terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-rjr"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "mysql" {
  source = "git::git@github.com:oriain/terraform-modules.git//data-stores/mysql?ref=v0.0.1"

  db_name     = "example_database_stage"
  db_username = "admin"
  db_password = "${var.db_password}"
}
