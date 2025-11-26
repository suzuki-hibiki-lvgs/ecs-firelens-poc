# =============================================================================
# Firehose Module Variables
# =============================================================================

variable "delivery_stream_name" {
  description = "Firehose Delivery Streamの名前"
  type        = string
}

variable "firehose_role_arn" {
  description = "Firehose用IAMロールのARN"
  type        = string
}

variable "s3_bucket_arn" {
  description = "配信先S3バケットのARN"
  type        = string
}

variable "buffering_size_mb" {
  description = "バッファサイズ（MB単位、1-128）。大きいほどファイル数削減、小さいほど低レイテンシ"
  type        = number
  default     = 5

  validation {
    condition     = var.buffering_size_mb >= 1 && var.buffering_size_mb <= 128
    error_message = "buffering_size_mb は 1 から 128 の範囲で指定してください"
  }
}

variable "buffering_interval_sec" {
  description = "バッファリング時間（秒単位、60-900）。大きいほどファイル数削減、小さいほど低レイテンシ"
  type        = number
  default     = 300

  validation {
    condition     = var.buffering_interval_sec >= 60 && var.buffering_interval_sec <= 900
    error_message = "buffering_interval_sec は 60 から 900 の範囲で指定してください"
  }
}

variable "enable_cloudwatch_logging" {
  description = "CloudWatch Logsへのエラーログ出力を有効にするかどうか"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch Logsの保持期間（日数）"
  type        = number
  default     = 14
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
