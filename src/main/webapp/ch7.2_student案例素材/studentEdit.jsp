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
		//####【添加代码】
		
		
		

		String checkedMale = "", checkedFemale = "";
		
		//####【添加代码】
		
		
	%>
		</span>

		<form action="" method="post">		<!-- //####【添加代码】 -->
		<table class="table_border table_padding10" style="width:500px; margin:0px auto;">
			<tr class="tr_header">
				<td>项目</td>
				<td>内容&emsp;&emsp;&emsp;&emsp;</td>
			</tr>
			<tr>
				<td width="30%">学号</td>
				<td class="left">
					<input type="text" name="studentNo" maxlength="8">		<!-- //####【添加代码】 -->
					<span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td>姓名</td>
				<td class="left">
					<input type="text" name="studentName" maxlength="45">	<!-- //####【添加代码】 -->
					<span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td>性别</td>
				<td class="left">
					//####【添加代码】
					&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<span style="color:red;">*</span>
				</td>
			</tr>
			<tr>
				<td>年龄</td>
				<td class="left">
					<input type="text" name="age" maxlength="3">			<!-- //####【添加代码】 -->
				</td>
			</tr>
			<tr>
				<td>班级</td>
				<td class="left">
					<input type="text" name="className" maxlength="45">		<!-- //####【添加代码】 -->
				</td>
			</tr>
			<tr>
				<td>备注</td>
				<td class="left">
					 //####【添加代码】
				</td>
			</tr>
			<tr>
				<td>更新时间</td>
				<td class="left"></td>				<!-- //####【添加代码】 -->
			</tr>
			<tr>
				<td colspan="2">
					&emsp;&emsp;&emsp;&emsp;
					<input type="submit" value="提交">
					&emsp;&emsp;
					<a href="">返回详情页</a>		<!-- //####【添加代码】 -->
				</td>
			</tr>
		</table>
		</form>
		<br>
		<a href="studentAdmin.jsp">返回模组管理</a>
	</div>
  </body>
</html>
