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

  azs = [for az in data.aws_availability_zones.available.names : az]
  
  tags = data.terraform_remote_state.infrastructure.outputs.tags
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.name

  engine                   = "postgres"
  engine_version           = "14"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = "postgres14" # DB parameter group
  major_engine_version     = "14"         # DB option group
  instance_class           = "db.t4g.large"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = "postgres"
  username = "postgres"
  port     = 5432

  manage_master_user_password_rotation    = false
  master_user_password_rotate_immediately = false

  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = var.performance_insights
  performance_insights_retention_period = var.performance_insights_retention_period

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = local.tags
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  cloudwatch_log_group_tags = {
    "Sensitive" = "high"
  }
}

module "vpc" {
    source = "../vpc"
}