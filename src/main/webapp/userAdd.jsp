<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        String title = "用户注册";
        String myRole = "";
        
        if (session.getAttribute("myRole") != null) {                     //如果已经登录        
            myRole = session.getAttribute("myRole").toString();            //获取session中该对象的值
            
            if (myRole.equals("admin")) {                                 //如果是管理员    
                title = "新添用户";
            }
        }
    %>
    <title><%= title %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        
        :root {
            --bg-primary: #0f1117;
            --bg-secondary: #161b25;
            --bg-card: #1c2330;
            --bg-hover: #2a3343;
            --accent-primary: #3a86ff;
            --accent-secondary: #5e60ce;
            --accent-success: #00b894;
            --accent-warning: #ffaa00;
            --accent-danger: #ff4757;
            --text-primary: #e6e9f0;
            --text-secondary: #a0a8c0;
            --border-radius: 12px;
            --transition: all 0.25s ease;
        }
        
        body {
            background: var(--bg-primary);
            color: var(--text-primary);
            background-image: radial-gradient(circle at 10% 20%, rgba(15, 31, 49, 0.8) 0%, rgba(10, 18, 30, 0.9) 90%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: rgba(22, 27, 37, 0.95);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius);
            padding: 30px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .header {
            text-align: center;
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .header h2 {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(90deg, var(--accent-primary), var(--accent-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        
        .header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-primary), var(--accent-secondary));
            border-radius: 3px;
        }
        
        .form-container {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
        }
        
        .form-row {
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-secondary);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .form-label i {
            color: var(--accent-primary);
            width: 20px;
            text-align: center;
        }
        
        .required::after {
            content: "*";
            color: var(--accent-danger);
            margin-left: 4px;
        }
        
        .form-input {
            width: 100%;
            padding: 14px 20px;
            border-radius: var(--border-radius);
            border: none;
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 16px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: var(--transition);
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(58, 134, 255, 0.2);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 42px;
            color: var(--text-secondary);
            cursor: pointer;
            transition: var(--transition);
        }
        
        .password-toggle:hover {
            color: var(--accent-primary);
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }
        
        .btn {
            flex: 1;
            min-width: 120px;
            padding: 14px;
            border-radius: var(--border-radius);
            border: none;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            color: white;
        }
        
        .btn-primary:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(58, 134, 255, 0.3);
        }
        
        .back-links {
            margin-top: 15px;
            text-align: center;
        }
        
        .back-links a {
            color: var(--accent-primary);
            text-decoration: none;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin: 0 10px;
            font-size: 14px;
        }
        
        .back-links a:hover {
            color: #6aa6ff;
            text-decoration: underline;
        }
        
        .note {
            background: rgba(255, 170, 85, 0.1);
            border: 1px solid var(--accent-warning);
            color: var(--accent-warning);
            border-radius: var(--border-radius);
            padding: 15px;
            font-size: 14px;
            line-height: 1.6;
            margin-top: 20px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .note i {
            font-size: 18px;
            margin-top: 2px;
        }
        
        @media (max-width: 500px) {
            .btn {
                min-width: 100%;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .back-links {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            
            .back-links a {
                margin: 5px 0;
            }
        }
    </style>
    <script>
        function togglePasswordVisibility(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const toggleIcon = document.querySelector(`[data-toggle="${fieldId}"] i`);
            
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                passwordField.type = "password";
                toggleIcon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }
    </script>
</head>
  
<body>
    <div class="container">
        <div class="header">
            <h2>
                <% if (myRole.equals("admin")) { %>
                    <i class="fas fa-user-plus"></i> 新添用户
                <% } else { %>
                    <i class="fas fa-user-circle"></i> 用户注册
                <% } %>
            </h2>
        </div>

        <form action="userAddDo.jsp" method="post">
            <div class="form-container">
                <div class="form-row">
                    <label for="username" class="form-label required">
                        <i class="fas fa-user"></i> 用户名
                    </label>
                    <input type="text" id="username" class="form-input" name="username" maxlength="45" placeholder="输入用户名" required>
                </div>
                
                <div class="form-row">
                    <label for="password" class="form-label required">
                        <i class="fas fa-lock"></i> 密码
                    </label>
                    <input type="password" id="password" class="form-input" name="password" maxlength="45" placeholder="输入密码" required>
                    <span class="password-toggle" data-toggle="password" onclick="togglePasswordVisibility('password')">
                        <i class="fas fa-eye"></i>
                    </span>
                </div>
                
                <div class="form-row">
                    <label for="password2" class="form-label required">
                        <i class="fas fa-lock"></i> 密码确认
                    </label>
                    <input type="password" id="password2" class="form-input" name="password2" maxlength="45" placeholder="再次输入密码" required>
                    <span class="password-toggle" data-toggle="password2" onclick="togglePasswordVisibility('password2')">
                        <i class="fas fa-eye"></i>
                    </span>
                </div>
                
                <div class="form-row">
                    <label for="realName" class="form-label">
                        <i class="fas fa-id-card"></i> 真实姓名
                    </label>
                    <input type="text" id="realName" class="form-input" name="realName" maxlength="45" placeholder="输入真实姓名（可选）">
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <% if (myRole.equals("admin")) { %>
                            <i class="fas fa-plus-circle"></i> 添加用户
                        <% } else { %>
                            <i class="fas fa-user-check"></i> 立即注册
                        <% } %>
                    </button>
                </div>
            </div>
        </form>
        
        <div class="note">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                *注册之后，新用户还需获得管理员的授权，才能查看、管理模组和用户的信息。
            </div>
        </div>
        
        <div class="back-links">
            <% if (myRole.equals("admin")) {  %>
                <a href="main.jsp"><i class="fas fa-arrow-left"></i> 返回模组中心</a>        
            <% } else { %>    
                <a href="index.jsp"><i class="fas fa-sign-in-alt"></i> 返回登录页面</a>    
            <% } %>
        </div>
    </div>
</body>
</html>