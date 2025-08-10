# 🗄️ FiberAir4 数据库设置指南

本目录包含完整的数据库设置脚本，支持本地开发和服务器部署环境。

## 📁 文件说明

| 文件 | 用途 | 适用场景 |
|------|------|----------|
| `database-setup.sql` | 完整数据库初始化脚本 | 生产环境、详细设置 |
| `quick-setup.sql` | 快速设置脚本 | 开发环境、快速启动 |
| `setup-database.bat` | Windows自动化脚本 | Windows系统 |
| `setup-database.sh` | Linux/macOS自动化脚本 | Linux/macOS系统 |
| `init.sql` | Docker容器初始化 | Docker环境 |

## 🚀 快速开始

### Windows 用户

1. 确保MySQL已安装并启动
2. 双击运行 `setup-database.bat`
3. 输入MySQL root密码
4. 等待设置完成

```cmd
# 或者命令行执行
cd scripts
setup-database.bat
```

### Linux/macOS 用户

1. 确保MySQL已安装并启动
2. 运行设置脚本：

```bash
cd scripts
chmod +x setup-database.sh
./setup-database.sh
```

### 手动设置

如果自动脚本不适用，可以手动执行：

```bash
# 连接MySQL
mysql -u root -p

# 执行快速设置
mysql> source /path/to/scripts/quick-setup.sql;

# 或执行完整设置
mysql> source /path/to/scripts/database-setup.sql;
```

## 📋 设置结果

设置完成后，将创建：

### 数据库
- **名称**: `fiber_air`
- **字符集**: `utf8mb4`
- **排序规则**: `utf8mb4_unicode_ci`

### 用户账户
- **用户名**: `fiber_user`
- **密码**: `fiber_pass`
- **权限**: 对 `fiber_air` 数据库的完全访问权限
- **连接**: 支持本地和远程连接

### 数据表
- **users**: 用户表，包含ID、用户名、密码、时间戳等字段

## 🧪 连接测试

设置完成后，可以使用以下命令测试连接：

```bash
# 测试应用用户连接
mysql -u fiber_user -p fiber_air

# 查看表结构
mysql> DESCRIBE users;

# 查看数据库
mysql> SHOW DATABASES;
```

## 🔧 应用配置

确保应用配置文件中的数据库连接信息正确：

```yaml
# internal/config/config.local.yml
database:
  host: 127.0.0.1
  port: 3306
  user: fiber_user
  password: fiber_pass
  name: fiber_air
```

## 🛠️ 故障排除

### 常见问题

1. **MySQL命令未找到**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install mysql-server mysql-client
   
   # CentOS/RHEL
   sudo yum install mysql-server mysql
   
   # macOS
   brew install mysql
   ```

2. **权限被拒绝**
   - 确保使用正确的root密码
   - 检查MySQL服务是否运行：`sudo service mysql status`

3. **用户已存在错误**
   - 脚本会自动处理已存在的用户
   - 如需重置，可以手动删除用户后重新运行

4. **字符集问题**
   - 确保MySQL配置支持utf8mb4
   - 检查 `my.cnf` 配置文件

### 重置数据库

如果需要完全重置数据库：

```sql
-- 谨慎使用：会删除所有数据
DROP DATABASE IF EXISTS fiber_air;
DROP USER IF EXISTS 'fiber_user'@'localhost';
DROP USER IF EXISTS 'fiber_user'@'%';

-- 然后重新运行设置脚本
```

## 🔒 安全建议

### 生产环境

1. **修改默认密码**：
   ```sql
   ALTER USER 'fiber_user'@'%' IDENTIFIED BY 'your-strong-password';
   ```

2. **限制网络访问**：
   ```sql
   -- 仅允许特定IP访问
   CREATE USER 'fiber_user'@'192.168.1.100' IDENTIFIED BY 'strong-password';
   ```

3. **最小权限原则**：
   ```sql
   -- 仅授予必需权限
   GRANT SELECT, INSERT, UPDATE, DELETE ON fiber_air.* TO 'fiber_user'@'%';
   ```

### 开发环境

- 可以使用默认密码
- 建议定期备份数据
- 测试数据与生产数据分离

## 📝 环境变量

也可以通过环境变量配置数据库连接：

```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_USER=fiber_user
export DB_PASSWORD=fiber_pass
export DB_NAME=fiber_air
```

## 🆘 获取帮助

如果遇到问题：

1. 检查MySQL错误日志
2. 验证网络连接
3. 确认用户权限
4. 查看应用日志

有关更多信息，请参考项目主README文件。