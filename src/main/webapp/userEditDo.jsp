<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>修改用户的结果</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>修改用户的结果</h3>
    	<span class="msg">
	<%
		request.setCharacterEncoding("UTF-8");
		String msg = "";	
		String label = "</span></div></body></html>";	
		String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;		//后退链接
		
		if (session.getAttribute("myRole") == null) { 				//如果此session属性不存在或已经失效
			msg = "<br>您的登录已失效！请重新登录。";
  			msg += "&emsp;<a href='index.jsp'>用户登录</a>" + label;	
			out.print(msg);
			return;
		}

		String myRole = session.getAttribute("myRole").toString();	//获取session中该对象的值

// 		if (myRole.equals("admin") == false) { 						//如果不是管理员		
// 			msg = "您的权限不足！";
// 			msg += "&emsp;<a href='main.jsp'>用户功能</a>" + label;
// 			out.print(msg);
// 			return;
// 		}
		
		for (int f = 0; f < 1; /*f++*/) {
			String password = "", password2 = "", realName = "", role = "";
			
			password 	= request.getParameter("password"); 		//获取输入的值
			password2 	= request.getParameter("password2");
			realName 	= request.getParameter("realName");
			role 		= request.getParameter("role");
		
			if (password == null || password2 == null || realName == null) {
				msg = "输入不正确！";								//值为null的原因：输入框名称不对，或者在地址栏直接输入本页网址
				break;
			}
			realName = realName.trim();
			role = role.trim();
		
			if (password.equals("") == false || password2.equals("") == false) {	//密码输入非空
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
			}
			
			if (realName.length() > 45) {
				msg = "真实姓名最多为45个字符！";
				break;
			}
	
			if (role == null || role.length() < 1 || role.length() > 5) {	
				msg = "请选择角色级别！";
				break;
			}
	
			String userId = request.getParameter("userId"); 			//获取地址栏参数userId的值
	
			try { 									 
				Integer.parseInt(userId);								//如果不能转换为整数   
			} catch (Exception e) {
				msg = "参数userId错误！";
				break;
			}	
			
			String myUserId = session.getAttribute("myUserId").toString();				//取得session中的值
	
			if (userId.equals(myUserId) == false && myRole.equals("admin") == false) { 	//如果不是自己，且不是管理员
				msg = "您只能修改自己的信息！";
				break;
			}
	
			if (userId.equals(myUserId) && role.equals(myRole) == false) { 				//如果是自己，但修改了角色级别
				msg = "您不能修改自己的角色级别！";
				break;
			}
						
			Db db = new Db();											//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 
			ResultSet rs = null;
			
			sql = "select * from tb_user where userId = ?";		
			rs = db.select(sql, userId);
	
			if (rs == null) {				
				msg = "数据库操作发生错误！";
				break;
			}
			
			if (rs.next() == false) {
				db.close();
				msg = "对应的记录已不存在！";
				break;
			}
			rs.close();													//只关闭rs
	
			//--->>>------------ 更新数据
			int count = 0;
			
			if (password.equals("") == false) {							//如果密码需要修改
				sql = "update tb_user set password = ?, realName = ?, role = ?" 
					+ ", timeRenew = (now()) where userId = ?";
				count = db.update(sql, password, realName, role, userId);
			} else {
				sql = "update tb_user set realName = ?, role = ?" 
					+ ", timeRenew = (now()) where userId = ?";
				count = db.update(sql, realName, role, userId);
			}		
			
			if (count == 0){	
				msg = "修改用户信息失败！请重试。";
				break;
			}
	
			msg = "修改用户信息成功！";
			String url = "userShow.jsp?userId=" + userId;
			
			request.setAttribute("msg", msg);
			request.getRequestDispatcher(url).forward(request, response);		//转发
			return;
		}
		
		msg += back;			//修改失败。加上后退按钮
		out.print(msg);
	%>
		</span>
		<br>
		<% if (myRole.equals("admin")) {  %>
			<a href="userAdmin.jsp">返回用户管理</a>
		<% } else { %>
			<a href="main.jsp">返回用户功能页</a>
		<% } %>
	</div>
  </body>
</html>
