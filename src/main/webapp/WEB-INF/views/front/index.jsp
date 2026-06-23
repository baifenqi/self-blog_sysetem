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
    <div class="bg-container" id="bgContainer">
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
            <div class="left-main">
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
                <h4>背景设置</h4>
                <div class="preview-grid">
                    <!-- 默认背景 -->
                    <div class="preview-item active" data-bg="default"
                         style="background: radial-gradient(ellipse at 15% 15%, rgba(0,217,255,0.12) 0%, transparent 50%), radial-gradient(ellipse at 85% 85%, rgba(255,107,157,0.1) 0%, transparent 50%), #0a0a1a;"
                         title="默认星空"></div>

                    <!-- 极光背景 -->
                    <div class="preview-item" data-bg="aurora"
                         style="background: linear-gradient(180deg, #0a0a1a 0%, #1a0a2e 50%, #0a1a0a 100%);"
                         title="极光"></div>

                    <!-- 海洋背景 -->
                    <div class="preview-item" data-bg="ocean"
                         style="background: linear-gradient(180deg, #0a1628 0%, #1e3a5f 50%, #2d5a7b 100%);"
                         title="海洋"></div>

                    <!-- 紫罗兰背景 -->
                    <div class="preview-item" data-bg="violet"
                         style="background: linear-gradient(180deg, #1a0a2e 0%, #2d1b4e 50%, #4a2d6b 100%);"
                         title="紫罗兰"></div>

                    <!-- 预设图片1：你的名字-流星 -->
                    <div class="preview-item" data-bg="preset1"
                         style="background: url('${pageContext.request.contextPath}/static/images/backgrounds/【哲风壁纸】你的名字-流星.png') no-repeat center center; background-size: cover;"
                         title="你的名字"></div>

                    <!-- 预设图片2：动漫少女 -->
                    <div class="preview-item" data-bg="preset2"
                         style="background: url('${pageContext.request.contextPath}/static/images/backgrounds/【哲风壁纸】动漫-动漫少女-少女.png') no-repeat center center; background-size: cover;"
                         title="动漫少女"></div>

                    <!-- 自定义上传 -->
                    <label class="preview-item" style="background: rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; font-size: 24px; cursor: pointer;"
                           title="上传自定义背景" onclick="document.getElementById('bgUpload').click()">
                        📁
                    </label>
                </div>
                <input type="file" id="bgUpload" accept="image/*" style="display: none;" onchange="uploadBackground(this)">
                <p style="font-size: 11px; color: var(--muted); margin-top: 10px;">支持 JPG、PNG、GIF 格式，最大 20MB</p>
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
    <script>
        // ==================== 背景设置功能 ====================

        // 设置背景样式
        function setBackground(type) {
            const bgContainer = document.querySelector('.bg-container');
            if (!bgContainer) return;

            let bgStyle = '';

            switch(type) {
                case 'default':
                    bgStyle = 'radial-gradient(ellipse at 15% 15%, rgba(0,217,255,0.12) 0%, transparent 50%), radial-gradient(ellipse at 85% 85%, rgba(255,107,157,0.1) 0%, transparent 50%), #0a0a1a';
                    break;
                case 'aurora':
                    bgStyle = 'linear-gradient(180deg, #0a0a1a 0%, #1a0a2e 50%, #0a1a0a 100%)';
                    break;
                case 'ocean':
                    bgStyle = 'linear-gradient(180deg, #0a1628 0%, #1e3a5f 50%, #2d5a7b 100%)';
                    break;
                case 'violet':
                    bgStyle = 'linear-gradient(180deg, #1a0a2e 0%, #2d1b4e 50%, #4a2d6b 100%)';
                    break;
                case 'preset1':
                    bgStyle = `url('${pageContext.request.contextPath}/static/images/backgrounds/【哲风壁纸】你的名字-流星.png') no-repeat center center fixed`;
                    break;
                case 'preset2':
                    bgStyle = `url('${pageContext.request.contextPath}/static/images/backgrounds/【哲风壁纸】动漫-动漫少女-少女.png') no-repeat center center fixed`;
                    break;
                default:
                    bgStyle = 'radial-gradient(ellipse at 15% 15%, rgba(0,217,255,0.12) 0%, transparent 50%), radial-gradient(ellipse at 85% 85%, rgba(255,107,157,0.1) 0%, transparent 50%), #0a0a1a';
            }

            bgContainer.style.background = bgStyle;
            bgContainer.style.backgroundSize = 'cover';
            bgContainer.style.backgroundPosition = 'center';

            // 更新预览选中状态
            const bgTab = document.getElementById('bg');
            if (bgTab) {
                bgTab.querySelectorAll('.preview-item').forEach(item => item.classList.remove('active'));
                const targetItem = bgTab.querySelector(`[data-bg="${type}"]`);
                if (targetItem) targetItem.classList.add('active');
            }

            // 保存到服务器
            fetch('/blog/api/setting/background', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ background: type })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    console.log('背景已保存');
                }
            })
            .catch(err => {
                console.error('保存背景失败:', err);
            });
        }

        // 从服务器加载当前背景
        function loadCurrentBackground() {
            fetch('/blog/api/setting/background')
            .then(res => res.json())
            .then(data => {
                if (data.code === 200 && data.data) {
                    setBackground(data.data);
                }
            })
            .catch(err => {
                console.error('加载背景失败:', err);
            });
        }

        // 上传自定义背景
        function uploadBackground(input) {
            if (!input.files || !input.files[0]) return;

            const formData = new FormData();
            formData.append('file', input.files[0]);

            fetch('/blog/api/setting/background/upload', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    const bgContainer = document.querySelector('.bg-container');
                    if (bgContainer) {
                        bgContainer.style.background = `url('${data.data}') no-repeat center center fixed`;
                        bgContainer.style.backgroundSize = 'cover';
                    }
                    alert('背景上传成功！');
                } else {
                    alert(data.msg || '上传失败');
                }
            })
            .catch(err => {
                console.error('上传失败:', err);
                alert('上传失败');
            });
        }

        // 初始化背景设置
        document.addEventListener('DOMContentLoaded', () => {
            // 延迟加载背景，确保DOM已完全加载
            setTimeout(loadCurrentBackground, 500);
        });

        // 绑定背景预览项点击事件
        document.addEventListener('click', (e) => {
            const previewItem = e.target.closest('.preview-item');
            if (previewItem && !previewItem.querySelector('input')) {
                const bgType = previewItem.dataset.bg;
                if (bgType) {
                    setBackground(bgType);
                }
            }
        });
    </script>
</body>
</html>