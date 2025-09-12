<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>用户登录</title>
	<!-- //####【添加代码】：引入外部样式文件 -->
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>用户登录</h3>
		<form>		<!-- //####【添加代码】 -->
		   	用户名：<input type="text" name="username" style="width:150px;">		<!-- //####【添加代码】 -->
		   	<br>
		   	密&emsp;码：<input type="password" name="password" style="width:150px;">		<!-- //####【添加代码】 -->
			<div style="text-align:left; padding-left:275px; box-sizing:border-size;">
				<input type="submit" value="提交">&emsp;
				<span class="msg"></span>	<!-- //####【添加代码】 -->
			</div>
			<br>
			<a href="userAdd.jsp">用户注册</a>
			<br>
			<span class="note">
				普通用户角色user登录：tom，1&emsp;&emsp;管理员角色admin登录：zhangsan，1
			</span>
		</form>
	</div>
  </body>
</html>
