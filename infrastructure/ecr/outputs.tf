output "repository_names" {
  description = "Names of all repositories"
  value       = { for key, mod in module.ecr : key => mod.repository_name }
}

output "repository_arns" {
  description = "ARNs of all repositories"
  value       = { for key, mod in module.ecr : key => mod.repository_arn }
}

output "repository_registry_ids" {
  description = "Registry IDs of all repositories where repositories were created"
  value       = { for key, mod in module.ecr : key => mod.repository_registry_id }
}

output "repository_urls" {
  description = "URLs of all repositories (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`)"
  value       = { for key, mod in module.ecr : key => mod.repository_url }
}