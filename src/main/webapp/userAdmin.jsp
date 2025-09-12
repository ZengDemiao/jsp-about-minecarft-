<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <title>玩家管理 - Modrinth风格</title>
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
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        
        .nav-links a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: var(--transition);
            font-size: 15px;
            position: relative;
            padding: 5px 0;
            display: flex;
            align-items: center;
            gap: 6px;
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
        
        /* 页面标题 */
        .page-title {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .page-title h1 {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(90deg, var(--accent-primary), var(--accent-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .page-title i {
            font-size: 32px;
            color: var(--accent-primary);
        }
        
        /* 搜索区域 */
        .admin-tools {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .search-container {
            display: flex;
            gap: 15px;
            flex: 1;
            max-width: 600px;
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
        
        .add-user-btn {
            background: linear-gradient(135deg, #00b894, var(--accent-primary));
            color: white;
            border: none;
            border-radius: 50px;
            padding: 0 30px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .add-user-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 184, 148, 0.3);
        }
        
        .search-note {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 12px;
            padding-left: 10px;
        }
        
        /* 玩家表格 */
        .users-container {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 25px;
            overflow-x: auto;
        }
        
        .users-header {
            display: grid;
            grid-template-columns: 60px 1.5fr 1.5fr 1fr 1.5fr 1.5fr 100px 80px;
            padding: 16px 25px;
            background: var(--bg-secondary);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .user-item {
            display: grid;
            grid-template-columns: 60px 1.5fr 1.5fr 1fr 1.5fr 1.5fr 100px 80px;
            padding: 18px 25px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: var(--transition);
            position: relative;
        }
        
        .user-item:last-child {
            border-bottom: none;
        }
        
        .user-item:hover {
            background: var(--bg-hover);
        }
        
        .user-item:hover::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            width: 3px;
            background: var(--accent-primary);
        }
        
        .user-index {
            font-weight: 600;
            color: var(--text-secondary);
        }
        
        .user-name {
            font-weight: 600;
        }
        
        .user-realname {
            color: var(--accent-primary);
        }
        
        .user-role {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .role-admin {
            background: rgba(255, 71, 87, 0.15);
            color: var(--accent-danger);
        }
        
        .role-user {
            background: rgba(58, 134, 255, 0.15);
            color: var(--accent-primary);
        }
        
        .role-guest {
            background: rgba(160, 168, 192, 0.15);
            color: var(--text-secondary);
        }
        
        .action-cell {
            display: flex;
            gap: 10px;
        }
        
        .action-btn {
            background: rgba(58, 134, 255, 0.15);
            color: var(--accent-primary);
            border: none;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 13px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .action-btn:hover {
            background: rgba(58, 134, 255, 0.25);
        }
        
        .edit-btn {
            background: rgba(0, 184, 148, 0.15);
            color: #00b894;
        }
        
        .edit-btn:hover {
            background: rgba(0, 184, 148, 0.25);
        }
        
        /* 复选框 */
        .checkbox-container {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .custom-checkbox {
            position: relative;
            display: inline-block;
            width: 20px;
            height: 20px;
        }
        
        .custom-checkbox input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .checkmark {
            position: absolute;
            top: 0;
            left: 0;
            height: 20px;
            width: 20px;
            background-color: var(--bg-secondary);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            transition: var(--transition);
        }
        
        .custom-checkbox input:checked ~ .checkmark {
            background-color: var(--accent-primary);
            border-color: var(--accent-primary);
        }
        
        .checkmark:after {
            content: "";
            position: absolute;
            display: none;
            left: 7px;
            top: 3px;
            width: 5px;
            height: 10px;
            border: solid white;
            border-width: 0 2px 2px 0;
            transform: rotate(45deg);
        }
        
        .custom-checkbox input:checked ~ .checkmark:after {
            display: block;
        }
        
        /* 分页控件 */
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 20px 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .pagination-info {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .pagination-info strong {
            color: var(--accent-primary);
        }
        
        .pagination-controls {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .pagination-btn {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: none;
            border-radius: 6px;
            padding: 8px 15px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .pagination-btn:hover:not(:disabled) {
            background: var(--bg-hover);
        }
        
        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .pagination-btn.active {
            background: var(--accent-primary);
            color: white;
        }
        
        .pagination-input {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .pagination-input input {
            background: var(--bg-secondary);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--text-primary);
            border-radius: 6px;
            padding: 8px 12px;
            width: 60px;
            text-align: center;
        }
        
        .pagination-input button {
            background: var(--accent-primary);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 15px;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .pagination-input button:hover {
            opacity: 0.9;
        }
        
        /* 删除按钮 */
        .delete-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            margin-bottom: 30px;
        }
        
        .delete-btn {
            background: linear-gradient(135deg, var(--accent-danger), #ff6b81);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .delete-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 71, 87, 0.3);
        }
        
        /* 消息提示 */
        .msg {
            color: var(--accent-danger);
            font-size: 16px;
            padding: 15px;
            background: rgba(255, 71, 87, 0.1);
            border-radius: var(--border-radius);
            border: 1px solid var(--accent-danger);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* 空状态 */
        .empty-state {
            padding: 50px 20px;
            text-align: center;
            color: var(--text-secondary);
            grid-column: 1 / -1;
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
            .users-header, .user-item {
                grid-template-columns: 50px 1fr 1fr;
                grid-template-areas: 
                    "index username realname"
                    ". role time"
                    ". action checkbox";
            }
            
            .users-header {
                display: none;
            }
            
            .user-index { grid-area: index; }
            .user-name { grid-area: username; }
            .user-realname { grid-area: realname; margin-top: 10px; }
            .user-role { grid-area: role; margin-top: 10px; }
            .user-time { grid-area: time; margin-top: 10px; }
            .user-action { grid-area: action; margin-top: 10px; }
            .user-checkbox { grid-area: checkbox; margin-top: 10px; }
            
            .user-item {
                padding: 20px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
            
            .pagination {
                flex-direction: column;
                gap: 15px;
            }
            
            .delete-section {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
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
            
            .admin-tools {
                flex-direction: column;
            }
            
            .search-container {
                flex-direction: column;
            }
            
            .nav-links {
                justify-content: center;
                gap: 15px;
            }
            
            .pagination-controls {
                flex-wrap: wrap;
                justify-content: center;
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
                msg += "&emsp;<a href='index.jsp'>玩家登录</a>" + label;    
                out.print(msg);
                return;
            }
            
            String myRole = session.getAttribute("myRole").toString();                //获取session中该对象的值
            
            if (myRole.equals("admin") == false) {                                    //如果如果不是管理员    
                msg = "您的权限不足！";
                msg += "&emsp;<a href='main.jsp'>玩家功能</a>" + label;
                out.print(msg);
                return;
            }
            
            String linkAdmin = "";                                                    //管理链接
            
            if (myRole.equals("admin")) {                                             //如果为管理员
                linkAdmin = "&nbsp;&emsp;|&emsp;&nbsp;<a href='modAdmin.jsp'>模组管理</a>"
                    + "&nbsp;&emsp;<a href='userAdmin.jsp'>玩家管理</a>";            //生成管理链接
            }
        
            if (request.getParameter("buttonDelete") != null) {                     //如果单击了删除按钮
                String[] userIdList = request.getParameterValues("userId");         //userId列表            
                
                if (userIdList != null) {
                    String myUserId = session.getAttribute("myUserId").toString();    //获取session中该对象的值
                    String userIdAll = "";    
                    
                    for (int i = 0; i < userIdList.length; i++) {
                        try {                                       
                            Integer.parseInt(userIdList[i]);            //尝试转换为整数，即判断其是否为整数   
                        } catch (Exception e) {
                            continue;                                    //如果转换失败，即不是整数，则略过此项
                        }
        
                        if (userIdList[i].equals(myUserId)) {             //如果是自己
                            continue;                                    //则略过此项
                        }
                        
                        userIdAll += "," + userIdList[i];    
                    }
                    
                    if (userIdAll.isEmpty() == false) {                //如果有值
                        userIdAll = userIdAll.substring(1);            //去除最前面的逗号
                        
                        Db db2 = new Db();                                //新建实例（该实例实现了数据的增删改查）
                        String sql2 = "delete from tb_user where userId in (" + userIdAll + ")";
                        int count = db2.delete(sql2);                    //批量删除记录    
                        
                        msg = "成功删除了" + count + "个玩家！";
                        request.setAttribute("msg", msg);
                    }
                }
            }    

            String search         = "";                                    //搜索内容
            String buttonSearch    = request.getParameter("buttonSearch");    //搜索按钮        
            String buttonPage      = request.getParameter("buttonPage");     //页码提交按钮
            String pageInput      = "1";                                    //输入的页码
            
            if (buttonSearch != null && request.getParameter("search") != null) {     //如果单击了搜索按钮
                search = request.getParameter("search").trim();                     //搜索内容        
                    
            } else if (buttonPage != null && request.getParameter("search") != null) {     //如果单击了页码提交按钮
                search = request.getParameter("search").trim();                     //搜索内容
                pageInput = request.getParameter("pageShow");                         //页码输入框中的值
                
            } else {                                                     //点击了页码链接，或者刚打开此页
                if (request.getParameter("searchUrl") != null) { 
                    search = request.getParameter("searchUrl");         //不需要进行解码操作，系统会自动解码
                }
                
                if (request.getParameter("pageUrl") != null) {            //地址栏中的页码
                    pageInput = request.getParameter("pageUrl");
                }
            }
            
            String searchUrl = "";
            
            if (search.equals("") == false) {
                searchUrl = URLEncoder.encode(search, "UTF-8");            //进行URL编码，以便在地址栏传递参数
            }
            
            Db db = new Db();                                            //新建实例（该实例实现了数据的增删改查）
            String sql = ""; 
            ResultSet rs = null;
            String sqlWhere = "";
            
            if (search.equals("") == false) {                            //如果有搜索内容
                sqlWhere = " where concat_ws(',', userName, realName, role) like ?";    //多字段模糊查询
            }    
            
            //--->>>-------------查询记录总数        
            if (search.equals("")) {                                    //没搜索，或无搜索内容
                sql = "select count(*) from tb_user";                     //SQL查询语句
                rs = db.select(sql);                                     //执行查询，得到结果集
            } else {                                                    //如果有搜索内容    
                sql = "select count(*) from tb_user " + sqlWhere;         //SQL模糊查询语句
                rs = db.select(sql, "%" + search + "%");                 //增加含有查询内容的参数
            }
            
            if (rs == null) {        
                msg = "数据库操作发生错误！" + back;
                out.print(msg);
                return;
            }
                
            int countRow = 0;
                
            if(rs.next()) {                                    //如果读取下一条记录成功
                countRow = rs.getInt(1);                     //读取第1个字段的值（整数）
            }            
            rs.close();                                        //用完立即关闭rs，但没关闭数据库连接
            //---<<<-------------查询记录总数
            
            //--->>>-------------开始数据分页
            int pageSize  = 3;                                //每页3条记录
            int pageCount = 0;                                 //总页数预设为0

            if (countRow % pageSize == 0) {                    //如果余数为0，即能整除
                pageCount = countRow / pageSize;             //总页数
            } else {
                pageCount = countRow / pageSize + 1;        //不能整除则加1页。如果除数为小数，将自动去除小数部分得到整数            
            }
            
            int pageShow = 1;                                 //当前页预设为1
            try {                                      
                pageShow = Integer.parseInt(pageInput);        //如果是数字，返回字符串对应的整数   
            } catch (Exception e) {
                //showPage = 1;                             //如果抛出异常，则取预设值
            }                

            if (pageShow < 1) {                                //如果当前页码小于1
                pageShow = 1;
            } else if (pageShow > pageCount && pageCount >= 1) {         //如果当前页码大于总页数，且总页数>=1
                pageShow = pageCount;
            }
            
            int indexStart = 0;                                            //查询记录时的起始位置    
            indexStart = (pageShow - 1) * pageSize;                        //已经显示的记录条数    
                        
            if (search.equals("")) {                                    //没搜索，或无搜索内容    
                sql = "select * from tb_user order by username"            //SQL查询语句
                    + " limit " + indexStart + "," + pageSize;             //只获取该页的记录
                rs = db.select(sql);                                     //执行查询，得到结果集
            } else {                                                    //没搜索，或无搜索内容
                sql = "select * from tb_user " + sqlWhere + " order by username"    //SQL模糊查询语句
                    + " limit " + indexStart + "," + pageSize;             //只获取该页的记录
                rs = db.select(sql, "%" + search + "%");                 //增加含有查询内容的参数
            }
            
            if (rs == null) {        
                msg = "数据库操作发生错误！" + back;
                out.print(msg);
                return;
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
            </div>
        </div>
        
        <!-- 页面标题 -->
        <div class="page-title">
            <i class="fas fa-users"></i>
            <h1>玩家管理系统</h1>
        </div>
        
        <!-- 导航链接 -->
        <div class="nav-links">
            <a href="userShow.jsp?userId=${ myUserId }"><i class="fas fa-user"></i> 个人信息</a>
            <a href="main.jsp"><i class="fas fa-home"></i> 玩家功能</a>
            <a href="modList.jsp"><i class="fas fa-list"></i> 模组列表</a>
            <a href="modPage.jsp"><i class="fas fa-file-alt"></i> 模组分页</a>
            <a href="modAdmin.jsp"><i class="fas fa-cog"></i> 模组管理</a>
            <a href="userAdmin.jsp" class="active"><i class="fas fa-users-cog"></i> 玩家管理</a>
        </div>
        
        <!-- 消息提示 -->
        <% if (request.getAttribute("msg") != null) { %>
            <div class="msg">
                <i class="fas fa-exclamation-circle"></i>
                <span>${ msg }</span>
            </div>
        <% } %>
        
        <!-- 搜索和添加区域 -->
        <form action="" method="post">
            <div class="admin-tools">
                <div class="search-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" value="<%= search %>" placeholder="搜索玩家...">
                    </div>
                    <button type="submit" name="buttonSearch" class="search-btn">搜索</button>
                </div>
                <a href="userAdd.jsp" class="add-user-btn">
                    <i class="fas fa-plus"></i> 添加新玩家
                </a>
            </div>
            
            <!-- 玩家列表 -->
            <div class="users-container">
                <div class="users-header">
                    <div>序号</div>
                    <div>用户名</div>
                    <div>真实姓名</div>
                    <div>角色级别</div>
                    <div>更新时间</div>
                    <div>操作</div>
                    <div>
                        <div class="checkbox-container">
                            <label>全选</label>
                        </div>
                    </div>
                </div>
                
                <%
                    int i = indexStart;                                     //序号
                    String username, realName, role, timeRenew;
                    boolean hasRecords = false;

                    while (rs != null && rs.next()) {                        //如果读到了数据
                        i++;
                        hasRecords = true;
                        username    = rs.getString("username");              //获取字段的值
                        realName = rs.getString("realName");
                        role     = rs.getString("role");
                        timeRenew     = rs.getString("timeRenew");
                    
                        String userId = rs.getString("userId");        //链接中要用到
                        
                        // 为角色添加样式
                        String roleClass = "user-role ";
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
                <div class="user-item">
                    <div class="user-index"><%= i %></div>
                    <div class="user-name"><%= username %></div>
                    <div class="user-realname"><%= realName %></div>
                    <div class="user-role <%= roleClass %>"><%= role %></div>
                    <div class="user-time"><%= timeRenew %></div>
                    <div class="user-action action-cell">
                        <a href="userShow.jsp?userId=<%= userId %>" class="action-btn">
                            <i class="fas fa-eye"></i> 详情
                        </a>
                        <a href="userEdit.jsp?userId=<%= userId %>" class="action-btn edit-btn">
                            <i class="fas fa-edit"></i> 编辑
                        </a>
                    </div>
                    <div class="user-checkbox checkbox-container">
                        <label class="custom-checkbox">
                            <input type="checkbox" name="userId" value="<%= userId %>">
                            <span class="checkmark"></span>
                        </label>
                    </div>
                </div>
                <%
                    }                            
                    if (db != null) db.close();         //用完立即关闭
                    
                    if (!hasRecords) {
                        msg = "没有找到玩家记录";
                %>
                <div class="empty-state">
                    <i class="fas fa-user-slash"></i>
                    <h3>没有玩家数据</h3>
                    <p><%= msg %></p>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- 删除按钮 -->
            <div class="delete-section">
                <div class="pagination-info">
                    显示 <strong><%= pageShow %></strong> / <strong><%= pageCount %></strong> 页 | 
                    共 <strong><%= countRow %></strong> 条记录
                </div>
                <button type="submit" class="delete-btn" name="buttonDelete" 
                    onclick="return confirm('确认删除所选玩家？该操作不可恢复！')">
                    <i class="fas fa-trash-alt"></i> 删除选中玩家
                </button>
            </div>
            
            <!-- 分页控件 -->
            <div class="pagination">
                <div class="pagination-controls">
                    <% if (pageShow <= 1) { %>
                        <button class="pagination-btn" disabled>
                            <i class="fas fa-angle-double-left"></i> 首页
                        </button>
                        <button class="pagination-btn" disabled>
                            <i class="fas fa-angle-left"></i> 上一页
                        </button>
                    <% } else { %>
                        <a href="userAdmin.jsp?pageUrl=1&searchUrl=<%= searchUrl %>" class="pagination-btn">
                            <i class="fas fa-angle-double-left"></i> 首页
                        </a>
                        <a href="userAdmin.jsp?pageUrl=<%= pageShow - 1 %>&searchUrl=<%= searchUrl %>" class="pagination-btn">
                            <i class="fas fa-angle-left"></i> 上一页
                        </a>
                    <% } %>
                    
                    <button class="pagination-btn active"><%= pageShow %></button>
                    
                    <% if (pageShow >= pageCount) { %>
                        <button class="pagination-btn" disabled>
                            下一页 <i class="fas fa-angle-right"></i>
                        </button>
                        <button class="pagination-btn" disabled>
                            尾页 <i class="fas fa-angle-double-right"></i>
                        </button>
                    <% } else { %>
                        <a href="userAdmin.jsp?pageUrl=<%= pageShow + 1 %>&searchUrl=<%= searchUrl %>" class="pagination-btn">
                            下一页 <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="userAdmin.jsp?pageUrl=<%= pageCount %>&searchUrl=<%= searchUrl %>" class="pagination-btn">
                            尾页 <i class="fas fa-angle-double-right"></i>
                        </a>
                    <% } %>
                </div>
                
                <div class="pagination-input">
                    <input type="text" name="pageShow" value="<%= pageShow %>">
                    <button type="submit" name="buttonPage" class="pagination-input-btn">跳转</button>
                </div>
            </div>
        </form>
    </div>
    
    <script type="text/javascript">
    function checkAll() {
        var checkboxList = document.getElementsByName("userId");            //获取复选框列表
        var checkboxAll  = document.querySelector('input[name="checkboxAll"]');    //全选复选框
        
        if (checkboxAll) {
            for (var i = 0; i < checkboxList.length; i++) {                        //对于列表中的每一个复选框
                checkboxList[i].checked = checkboxAll.checked;                    //此复选框的勾选情况与全选复选框一致
            }
        }
    }

    function check() {
        var checkboxList = document.getElementsByName("userId");            //获取复选框列表
        var checkboxAll  = document.querySelector('input[name="checkboxAll"]');    //全选复选框
        var isChecked = true;
        
        for (var i = 0; i < checkboxList.length; i++) {                        //对于列表中的每一个复选框
            if (checkboxList[i].checked == false) {                            //如果没被勾选
                isChecked = false;
                break;
            }
        }
        
        if (isChecked && checkboxAll) {
            checkboxAll.checked = true;                                        //全选复选框被勾选
        } else if (checkboxAll) {
            checkboxAll.checked = false;                                    //全选复选框被取消勾选
        }
    }
    </script>
</body>
</html>