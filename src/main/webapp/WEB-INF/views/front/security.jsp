<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>账号安全 - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/front.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/settings.css?v=2026070901">
    <style>
        body { background: transparent !important; }
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
        .floating-music-player {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }
        .floating-music-player .music-popup {
            top: auto;
            bottom: 90px;
            left: auto;
            right: 0;
        }
    </style>
</head>
<body>
    <div class="bg-container" id="bgContainer"></div>

    <nav class="navbar">
        <div class="navbar-brand" onclick="location.href='${pageContext.request.contextPath}/'">BLOG</div>
        <div class="navbar-search">
            <input type="text" placeholder="搜索文章..." id="searchInput">
        </div>
        <div class="navbar-user">
            <a class="nav-action-btn" href="${pageContext.request.contextPath}/" title="返回首页">&#8962;</a>
            <div class="settings-btn" id="settingsBtn">&#9881;</div>
        </div>
    </nav>

    <div class="profile-container">
        <div class="profile-header">
            <div class="back-link" onclick="goBack()">
                ← 返回
            </div>
            <div class="header-title">账号安全与防护</div>
        </div>

        <div class="profile-content">
            <div class="profile-card">
                <div class="security-section">
                    <div class="security-item" onclick="showChangePasswordModal()">
                        <div class="security-item-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        </div>
                        <div class="security-item-info">
                            <div class="security-item-title">更改密码</div>
                            <div class="security-item-desc">修改登录密码，保护账号安全</div>
                        </div>
                        <div class="security-item-arrow">›</div>
                    </div>
                    
                    <div class="security-item" onclick="showChangeUsernameModal()">
                        <div class="security-item-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <div class="security-item-info">
                            <div class="security-item-title">更改账号</div>
                            <div class="security-item-desc">修改登录用户名</div>
                        </div>
                        <div class="security-item-arrow">›</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="passwordModalOverlay"></div>
    <div class="avatar-modal" id="passwordModal">
        <div class="modal-header">
            <h3>更改密码</h3>
            <button class="modal-close" id="passwordModalClose">&#215;</button>
        </div>
        <div class="avatar-modal-content">
            <div class="form-group">
                <label>旧密码</label>
                <input type="password" class="profile-input" id="oldPassword" placeholder="请输入旧密码">
            </div>
            <div class="form-group">
                <label>新密码</label>
                <input type="password" class="profile-input" id="newPassword" placeholder="请输入新密码">
            </div>
            <div class="form-group">
                <label>确认新密码</label>
                <input type="password" class="profile-input" id="confirmPassword" placeholder="请再次输入新密码">
            </div>
            <button class="btn-primary" onclick="changePassword()" style="width: 100%; margin-top: 15px;">确认更改</button>
        </div>
    </div>

    <div class="modal-overlay" id="usernameModalOverlay"></div>
    <div class="avatar-modal" id="usernameModal">
        <div class="modal-header">
            <h3>更改账号</h3>
            <button class="modal-close" id="usernameModalClose">&#215;</button>
        </div>
        <div class="avatar-modal-content">
            <div class="form-group">
                <label>新账号</label>
                <input type="text" class="profile-input" id="newUsername" placeholder="请输入新账号">
            </div>
            <div class="form-group">
                <label>当前密码</label>
                <input type="password" class="profile-input" id="currentPasswordForUsername" placeholder="请输入当前密码以确认">
            </div>
            <button class="btn-primary" onclick="changeUsername()" style="width: 100%; margin-top: 15px;">确认更改</button>
        </div>
    </div>

    <script>
        function goBack() {
            window.location.href = '${pageContext.request.contextPath}/user/profile';
        }

        var passwordModalOverlay = document.getElementById('passwordModalOverlay');
        var passwordModal = document.getElementById('passwordModal');
        var passwordModalClose = document.getElementById('passwordModalClose');

        var usernameModalOverlay = document.getElementById('usernameModalOverlay');
        var usernameModal = document.getElementById('usernameModal');
        var usernameModalClose = document.getElementById('usernameModalClose');

        function showChangePasswordModal() {
            passwordModalOverlay.classList.add('active');
            passwordModal.classList.add('active');
        }

        passwordModalClose.addEventListener('click', function() {
            passwordModalOverlay.classList.remove('active');
            passwordModal.classList.remove('active');
        });

        passwordModalOverlay.addEventListener('click', function() {
            passwordModalOverlay.classList.remove('active');
            passwordModal.classList.remove('active');
        });

        function showChangeUsernameModal() {
            usernameModalOverlay.classList.add('active');
            usernameModal.classList.add('active');
        }

        usernameModalClose.addEventListener('click', function() {
            usernameModalOverlay.classList.remove('active');
            usernameModal.classList.remove('active');
        });

        usernameModalOverlay.addEventListener('click', function() {
            usernameModalOverlay.classList.remove('active');
            usernameModal.classList.remove('active');
        });

        function changePassword() {
            var oldPassword = document.getElementById('oldPassword').value.trim();
            var newPassword = document.getElementById('newPassword').value.trim();
            var confirmPassword = document.getElementById('confirmPassword').value.trim();

            if (!oldPassword) {
                alert('请输入旧密码');
                return;
            }
            if (!newPassword) {
                alert('请输入新密码');
                return;
            }
            if (newPassword.length < 6) {
                alert('新密码长度不能少于6位');
                return;
            }
            if (newPassword !== confirmPassword) {
                alert('两次输入的新密码不一致');
                return;
            }
            if (oldPassword === newPassword) {
                alert('新密码不能与旧密码相同');
                return;
            }

            fetch('${pageContext.request.contextPath}/api/user/profile/password', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ oldPassword: oldPassword, newPassword: newPassword })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    alert('密码修改成功，请重新登录');
                    passwordModalOverlay.classList.remove('active');
                    passwordModal.classList.remove('active');
                    document.getElementById('oldPassword').value = '';
                    document.getElementById('newPassword').value = '';
                    document.getElementById('confirmPassword').value = '';
                    location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert(data.message || data.msg || '密码修改失败');
                }
            })
            .catch(err => {
                console.error('修改失败:', err);
                alert('密码修改失败');
            });
        }

        function changeUsername() {
            var newUsername = document.getElementById('newUsername').value.trim();
            var currentPassword = document.getElementById('currentPasswordForUsername').value.trim();

            if (!newUsername) {
                alert('请输入新账号');
                return;
            }
            if (newUsername.length < 3) {
                alert('新账号长度不能少于3位');
                return;
            }
            if (!currentPassword) {
                alert('请输入当前密码');
                return;
            }

            fetch('${pageContext.request.contextPath}/api/user/profile/username', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ newUsername: newUsername, currentPassword: currentPassword })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    alert('账号修改成功，请重新登录');
                    usernameModalOverlay.classList.remove('active');
                    usernameModal.classList.remove('active');
                    document.getElementById('newUsername').value = '';
                    document.getElementById('currentPasswordForUsername').value = '';
                    location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert(data.message || data.msg || '账号修改失败');
                }
            })
            .catch(err => {
                console.error('修改失败:', err);
                alert('账号修改失败');
            });
        }
    </script>

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
    </script>
    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/search.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=2026070901"></script>
</body>
</html>