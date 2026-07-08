# 博客系统开发清单

> 项目状态：后端基础功能已完成，前端页面部分缺失

---

## 📁 项目结构概览

```
src/main/
├── java/com/leleo/blog/      ✅ 全部完成
├── resources/                ✅ 基本完成（需修复上传路径）
└── webapp/
    ├── WEB-INF/views/        ⚠️ 部分缺失
    └── static/               ✅ 完成
```

---

## 🎨 一、前端页面开发

### 1.1 前台页面

| 序号 | 页面路径 | 状态 | 负责人 | 描述 |
|:---:|---------|:---:|:------:|------|
| 1 | `front/article.jsp` | ❌ 待开发 | - | 文章详情页（显示文章内容、评论区、点赞功能） |
| 2 | `front/profile.jsp` | ❌ 待开发 | - | 用户个人信息页（个人资料、发布文章列表） |
| 3 | `front/login.jsp` | ✅ 已完成 | - | 用户登录页 |
| 4 | `front/register.jsp` | ✅ 已完成 | - | 用户注册页 |
| 5 | `front/index.jsp` | ✅ 已完成 | - | 首页（文章列表、分类、标签、音乐播放器） |

### 1.2 后台管理页面

| 序号 | 页面路径 | 状态 | 负责人 | 描述 |
|:---:|---------|:---:|:------:|------|
| 1 | `admin/article/list.jsp` | ❌ 待开发 | - | 文章列表管理页（搜索、分页、删除） |
| 2 | `admin/article/edit.jsp` | ❌ 待开发 | - | 文章编辑页（富文本编辑器、标签选择） |
| 3 | `admin/category/list.jsp` | ❌ 待开发 | - | 分类管理页（增删改查） |
| 4 | `admin/tag/list.jsp` | ❌ 待开发 | - | 标签管理页（增删改查、颜色设置） |
| 5 | `admin/music/list.jsp` | ❌ 待开发 | - | 音乐管理页（增删改查） |
| 6 | `admin/user/list.jsp` | ❌ 待开发 | - | 用户管理页（增删改查、密码重置） |
| 7 | `admin/setting.jsp` | ❌ 待开发 | - | 系统设置页 |
| 8 | `admin/index.jsp` | ✅ 已完成 | - | 后台首页（统计数据展示） |
| 9 | `admin/login.jsp` | ✅ 已完成 | - | 管理员登录页 |

### 1.3 错误页面

| 序号 | 页面路径 | 状态 | 负责人 | 描述 |
|:---:|---------|:---:|:------:|------|
| 1 | `error/404.jsp` | ❌ 待开发 | - | 404 页面未找到 |
| 2 | `error/500.jsp` | ❌ 待开发 | - | 500 服务器错误 |

---

## 🔧 二、功能完善

### 2.1 核心功能

| 序号 | 功能模块 | 状态 | 负责人 | 描述 |
|:---:|---------|:---:|:------:|------|
| 1 | 文件上传 | ⚠️ 路径错误 | - | 修复 `db.properties` 中上传路径 |
| 2 | 文章点赞 | ❌ 待实现 | - | 文章点赞功能（后端已支持，需前端对接） |
| 3 | 评论回复 | ❌ 待完善 | - | 评论嵌套回复功能 |
| 4 | 文章搜索 | ❌ 待实现 | - | 搜索框对接后端接口 |
| 5 | 分页展示 | ⚠️ 部分实现 | - | 前端列表分页展示 |
| 6 | 图片上传 | ❌ 待实现 | - | 文章封面图片上传 |

### 2.2 后端接口（已实现）

| 模块 | 接口数量 | 状态 | 说明 |
|:----|:-------:|:---:|------|
| 用户管理 | 6 | ✅ | 登录、注册、列表、增删改查 |
| 文章管理 | 5 | ✅ | 列表、详情、新增、更新、删除 |
| 分类管理 | 3 | ✅ | 列表、保存、删除 |
| 标签管理 | 3 | ✅ | 列表、保存、删除 |
| 评论管理 | 2 | ✅ | 列表、删除 |
| 音乐管理 | 3 | ✅ | 列表、保存、删除 |
| 系统设置 | 2 | ✅ | 列表、保存 |

---

## 🐛 三、代码问题修复

