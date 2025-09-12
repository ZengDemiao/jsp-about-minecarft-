<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>修改班级的结果</title>
	<link rel="stylesheet" href="../css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>修改班级的结果</h3>
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
		
		for (int f = 0; f < 1; /*f++*/) {
			String className = "", year = "";
			
			className 	= request.getParameter("className"); 			//获取输入的值
			year 		= request.getParameter("year");
		
			if (className == null || year == null) {
				msg = "输入不正确！";										//值为null的原因：输入框名称不对，或者在地址栏直接输入本页网址
				break;
			}
			className = className.trim();
			year = year.trim();
		
			if (className.length() < 1 || className.length() > 45) {
				msg = "“班级名称应为”为1~45个字符！";
				break;
			}
			
			try {
				int n = Integer.parseInt(year);
				
				if (n < 2000 || n > 2022) {
					msg = "入学年份的范围有误！";
					break;
				}
			} catch (Exception e) {				
				msg = "入学年份应为4位的整数！";
				break;
			}
	
			String classId = request.getParameter("classId"); 			//获取地址栏参数classId的值
	
			try { 									 
				Integer.parseInt(classId);								//如果不能转换为整数   
			} catch (Exception e) {
				msg = "参数classId错误！";
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
			
			sql = "select * from tb_class where className = ? and classId != ?";		
			rs = db.select(sql, className, classId);
	
			if (rs == null) {				
				msg = "数据库操作发生错误！";
				break;
			}
			
			if (rs.next()) {		//如果有记录
				db.close();
				msg = "所输入的班级名称已经存在！";
				break;
			}
			rs.close();													//只关闭rs
	
			//--->>>------------ 更新数据
			int count = 0;
			
			sql = "update tb_class set className = ?, year = ?" 
				+ ", timeRenew = (now()) where classId = ?";
			count = db.update(sql, className, year, classId);
			
			if (count == 0){	
				msg = "修改班级信息失败！请重试。";
				break;
			}
	
			msg = "修改班级信息成功！";
			String url = "classShow.jsp?classId=" + classId;
			
			request.setAttribute("msg", msg);
			request.getRequestDispatcher(url).forward(request, response);		//转发
			return;
		}
		
		msg += back;			//加上后退按钮
		out.print(msg);
	%>
		</span>
		<br>
		<a href="classAdmin.jsp">返回班级管理</a>
	</div>
  </body>
</html>
