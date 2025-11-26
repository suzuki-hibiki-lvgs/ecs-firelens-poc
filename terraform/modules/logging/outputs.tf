# =============================================================================
# Logging Module Outputs
# =============================================================================

# -----------------------------------------------------------------------------
# S3 Bucket
# -----------------------------------------------------------------------------
output "bucket_id" {
  description = "S3バケットのID"
  value       = aws_s3_bucket.logs.id
}

output "bucket_arn" {
  description = "S3バケットのARN"
  value       = aws_s3_bucket.logs.arn
}

output "bucket_name" {
  description = "S3バケット名"
  value       = aws_s3_bucket.logs.bucket
}

# -----------------------------------------------------------------------------
# Firehose Delivery Stream
# -----------------------------------------------------------------------------
output "delivery_stream_arn" {
  description = "Firehose Delivery StreamのARN"
  value       = aws_kinesis_firehose_delivery_stream.logs.arn
}

output "delivery_stream_name" {
  description = "Firehose Delivery Stream名"
  value       = aws_kinesis_firehose_delivery_stream.logs.name
}

# -----------------------------------------------------------------------------
# IAM Role (参照用)
# -----------------------------------------------------------------------------
output "firehose_role_arn" {
  description = "Firehose用IAMロールのARN"
  value       = aws_iam_role.firehose.arn
}
