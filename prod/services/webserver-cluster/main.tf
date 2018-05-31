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
  region = "${var.aws_region}"
}

module "webserver_cluster" {
  source = "git::git@github.com:oriain/terraform-modules.git//services/webserver-cluster"

  ami         = "${data.aws_ami.ubuntu.id}"
  server_text = "Hello, World"

  aws_region             = "${var.aws_region}"
  cluster_name           = "${var.cluster_name}"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  # cluster_name           = "webservers-prod"
  # db_remote_state_bucket = "terraform-up-and-running"
  # db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
