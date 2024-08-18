terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.0"
    }
  }
}

module "example" {
  source = "./modules/example"

  env      = var.env
  basename = var.basename

  providers = {
    aws = aws
  }
}

# main モジュールで直接リソースを定義しても良い。
# リソースが多くなる場合は別ファイル (*.tf) に分けるのが望ましい。
