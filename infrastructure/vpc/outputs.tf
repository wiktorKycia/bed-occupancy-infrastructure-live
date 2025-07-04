output "database_subnet_group" {
  description = "The name of the database subnet group"
  value       = module.aws_vpc.database_subnet_group
}