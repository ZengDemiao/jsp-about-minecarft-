<%@page import="java.sql.ResultSet"%>
<%@page import="dao.Db"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh">
  <head>
	<title>登录验证</title>
	<link rel="stylesheet" type="text/css" href="css/css.css">
  </head>
  
  <body>
	<div style="width:600px; margin:30px auto;">
    	<h3>登录验证</h3>
    	<span class="msg">
	<%
		request.setCharacterEncoding("UTF-8");
		String msg = "";
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		for (int f = 0; f < 1; /*f++*/) {							//方便随时退出循环，去输出出错消息
			if (username == null || password == null) {
				username = "";
				password = "";
				break;
			}
			
			if (username.trim().equals("")) {
				msg = "请输入用户名！";
				break;
			}
			username = username.trim();
			
			if (password.equals("")) {
				msg = "请输入密码！";
				break;
			}
			
			Db db = new Db();				//新建实例（该实例实现了数据的增删改查）
			String sql = ""; 				//SQL语句
			ResultSet rs = null;			//记录集
			
			//select userId, role from tb_user where username = 'tom' and password = '1'”		//样例
			sql = "SELECT userId, role FROM tb_user " +
      				"WHERE username = '" + username + "' AND password = '" + password + "'";
			rs = db.select(sql);			
											//执行查询。务必理解SQL语句中的空格、逗号、加号、双引号、单引号的作用
											//以上SQL语句容易被进行SQL注入式攻击，例如：在password文本框输入：0' or '1'='1	
			//sql = "select userId, role from tb_user where username = ? and password = ?";	//SQL语句中应用占位符“?”
			//rs = db.select(sql, username, password);					//调用的selec()方法应用了预编译的SQL执行接口对象
			
			if (rs == null) {		
				msg = "数据库操作发生错误！";
				break;
			}
						
			if (rs.next() == false)	{							//尝试读取下一条记录，如果没读到记录
				db.close();										//用完之后需及时关闭与数据库的连接
				msg = "登录失败！输入的用户名或者密码不正确。";
				break;
			}
			//--------往下：能查询到记录
			
			String userId = "", role = "";
					
			userId 	= rs.getString(1);							//第1列的字段值。效率最高。相当于rs.getString("userId")
			role 	= rs.getString("role");						//字段名为role的值。效率稍低
			db.close();											//用完需及时关闭与数据库的连接
			
			session.setAttribute("myUserId", userId); 			//用户id，添加到session
			session.setAttribute("myUsername", username); 		//用户名
			session.setAttribute("myRole", role);				//用户角色（权限）
			
			response.sendRedirect("main.jsp"); 					//登录成功后，重定向到下一个网页
			return;
		}
		
		request.setAttribute("username", username);				//将在index.jsp页用EL表达式显示出来
		request.setAttribute("password", password);
		request.setAttribute("msg", msg);
		request.getRequestDispatcher("index.jsp").forward(request, response);	//转发到下一个网页
		//return;			//此处不能有return（将使其后的语句无法执行）。但在if、循环等内部语句中可以有return
	%>
		</span>
	</div>
  </body>
</html>
