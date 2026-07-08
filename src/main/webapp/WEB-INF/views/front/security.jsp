<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>账号安全 - LELEO博客</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/front.css">
</head>
<body>
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
                        <div class="security-item-icon">🔑</div>
                        <div class="security-item-info">
                            <div class="security-item-title">更改密码</div>
                            <div class="security-item-desc">修改登录密码，保护账号安全</div>
                        </div>
                        <div class="security-item-arrow">›</div>
                    </div>
                    
                    <div class="security-item" onclick="showChangeUsernameModal()">
                        <div class="security-item-icon">👤</div>
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
            <h3>🔑 更改密码</h3>
            <button class="modal-close" id="passwordModalClose">&#215;</button>
        </div>
        <div class="avatar-modal-content">
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
                <label>新账号</label>
                <input type="text" class="profile-input" id="newUsername" placeholder="请输入新账号">
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
            var newPassword = document.getElementById('newPassword').value.trim();
            var confirmPassword = document.getElementById('confirmPassword').value.trim();

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

            fetch('${pageContext.request.contextPath}/api/user/profile/password', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ newPassword: newPassword })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    alert('密码修改成功，请重新登录');
                    passwordModalOverlay.classList.remove('active');
                    passwordModal.classList.remove('active');
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
            var newUsername = document.getElementById('newUsername').value.trim();

            if (!newUsername) {
                alert('请输入新账号');
                return;
            }
            if (newUsername.length < 3) {
                alert('新账号长度不能少于3位');
                return;
            }

            fetch('${pageContext.request.contextPath}/api/user/profile/username', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ newUsername: newUsername })
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    alert('账号修改成功，请重新登录');
                    usernameModalOverlay.classList.remove('active');
                    usernameModal.classList.remove('active');
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