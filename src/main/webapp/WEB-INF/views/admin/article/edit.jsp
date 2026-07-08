<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${article != null ? '编辑文章' : '写文章'} - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
    <style>
        .article-form {
            max-width: 900px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #303133;
        }
        .form-group input[type="text"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e4e7ed;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .form-group input[type="text"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102,126,234,0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
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
        .btn-secondary {
            background: #f5f7fa;
            color: #606266;
            margin-left: 15px;
        }
        .btn-secondary:hover {
            background: #e4e7ed;
        }
        .tag-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        .tag-item {
            padding: 6px 14px;
            background: #ecf5ff;
            color: #409eff;
            border-radius: 20px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s;
            border: 1px solid transparent;
        }
        .tag-item:hover {
            background: #dbeafe;
        }
        .tag-item.selected {
            background: #667eea;
            color: white;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        .checkbox-group label {
            margin-bottom: 0;
            cursor: pointer;
        }
        .header-actions {
            display: flex;
            gap: 15px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .page-header h2 {
            font-size: 22px;
            color: #303133;
        }
        .editor-textarea {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', monospace;
            font-size: 14px;
            line-height: 1.8;
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

        <main class="main-content">
            <header class="content-header">
                <h1>${article != null ? '编辑文章' : '写文章'}</h1>
                <div class="user-info">
                    欢迎，<strong>${sessionScope.loginUser.nickname}</strong>
                </div>
            </header>

            <div class="panel">
                <div class="page-header">
                    <h2>文章内容</h2>
                    <div class="header-actions">
                        <button onclick="saveArticle()" class="btn btn-primary">
                            <span>💾</span> ${article != null ? '更新文章' : '发布文章'}
                        </button>
                        <a href="/admin/article/list" class="btn btn-secondary">
                            <span>←</span> 返回列表
                        </a>
                    </div>
                </div>

                <div class="panel-content">
                    <form id="articleForm" class="article-form">
                        <input type="hidden" id="id" value="${article != null ? article.id : ''}">
                        
                        <div class="form-group">
                            <label for="title">文章标题 <span style="color: #f56c6c;">*</span></label>
                            <input type="text" id="title" value="${article != null ? article.title : ''}" 
                                   placeholder="请输入文章标题" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="slug">文章别名</label>
                                <input type="text" id="slug" value="${article != null ? article.slug : ''}" 
                                       placeholder="用于URL路径，可选">
                            </div>
                            <div class="form-group">
                                <label for="categoryId">分类 <span style="color: #f56c6c;">*</span></label>
                                <select id="categoryId" required>
                                    <option value="">请选择分类</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.id}" 
                                                ${article != null && article.categoryId == category.id ? 'selected' : ''}>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="summary">文章摘要</label>
                            <textarea id="summary" placeholder="请输入文章摘要（可选）" rows="3"><c:if test="${article != null}">${article.summary}</c:if></textarea>
                        </div>

                        <div class="form-group">
                            <label for="coverImage">封面图片</label>
                            <input type="text" id="coverImage" value="${article != null ? article.coverImage : ''}" 
                                   placeholder="请输入封面图片URL">
                        </div>

                        <div class="form-group">
                            <label>选择标签</label>
                            <div class="tag-list" id="tagList">
                                <c:forEach items="${tags}" var="tag">
                                        <span class="tag-item"
                                              onclick="toggleTag(${tag.id})" data-id="${tag.id}">
                                            ${tag.name}
                                        </span>
                                    </c:forEach>
                            </div>
                            <input type="hidden" id="tagIds">
                        </div>

                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="isTop" ${article != null && article.isTop == 1 ? 'checked' : ''}>
                                <label for="isTop">置顶文章</label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="content">文章内容 <span style="color: #f56c6c;">*</span></label>
                            <textarea id="content" class="editor-textarea" placeholder="请输入文章内容（支持Markdown格式）" rows="25" required><c:if test="${article != null}">${article.content}</c:if></textarea>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        var selectedTagIds = [];

        <c:if test="${article != null && article.tags != null}">
            <c:forEach items="${article.tags}" var="tag">
                selectedTagIds.push(${tag.id});
            </c:forEach>
        </c:if>

        function toggleTag(tagId) {
            var index = selectedTagIds.indexOf(tagId);
            var tagItem = document.querySelector('.tag-item[data-id="' + tagId + '"]');
            
            if (index > -1) {
                selectedTagIds.splice(index, 1);
                tagItem.classList.remove('selected');
            } else {
                selectedTagIds.push(tagId);
                tagItem.classList.add('selected');
            }
        }

        function initSelectedTags() {
            selectedTagIds.forEach(function(tagId) {
                var tagItem = document.querySelector('.tag-item[data-id="' + tagId + '"]');
                if (tagItem) {
                    tagItem.classList.add('selected');
                }
            });
        }

        function saveArticle() {
            var form = document.getElementById('articleForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            var article = {
                id: document.getElementById('id').value || null,
                title: document.getElementById('title').value,
                slug: document.getElementById('slug').value || null,
                summary: document.getElementById('summary').value || null,
                content: document.getElementById('content').value,
                coverImage: document.getElementById('coverImage').value || null,
                categoryId: document.getElementById('categoryId').value ? parseInt(document.getElementById('categoryId').value) : null,
                isTop: document.getElementById('isTop').checked ? 1 : 0
            };

            var tagIds = selectedTagIds.length > 0 ? selectedTagIds : null;

            var url = '/admin/article/save';
            if (tagIds) {
                url += '?tagIds=' + tagIds.join('&tagIds=');
            }

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(article),
                credentials: 'same-origin'
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('保存成功');
                    window.location.href = '/admin/article/list';
                } else {
                    alert('保存失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('保存失败:', error);
                alert('保存失败，请稍后重试');
            });
        }

        window.onload = function() {
            initSelectedTags();
        };
    </script>
</body>
</html>