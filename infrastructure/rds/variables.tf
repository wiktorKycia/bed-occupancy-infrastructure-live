variable "backup_retention_period" {
  description = "Specifies the number of days that automated backups of the resource should be retained."
  type        = number
  default     = 1
}
variable "skip_final_snapshot" {
  description = "Indicates that when the resource is deleted, Terraform should skip creating a final snapshot of the resource."
  type        = bool
  default     = true
}
variable "deletion_protection" {
  description = "When set to false, the resource can be deleted without additional safeguards."
  type        = bool
  default     = false
}
variable "performance_insights" {
  description = "When set to true, AWS collects and displays performance metrics for the database"
  type        = bool
  default     = true
}
variable "performance_insights_retention_period" {
  description = "Specifies the number of days to retain Performance Insights data."
  type        = number
  default     = 7
}