<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>删除班级</title>
	<link rel="stylesheet" href="../css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>删除班级</h3>
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
		
		for (int f = 0; f < 1; f++) {
			String classId = request.getParameter("classId"); 			//获取地址栏参数classId的值
		
			try { 									 
				Integer.parseInt(classId);								//如果不能转换为整数   
			} catch (Exception e) {
				msg = "参数classId错误。请刷新后重试！";
				break;
			}
			
			String myUserId = session.getAttribute("myUserId").toString();	//取得session中的值
	
			if (classId.equals(myUserId)) { 								//如果是自己
				msg = "班级不许删除自己！";
				break;
			}
			
			Db db = new Db();											//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 
			ResultSet rs = null;
			
			sql = "select * from tb_class where classId = ?"; 		
			rs = db.select(sql, classId);
	
			if (rs == null) {				
				msg = "数据库操作发生错误！";
				break;
			}
			
			if (rs.next() == false) {
				db.close();
				msg = "对应的记录已不存在！";
				break;
			}
			rs.close();													//只关闭rs			
			
			sql = "delete from tb_class where classId = ?"; 			//SQL删除语句
			int count = db.delete(sql, classId);						//执行SQL语句，得到被删除的记录的条数
			
			if (count == 0) {	
				msg = "删除班级信息失败！请重试。";
				break;
			}
		
			msg = "删除班级信息成功！";
		}
		
		if (msg.indexOf("成功") <= 0) {									//如果msg中无“成功”
			msg += back;			//加上后退按钮
		}
		out.print(msg);
	%>
		</span>
		<br><br>
		<a href="classAdmin.jsp">返回班级管理</a>
	</div>
  </body>
</html>
