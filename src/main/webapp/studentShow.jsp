<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>模组信息</title>
	<style>
        body {
            background: url('https://images.unsplash.com/photo-1607513746994-51f730a44832?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Minecraft', Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #fff;
            text-shadow: 2px 2px 4px #000;
        }

        @font-face {
            font-family: 'Minecraft';
            src: url('https://fonts.cdnfonts.com/css/minecraft-4') format('woff');
        }

        .container {
            width: 800px;
            margin: 30px auto;
            background-color: rgba(0, 0, 0, 0.7);
            border: 4px solid #5a5a5a;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
        }

        h3 {
            text-align: center;
            font-size: 32px;
            color: #55ff55;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .user-info {
            background-color: rgba(85, 255, 85, 0.1);
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
            border: 1px solid #55ff55;
            font-size: 16px;
        }

        .logout-link {
            color: #ff5555;
            text-decoration: none;
            margin-left: 15px;
        }

        .logout-link:hover {
            text-decoration: underline;
        }

        .mod-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 24px;
            color: #55ff55;
            border-bottom: 2px solid #55ff55;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }

        .mod-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .mod-card {
            background-color: rgba(85, 85, 85, 0.5);
            border: 2px solid #5a5a5a;
            border-radius: 5px;
            padding: 15px;
            transition: all 0.3s;
        }

        .mod-card:hover {
            border-color: #55ff55;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(85, 255, 85, 0.3);
        }

        .mod-name {
            font-size: 18px;
            color: #55ff55;
            margin-bottom: 10px;
        }

        .mod-desc {
            font-size: 14px;
            color: #aaa;
            margin-bottom: 15px;
        }

        .mod-action {
            display: inline-block;
            padding: 5px 10px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 3px;
            font-size: 14px;
            margin-right: 10px;
        }

        .mod-action:hover {
            background-color: #45a049;
        }

        .admin-action {
            background-color: #ff5555;
        }

        .admin-action:hover {
            background-color: #cc4444;
        }

        .msg {
            color: #ff5555;
            font-size: 16px;
            display: block;
            margin: 20px 0;
            padding: 10px;
            background-color: rgba(255, 85, 85, 0.1);
            border: 1px solid #ff5555;
            border-radius: 5px;
        }

        .pixel-icon {
            font-size: 24px;
            margin-right: 10px;
            vertical-align: middle;
        }
    </style>
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3><span class="pixel-icon">⛏️</span>模组信息</h3>
    	<span class="msg">
	<%
		request.setCharacterEncoding("UTF-8");
		String msg = "";	
		String label = "</span></div></body></html>";	
		String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;		//后退链接
		
		if (session.getAttribute("myRole") == null) { 					//如果此session属性不存在或已经失效
			msg = "<br>您的登录已失效！请重新登录。";
  			msg += "&emsp;<a href='index.jsp'>用户登录</a>" + label;	
			out.print(msg);
			return;
		}

		String myRole = session.getAttribute("myRole").toString();		//获取session中该对象的值

		if (myRole.equals("admin") == false) { 							//如果不是管理员		
			msg = "您的权限不足！";
			msg += "&emsp;<a href='main.jsp'>用户功能</a>" + label;
			out.print(msg);
			return;
		}		
			
		String studentId = request.getParameter("studentId"); 			//获取地址栏参数studentId的值

		try { 									 
			Integer.parseInt(studentId);								//如果不能转换为整数   
		} catch (Exception e) {
			msg = "参数studentId错误！" + back;
			out.print(msg);
			return;
		}
		
		Db db = new Db();												//新建实例（该实例实现了数据的增删改查）
		String sql = ""; 
		ResultSet rs = null;
		
		sql = "select * from tb_student where studentId = ?";
		rs = db.select(sql, studentId);
		
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

		String studentNo = "", studentName = "", sex = "", age = "", className = "", note = "", timeRenew = "";
		
		studentNo 	= rs.getString("studentNo"); 							//获取字段的值
		studentName = rs.getString("studentName");
		sex 		= rs.getString("sex");
		age 		= rs.getString("age");	if (age.equals("0")) age = "";
		className	= rs.getString("className");
		note		= rs.getString("note");	
		note 		= note.replace("\r\n", "<br>").replace(" ", "&ensp;");	//替换换行符和空格，以在页面中能显示换行和多空格效果
		timeRenew	= rs.getString("timeRenew");							//在连接MySQL 8时指定了时区地点，则获取到的时间不需格式化
		db.close();
	%>
		</span>

		<table class="table_border table_padding10" style="width:500px; margin:0px auto;">
			<tr class="tr_header">
				<td>项目</td>
				<td>内容&emsp;&emsp;&emsp;&emsp;</td>
			</tr>
			<tr>
				<td width="30%">学号</td>
				<td class="left"><%= studentNo %></td>
			</tr>
			<tr>
				<td>姓名</td>
				<td class="left"><%= studentName %></td>
			</tr>
			<tr>
				<td>性别</td>
				<td class="left"><%= sex %></td>
			</tr>
			<tr>
				<td>年龄</td>
				<td class="left"><%= age %></td>
			</tr>
			<tr>
				<td>班级</td>
				<td class="left"><%= className %></td>
			</tr>
			<tr>
				<td>备注</td>
				<td class="left"><%= note %></td>
			</tr>
			<tr>
				<td>更新时间</td>
				<td class="left"><%= timeRenew %></td>
			</tr>
			<tr>
				<td colspan="2">
					<a href="studentEdit.jsp?studentId=<%= studentId %>">修改</a>&emsp;
					<a href="studentDeleteDo.jsp?studentId=<%= studentId %>"
						onclick="return confirm('确定要删除吗？')">删除</a>
				</td>
			</tr>
		</table>
		<div class="msg">${ msg }</div>
		<br>
		<a href="studentAdmin.jsp">返回模组管理</a>
	</div>
  </body>
</html>
