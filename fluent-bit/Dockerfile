# ===========================================
# Custom Fluent Bit Image for ECS FireLens
# ===========================================
# AWS公式イメージをベースに、カスタム設定ファイルを追加
#
# 使用パターン:
# 1. ECS FireLens: /extra.conf を config-file-value で指定
#    - FireLensが /fluent-bit/etc/fluent-bit.conf を予約・自動生成
#    - カスタム設定は /extra.conf に配置（OUTPUTのみ）
#
# 2. ローカル開発: docker-compose でvolume mountを使用
#    - fluent-bit.conf を /fluent-bit/etc/fluent-bit.conf にマウント
#    - フルconfig（INPUT + FILTER + OUTPUT）

FROM public.ecr.aws/aws-observability/aws-for-fluent-bit:stable

# ECS FireLens用: カスタム設定を /extra.conf に配置
# ※ /fluent-bit/etc/fluent-bit.conf はFireLens予約パスのため使用不可
COPY extra.conf /extra.conf

# パーサー設定（両環境で使用）
COPY parsers.conf /fluent-bit/etc/parsers.conf

# FireLens用にデフォルトのエントリポイントを維持
# aws-for-fluent-bitイメージは自動的に適切なエントリポイントを持つ
