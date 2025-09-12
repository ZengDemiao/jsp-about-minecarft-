<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <title>玩家信息 - Modrinth风格</title>
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
                              url('https://images.unsplash.com/photo-1607513746994-51f730a44832?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
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
        
        .player-card {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 25px;
        }
        
        .info-row {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            width: 120px;
            color: var(--text-secondary);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-label i {
            color: var(--accent-primary);
            width: 24px;
            text-align: center;
        }
        
        .info-value {
            flex: 1;
            font-weight: 500;
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
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: var(--border-radius);
            border: none;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
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
            text-align: center;
        }
        
        .back-links a {
            color: var(--accent-primary);
            text-decoration: none;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin: 0 10px;
        }
        
        .back-links a:hover {
            color: #6aa6ff;
            text-decoration: underline;
        }
        
        .msg {
            color: var(--accent-danger);
            font-size: 14px;
            padding: 15px;
            background: rgba(255, 71, 87, 0.1);
            border-radius: var(--border-radius);
            border: 1px solid var(--accent-danger);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        @media (max-width: 600px) {
            .info-row {
                flex-direction: column;
                gap: 5px;
            }
            
            .info-label {
                width: 100%;
            }
            
            .btn {
                padding: 10px 15px;
                font-size: 14px;
            }
        }
    </style>
</head>
  
<body>
    <div class="container">
        <div class="header">
            <h2><i class="fas fa-user"></i> 玩家信息</h2>
        </div>
        
        <span class="msg">
        <%
            request.setCharacterEncoding("UTF-8");
            String msg = "";    
            String label = "</span></div></body></html>";    
            String back = "&emsp;<a href='javascript:window.history.back();' style='color:var(--accent-primary);'>后退</a>" + label;        //后退链接
            
            if (session.getAttribute("myRole") == null) {                 //如果此session属性不存在或已经失效
                msg = "<br>您的登录已失效！请重新登录。";
                msg += "&emsp;<a href='index.jsp' style='color:var(--accent-primary);'>玩家登录</a>" + label;    
                out.print(msg);
                return;
            }
            
            String myRole = session.getAttribute("myRole").toString();    //获取session中该对象的值

            String userId = request.getParameter("userId");             //获取地址栏参数userId的值
            
            try {                                     
                Integer.parseInt(userId);                                //如果不能转换为整数   
            } catch (Exception e) {
                msg = "参数userId错误！" + back;
                out.print(msg);
                return;
            }
            
            String myUserId = session.getAttribute("myUserId").toString();                //取得session中的值
        
            if (userId.equals(myUserId) == false && myRole.equals("admin") == false) {     //如果不是自己，且不是管理员
                msg = "您只能查看自己的信息！" + back;
                out.print(msg);
                return;
            }
            
            Db db = new Db();                                            //新建实例（该实例实现了数据的增删改查）
            String sql = ""; 
            ResultSet rs = null;
            
            sql = "select * from tb_user where userId = ?";                 //SQL查询语句        
            rs = db.select(sql, userId);                                 //执行查询

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
            
            username     = rs.getString("username");         //获取字段的值
            realName     = rs.getString("realName");
            role         = rs.getString("role");
            timeRenew    = rs.getString("timeRenew");        //在连接MySQL 8时指定了时区地点，则获取到的时间不需格式化
            db.close();
            
            // 为角色添加样式
            String roleClass = "role-tag ";
            if (role != null) {
                if (role.equals("admin")) {
                    roleClass += "role-admin";
                } else if (role.equals("user")) {
                    roleClass += "role-user";
                } else {
                    roleClass += "role-guest";
                }
            }
        %>
        </span>

        <div class="player-card">
            <div class="info-row">
                <div class="info-label">
                    <i class="fas fa-user"></i>
                    <span>玩家名称</span>
                </div>
                <div class="info-value"><%= username %></div>
            </div>
            
            <div class="info-row">
                <div class="info-label">
                    <i class="fas fa-id-card"></i>
                    <span>真实姓名</span>
                </div>
                <div class="info-value"><%= realName %></div>
            </div>
            
            <div class="info-row">
                <div class="info-label">
                    <i class="fas fa-user-tag"></i>
                    <span>角色权限</span>
                </div>
                <div class="info-value">
                    <span class="<%= roleClass %>"><%= role %></span>
                </div>
            </div>
            
            <div class="info-row">
                <div class="info-label">
                    <i class="fas fa-clock"></i>
                    <span>最后更新</span>
                </div>
                <div class="info-value"><%= timeRenew %></div>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="userEdit.jsp?userId=<%= userId %>" class="btn btn-primary">
                <i class="fas fa-edit"></i> 修改资料
            </a>
            <% if (myRole.equals("admin") && myUserId.equals(userId) == false) {  %>
            <a href="userDeleteDo.jsp?userId=<%= userId %>" 
               class="btn btn-danger"
               onclick="return confirm('确定要删除这位玩家吗？该操作不可恢复！');">
                <i class="fas fa-trash-alt"></i> 删除玩家
            </a>
            <% } %>
        </div>
        
        <div class="msg">${ msg }</div>

        <div class="back-links">
            <% if (myRole.equals("admin")) {  %>
                <a href="main.jsp"><i class="fas fa-arrow-left"></i> 返回模组中心</a>
            <% } else { %>
                <a href="main.jsp"><i class="fas fa-arrow-left"></i> 返回功能页面</a>
            <% } %>
            <a href="userList.jsp"><i class="fas fa-users"></i> 查看所有玩家</a>
        </div>
    </div>
</body>
</html>