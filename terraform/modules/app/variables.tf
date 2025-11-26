# =============================================================================
# App Module Variables
# =============================================================================
# ECS Cluster/Service/Task Definition + IAMロールを統合したモジュールの入力変数

# -----------------------------------------------------------------------------
# 基本設定
# -----------------------------------------------------------------------------
variable "project" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名（dev, staging, prod など）"
  type        = string
}

variable "aws_region" {
  description = "AWSリージョン"
  type        = string
}

variable "aws_account_id" {
  description = "AWSアカウントID"
  type        = string
}

# -----------------------------------------------------------------------------
# ネットワーク設定
# -----------------------------------------------------------------------------
variable "vpc_id" {
  description = "ECSタスクを配置するVPCのID"
  type        = string
}

variable "subnet_ids" {
  description = "ECSタスクを配置するサブネットIDのリスト"
  type        = list(string)
}

# -----------------------------------------------------------------------------
# コンテナイメージ
# -----------------------------------------------------------------------------
variable "sample_app_image" {
  description = "sample-appコンテナイメージのURI"
  type        = string
}

variable "fluent_bit_image" {
  description = "fluent-bitコンテナイメージのURI"
  type        = string
}

# -----------------------------------------------------------------------------
# タスク設定
# -----------------------------------------------------------------------------
variable "task_cpu" {
  description = "タスクに割り当てるCPUユニット（256, 512, 1024, 2048, 4096）"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "タスクに割り当てるメモリ（MB）"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "起動するタスク数"
  type        = number
  default     = 1
}

# -----------------------------------------------------------------------------
# アプリケーション設定
# -----------------------------------------------------------------------------
variable "log_interval_ms" {
  description = "sample-appのログ出力間隔（ミリ秒）"
  type        = number
  default     = 5000
}

# -----------------------------------------------------------------------------
# Fluent Bit / ログ連携設定
# -----------------------------------------------------------------------------
variable "firehose_delivery_stream_arn" {
  description = "Kinesis Firehose Delivery StreamのARN（Task Roleに権限付与用）"
  type        = string
}

variable "firehose_delivery_stream_name" {
  description = "Kinesis Firehose Delivery Stream名（Fluent Bit設定用）"
  type        = string
}

variable "newrelic_license_key_secret_arn" {
  description = "New Relic License KeyのSecrets Manager ARN"
  type        = string
}

# -----------------------------------------------------------------------------
# モニタリング設定
# -----------------------------------------------------------------------------
variable "enable_container_insights" {
  description = "Container Insightsを有効にするかどうか"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch Logsの保持期間（日）"
  type        = number
  default     = 7
}

# -----------------------------------------------------------------------------
# タグ
# -----------------------------------------------------------------------------
variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
