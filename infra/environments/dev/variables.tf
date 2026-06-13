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