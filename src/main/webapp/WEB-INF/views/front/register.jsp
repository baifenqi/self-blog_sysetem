<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - LELEO博客</title>
    <style>
        body {
            background: linear-gradient(135deg, #0a0a1a 0%, #1a1a2e 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
        }
        .register-container {
            width: 400px;
            padding: 40px;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            backdrop-filter: blur(10px);
        }
        h1 {
            text-align: center;
            font-size: 28px;
            background: linear-gradient(135deg, #00d9ff, #ff6b9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: rgba(255,255,255,0.8);
            margin-bottom: 8px;
            font-size: 14px;
        }
        input {
            width: 100%;
            height: 45px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 8px;
            padding: 0 16px;
            color: white;
            font-size: 14px;
            transition: all 0.3s;
        }
        input:focus {
            outline: none;
            border-color: #00d9ff;
            box-shadow: 0 0 15px rgba(0,217,255,0.2);
        }
        .btn-register {
            width: 100%;
            height: 45px;
            background: linear-gradient(135deg, #ff6b9d, #ff8a5b);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(255,107,157,0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: rgba(255,255,255,0.6);
            font-size: 14px;
        }
        .login-link a {
            color: #00d9ff;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .error-msg, .success-msg {
            font-size: 13px;
            margin-top: 8px;
            text-align: center;
        }
        .error-msg { color: #ff6b6b; }
        .success-msg { color: #6bff6b; }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>注册</h1>
        <form id="registerForm">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" name="username" required placeholder="请输入用户名">
            </div>
            <div class="form-group">
                <label>邮箱</label>
                <input type="email" name="email" required placeholder="请输入邮箱">
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" name="password" required placeholder="请输入密码">
            </div>
            <div class="form-group">
                <label>确认密码</label>
                <input type="password" name="confirmPassword" required placeholder="请确认密码">
            </div>
            <button type="submit" class="btn-register">注 册</button>
        </form>
        <div class="login-link">
            已有账号？ <a href="/login">立即登录</a>
        </div>
        <div class="error-msg" id="errorMsg"></div>
        <div class="success-msg" id="successMsg"></div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            
            if (formData.get('password') !== formData.get('confirmPassword')) {
                document.getElementById('errorMsg').textContent = '两次输入的密码不一致';
                return;
            }
            
            fetch('/register', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    document.getElementById('successMsg').textContent = '注册成功！正在跳转...';
                    document.getElementById('errorMsg').textContent = '';
                    setTimeout(function() {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    document.getElementById('errorMsg').textContent = data.message;
                    document.getElementById('successMsg').textContent = '';
                }
            })
            .catch(error => {
                document.getElementById('errorMsg').textContent = '注册失败，请稍后重试';
            });
        });
    </script>
</body>
</html>