@echo off
REM =================================================================
REM FiberAir4 Windows数据库自动设置脚本
REM =================================================================

echo.
echo ======================================
echo FiberAir4 数据库自动设置工具
echo ======================================
echo.

REM 检查MySQL是否可用
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到MySQL命令，请确保MySQL已安装并添加到PATH
    echo.
    echo 💡 提示:
    echo    1. 安装MySQL Server
    echo    2. 将MySQL的bin目录添加到系统PATH
    echo    3. 重新运行此脚本
    pause
    exit /b 1
)

echo ✅ 检测到MySQL已安装
echo.

REM 提示用户输入root密码
set /p ROOT_PASSWORD=请输入MySQL root用户密码: 

echo.
echo 🚀 开始创建数据库...
echo.

REM 执行数据库设置脚本
mysql -u root -p%ROOT_PASSWORD% < "%~dp0quick-setup.sql"

if %errorlevel% equ 0 (
    echo.
    echo ✅ 数据库设置成功完成！
    echo.
    echo 📋 连接信息:
    echo    数据库名: fiber_air
    echo    用户名: fiber_user  
    echo    密码: fiber_pass
    echo    主机: localhost
    echo    端口: 3306
    echo.
    echo 🧪 测试连接:
    echo    mysql -u fiber_user -p fiber_air
    echo.
) else (
    echo.
    echo ❌ 数据库设置失败！
    echo 请检查MySQL连接和权限
    echo.
)

echo 按任意键退出...
pause >nul