terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92.0"
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

# local variables
locals {
  region = "eu-central-1"
  name   = "bed-occupancy"

  azs = [for az in data.aws_availability_zones.available.names : az]

  account_id       = data.aws_caller_identity.current.account_id
  current_identity = data.aws_caller_identity.current.arn

  tags = {
    Name       = local.name
    Repository = "https://github.com/wiktorKycia/bed-occupancy-infrastructure-live/tree/basic-config-and-ecr"
  }
}