# =============================================================================
# Security Group for ECS Tasks
# =============================================================================

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project}-${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  # Egress: 全てのアウトバウンド通信を許可
  # - ECRからのイメージプル
  # - New Relic APIへのログ送信
  # - Firehoseへのログ送信
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-ecs-tasks-sg"
    }
  )
}
