<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="UTF-8"%>
<%@page import="com.java.board.UserDao"%>
<%@page import="java.lang.*"%>
<jsp:useBean id="user" class="com.java.board.User" scope="page" />
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>file downLoad</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script>
    	$("#document").ready(function(){
	        <%UserDao userDao = new UserDao();
	        int successChk  = (int)userDao.listDownLoad();
	         if (successChk == 1) {%>
	         	alert("List file saved to D drive 12345");
	         <%} else {%> 
	         	alert("false file downLoad");
	         <%}%>
	         //opener.location.reload();
	         self.close();
        });
    </script>
</head>
<body>
</body>
</html>