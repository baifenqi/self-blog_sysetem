<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>写博客 - ${siteName != null ? siteName : 'LELEO'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/widgets.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/settings.css?v=2026070901">
    <style>
        .write-container {
            max-width: 900px;
            margin: 80px auto 40px;
            padding: 30px;
            background: rgba(10,10,20,0.7);
            border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
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
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 40px;
        }
        .form-group {
            margin-bottom: 24px;
        }
        .form-group label {
            display: block;
            color: var(--text);
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
            background: rgba(20,20,40,0.75);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px;
            color: var(--text);
            font-size: 14px;
            font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        .form-group input[type="text"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(0,217,255,0.15);
        }

        .preview-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.95);
            width: 90%;
            max-width: 900px;
            max-height: 85vh;
            background: rgba(10,10,20,0.9);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }
        .preview-modal.active {
            opacity: 1;
            visibility: visible;
            transform: translate(-50%, -50%) scale(1);
        }
        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .preview-close {
            background: none;
            border: none;
            color: var(--muted);
            font-size: 24px;
            cursor: pointer;
            transition: color 0.3s;
        }
        .preview-close:hover {
            color: var(--text);
        }
        .preview-body {
            padding: 24px;
            overflow-y: auto;
            flex: 1;
        }
        #previewOverlay {
            z-index: 999;
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
            color: var(--text);
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
            color: var(--muted);
            font-size: 12px;
            margin-top: 4px;
        }
        .bg-container video.bg-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
        }
        .floating-music-player { position: fixed; bottom: 20px; right: 20px; z-index: 1000; }
        .floating-music-player .music-popup { top: auto; bottom: 90px; left: auto; right: 0; }

        .btn-sm { padding: 6px 14px; font-size: 13px; }
        .btn-danger { background: rgba(231,76,60,0.8); color: #fff; }
        .btn-danger:hover { background: rgba(231,76,60,1); }
        .tag-select-area { display: flex; flex-wrap: wrap; gap: 8px; min-height: 36px; align-items: center; }
        .tag-chip {
            display: inline-block; padding: 4px 14px; border-radius: 20px; font-size: 13px;
            border: 1px solid; cursor: pointer; transition: all 0.2s; background: transparent;
            user-select: none;
        }
        .tag-chip.active {
            background: currentColor !important;
            color: #fff !important;
        }
        .tag-chip:hover { opacity: 0.8; }

        .mgr-modal {
            position: fixed; top: 50%; left: 50%; transform: translate(-50%,-50%) scale(0.95);
            width: 90%; max-width: 600px; max-height: 80vh;
            background: rgba(15,15,30,0.95); border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px; z-index: 1000; opacity: 0; visibility: hidden;
            transition: all 0.3s ease; display: flex; flex-direction: column;
        }
        .mgr-modal.active { opacity: 1; visibility: visible; transform: translate(-50%,-50%) scale(1); }
        .mgr-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .mgr-header h3 { margin: 0; font-size: 16px; }
        .mgr-close { background: none; border: none; color: var(--muted); font-size: 24px; cursor: pointer; }
        .mgr-close:hover { color: var(--text); }
        .mgr-body { padding: 20px 24px; overflow-y: auto; flex: 1; }
        .mgr-add-form { display: flex; gap: 8px; margin-bottom: 16px; }
        .mgr-add-form input, .mgr-add-form select { flex: 1; padding: 8px 12px; background: rgba(20,20,40,0.8); border: 1px solid rgba(255,255,255,0.15); border-radius: 8px; color: var(--text); font-size: 13px; }
        .mgr-add-form input:focus, .mgr-add-form select:focus { outline: none; border-color: var(--primary); }
        .mgr-item { display: flex; justify-content: space-between; align-items: center; padding: 10px 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .mgr-item:last-child { border-bottom: none; }
        .mgr-item-info { flex: 1; }
        .mgr-item-name { font-size: 14px; color: var(--text); }
        .mgr-item-count { font-size: 11px; color: var(--muted); margin-left: 8px; }
        .mgr-item-actions { display: flex; gap: 6px; }
        .mgr-item-actions button { padding: 4px 10px; font-size: 12px; border: none; border-radius: 6px; cursor: pointer; transition: all 0.2s; }
        .mgr-item-edit-btn { background: rgba(0,217,255,0.15); color: var(--primary); }
        .mgr-item-edit-btn:hover { background: rgba(0,217,255,0.3); }
        .mgr-item-del-btn { background: rgba(231,76,60,0.15); color: #e74c3c; }
        .mgr-item-del-btn:hover { background: rgba(231,76,60,0.3); }
        .mgr-empty { text-align: center; color: var(--muted); padding: 30px; font-size: 14px; }
        .mgr-overlay { z-index: 999; }
    </style>
</head>
<body>
    <div class="bg-container" id="bgContainer"></div>

    <nav class="navbar">
        <div class="navbar-brand" onclick="location.href='/'">${siteName != null ? siteName : 'LELEO'}</div>
        <div class="navbar-search">
            <input type="text" placeholder="搜索文章..." id="searchInput">
        </div>
        <div class="navbar-user">
            <div class="settings-btn" id="settingsBtn">&#9881;</div>
        </div>
    </nav>

    <div class="write-container">
        <div class="write-header">
            <h1><c:choose><c:when test="${article != null}">✏️ 编辑文章</c:when><c:otherwise>✏️ 写博客</c:otherwise></c:choose></h1>
            <div>
                <button onclick="previewArticle()" class="btn btn-secondary" style="margin-right:8px;">预览</button>
                <button onclick="saveDraft()" class="btn btn-secondary" style="margin-right:8px;background:rgba(255,193,7,0.15);border-color:rgba(255,193,7,0.3);color:#ffc107;">保存草稿</button>
                <button onclick="saveArticle()" class="btn btn-primary">发布文章</button>
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">返回首页</a>
            </div>
        </div>

        <div class="write-card">
            <form id="articleForm">
                <c:if test="${article != null}">
                    <input type="hidden" id="articleId" value="${article.id}">
                </c:if>
                <div class="form-group">
                    <label for="title">文章标题 <span class="required">*</span></label>
                    <input type="text" id="title" placeholder="请输入文章标题" required maxlength="200" value="${article != null ? article.title : ''}">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="slug">文章别名</label>
                        <input type="text" id="slug" placeholder="用于URL路径，可选（留空自动生成）" value="${article != null ? article.slug : ''}">
                    </div>
                    <div class="form-group">
                        <label for="categoryId">分类 <span class="required">*</span></label>
                        <div style="display:flex;gap:8px;">
                            <select id="categoryId" required style="flex:1;">
                                <option value="">请选择分类</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.id}" ${article != null && article.categoryId == category.id ? 'selected' : ''}>${category.name}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="btn btn-sm btn-secondary" onclick="openCategoryManager()" style="white-space:nowrap;">📁 管理</button>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="summary">文章摘要</label>
                    <textarea id="summary" placeholder="请输入文章摘要（可选）" rows="3" maxlength="500">${article != null ? article.summary : ''}</textarea>
                    <div class="char-count"><span id="summaryCount">0</span>/500</div>
                </div>

                <div class="form-group">
                    <label for="coverImage">封面图片URL</label>
                    <input type="text" id="coverImage" placeholder="请输入封面图片URL（可选）" value="${article != null ? article.coverImage : ''}">
                </div>

                <div class="form-group">
                    <label>标签</label>
                    <div class="tag-select-area" id="tagSelectArea">
                        <c:forEach items="${tags}" var="tag">
                            <span class="tag-chip" data-id="${tag.id}" style="border-color: ${tag.color}; color: ${tag.color}" onclick="toggleTagChip(this)">${tag.name}</span>
                        </c:forEach>
                    </div>
                    <div style="margin-top: 8px;">
                        <button type="button" class="btn btn-sm btn-secondary" onclick="openTagManager()">🏷️ 管理标签</button>
                    </div>
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="isTop" ${article != null && article.isTop == 1 ? 'checked' : ''}>
                        <label for="isTop">置顶文章</label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="content">文章内容 <span class="required">*</span></label>
                    <textarea id="content" class="editor-area" placeholder="请输入文章内容，支持Markdown格式..." required>${article != null ? article.content : ''}</textarea>
                </div>
            </form>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <div class="modal-overlay" id="previewOverlay" onclick="closePreview()"></div>
    <div class="preview-modal" id="previewModal">
        <div class="preview-header">
            <h3 style="margin:0;font-size:16px;">文章预览</h3>
            <button class="preview-close" onclick="closePreview()">&#215;</button>
        </div>
        <div class="preview-body">
            <div class="article-detail" style="max-width:800px;margin:0 auto;background:var(--card);border:1px solid var(--border);border-radius:12px;padding:24px;">
                <div class="article-header" style="margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid var(--border);">
                    <h1 id="previewTitle" style="font-size:28px;color:var(--text);margin:0 0 12px 0;line-height:1.4;"></h1>
                    <div style="display:flex;align-items:center;gap:16px;font-size:12px;color:var(--muted);">
                        <span>分类：<span id="previewCategory"></span></span>
                        <span>发布时间：<span id="previewDate"></span></span>
                    </div>
                </div>
                <img id="previewCover" style="max-width:100%;border-radius:8px;margin:0 0 16px 0;display:none;" alt="封面">
                <div id="previewSummary" style="font-size:14px;color:var(--muted);line-height:1.6;margin-bottom:16px;padding:12px 16px;background:rgba(0,217,255,0.05);border-radius:8px;border-left:3px solid var(--primary);display:none;"></div>
                <div id="previewContent" style="color:var(--text);line-height:1.8;font-size:16px;"></div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="modalOverlay"></div>

    <!-- 标签管理弹窗 -->
    <div class="modal-overlay mgr-overlay" id="tagMgrOverlay" onclick="closeTagManager()"></div>
    <div class="mgr-modal" id="tagMgrModal">
        <div class="mgr-header">
            <h3>🏷️ 标签管理</h3>
            <button class="mgr-close" onclick="closeTagManager()">&#215;</button>
        </div>
        <div class="mgr-body">
            <div class="mgr-add-form">
                <input type="text" id="tagInput" placeholder="标签名称" maxlength="50">
                <select id="tagColorSelect">
                    <option value="#00d9ff">青色</option>
                    <option value="#ff6b9d">粉色</option>
                    <option value="#ffd93d">黄色</option>
                    <option value="#6bcbff">蓝色</option>
                    <option value="#a29bfe">紫色</option>
                    <option value="#55efc4">绿色</option>
                    <option value="#fd79a8">玫红</option>
                    <option value="#ffa502">橙色</option>
                </select>
                <button class="btn btn-primary" onclick="saveTag()" style="padding:8px 20px;font-size:13px;white-space:nowrap;">新建</button>
            </div>
            <div id="tagList"></div>
        </div>
    </div>

    <!-- 分类管理弹窗 -->
    <div class="modal-overlay mgr-overlay" id="catMgrOverlay" onclick="closeCategoryManager()"></div>
    <div class="mgr-modal" id="catMgrModal">
        <div class="mgr-header">
            <h3>📁 分类管理</h3>
            <button class="mgr-close" onclick="closeCategoryManager()">&#215;</button>
        </div>
        <div class="mgr-body">
            <div class="mgr-add-form">
                <input type="text" id="catInput" placeholder="分类名称" maxlength="50">
                <input type="text" id="catSlugInput" placeholder="别名（URL路径）" maxlength="50">
                <button class="btn btn-primary" onclick="saveCategory()" style="padding:8px 20px;font-size:13px;white-space:nowrap;">新建</button>
            </div>
            <div id="categoryList"></div>
        </div>
    </div>

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
                        &#128193;
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

        document.getElementById('summary').addEventListener('input', function() {
            document.getElementById('summaryCount').textContent = this.value.length;
        });

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            // 更新摘要字数
            document.getElementById('summaryCount').textContent = document.getElementById('summary').value.length;

            // 编辑模式：回填标签选中状态
            <c:if test="${article != null && article.tags != null}">
                var selectedTagIds = [
                    <c:forEach items="${article.tags}" var="tag" varStatus="status">
                        ${tag.id}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ];
                document.querySelectorAll('.tag-chip').forEach(function(chip) {
                    var tagId = parseInt(chip.getAttribute('data-id'));
                    if (selectedTagIds.indexOf(tagId) !== -1) {
                        chip.classList.add('active');
                    }
                });
            </c:if>
        });

        function showToast(message, type) {
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + (type || 'success');
            toast.style.display = 'block';
            setTimeout(function() {
                toast.style.display = 'none';
            }, 3000);
        }

        function getArticleData() {
            var articleIdEl = document.getElementById('articleId');
            return {
                id: articleIdEl ? parseInt(articleIdEl.value) : null,
                title: document.getElementById('title').value.trim(),
                slug: document.getElementById('slug').value.trim() || null,
                summary: document.getElementById('summary').value.trim() || null,
                content: document.getElementById('content').value,
                coverImage: document.getElementById('coverImage').value.trim() || null,
                categoryId: document.getElementById('categoryId').value ? parseInt(document.getElementById('categoryId').value) : null,
                tagIds: getSelectedTagIds(),
                isTop: document.getElementById('isTop').checked ? 1 : 0
            };
        }

        function saveArticle() {
            var form = document.getElementById('articleForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            var article = getArticleData();

            fetch(contextPath + '/article/write/save?status=1', {
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

        function saveDraft() {
            var title = document.getElementById('title').value.trim();
            if (!title) {
                showToast('请输入文章标题后再保存草稿', 'error');
                return;
            }

            var article = getArticleData();

            fetch(contextPath + '/article/write/save?status=0', {
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
                    // 如果是新草稿，更新页面上的ID
                    var articleIdEl = document.getElementById('articleId');
                    if (!articleIdEl && data.data) {
                        var hiddenInput = document.createElement('input');
                        hiddenInput.type = 'hidden';
                        hiddenInput.id = 'articleId';
                        hiddenInput.value = data.data;
                        document.getElementById('articleForm').insertBefore(hiddenInput, document.getElementById('articleForm').firstChild);
                    }
                    showToast('草稿已保存！', 'success');
                } else if (data.code === 401) {
                    showToast('请先登录后再保存草稿', 'error');
                    setTimeout(function() {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    showToast('保存失败：' + data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('保存草稿失败:', error);
                showToast('保存失败，请稍后重试', 'error');
            });
        }

        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                e.preventDefault();
                saveArticle();
            }
        });

        function previewArticle() {
            var title = document.getElementById('title').value.trim() || '无标题';
            var content = document.getElementById('content').value;
            var categorySelect = document.getElementById('categoryId');
            var categoryName = categorySelect.options[categorySelect.selectedIndex].text;
            if (categorySelect.value === '') categoryName = '未分类';
            var summary = document.getElementById('summary').value.trim();
            var coverImage = document.getElementById('coverImage').value.trim();

            var now = new Date();
            var dateStr = now.getFullYear() + '-' + String(now.getMonth()+1).padStart(2,'0') + '-' + String(now.getDate()).padStart(2,'0') + ' ' + String(now.getHours()).padStart(2,'0') + ':' + String(now.getMinutes()).padStart(2,'0');

            document.getElementById('previewTitle').textContent = title;
            document.getElementById('previewCategory').textContent = categoryName;
            document.getElementById('previewDate').textContent = dateStr;
            document.getElementById('previewContent').innerHTML = content.replace(/\n/g, '<br>');

            var coverEl = document.getElementById('previewCover');
            if (coverImage) {
                coverEl.src = coverImage;
                coverEl.style.display = 'block';
            } else {
                coverEl.style.display = 'none';
            }

            var summaryEl = document.getElementById('previewSummary');
            if (summary) {
                summaryEl.textContent = summary;
                summaryEl.style.display = 'block';
            } else {
                summaryEl.style.display = 'none';
            }

            document.getElementById('previewModal').classList.add('active');
            document.getElementById('previewOverlay').classList.add('active');
        }

        function closePreview() {
            document.getElementById('previewModal').classList.remove('active');
            document.getElementById('previewOverlay').classList.remove('active');
        }

        function getSelectedTagIds() {
            var ids = [];
            document.querySelectorAll('.tag-chip.active').forEach(function(el) {
                ids.push(parseInt(el.getAttribute('data-id')));
            });
            return ids;
        }

        function toggleTagChip(el) {
            el.classList.toggle('active');
        }

        // ====== 标签管理 ======
        function openTagManager() {
            document.getElementById('tagMgrModal').classList.add('active');
            document.getElementById('tagMgrOverlay').classList.add('active');
            loadTagList();
        }
        function closeTagManager() {
            document.getElementById('tagMgrModal').classList.remove('active');
            document.getElementById('tagMgrOverlay').classList.remove('active');
        }
        function loadTagList() {
            fetch(contextPath + '/admin/tag/list')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    var html = '';
                    if (data.length === 0) {
                        html = '<div class="mgr-empty">暂无标签，请新建</div>';
                    } else {
                        data.forEach(function(t) {
                            html += '<div class="mgr-item">' +
                                '<div class="mgr-item-info">' +
                                '<span class="mgr-item-name" style="color:' + t.color + '">' + escapeHtml(t.name) + '</span>' +
                                '<span class="mgr-item-count">' + (t.articleCount || 0) + ' 篇文章</span>' +
                                '</div>' +
                                '<div class="mgr-item-actions">' +
                                '<button class="mgr-item-edit-btn" onclick="editTag(' + t.id + ',\'' + escapeHtml(t.name) + '\',\'' + t.color + '\')">编辑</button>' +
                                '<button class="mgr-item-del-btn" onclick="deleteTag(' + t.id + ')">删除</button>' +
                                '</div></div>';
                        });
                    }
                    document.getElementById('tagList').innerHTML = html;
                });
        }
        var editingTagId = null;
        function editTag(id, name, color) {
            editingTagId = id;
            document.getElementById('tagInput').value = name;
            document.getElementById('tagColorSelect').value = color;
            document.querySelector('#tagMgrModal .btn-primary').textContent = '保存';
        }
        function saveTag() {
            var name = document.getElementById('tagInput').value.trim();
            var color = document.getElementById('tagColorSelect').value;
            if (!name) { showToast('请输入标签名称', 'error'); return; }
            var body = { name: name, color: color };
            if (editingTagId) body.id = editingTagId;
            fetch(contextPath + '/admin/tag/save', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    showToast(editingTagId ? '标签已更新' : '标签已创建', 'success');
                    document.getElementById('tagInput').value = '';
                    editingTagId = null;
                    document.querySelector('#tagMgrModal .btn-primary').textContent = '新建';
                    loadTagList();
                    refreshTagChips();
                } else {
                    showToast(data.msg || '操作失败', 'error');
                }
            });
        }
        function deleteTag(id) {
            if (!confirm('确定要删除这个标签吗？')) return;
            fetch(contextPath + '/admin/tag/delete?id=' + id, { method: 'POST' })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    showToast('标签已删除', 'success');
                    loadTagList();
                    refreshTagChips();
                } else {
                    showToast(data.msg || '删除失败', 'error');
                }
            });
        }

        // ====== 分类管理 ======
        function openCategoryManager() {
            document.getElementById('catMgrModal').classList.add('active');
            document.getElementById('catMgrOverlay').classList.add('active');
            loadCategoryList();
        }
        function closeCategoryManager() {
            document.getElementById('catMgrModal').classList.remove('active');
            document.getElementById('catMgrOverlay').classList.remove('active');
        }
        function loadCategoryList() {
            fetch(contextPath + '/admin/category/list')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    var html = '';
                    if (data.length === 0) {
                        html = '<div class="mgr-empty">暂无分类，请新建</div>';
                    } else {
                        data.forEach(function(c) {
                            html += '<div class="mgr-item">' +
                                '<div class="mgr-item-info">' +
                                '<span class="mgr-item-name">' + escapeHtml(c.name) + '</span>' +
                                '<span class="mgr-item-count">' + (c.articleCount || 0) + ' 篇文章</span>' +
                                '</div>' +
                                '<div class="mgr-item-actions">' +
                                '<button class="mgr-item-edit-btn" onclick="editCategory(' + c.id + ',\'' + escapeHtml(c.name) + '\',\'' + escapeHtml(c.slug || '') + '\')">编辑</button>' +
                                '<button class="mgr-item-del-btn" onclick="deleteCategory(' + c.id + ')">删除</button>' +
                                '</div></div>';
                        });
                    }
                    document.getElementById('categoryList').innerHTML = html;
                });
        }
        var editingCatId = null;
        function editCategory(id, name, slug) {
            editingCatId = id;
            document.getElementById('catInput').value = name;
            document.getElementById('catSlugInput').value = slug;
            document.querySelector('#catMgrModal .btn-primary').textContent = '保存';
        }
        function saveCategory() {
            var name = document.getElementById('catInput').value.trim();
            var slug = document.getElementById('catSlugInput').value.trim();
            if (!name) { showToast('请输入分类名称', 'error'); return; }
            var body = { name: name, slug: slug || null };
            if (editingCatId) body.id = editingCatId;
            fetch(contextPath + '/admin/category/save', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    showToast(editingCatId ? '分类已更新' : '分类已创建', 'success');
                    document.getElementById('catInput').value = '';
                    document.getElementById('catSlugInput').value = '';
                    editingCatId = null;
                    document.querySelector('#catMgrModal .btn-primary').textContent = '新建';
                    loadCategoryList();
                    refreshCategorySelect();
                } else {
                    showToast(data.msg || '操作失败', 'error');
                }
            });
        }
        function deleteCategory(id) {
            if (!confirm('确定要删除这个分类吗？')) return;
            fetch(contextPath + '/admin/category/delete?id=' + id, { method: 'POST' })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    showToast('分类已删除', 'success');
                    loadCategoryList();
                    refreshCategorySelect();
                } else {
                    showToast(data.msg || '删除失败', 'error');
                }
            });
        }

        // ====== 刷新下拉和标签 ======
        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/'/g,'&#39;').replace(/"/g,'&quot;');
        }
        function refreshTagChips() {
            fetch(contextPath + '/admin/tag/list')
                .then(function(r) { return r.json(); })
                .then(function(tags) {
                    var area = document.getElementById('tagSelectArea');
                    var selectedIds = getSelectedTagIds();
                    area.innerHTML = '';
                    tags.forEach(function(t) {
                        var span = document.createElement('span');
                        span.className = 'tag-chip';
                        if (selectedIds.indexOf(t.id) !== -1) span.classList.add('active');
                        span.setAttribute('data-id', t.id);
                        span.style.borderColor = t.color;
                        span.style.color = t.color;
                        span.textContent = t.name;
                        span.onclick = function() { toggleTagChip(span); };
                        area.appendChild(span);
                    });
                });
        }
        function refreshCategorySelect() {
            fetch(contextPath + '/admin/category/list')
                .then(function(r) { return r.json(); })
                .then(function(cats) {
                    var sel = document.getElementById('categoryId');
                    var selected = sel.value;
                    sel.innerHTML = '<option value="">请选择分类</option>';
                    cats.forEach(function(c) {
                        var opt = document.createElement('option');
                        opt.value = c.id;
                        opt.textContent = c.name;
                        sel.appendChild(opt);
                    });
                    if (selected) sel.value = selected;
                });
        }
    </script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070801"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/search.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=2026070901"></script>
</body>
</html>