<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>文章管理 - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
    <style>
        .search-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            align-items: center;
        }
        .search-bar input, .search-bar select {
            padding: 10px 15px;
            border: 1px solid #e4e7ed;
            border-radius: 6px;
            font-size: 14px;
        }
        .search-bar input {
            width: 250px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .btn-success {
            background: #67c23a;
            color: white;
        }
        .btn-success:hover {
            background: #5eb838;
        }
        .btn-warning {
            background: #e6a23c;
            color: white;
        }
        .btn-warning:hover {
            background: #d99233;
        }
        .btn-danger {
            background: #f56c6c;
            color: white;
        }
        .btn-danger:hover {
            background: #ee5a5a;
        }
        .btn-info {
            background: #409eff;
            color: white;
        }
        .btn-info:hover {
            background: #378de5;
        }
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin-top: 20px;
        }
        .pagination a, .pagination span {
            padding: 8px 15px;
            border: 1px solid #e4e7ed;
            border-radius: 6px;
            text-decoration: none;
            color: #606266;
            font-size: 14px;
        }
        .pagination a:hover {
            background: #f5f7fa;
        }
        .pagination .active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
        }
        .table-actions {
            display: flex;
            gap: 8px;
        }
        .top-badge {
            background: #e6a23c;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        .status-badge {
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        .status-published {
            background: #f0f9eb;
            color: #67c23a;
        }
        .status-draft {
            background: #fef0f0;
            color: #f56c6c;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-header h2 {
            font-size: 22px;
            color: #303133;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>LELEO</h2>
                <p>博客管理系统</p>
            </div>
            <nav class="sidebar-nav">
                <a href="/admin/index" class="nav-item">
                    <span>📊</span> 控制台
                </a>
                <a href="/admin/article/list" class="nav-item active">
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

        <main class="main-content">
            <header class="content-header">
                <h1>文章管理</h1>
                <div class="user-info">
                    欢迎，<strong>${sessionScope.loginUser.nickname}</strong>
                </div>
            </header>

            <div class="panel">
                <div class="page-header">
                    <h2>文章列表</h2>
                    <a href="/admin/article/edit" class="btn btn-primary">
                        <span>✏️</span> 写文章
                    </a>
                </div>

                <div class="panel-content">
                    <div class="search-bar">
                        <input type="text" id="keyword" placeholder="搜索文章标题或摘要">
                        <select id="categoryId">
                            <option value="">全部分类</option>
                        </select>
                        <button class="btn btn-info" onclick="searchArticles()">搜索</button>
                        <button class="btn btn-success" onclick="resetSearch()">重置</button>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>标题</th>
                                <th>分类</th>
                                <th>浏览量</th>
                                <th>评论数</th>
                                <th>状态</th>
                                <th>创建时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="articleTableBody">
                        </tbody>
                    </table>

                    <div class="pagination" id="pagination">
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        var currentPage = 1;
        var pageSize = 10;

        function searchArticles() {
            currentPage = 1;
            loadArticles();
        }

        function resetSearch() {
            document.getElementById('keyword').value = '';
            document.getElementById('categoryId').value = '';
            currentPage = 1;
            loadArticles();
        }

        function loadArticles() {
            var keyword = document.getElementById('keyword').value;
            var categoryId = document.getElementById('categoryId').value;

            fetch('/admin/article/data?keyword=' + encodeURIComponent(keyword) +
                  '&categoryId=' + categoryId +
                  '&pageNum=' + currentPage +
                  '&pageSize=' + pageSize)
                .then(response => response.json())
                .then(data => {
                    renderTable(data);
                    renderPagination(data);
                })
                .catch(error => {
                    console.error('加载文章失败:', error);
                });
        }

        function renderTable(data) {
            var tbody = document.getElementById('articleTableBody');
            tbody.innerHTML = '';

            if (data.data && data.data.length > 0) {
                data.data.forEach(function(article) {
                    var row = document.createElement('tr');
                    row.innerHTML = '<tr><td>' + article.id + '</td>' +
                        '<td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + (article.title || '') + '</td>' +
                        '<td>' + (article.categoryName || '-') + '</td>' +
                        '<td>' + (article.viewCount || 0) + '</td>' +
                        '<td>' + (article.commentCount || 0) + '</td>' +
                        '<td>' + (article.isTop == 1 ? '<span class="top-badge">置顶</span>' : '<span class="status-badge status-published">已发布</span>') + '</td>' +
                        '<td>' + formatDate(article.createTime) + '</td>' +
                        '<td><div class="table-actions">' +
                        '<a href="/admin/article/edit?id=' + article.id + '" class="btn btn-info" style="padding: 5px 10px; font-size: 12px;">编辑</a>' +
                        '<button onclick="deleteArticle(' + article.id + ')" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;">删除</button>' +
                        '</div></td></tr>';
                    tbody.appendChild(row);
                });
            } else {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: #909399;">暂无文章数据</td></tr>';
            }
        }

        function renderPagination(data) {
            var pagination = document.getElementById('pagination');
            pagination.innerHTML = '';

            if (!data || data.total <= pageSize) {
                return;
            }

            var totalPages = Math.ceil(data.total / pageSize);

            if (currentPage > 1) {
                pagination.innerHTML += `<a href="#" onclick="goPage(${currentPage - 1})">上一页</a>`;
            }

            for (var i = 1; i <= totalPages; i++) {
                if (i == currentPage) {
                    pagination.innerHTML += `<span class="active">${i}</span>`;
                } else {
                    pagination.innerHTML += `<a href="#" onclick="goPage(${i})">${i}</a>`;
                }
            }

            if (currentPage < totalPages) {
                pagination.innerHTML += `<a href="#" onclick="goPage(${currentPage + 1})">下一页</a>`;
            }

            pagination.innerHTML += `<span style="margin-left: 15px; color: #909399;">共 ${data.total} 条记录</span>`;
        }

        function goPage(page) {
            currentPage = page;
            loadArticles();
        }

        function deleteArticle(id) {
            if (confirm('确定要删除这篇文章吗？')) {
                fetch('/admin/article/delete?id=' + id, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    credentials: 'same-origin'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        alert('删除成功');
                        loadArticles();
                    } else {
                        alert('删除失败：' + data.message);
                    }
                })
                .catch(error => {
                    console.error('删除失败:', error);
                    alert('删除失败');
                });
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            var date = new Date(dateStr);
            return date.getFullYear() + '-' + 
                   String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                   String(date.getDate()).padStart(2, '0') + ' ' +
                   String(date.getHours()).padStart(2, '0') + ':' +
                   String(date.getMinutes()).padStart(2, '0');
        }

        window.onload = function() {
            loadArticles();
        };
    </script>
</body>
</html>