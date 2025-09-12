<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>用户功能</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>用户功能</h3>
    	<span class="msg">
	  	<%
			request.setCharacterEncoding("UTF-8");
			String msg = "";	
			String label = "</span></div></body></html>";
			
			//####【添加代码】		//如果此session属性不存在或已经失效
				msg = "您的登录已失效！请重新登录。";
	  			//####【添加代码】
				//####【添加代码】
				//####【添加代码】
			//####【添加代码】
	
			String myRole = "";		//####【添加代码】		//用户角色：管理员admin、普通用户user、注册用户guest
	  	%> 
	  	</span> 
	  	
		<div style="margin:-25px 0px 40px; font-size:small;">
			欢迎：${ myUsername }（${ myRole }）&emsp;<a href="logout.jsp">注销登录</a>
		</div>
			
		<table style="width:580px;" class="table_border table_border_bg table_hover">
			<tr height="50" class="tr_header">
				<th colspan="2">
					用户功能列表
				</th>
			</tr>
			<tr height="50">
				<td width="30%">
					登录相关
				</td>
				<td class="left">&emsp;
					<a href="userAdd.jsp">注册新用户</a>&emsp;&emsp;
					<a href="userShow.jsp?userId=${ myUserId  }">个人信息</a>&emsp;&emsp;
					<a href="logout.jsp">注销登录</a>&emsp;&emsp;
				</td>
			</tr>
			<%
				//####【添加代码】
			%>
			<tr height="50">
				<td>
					模组数据
				</td>
				<td class="left">&emsp;
					<a href="studentList.jsp">列表/查询</a>&emsp;&emsp;
					<a href="studentPage.jsp">模组分页</a>&emsp;&emsp;
				</td>
			</tr>
			<%
				//####【添加代码】
				
				//####【添加代码】
			%>
			<tr height="50">
				<td>
					模组管理
				</td>
				<td class="left">&emsp;
					<a href="studentAdmin.jsp">管理</a>&emsp;&emsp;
					<a href="studentAdd.jsp">新添</a>&emsp;&emsp;
				</td>
			</tr>
			<tr height="50">
				<td>
					用户管理
				</td>
				<td class="left">&emsp;
					<a href="userAdmin.jsp">管理</a>&emsp;&emsp;
					<a href="userAdd.jsp">新添/注册</a>&emsp;&emsp;
				</td>
			</tr>		
			<tr height="50">
				<td>
					班级管理
				</td>
				<td class="left">&emsp;
					<a href="class/classAdmin.jsp">管理</a>&emsp;&emsp;
					<a href="class/classAdd.jsp">新添</a>&emsp;&emsp;
				</td>
			</tr>	
			<%
				//####【添加代码】
			%>
		</table>	
		<%
			//####【添加代码】
		%>
		<br>
		<span class="msg">
			*注册之后，新用户（guest）还需获得管理员的授权，才能查看、管理模组和用户的信息。
		</span>		
		<% 
			//####【添加代码】
		%>
    </div>
  </body>
</html>
