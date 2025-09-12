<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新添模组 - Modrinth风格</title>
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
            max-width: 600px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .header {
            text-align: center;
            margin-bottom: 20px;
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
        
        textarea.form-input {
            min-height: 120px;
            resize: vertical;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            flex-wrap: wrap;
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
        
        .btn-secondary {
            background: rgba(160, 168, 192, 0.2);
            color: var(--text-secondary);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .btn-secondary:hover {
            background: rgba(160, 168, 192, 0.3);
            color: var(--text-primary);
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
        
        .msg {
            color: var(--accent-danger);
            font-size: 14px;
            padding: 10px;
            background: rgba(255, 71, 87, 0.1);
            border-radius: var(--border-radius);
            border: 1px solid var(--accent-danger);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .radio-container {
            display: flex;
            gap: 20px;
            margin-top: 8px;
        }
        
        .radio-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .radio-item input[type="radio"] {
            width: 18px;
            height: 18px;
            accent-color: var(--accent-primary);
        }
        
        .radio-item label {
            color: var(--text-secondary);
        }
        
        .required::after {
            content: "*";
            color: var(--accent-danger);
            margin-left: 4px;
        }
        
        @media (max-width: 500px) {
            .btn {
                min-width: 100%;
            }
            
            .radio-container {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
  
<body>
    <div class="container">
        <div class="header">
            <h2><i class="fas fa-cube"></i> 新添模组</h2>
        </div>
        
        <span class="msg">
        <%
            request.setCharacterEncoding("UTF-8");
            String msg = "";	
            String label = "</span></div></body></html>";	
            String back = "&emsp;<a href='javascript:window.history.back();' class='back-link'>后退</a>" + label;
            
            if (session.getAttribute("myRole") == null) { 					//如果此session属性不存在或已经失效
                msg = "<br>您的登录已失效！请重新登录。";
                msg += "&emsp;<a href='index.jsp' class='back-link'>玩家登录</a>" + label;	
                out.print(msg);
                return;
            }

            String myRole = session.getAttribute("myRole").toString();		//获取session中该对象的值

            if (!myRole.equals("admin")) { 							//如果不是管理员		
                msg = "您的权限不足！";
                msg += "&emsp;<a href='main.jsp' class='back-link'>玩家功能</a>" + label;
                out.print(msg);
                return;
            }
        %>
        </span>

        <form action="modAddDo.jsp" method="post">
            <div class="form-container">
                <div class="form-row">
                    <label for="modNo" class="form-label required">
                        <i class="fas fa-hashtag"></i> 模组编号
                    </label>
                    <input type="text" id="modNo" class="form-input" name="modNo" maxlength="8" placeholder="输入模组编号" required>
                </div>
                
                <div class="form-row">
                    <label for="modName" class="form-label required">
                        <i class="fas fa-font"></i> 模组名称
                    </label>
                    <input type="text" id="modName" class="form-input" name="modName" maxlength="45" placeholder="输入模组名称" required>
                </div>
                
                <div class="form-row">
                    <label class="form-label required">
                        <i class="fas fa-server"></i> 适用服务器
                    </label>
                    <div class="radio-container">
                        <div class="radio-item">
                            <input type="radio" id="pc" name="server" value="男" required>
                            <label for="pc">PC端</label>
                        </div>
                        <div class="radio-item">
                            <input type="radio" id="netease" name="server" value="女">
                            <label for="netease">网易端</label>
                        </div>
                    </div>
                </div>
                
                <div class="form-row">
                    <label for="year" class="form-label">
                        <i class="fas fa-calendar-alt"></i> 发布年份
                    </label>
                    <input type="text" id="year" class="form-input" name="year" maxlength="3" placeholder="输入发布年份">
                </div>
                
                <div class="form-row">
                    <label for="version" class="form-label">
                        <i class="fas fa-code-branch"></i> 版本类型
                    </label>
                    <input type="text" id="version" class="form-input" name="version" maxlength="45" placeholder="输入版本类型">
                </div>
                
                <div class="form-row">
                    <label for="note" class="form-label">
                        <i class="fas fa-sticky-note"></i> 备注
                    </label>
                    <textarea id="note" class="form-input" name="note" placeholder="输入模组备注信息..."></textarea>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i> 添加模组
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-redo"></i> 重置表单
                    </button>
                </div>
            </div>
        </form>
        
        <div class="back-links">
            <a href="modAdmin.jsp"><i class="fas fa-arrow-left"></i> 返回模组管理</a>
            <a href="main.jsp"><i class="fas fa-home"></i> 返回主页面</a>
        </div>
    </div>
</body>
</html>