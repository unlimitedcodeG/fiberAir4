# Docker 部署指南

## 🐳 快速开始

### 1. 环境准备

确保已安装：
- Docker (20.10+)
- Docker Compose (2.0+)

### 2. 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑环境变量（重要！）
vim .env
```

### 3. 启动服务

```bash
# 方式1：使用启动脚本（推荐）
chmod +x scripts/start.sh
./scripts/start.sh

# 方式2：直接使用 docker-compose
docker-compose up -d

# 方式3：使用 Makefile
make docker-run
```

## 📋 服务说明

### 服务组件
- **app**: FiberAir4 应用服务 (端口: 8080)
- **mysql**: MySQL 8.0 数据库 (端口: 3306)
- **redis**: Redis 7 缓存 (端口: 6379)

### 跨平台支持
支持以下架构：
- `linux/amd64` (x86_64)
- `linux/arm64` (Apple Silicon, ARM64)

## 🔧 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f app
docker-compose logs -f mysql
docker-compose logs -f redis

# 进入容器
docker-compose exec app sh
docker-compose exec mysql mysql -u root -p

# 重启服务
docker-compose restart app

# 停止服务
docker-compose down

# 完全清理（包括数据卷）
docker-compose down -v
docker system prune -f
```

## 🚀 生产环境部署

### 1. 使用生产配置

```bash
# 编辑生产环境变量
cp .env.example .env.prod
vim .env.prod

# 启动生产环境
docker-compose -f docker-compose.prod.yml up -d
```

### 2. 生产环境特性

- 资源限制和预留
- 优化的日志配置
- 增强的安全配置
- 数据持久化
- 健康检查和自动重启

## 🏥 健康检查

```bash
# 检查应用健康状态
curl http://localhost:8080/health

# 预期响应
{
  "status": "ok",
  "service": "fiberair4",
  "timestamp": 1640995200
}
```

## 📊 监控和日志

### 查看实时日志
```bash
# 应用日志
docker-compose logs -f app

# 所有服务日志
docker-compose logs -f
```

### 日志文件位置
- 应用日志: 容器内 `/app/logs/`
- MySQL日志: 容器内 `/var/lib/mysql/`
- Redis日志: 容器内 `/data/`

## 🔒 安全配置

### 生产环境安全检查清单

- [ ] 修改默认密码（MySQL root, Redis）
- [ ] 设置强JWT密钥
- [ ] 配置防火墙规则
- [ ] 启用HTTPS（建议使用反向代理）
- [ ] 定期备份数据
- [ ] 监控资源使用情况

## 🛠️ 故障排除

### 常见问题

1. **端口占用**
   ```bash
   # 检查端口占用
   lsof -i :8080
   lsof -i :3306
   lsof -i :6379
   ```

2. **数据库连接失败**
   ```bash
   # 检查MySQL服务
   docker-compose exec mysql mysqladmin ping -h localhost -u root -p
   ```

3. **Redis连接失败**
   ```bash
   # 检查Redis服务
   docker-compose exec redis redis-cli ping
   ```

4. **应用无法启动**
   ```bash
   # 查看详细日志
   docker-compose logs app
   ```

### 重置环境

```bash
# 完全重置（会删除所有数据）
docker-compose down -v
docker system prune -f
docker volume prune -f
```

## 📈 性能优化

### 资源配置建议

**开发环境**:
- CPU: 1 core
- Memory: 1GB
- Storage: 10GB

**生产环境**:
- CPU: 2+ cores  
- Memory: 4GB+
- Storage: 50GB+

### 数据库优化

生产环境MySQL配置已包含：
- InnoDB缓冲池优化
- 连接数限制
- 查询缓存
- 慢查询日志

## 🔄 数据备份

```bash
# MySQL备份
docker-compose exec mysql mysqldump -u root -p fiber_air > backup.sql

# Redis备份
docker-compose exec redis redis-cli BGSAVE
```

## 📝 API测试

```bash
# 健康检查
curl http://localhost:8080/health

# 用户注册
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"123456"}'

# 用户登录
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"123456"}'
```