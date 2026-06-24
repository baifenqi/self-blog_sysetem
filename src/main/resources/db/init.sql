-- 创建数据库
CREATE DATABASE IF NOT EXISTS blog_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE blog_system;

-- 用户表
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `signature` VARCHAR(255) DEFAULT NULL COMMENT '个人签名',
  `role` VARCHAR(20) DEFAULT 'user' COMMENT '角色：admin-管理员，user-普通用户',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 文章分类表
DROP TABLE IF EXISTS `blog_category`;
CREATE TABLE `blog_category` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `slug` VARCHAR(50) NOT NULL COMMENT '分类别名',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
  `sort` INT(11) DEFAULT 0 COMMENT '排序',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章分类表';

-- 标签表
DROP TABLE IF EXISTS `blog_tag`;
CREATE TABLE `blog_tag` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `color` VARCHAR(20) DEFAULT '#00d9ff' COMMENT '标签颜色',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 文章表
DROP TABLE IF EXISTS `blog_article`;
CREATE TABLE `blog_article` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` VARCHAR(200) NOT NULL COMMENT '文章标题',
  `slug` VARCHAR(200) DEFAULT NULL COMMENT '文章别名',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '文章摘要',
  `content` TEXT NOT NULL COMMENT '文章内容(Markdown)',
  `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图片',
  `category_id` BIGINT(20) DEFAULT NULL COMMENT '分类ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '作者ID',
  `view_count` INT(11) DEFAULT 0 COMMENT '浏览量',
  `comment_count` INT(11) DEFAULT 0 COMMENT '评论数',
  `like_count` INT(11) DEFAULT 0 COMMENT '点赞数',
  `is_top` TINYINT(1) DEFAULT 0 COMMENT '是否置顶：0-否，1-是',
  `is_deleted` TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-否，1-是',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章表';

-- 文章标签关联表
DROP TABLE IF EXISTS `blog_article_tag`;
CREATE TABLE `blog_article_tag` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `article_id` BIGINT(20) NOT NULL COMMENT '文章ID',
  `tag_id` BIGINT(20) NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章标签关联表';

-- 评论表
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `article_id` BIGINT(20) NOT NULL COMMENT '文章ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '评论用户ID',
  `content` VARCHAR(500) NOT NULL COMMENT '评论内容',
  `parent_id` BIGINT(20) DEFAULT NULL COMMENT '父评论ID',
  `is_deleted` TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-否，1-是',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- 系统设置表
DROP TABLE IF EXISTS `sys_setting`;
CREATE TABLE `sys_setting` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '设置ID',
  `setting_key` VARCHAR(50) NOT NULL COMMENT '设置键',
  `setting_value` TEXT COMMENT '设置值',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '描述',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统设置表';

-- 音乐表
DROP TABLE IF EXISTS `blog_music`;
CREATE TABLE `blog_music` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '音乐ID',
  `title` VARCHAR(100) NOT NULL COMMENT '音乐标题',
  `artist` VARCHAR(100) DEFAULT NULL COMMENT '艺术家',
  `url` VARCHAR(255) NOT NULL COMMENT '音乐URL',
  `cover` VARCHAR(255) DEFAULT NULL COMMENT '封面URL',
  `lyrics` TEXT COMMENT '歌词',
  `sort` INT(11) DEFAULT 0 COMMENT '排序',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='音乐表';

-- 插入默认管理员用户 (密码: admin123)
INSERT INTO `sys_user` (`username`, `password`, `nickname`, `avatar`, `email`, `signature`, `role`)
VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 'LELEO', NULL, 'admin@example.com', '顶峰的少年,给了你所有细节,你却说我不是迪迦', 'admin');

-- 插入默认分类
INSERT INTO `blog_category` (`name`, `slug`, `description`, `sort`) VALUES
('技术分享', 'tech', '技术相关文章', 1),
('生活随笔', 'life', '生活感悟文章', 2),
('学习笔记', 'study', '学习记录', 3),
('项目实战', 'project', '项目经验总结', 4);

-- 插入默认标签
INSERT INTO `blog_tag` (`name`, `color`) VALUES
('Java', '#00d9ff'),
('Spring', '#ff6b9d'),
('MyBatis', '#ffd93d'),
('JavaScript', '#6bcb77'),
('Vue', '#9b59b6'),
('Python', '#e74c3c');

-- 插入示例文章
INSERT INTO `blog_article` (`title`, `slug`, `summary`, `content`, `category_id`, `user_id`, `view_count`, `comment_count`, `like_count`)
VALUES
('欢迎访问我的博客', 'welcome', '这是一个基于SSM框架开发的个人博客系统', '# 欢迎访问我的博客\n\n这是一个基于SSM框架开发的个人博客系统。\n\n## 功能特点\n\n- 文章发布与管理\n- 评论互动\n- 标签分类\n- 响应式设计\n\n希望你会喜欢！', 1, 1, 100, 5, 10),
('Spring Boot入门指南', 'spring-boot-guide', '详细介绍Spring Boot的基本使用和核心概念', '# Spring Boot入门指南\n\nSpring Boot是简化Spring应用开发的框架。\n\n## 核心特性\n\n1. 自动配置\n2. 嵌入式服务器\n3. 简化依赖管理\n\n让我们一起学习吧！', 1, 1, 200, 8, 15);

-- 插入示例评论
INSERT INTO `blog_comment` (`article_id`, `user_id`, `content`) VALUES
(1, 1, '博客系统看起来很不错！'),
(1, 1, '欢迎欢迎！');

-- 插入系统设置
INSERT INTO `sys_setting` (`setting_key`, `setting_value`, `description`) VALUES
('site_name', 'LELEO Blog', '网站名称'),
('site_description', '个人技术博客', '网站描述'),
('avatar', NULL, '用户默认头像'),
('background_image', NULL, '背景图片');

-- 插入示例音乐
INSERT INTO `blog_music` (`title`, `artist`, `url`, `cover`, `sort`, `status`) VALUES
('Starry Sky', 'Unknown Artist', '/static/music/sample1.mp3', 'https://picsum.photos/200/200?random=1', 1, 1),
('Night Dreams', 'Unknown Artist', '/static/music/sample2.mp3', 'https://picsum.photos/200/200?random=2', 2, 1),
('Ocean Waves', 'Unknown Artist', '/static/music/sample3.mp3', 'https://picsum.photos/200/200?random=3', 3, 1),
('Forest Morning', 'Unknown Artist', '/static/music/sample4.mp3', 'https://picsum.photos/200/200?random=4', 4, 1),
('City Lights', 'Unknown Artist', '/static/music/sample5.mp3', 'https://picsum.photos/200/200?random=5', 5, 1);