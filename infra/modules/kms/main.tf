resource "aws_kms_key" "data_lake" {
  description             = "KMS key for ${var.project_name} ${var.environment} data lake encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-data-lake-kms"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_kms_alias" "data_lake" {
  name          = "alias/${var.project_name}-${var.environment}-data-lake"
  target_key_id = aws_kms_key.data_lake.key_id
}