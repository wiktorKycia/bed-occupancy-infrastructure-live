locals {
  region = "eu-central-1"
  name   = "bed-occupancy"

  tags = {
    Name       = local.name
    Repository = "https://github.com/wiktorKycia/bed-occupancy-infrastructure-live/tree/basic-config-and-ecr"
  }
}