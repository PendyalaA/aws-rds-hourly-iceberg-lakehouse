# Runbook

## Purpose

This runbook explains how to operate and troubleshoot the AWS RDS Hourly Iceberg Lakehouse pipeline.

## Main Pipeline

EventBridge Scheduler starts the Step Functions state machine hourly.

Step Functions controls:

1. Lambda incremental extraction
2. Glue Iceberg processing
3. Watermark update
4. Audit logging

## Where to Check Failures

| Failure Area | Where to Check |
|---|---|
| Schedule did not run | EventBridge Scheduler |
| Workflow failed | Step Functions execution history |
| Lambda failed | CloudWatch Lambda log group |
| Glue failed | CloudWatch Glue logs |
| Data quality failed | S3 rejected zone |
| Watermark issue | DynamoDB watermark table |
| Pipeline audit | DynamoDB audit table |
| Alerting issue | SNS topic and subscriptions |

## Important Rule

Do not manually update the watermark unless the Iceberg table is confirmed to have the matching data.