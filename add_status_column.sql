-- 为 blog_article 表添加 status 字段
-- 执行此脚本前请确保已备份数据库

ALTER TABLE `blog_article`
ADD COLUMN `status` TINYINT(1) DEFAULT 1 COMMENT '状态：0-草稿，1-已发布'
AFTER `is_deleted`;

-- 可选：添加索引
ALTER TABLE `blog_article` ADD INDEX `idx_status` (`status`);
