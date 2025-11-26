/**
 * Sample Application for ECS FireLens PoC
 *
 * 構造化JSONログを定期的に出力するテストアプリケーション
 * ログレベル（INFO/WARN/ERROR/DEBUG）を交互に出力し、
 * Fluent Bit のフィルタリング動作を検証する
 */

// ログレベル定義
type LogLevel = "DEBUG" | "INFO" | "WARN" | "ERROR";

// ログスキーマ
interface LogEntry {
  timestamp: string;
  level: LogLevel;
  service: string;
  environment: string;
  trace_id: string;
  span_id: string;
  message: string;
  context?: Record<string, unknown>;
}

// 環境変数から設定を取得
const SERVICE_NAME = process.env.SERVICE_NAME || "sample-app";
const ENVIRONMENT = process.env.ENVIRONMENT || "local";

// ランダムなトレースIDを生成
function generateTraceId(): string {
  return Math.random().toString(36).substring(2, 15);
}

// ランダムなスパンIDを生成
function generateSpanId(): string {
  return Math.random().toString(36).substring(2, 10);
}

// 構造化ログを出力
function log(level: LogLevel, message: string, context?: Record<string, unknown>): void {
  const entry: LogEntry = {
    timestamp: new Date().toISOString(),
    level,
    service: SERVICE_NAME,
    environment: ENVIRONMENT,
    trace_id: generateTraceId(),
    span_id: generateSpanId(),
    message,
    context,
  };

  // JSON形式で標準出力に出力（Fluent Bitが収集）
  console.log(JSON.stringify(entry));
}

// テストログのパターン
const logPatterns: Array<{ level: LogLevel; message: string; context?: Record<string, unknown> }> = [
  {
    level: "INFO",
    message: "Application started successfully",
    context: { version: "1.0.0", node_version: process.version },
  },
  {
    level: "DEBUG",
    message: "Processing request",
    context: { request_id: "req-001", path: "/api/health" },
  },
  {
    level: "INFO",
    message: "Request processed successfully",
    context: { user_id: "user-123", request_path: "/api/v1/resource", response_time_ms: 45 },
  },
  {
    level: "WARN",
    message: "High memory usage detected",
    context: { memory_usage_percent: 85, threshold: 80 },
  },
  {
    level: "ERROR",
    message: "Database connection failed",
    context: { error_code: "ECONNREFUSED", retry_count: 3, host: "db.example.com" },
  },
  {
    level: "DEBUG",
    message: "Cache lookup",
    context: { cache_key: "user:123:profile", hit: false },
  },
  {
    level: "INFO",
    message: "User authentication successful",
    context: { user_id: "user-456", auth_method: "oauth2" },
  },
  {
    level: "ERROR",
    message: "Payment processing failed",
    context: { transaction_id: "txn-789", error: "Insufficient funds", amount: 150.0 },
  },
];

// メインループ
let patternIndex = 0;

function emitLog(): void {
  const pattern = logPatterns[patternIndex];
  log(pattern.level, pattern.message, pattern.context);

  patternIndex = (patternIndex + 1) % logPatterns.length;
}

// 初期ログ
log("INFO", "Sample app initializing", { pid: process.pid });

// 1秒ごとにログを出力
setInterval(emitLog, 1000);

// 終了ハンドリング
process.on("SIGTERM", () => {
  log("INFO", "Received SIGTERM, shutting down gracefully");
  process.exit(0);
});

process.on("SIGINT", () => {
  log("INFO", "Received SIGINT, shutting down gracefully");
  process.exit(0);
});

log("INFO", "Sample app started, emitting logs every 1 second");