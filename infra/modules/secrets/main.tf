locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "random_password" "db_master_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${local.name_prefix}/rds/postgres/credentials"
  description = "RDS PostgreSQL credentials for ${local.name_prefix}"
  kms_key_id  = var.kms_key_arn

  tags = {
    Name        = "${local.name_prefix}-rds-postgres-credentials"
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "rds-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_initial" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_master_password.result
    database = var.db_name
    port     = var.db_port
  })
}