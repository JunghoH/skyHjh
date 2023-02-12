<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="UTF-8"%>
<%@page import="com.java.board.UserDao"%>
<%@page import="java.lang.*"%>
<jsp:useBean id="user" class="com.java.board.User" scope="page" />
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>board</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script>
    	$("#document").ready(function(){
	        <%UserDao userDao = new UserDao();
	        int successChk  = (int)userDao.cudProcess(request);
	         if (successChk == 1) {%>
	         	alert("success cud action");
	         <%} else {%> 
	         	alert("false cud action 12345");
	         <%}%>
	         document.form.submit();
        });
    </script>
</head>
<body>
<div id = "cudDiv"></div>
	<form name="form" method="post" action="index.jsp"></form>

</body>
</html>