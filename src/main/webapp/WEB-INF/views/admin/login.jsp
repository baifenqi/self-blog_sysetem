<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - LELEO博客</title>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
        }
        .login-box {
            width: 400px;
            padding: 40px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        h1 {
            text-align: center;
            font-size: 28px;
            color: #303133;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #909399;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        input {
            width: 100%;
            height: 48px;
            background: #f5f7fa;
            border: 2px solid #e4e7ed;
            border-radius: 8px;
            padding: 0 16px;
            font-size: 14px;
            transition: all 0.3s;
        }
        input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
        }
        .btn-login {
            width: 100%;
            height: 48px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }
        .error-msg {
            color: #f56c6c;
            font-size: 13px;
            margin-top: 10px;
            text-align: center;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #909399;
            text-decoration: none;
            font-size: 13px;
        }
        .back-link:hover {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h1>LELEO</h1>
        <p class="subtitle">博客管理系统</p>
        <form id="loginForm">
            <div class="form-group">
                <input type="text" name="username" required placeholder="请输入用户名">
            </div>
            <div class="form-group">
                <input type="password" name="password" required placeholder="请输入密码">
            </div>
            <button type="submit" class="btn-login">登 录</button>
        </form>
        <div class="error-msg" id="errorMsg"></div>
        <a href="/" class="back-link">← 返回首页</a>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            
            fetch('/admin/login', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    window.location.href = '/admin/index';
                } else {
                    document.getElementById('errorMsg').textContent = data.message;
                }
            })
            .catch(error => {
                document.getElementById('errorMsg').textContent = '登录失败，请稍后重试';
            });
        });
    </script>
</body>
</html>