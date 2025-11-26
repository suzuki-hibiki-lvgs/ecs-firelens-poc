# =============================================================================
# Secrets Manager
# =============================================================================
# New Relic License Key等の機密情報を管理

resource "aws_secretsmanager_secret" "newrelic_license_key" {
  name        = "${var.project}-${var.environment}-newrelic-license-key"
  description = "New Relic License Key for Fluent Bit"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "newrelic_license_key" {
  secret_id     = aws_secretsmanager_secret.newrelic_license_key.id
  secret_string = var.newrelic_license_key
}
