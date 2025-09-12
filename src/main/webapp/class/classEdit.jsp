<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>修改班级</title>
	<link rel="stylesheet" href="../css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>修改班级</h3>
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
		
		String classId = request.getParameter("classId"); 				//获取地址栏参数classId的值
		
		try { 									 
			Integer.parseInt(classId);									//如果不能转换为整数   
		} catch (Exception e) {
			msg = "参数classId错误！" + back;
			out.print(msg);
			return;
		}
				
		Db db = new Db();												//新建实例（该实例实现了数据的增删改查）
		String sql = ""; 
		ResultSet rs = null;
		
		sql = "select * from tb_class where classId = ?"; 				//SQL查询语句		
		rs = db.select(sql, classId); 									//执行查询

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

		String className = "", year = "", timeRenew = "";
		
		className 	= rs.getString("className"); 		//获取字段的值
		year 		= rs.getString("year");
		timeRenew	= rs.getString("timeRenew");		//在连接MySQL 8时指定了时区地点，则获取到的时间不需格式化
		db.close();	
	%>
		</span>

		<form action="classEditDo.jsp?classId=<%= classId %>" method="post">
		<table class="table_border table_padding10" style="width:500px; margin:0px auto;">
			<tr class="tr_header">
				<td>项目</td>
				<td>内容&emsp;&emsp;&emsp;&emsp;</td>
			</tr>
			<tr>
				<td width="30%">班级名</td>
				<td class="left">
					<input type="text" name="className" maxlength="45" value="<%= className %>">
				</td>
			</tr>
			<tr>
				<td>入学年份</td>
				<td class="left">
					<input type="text" name="year" maxlength="45" value="<%= year %>">
				</td>
			</tr>
			<tr>
				<td>更新时间</td>
				<td class="left"><%= timeRenew %></td>
			</tr>
			<tr>
				<td colspan="2">
					&emsp;&emsp;&emsp;&emsp;
					<input type="submit" value="提交">
					&emsp;&emsp;
					<a href="classShow.jsp?classId=<%= classId %>">返回详情页</a>
				</td>
			</tr>
		</table>
		</form>
		<br>
		<a href="classAdmin.jsp">返回班级管理</a>
	</div>
  </body>
</html>
