<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>删除模组</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>删除模组</h3>
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
			String studentId = request.getParameter("studentId"); 		//获取地址栏参数studentId的值
		
			try { 									 
				Integer.parseInt(studentId);							//如果不能转换为整数   
			} catch (Exception e) {
				msg = "参数studentId错误！";	
				break;
			}
			
			Db db = new Db();											//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 
			ResultSet rs = null;
			
			sql = "select * from tb_student where studentId = ?";
			rs = db.select(sql, studentId);
		
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
			
			sql = "delete from tb_student where studentId = ?"; 			//SQL删除语句
			int count = db.delete(sql, studentId); 						//执行SQL语句，得到被删除的记录的条数
			
			if (count == 0) {	
				msg = "模组信息删除失败！请重试。"; 		
				break;
			}
		
			msg = "模组信息删除成功！"; 
		}																//for循环的结束大括号
		
		if (msg.indexOf("成功") <= 0) {									//如果msg中无“成功”
			msg += back;												//加上后退按钮
		}
		out.print(msg);		
	%>
		</span>
		<br><br>
		<a href="studentAdmin.jsp">返回模组管理</a>
	</div>
  </body>
</html>
