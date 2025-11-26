# =============================================================================
# IAM Module Variables
# =============================================================================

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

variable "s3_bucket_arn" {
  description = "ログ保存先S3バケットのARN"
  type        = string
}

variable "firehose_delivery_stream_arn" {
  description = "Firehose Delivery StreamのARN（ECSタスクロールに必要）"
  type        = string
  default     = ""
}

variable "enable_cloudwatch_logging" {
  description = "CloudWatch Logsへのログ出力を有効にするかどうか"
  type        = bool
  default     = true
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
