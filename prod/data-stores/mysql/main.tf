terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-rjr"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "mysql" {
  source = "git::git@github.com:oriain/terraform-modules.git//data-stores/mysql"

  db_name     = "example_database_prod"
  db_username = "admin"
  db_password = "${var.db_password}"
}
