# =============================================================================
# Firehose Module Outputs
# =============================================================================

output "delivery_stream_arn" {
  description = "Firehose Delivery StreamのARN"
  value       = aws_kinesis_firehose_delivery_stream.logs.arn
}

output "delivery_stream_name" {
  description = "Firehose Delivery Streamの名前"
  value       = aws_kinesis_firehose_delivery_stream.logs.name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Log Groupの名前（有効な場合）"
  value       = var.enable_cloudwatch_logging ? aws_cloudwatch_log_group.firehose[0].name : null
}
