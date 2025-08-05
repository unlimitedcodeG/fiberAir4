# fiberAir4

Fiber+Air Development

## 🎯 项目文件结构

### 核心 Docker 文件

- `Dockerfile` - 多阶段构建，支持 linux/amd64 和 linux/arm64
- `docker-compose.yml` - 开发环境配置
- `docker-compose.prod.yml` - 生产环境配置

### 配置文件

- `scripts/init.sql` - MySQL 初始化脚本
- `scripts/redis.conf` - Redis 开发环境配置
- `scripts/redis-prod.conf` - Redis 生产环境配置
- `scripts/mysql-prod.cnf` - MySQL 生产环境配置
- `internal/config/config.docker.yml` - Docker 环境配置
- `internal/config/config.prod.yml` - 生产环境配置

### 辅助文件

- `.env.example` - 环境变量模板
- `Makefile` - 构建和部署命令
- `scripts/start.sh` - 一键启动脚本
- `DOCKER.md` - 详细的 Docker 部署文档