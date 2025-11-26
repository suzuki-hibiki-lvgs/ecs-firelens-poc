# =============================================================================
# Backend Configuration
# =============================================================================
# 開発環境ではローカルstateを使用
# 本番運用時はS3バックエンドに移行することを推奨

# NOTE: 以下のコメントアウトされた設定は、本番運用時に有効化してください
# terraform {
#   backend "s3" {
#     bucket         = "firelens-poc-terraform-state"
#     key            = "dev/terraform.tfstate"
#     region         = "ap-northeast-1"
#     encrypt        = true
#     dynamodb_table = "firelens-poc-terraform-lock"
#   }
# }
