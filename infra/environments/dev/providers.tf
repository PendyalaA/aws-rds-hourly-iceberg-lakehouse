terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "aws-rds-hourly-iceberg-tfstate-626963114819-af-south-1"
    key          = "dev/terraform.tfstate"
    region       = "af-south-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}