<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>班级管理</title>
	<style>
        body {
            background: url('https://images.unsplash.com/photo-1607513746994-51f730a44832?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Minecraft', Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #fff;
            text-shadow: 2px 2px 4px #000;
        }

        @font-face {
            font-family: 'Minecraft';
            src: url('https://fonts.cdnfonts.com/css/minecraft-4') format('woff');
        }

        .container {
            width: 800px;
            margin: 30px auto;
            background-color: rgba(0, 0, 0, 0.7);
            border: 4px solid #5a5a5a;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
        }

        h3 {
            text-align: center;
            font-size: 32px;
            color: #55ff55;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .user-info {
            background-color: rgba(85, 255, 85, 0.1);
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
            border: 1px solid #55ff55;
            font-size: 16px;
        }

        .logout-link {
            color: #ff5555;
            text-decoration: none;
            margin-left: 15px;
        }

        .logout-link:hover {
            text-decoration: underline;
        }

        .mod-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 24px;
            color: #55ff55;
            border-bottom: 2px solid #55ff55;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }

        .mod-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .mod-card {
            background-color: rgba(85, 85, 85, 0.5);
            border: 2px solid #5a5a5a;
            border-radius: 5px;
            padding: 15px;
            transition: all 0.3s;
        }

        .mod-card:hover {
            border-color: #55ff55;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(85, 255, 85, 0.3);
        }

        .mod-name {
            font-size: 18px;
            color: #55ff55;
            margin-bottom: 10px;
        }

        .mod-desc {
            font-size: 14px;
            color: #aaa;
            margin-bottom: 15px;
        }

        .mod-action {
            display: inline-block;
            padding: 5px 10px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 3px;
            font-size: 14px;
            margin-right: 10px;
        }

        .mod-action:hover {
            background-color: #45a049;
        }

        .admin-action {
            background-color: #ff5555;
        }

        .admin-action:hover {
            background-color: #cc4444;
        }

        .msg {
            color: #ff5555;
            font-size: 16px;
            display: block;
            margin: 20px 0;
            padding: 10px;
            background-color: rgba(255, 85, 85, 0.1);
            border: 1px solid #ff5555;
            border-radius: 5px;
        }

        .pixel-icon {
            font-size: 24px;
            margin-right: 10px;
            vertical-align: middle;
        }
    </style>
  </head>
  
  <body>
    <div class="container">
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
		
		if (myRole.equals("admin") == false) { 									//如果不是管理员		
			msg = "您的权限不足！";
			msg += "&emsp;<a href='main.jsp'>用户功能</a>" + label;
			out.print(msg);
			return;
		}

		String linkAdmin = "";													//管理链接	
		
		if (myRole.equals("admin")) { 											//如果为管理员
			linkAdmin = "&nbsp;&emsp;|&emsp;&nbsp;<a href='../modAdmin.jsp'>模组管理</a>"
				+ "&nbsp;&emsp;<a href='../userAdmin.jsp'>用户管理</a>";			//生成管理链接
		}		

		if (request.getParameter("buttonDelete") != null) { 					//如果单击了删除按钮
			String[] versionIdList = request.getParameterValues("versionId"); 		//classId值列表
			
			if (versionIdList != null) {
				String versionIdAll = "";
				
				for (int i = 0; i < versionIdList.length; i++) {
					try { 									 
						Integer.parseInt(versionIdList[i]);			//尝试转换为整数，即判断其是否为整数
					} catch (Exception e) {
						continue;									//如果转换失败，即不是整数，则略过此项
					}
					
					versionIdAll += "," + versionIdList[i];	
				}
				
				if (versionIdAll.isEmpty() == false) {				//如果有值
					versionIdAll = versionIdAll.substring(1);			//去除最前面的逗号
					
					Db db2 = new Db();								//新建实例（该实例实现了数据的增删改查）					
					//String sql2 = "delete from tb_class where classId in (3,6,8)";
					String   sql2 = "delete from tb_version where versionName in (" + versionIdAll + ")";
					int count = db2.delete(sql2);					//批量删除记录	
					
					msg = "成功删除了" + count + "个版本类型！";
					request.setAttribute("msg", msg);
				}
			}
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
			searchUrl = URLEncoder.encode(search, "UTF-8");			//进行URL编码，以便在地址栏传递参数
		}
		
		Db db = new Db();											//新建实例（该实例实现了数据的增删改查）
		String sql = ""; 
		ResultSet rs = null;
		String sqlWhere = "";
		
		if (search.equals("") == false) {							//如果有搜索内容
			//sqlWhere = " where year like '%陈%'";					//常用的模糊查询
			sqlWhere = " where concat_ws(',', versionName, year, dept) like ?";	//多字段模糊查询
			//db.setCanShowSql(true);								//将在控制台输出SQL语句
		}	

		//--->>>-------------查询记录总数		
		if (search.equals("")) {									//没搜索，或无搜索内容
			sql = "select count(*) from tb_version"; 					//SQL查询语句
			rs = db.select(sql); 									//执行查询，得到结果集
		} else {													//如果有搜索内容	
			sql = "select count(*) from tb_version " + sqlWhere; 		//SQL模糊查询语句
			rs = db.select(sql, "%" + search + "%"); 				//增加含有查询内容的参数
		}

		if (rs == null) {		
			msg = "数据库操作发生错误！" + back;
			out.print(msg);
			return;
		}
			
		int countRow = 0;
		
		if(rs.next()) {									//如果读取下一条记录成功
			countRow = rs.getInt(1); 					//读取第1个字段的值（整数）
		}			
		rs.close();										//用完立即关闭rs，但没关闭数据库连接
		//---<<<-------------查询记录总数
		
		//--->>>-------------开始数据分页
		int pageSize  = 3;  							//每页3条记录
		int pageCount = 0; 								//总页数预设为0

		if (countRow % pageSize == 0) {					//如果余数为0，即能整除
			pageCount = countRow / pageSize; 			//总页数
		} else {
			pageCount = countRow / pageSize + 1;		//不能整除则加1页。如果除数为小数，将自动去除小数部分得到整数			
		}
		
		int pageShow = 1; 								//当前页预设为1
		try { 									 
			pageShow = Integer.parseInt(pageInput);		//如果是数字，返回字符串对应的整数   
		} catch (Exception e) {
			//showPage = 1; 							//如果抛出异常，则取预设值
		}				

		if (pageShow < 1) {								//如果当前页码小于1
			pageShow = 1;
		} else if (pageShow > pageCount && pageCount >= 1) { 		//如果当前页码大于总页数，且总页数>=1
			pageShow = pageCount;
		}
		
		int indexStart = 0;											//查询记录时的起始位置	
		indexStart = (pageShow - 1) * pageSize;						//已经显示的记录条数	
				
		if (search.equals("")) {									//没搜索，或无搜索内容	
			sql = "select * from tb_class order by className"		//SQL查询语句
				+ " limit " + indexStart + "," + pageSize; 			//只获取该页的记录
			rs = db.select(sql); 									//执行查询，得到结果集
		} else {													//没搜索，或无搜索内容
			sql = "select * from tb_class " + sqlWhere + " order by className"	//SQL模糊查询语句
				+ " limit " + indexStart + "," + pageSize; 			//只获取该页的记录
			rs = db.select(sql, "%" + search + "%"); 				//增加含有查询内容的参数
		}
		
		if (rs == null) {		
			msg = "数据库操作发生错误！" + back;
			out.print(msg);
			return;
		}
  	%> 
	  	</span>    	
		<form action="" method="post">
		<table style="width:800px; margin:0px auto;">
			<tr>
				<td>
					<div style="margin:0px 0px 40px; font-size:small;">
						欢迎：${ myUsername }（${ myRole }）&emsp;
						<a href="../logout.jsp">注销登录</a>&emsp;
						<a href="../userShow.jsp?userId=${ myUserId }">个人信息</a>&emsp;
						<a href="../main.jsp">用户功能</a>&nbsp;&emsp;|&emsp;
						<a href="../studentList.jsp">模组列表</a>&emsp;
						<a href="../studentPage.jsp">模组分页</a>
						<%= linkAdmin %>
					</div>
					
					<h3>班级管理</h3>
					<div class="right note" style="margin:40px 0px 5px 0px;">
						<div style="display:inline-block; padding-right:250px;">
							（<a href="classAdd.jsp">新添班级</a>）
						</div>
						&emsp;&emsp;搜索：
						<input type="text" name="search" value="<%= search %>" style="width:80px;">
						<input type="submit" name="buttonSearch" value="搜索">
						<span class="note">（在班级名称、入学年份、学院中搜索）</span>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<table class="table_border table_border_bg table_hover" style="width:100%">
						<tr class="tr_header">
							<td>序号</td>
							<td>班级名称</td>
							<td>入学年份</td>	
							<td>详情/修改</td>
							<td style="width:46px;">选择</td>
						</tr>
						<%
							int i = indexStart; 									//序号
							String className, year, dept;

							while (rs.next()) { 									//如果读到了数据									
								i++;
								className	= rs.getString("className");			//获取字段的值
								year 		= rs.getString("year");
							
								String classId = rs.getString("classId");			//链接中要用到
						%>
						<tr>
							<td><%= i %></td>
							<td><%= className %></td>
							<td><%= year %></td>
							<td>
								<a href="classShow.jsp?classId=<%= classId %>" title="显示详情">
									<img src="../image/icon_show.gif" border="0"></a>&emsp;
								<a href="classEdit.jsp?classId=<%= classId %>" title="编辑">
									<img src="../image/icon_edit.gif" border="0"></a>
							</td>
							<td>
								<input type="checkbox" name="classId" value="<%= classId %>" onchange="check()">
							</td>
						</tr>
						<%
							}							
							db.close(); 		//用完立即关闭
							
							if (i == 0) {
								msg = "（没有记录）";
								request.setAttribute("msg", msg);
							}
						%>
						<tr>
							<td colspan="8" class="note" style="text-align:right; height:50px;">
								<span class="msg">${ msg }</span>&emsp;&emsp;
								<input type="submit" name="buttonDelete" value="删除" 
									onclick="return confirm('确认删除所选记录？');">
								&emsp;
								<label>全选:<input type="checkbox" name="checkboxAll" 
									onchange="checkAll()"></label>&emsp;
							</td>
						</tr>
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
							<a href="classAdmin.jsp?pageUrl=<%= 1 %>&searchUrl=<%= searchUrl %>">首页</a>&ensp;
							<a href="classAdmin.jsp?pageUrl=<%= pageShow - 1 %>&searchUrl=<%= searchUrl %>">上一页</a>&ensp;
					<% } %>
					
					<% if (pageShow >= pageCount) { %>
							<span style="color:gray;">下一页&ensp;
							尾页</span>
					<% } else { %>
							<a href="classAdmin.jsp?pageUrl=<%= pageShow + 1 %>&searchUrl=<%= searchUrl %>">下一页</a>&ensp;
							<a href="classAdmin.jsp?pageUrl=<%= pageCount %>&searchUrl=<%= searchUrl %>">尾页</a>
					<% } %>
					&emsp;&emsp;
					页码：<%= pageShow + "/" + pageCount %>&emsp;
					记录数：<%= countRow %>&emsp;&emsp;
					输入页码:
					<input type="text" name="pageShow" value="<%= pageShow %>" style="width:40px; text-align:center;">
					<input type="submit" name="buttonPage" id="buttonPage" value="提交">	&emsp;
				</td>
			</tr>	
		</table>
		</form>
    </div>
  </body>
<script type="text/javascript">
function checkAll() {
	var checkboxList = document.getElementsByName("classId");			//获取复选框列表
	var checkboxAll  = document.getElementsByName("checkboxAll")[0];	//全选复选框
	
	for (var i = 0; i < checkboxList.length; i++) {						//对于列表中的每一个复选框
		checkboxList[i].checked = checkboxAll.checked;					//此复选框的勾选情况与全选复选框一致
	}
}

function check() {
	var checkboxList = document.getElementsByName("classId");			//获取复选框列表
	var checkboxAll  = document.getElementsByName("checkboxAll")[0];	//全选复选框
	var isChecked = true;
	
	for (var i = 0; i < checkboxList.length; i++) {						//对于列表中的每一个复选框
		if (checkboxList[i].checked == false) {							//如果没被勾选
			isChecked = false;
			break;
		}
	}
	
	if (isChecked) {
		checkboxAll.checked = true;										//全选复选框被勾选
	} else {
		checkboxAll.checked = false;									//全选复选框被取消勾选
	}
}
</script>
</html>
