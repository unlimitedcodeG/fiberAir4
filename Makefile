# Makefile for FiberAir4 project

.PHONY: help build run test clean docker-build docker-run docker-stop docker-clean

# 默认目标
help:
	@echo "Available commands:"
	@echo "  build          - Build the application"
	@echo "  run            - Run the application locally"
	@echo "  test           - Run tests"
	@echo "  clean          - Clean build artifacts"
	@echo "  docker-build   - Build Docker image"
	@echo "  docker-run     - Run with Docker Compose"
	@echo "  docker-stop    - Stop Docker containers"
	@echo "  docker-clean   - Clean Docker resources"
	@echo "  docker-prod    - Run production environment"

# 本地构建
build:
	go mod tidy
	go build -ldflags="-s -w" -o tmp/main cmd/slg/main.go

# 本地运行
run:
	go run cmd/slg/main.go

# 运行测试
test:
	go test -v ./...

# 清理构建文件
clean:
	rm -rf tmp/main*
	go clean

# Docker相关命令
docker-build:
	docker build --platform linux/amd64,linux/arm64 -t fiberair4:latest .

docker-run:
	docker-compose up -d

docker-stop:
	docker-compose down

docker-clean:
	docker-compose down -v
	docker system prune -f

# 生产环境
docker-prod:
	docker-compose -f docker-compose.prod.yml up -d

# 查看日志
docker-logs:
	docker-compose logs -f app

# 进入容器
docker-shell:
	docker-compose exec app sh

# 数据库迁移
docker-migrate:
	docker-compose exec app ./main migrate

# 健康检查
health:
	curl -f http://localhost:8080/health || exit 1