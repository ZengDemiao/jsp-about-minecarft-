<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>注销登录</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
  	<%
  		session.invalidate();					//清除本浏览器在此网站中的所有session
  	
  		String msg = "注销登录成功！";		
		String url = "index.jsp";
			
		request.setAttribute("msg", msg);
		request.getRequestDispatcher(url).forward(request, response);		//转发
  	%>
  </body>
</html>
