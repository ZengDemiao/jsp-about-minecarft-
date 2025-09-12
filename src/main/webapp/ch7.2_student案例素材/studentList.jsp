<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>模组列表</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:810px; margin:10px auto;">
    	<span class="msg">
  	<%
  		request.setCharacterEncoding("UTF-8");
		String msg = "";	
		String label = "</span></div></body></html>";	
		String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;		//后退链接

		if (session.getAttribute("myRole") == null) { 							//如果此session属性不存在或已经失效
			msg = "<br>您的登录已失效！请重新登录。";
  			msg += "&emsp;<a href='index.jsp'>用户登录</a>" + label;	
			out.print(msg);
			return;
		}

		String myRole = session.getAttribute("myRole").toString();				//获取session中该对象的值
		
		if (myRole.equals("admin") == false && myRole.equals("user") == false) {//如果是新用户guest	
			msg = "您的权限不足！";
			msg += "&emsp;<a href='main.jsp'>用户功能</a>" + label;
			out.print(msg);
			return;
		}
		
		String linkAdmin = "";													//管理链接
		
		if (myRole.equals("admin")) { 											//如果为管理员
			linkAdmin = "&nbsp;&emsp;|&emsp;&nbsp;<a href='studentAdmin.jsp'>模组管理</a>"
				+ "&nbsp;&emsp;<a href='userAdmin.jsp'>用户管理</a>";			//生成管理链接
		} 
		
		String search 		= "";									//搜索内容
		String buttonSearch	= request.getParameter("buttonSearch");	//搜索按钮
		
		//####【添加代码】					//如果单击了搜索按钮
		//####【添加代码】 					//搜索内容			
		//####【添加代码】

		//####【添加代码】											//新建实例（该实例实现了数据的增删改查）
		String sql = ""; 
		ResultSet rs = null;
		String sqlWhere = "";
		
		//####【添加代码】					//如果有搜索内容
		
		
		
		
		if (rs == null) {		
			msg = "数据库操作发生错误！" + back;
			out.print(msg);
			return;													//结束页面的执行
		}
  	%> 
	  	</span>    	
		<form action="" method="post">
		<table style="width:800px; margin:0px auto;">
			<tr>
				<td>
					<div style="margin:0px 0px 40px; font-size:small;">
						欢迎：${ myUsername }（${ myRole }）&emsp;
						<a href="logout.jsp">注销登录</a>&emsp;
						<a href="userShow.jsp?userId=${ myUserId }">个人信息</a>&emsp;
						<a href="main.jsp">用户功能</a>&nbsp;&emsp;|&emsp;
						<a href="studentList.jsp">模组列表</a>&emsp;
						<a href="studentPage.jsp">模组分页</a>
						<%= linkAdmin %>
					</div>
					<h3>模组列表</h3>
					
					<div class="right note" style="margin:40px 0px 5px 0px;">
						&emsp;&emsp;搜索：
						<input type="text" name="search" value="???" style="width:80px;">	<!-- //####【添加代码】 -->
						<input type="submit" name="buttonSearch" value="搜索">
						<span class="note">（在学号、姓名、班级中搜索）</span>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<table class="table_border table_border_bg table_hover" style="width:100%">
						<tr class="tr_header">
							<td>序号</td>
							<td>学号</td>
							<td>姓名</td>
							<td>性别</td>
							<td>年龄</td>
							<td>班级</td>
						</tr>
						<%
							int i = 0; 												//序号
							String studentNo, studentName, sex, age, className;

							//####【添加代码】
							
						%>
						
						<%
							
				 					//用完立即关闭数据库连接
							
							if (i == 0) {
								msg = "（没有记录）";
								request.setAttribute("msg", msg);		//为了在下面的EL表达式中显示msg的内容
						%>					  
						<tr>
							<td colspan="6" class="note" style="text-align:center; height:50px;">
								<span class="msg">${ msg }</span>&emsp;&emsp;
							</td>
						</tr>
						<%
							}
						%>
					</table>
				</td>
			</tr>
		</table>
		</form>
    </div>
  </body>
</html>
