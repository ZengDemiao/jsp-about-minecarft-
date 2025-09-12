<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>修改模组</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>修改模组</h3>
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
			
		String modId = request.getParameter("modId"); 			//获取地址栏参数modId的值

		try { 									 
			Integer.parseInt(modId);								//如果不能转换为整数   
		} catch (Exception e) {
			msg = "参数modId错误！" + back;
			out.print(msg);
			return;
		}
		
		Db db = new Db();												//新建实例（该实例实现了数据的增删改查）
		String sql = ""; 
		ResultSet rs = null;
		
		sql = "select * from tb_mod where modId = ?";
		rs = db.select(sql, modId);

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

		String modNo = "", modName = "", server = "", year = "", version = "", note = "", timeRenew = "";
		
		modNo 	= rs.getString("modNo"); 							//获取字段的值
		modName = rs.getString("modName");
		server 		= rs.getString("server");
		year 		= rs.getString("year");	
		version	= rs.getString("version");
		note		= rs.getString("note");
		//note 		= note.replace("\r\n", "<br>").replace(" ", "&ensp;");	//替换换行符和空格，以在页面中能显示换行和多空格效果
		timeRenew	= rs.getString("timeRenew");							//在连接MySQL 8时指定了时区地点，则获取到的时间不需格式化
		db.close();

		String checkedMale = "", checkedFemale = "";
		
		if (server.equals("PC")) {
			checkedMale = "checked";
		} else if (server.equals("网易")) {
			checkedFemale = "checked";
		}
	%>
		</span>

		<form action="modEditDo.jsp?modId=<%= modId %>" method="post">
		<table class="table_border table_padding10" style="width:500px; margin:0px auto;">
			<tr class="tr_header">
				<td>项目</td>
				<td>内容&emsp;&emsp;&emsp;&emsp;</td>
			</tr>
			<tr>
				<td width="30%">模组编号</td>
				<td class="left">
					<input type="text" name="modNo" value="<%= modNo %>" maxlength="8">
					<span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td>模组名称</td>
				<td class="left">
					<input type="text" name="modName" value="<%= modName %>" maxlength="45">
					<span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td>适用服务器</td>
				<td class="left">
					<label><input type="radio" name="sex" value="PC" <%= checkedMale %>>PC</label>&nbsp;
					<label><input type="radio" name="sex" value="网易" <%= checkedFemale %>>网易</label>&nbsp;
					&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td>发布年份</td>
				<td class="left">
					<input type="text" name="age" value="<%= year %>" maxlength="3">
				</td>
			</tr>
			<tr>
				<td>版本类型</td>
				<td class="left">
					<input type="text" name="className" value="<%= modName %>" maxlength="45">
				</td>
			</tr>
			<tr>
				<td>备注</td>
				<td class="left">
					<textarea name="note" rows="5" cols="30"><%= note %></textarea>
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
					<a href="studentShow.jsp?studentId=<%= modId %>">返回详情页</a>
				</td>
			</tr>
		</table>
		</form>
		<br>
		<a href="modAdmin.jsp">返回学生管理</a>
	</div>
  </body>
</html>
