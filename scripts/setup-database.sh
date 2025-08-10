#!/bin/bash

# =================================================================
# FiberAir4 Linux/macOS数据库自动设置脚本
# =================================================================

set -e  # 遇到错误立即退出

echo ""
echo "======================================"
echo "FiberAir4 数据库自动设置工具"
echo "======================================"
echo ""

# 检查MySQL是否可用
if ! command -v mysql &> /dev/null; then
    echo "❌ 错误: 未找到MySQL命令，请确保MySQL已安装"
    echo ""
    echo "💡 安装提示:"
    echo "   Ubuntu/Debian: sudo apt-get install mysql-server mysql-client"
    echo "   CentOS/RHEL:   sudo yum install mysql-server mysql"
    echo "   macOS:         brew install mysql"
    echo ""
    exit 1
fi

echo "✅ 检测到MySQL已安装"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 提示用户输入root密码
echo -n "请输入MySQL root用户密码: "
read -s ROOT_PASSWORD
echo ""
echo ""

echo "🚀 开始创建数据库..."
echo ""

# 执行数据库设置脚本
if mysql -u root -p"$ROOT_PASSWORD" < "$SCRIPT_DIR/quick-setup.sql"; then
    echo ""
    echo "✅ 数据库设置成功完成！"
    echo ""
    echo "📋 连接信息:"
    echo "   数据库名: fiber_air"
    echo "   用户名: fiber_user"
    echo "   密码: fiber_pass"
    echo "   主机: localhost"
    echo "   端口: 3306"
    echo ""
    echo "🧪 测试连接:"
    echo "   mysql -u fiber_user -p fiber_air"
    echo ""
    echo "🚀 现在可以启动FiberAir4应用了："
    echo "   go run cmd/slg/main.go"
    echo "   或者: air -c .air.windows.toml"
    echo ""
else
    echo ""
    echo "❌ 数据库设置失败！"
    echo "请检查MySQL连接和权限"
    echo ""
    exit 1
fi