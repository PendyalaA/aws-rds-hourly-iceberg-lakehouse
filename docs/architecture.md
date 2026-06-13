# Architecture Notes

## Services

| Area | AWS Service |
|---|---|
| Source database | Amazon RDS PostgreSQL |
| Incremental extraction | AWS Lambda |
| Raw storage | Amazon S3 |
| Lakehouse format | Apache Iceberg |
| Processing | AWS Glue PySpark |
| Catalog | AWS Glue Data Catalog |
| Governance | AWS Lake Formation |
| Query | Amazon Athena |
| Orchestration | AWS Step Functions |
| Scheduling | Amazon EventBridge Scheduler |
| Watermark | Amazon DynamoDB |
| Audit | Amazon DynamoDB |
| Secrets | AWS Secrets Manager |
| Encryption | AWS KMS |
| Logs | Amazon CloudWatch |
| Alerts | Amazon SNS |
| Deployment | GitHub Actions + Terraform |

## Data Flow

1. EventBridge triggers Step Functions every hour.
2. Step Functions starts Lambda extractor.
3. Lambda reads last successful watermark from DynamoDB.
4. Lambda extracts changed rows from RDS using updated_at.
5. Lambda writes raw incremental files to S3.
6. Glue validates the raw batch.
7. Glue writes rejected records to S3 rejected zone.
8. Glue MERGE operations update Iceberg tables.
9. Watermark is updated only after successful Iceberg processing.
10. Audit table records the run status.
11. SNS sends failure alerts if any stage fails.

## Failure Visibility

Every pipeline run must capture:

- run_id
- table_name
- stage_name
- status
- records_read
- records_written
- records_rejected
- error_message
- cloudwatch_log_group
- cloudwatch_log_stream
- started_at
- completed_at