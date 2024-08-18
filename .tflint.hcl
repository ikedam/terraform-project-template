# https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md
tflint {
  required_version = ">= 0.50"
}

# https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md
plugin "terraform" {
    enabled = true
    preset  = "recommended"
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

# ルートモジュールにも構成を強制してしまうので採用しない
# rule "terraform_standard_module_structure" {
#   enabled = true
# }

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_module_version" {
  enabled = true
  # モジュールのバージョンは固定で指定する。
  exact = true
}

# https://github.com/terraform-linters/tflint-ruleset-aws
plugin "aws" {
    enabled = true
    version = "0.32.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
