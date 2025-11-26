# =============================================================================
# ECS FireLens PoC - Dev Environment
# =============================================================================
# 開発環境用のTerraform設定
# Provider, Backend, Data Sourcesを定義

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

# 既存のVPC（lt-development）を参照
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["lt-development"]
  }
}

# プライベートサブネットを取得（NAT Gateway経由でインターネットアクセス可能）
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
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
