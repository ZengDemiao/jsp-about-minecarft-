<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>模组信息</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>模组信息</h3>
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

		if (myRole.equals("admin") == false) { 						//如果不是管理员		
			msg = "您的权限不足！";
			msg += "&emsp;<a href='main.jsp'>用户功能</a>" + label;
			out.print(msg);
			return;
		}		
			
		//####【添加代码】 							//获取地址栏参数studentId的值

		//####【添加代码】							//如果不能转换为整数   
		
		
		//####【添加代码】							//SQL查询语句
		
		
		
		
		

		String studentNo = "", studentName = "", sex = "", age = "", className = "", note = "", timeRenew = "";
		
		//####【添加代码】							//获取字段的值
		
		
		
		
	%>
		</span>

		<table class="table_border table_padding10" style="width:500px; margin:0px auto;">
			<tr class="tr_header">
				<td>项目</td>
				<td>内容&emsp;&emsp;&emsp;&emsp;</td>
			</tr>
			<tr>
				<td width="30%">学号</td>
				<td class="left">//####【添加代码】</td>
			</tr>
			<tr>
				<td>姓名</td>
				<td class="left">//####【添加代码】</td>
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
					//####【添加代码】
					//####【添加代码】
				</td>
			</tr>
		</table>
		<div class="msg">${ msg }</div>
		<br>
		<a href="studentAdmin.jsp">返回模组管理</a>
	</div>
  </body>
</html>
