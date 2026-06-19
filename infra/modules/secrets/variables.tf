variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting the secret"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "retail_admin"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "retaildb"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}