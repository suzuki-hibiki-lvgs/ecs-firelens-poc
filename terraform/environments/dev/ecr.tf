# =============================================================================
# ECR Repositories
# =============================================================================
# sample-app と fluent-bit のコンテナイメージリポジトリ

# -----------------------------------------------------------------------------
# ECR Module - sample-app イメージリポジトリ
# -----------------------------------------------------------------------------
module "ecr_sample_app" {
  source = "../../modules/ecr"

  repository_name = "${var.project}-${var.environment}-sample-app"
  scan_on_push    = true
  max_image_count = 5

  tags = local.tags
}

# -----------------------------------------------------------------------------
# ECR Module - fluent-bit イメージリポジトリ
# -----------------------------------------------------------------------------
module "ecr_fluent_bit" {
  source = "../../modules/ecr"

  repository_name = "${var.project}-${var.environment}-fluent-bit"
  scan_on_push    = true
  max_image_count = 5

  tags = local.tags
}
