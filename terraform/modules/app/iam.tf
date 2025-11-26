# =============================================================================
# IAM Roles for ECS Tasks
# =============================================================================
# Task Execution Role: ECRプル、CloudWatch Logs書き込み、Secrets Manager読み取り
# Task Role: コンテナ（Fluent Bit）からFirehoseへの書き込み

# -----------------------------------------------------------------------------
# ECS Task Execution Role
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project}-${var.environment}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-ecs-task-execution-role"
    }
  )
}

# AWSマネージドポリシーをアタッチ（ECRプル、CloudWatch Logs書き込み）
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Secrets Manager読み取り権限
data "aws_iam_policy_document" "ecs_task_execution_secrets" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.project}-${var.environment}-*"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_secrets" {
  name   = "${var.project}-${var.environment}-ecs-task-execution-secrets-policy"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_task_execution_secrets.json
}

# -----------------------------------------------------------------------------
# ECS Task Role
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.project}-${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-ecs-task-role"
    }
  )
}

# Firehose書き込み権限（Fluent Bitがログを送信するため）
data "aws_iam_policy_document" "ecs_task_firehose" {
  statement {
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [
      var.firehose_delivery_stream_arn
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_firehose" {
  name   = "${var.project}-${var.environment}-ecs-task-firehose-policy"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_task_firehose.json
}
