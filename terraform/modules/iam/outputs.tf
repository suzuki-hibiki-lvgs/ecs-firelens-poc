# =============================================================================
# IAM Module Outputs
# =============================================================================

# -----------------------------------------------------------------------------
# Firehose Role
# -----------------------------------------------------------------------------
output "firehose_role_arn" {
  description = "Firehose用IAMロールのARN"
  value       = aws_iam_role.firehose.arn
}

output "firehose_role_name" {
  description = "Firehose用IAMロールの名前"
  value       = aws_iam_role.firehose.name
}

# -----------------------------------------------------------------------------
# ECS Task Execution Role
# -----------------------------------------------------------------------------
output "ecs_task_execution_role_arn" {
  description = "ECSタスク実行ロールのARN"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_execution_role_name" {
  description = "ECSタスク実行ロールの名前"
  value       = aws_iam_role.ecs_task_execution.name
}

# -----------------------------------------------------------------------------
# ECS Task Role
# -----------------------------------------------------------------------------
output "ecs_task_role_arn" {
  description = "ECSタスクロールのARN"
  value       = aws_iam_role.ecs_task.arn
}

output "ecs_task_role_name" {
  description = "ECSタスクロールの名前"
  value       = aws_iam_role.ecs_task.name
}
