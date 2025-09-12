<!-- //####【添加代码】 -->
<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>模组分页</title>
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
		String buttonPage  	= request.getParameter("buttonPage"); 	//页码提交按钮
		String pageInput  	= "1";									//输入的页码
		
		if (buttonSearch != null && request.getParameter("search") != null) { 	//如果单击了搜索按钮
			search = request.getParameter("search").trim(); 					//搜索内容		
				
		} else if (buttonPage != null && request.getParameter("search") != null) { 	//如果单击了页码提交按钮
			search = request.getParameter("search").trim(); 					//搜索内容
			pageInput = request.getParameter("pageShow"); 						//页码输入框中的值
			
		} else { 													//点击了页码链接，或者刚打开此页
			if (request.getParameter("searchUrl") != null) { 
				search = request.getParameter("searchUrl"); 		//不需要进行解码操作，系统会自动解码
			}
			
			if (request.getParameter("pageUrl") != null) {			//地址栏中的页码
				pageInput = request.getParameter("pageUrl");
			}
		}
		
		String searchUrl = "";
		
		if (search.equals("") == false) {
			//####【添加代码】 				//进行URL编码，以便在地址栏传递参数
		}

		Db db = new Db();											//新建实例（该实例实现了数据的增删改查）
		String sql = ""; 
		ResultSet rs = null;
		String sqlWhere = "";
		
		if (search.equals("") == false) {							//如果有搜索内容
			//sqlWhere = " where studentName like '%陈%'";			//常用的模糊查询
			sqlWhere = " where concat_ws(',', studentNo, studentName, className) like ?";	//多字段模糊查询
			db.setCanShowSql(true);									//将在控制台输出SQL语句
		}		
		
		//--->>>-------------查询记录总数
		if (search.equals("")) {									//没搜索，或无搜索内容
			//####【添加代码】  										//SQL查询语句
			rs = db.select(sql); 									//执行查询，得到结果集
		} else {													//如果有搜索内容	
			//####【添加代码】  										//SQL模糊查询语句
			rs = db.select(sql, "%" + search + "%"); 				//增加含有查询内容的参数
		}
	
		if (rs == null) {		
			msg = "数据库操作发生错误！" + back;
			out.print(msg);
			return;
		}
			
		int countRow = 0;
		
		//####【添加代码】								//如果读取下一条记录成功
			//####【添加代码】  							//读取第1个字段的值（整数）
		//####【添加代码】			
		rs.close();										//用完立即关闭rs，但没关闭数据库连接
		//---<<<-------------查询记录总数
		
		//--->>>-------------开始数据分页
		int pageSize  = 3;  							//每页3条记录
		int pageCount = 0; 								//总页数预设为0

		//####【添加代码】 					//如果余数为0，即能整除
		
		
		
		int pageShow = 1; 								//当前页预设为1
		//####【添加代码】 
		
		

		int indexStart = 0;											//查询记录时的起始位置	
		indexStart = 0;						//####【添加代码】 		//已经显示的记录条数
		
			
		if (search.equals("")) {									//没搜索，或无搜索内容	
			sql = "select * from tb_student order by studentNo"		//SQL查询语句
				+ ""; 	//####【添加代码】 							//只获取该页的记录
			rs = db.select(sql); 									//执行查询，得到结果集
		} else {													//有搜索内容
			sql = "select * from tb_student " + sqlWhere + " order by studentNo"	//SQL模糊查询语句
				+ ""; 	//####【添加代码】 							//只获取该页的记录
			rs = db.select(sql, "%" + search + "%"); 				//增加含有查询内容的参数
		}
		
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
					<h3>模组分页</h3>
					
					<div class="right note" style="margin:40px 0px 5px 0px;">
						&emsp;&emsp;搜索：
						<input type="text" name="search" value="<%= search %>" style="width:80px;">
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
							int i = 0; 		//####【添加代码】 									//序号
							String studentNo, studentName, sex, age, className;

							while (rs.next()) { 									//如果读到了数据
								i++;
								studentNo	= rs.getString("studentNo");			//获取字段的值
								studentName = rs.getString("studentName");
								sex 		= rs.getString("sex");
								age 		= rs.getString("age");	if (age.equals("0")) age = "";
								className 	= rs.getString("className");
						%>
						<tr>
							<td><%= i %></td>
							<td><%= studentNo %></td>
							<td><%= studentName %></td>
							<td><%= sex %></td>
							<td><%= age %></td>
							<td><%= className %></td>
						</tr>
						<%
							}							
							db.close(); 		//用完立即关闭数据库连接
							
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
			<tr>
				<td style="font-size:small; text-align:right;">
					<br>
					<% if (pageShow <= 1) { %>
							<span style="color:gray;">首页&ensp;
							上一页&ensp;</span>
					<% } else { %>
							<a href="studentPage.jsp?pageUrl=<%= 1 %>&searchUrl=<%= searchUrl %>">首页</a>&ensp;
							<a href="studentPage.jsp?pageUrl=<%= pageShow - 1 %>&searchUrl=<%= searchUrl %>">上一页</a>&ensp;
					<% } %>
					
					<!-- ####添加代码 --> 	
					
					
					
					&emsp;&emsp;
					页码：	<!-- ####添加代码 --> 
					记录数：	<!-- ####添加代码 --> 
					输入页码:
					<input type="text" name="pageShow" value="???" style="width:40px; text-align:center;">		<!-- ####添加代码 -->
					<input type="submit" name="buttonPage" value="提交">&emsp;
				</td>
			</tr>	
		</table>
		</form>
    </div>
  </body>
</html>
