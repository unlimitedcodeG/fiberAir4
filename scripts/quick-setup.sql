-- =================================================================
-- FiberAir4 快速数据库设置脚本
-- 
-- 使用方法：mysql -u root -p < quick-setup.sql
-- =================================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS fiber_air 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

-- 创建用户
CREATE USER IF NOT EXISTS 'fiber_user'@'localhost' IDENTIFIED BY 'fiber_pass';
CREATE USER IF NOT EXISTS 'fiber_user'@'%' IDENTIFIED BY 'fiber_pass';

-- 授予权限
GRANT ALL PRIVILEGES ON fiber_air.* TO 'fiber_user'@'localhost';
GRANT ALL PRIVILEGES ON fiber_air.* TO 'fiber_user'@'%';
FLUSH PRIVILEGES;

-- 使用数据库
USE fiber_air;

-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_users_deleted_at (deleted_at),
    INDEX idx_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT '✅ 数据库设置完成！' as Message;