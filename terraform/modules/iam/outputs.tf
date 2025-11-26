# =============================================================================
# IAM Module Outputs
# =============================================================================

output "firehose_role_arn" {
  description = "Firehose用IAMロールのARN"
  value       = aws_iam_role.firehose.arn
}

output "firehose_role_name" {
  description = "Firehose用IAMロールの名前"
  value       = aws_iam_role.firehose.name
}
