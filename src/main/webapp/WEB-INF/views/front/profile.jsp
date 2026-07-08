<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户资料 - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/front.css">
</head>
<body>
    <div class="bg-container" id="bgContainer"></div>

    <div class="profile-page">
        <div class="profile-header">
            <div class="profile-home-link" onclick="location.href='${pageContext.request.contextPath}/'">首页</div>
        </div>

        <div class="profile-content">
            <div class="profile-card">
                <div class="profile-avatar-section">
                    <div class="profile-avatar-wrapper" id="avatarWrapper">
                        <img src="${sessionScope.user != null && sessionScope.user.avatar != null ? sessionScope.user.avatar : 'https://picsum.photos/200/200'}" 
                             alt="Avatar" class="profile-avatar-img">
                        <div class="profile-avatar-popup" id="avatarPopup">编辑头像</div>
                    </div>
                </div>

                <div class="profile-info-section">
                    <div class="profile-row">
                        <span class="profile-label">用户昵称</span>
                        <input type="text" class="profile-input" id="nicknameInput" 
                               value="${sessionScope.user != null && sessionScope.user.nickname != null ? sessionScope.user.nickname : 'LELEO'}"
                               onblur="updateNickname()">
                    </div>

                    <div class="profile-row">
                        <span class="profile-label">个性签名</span>
                        <input type="text" class="profile-input" id="signatureInput" 
                               value="${sessionScope.user != null && sessionScope.user.signature != null ? sessionScope.user.signature : ''}"
                               placeholder="输入个性签名..."
                               onblur="updateSignature()">
                    </div>

                    <a href="${pageContext.request.contextPath}/user/security" class="security-link">
                        🔒 账号安全与防护
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
                <img id="avatarPreviewImg" src="${sessionScope.user != null && sessionScope.user.avatar != null ? sessionScope.user.avatar : 'https://picsum.photos/150/150'}" alt="预览">
            </div>
            <div class="avatar-upload-area">
                <label class="avatar-upload-btn">
                    <input type="file" id="avatarUpload" accept="image/*" onchange="previewAvatar(this)">
                    📁 选择图片
                </label>
                <p style="font-size: 11px; color: rgba(255,255,255,0.6); margin-top: 10px;">支持 JPG、PNG 格式，建议尺寸 200x200</p>
            </div>
            <button class="btn-primary" onclick="uploadAvatar()" style="width: 100%; margin-top: 15px;">保存头像</button>
        </div>
    </div>

    <div class="modal-overlay" id="passwordModalOverlay"></div>
    <div class="avatar-modal" id="passwordModal">
        <div class="modal-header">
            <h3>🔑 更改密码</h3>
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
            <h3>👤 更改账号</h3>
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
        var currentAvatar = "${sessionScope.user != null && sessionScope.user.avatar != null ? sessionScope.user.avatar : ''}";

        function updateNickname() {
            var nickname = document.getElementById('nicknameInput').value.trim();
            if (!nickname) return;

            fetch('/blog/api/user/profile/nickname', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ nickname: nickname })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    console.log('昵称更新成功');
                } else {
                    alert(data.msg || '更新失败');
                    document.getElementById('nicknameInput').value = data.data || nickname;
                }
            })
            .catch(err => {
                console.error('更新失败:', err);
            });
        }

        function updateSignature() {
            var signature = document.getElementById('signatureInput').value.trim();

            fetch('/blog/api/user/profile/signature', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ signature: signature })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    console.log('签名更新成功');
                } else {
                    alert(data.msg || '更新失败');
                }
            })
            .catch(err => {
                console.error('更新失败:', err);
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
            };
            reader.readAsDataURL(input.files[0]);
        }

        function uploadAvatar() {
            var input = document.getElementById('avatarUpload');
            if (!input.files || !input.files[0]) {
                alert('请先选择图片');
                return;
            }

            var formData = new FormData();
            formData.append('file', input.files[0]);

            fetch('/blog/api/user/profile/avatar', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    currentAvatar = data.data;
                    document.querySelector('.profile-avatar-img').src = data.data;
                    avatarModalOverlay.classList.remove('active');
                    avatarModal.classList.remove('active');
                    alert('头像更新成功');
                } else {
                    alert(data.msg || '上传失败');
                }
            })
            .catch(err => {
                console.error('上传失败:', err);
                alert('上传失败');
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

            fetch('/blog/api/user/profile/password', {
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

            fetch('/blog/api/user/profile/username', {
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
</body>
</html>