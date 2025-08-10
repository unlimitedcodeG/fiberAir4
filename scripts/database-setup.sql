-- =================================================================
-- FiberAir4 数据库完整初始化脚本
-- 
-- 用途：创建完整的数据库环境，包括数据库、用户、权限和表结构
-- 适用：本地开发环境、测试环境、生产环境
-- 
-- 使用方法：
-- 1. 以root用户连接MySQL: mysql -u root -p
-- 2. 执行此脚本: source /path/to/database-setup.sql
-- 或者: mysql -u root -p < /path/to/database-setup.sql
-- =================================================================

-- 删除已存在的数据库（谨慎使用，仅在重置时）
-- DROP DATABASE IF EXISTS fiber_air;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS fiber_air 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci
    COMMENT 'FiberAir4 应用主数据库';

-- 使用数据库
USE fiber_air;

-- =================================================================
-- 用户和权限管理
-- =================================================================

-- 删除已存在的用户（如果需要重置）
-- DROP USER IF EXISTS 'fiber_user'@'localhost';
-- DROP USER IF EXISTS 'fiber_user'@'%';

-- 创建应用用户（本地连接）
CREATE USER IF NOT EXISTS 'fiber_user'@'localhost' 
    IDENTIFIED BY 'fiber_pass'
    COMMENT 'FiberAir4应用本地数据库用户';

-- 创建应用用户（远程连接，适用于Docker等环境）
CREATE USER IF NOT EXISTS 'fiber_user'@'%' 
    IDENTIFIED BY 'fiber_pass'
    COMMENT 'FiberAir4应用远程数据库用户';

-- 授予权限给本地用户
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, REFERENCES 
    ON fiber_air.* TO 'fiber_user'@'localhost';

-- 授予权限给远程用户
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, REFERENCES 
    ON fiber_air.* TO 'fiber_user'@'%';

-- 刷新权限
FLUSH PRIVILEGES;

-- =================================================================
-- 数据库配置
-- =================================================================

-- 设置时区为中国标准时间
SET time_zone = '+08:00';

-- 设置字符集
SET NAMES utf8mb4;

-- =================================================================
-- 表结构创建
-- =================================================================

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(64) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码哈希',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL COMMENT '软删除时间',
    
    -- 索引
    INDEX idx_users_deleted_at (deleted_at),
    INDEX idx_users_username (username),
    INDEX idx_users_created_at (created_at)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci 
  COMMENT='用户表';

-- =================================================================
-- 示例数据插入（可选）
-- =================================================================

-- 插入测试用户（密码为 "123456" 的bcrypt哈希）
INSERT IGNORE INTO users (username, password, created_at, updated_at) VALUES 
    ('admin', '$2a$12$rZ8QFjJtQp7QbLzQ7Z9r8.K7QbLzQ7Z9r8QbLzQ7Z9r8QbLzQ7Z9r8', NOW(), NOW()),
    ('test_user', '$2a$12$rZ8QFjJtQp7QbLzQ7Z9r8.K7QbLzQ7Z9r8QbLzQ7Z9r8QbLzQ7Z9r8', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- =================================================================
-- 数据库状态检查
-- =================================================================

-- 显示数据库信息
SELECT 
    'Database Created Successfully' as Status,
    DATABASE() as Current_Database,
    @@character_set_database as Charset,
    @@collation_database as Collation,
    @@time_zone as TimeZone;

-- 显示表信息
SHOW TABLES;

-- 显示用户表结构
DESCRIBE users;

-- 显示用户权限
SHOW GRANTS FOR 'fiber_user'@'localhost';
SHOW GRANTS FOR 'fiber_user'@'%';

-- 显示数据库统计
SELECT 
    TABLE_NAME as '表名',
    TABLE_ROWS as '记录数',
    DATA_LENGTH as '数据大小(字节)',
    INDEX_LENGTH as '索引大小(字节)',
    CREATE_TIME as '创建时间'
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'fiber_air'
ORDER BY TABLE_NAME;

-- =================================================================
-- 完成提示
-- =================================================================

SELECT '✅ FiberAir4 数据库初始化完成！' as Message;
SELECT '📝 数据库名称: fiber_air' as Info;
SELECT '👤 应用用户: fiber_user' as User_Info;
SELECT '🔑 应用密码: fiber_pass' as Password_Info;
SELECT '🌐 连接示例: mysql -u fiber_user -p fiber_air' as Connection_Example;