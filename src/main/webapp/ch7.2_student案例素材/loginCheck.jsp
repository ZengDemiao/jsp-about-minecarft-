<!-- //####【添加代码】 -->
<!-- //####【添加代码】 -->
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>登录验证</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>登录验证</h3>
    	<span class="msg">
	<%
		request.setCharacterEncoding("UTF-8");
		String msg = "";
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		for (int f = 0; f < 1; f++) {							//方便随时退出循环，去输出出错消息
			if (username == null || password == null) {
				username = "";
				password = "";
				break;
			}
			
			if (username.trim().equals("")) {
				msg = "请输入用户名！";
				break;
			}
			username = username.trim();
			
			if (password.equals("")) {
				msg = "请输入密码！";
				break;
			}
			
			//####【添加代码】
			
			
			
			
			
			
			
			
			//--------往下：能查询到记录
			
			String userId = "", role = "";
					
			
			
			 				//用户id，添加到session
			 				//用户名
							//用户角色（权限）
			
							//登录成功后，重定向到下一个网页
			
		}
		
		//####【添加代码】				//将在index.jsp页用EL表达式显示出来
		//####【添加代码】
		//####【添加代码】
		//####【添加代码】				//转发到下一个网页
		//return;			//此处不能有return（将使其后的语句无法执行）。但在if、循环等内部语句中可以有return
	%>
		</span>
	</div>
  </body>
</html>
