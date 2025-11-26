# =============================================================================
# Dev Environment Outputs
# =============================================================================

output "s3_bucket_name" {
  description = "ログ保存用S3バケットの名前"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "ログ保存用S3バケットのARN"
  value       = module.s3.bucket_arn
}

output "firehose_delivery_stream_name" {
  description = "Firehose Delivery Streamの名前"
  value       = module.firehose.delivery_stream_name
}

output "firehose_delivery_stream_arn" {
  description = "Firehose Delivery StreamのARN"
  value       = module.firehose.delivery_stream_arn
}

output "firehose_role_arn" {
  description = "Firehose用IAMロールのARN"
  value       = module.iam.firehose_role_arn
}
