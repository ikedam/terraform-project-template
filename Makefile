ENV ?= dev
# tflint は GitHub API の Ratelimit の問題があるため、CI で使いづらい。
# .tflint.d ディレクトリーをキャッシュすることで回避可能だが、
# Ratelimit に引っかかる場合はここを false にして、必要なときだけ実行するようにする。
# See: https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/plugins.md#avoiding-rate-limiting
ENABLE_TFLINT ?= true

.PHONY: help
help:	## Show target helps
	@echo "set ENV variable and call targets:"
	@echo
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init:	## run terraform init
	docker compose run --rm terraform -chdir="env/$(ENV)" init
ifeq ($(ENABLE_TFLINT),true)
	docker compose run --rm tflint --init
endif

.PHONY: lint
lint:	## lint terraform files
	docker compose run --rm terraform -chdir="env/$(ENV)" validate
ifeq ($(ENABLE_TFLINT),true)
	docker compose run --rm tflint --recursive
endif
	docker compose run --rm terraform fmt -recursive -check -diff .

.PHONY: format
format:	## format terraform files
	docker compose run --rm terraform fmt -recursive .

.PHONY: lock
lock:	## create/update .terraform.lock.hcl files for all environments
	$(MAKE) lock-dev
	$(MAKE) lock-stg
	$(MAKE) lock-prd

.PHONY: lock-%
lock-%:
	$(eval env := ${@:lock-%=%})
	docker compose run --rm terraform -chdir="env/$(env)" init -backend=false
	docker compose run --rm terraform -chdir="env/$(env)" providers lock -platform=linux_amd64 -platform=linux_arm64 -enable-plugin-cache

.PHONY: plan
plan:	## run terraform plan
	docker compose run --rm terraform -chdir="env/$(ENV)" plan

.PHONY: apply
apply:	## run terraform apply
	docker compose run --rm terraform -chdir="env/$(ENV)" apply

.PHONY: output-%
output-%:	## run terraform output. Don't need `main.` prefix.
	@$(eval output := ${@:output-%=%})
	@docker compose run --rm terraform -chdir="env/$(ENV)" output -json main \
		| docker compose run --rm jq -r .main.$(output)

# .PHONY: destroy
# destroy:	## run terraform destroy
# 	docker compose run --rm terraform -chdir="env/$(ENV)" destroy
