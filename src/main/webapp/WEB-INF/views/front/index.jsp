<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${siteName != null ? siteName : 'LELEO'} - 个人博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/front.css">
</head>
<body>
    <div class="bg-container">
        <div class="stars" id="stars"></div>
    </div>

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

    <div class="main-content">
        <!-- 左侧面板 -->
        <div class="left-panel">
            <div class="avatar-container">
                <a href="#" class="avatar-wrapper" title="点击进入个人信息页">
                    <img src="https://picsum.photos/90/90" alt="Avatar" class="avatar-img">
                </a>
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
                <a href="#" class="social-link" title="GitHub">G</a>
                <a href="#" class="social-link" title="Email">E</a>
                <a href="#" class="social-link" title="Twitter">T</a>
                <a href="#" class="social-link" title="YouTube">Y</a>
            </div>

            <div class="settings-btn" id="settingsBtn">&#9881;</div>

            <div class="music-player">
                <div class="music-cover" id="musicCover"></div>
                <div class="music-popup">
                    <h4 id="musicTitle">Starry Sky</h4>
                    <div class="music-controls">
                        <div class="music-btn" onclick="prevMusic()">&#9668;&#9668;</div>
                        <div class="music-btn play" id="playBtn">&#9616;&#9612;</div>
                        <div class="music-btn" onclick="nextMusic()">&#9658;&#9658;</div>
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
                            <div class="music-item ${status.first ? 'active' : ''}" data-url="${music.url}" data-title="${music.title}" data-cover="${music.cover}">
                                <div class="music-item-title">${music.title}</div>
                                <div class="music-item-artist">${music.artist}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- 中间区域 -->
        <div class="center-panel">
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

        <!-- 右侧面板 -->
        <div class="right-panel">
            <div class="clock-widget">
                <div class="clock-time" id="clockTime">00:00:00</div>
                <div class="clock-date" id="clockDate">2025年01月01日</div>
                <div class="clock-ring">
                    <div class="ring"></div>
                    <div class="ring"></div>
                    <div class="ring"></div>
                </div>
            </div>

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

    <!-- 设置弹窗 -->
    <div class="modal-overlay" id="modalOverlay"></div>
    <div class="settings-modal" id="settingsModal">
        <div class="modal-header">
            <h3>设置</h3>
            <button class="modal-close" id="modalClose">&#215;</button>
        </div>
        <div class="tabs">
            <button class="tab active" data-tab="style">样式预览</button>
            <button class="tab" data-tab="bg">背景设置</button>
            <button class="tab" data-tab="music">音乐播放</button>
        </div>
        <div class="settings-content">
            <div class="setting-section active" id="style">
                <h4>样式预览</h4>
                <div class="preview-grid">
                    <div class="preview-item active"></div>
                    <div class="preview-item"></div>
                    <div class="preview-item"></div>
                </div>
            </div>
            <div class="setting-section" id="bg">
                <h4>背景设置</h4>
                <div class="preview-grid">
                    <div class="preview-item active"></div>
                    <div class="preview-item"></div>
                    <div class="preview-item"></div>
                </div>
            </div>
            <div class="setting-section" id="music">
                <h4>音乐播放列表</h4>
                <div class="music-list">
                    <c:forEach items="${musicList}" var="music">
                        <div class="music-item" data-url="${music.url}">
                            <div class="music-item-title">${music.title}</div>
                            <div class="music-item-artist">${music.artist}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/front.js"></script>
</body>
</html>