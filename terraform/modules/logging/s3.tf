# =============================================================================
# S3 Bucket for Log Storage
# =============================================================================
# FirehoseからのログをGZIP圧縮で保存するバケット
# Athenaでのクエリ効率を考慮したパーティショニングプレフィックスを使用

resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )
}

# -----------------------------------------------------------------------------
# バージョニング設定（コンプライアンス対応）
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# -----------------------------------------------------------------------------
# サーバーサイド暗号化設定（セキュリティベストプラクティス）
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# -----------------------------------------------------------------------------
# パブリックアクセスブロック（セキュリティベストプラクティス）
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# ライフサイクルルール（コスト最適化）
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  # ログデータのライフサイクル管理
  rule {
    id     = "log-lifecycle"
    status = "Enabled"

    # 対象: logs/ プレフィックス配下のすべてのオブジェクト
    filter {
      prefix = "logs/"
    }

    # 30日後にGlacier Instant Retrievalへ移行
    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER_IR"
    }

    # 90日後にDeep Archiveへ移行（長期保存用）
    transition {
      days          = var.transition_to_deep_archive_days
      storage_class = "DEEP_ARCHIVE"
    }

    # 365日後に削除（保持期間終了）
    expiration {
      days = var.expiration_days
    }

    # 非最新バージョンの管理
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER_IR"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  # エラーログのライフサイクル管理
  rule {
    id     = "error-log-lifecycle"
    status = "Enabled"

    filter {
      prefix = "errors/"
    }

    # エラーログは短期間で削除（デバッグ用途）
    expiration {
      days = 30
    }
  }
}