| 序号 | 文件 | 问题描述 | 状态 | 修复建议 |
|:---:|------|---------|:---:|---------|
| 1 | `IndexController.java` | 添加评论后重复调用 `selectById`，未更新评论数 | ❌ 待修复 | 调用 `articleService.updateCommentCount()` |
| 2 | `db.properties` | `upload.path` 指向错误目录 | ❌ 待修复 | 修改为正确路径：`D:/codelearng/BlogSystem/src/main/webapp/upload` |

---

## 🗂️ 四、文件结构清单

### 4.1 已存在文件

```
src/main/java/com/leleo/blog/
├── common/                    # 通用工具类
│   ├── Constants.java         ✅
│   ├── PageResult.java        ✅
│   └── Result.java            ✅
├── controller/                # 控制器
│   ├── AdminController.java   ✅
│   └── IndexController.java   ✅
├── entity/                    # 实体类
│   ├── Article.java           ✅
│   ├── BaseEntity.java        ✅
│   ├── Category.java          ✅
│   ├── Comment.java           ✅
│   ├── Music.java             ✅
│   ├── Setting.java           ✅
│   ├── Tag.java               ✅
│   └── User.java              ✅
├── exception/                 # 异常处理
│   ├── BusinessException.java ✅
│   └── GlobalExceptionHandler.java ✅
├── interceptor/               # 拦截器
│   └── LoginInterceptor.java  ✅
├── mapper/                    # Mapper接口
│   ├── ArticleMapper.java     ✅
│   ├── BaseMapper.java        ✅
│   ├── CategoryMapper.java    ✅
│   ├── CommentMapper.java     ✅
│   ├── MusicMapper.java       ✅
│   ├── SettingMapper.java     ✅
│   ├── TagMapper.java         ✅
│   └── UserMapper.java        ✅
└── service/                   # 服务层
    ├── impl/                  ✅ 全部实现类
    ├── ArticleService.java    ✅
    ├── CategoryService.java   ✅
    ├── CommentService.java    ✅
    ├── MusicService.java      ✅
    ├── SettingService.java    ✅
    ├── TagService.java        ✅
    └── UserService.java       ✅
```

### 4.2 资源文件

```
src/main/resources/
├── db/
│   └── init.sql               ✅ 数据库初始化脚本
├── mapper/                    ✅ 全部 XML 映射文件
├── mybatis/
│   └── mybatis-config.xml     ✅
├── spring/
│   ├── spring-dao.xml         ✅
│   └── spring-mvc.xml         ✅
├── applicationContext.xml     ✅
└── db.properties              ⚠️ 需修复上传路径
```

---

## 📊 五、数据库表结构

| 表名 | 说明 | 状态 |
|:----|:-----|:---:|
| `sys_user` | 用户表 | ✅ |
| `blog_category` | 文章分类表 | ✅ |
| `blog_tag` | 标签表 | ✅ |
| `blog_article` | 文章表 | ✅ |
| `blog_article_tag` | 文章标签关联表 | ✅ |
| `blog_comment` | 评论表 | ✅ |
| `sys_setting` | 系统设置表 | ✅ |
| `blog_music` | 音乐表 | ✅ |

---

## 🚀 六、推荐开发顺序

### 第一阶段（基础修复）
1. 修复 `db.properties` 上传路径
2. 创建错误页面（404、500）
3. 修复 `IndexController.java` 评论数更新问题

### 第二阶段（核心页面）
1. 创建 `front/article.jsp` - 文章详情页
2. 创建 `admin/article/list.jsp` - 文章列表页
3. 创建 `admin/article/edit.jsp` - 文章编辑页

### 第三阶段（管理页面）
1. 创建分类管理页
2. 创建标签管理页
3. 创建音乐管理页
4. 创建用户管理页

### 第四阶段（功能完善）
1. 实现文章搜索功能
2. 实现分页展示
3. 实现图片上传
4. 完善评论回复功能

---

## 👥 七、人员分工建议

| 模块 | 建议人数 | 预估工时（小时） |
|:----|:-------:|:---------------:|
| 前台页面开发 | 1-2 | 20-30 |
| 后台管理页面 | 1-2 | 25-35 |
| 功能完善与测试 | 1 | 10-15 |

---

## 📝 更新记录

| 日期 | 更新内容 | 更新人 |
|:----|:--------|:------:|
| 2026-06-23 | 初始化清单 | System |

---

> **备注**：请各位成员根据此清单认领任务，定期更新状态。如有疑问或需要协助，请随时沟通。