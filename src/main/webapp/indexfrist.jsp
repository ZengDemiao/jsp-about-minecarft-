<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>我的世界模组中心</title>
    <style>
        /* 全屏iframe样式 */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            font-family: 'Minecraft', Arial, sans-serif;
        }
        
        #website-frame {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
            z-index: 1;
        }
        
        /* 覆盖在iframe上方的登录按钮 */
        .login-overlay {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10;
            padding: 10px 20px;
            background-color: #000000;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-family: 'Minecraft', Arial, sans-serif;
            font-size: 16px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            transition: all 0.3s;
        }
        
        .login-overlay:hover {
            background-color: #FFCC00;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
    <!-- 全屏显示您的网站 -->
    <iframe id="website-frame" src="https://corona.studio/"></iframe>
    
    <!-- 登录按钮覆盖在网站上方 -->
    <button class="login-overlay" onclick="redirectToLogin()">用户登录</button>
    
    <script>
        function redirectToLogin() {
            // 跳转到真正的登录页面
            window.location.href = "index.jsp";
        }
    </script>
</body>
</html>