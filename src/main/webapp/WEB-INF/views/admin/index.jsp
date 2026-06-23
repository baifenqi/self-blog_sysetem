<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.leleo.blog.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理后台 - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- 侧边栏 -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>LELEO</h2>
                <p>博客管理系统</p>
            </div>
            <nav class="sidebar-nav">
                <a href="/admin/index" class="nav-item active">
                    <span>📊</span> 控制台
                </a>
                <a href="/admin/article/list" class="nav-item">
                    <span>📝</span> 文章管理
                </a>
                <a href="#" class="nav-item" onclick="alert('功能开发中')">
                    <span>📁</span> 分类管理
                </a>
                <a href="#" class="nav-item" onclick="alert('功能开发中')">
                    <span>🏷️</span> 标签管理
                </a>
                <a href="#" class="nav-item" onclick="alert('功能开发中')">
                    <span>💬</span> 评论管理
                </a>
                <a href="#" class="nav-item" onclick="alert('功能开发中')">
                    <span>🎵</span> 音乐管理
                </a>
                <a href="#" class="nav-item" onclick="alert('功能开发中')">
                    <span>👥</span> 用户管理
                </a>
                <a href="#" class="nav-item" onclick="alert('功能开发中')">
                    <span>⚙️</span> 系统设置
                </a>
            </nav>
            <div class="sidebar-footer">
                <a href="/" target="_blank" class="nav-item">
                    <span>🌐</span> 查看网站
                </a>
                <a href="/admin/logout" class="nav-item">
                    <span>🚪</span> 退出登录
                </a>
            </div>
        </aside>

        <!-- 主内容区 -->
        <main class="main-content">
            <header class="content-header">
                <h1>控制台</h1>
                <div class="user-info">
                    欢迎，<strong>${sessionScope.loginUser.nickname}</strong>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📝</div>
                    <div class="stat-info">
                        <div class="stat-value">${articleStats.totalArticles}</div>
                        <div class="stat-label">文章总数</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👁️</div>
                    <div class="stat-info">
                        <div class="stat-value">${articleStats.totalViews}</div>
                        <div class="stat-label">总访问量</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💬</div>
                    <div class="stat-info">
                        <div class="stat-value">${commentStats.totalComments}</div>
                        <div class="stat-label">评论总数</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-info">
                        <div class="stat-value">1</div>
                        <div class="stat-label">用户总数</div>
                    </div>
                </div>
            </div>

            <div class="content-grid">
                <div class="panel">
                    <div class="panel-header">
                        <h3>最新文章</h3>
                        <a href="/admin/article/list" class="more-link">查看更多 →</a>
                    </div>
                    <div class="panel-content">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>标题</th>
                                    <th>分类</th>
                                    <th>浏览量</th>
                                    <th>发布时间</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentArticles}" var="article">
                                    <tr>
                                        <td>${article.title}</td>
                                        <td>${article.categoryName}</td>
                                        <td>${article.viewCount}</td>
                                        <td>${article.createTime}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3>最新评论</h3>
                    </div>
                    <div class="panel-content">
                        <ul class="comment-list">
                            <c:forEach items="${recentComments}" var="comment">
                                <li class="comment-item">
                                    <div class="comment-user">${comment.username}</div>
                                    <div class="comment-content">${comment.content}</div>
                                    <div class="comment-time">${comment.createTime}</div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>