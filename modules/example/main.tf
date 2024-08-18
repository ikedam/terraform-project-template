terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.0"
    }
  }
}

resource "aws_dynamodb_table" "table" {
  name         = "${var.basename}-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}
