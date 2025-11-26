# =============================================================================
# CloudWatch Log Groups for ECS
# =============================================================================

# アプリケーションログ用（FireLensがawslogsにフォールバックする場合に使用）
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project}-${var.environment}/app"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# FireLens (Fluent Bit) 自身のログ用
resource "aws_cloudwatch_log_group" "firelens" {
  name              = "/ecs/${var.project}-${var.environment}/firelens"
  retention_in_days = var.log_retention_days

  tags = var.tags
}
