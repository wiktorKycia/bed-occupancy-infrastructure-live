variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "database_subnets" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

variable "private_subnet_names" {
  description = "Names for private subnets"
  type        = list(string)
  default     = ["backend", "frontend"]
}

variable "database_subnet_names" {
  description = "Names for database subnets"
  type        = list(string)
  default     = ["db"]
}

variable "public_subnet_names" {
  description = "Names for public subnets"
  type        = list(string)
  default     = ["load balancer"]
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT gateway"
  type        = bool
  default     = true
}