locals {
  name_prefix = "${var.project_name}-${var.environment}"

  log_groups = {
    lambda_extractor = "/aws/lambda/${local.name_prefix}-extract-rds-to-s3"
    glue_iceberg     = "/aws-glue/jobs/${local.name_prefix}-iceberg-merge"
    stepfunctions    = "/aws/vendedlogs/states/${local.name_prefix}-orchestration"
  }
}

resource "aws_cloudwatch_log_group" "pipeline_logs" {
  for_each = local.log_groups

  name              = each.value
  retention_in_days = var.log_retention_days

  tags = {
    Name        = each.value
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "pipeline-observability"
  }
}

resource "aws_sns_topic" "pipeline_alerts" {
  name = "${local.name_prefix}-pipeline-alerts"

  tags = {
    Name        = "${local.name_prefix}-pipeline-alerts"
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "pipeline-alerting"
  }
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.pipeline_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}