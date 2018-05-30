terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-rjr"
    key            = "prod/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "git::git@github.com:oriain/terraform-modules.git//services/webserver-cluster?ref=v0.0.1"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true
}
