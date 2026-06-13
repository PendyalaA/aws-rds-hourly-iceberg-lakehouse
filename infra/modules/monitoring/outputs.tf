output "pipeline_alert_topic_arn" {
  value = aws_sns_topic.pipeline_alerts.arn
}

output "pipeline_alert_topic_name" {
  value = aws_sns_topic.pipeline_alerts.name
}

output "cloudwatch_log_group_names" {
  value = {
    for key, log_group in aws_cloudwatch_log_group.pipeline_logs :
    key => log_group.name
  }
}