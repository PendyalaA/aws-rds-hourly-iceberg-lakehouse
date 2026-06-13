resource "aws_dynamodb_table" "watermark" {
  name         = "${var.project_name}-${var.environment}-pipeline-watermark"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "table_name"

  attribute {
    name = "table_name"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-pipeline-watermark"
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "last-successful-watermark"
  }
}

resource "aws_dynamodb_table" "pipeline_audit" {
  name         = "${var.project_name}-${var.environment}-pipeline-audit"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "run_id"
  range_key    = "stage_name"

  attribute {
    name = "run_id"
    type = "S"
  }

  attribute {
    name = "stage_name"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-pipeline-audit"
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "pipeline-run-audit"
  }
}