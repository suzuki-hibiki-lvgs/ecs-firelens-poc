# =============================================================================
# ECR Module - コンテナイメージリポジトリ
# =============================================================================
# sample-appとfluent-bit用のECRリポジトリを作成

# -----------------------------------------------------------------------------
# ECR Repository
# -----------------------------------------------------------------------------
resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # イメージ暗号化（AWS管理キー使用）
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Lifecycle Policy - 古いイメージの自動削除
# -----------------------------------------------------------------------------
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
