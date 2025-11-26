# =============================================================================
# Logging Infrastructure
# =============================================================================
# S3 + Kinesis Data Firehose + IAMロールを統合したログ基盤

module "logging" {
  source = "../../modules/logging"

  project        = var.project
  environment    = var.environment
  aws_region     = var.aws_region
  aws_account_id = data.aws_caller_identity.current.account_id

  # S3設定
  bucket_name = "${var.project}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"

  # ライフサイクル設定（dev環境は短めに設定してコスト削減）
  # NOTE: DEEP_ARCHIVEはGLACIER_IRより90日以上後である必要がある
  enable_versioning               = false
  transition_to_glacier_days      = 30
  transition_to_deep_archive_days = 120
  expiration_days                 = 180

  # Firehose設定
  delivery_stream_name = "${var.project}-${var.environment}-stream"

  # バッファリング設定（dev環境は低レイテンシ優先）
  buffering_size_mb      = 1
  buffering_interval_sec = 60

  # CloudWatch Logs設定
  enable_cloudwatch_logging = true
  log_retention_days        = 7

  tags = local.tags
}
