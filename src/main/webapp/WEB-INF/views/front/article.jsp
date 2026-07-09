<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${article.title} - ${siteName != null ? siteName : 'LELEO'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/article.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/widgets.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/settings.css?v=2026070802">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/responsive.css">
    <style>
        .bg-container video.bg-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
        }

        /* ===== 文章阅读模式 ===== */
        .article-detail {
            max-width: 800px;
            margin: 0 auto;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            padding: 40px 48px;
            backdrop-filter: blur(10px);
        }

        .article-header {
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border);
        }

        .article-title {
            font-size: 30px;
            font-weight: 700;
            color: var(--text);
            margin: 0 0 16px 0;
            line-height: 1.4;
            letter-spacing: 0.5px;
            text-shadow: 0 2px 12px rgba(0,0,0,0.3);
        }

        .article-meta {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            font-size: 13px;
            color: var(--muted);
        }

        .article-meta span {
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .article-meta .meta-icon {
            opacity: 0.6;
            font-size: 12px;
        }

        .category-link {
            color: var(--primary);
            text-decoration: none;
            transition: color 0.2s;
        }
        .category-link:hover {
            color: rgba(0,217,255,0.8);
            text-decoration: underline;
        }

        /* ===== 文章内容（阅读模式） ===== */
        .article-content {
            color: var(--text);
            line-height: 1.9;
            font-size: 16px;
            letter-spacing: 0.3px;
        }
        .article-content img {
            max-width: 100%;
            border-radius: 10px;
            margin: 20px 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }
        .article-content h1,
        .article-content h2,
        .article-content h3 {
            color: var(--text);
            margin: 28px 0 14px 0;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border);
            font-weight: 650;
        }
        .article-content h1 { font-size: 24px; }
        .article-content h2 { font-size: 20px; }
        .article-content h3 { font-size: 18px; }
        .article-content p {
            margin: 14px 0;
        }
        .article-content ul,
        .article-content ol {
            padding-left: 28px;
            margin: 14px 0;
        }
        .article-content li {
            margin: 8px 0;
        }
        .article-content blockquote {
            border-left: 4px solid var(--primary);
            padding: 16px 20px;
            margin: 20px 0;
            color: rgba(255,255,255,0.85);
            background: rgba(0,217,255,0.04);
            border-radius: 0 10px 10px 0;
            font-style: italic;
        }
        .article-content pre {
            background: rgba(0,0,0,0.4);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 16px 20px;
            overflow-x: auto;
            font-size: 14px;
            line-height: 1.6;
            margin: 16px 0;
        }
        .article-content code {
            background: rgba(0,0,0,0.3);
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.9em;
        }
        .article-content pre code {
            background: none;
            padding: 0;
        }
        .article-content a {
            color: var(--primary);
            text-decoration: underline;
            text-underline-offset: 2px;
        }
        .article-content table {
            width: 100%;
            border-collapse: collapse;
            margin: 16px 0;
        }
        .article-content th,
        .article-content td {
            border: 1px solid var(--border);
            padding: 10px 14px;
            text-align: left;
        }
        .article-content th {
            background: rgba(0,217,255,0.08);
        }

        /* ===== 标签 ===== */
        .article-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid var(--border);
        }
        .article-tag {
            font-size: 12px;
            color: var(--primary);
            background: rgba(0,217,255,0.1);
            padding: 5px 12px;
            border-radius: 20px;
            transition: all 0.2s;
            cursor: default;
        }
        .article-tag:hover {
            background: rgba(0,217,255,0.2);
        }

        /* ===== 评论区 ===== */
        .comments-section {
            margin-top: 36px;
            padding-top: 28px;
            border-top: 1px solid var(--border);
        }

        .comments-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text);
            margin: 0 0 20px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .comments-title .count-badge {
            font-size: 12px;
            font-weight: 500;
            color: var(--muted);
            background: rgba(255,255,255,0.06);
            padding: 2px 10px;
            border-radius: 12px;
        }

        /* -- 评论列表 -- */
        .comment-list {
            display: flex;
            flex-direction: column;
            gap: 0;
        }

        .comment-item {
            padding: 18px 0;
            border-bottom: 1px solid rgba(255,255,255,0.06);
        }
        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }
        .comment-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            flex-shrink: 0;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(0,217,255,0.25), rgba(255,107,157,0.25));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            color: var(--text);
        }
        .comment-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .comment-author {
            font-size: 13px;
            color: var(--text);
            font-weight: 500;
        }
        .comment-time {
            font-size: 11px;
            color: var(--muted);
            margin-left: auto;
        }
        .comment-content {
            font-size: 15px;
            color: var(--text);
            line-height: 1.7;
            padding-left: 46px;
        }
        .comment-actions {
            display: flex;
            gap: 12px;
            margin-top: 8px;
            padding-left: 46px;
        }
        .comment-action-btn {
            font-size: 12px;
            color: var(--muted);
            background: none;
            border: none;
            cursor: pointer;
            padding: 2px 6px;
            border-radius: 4px;
            transition: all 0.2s;
        }
        .comment-action-btn:hover {
            color: var(--primary);
            background: rgba(0,217,255,0.08);
        }

        /* -- 子评论（嵌套回复） -- */
        .comment-children {
            margin-left: 46px;
            margin-top: 12px;
            padding-left: 16px;
            border-left: 2px solid rgba(0,217,255,0.15);
        }
        .comment-children .comment-item {
            padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        .comment-children .comment-item:last-child {
            border-bottom: none;
        }
        .comment-children .comment-content {
            padding-left: 0;
        }
        .comment-children .comment-actions {
            padding-left: 0;
        }

        /* -- 回复表单（内联） -- */
        .reply-form {
            margin-top: 10px;
            padding-left: 46px;
            display: none;
        }
        .reply-form.active {
            display: block;
        }
        .reply-form .reply-input {
            width: 100%;
            padding: 10px 14px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text);
            font-size: 13px;
            resize: vertical;
            min-height: 60px;
            box-sizing: border-box;
        }
        .reply-form .reply-input:focus {
            outline: none;
            border-color: var(--primary);
        }
        .reply-form .reply-actions {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }
        .reply-form .reply-submit {
            padding: 6px 18px;
            background: rgba(0,217,255,0.15);
            border: 1px solid var(--primary);
            color: var(--primary);
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .reply-form .reply-submit:hover {
            background: rgba(0,217,255,0.25);
        }
        .reply-form .reply-cancel {
            padding: 6px 18px;
            background: transparent;
            border: 1px solid var(--border);
            color: var(--muted);
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .reply-form .reply-cancel:hover {
            background: rgba(255,255,255,0.05);
        }

        /* -- 无评论提示 -- */
        .no-comments {
            color: var(--muted);
            font-size: 13px;
            padding: 30px 0;
            text-align: center;
            background: rgba(255,255,255,0.02);
            border-radius: 10px;
        }

        /* -- 评论发表表单 -- */
        .comment-form {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }
        .comment-form-title {
            font-size: 15px;
            color: var(--text);
            margin-bottom: 12px;
            font-weight: 500;
        }
        .comment-input {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            font-size: 14px;
            resize: vertical;
            min-height: 90px;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        .comment-input:focus {
            outline: none;
            border-color: var(--primary);
        }
        .comment-form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
        }
        .comment-login-tip {
            font-size: 12px;
            color: var(--muted);
        }
        .comment-login-tip a {
            color: var(--primary);
            text-decoration: none;
        }
        .comment-login-tip a:hover {
            text-decoration: underline;
        }
        .comment-submit {
            padding: 9px 28px;
            background: linear-gradient(135deg, rgba(0,217,255,0.2), rgba(0,217,255,0.1));
            border: 1px solid var(--primary);
            color: var(--primary);
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 500;
        }
        .comment-submit:hover {
            background: rgba(0,217,255,0.25);
            transform: translateY(-1px);
        }
        .comment-submit:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .floating-music-player { position: fixed; bottom: 20px; right: 20px; z-index: 1000; }
        .floating-music-player .music-popup { top: auto; bottom: 90px; left: auto; right: 0; }

        /* ===== 响应式 ===== */
        @media (max-width: 768px) {
            .article-detail {
                padding: 20px 16px;
                border-radius: 12px;
            }
            .article-title {
                font-size: 22px;
            }
            .article-content {
                font-size: 15px;
            }
            .comment-children {
                margin-left: 20px;
                padding-left: 12px;
            }
            .comment-content {
                padding-left: 0;
            }
            .comment-actions {
                padding-left: 0;
            }
            .reply-form {
                padding-left: 0;
            }
        }
    </style>
</head>
<body>
    <div class="bg-container" id="bgContainer"></div>

    <nav class="navbar">
        <div class="navbar-brand" onclick="location.href='/'">BLOG</div>
        <div class="navbar-search">
            <input type="text" placeholder="搜索文章..." id="searchInput">
        </div>
        <div class="navbar-user">
            <a class="nav-action-btn" href="${pageContext.request.contextPath}/" title="返回首页">&#8962;</a>
            <div class="settings-btn" id="settingsBtn">&#9881;</div>
        </div>
    </nav>

    <div class="main-content">
        <div class="center-panel">
            <div class="article-detail">
                <!-- 文章头部 -->
                <div class="article-header">
                    <h1 class="article-title">${article.title}</h1>
                    <div class="article-meta">
                        <span><span class="meta-icon">&#9670;</span>分类：<a href="${pageContext.request.contextPath}/category/${category != null ? category.slug : ''}" class="category-link">${category != null ? category.name : '未分类'}</a></span>
                        <span><span class="meta-icon">&#128339;</span><fmt:formatDate value="${article.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                        <span><span class="meta-icon">&#128065;</span>${article.viewCount} 次阅读</span>
                        <c:if test="${article.commentCount != null}">
                            <span><span class="meta-icon">&#128172;</span>${article.commentCount} 条评论</span>
                        </c:if>
                    </div>
                </div>

                <!-- 文章内容 -->
                <div class="article-content">
                    ${article.content}
                </div>

                <!-- 标签 -->
                <c:if test="${article.tags != null && !article.tags.isEmpty()}">
                    <div class="article-tags">
                        <c:forEach items="${article.tags}" var="tag">
                            <span class="article-tag">${tag.name}</span>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- 评论区 -->
                <div class="comments-section">
                    <h3 class="comments-title">
                        评论
                        <span class="count-badge">${article.commentCount != null ? article.commentCount : 0}</span>
                    </h3>

                    <!-- 评论列表 -->
                    <div class="comment-list" id="commentList">
                        <c:choose>
                            <c:when test="${comments != null && !comments.isEmpty()}">
                                <c:forEach items="${comments}" var="comment">
                                    <div class="comment-item" data-comment-id="${comment.id}">
                                        <div class="comment-header">
                                            <div class="comment-avatar">
                                                <c:choose>
                                                    <c:when test="${comment.userAvatar != null && !comment.userAvatar.isEmpty()}">
                                                        <img src="${pageContext.request.contextPath}${comment.userAvatar}" alt="${comment.username}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${comment.username != null && comment.username.length() > 0 ? comment.username.substring(0,1) : '?'}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <span class="comment-author">${comment.username != null ? comment.username : '匿名用户'}</span>
                                            <span class="comment-time"><fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                        </div>
                                        <div class="comment-content">${comment.content}</div>
                                        <div class="comment-actions">
                                            <button class="comment-action-btn" onclick="toggleReplyForm(${comment.id})">&#128257; 回复</button>
                                        </div>

                                        <!-- 内联回复表单 -->
                                        <div class="reply-form" id="replyForm_${comment.id}">
                                            <textarea class="reply-input" id="replyInput_${comment.id}" placeholder="写下你的回复..."></textarea>
                                            <div class="reply-actions">
                                                <button class="reply-submit" onclick="submitReply(${comment.id}, ${article.id})">发表回复</button>
                                                <button class="reply-cancel" onclick="toggleReplyForm(${comment.id})">取消</button>
                                            </div>
                                        </div>

                                        <!-- 子评论（嵌套回复） -->
                                        <c:if test="${comment.children != null && !comment.children.isEmpty()}">
                                            <div class="comment-children">
                                                <c:forEach items="${comment.children}" var="child">
                                                    <div class="comment-item" data-comment-id="${child.id}">
                                                        <div class="comment-header">
                                                            <div class="comment-avatar">
                                                                <c:choose>
                                                                    <c:when test="${child.userAvatar != null && !child.userAvatar.isEmpty()}">
                                                                        <img src="${pageContext.request.contextPath}${child.userAvatar}" alt="${child.username}">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${child.username != null && child.username.length() > 0 ? child.username.substring(0,1) : '?'}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <span class="comment-author">${child.username != null ? child.username : '匿名用户'}</span>
                                                            <span class="comment-time"><fmt:formatDate value="${child.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                                        </div>
                                                        <div class="comment-content">${child.content}</div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-comments">暂无评论，快来发表第一条评论吧！</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 发表评论表单 -->
                    <form class="comment-form" id="commentForm" onsubmit="return false;">
                        <div class="comment-form-title">发表评论</div>
                        <textarea class="comment-input" id="commentContent" placeholder="写下你的评论...分享你的想法"></textarea>
                        <div class="comment-form-footer">
                            <span class="comment-login-tip" id="loginTip">
                                <c:if test="${sessionScope.user == null}">
                                    登录后即可评论，<a href="${pageContext.request.contextPath}/login">去登录</a>
                                </c:if>
                            </span>
                            <button type="button" class="comment-submit" id="commentSubmitBtn" onclick="submitComment()">发表评论</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="modalOverlay"></div>
    <div class="settings-modal" id="settingsModal">
        <div class="modal-header">
            <h3>设置</h3>
            <button class="modal-close" id="modalClose">&#215;</button>
        </div>
        <div class="tabs">
            <button class="tab active" data-tab="bg">背景设置</button>
            <button class="tab" data-tab="music">音乐播放</button>
        </div>
        <div class="settings-content">
            <div class="setting-section active" id="bg">
                <h5 style="color: var(--muted); font-size: 12px; margin: 0 0 10px; font-weight: normal;">系统背景</h5>
                <div class="preview-grid" id="systemBgGrid"></div>
                <h5 style="color: var(--muted); font-size: 12px; margin: 20px 0 10px; font-weight: normal;">我的背景</h5>
                <div class="preview-grid" id="localBgGrid">
                    <label class="preview-item" style="background: rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; font-size: 24px; cursor: pointer;"
                           title="上传自定义背景" onclick="document.getElementById('bgUpload').click()">
                        &#128194;
                    </label>
                </div>
                <input type="file" id="bgUpload" accept="image/*,video/mp4" style="display: none;" onchange="uploadBackground(this)">
                <p style="font-size: 11px; color: var(--muted); margin-top: 10px;">支持 JPG、PNG、GIF、MP4 格式，最大 20MB</p>
            </div>
            <div class="setting-section" id="music">
                <h4>音乐播放列表</h4>
                <button class="music-upload-btn" onclick="document.getElementById('musicUpload').click()">+ 添加音乐</button>
                <input type="file" id="musicUpload" accept="audio/*" style="display: none;" onchange="uploadMusic(this)">
                <div class="music-list" id="musicSettingsList">
                    <c:forEach items="${musicList}" var="music">
                        <div class="music-item" data-id="${music.id}" data-url="${pageContext.request.contextPath}${music.url}">
                            <div class="music-item-title">${music.title}</div>
                            <button class="music-delete-btn" onclick="deleteMusic(${music.id}, this)">删除</button>
                        </div>
                    </c:forEach>
                </div>
                <p style="font-size: 11px; color: var(--muted); margin-top: 10px;">支持 MP3、WAV、OGG、FLAC 格式，最大 50MB</p>
            </div>
        </div>
    </div>

    <script>
        var contextPath = '${pageContext.request.contextPath}';
        var articleId = ${article.id};
        var isLoggedIn = ${sessionScope.user != null ? 'true' : 'false'};

        /**
         * 提交评论
         */
        function submitComment() {
            if (!isLoggedIn) {
                alert('请先登录后再发表评论');
                window.location.href = contextPath + '/login';
                return;
            }

            var content = document.getElementById('commentContent').value.trim();
            if (!content) {
                alert('请输入评论内容');
                return;
            }

            var btn = document.getElementById('commentSubmitBtn');
            btn.disabled = true;
            btn.textContent = '提交中...';

            var xhr = new XMLHttpRequest();
            xhr.open('POST', contextPath + '/api/comment', true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.onload = function() {
                btn.disabled = false;
                btn.textContent = '发表评论';
                if (xhr.status === 200) {
                    var result = JSON.parse(xhr.responseText);
                    if (result.code === 200) {
                        // 评论成功，刷新页面显示新评论
                        alert('评论成功！');
                        document.getElementById('commentContent').value = '';
                        location.reload();
                    } else {
                        alert(result.message || '评论失败');
                    }
                } else if (xhr.status === 401) {
                    alert('登录已过期，请重新登录');
                    window.location.href = contextPath + '/login';
                } else {
                    alert('评论失败，请稍后重试');
                }
            };
            xhr.onerror = function() {
                btn.disabled = false;
                btn.textContent = '发表评论';
                alert('网络错误，请稍后重试');
            };
            xhr.send(JSON.stringify({articleId: articleId, content: content}));
        }

        /**
         * 切换回复表单显示
         */
        function toggleReplyForm(commentId) {
            var form = document.getElementById('replyForm_' + commentId);
            if (form) {
                form.classList.toggle('active');
                if (form.classList.contains('active')) {
                    document.getElementById('replyInput_' + commentId).focus();
                }
            }
        }

        /**
         * 提交回复
         */
        function submitReply(parentId, articleId) {
            if (!isLoggedIn) {
                alert('请先登录后再回复');
                window.location.href = contextPath + '/login';
                return;
            }

            var content = document.getElementById('replyInput_' + parentId).value.trim();
            if (!content) {
                alert('请输入回复内容');
                return;
            }

            var btn = document.querySelector('#replyForm_' + parentId + ' .reply-submit');
            btn.disabled = true;
            btn.textContent = '提交中...';

            var xhr = new XMLHttpRequest();
            xhr.open('POST', contextPath + '/api/comment', true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.onload = function() {
                btn.disabled = false;
                btn.textContent = '发表回复';
                if (xhr.status === 200) {
                    var result = JSON.parse(xhr.responseText);
                    if (result.code === 200) {
                        alert('回复成功！');
                        location.reload();
                    } else {
                        alert(result.message || '回复失败');
                    }
                } else if (xhr.status === 401) {
                    alert('登录已过期，请重新登录');
                    window.location.href = contextPath + '/login';
                } else {
                    alert('回复失败，请稍后重试');
                }
            };
            xhr.onerror = function() {
                btn.disabled = false;
                btn.textContent = '发表回复';
                alert('网络错误，请稍后重试');
            };
            xhr.send(JSON.stringify({articleId: articleId, content: content, parentId: parentId}));
        }
    </script>

    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070801"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/search.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=20250101"></script>
</body>
</html>