# =============================================================================
# Dev Environment Variables
# =============================================================================

variable "project" {
  description = "プロジェクト名"
  type        = string
  default     = "firelens-poc"
}

variable "environment" {
  description = "環境名"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "newrelic_license_key" {
  description = "New Relic License Key"
  type        = string
  sensitive   = true
}
