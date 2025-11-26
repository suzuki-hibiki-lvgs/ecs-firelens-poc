# =============================================================================
# IAM Roles for Kinesis Data Firehose
# =============================================================================
# Firehose がS3にログを書き込むために必要なIAMロールとポリシー

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
