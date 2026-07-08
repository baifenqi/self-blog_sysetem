<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${siteName != null ? siteName : 'LELEO'} - 个人博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/calendar.css">
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
        .music-upload-btn {
            margin-bottom: 10px;
            padding: 6px 14px;
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.05);
            color: rgba(255,255,255,0.98);
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .music-upload-btn:hover {
            background: rgba(0,217,255,0.15);
            border-color: #00d9ff;
            color: #00d9ff;
        }
        .music-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .music-item-title {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .music-delete-btn {
            padding: 4px 8px;
            border: 1px solid rgba(255,87,108,0.2);
            background: rgba(255,87,108,0.05);
            color: rgba(255,87,108,0.8);
            border-radius: 4px;
            font-size: 10px;
            cursor: pointer;
            transition: all 0.2s;
            margin-left: 8px;
            flex-shrink: 0;
        }
        .music-delete-btn:hover {
            background: rgba(255,87,108,0.15);
            border-color: #ff576c;
            color: #ff576c;
        }
    </style>
</head>
<body>
    <div class="bg-container" id="bgContainer">
    </div>

    <nav class="navbar">
        <div class="navbar-brand" onclick="location.href='/'">BLOG</div>
        <div class="navbar-search">
            <input type="text" placeholder="搜索文章..." id="searchInput">
        </div>
        <div class="navbar-user">
            <div class="settings-btn" id="settingsBtn">&#9881;</div>
            <div class="navbar-avatar" title="点击进入个人信息页"
                 onclick="location.href='${pageContext.request.contextPath}/user/profile'"
                 style="background: url('${sessionScope.user != null && sessionScope.user.avatar != null ? sessionScope.user.avatar : 'https://picsum.photos/40/40'}') center/cover;"></div>
        </div>
    </nav>

    <div class="main-content">
        <!-- 左侧面板 -->
        <div class="left-panel">
            <div class="left-main">
                <div class="avatar-container">
                    <div class="avatar-wrapper">
                        <img src="${sessionScope.user != null && sessionScope.user.avatar != null ? sessionScope.user.avatar : 'https://picsum.photos/90/90'}" alt="Avatar" class="avatar-img">
                    </div>
                    <div class="username">${sessionScope.user != null ? sessionScope.user.nickname : 'LELEO'}</div>
                </div>

                <div class="signature">
                    "${sessionScope.user != null && sessionScope.user.signature != null ? sessionScope.user.signature : '顶峰的少年,给了你所有细节,你却说我不是迪迦'}"
                </div>

                <div class="pie-chart-container">
                    <div class="pie-chart-title">Tags</div>
                    <div class="pie-chart"></div>
                </div>

                <div class="social-links">
                    <!-- GitHub -->
                    <a href="https://github.com/baifenqi" class="social-link" title="GitHub" target="_blank" rel="noopener" data-platform="github">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.4 3-.405 1.02.005 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
                        </svg>
                    </a>
                    <!-- QQ -->
                    <a href="https://im.qq.com/" class="social-link" title="QQ" target="_blank" rel="noopener" data-platform="qq">
                        <img src="https://cdn.simpleicons.org/qq/ffffff" width="24" height="24" alt="QQ" />
                    </a>
                    <!-- 微信 -->
                    <a href="weixin://" class="social-link" title="微信" target="_blank" rel="noopener" data-platform="wechat">
                        <img src="https://cdn.simpleicons.org/wechat/ffffff" width="24" height="24" alt="微信" />
                    </a>
                    <!-- B站 -->
                    <a href="https://www.bilibili.com/" class="social-link" title="B站" target="_blank" rel="noopener" data-platform="bilibili">
                        <img src="https://cdn.simpleicons.org/bilibili/ffffff" width="24" height="24" alt="B站" />
                    </a>
                </div>

                <div class="music-player">
                    <div class="music-cover" id="musicCover"></div>
                    <div class="music-popup">
                        <h4 id="musicTitle">Starry Sky</h4>
                        <div class="music-controls">
                            <div class="music-btn prev" onclick="prevMusic()">
                                <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                    <path d="M6 6h2v12H6zm3.5 6l8.5 6V6z"/>
                                </svg>
                            </div>
                            <div class="music-btn play" id="playBtn">
                                <svg class="icon-play" viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
                                    <path d="M8 5v14l11-7z"/>
                                </svg>
                                <svg class="icon-pause" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="display:none;">
                                    <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
                                </svg>
                            </div>
                            <div class="music-btn next" onclick="nextMusic()">
                                <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                    <path d="M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z"/>
                                </svg>
                            </div>
                        </div>
                        <div class="music-progress">
                            <div class="music-progress-bar" id="musicProgressBar"></div>
                        </div>
                        <div class="music-time">
                            <span id="musicCurrentTime">0:00</span>
                            <span id="musicDuration">0:00</span>
                        </div>
                        <div class="music-list" id="musicList">
                            <c:forEach items="${musicList}" var="music" varStatus="status">
                                <div class="music-item ${status.first ? 'active' : ''}" data-url="${pageContext.request.contextPath}${music.url}" data-title="${music.title}" data-cover="${music.cover}">
                                    <div class="music-item-title">${music.title}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 移入的右侧面板内容 -->
            <div class="left-widgets">
                <div class="widget">
                    <div class="widget-title">文章分类</div>
                    <ul class="category-list">
                        <c:forEach items="${categories}" var="category">
                            <li>
                                <a href="/category/${category.slug}">
                                    ${category.name}
                                    <span>${category.articleCount}</span>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <div class="widget">
                    <div class="widget-title">标签云</div>
                    <div class="tags-cloud">
                        <c:forEach items="${tags}" var="tag">
                            <span class="tag" style="border-color: ${tag.color}; color: ${tag.color}">${tag.name}</span>
                        </c:forEach>
                    </div>
                </div>

                <div class="widget">
                    <div class="widget-title">博客统计</div>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value">${articleStats.totalArticles}</div>
                            <div class="stat-label">文章数</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${articleStats.totalViews}</div>
                            <div class="stat-label">访问量</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${commentStats.totalComments}</div>
                            <div class="stat-label">评论数</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${categories.size()}</div>
                            <div class="stat-label">分类数</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 中间区域 -->
        <div class="center-panel">
            <div class="dashboard-header">
                <div class="calendar-section">
                    <div class="calendar-header">
                        <h3 class="calendar-title" id="calendarTitle">2025</h3>
                    </div>
                    <div class="calendar-months" id="calendarMonths"></div>
                    <div class="contribution-graph" id="contributionGraph"></div>
                    <div class="calendar-legend">
                        <span class="legend-label">少</span>
                        <span class="legend-block level-0"></span>
                        <span class="legend-block level-1"></span>
                        <span class="legend-block level-2"></span>
                        <span class="legend-block level-3"></span>
                        <span class="legend-block level-4"></span>
                        <span class="legend-label">多</span>
                    </div>
                </div>
                <div class="action-section">
                    <button class="btn-primary write-btn" id="writeBtn" onclick="goToWrite()">✏️ 写博客</button>
                    <button class="btn-secondary draft-btn" id="draftBtn" onclick="goToDrafts()">📝 草稿箱</button>
                    <button class="btn-secondary stats-btn" id="statsBtn" onclick="goToStats()">📊 统计</button>
                    <div class="clock-widget">
                        <div id="clockTime" class="clock-time">00:00:00</div>
                        <div id="clockDate" class="clock-date"></div>
                    </div>
                    <div class="calendar-stats">
                        <div class="stat-row">
                            <span class="stat-label">过去一年提交</span>
                            <span class="stat-value highlight">${articleStats.totalArticles}</span>
                        </div>
                        <div class="stat-row">
                            <span class="stat-label">最近一月</span>
                            <span class="stat-value">${articleStats.monthArticles}</span>
                        </div>
                        <div class="stat-row">
                            <span class="stat-label">最近一周</span>
                            <span class="stat-value">${articleStats.weekArticles}</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="articles-grid">
                <c:forEach items="${articles}" var="article" varStatus="status">
                    <div class="article-card ${status.index % 5 == 0 ? 'large' : (status.index % 3 == 0 ? 'medium' : '')}"
                         onclick="location.href='/article/${article.slug}'">
                        <div class="card-image" style="${article.coverImage != null ? 'background: url(' += article.coverImage += ') center/cover;' : ''}"></div>
                        <div class="card-content">
                            <h3 class="card-title">${article.title}</h3>
                            <p class="card-desc">${article.summary}</p>
                            <div class="card-footer">
                                <span class="card-category">${article.categoryName != null ? article.categoryName : '未分类'}</span>
                                <span class="card-date"><fmt:formatDate value="${article.createTime}" pattern="yyyy-MM-dd"/></span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- 设置弹窗 -->
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
                        📁
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
    </script>
    <script src="${pageContext.request.contextPath}/static/js/modules/clock.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070801"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/calendar.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070801"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/search.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=20250101"></script>
    <script src="${pageContext.request.contextPath}/static/js/front-v2.js"></script>
</body>
</html>