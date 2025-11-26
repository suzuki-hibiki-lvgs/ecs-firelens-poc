# ===========================================
# Custom Fluent Bit Image for ECS FireLens
# ===========================================
# AWS公式イメージをベースに、設定ファイルを焼き込む
# これにより、S3からの設定読み込みを省略しデプロイをシンプル化

FROM public.ecr.aws/aws-observability/aws-for-fluent-bit:stable

# 設定ファイルをコピー
COPY fluent-bit.conf /fluent-bit/etc/fluent-bit.conf
COPY parsers.conf /fluent-bit/etc/parsers.conf

# FireLens用にデフォルトのエントリポイントを維持
# aws-for-fluent-bitイメージは自動的に適切なエントリポイントを持つ
