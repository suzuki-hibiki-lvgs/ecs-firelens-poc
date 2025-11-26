# =============================================================================
# ECS FireLens PoC - Dev Environment
# =============================================================================
# 開発環境用のTerraform設定
# S3バケット、IAMロール、Kinesis Data Firehoseを構築

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# Provider Configuration
# -----------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# -----------------------------------------------------------------------------
# Data Sources
# -----------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# -----------------------------------------------------------------------------
# S3 Module - ログ保存用バケット
# -----------------------------------------------------------------------------
module "s3" {
  source = "../../modules/s3"

  bucket_name = "${var.project}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"

  # ライフサイクル設定（dev環境は短めに設定してコスト削減）
  # NOTE: DEEP_ARCHIVEはGLACIER_IRより90日以上後である必要がある
  enable_versioning               = false
  transition_to_glacier_days      = 30
  transition_to_deep_archive_days = 120
  expiration_days                 = 180

  tags = local.tags
}

# -----------------------------------------------------------------------------
# IAM Module - Firehose用IAMロール
# -----------------------------------------------------------------------------
module "iam" {
  source = "../../modules/iam"

  project        = var.project
  environment    = var.environment
  aws_region     = var.aws_region
  aws_account_id = data.aws_caller_identity.current.account_id

  s3_bucket_arn             = module.s3.bucket_arn
  enable_cloudwatch_logging = true

  tags = local.tags
}

# -----------------------------------------------------------------------------
# Firehose Module - ログ配信ストリーム
# -----------------------------------------------------------------------------
module "firehose" {
  source = "../../modules/firehose"

  delivery_stream_name = "${var.project}-${var.environment}-stream"
  firehose_role_arn    = module.iam.firehose_role_arn
  s3_bucket_arn        = module.s3.bucket_arn

  # バッファリング設定（dev環境は低レイテンシ優先）
  buffering_size_mb      = 1
  buffering_interval_sec = 60

  enable_cloudwatch_logging = true
  log_retention_days        = 7

  tags = local.tags
}

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

# -----------------------------------------------------------------------------
# Local Values
# -----------------------------------------------------------------------------
locals {
  tags = {
    Project     = var.project
    Environment = var.environment
  }
}
