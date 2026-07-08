# LELEO 博客系统开发指南

## 项目简介

这是一个基于SSM框架（Spring + Spring MVC + MyBatis）开发的个人博客系统，使用JSP作为前端视图技术，MySQL作为数据库。

## 技术栈

- **后端框架**：Spring 5.2.8 + Spring MVC
- **持久层框架**：MyBatis 3.5.6
- **数据库**：MySQL 8.0
- **连接池**：Druid 1.2.4
- **分页插件**：PageHelper 5.2.0
- **前端视图**：JSP + JSTL
- **构建工具**：Maven 3.x

## 项目结构

```
blog-system/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/leleo/blog/
│   │   │       ├── common/          # 公共类
│   │   │       ├── controller/      # 控制器层
│   │   │       ├── entity/          # 实体类
│   │   │       ├── exception/        # 异常处理
│   │   │       ├── interceptor/      # 拦截器
│   │   │       ├── mapper/          # MyBatis Mapper接口
│   │   │       ├── service/         # 服务层
│   │   │       └── util/            # 工具类
│   │   ├── resources/
│   │   │   ├── db/                  # 数据库脚本
│   │   │   ├── mapper/              # MyBatis XML映射文件
│   │   │   ├── mybatis/             # MyBatis配置
│   │   │   ├── spring/              # Spring配置文件
│   │   │   └── db.properties       # 数据库配置
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── views/          # JSP视图文件
│   │       ├── static/              # 静态资源
│   │       └── upload/              # 文件上传目录
│   └── test/                        # 测试代码
├── pom.xml                          # Maven配置
└── README.md                        # 项目说明
```

## 快速开始

### 1. 环境要求

- JDK 1.8+
- Maven 3.x
- MySQL 5.7+ 或 MySQL 8.0+
- Tomcat 8.5+ 或使用Maven运行

### 2. 数据库配置

1. 修改 `src/main/resources/db.properties` 中的数据库连接信息：

```properties
jdbc.url=jdbc:mysql://localhost:3306/blog_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
jdbc.username=root
jdbc.password=your_password
```

2. 创建数据库并导入初始化脚本：

```sql
-- 在MySQL中执行
CREATE DATABASE blog_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blog_system;
-- 然后执行 src/main/resources/db/init.sql 中的所有语句
```

### 3. 编译运行

```bash
# 编译项目
mvn clean package

# 运行项目（使用Tomcat插件）
mvn tomcat7:run

# 或者部署到Tomcat
# 将 target/blog-system.war 复制到 Tomcat 的 webapps 目录
```

### 4. 访问系统

- 前台首页：http://localhost:8080/
- 后台管理：http://localhost:8080/admin/login
- 默认管理员账号：admin / admin123

## 开发规范

### 命名规范

- **实体类**：驼峰命名，如 `User`, `Article`
- **Mapper接口**：以 `Mapper` 结尾，如 `UserMapper`
- **Service接口**：以 `Service` 结尾，如 `UserService`
- **Service实现**：以 `ServiceImpl` 结尾，如 `UserServiceImpl`
- **Controller**：以 `Controller` 结尾，如 `UserController`

### 数据库表命名

- `sys_` 前缀：系统表，如 `sys_user`
- `blog_` 前缀：业务表，如 `blog_article`

### 代码示例

#### 1. 创建新的实体类

```java
// src/main/java/com/leleo/blog/entity/User.java
public class User extends BaseEntity {
    private String username;
    private String password;
    private String nickname;
    // getter和setter方法
}
```

#### 2. 创建Mapper接口

```java
// src/main/java/com/leleo/blog/mapper/UserMapper.java
public interface UserMapper extends BaseMapper<User> {
    User selectByUsername(@Param("username") String username);
    User login(@Param("username") String username, @Param("password") String password);
}
```

#### 3. 创建Mapper XML

```xml
<!-- src/main/resources/mapper/UserMapper.xml -->
<mapper namespace="com.leleo.blog.mapper.UserMapper">
    <select id="selectByUsername" resultType="User">
        SELECT * FROM sys_user WHERE username = #{username}
    </select>
</mapper>
```

#### 4. 创建Service

```java
// Service接口
public interface UserService {
    User selectById(Long id);
    User login(String username, String password);
}

// Service实现
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;

    @Override
    public User selectById(Long id) {
        return userMapper.selectById(id);
    }
}
```

#### 5. 创建Controller

```java
@Controller
@RequestMapping("/admin")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/user/list")
    @ResponseBody
    public Result<List<User>> list() {
        return Result.success(userService.selectAll());
    }
}
```

## 功能模块

### 1. 文章管理

- **功能**：文章的增删改查
- **API**：
  - `GET /admin/article/list` - 文章列表
  - `GET /admin/article/edit?id=1` - 编辑文章
  - `POST /admin/article/save` - 保存文章
  - `POST /admin/article/delete` - 删除文章

### 2. 分类管理

- **功能**：文章分类的增删改查
- **API**：
  - `GET /admin/category/list` - 分类列表
  - `POST /admin/category/save` - 保存分类
  - `POST /admin/category/delete` - 删除分类

### 3. 标签管理

- **功能**：文章标签的增删改查
- **API**：
  - `GET /admin/tag/list` - 标签列表
  - `POST /admin/tag/save` - 保存标签
  - `POST /admin/tag/delete` - 删除标签

### 4. 评论管理

- **功能**：评论的查看和删除
- **API**：
  - `GET /admin/comment/list` - 评论列表
  - `POST /admin/comment/delete` - 删除评论

### 5. 音乐管理

- **功能**：背景音乐的增删改查
- **API**：
  - `GET /admin/music/list` - 音乐列表
  - `POST /admin/music/save` - 保存音乐
  - `POST /admin/music/delete` - 删除音乐

## 前端页面

### 前台页面

- `/WEB-INF/views/front/index.jsp` - 首页
- `/WEB-INF/views/front/login.jsp` - 登录页
- `/WEB-INF/views/front/register.jsp` - 注册页
- `/WEB-INF/views/front/article.jsp` - 文章详情页

### 后台页面

- `/WEB-INF/views/admin/index.jsp` - 管理后台首页
- `/WEB-INF/views/admin/login.jsp` - 后台登录页
- `/WEB-INF/views/admin/article/` - 文章管理页面

## 常见问题

### 1. 数据库连接失败

检查 `db.properties` 中的数据库配置是否正确，确保MySQL服务已启动。

### 2. 静态资源无法访问

检查 `spring-mvc.xml` 中的静态资源映射配置。

### 3. 拦截器导致无法访问

检查 `spring-mvc.xml` 中的拦截器配置，确保登录页和静态资源被排除。




## 许可证

本项目仅供学习交流使用，禁止商业用途。
