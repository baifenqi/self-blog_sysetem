<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>草稿箱 - ${siteName != null ? siteName : 'LELEO'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/widgets.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/settings.css?v=2026070901">
    <style>
        .drafts-container {
            max-width: 900px;
            margin: 80px auto 40px;
            padding: 30px;
            background: rgba(10,10,20,0.7);
            border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        .drafts-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .drafts-header h1 {
            font-size: 28px;
            background: linear-gradient(135deg, #00d9ff, #ff6b9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .drafts-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 16px;
        }
        .draft-title {
            font-size: 18px;
            color: var(--text);
            margin: 0 0 8px 0;
            cursor: pointer;
        }
        .draft-title:hover {
            color: var(--primary);
        }
        .draft-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 12px;
            color: var(--muted);
        }
        .draft-actions {
            display: flex;
            gap: 12px;
            margin-top: 12px;
        }
        .btn {
            padding: 6px 16px;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary {
            background: rgba(0,217,255,0.15);
            border: 1px solid var(--primary);
            color: var(--primary);
        }
        .btn-primary:hover {
            background: rgba(0,217,255,0.25);
        }
        .btn-secondary {
            background: rgba(255,255,255,0.08);
            border: 1px solid var(--border);
            color: var(--text);
        }
        .btn-secondary:hover {
            background: rgba(255,255,255,0.12);
        }
        .btn-danger {
            background: rgba(255,87,108,0.05);
            border: 1px solid rgba(255,87,108,0.2);
            color: rgba(255,87,108,0.8);
        }
        .btn-danger:hover {
            background: rgba(255,87,108,0.15);
            border-color: #ff576c;
            color: #ff576c;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--muted);
        }
        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 8px;
            color: var(--text);
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
    </style>
</head>
<body>
    <div class="bg-container" id="bgContainer"></div>

    <nav class="navbar">
        <div class="navbar-brand" onclick="location.href='${pageContext.request.contextPath}/'">${siteName != null ? siteName : 'LELEO'}</div>
        <div class="navbar-search">
            <input type="text" placeholder="搜索文章..." id="searchInput">
        </div>
        <div class="navbar-user">
            <a class="nav-action-btn" href="${pageContext.request.contextPath}/" title="返回首页">&#8962;</a>
            <div class="settings-btn" id="settingsBtn">&#9881;</div>
        </div>
    </nav>

    <div class="drafts-container">
        <div class="drafts-header">
            <h1><svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="url(#draftGrad)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:8px;"><defs><linearGradient id="draftGrad" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="0%" style="stop-color:#00d9ff"/><stop offset="100%" style="stop-color:#ff6b9d"/></linearGradient></defs><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>草稿箱</h1>
            <div>
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary" style="margin-right: 10px;">返回首页</a>
                <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/write'"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:4px;"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>写博客</button>
            </div>
        </div>

        <c:if test="${drafts != null && !drafts.isEmpty()}">
            <c:forEach items="${drafts}" var="draft">
                <div class="drafts-card">
                    <h3 class="draft-title" onclick="location.href='${pageContext.request.contextPath}/write?edit=${draft.id}'">${draft.title}</h3>
                    <div class="draft-meta">
                        <span>最后修改：<fmt:formatDate value="${draft.updateTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                        <span>分类：${draft.categoryName != null ? draft.categoryName : '未分类'}</span>
                    </div>
                    <div class="draft-actions">
                        <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/write?edit=${draft.id}'">继续编辑</button>
                        <button class="btn btn-secondary" onclick="publishDraft(${draft.id})">发布</button>
                        <button class="btn btn-danger" onclick="deleteDraft(${draft.id})">删除</button>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${drafts == null || drafts.isEmpty()}">
            <div class="empty-state">
                <h3>暂无草稿</h3>
                <p>开始写博客，保存为草稿后会在这里显示</p>
                <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/write'" style="margin-top: 16px;">✏️ 写博客</button>
            </div>
        </c:if>
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

        function deleteDraft(id) {
            if (confirm('确定要删除这个草稿吗？删除后无法恢复。')) {
                fetch(contextPath + '/article/draft/delete?id=' + id, {
                    method: 'POST',
                    credentials: 'same-origin'
                })
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    if (data.code === 200) {
                        showToast('草稿已删除', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 800);
                    } else if (data.code === 401) {
                        showToast('请先登录', 'error');
                        setTimeout(function() {
                            window.location.href = contextPath + '/login';
                        }, 1000);
                    } else {
                        showToast(data.message || '删除失败', 'error');
                    }
                })
                .catch(function(error) {
                    console.error('删除失败:', error);
                    showToast('删除失败，请稍后重试', 'error');
                });
            }
        }

        function publishDraft(id) {
            if (confirm('确定要发布这篇草稿吗？')) {
                // 跳转到编辑页，用户可以在编辑页发布
                window.location.href = contextPath + '/write?edit=' + id;
            }
        }

        function showToast(message, type) {
            var toast = document.createElement('div');
            toast.style.cssText = 'position:fixed;top:80px;left:50%;transform:translateX(-50%);padding:12px 30px;border-radius:8px;color:white;font-size:14px;z-index:9999;backdrop-filter:blur(10px);';
            toast.style.background = type === 'success' ? 'rgba(39, 174, 96, 0.9)' : 'rgba(231, 76, 60, 0.9)';
            toast.textContent = message;
            document.body.appendChild(toast);
            setTimeout(function() {
                toast.remove();
            }, 3000);
        }
    </script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070801"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=2026070901"></script>
</body>
</html>