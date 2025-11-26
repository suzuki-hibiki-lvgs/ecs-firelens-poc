# =============================================================================
# S3 Module Variables
# =============================================================================

variable "bucket_name" {
  description = "S3バケット名（グローバルで一意である必要がある）"
  type        = string
}

variable "enable_versioning" {
  description = "バージョニングを有効にするかどうか"
  type        = bool
  default     = true
}

variable "transition_to_glacier_days" {
  description = "Glacier Instant Retrievalへ移行するまでの日数"
  type        = number
  default     = 30
}

variable "transition_to_deep_archive_days" {
  description = "Deep Archiveへ移行するまでの日数"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "オブジェクトを削除するまでの日数"
  type        = number
  default     = 365
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
