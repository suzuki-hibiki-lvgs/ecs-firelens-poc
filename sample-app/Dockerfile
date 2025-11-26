# ===========================================
# Sample App Dockerfile
# ===========================================
# TypeScript アプリケーションをビルド・実行

FROM node:20-alpine AS builder

WORKDIR /app

# 依存関係のインストール
COPY package*.json ./
RUN npm install

# ソースコードのコピーとビルド
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# -------------------------------------------
# Production Stage
# -------------------------------------------
FROM node:20-alpine

WORKDIR /app

# 本番用依存関係のみインストール
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force

# ビルド成果物をコピー
COPY --from=builder /app/dist ./dist

# 非rootユーザーで実行
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup
USER appuser

CMD ["node", "dist/main.js"]
