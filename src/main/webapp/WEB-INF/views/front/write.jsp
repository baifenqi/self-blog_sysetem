<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>写博客 - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/front.css">
    <style>
        .write-container {
            max-width: 900px;
            margin: 80px auto 40px;
            padding: 0 20px;
        }
        .write-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .write-header h1 {
            font-size: 28px;
            background: linear-gradient(135deg, #00d9ff, #ff6b9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .write-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 40px;
            backdrop-filter: blur(10px);
        }
        .form-group {
            margin-bottom: 24px;
        }
        .form-group label {
            display: block;
            color: rgba(255,255,255,0.85);
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
        }
        .form-group label .required {
            color: #ff6b6b;
        }
        .form-group input[type="text"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
            transition: all 0.3s;
        }
        .form-group input[type="text"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #00d9ff;
            box-shadow: 0 0 15px rgba(0,217,255,0.15);
        }
        .form-group select {
            cursor: pointer;
        }
        .form-group select option {
            background: #1a1a2e;
            color: #fff;
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
        .form-group textarea.editor-area {
            font-family: 'Fira Code', 'Monaco', 'Consolas', monospace;
            font-size: 14px;
            line-height: 1.8;
            min-height: 400px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }
        .btn-primary {
            background: linear-gradient(135deg, #00d9ff, #00a8cc);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,217,255,0.4);
        }
        .btn-secondary {
            background: rgba(255,255,255,0.08);
            color: rgba(255,255,255,0.8);
            margin-left: 15px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        .btn-secondary:hover {
            background: rgba(255,255,255,0.12);
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
            accent-color: #00d9ff;
        }
        .checkbox-group label {
            margin-bottom: 0;
            cursor: pointer;
            color: rgba(255,255,255,0.85);
        }
        .toast {
            position: fixed;
            top: 80px;
            left: 50%;
            transform: translateX(-50%);
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-size: 14px;
            z-index: 9999;
            display: none;
            backdrop-filter: blur(10px);
        }
        .toast.success {
            background: rgba(39, 174, 96, 0.9);
        }
        .toast.error {
            background: rgba(231, 76, 60, 0.9);
        }
        .char-count {
            text-align: right;
            color: rgba(255,255,255,0.4);
            font-size: 12px;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <div class="bg-container"></div>

    <nav class="navbar">
        <div class="navbar-brand" onclick="location.href='/'">${siteName != null ? siteName : 'LELEO'}</div>
        <div class="navbar-search">
            <input type="text" placeholder="搜索文章..." id="searchInput">
        </div>
        <div class="navbar-user">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="navbar-avatar" title="点击进入个人信息页"
                         onclick="location.href='/user/profile'"></div>
                </c:when>
                <c:otherwise>
                    <div class="navbar-avatar" title="点击登录"
                         onclick="location.href='/login'"></div>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <div class="write-container">
        <div class="write-header">
            <h1>✏️ 写博客</h1>
            <div>
                <button onclick="saveArticle()" class="btn btn-primary">发布文章</button>
                <a href="/" class="btn btn-secondary">返回首页</a>
            </div>
        </div>

        <div class="write-card">
            <form id="articleForm">
                <div class="form-group">
                    <label for="title">文章标题 <span class="required">*</span></label>
                    <input type="text" id="title" placeholder="请输入文章标题" required maxlength="200">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="slug">文章别名</label>
                        <input type="text" id="slug" placeholder="用于URL路径，可选（留空自动生成）">
                    </div>
                    <div class="form-group">
                        <label for="categoryId">分类 <span class="required">*</span></label>
                        <select id="categoryId" required>
                            <option value="">请选择分类</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="summary">文章摘要</label>
                    <textarea id="summary" placeholder="请输入文章摘要（可选）" rows="3" maxlength="500"></textarea>
                    <div class="char-count"><span id="summaryCount">0</span>/500</div>
                </div>

                <div class="form-group">
                    <label for="coverImage">封面图片URL</label>
                    <input type="text" id="coverImage" placeholder="请输入封面图片URL（可选）">
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="isTop">
                        <label for="isTop">置顶文章</label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="content">文章内容 <span class="required">*</span></label>
                    <textarea id="content" class="editor-area" placeholder="请输入文章内容，支持Markdown格式..." required></textarea>
                </div>
            </form>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        // 摘要字数统计
        document.getElementById('summary').addEventListener('input', function() {
            document.getElementById('summaryCount').textContent = this.value.length;
        });

        // 显示提示消息
        function showToast(message, type) {
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + (type || 'success');
            toast.style.display = 'block';
            setTimeout(function() {
                toast.style.display = 'none';
            }, 3000);
        }

        function saveArticle() {
            var form = document.getElementById('articleForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            var article = {
                title: document.getElementById('title').value.trim(),
                slug: document.getElementById('slug').value.trim() || null,
                summary: document.getElementById('summary').value.trim() || null,
                content: document.getElementById('content').value,
                coverImage: document.getElementById('coverImage').value.trim() || null,
                categoryId: document.getElementById('categoryId').value ? parseInt(document.getElementById('categoryId').value) : null,
                isTop: document.getElementById('isTop').checked ? 1 : 0
            };

            fetch('/article/write/save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(article),
                credentials: 'same-origin'
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.code === 200) {
                    showToast('文章发布成功！即将跳转到首页...', 'success');
                    setTimeout(function() {
                        window.location.href = '/';
                    }, 1500);
                } else if (data.code === 401) {
                    showToast('请先登录后再发布文章', 'error');
                    setTimeout(function() {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    showToast('发布失败：' + data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('保存失败:', error);
                showToast('发布失败，请稍后重试', 'error');
            });
        }

        // 快捷键：Ctrl+Enter 发布文章
        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                e.preventDefault();
                saveArticle();
            }
        });
    </script>
</body>
</html>