# =============================================================================
# ECS Module Variables
# =============================================================================

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
# IAMロール
# -----------------------------------------------------------------------------
variable "ecs_task_execution_role_arn" {
  description = "ECSタスク実行ロールのARN（ECRプル、CloudWatch Logs書き込み用）"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECSタスクロールのARN（Firehose PutRecord用）"
  type        = string
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
# Fluent Bit設定
# -----------------------------------------------------------------------------
variable "firehose_delivery_stream_name" {
  description = "Kinesis Firehose Delivery Stream名"
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
