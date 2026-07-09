<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>统计 - ${siteName != null ? siteName : 'LELEO'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/widgets.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/settings.css?v=2026070901">
    <style>
        body { background: transparent !important; }
        .stats-container {
            max-width: 960px;
            margin: 80px auto 40px;
            padding: 0 20px;
        }
        .stats-header {
            margin-bottom: 30px;
        }
        .stats-header h1 {
            font-size: 28px;
            background: linear-gradient(135deg, #00d9ff, #ff6b9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .stats-header p {
            color: var(--muted);
            font-size: 14px;
            margin-top: 6px;
        }

        /* 概览卡片 */
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .overview-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 22px 20px;
            position: relative;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            backdrop-filter: blur(8px);
        }
        .overview-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }
        .overview-card .card-icon {
            font-size: 26px;
            margin-bottom: 10px;
        }
        .overview-card .card-value {
            font-size: 30px;
            font-weight: 700;
            color: var(--text);
            line-height: 1.2;
        }
        .overview-card .card-label {
            font-size: 12px;
            color: var(--muted);
            margin-top: 4px;
        }
        .overview-card .card-glow {
            position: absolute;
            top: -30px;
            right: -30px;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            opacity: 0.12;
        }
        .glow-blue { background: #00d9ff; }
        .glow-pink { background: #ff6b9d; }
        .glow-green { background: #4ade80; }
        .glow-purple { background: #a78bfa; }
        .glow-orange { background: #fb923c; }
        .glow-cyan { background: #22d3ee; }

        /* 内容区块 */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 24px;
        }
        .section-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 22px;
            backdrop-filter: blur(8px);
        }
        .section-card.full-width {
            grid-column: 1 / -1;
        }
        .section-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text);
            margin: 0 0 16px 0;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* 分类进度条 */
        .category-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        .category-row:last-child { border-bottom: none; }
        .category-name {
            font-size: 13px;
            color: var(--text);
            min-width: 80px;
            flex-shrink: 0;
        }
        .category-bar-bg {
            flex: 1;
            height: 6px;
            background: rgba(255,255,255,0.06);
            border-radius: 3px;
            overflow: hidden;
        }
        .category-bar {
            height: 100%;
            border-radius: 3px;
            background: linear-gradient(90deg, #00d9ff, #a78bfa);
            transition: width 0.6s ease;
        }
        .category-count {
            font-size: 12px;
            color: var(--primary);
            font-weight: 600;
            min-width: 40px;
            text-align: right;
        }

        /* 标签云 */
        .tag-cloud {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .tag-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 5px 12px;
            background: rgba(0,217,255,0.08);
            border: 1px solid rgba(0,217,255,0.15);
            border-radius: 20px;
            font-size: 12px;
            color: var(--text);
            transition: all 0.2s;
        }
        .tag-pill:hover {
            background: rgba(0,217,255,0.16);
            transform: translateY(-1px);
        }
        .tag-pill .tag-count {
            font-size: 10px;
            color: var(--primary);
            font-weight: 600;
        }

        /* 热门文章列表 */
        .hot-article {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .hot-article:last-child { border-bottom: none; }
        .hot-article:hover { opacity: 0.8; }
        .hot-rank {
            width: 24px;
            height: 24px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            color: #fff;
            flex-shrink: 0;
        }
        .hot-rank.r1 { background: linear-gradient(135deg, #ff6b9d, #ff8a5b); }
        .hot-rank.r2 { background: linear-gradient(135deg, #a78bfa, #818cf8); }
        .hot-rank.r3 { background: linear-gradient(135deg, #00d9ff, #00a8cc); }
        .hot-rank.r4, .hot-rank.r5 { background: rgba(255,255,255,0.1); }
        .hot-info { flex: 1; min-width: 0; }
        .hot-title {
            font-size: 13px;
            color: var(--text);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .hot-meta {
            font-size: 11px;
            color: var(--muted);
            margin-top: 2px;
        }
        .hot-views {
            font-size: 12px;
            color: var(--primary);
            font-weight: 500;
            flex-shrink: 0;
        }

        /* 最近评论 */
        .comment-item {
            display: flex;
            gap: 10px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        .comment-item:last-child { border-bottom: none; }
        .comment-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(0,217,255,0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            flex-shrink: 0;
            overflow: hidden;
        }
        .comment-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }
        .comment-body { flex: 1; min-width: 0; }
        .comment-user {
            font-size: 12px;
            color: var(--primary);
            font-weight: 500;
        }
        .comment-time {
            font-size: 10px;
            color: var(--muted);
            margin-left: 8px;
        }
        .comment-text {
            font-size: 13px;
            color: var(--text);
            margin-top: 3px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* 操作栏 */
        .stats-actions {
            text-align: center;
            margin-top: 8px;
        }
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
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
            transform: translateY(-1px);
        }

        .bg-container video.bg-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
        }

        @media (max-width: 640px) {
            .overview-grid { grid-template-columns: repeat(2, 1fr); }
            .content-grid { grid-template-columns: 1fr; }
        }
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
            <div class="settings-btn" id="settingsBtn">&#9881;</div>
        </div>
    </nav>

    <div class="stats-container">
        <div class="stats-header">
            <h1>📊 博客统计</h1>
            <p>全站数据概览与分析</p>
        </div>

        <!-- 概览卡片 -->
        <div class="overview-grid">
            <div class="overview-card">
                <div class="card-glow glow-blue"></div>
                <div class="card-icon">📝</div>
                <div class="card-value">${articleCount != null ? articleCount : 0}</div>
                <div class="card-label">文章总数</div>
            </div>
            <div class="overview-card">
                <div class="card-glow glow-pink"></div>
                <div class="card-icon">👁️</div>
                <div class="card-value">${totalViews != null ? totalViews : 0}</div>
                <div class="card-label">总浏览量</div>
            </div>
            <div class="overview-card">
                <div class="card-glow glow-green"></div>
                <div class="card-icon">💬</div>
                <div class="card-value">${commentCount != null ? commentCount : 0}</div>
                <div class="card-label">评论总数</div>
            </div>
            <div class="overview-card">
                <div class="card-glow glow-purple"></div>
                <div class="card-icon">❤️</div>
                <div class="card-value">${totalLikes != null ? totalLikes : 0}</div>
                <div class="card-label">总点赞数</div>
            </div>
            <div class="overview-card">
                <div class="card-glow glow-orange"></div>
                <div class="card-icon">📂</div>
                <div class="card-value">${categoryCount != null ? categoryCount : 0}</div>
                <div class="card-label">分类数</div>
            </div>
            <div class="overview-card">
                <div class="card-glow glow-cyan"></div>
                <div class="card-icon">🏷️</div>
                <div class="card-value">${tagCount != null ? tagCount : 0}</div>
                <div class="card-label">标签数</div>
            </div>
        </div>

        <!-- 分类 + 标签 -->
        <div class="content-grid">
            <div class="section-card">
                <h3 class="section-title">📂 分类分布</h3>
                <c:if test="${categoryStats != null && !categoryStats.isEmpty()}">
                    <c:forEach items="${categoryStats}" var="cat">
                        <div class="category-row">
                            <span class="category-name">${cat.name}</span>
                            <div class="category-bar-bg">
                                <div class="category-bar" style="width: ${articleCount > 0 ? (cat.articleCount != null ? cat.articleCount * 100 / articleCount : 0) : 0}%"></div>
                            </div>
                            <span class="category-count">${cat.articleCount != null ? cat.articleCount : 0}</span>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${categoryStats == null || categoryStats.isEmpty()}">
                    <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">暂无分类数据</p>
                </c:if>
            </div>
            <div class="section-card">
                <h3 class="section-title">🏷️ 标签云</h3>
                <div class="tag-cloud">
                    <c:if test="${tagStats != null && !tagStats.isEmpty()}">
                        <c:forEach items="${tagStats}" var="tag">
                            <span class="tag-pill">
                                ${tag.name}
                                <span class="tag-count">${tag.articleCount != null ? tag.articleCount : 0}</span>
                            </span>
                        </c:forEach>
                    </c:if>
                </div>
                <c:if test="${tagStats == null || tagStats.isEmpty()}">
                    <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">暂无标签数据</p>
                </c:if>
            </div>
        </div>

        <!-- 热门文章 + 最近评论 -->
        <div class="content-grid">
            <div class="section-card">
                <h3 class="section-title">🔥 热门文章 TOP5</h3>
                <c:if test="${topArticles != null && !topArticles.isEmpty()}">
                    <c:forEach items="${topArticles}" var="art" varStatus="status">
                        <div class="hot-article" onclick="location.href='${pageContext.request.contextPath}/article/${art.slug}'">
                            <div class="hot-rank r${status.count}">${status.count}</div>
                            <div class="hot-info">
                                <div class="hot-title">${art.title}</div>
                                <div class="hot-meta">
                                    <fmt:formatDate value="${art.createTime}" pattern="yyyy-MM-dd"/>
                                </div>
                            </div>
                            <div class="hot-views">👁 ${art.viewCount != null ? art.viewCount : 0}</div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${topArticles == null || topArticles.isEmpty()}">
                    <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">暂无文章数据</p>
                </c:if>
            </div>
            <div class="section-card">
                <h3 class="section-title">💬 最近评论</h3>
                <c:if test="${recentComments != null && !recentComments.isEmpty()}">
                    <c:forEach items="${recentComments}" var="cmt">
                        <div class="comment-item">
                            <div class="comment-avatar">
                                <c:choose>
                                    <c:when test="${cmt.userAvatar != null && !cmt.userAvatar.isEmpty()}">
                                        <img src="${pageContext.request.contextPath}${cmt.userAvatar}" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        ${cmt.username != null && cmt.username.length() > 0 ? cmt.username.substring(0,1) : '?'}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="comment-body">
                                <span class="comment-user">${cmt.username != null ? cmt.username : '匿名'}</span>
                                <span class="comment-time"><fmt:formatDate value="${cmt.createTime}" pattern="MM-dd HH:mm"/></span>
                                <div class="comment-text">${cmt.content}</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${recentComments == null || recentComments.isEmpty()}">
                    <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">暂无评论数据</p>
                </c:if>
            </div>
        </div>

        <div class="stats-actions">
            <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/'">返回首页</button>
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

    <script>var contextPath = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/search.js?v=2026070901"></script>
</body>
</html>
