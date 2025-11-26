# =============================================================================
# ECR Module Variables
# =============================================================================

variable "repository_name" {
  description = "ECRリポジトリ名"
  type        = string
}

variable "image_tag_mutability" {
  description = "イメージタグの変更可否（MUTABLE or IMMUTABLE）"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "プッシュ時に脆弱性スキャンを実行するか"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "保持する最大イメージ数（ライフサイクルポリシー）"
  type        = number
  default     = 10
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
