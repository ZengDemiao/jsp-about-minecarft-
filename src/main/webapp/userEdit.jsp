<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <title>修改用户 - Modrinth风格</title>
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
            --accent-danger: #ff4757;
            --accent-success: #00b894;
            --text-primary: #e6e9f0;
            --text-secondary: #a0a8c0;
            --border-radius: 12px;
            --transition: all 0.25s ease;
        }
        
        body {
            background: var(--bg-primary);
            color: var(--text-primary);
            background-image: radial-gradient(circle at 10% 20%, rgba(15, 31, 49, 0.8) 0%, rgba(10, 18, 30, 0.9) 90%), 
                              url('https://www.minecraft.net/content/dam/minecraft/touchup-2020/minecraft-background-creepers-v2.jpg');
            background-blend-mode: multiply;
            background-size: cover;
            background-attachment: fixed;
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
            margin-bottom: 30px;
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
        
        .form-note {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 8px;
            display: block;
        }
        
        .radio-group {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .radio-option {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        
        .radio-option input[type="radio"] {
            appearance: none;
            width: 18px;
            height: 18px;
            border: 2px solid var(--text-secondary);
            border-radius: 50%;
            position: relative;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .radio-option input[type="radio"]:checked {
            border-color: var(--accent-primary);
        }
        
        .radio-option input[type="radio"]:checked::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 10px;
            height: 10px;
            background: var(--accent-primary);
            border-radius: 50%;
        }
        
        .role-tag {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .role-guest {
            background: rgba(160, 168, 192, 0.2);
            color: var(--text-secondary);
        }
        
        .role-user {
            background: rgba(58, 134, 255, 0.2);
            color: var(--accent-primary);
        }
        
        .role-admin {
            background: rgba(255, 71, 87, 0.2);
            color: var(--accent-danger);
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn {
            flex: 1;
            min-width: 150px;
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
        
        .btn-danger {
            background: linear-gradient(135deg, var(--accent-danger), #ff6b81);
            color: white;
        }
        
        .btn-danger:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 71, 87, 0.3);
        }
        
        .back-links {
            margin-top: 25px;
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
        
        @media (max-width: 600px) {
            .btn {
                min-width: 100%;
            }
            
            .radio-group {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
  
<body>
    <div class="container">
        <div class="header">
            <h2><i class="fas fa-user-edit"></i> 修改用户信息</h2>
        </div>
        
        <span class="msg">
        <%
            request.setCharacterEncoding("UTF-8");
            String msg = "";  
            String label = "</span></div></body></html>";  
            String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;    //后退链接
            
            if (session.getAttribute("myRole") == null) {           //如果此session属性不存在或已经失效
                msg = "<br>您的登录已失效！请重新登录。";
                msg += "&emsp;<a href='index.jsp'>用户登录</a>" + label;  
                out.print(msg);
                return;
            }
            
            String myRole = session.getAttribute("myRole").toString();    //获取session中该对象的值

            String userId = request.getParameter("userId");        //获取地址栏参数userId的值
            
            try {                                   
                Integer.parseInt(userId);                 //如果不能转换为整数   
            } catch (Exception e) {
                msg = "参数userId错误！" + back;
                out.print(msg);
                return;
            }
            
            String myUserId = session.getAttribute("myUserId").toString();    //取得session中的值

            if (userId.equals(myUserId) == false && myRole.equals("admin") == false) {   //如果不是自己，且不是管理员
                msg = "您只能修改自己的信息！" + back;
                out.print(msg);
                return;
            }
            
            Db db = new Db();                      //新建实例（该实例实现了数据的增删改查）
            String sql = ""; 
            ResultSet rs = null;
            
            sql = "select * from tb_user where userId = ?";        //SQL查询语句    
            rs = db.select(sql, userId);                 //执行查询

            if (rs == null) {        
                msg = "数据库操作发生错误！" + back;
                out.print(msg);
                return;
            }
            
            if (rs.next() == false) {
                db.close();
                msg = "对应的记录已不存在！" + back;
                out.print(msg);
                return;
            }

            String username = "", realName = "", role = "", timeRenew = "";
            
            username   = rs.getString("username");      //获取字段的值
            realName   = rs.getString("realName");
            role     = rs.getString("role");
            timeRenew  = rs.getString("timeRenew");    //在连接MySQL 8时指定了时区地点，则获取到的时间不需格式化
            db.close();  
            
            String checkedGuest = "", checkedUser = "", checkedAdmin = "";
            
            if (role.equals("guest")) {
                checkedGuest = "checked";
            } else if (role.equals("user")) {
                checkedUser = "checked";
            } else if (role.equals("admin")) {
                checkedAdmin = "checked";
            }
        %>
        </span>

        <form action="userEditDo.jsp?userId=<%= userId %>" method="post">
            <div class="form-container">
                <div class="form-row">
                    <label for="username"><i class="fas fa-user"></i> 用户名</label>
                    <input type="text" class="form-input" value="<%= username %>" disabled>
                </div>
                
                <div class="form-row">
                    <label for="password"><i class="fas fa-lock"></i> 密码</label>
                    <input type="password" class="form-input" name="password" maxlength="45" placeholder="输入新密码">
                    <span class="form-note">* 不修改请留空</span>
                </div>
                
                <div class="form-row">
                    <label for="password2"><i class="fas fa-lock"></i> 密码确认</label>
                    <input type="password" class="form-input" name="password2" maxlength="45" placeholder="再次输入新密码">
                    <span class="form-note">* 不修改请留空</span>
                </div>
                
                <div class="form-row">
                    <label for="realName"><i class="fas fa-id-card"></i> 真实姓名</label>
                    <input type="text" class="form-input" name="realName" maxlength="45" value="<%= realName %>" placeholder="输入真实姓名">
                </div>
                
                <div class="form-row">
                    <label><i class="fas fa-user-tag"></i> 角色级别</label>
                    <div class="radio-group">
                        <label class="radio-option">
                            <input type="radio" name="role" value="guest" <%= checkedGuest %>>
                            <span class="role-tag role-guest">村民</span>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="role" value="user" <%= checkedUser %>>
                            <span class="role-tag role-user">玩家</span>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="role" value="admin" <%= checkedAdmin %>>
                            <span class="role-tag role-admin">管理员</span>
                        </label>
                    </div>
                </div>
                
                <div class="form-row">
                    <label for="timeRenew"><i class="fas fa-clock"></i> 更新时间</label>
                    <input type="text" class="form-input" value="<%= timeRenew %>" disabled>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> 提交修改
                    </button>
                    <a href="userShow.jsp?userId=<%= userId %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> 取消
                    </a>
                </div>
            </div>
        </form>
        
        <div class="back-links">
            <% if (myRole.equals("admin")) {  %>
                <a href="main.jsp"><i class="fas fa-arrow-left"></i> 返回模组中心</a>
            <% } else { %>
                <a href="main.jsp"><i class="fas fa-arrow-left"></i> 返回用户功能页</a>
            <% } %>
            <a href="userShow.jsp?userId=<%= userId %>"><i class="fas fa-user"></i> 返回详情页</a>
        </div>
    </div>
</body>
</html>