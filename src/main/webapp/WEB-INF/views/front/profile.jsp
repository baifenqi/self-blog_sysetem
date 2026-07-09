<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户资料 - LELEO博客</title>
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

    <div class="profile-page">
        <div class="profile-header">
            <div class="profile-home-link-left" onclick="location.href='${pageContext.request.contextPath}/'">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                <span>返回首页</span>
            </div>
        </div>

        <div class="profile-content">
            <div class="profile-card">
                <!-- 头像区域 -->
                <div class="profile-avatar-section">
                    <div class="profile-avatar-wrapper" id="avatarWrapper">
                        <img src="${sessionScope.user != null && sessionScope.user.avatar != null ? pageContext.request.contextPath.concat(sessionScope.user.avatar) : 'https://picsum.photos/200/200'}" 
                             alt="Avatar" class="profile-avatar-img">
                        <div class="profile-avatar-popup" id="avatarPopup">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                            <span>更换头像</span>
                        </div>
                    </div>
                    <div class="profile-avatar-name" id="avatarDisplayName">LELEO</div>
                    <div class="profile-avatar-role">用户</div>
                </div>

                <!-- 分隔线 -->
                <div class="profile-divider"></div>

                <!-- 表单区域 -->
                <div class="profile-info-section">
                    <div class="profile-row">
                        <span class="profile-label">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            用户昵称
                        </span>
                        <input type="text" class="profile-input" id="nicknameInput" 
                               value="${sessionScope.user != null && sessionScope.user.nickname != null ? sessionScope.user.nickname : 'LELEO'}"
                               oninput="updateAvatarDisplayName()">
                    </div>

                    <div class="profile-row">
                        <span class="profile-label">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                            个性签名
                        </span>
                        <input type="text" class="profile-input" id="signatureInput" 
                               value="${sessionScope.user != null && sessionScope.user.signature != null ? sessionScope.user.signature : ''}"
                               placeholder="输入个性签名...">
                    </div>

                    <button class="btn-primary save-profile-btn" onclick="saveProfile()">保存资料</button>

                    <a href="${pageContext.request.contextPath}/user/security" class="security-link">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        <span>账号安全与防护</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="avatarModalOverlay"></div>
    <div class="avatar-modal" id="avatarModal">
        <div class="modal-header">
            <h3>编辑头像</h3>
            <button class="modal-close" id="avatarModalClose">&#215;</button>
        </div>
        <div class="avatar-modal-content">
            <div class="avatar-preview">
                <img id="avatarPreviewImg" src="${sessionScope.user != null && sessionScope.user.avatar != null ? pageContext.request.contextPath.concat(sessionScope.user.avatar) : 'https://picsum.photos/150/150'}" alt="预览">
            </div>
            <div class="avatar-upload-area">
                <label class="avatar-upload-btn">
                    <input type="file" id="avatarUpload" accept="image/*" onchange="previewAvatar(this)">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle; margin-right: 4px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                    选择图片
                </label>
                <p style="font-size: 11px; color: rgba(255,255,255,0.6); margin-top: 10px;">支持 JPG、PNG 格式，建议尺寸 200x200</p>
            </div>
            <button class="btn-primary" onclick="uploadAvatar()" style="width: 100%; margin-top: 15px;">保存头像</button>
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
                <label>当前密码</label>
                <input type="password" class="profile-input" id="currentPassword" placeholder="请输入当前密码">
            </div>
            <div class="form-group">
                <label>新账号</label>
                <input type="text" class="profile-input" id="newUsername" placeholder="请输入新账号">
            </div>
            <button class="btn-primary" onclick="changeUsername()" style="width: 100%; margin-top: 15px;">确认更改</button>
        </div>
    </div>

    <script>
        var currentAvatar = "${sessionScope.user != null && sessionScope.user.avatar != null ? pageContext.request.contextPath.concat(sessionScope.user.avatar) : ''}";
        var contextPath = '${pageContext.request.contextPath}';
        var isLoggedIn = ${sessionScope.user != null && sessionScope.user.id != null ? 'true' : 'false'};

        // 页面加载时恢复资料（localStorage 作为补充）
        (function() {
            var savedNickname = localStorage.getItem('profile_nickname');
            var savedSignature = localStorage.getItem('profile_signature');
            var savedAvatar = localStorage.getItem('profile_avatar');
            // 未登录时，localStorage 优先；已登录时，若服务器无数据则用 localStorage 补充
            if (!isLoggedIn || !document.getElementById('nicknameInput').value) {
                if (savedNickname) {
                    document.getElementById('nicknameInput').value = savedNickname;
                }
            }
            if (!isLoggedIn || !document.getElementById('signatureInput').value) {
                if (savedSignature !== null) {
                    document.getElementById('signatureInput').value = savedSignature;
                }
            }
            if (savedAvatar) {
                var mainImg = document.querySelector('.profile-avatar-img');
                if (!isLoggedIn || !mainImg.src || mainImg.src.indexOf('/upload/avatars/') === -1) {
                    mainImg.src = savedAvatar;
                    document.getElementById('avatarPreviewImg').src = savedAvatar;
                    currentAvatar = savedAvatar;
                }
            }
            // 更新头像下方显示的名称
            updateAvatarDisplayName();
        })();

        function updateAvatarDisplayName() {
            var nameEl = document.getElementById('avatarDisplayName');
            if (nameEl) {
                var nick = document.getElementById('nicknameInput').value.trim() || '访客';
                nameEl.textContent = nick;
            }
        }

        function saveProfile() {
            var nickname = document.getElementById('nicknameInput').value.trim();
            var signature = document.getElementById('signatureInput').value.trim();
            var saveBtn = document.querySelector('.save-profile-btn');

            if (!nickname) {
                alert('请输入用户昵称');
                return;
            }

            // 始终保存到 localStorage（未登录时作为本地持久化，登录时也作为备份）
            localStorage.setItem('profile_nickname', nickname);
            localStorage.setItem('profile_signature', signature);
            if (currentAvatar) {
                localStorage.setItem('profile_avatar', currentAvatar);
            }
            updateAvatarDisplayName();

            saveBtn.innerHTML = '保存中...';
            saveBtn.disabled = true;

            Promise.all([
                fetch(contextPath + '/api/user/profile/nickname', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ nickname: nickname })
                }).then(res => res.json()),
                fetch(contextPath + '/api/user/profile/signature', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ signature: signature })
                }).then(res => res.json())
            ])
            .then(results => {
                var allSuccess = results.every(r => r.code === 200);
                if (allSuccess) {
                    alert('资料保存成功！');
                    saveBtn.innerHTML = '保存成功';
                    setTimeout(() => {
                        saveBtn.innerHTML = '保存资料';
                        saveBtn.disabled = false;
                    }, 2000);
                } else {
                    var errorMsg = results.find(r => r.code !== 200)?.msg || '保存失败';
                    alert(errorMsg);
                    saveBtn.innerHTML = '保存资料';
                    saveBtn.disabled = false;
                }
            })
            .catch(err => {
                console.error('保存失败:', err);
                // 如果是未登录用户，API 会失败，但 localStorage 已保存
                if (!isLoggedIn) {
                    alert('资料已本地保存（未登录状态下关闭浏览器后不会丢失）');
                    saveBtn.innerHTML = '保存资料';
                    saveBtn.disabled = false;
                } else {
                    alert('保存失败，请重试');
                    saveBtn.innerHTML = '保存资料';
                    saveBtn.disabled = false;
                }
            });
        }

        var avatarWrapper = document.getElementById('avatarWrapper');
        var avatarPopup = document.getElementById('avatarPopup');
        var avatarModalOverlay = document.getElementById('avatarModalOverlay');
        var avatarModal = document.getElementById('avatarModal');
        var avatarModalClose = document.getElementById('avatarModalClose');
        var avatarPreviewImg = document.getElementById('avatarPreviewImg');

        avatarWrapper.addEventListener('mouseenter', function() {
            avatarPopup.style.display = 'flex';
        });

        avatarWrapper.addEventListener('mouseleave', function() {
            avatarPopup.style.display = 'none';
        });

        avatarWrapper.addEventListener('click', function() {
            avatarModalOverlay.classList.add('active');
            avatarModal.classList.add('active');
        });

        avatarModalClose.addEventListener('click', function() {
            avatarModalOverlay.classList.remove('active');
            avatarModal.classList.remove('active');
        });

        avatarModalOverlay.addEventListener('click', function() {
            avatarModalOverlay.classList.remove('active');
            avatarModal.classList.remove('active');
        });

        function previewAvatar(input) {
            if (!input.files || !input.files[0]) return;

            var reader = new FileReader();
            reader.onload = function(e) {
                avatarPreviewImg.src = e.target.result;
                currentAvatar = e.target.result;
                // 预览时即保存到 localStorage，防止用户未点击保存就刷新
                localStorage.setItem('profile_avatar', currentAvatar);
            };
            reader.readAsDataURL(input.files[0]);
        }

        function uploadAvatar() {
            var input = document.getElementById('avatarUpload');
            if (!input.files || !input.files[0]) {
                alert('请先选择图片');
                return;
            }

            // 未登录用户：直接使用 localStorage 保存 base64，不上传服务器
            if (!isLoggedIn) {
                if (currentAvatar && currentAvatar.startsWith('data:')) {
                    localStorage.setItem('profile_avatar', currentAvatar);
                    document.querySelector('.profile-avatar-img').src = currentAvatar;
                    avatarModalOverlay.classList.remove('active');
                    avatarModal.classList.remove('active');
                    input.value = '';
                    alert('头像已本地保存');
                    return;
                }
            }

            var formData = new FormData();
            formData.append('file', input.files[0]);

            fetch(contextPath + '/api/user/profile/avatar', {
                method: 'POST',
                body: formData
            })
            .then(res => {
                if (!res.ok) {
                    return res.text().then(text => { throw new Error('HTTP ' + res.status + ': ' + text.substring(0, 200)); });
                }
                return res.json();
            })
            .then(data => {
                if (data.code === 200) {
                    currentAvatar = contextPath + data.data;
                    document.querySelector('.profile-avatar-img').src = currentAvatar;
                    document.getElementById('avatarPreviewImg').src = currentAvatar;
                    localStorage.setItem('profile_avatar', currentAvatar);
                    avatarModalOverlay.classList.remove('active');
                    avatarModal.classList.remove('active');
                    input.value = '';
                    alert('头像更新成功');
                } else {
                    alert(data.msg || data.message || '上传失败');
                }
            })
            .catch(err => {
                console.error('上传失败:', err);
                // 如果上传失败但已有 base64 预览，保存到 localStorage
                if (currentAvatar && currentAvatar.startsWith('data:')) {
                    localStorage.setItem('profile_avatar', currentAvatar);
                    document.querySelector('.profile-avatar-img').src = currentAvatar;
                    avatarModalOverlay.classList.remove('active');
                    avatarModal.classList.remove('active');
                    input.value = '';
                    alert('头像已本地保存（服务器上传失败）');
                } else {
                    alert('上传失败: ' + err.message);
                }
            });
        }

        var passwordModalOverlay = document.getElementById('passwordModalOverlay');
        var passwordModal = document.getElementById('passwordModal');
        var passwordModalClose = document.getElementById('passwordModalClose');

        var usernameModalOverlay = document.getElementById('usernameModalOverlay');
        var usernameModal = document.getElementById('usernameModal');
        var usernameModalClose = document.getElementById('usernameModalClose');

        var securitySection = document.getElementById('securitySection');
        if (securitySection) {
            securitySection.style.display = 'none';
        }

        function toggleSecuritySection() {
            if (securitySection) {
                securitySection.style.display = securitySection.style.display === 'none' ? 'flex' : 'none';
            }
        }

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
            if (newPassword !== confirmPassword) {
                alert('两次输入的新密码不一致');
                return;
            }

            fetch(contextPath + '/api/user/profile/password', {
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
                    alert(data.msg || '密码修改失败');
                }
            })
            .catch(err => {
                console.error('修改失败:', err);
                alert('密码修改失败');
            });
        }

        function changeUsername() {
            var currentPassword = document.getElementById('currentPassword').value.trim();
            var newUsername = document.getElementById('newUsername').value.trim();

            if (!currentPassword) {
                alert('请输入当前密码');
                return;
            }
            if (!newUsername) {
                alert('请输入新账号');
                return;
            }

            fetch(contextPath + '/api/user/profile/username', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ currentPassword: currentPassword, newUsername: newUsername })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    alert('账号修改成功，请重新登录');
                    usernameModalOverlay.classList.remove('active');
                    usernameModal.classList.remove('active');
                    document.getElementById('currentPassword').value = '';
                    document.getElementById('newUsername').value = '';
                    location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert(data.msg || '账号修改失败');
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

    <script src="${pageContext.request.contextPath}/static/js/modules/settings.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/background.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/music.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/search.js?v=2026070901"></script>
    <script src="${pageContext.request.contextPath}/static/js/modules/navigation.js?v=2026070901"></script>
</body>
</html>