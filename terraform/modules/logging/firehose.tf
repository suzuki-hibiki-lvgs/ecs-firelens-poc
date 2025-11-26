# =============================================================================
# Kinesis Data Firehose Delivery Stream
# =============================================================================
# Fluent Bitからのログを受け取り、S3にGZIP圧縮して配信するストリーム
# Athenaでの効率的なクエリのため、日付ベースのパーティショニングを使用

resource "aws_kinesis_firehose_delivery_stream" "logs" {
  name        = var.delivery_stream_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.logs.arn

    # バッファリング設定
    # Trade-off: 小さいバッファ=低レイテンシだがファイル数増加、大きいバッファ=高レイテンシだがファイル数削減
    buffering_size     = var.buffering_size_mb
    buffering_interval = var.buffering_interval_sec

    # GZIP圧縮（S3ストレージコスト削減、Athenaクエリ効率向上）
    compression_format = "GZIP"

    # S3プレフィックス設定（Athenaパーティショニング対応）
    # 形式: logs/year=YYYY/month=MM/day=DD/hour=HH/
    prefix              = "logs/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"

    # CloudWatch Logsへのエラーログ出力（オプション）
    dynamic "cloudwatch_logging_options" {
      for_each = var.enable_cloudwatch_logging ? [1] : []
      content {
        enabled         = true
        log_group_name  = aws_cloudwatch_log_group.firehose[0].name
        log_stream_name = aws_cloudwatch_log_stream.firehose[0].name
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.delivery_stream_name
    }
  )
}

# -----------------------------------------------------------------------------
# CloudWatch Log Group for Firehose errors（オプション）
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "firehose" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  name              = "/aws/kinesisfirehose/${var.delivery_stream_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name = "/aws/kinesisfirehose/${var.delivery_stream_name}"
    }
  )
}

resource "aws_cloudwatch_log_stream" "firehose" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  name           = "S3Delivery"
  log_group_name = aws_cloudwatch_log_group.firehose[0].name
}
