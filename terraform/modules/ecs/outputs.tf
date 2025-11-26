# =============================================================================
# ECS Module Outputs
# =============================================================================

# -----------------------------------------------------------------------------
# Cluster
# -----------------------------------------------------------------------------
output "cluster_id" {
  description = "ECSクラスタのID"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "ECSクラスタのARN"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "ECSクラスタの名前"
  value       = aws_ecs_cluster.this.name
}

# -----------------------------------------------------------------------------
# Service
# -----------------------------------------------------------------------------
output "service_id" {
  description = "ECSサービスのID"
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "ECSサービスの名前"
  value       = aws_ecs_service.this.name
}

# -----------------------------------------------------------------------------
# Task Definition
# -----------------------------------------------------------------------------
output "task_definition_arn" {
  description = "タスク定義のARN"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "タスク定義のファミリー名"
  value       = aws_ecs_task_definition.this.family
}

# -----------------------------------------------------------------------------
# Security Group
# -----------------------------------------------------------------------------
output "security_group_id" {
  description = "ECSタスク用セキュリティグループのID"
  value       = aws_security_group.ecs_tasks.id
}

# -----------------------------------------------------------------------------
# CloudWatch Log Groups
# -----------------------------------------------------------------------------
output "app_log_group_name" {
  description = "アプリケーションログ用CloudWatch Log Groupの名前"
  value       = aws_cloudwatch_log_group.app.name
}

output "firelens_log_group_name" {
  description = "FireLensログ用CloudWatch Log Groupの名前"
  value       = aws_cloudwatch_log_group.firelens.name
}
