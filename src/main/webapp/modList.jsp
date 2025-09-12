<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <title>模组列表 - Modrinth风格</title>
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
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 20px auto;
        }
        
        /* 头部导航 */
        .header {
            background: rgba(22, 27, 37, 0.9);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius);
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .brand {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .logo {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: bold;
            color: white;
        }
        
        .brand-text {
            font-size: 22px;
            font-weight: 700;
            background: linear-gradient(90deg, var(--accent-primary), #8a2be2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 14px;
        }
        
        .user-info span {
            color: var(--text-secondary);
        }
        
        .user-info a {
            color: var(--accent-primary);
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .user-info a:hover {
            color: #6aa6ff;
            text-decoration: underline;
        }
        
        .nav-links {
            display: flex;
            gap: 25px;
            margin-top: 8px;
        }
        
        .nav-links a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: var(--transition);
            font-size: 15px;
            position: relative;
            padding: 5px 0;
        }
        
        .nav-links a:hover, 
        .nav-links a.active {
            color: var(--text-primary);
        }
        
        .nav-links a.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--accent-primary);
            border-radius: 2px;
        }
        
        /* 搜索区域 */
        .search-section {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .section-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .section-title h2 {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title h2 i {
            color: var(--accent-primary);
        }
        
        .search-container {
            display: flex;
            gap: 15px;
        }
        
        .search-box {
            flex: 1;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 14px 20px 14px 45px;
            border-radius: 50px;
            border: none;
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 16px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: var(--transition);
        }
        
        .search-box input:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(58, 134, 255, 0.2);
        }
        
        .search-box i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        
        .search-btn {
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            color: white;
            border: none;
            border-radius: 50px;
            padding: 0 30px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .search-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(58, 134, 255, 0.3);
        }
        
        .search-note {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 12px;
            padding-left: 10px;
        }
        
        /* 模组表格 */
        .mods-container {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .mods-header {
            display: grid;
            grid-template-columns: 60px 1fr 1.2fr 1fr 0.8fr 0.8fr 1.2fr;
            padding: 16px 25px;
            background: var(--bg-secondary);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .mod-item {
            display: grid;
            grid-template-columns: 60px 1fr 1.2fr 1fr 0.8fr 0.8fr 1.2fr;
            padding: 18px 25px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: var(--transition);
            cursor: pointer;
            position: relative;
        }
        
        .mod-item:last-child {
            border-bottom: none;
        }
        
        .mod-item:hover {
            background: var(--bg-hover);
        }
        
        .mod-item:hover::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            width: 3px;
            background: var(--accent-primary);
        }
        
        .mod-index {
            font-weight: 600;
            color: var(--text-secondary);
        }
        
        .mod-id {
            color: var(--accent-primary);
            font-weight: 500;
        }
        
        .mod-name {
            font-weight: 600;
        }
        
        .mod-server {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .server-icon {
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
        }
        
        .mod-note {
            color: var(--text-secondary);
            font-size: 14px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        /* 空状态 */
        .empty-state {
            padding: 50px 20px;
            text-align: center;
            color: var(--text-secondary);
        }
        
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            color: var(--accent-primary);
        }
        
        .empty-state p {
            margin-top: 10px;
            font-size: 16px;
        }
        
        /* 响应式设计 */
        @media (max-width: 900px) {
            .mods-header, .mod-item {
                grid-template-columns: 50px 1fr 1fr;
                grid-template-areas: 
                    "index id name"
                    ". server year"
                    ". version note";
            }
            
            .mods-header {
                display: none;
            }
            
            .mod-index { grid-area: index; }
            .mod-id { grid-area: id; }
            .mod-name { grid-area: name; }
            .mod-server { grid-area: server; margin-top: 10px; }
            .mod-year { grid-area: year; margin-top: 10px; }
            .mod-version { grid-area: version; margin-top: 10px; }
            .mod-note { grid-area: note; margin-top: 10px; }
            
            .mod-item {
                padding: 20px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
        }
        
        @media (max-width: 600px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .user-info {
                flex-direction: column;
                gap: 10px;
            }
            
            .search-container {
                flex-direction: column;
            }
            
            .nav-links {
                justify-content: center;
                flex-wrap: wrap;
                gap: 15px;
            }
        }
    </style>
</head>
  
<body>
    <div class="container">
        <%
            request.setCharacterEncoding("UTF-8");
            String msg = "";    
            String label = "</span></div></body></html>";    
            String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;        //后退链接

            if (session.getAttribute("myRole") == null) {                             //如果此session属性不存在或已经失效
                msg = "<br>您的登录已失效！请重新登录。";
                msg += "&emsp;<a href='index.jsp'>用户登录</a>" + label;    
                out.print(msg);
                return;
            }

            String myRole = session.getAttribute("myRole").toString();                //获取session中该对象的值
            
            if (myRole.equals("admin") == false && myRole.equals("user") == false) {  //如果是新用户guest    
                msg = "您的权限不足！";
                msg += "&emsp;<a href='main.jsp'>用户功能</a>" + label;
                out.print(msg);
                return;
            }
            
            String linkAdmin = "";                                                    //管理链接
            
            if (myRole.equals("admin")) {                                             //如果为管理员
                linkAdmin = "&nbsp;&emsp;|&emsp;&nbsp;<a href='modAdmin.jsp'>模组管理</a>"
                    + "&nbsp;&emsp;<a href='userAdmin.jsp'>用户管理</a>";            //生成管理链接
            } 
            
            String search         = "";                                   //搜索内容
            String buttonSearch    = request.getParameter("buttonSearch");    //搜索按钮
            
            if (buttonSearch != null && request.getParameter("search") != null) {     //如果单击了搜索按钮
                search = request.getParameter("search").trim();                     //搜索内容            
            }

            Db db = new Db();                                           //新建实例（该实例实现了数据的增删改查）
            String sql = ""; 
            ResultSet rs = null;
            String sqlWhere = "";
            
            if (search.equals("") == false) {                            //如果有搜索内容
                // 多字段模糊查询：模组编号、模组名称、服务器
                sqlWhere = " where concat_ws(',', modNo, modName, server) like ?";
                db.setCanShowSql(true);                                    //将在控制台输出SQL语句
            }        
            
            if (search.equals("")) {                                    //没搜索，或无搜索内容    
                sql = "select * from tb_mod order by modNo";            // SQL查询语句（使用tb_mod表）
                rs = db.select(sql);                                     //执行查询，得到结果集
            } else {                                                    //有搜索内容
                sql = "select * from tb_mod " + sqlWhere + " order by modNo";    //SQL模糊查询语句
                rs = db.select(sql, "%" + search + "%");                 //增加含有查询内容的参数
            }
            
            if (rs == null) {        
                msg = "数据库操作发生错误！" + back;
                out.print(msg);
                return;                                                    //结束页面的执行
            }
        %> 
        
        <!-- 顶部导航 -->
        <div class="header">
            <div class="brand">
                <div class="logo">M</div>
                <div class="brand-text">Modrinth风格模组库</div>
            </div>
            
            <div class="user-info">
                <span>欢迎：${ myUsername }（${ myRole }）</span>
                <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> 注销登录</a>
                <a href="userShow.jsp?userId=${ myUserId }"><i class="fas fa-user"></i> 个人信息</a>
            </div>
        </div>
        
        <!-- 导航链接 -->
        <div class="nav-links">
            <a href="main.jsp">用户功能</a>
            <a href="modList.jsp" class="active">模组列表</a>
            <a href="modPage.jsp">模组分页</a>
            <% if (myRole.equals("admin")) { %>
                <a href="modAdmin.jsp">模组管理</a>
                <a href="userAdmin.jsp">用户管理</a>
            <% } %>
        </div>
        
        <!-- 搜索区域 -->
        <div class="search-section">
            <div class="section-title">
                <h2><i class="fas fa-cube"></i> 模组列表</h2>
            </div>
            
            <form action="" method="post">
                <div class="search-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" value="<%= search %>" placeholder="搜索模组...">
                    </div>
                    <button type="submit" name="buttonSearch" class="search-btn">搜索</button>
                </div>
                <div class="search-note">在模组编号、名称、服务器中搜索</div>
            </form>
        </div>
        
        <!-- 模组列表 -->
        <div class="mods-container">
            <div class="mods-header">
                <div>序号</div>
                <div>模组编号</div>
                <div>模组名称</div>
                <div>服务器</div>
                <div>年份</div>
                <div>版本</div>
                <div>备注</div>
            </div>
            
            <%
                int i = 0;                                                 //序号
                String modNo, modName, server, year, version, note;
                boolean hasRecords = false;

                while (rs != null && rs.next()) {                           //如果读到了数据
                    i++;
                    hasRecords = true;
                    modNo    = rs.getString("modNo");               //获取字段的值
                    modName = rs.getString("modName");
                    server     = rs.getString("server");
                    year     = rs.getString("year"); if ("0".equals(year)) year = "";
                    version = rs.getString("version");
                    note     = rs.getString("note");
            %>
            <div class="mod-item">
                <div class="mod-index"><%= i %></div>
                <div class="mod-id"><%= modNo %></div>
                <div class="mod-name"><%= modName %></div>
                <div class="mod-server">
                    <div class="server-icon"><i class="fas fa-server"></i></div>
                    <div><%= server %></div>
                </div>
                <div class="mod-year"><%= year %></div>
                <div class="mod-version"><%= version %></div>
                <div class="mod-note"><%= (note != null && !note.isEmpty()) ? note : "" %></div>
            </div>
            <%
                }                            
                if (db != null) db.close();         //用完立即关闭数据库连接
                
                if (!hasRecords) {
                    msg = "没有找到模组记录";
            %>
            <div class="empty-state">
                <i class="fas fa-box-open"></i>
                <h3>没有模组数据</h3>
                <p><%= msg %></p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>