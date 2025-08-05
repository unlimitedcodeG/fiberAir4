#!/bin/bash

# FiberAir4 启动脚本

set -e

echo "🚀 Starting FiberAir4 with Docker..."

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# 检查环境变量文件
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your actual values before running in production!"
fi

# 检查配置文件
if [ ! -f internal/config/config.docker.yml ]; then
    echo "❌ Docker config file not found!"
    exit 1
fi

# 构建并启动服务
echo "🔨 Building and starting services..."
docker-compose up --build -d

# 等待服务启动
echo "⏳ Waiting for services to be ready..."
sleep 10

# 健康检查
echo "🏥 Checking service health..."
for i in {1..30}; do
    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        echo "✅ Service is healthy!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Service health check failed!"
        docker-compose logs app
        exit 1
    fi
    echo "   Attempt $i/30..."
    sleep 2
done

echo ""
echo "🎉 FiberAir4 is running successfully!"
echo "📱 API URL: http://localhost:8080"
echo "🏥 Health Check: http://localhost:8080/health"
echo "📊 View logs: docker-compose logs -f app"
echo "🛑 Stop services: docker-compose down"
echo ""