terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "bed-occupancy-terraform-remote-state"
    key    = "bed-occupancy/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
}

# local variables
locals {

  region = data.terraform_remote_state.infrastructure.outputs.region
  name = data.terraform_remote_state.infrastructure.outputs.name


  docker_images = [
    "frontend",
    "backend",
    "faker",
    "db"
  ]

  tags = data.terraform_remote_state.infrastructure.outputs.tags

}

# automatic arn and account data detection
data "aws_caller_identity" "current" {}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  for_each = toset(local.docker_images)

  repository_name = "${local.name}-${each.key}"

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "any",
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_image_tag_mutability = var.repository_image_tag_mutability

  repository_force_delete = var.repository_force_delete

  tags = merge(local.tags, {
    Terraform   = "true"
    Environment = "dev"
    ServiceName = each.key
  })
}
