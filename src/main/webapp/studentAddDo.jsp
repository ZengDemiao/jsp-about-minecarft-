<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>新添模组的结果</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>新添模组的结果</h3>
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
			String studentNo = "", studentName = "", sex = "", age = "", className = "", note = "";
			
			studentNo 	= request.getParameter("studentNo"); 			//取得输入的值
			studentName = request.getParameter("studentName");
			sex 		= request.getParameter("sex");
			age 		= request.getParameter("age");
			className	= request.getParameter("className");
			note		= request.getParameter("note");
		
			if (studentNo == null || studentName == null || age == null //值为null的原因：输入框名称不对，或者在地址栏直接输入本页网址
					|| className == null || note == null) {				//sex在下面检查。只要不选择性别，sex就是null	
				msg = "输入不正确！";							
				break;
			}
			studentNo 	= studentNo.trim();								//去除首尾空格
			studentName = studentName.trim();
			age 		= age.trim();
			className	= className.trim();
			note		= note.trim();
			
			if (studentNo.length() < 1 || studentNo.length() > 8) {	
				msg = "学号要求为1~8个字符！";							
				break;
			}
			if (studentName.length() < 1 || studentName.length() > 45) {	
				msg = "姓名要求为1~45个字符！！";							
				break;
			}
			if (sex == null || (sex.equals("男") == false && sex.equals("女") == false)) {	
				msg = "请选择性别！";								//只要不选择性别，sex就是null					
				break;
			}		
			
			if (age.equals("")) {									//年龄文本框有输入
				age = "0";
			}
			
			int ageInt = 0;
			
			try {
				ageInt = Integer.parseInt(age); 					//如果是数字，返回对应的整数   
			} catch (Exception e) {	
				msg = "年龄要求为0~150之间的整数！";							
				break;
			}
			if (ageInt < 0 || ageInt > 150) {	
				msg = "年龄要求为0~150之间的整数！";							
				break;
			}		
			age = String.valueOf(ageInt);							//转换为字符串
			
			if (className.length() > 0) {							//班级名称文本框有输入
				if (className.length() > 45) {	
					msg = "班级名称要求为1~45个字符！！";							
					break;
				}
			}
			
			Db db = new Db();										//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 
			ResultSet rs = null;

			//----------------- 由于学号要求唯一，故需要判断学号是否已经存在此学号			
			sql = "select * from tb_student where studentNo = ?"; 	//查询是否已经存在此学号
			rs = db.select(sql, studentNo); 						//执行查询
	
			if (rs == null) {				
				msg = "数据库操作发生错误！";							
				break;
			}
			
			if (rs.next()) {
				db.close();	
				msg = "您输入的学号已经存在，请重新输入！";							
				break;
			}
			rs.close();												//只关闭rs，因为下面还要插入数据
	
			//----------------- 插入数据
			sql = "insert into tb_student (studentNo, studentName, sex, age, className, note)"
				+ " values (?, ?, ?, ?, ?, ?)";
			String studentId = db.insert(sql, studentNo, studentName, sex, age, className, note); 
																	//执行SQL语句，得到被新添的记录的ID
			
			if (studentId.equals("0")){
				msg = "模组信息新添失败！请重试。"; 		
				break;
			}
		
			msg = "模组信息新添成功！"; 
			String url = "studentShow.jsp?studentId=" + studentId;
			
			request.setAttribute("msg", msg);
			request.getRequestDispatcher(url).forward(request, response);		//转发
			return;
		}
		
		msg += back;			//新添失败。加上后退按钮
		out.print(msg);		
	%>
		</span>
		<br>
		<a href="studentAdmin.jsp">返回模组管理</a>
	</div>
  </body>
</html>
