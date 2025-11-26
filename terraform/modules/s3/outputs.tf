# =============================================================================
# S3 Module Outputs
# =============================================================================

output "bucket_id" {
  description = "S3バケットのID"
  value       = aws_s3_bucket.logs.id
}

output "bucket_arn" {
  description = "S3バケットのARN"
  value       = aws_s3_bucket.logs.arn
}

output "bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = aws_s3_bucket.logs.bucket_domain_name
}
