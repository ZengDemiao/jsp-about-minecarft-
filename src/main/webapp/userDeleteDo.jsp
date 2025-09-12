<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>删除玩家</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
    <div style="width:600px; margin:30px auto;">
    	<h3>删除玩家</h3>
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
		
		for (int f = 0; f < 1; f++) {
			String userId = request.getParameter("userId"); 			//获取地址栏参数userId的值
		
			try { 									 
				Integer.parseInt(userId);								//如果不能转换为整数   
			} catch (Exception e) {
				msg = "参数userId错误。请刷新后重试！";
				break;
			}
			
			String myUserId = session.getAttribute("myUserId").toString();	//取得session中的值
	
			if (userId.equals(myUserId)) { 								//如果是自己
				msg = "玩家不许删除自己！"; 
				break;
			}
			
			Db db = new Db();											//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 
			ResultSet rs = null;
			
			sql = "select * from tb_user where userId = ?"; 		
			rs = db.select(sql, userId);
	
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
			
			sql = "delete from tb_user where userId = ?"; 			//SQL删除语句
			int count = db.delete(sql, userId);						//执行SQL语句，得到被删除的记录的条数
			
			if (count == 0) {	
				msg = "删除玩家信息失败！请重试。"; 
				break;
			}
		
			msg = "删除玩家信息成功！"; 
		}
		
		if (msg.indexOf("成功") <= 0) {								//如果msg中无“成功”
			msg += back;			//加上后退按钮
		}
		out.print(msg);
	%>
		</span>
		<br><br>
		<a href="playerAdmin.jsp">返回玩家管理</a>
	</div>
  </body>
</html>
