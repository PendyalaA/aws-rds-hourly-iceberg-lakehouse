variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "af-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-rds-hourly-iceberg-lakehouse"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "terraform_state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
  default     = "aws-rds-hourly-iceberg-tfstate-626963114819-af-south-1"
}

variable "github_owner" {
  description = "GitHub owner or organization"
  type        = string
  default     = "PendyalaA"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "aws-rds-hourly-iceberg-lakehouse"
}