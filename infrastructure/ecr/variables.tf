variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "MUTABLE"
}
variable "repository_force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = true
}