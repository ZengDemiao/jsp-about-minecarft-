<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
   	<%
    	String title = "玩家注册的结果"; 
    	String myRole = "";
    	
		if (session.getAttribute("myRole") != null) { 					//如果已经登录		
			myRole = session.getAttribute("myRole").toString();			//获取session中该对象的值
			
			if (myRole.equals("admin")) { 								//如果是管理员	
				title = "新添玩家的结果"; 
			}
		}
   	%>
	<title><%= title %></title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3><%= title %></h3>
    	<span class="msg">
	<%
		request.setCharacterEncoding("UTF-8");
		String msg = "";		
		String label = "</span></div></body></html>";	
		String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;		//后退链接
		
		for (int f = 0; f < 1; /*f++*/) {
			String username = "", password = "", password2 = "", realName = "", role = "";
			
			username 	= request.getParameter("username"); 			//取得输入的值
			password 	= request.getParameter("password");
			password2 	= request.getParameter("password2");
			realName 	= request.getParameter("realName");
		
			if (username == null || password == null || password2 == null || realName == null) {
				msg = "输入不正确！";								//值为null的原因：输入框名称不对，或者在地址栏直接输入本页网址
				break;
			}
			username = username.trim();
			realName = realName.trim();
	
			if (username.length() < 1 || username.length() > 45) {
				msg = "玩家名为1~45个字符！"; 
				break;
			}
	
			if (password.length() < 1 || password.length() > 45) {
				msg = "密码为1~45个字符！";
				break;
			}
			if (password2.length() < 1 || password2.length() > 45) {
				msg = "“密码确认”为1~45个字符！";
				break;
			}
			if (password.equals(password2) == false) {
				msg = "请确认2个密码保持一致！";
				break;
			}
			
			if (realName.length() > 45) {
				msg = "真实姓名最多为45个字符！";
				break;
			}
		
			Db db = new Db();										//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 
			ResultSet rs = null;
			
			sql = "select * from tb_user where username = ?";  		//查询是否已经存在此用户名
			rs = db.select(sql, username); 					 
	
			if (rs == null) {				
				msg = "数据库操作发生错误！";
				break;
			}
			
			if (rs.next()) {
				db.close();
				msg = "您输入的玩家名已经存在，请重新输入！"; 
				break;
			}
			rs.close();		//只关闭rs		
	
			sql = "insert into tb_user (username, password, realName, role)"
				+ " values (?, ?, ?, 'guest')";								//插入记录
			String userId = db.insert(sql, username, password, realName); 	//执行SQL语句，得到被新添的记录的ID
			
			if (userId.equals("0")){
				msg = "玩家注册失败！请重试。"; 
				break;
			}
	
			msg = "玩家注册成功！"; 
			String url = "index.jsp";
			
			if (myRole.equals("admin")) {
				msg = "玩家新添成功！"; 
				url = "userShow.jsp?userId=" + userId;
			}
			
			request.setAttribute("msg", msg);
			request.getRequestDispatcher(url).forward(request, response);		//转发
			return;
		}
			
		msg += back;			//新添失败。加上后退按钮
		out.print(msg);
	%>
		</span>
		<br><br>
		<% if (myRole.equals("admin")) {  %>
				<a href="playerAdmin.jsp">返回玩家管理</a>		
		<% } else { %>	
				<a href="index.jsp">玩家登录</a>	
		<% } %>
		<br>
		<span class="msg" style="color:orange;">
			*注册之后，新玩家还需获得管理员的授权，才能查看、管理模组和玩家的信息。
		</span>
	</div>
  </body>
</html>
