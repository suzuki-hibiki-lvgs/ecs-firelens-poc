# =============================================================================
# ECS Module for FireLens PoC
# =============================================================================
# ECS Cluster, Task Definition (with FireLens sidecar), Service, Security Group

# -----------------------------------------------------------------------------
# ECS Cluster
# -----------------------------------------------------------------------------
resource "aws_ecs_cluster" "this" {
  name = "${var.project}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-cluster"
    }
  )
}

# -----------------------------------------------------------------------------
# CloudWatch Log Groups
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project}-${var.environment}/app"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "firelens" {
  name              = "/ecs/${var.project}-${var.environment}/firelens"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Security Group
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# ECS Task Definition
# -----------------------------------------------------------------------------
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    # Fluent Bit Sidecar (FireLens)
    # カスタムイメージを使用し、/extra.confでNew Relic + Firehose両方に出力
    # 重要: /fluent-bit/etc/fluent-bit.confはFireLensが予約しているため使用不可
    {
      name      = "fluent-bit"
      image     = var.fluent_bit_image
      essential = true
      firelensConfiguration = {
        type = "fluentbit"
        options = {
          config-file-type  = "file"
          config-file-value = "/extra.conf"
        }
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.firelens.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "firelens"
        }
      }
      # Fluent Bit設定で使用する環境変数
      environment = [
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "FIREHOSE_DELIVERY_STREAM"
          value = var.firehose_delivery_stream_name
        }
      ]
      # New Relic License KeyはSecrets Managerから取得
      secrets = [
        {
          name      = "NEW_RELIC_LICENSE_KEY"
          valueFrom = var.newrelic_license_key_secret_arn
        }
      ]
      memoryReservation = 50
    },
    # Application Container
    {
      name      = "sample-app"
      image     = var.sample_app_image
      essential = true
      # FireLens経由でログを送信（awsfirelensドライバー）
      # 実際のルーティングはFluent Bitの/extra.confで定義
      logConfiguration = {
        logDriver = "awsfirelens"
        options   = {}
      }
      environment = [
        {
          name  = "SERVICE_NAME"
          value = var.project
        },
        {
          name  = "ENVIRONMENT"
          value = var.environment
        },
        {
          name  = "LOG_INTERVAL_MS"
          value = tostring(var.log_interval_ms)
        }
      ]
      memoryReservation = 256
    }
  ])

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-task"
    }
  )
}

# -----------------------------------------------------------------------------
# ECS Service
# -----------------------------------------------------------------------------
resource "aws_ecs_service" "this" {
  name            = "${var.project}-${var.environment}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  # タスク定義変更時にサービスを強制的に新しいデプロイ
  force_new_deployment = true

  # サービスのライフサイクル設定
  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-service"
    }
  )
}
