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

# local variables
locals {
  region = "eu-central-1"
  name   = "bed-occupancy"

  vpc_cidr = "10.0.0.0/16"

  azs = [for az in data.aws_availability_zones.available.names : az]

  docker_images = [
    "frontend",
    "backend",
    "faker",
    "db"
  ]

  tags = {
    Name       = local.name
    Repository = "https://github.com/wiktorKycia/bed-occupancy-infrastructure-live/tree/basic-config-and-ecr"
  }
}


module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24"]

  private_subnet_names  = ["backend", "frontend"]
  database_subnet_names = ["db"]
  public_subnet_names   = ["load balancer"]

  create_database_subnet_group = true

  enable_nat_gateway = true

  tags = local.tags
}