terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.0"
    }
  }

  backend "s3" {
    # FIXME: バックエンド用に作成したS3バケットとDynamoDBテーブルを指定してください。
    # bucket         = "ACCOUNTID-tfstate-prd"
    key            = "rootmodule.tfstate"
    region         = "ap-northeast-1"
    # dynamodb_table = "tfstate-lock"
  }
}

provider "aws" {
  # FIXME: ここで「使用されるはずのアカウントID」を指定する。
  # allowed_account_ids = [ACCOUNTID]
  region              = "ap-northeast-1"
}

module "main" {
  source = "../.."

  basename = "terraform-rootmodule"
  env      = "prd"

  providers = {
    aws = aws
  }
}

output "main" {
  value = module.main
}
