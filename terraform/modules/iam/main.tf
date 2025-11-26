# =============================================================================
# IAM Roles for ECS FireLens PoC
# =============================================================================
# Firehose、ECS Task Execution、ECS Task用のIAMロールとポリシー

# -----------------------------------------------------------------------------
# Firehose用のAssumeRoleポリシー
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# -----------------------------------------------------------------------------
# Firehose用のIAMロール
# -----------------------------------------------------------------------------
resource "aws_iam_role" "firehose" {
  name               = "${var.project}-${var.environment}-firehose-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-firehose-role"
    }
  )
}

# -----------------------------------------------------------------------------
# S3への書き込み権限ポリシー
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "firehose_s3" {
  # S3バケットへのオブジェクト書き込み権限
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_s3" {
  name   = "${var.project}-${var.environment}-firehose-s3-policy"
  role   = aws_iam_role.firehose.id
  policy = data.aws_iam_policy_document.firehose_s3.json
}

# -----------------------------------------------------------------------------
# CloudWatch Logs への書き込み権限ポリシー（オプション）
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "firehose_cloudwatch" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/kinesisfirehose/${var.project}-${var.environment}*:*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_cloudwatch" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  name   = "${var.project}-${var.environment}-firehose-cloudwatch-policy"
  role   = aws_iam_role.firehose.id
  policy = data.aws_iam_policy_document.firehose_cloudwatch[0].json
}

# =============================================================================
# ECS Task Execution Role
# =============================================================================
# ECSエージェントがECRからイメージをプル、CloudWatch Logsへログ出力するための権限

# -----------------------------------------------------------------------------
# ECS Task Execution Role - AssumeRoleポリシー
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

# -----------------------------------------------------------------------------
# ECS Task Execution Role
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# ECS Task Execution Role - AWSマネージドポリシーをアタッチ
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -----------------------------------------------------------------------------
# ECS Task Execution Role - Secrets Manager読み取り権限
# -----------------------------------------------------------------------------
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

# =============================================================================
# ECS Task Role
# =============================================================================
# コンテナ（Fluent Bit）がFirehoseへログを送信するための権限

# -----------------------------------------------------------------------------
# ECS Task Role - AssumeRoleポリシー
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

# -----------------------------------------------------------------------------
# ECS Task Role
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# ECS Task Role - Firehose書き込み権限
# -----------------------------------------------------------------------------
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
