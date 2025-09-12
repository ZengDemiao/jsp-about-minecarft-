<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>修改模组的结果</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>修改模组的结果</h3>
    	<span class="msg">
	<%
		request.setCharacterEncoding("UTF-8");
		String msg = "";	
		String label = "</span></div></body></html>";
		String back = "&emsp;<a href='javascript:window.history.back();'>后退</a>" + label;		//后退链接
		
		if (session.getAttribute("myRole") == null) { 					//如果此session属性不存在或已经失效
			msg = "<br>您的登录已失效！请重新登录。";
  			msg += "&emsp;<a href='index.jsp'>玩家登录</a>" + label;	
			out.print(msg);
			return;
		}

		String myRole = session.getAttribute("myRole").toString();		//获取session中该对象的值

		if (myRole.equals("admin") == false) { 							//如果不是管理员		
			msg = "您的权限不足！";
			msg += "&emsp;<a href='main.jsp'>玩家功能</a>" + label;
			out.print(msg);
			return;
		}		

		for (int f = 0; f < 1; /*f++*/) {
			String modNo = "", modName = "", server = "", year = "", version = "", note = "";
			
			modNo 	= request.getParameter("modNo"); 			//取得输入的值
			modName = request.getParameter("modName");
			server 		= request.getParameter("server");
			year 		= request.getParameter("year");
			version	= request.getParameter("version");
			note		= request.getParameter("note");
	
			if (modNo == null || modName == null || year == null //值为null的原因：输入框名称不对，或者在地址栏直接输入本页网址
					|| version == null || note == null) {				//sex在下面检查。只要不选择性别，sex就是null	
				msg = "输入不正确！";							
				break;
			}
			modNo 	= modNo.trim();								//去除首尾空格
			modName = modName.trim();
			year 		= year.trim();
			version	= version.trim();
			note		= note.trim();
			
			if (modNo.length() < 1 || modNo.length() > 8) {	
				msg = "模组编号要求为1~8个字符！";							
				break;
			}
			if (modName.length() < 1 || modName.length() > 45) {	
				msg = "模组名称要求为1~45个字符！！";							
				break;
			}
			if (server == null || (server.equals("PC") == false && server.equals("网易") == false)) {	
				msg = "请选择版本！";								//只要不选择性别，sex就是null
				break;
			}		
			
			if (year.equals("")) {									//年龄文本框有输入
				year = "0";
			}
			
			int ageInt = 0;
			
			try {
				ageInt = Integer.parseInt(year); 					//如果是数字，返回对应的整数   
			} catch (Exception e) {	
				msg = "年份要求为0~150之间的整数！";							
				break;
			}
			if (ageInt < 0 || ageInt > 150) {	
				msg = "年份要求为0~150之间的整数！";							
				break;
			}		
			year = String.valueOf(ageInt);							//转换为字符串
			
			if (version.length() > 0) {							//班级名称文本框有输入
				if (version.length() > 45) {	
					msg = "版本类型要求为1~45个字符！！";							
					break;
				}
			}
					
			String studentId = request.getParameter("studentId"); 	//获取地址栏参数studentId的值
	
			try { 									 
				Integer.parseInt(studentId);						//如果不能转换为整数   
			} catch (Exception e) {
				msg = "参数modId错误！";
				break;
			}
			
			Db db = new Db();										//新建实例（该实例实现了数据的增删改查）
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
			rs.close();												//只关闭rs		
			
			//----------------- 由于学号要求唯一，故需要判断学号是否与其他人的学号相同
			sql = "select * from tb_student where studentNo = ? and studentId != ?"; 	//查询是否已经存在此学号
			rs = db.select(sql, modNo, studentId); 						
	
			if (rs == null) {			
				msg = "数据库操作发生错误！";
				break;
			}
			
			if (rs.next() == true) {
				db.close();
				msg = "您输入的编号已经存在，请重新输入！";
				break;
			}
			rs.close();												//只关闭rs		

			//----------------- 更新数据
			sql = "update tb_student set studentNo = ?, studentName = ?, sex = ?, age = ?" 
				+ ", className = ?, note = ?, timeRenew = (now()) where studentId = ?";
			int count = db.update(sql, modNo, modName, server, year, version, note, studentId); 	
																	//执行SQL语句，得到被修改的记录的条数
			
			if (count == 0) {	
				msg = "模组信息修改失败！请重试。"; 
				break;
			}
		
			msg = "模组信息修改成功！"; 
			String url = "studentShow.jsp?studentId=" + studentId;
			
			request.setAttribute("msg", msg);
			request.getRequestDispatcher(url).forward(request, response);		//转发到该网址url
			return;
		}
		
		msg += back;			//修改失败。加上后退按钮
		out.print(msg);
	%>
		</span>
		<br>
		<a href="modAdmin.jsp">返回模组管理</a>
	</div>
  </body>
</html>
