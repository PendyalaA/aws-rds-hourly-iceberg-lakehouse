variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used for S3 encryption"
  type        = string
}

variable "force_destroy" {
  description = "Allow Terraform to delete bucket contents during destroy. Use true only for dev."
  type        = bool
  default     = false
}