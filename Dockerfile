# 多阶段构建 Dockerfile，支持跨平台
FROM --platform=$BUILDPLATFORM golang:1.24.2-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装必要的工具
RUN apk add --no-cache git ca-certificates tzdata

# 复制 go mod 文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建参数
ARG TARGETOS
ARG TARGETARCH

# 编译应用（优化编译参数）
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -ldflags="-s -w -X main.version=$(date +%Y%m%d-%H%M%S)" \
    -o main cmd/slg/main.go

# 运行阶段
FROM --platform=$TARGETPLATFORM alpine:latest

# 安装运行时依赖
RUN apk --no-cache add ca-certificates tzdata && \
    addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

# 设置时区
ENV TZ=Asia/Shanghai

# 创建必要目录
RUN mkdir -p /app/internal/config && \
    chown -R appuser:appuser /app

# 切换到非root用户
USER appuser

WORKDIR /app

# 从构建阶段复制二进制文件
COPY --from=builder --chown=appuser:appuser /app/main .
COPY --from=builder --chown=appuser:appuser /app/internal/config/config.yml ./internal/config/

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# 启动应用
CMD ["./main"]