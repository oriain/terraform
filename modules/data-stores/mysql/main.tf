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

resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "${var.db_name}"
  username            = "${var.db_username}"
  password            = "${var.db_password}"
  skip_final_snapshot = true
}
