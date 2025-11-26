# =============================================================================
# Application Infrastructure
# =============================================================================
# ECS Cluster/Service/Task Definition + IAMロールを統合したアプリ基盤

module "app" {
  source = "../../modules/app"

  project        = var.project
  environment    = var.environment
  aws_region     = var.aws_region
  aws_account_id = data.aws_caller_identity.current.account_id

  # ネットワーク設定（既存のlt-development VPCを使用）
  vpc_id     = data.aws_vpc.main.id
  subnet_ids = data.aws_subnets.private.ids

  # コンテナイメージ
  sample_app_image = "${module.ecr_sample_app.repository_url}:latest"
  fluent_bit_image = "${module.ecr_fluent_bit.repository_url}:latest"

  # タスク設定（dev環境は最小構成）
  task_cpu      = 256
  task_memory   = 512
  desired_count = 1

  # アプリケーション設定
  log_interval_ms = 5000

  # Fluent Bit / ログ連携設定（loggingモジュールから取得）
  firehose_delivery_stream_arn    = module.logging.delivery_stream_arn
  firehose_delivery_stream_name   = module.logging.delivery_stream_name
  newrelic_license_key_secret_arn = aws_secretsmanager_secret.newrelic_license_key.arn

  # モニタリング設定
  enable_container_insights = true
  log_retention_days        = 7

  tags = local.tags
}
