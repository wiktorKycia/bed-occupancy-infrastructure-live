output "vpc_id" {
  value       = module.aws_vpc.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = module.aws_vpc.public_subnets
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = module.aws_vpc.private_subnets
  description = "The IDs of the private subnets"
}

output "database_subnet_ids" {
  value       = module.aws_vpc.database_subnets
  description = "The IDs of the database subnets"
}

output "route_table_ids" {
  value       = module.aws_vpc.private_route_table_ids
  description = "The IDs of the private route tables"
}

output "vpc_cidr_block" {
  value       = module.aws_vpc.vpc_cidr_block
  description = "The CIDR block of the VPC"
}

output "database_subnet_group" {

  value       = module.aws_vpc.database_subnet_group
  description = "ID of database subnet group"
}

output "database_subnet_group_name" {
  value       = module.aws_vpc.database_subnet_group_name
  description = "Name of database subnet group"
}