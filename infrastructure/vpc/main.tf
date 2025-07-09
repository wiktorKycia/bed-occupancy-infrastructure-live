terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "bed-occupancy-terraform-remote-state"
    key    = "bed-occupancy/terraform.tfstate"
    region = "eu-central-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
}


# automatic arn and account data detection
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "terraform_remote_state" "infrastructure" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

# local variables
locals {
  region = data.terraform_remote_state.infrastructure.outputs.region
  name = data.terraform_remote_state.infrastructure.outputs.name

  vpc_cidr = "10.0.0.0/16"

  azs = [for az in data.aws_availability_zones.available.names : az]

  docker_images = [
    "frontend",
    "backend",
    "faker",
    "db"
  ]

  tags = data.terraform_remote_state.infrastructure.outputs.tags
}


module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
  public_subnets   = var.public_subnets

  private_subnet_names  = var.private_subnet_names
  database_subnet_names = var.database_subnet_names
  public_subnet_names   = var.public_subnet_names

  create_database_subnet_group = true

  enable_nat_gateway = var.enable_nat_gateway

  tags = local.tags
}