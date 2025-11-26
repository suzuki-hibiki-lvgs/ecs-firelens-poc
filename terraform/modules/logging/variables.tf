# =============================================================================
# Logging Module Variables
# =============================================================================
# S3バケット + Kinesis Data Firehose + IAMロールを統合したモジュールの入力変数

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
# S3設定
# -----------------------------------------------------------------------------
variable "bucket_name" {
  description = "ログ保存用S3バケット名"
  type        = string
}

variable "enable_versioning" {
  description = "S3バージョニングを有効にするかどうか"
  type        = bool
  default     = false
}

variable "transition_to_glacier_days" {
  description = "Glacier Instant Retrievalへ移行するまでの日数"
  type        = number
  default     = 30
}

variable "transition_to_deep_archive_days" {
  description = "Deep Archiveへ移行するまでの日数"
  type        = number
  default     = 120
}

variable "expiration_days" {
  description = "オブジェクトを削除するまでの日数"
  type        = number
  default     = 365
}

# -----------------------------------------------------------------------------
# Firehose設定
# -----------------------------------------------------------------------------
variable "delivery_stream_name" {
  description = "Kinesis Firehose Delivery Stream名"
  type        = string
}

variable "buffering_size_mb" {
  description = "バッファリングサイズ（MB）。1-128の範囲"
  type        = number
  default     = 5
}

variable "buffering_interval_sec" {
  description = "バッファリング間隔（秒）。60-900の範囲"
  type        = number
  default     = 300
}

# -----------------------------------------------------------------------------
# CloudWatch Logs設定
# -----------------------------------------------------------------------------
variable "enable_cloudwatch_logging" {
  description = "Firehoseエラーログ用CloudWatch Logsを有効にするかどうか"
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
