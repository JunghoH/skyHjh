<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="UTF-8"%>
<%@page import="com.java.board.User"%>
<%@page import="com.java.board.UserDao"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="user" class="com.java.board.User" scope="page" />
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>adcore test board</title>
    <style type="text/css">
        table{
            border: 1px solid #ccc;
        }
        table th, table td{
            border-color :#ccc;
        }
    </style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script>
    	$("#document").ready(function(){
	        var strList  = "";
	        var strLists = [];
	        <%String actionType = "";
	         UserDao userDao = new UserDao();
	         ArrayList<User> userList  = (ArrayList<User>)userDao.selectInfo(actionType);
	         if (userList != null) {
	         	for (int i = 0; i < userList.size(); i++) {%>
		        	strLists.push({
		         		dbId        : "<%= userList.get(i).getDbId() %>",
		         		id          : "<%= userList.get(i).getId() %>",
		         		name        : "<%= userList.get(i).getName() %>",
		         		description : "<%= userList.get(i).getDescription() %>",
		         		parent      : "<%= userList.get(i).getParent() %>",
		         		rdOnly      : "<%= userList.get(i).getReadOnly() %>"
		         	});
	         	<%}%>
	         	getSearch ();
	         <%}%>
	         
	         //serach list setting
	         function getSearch () {
	        	 $("#memDiv").empty();
	        	 for (var s = 0; s < strLists.length; s++) {
	        		 var getStr = "";
	        		 getStr += "<tr>";
	        		 getStr += "<td><input name=\"dbId\" type=\"hidden\" value= '" + strLists[s].dbId + "'></input><input name=\"hdRdOnly\" type=\"hidden\" /></td>";
	        		 getStr += "<td><input name=\"chk\" type=\"checkbox\" value= \"\"></input></td>";
                     if (strLists[s].rdOnly != '1') {
    	        		 getStr += "<td><input name=\"id\" type=\"text\"           value= '" + strLists[s].id + "'></input></td>";
    	        		 getStr += "<td><input name=\"name\" type=\"text\"         value= '" + strLists[s].name + "'></input></td>";
    	        		 getStr += "<td><input name=\"description\" type=\"text\"  value= '" + strLists[s].description + "'></input></td>";
    	        		 getStr += "<td><input name=\"parent\" type=\"text\"       value= '" + strLists[s].parent + "'></input></td>";
                    	 getStr += "<td><input name=\"rdOnly\" type=\"checkbox\"></input></td>";
                     } else {
    	        		 getStr += "<td><input name=\"id\" type=\"text\"           value= '" + strLists[s].id + "'          style='background-color:#E2E2E2' readonly></input></td>";
    	        		 getStr += "<td><input name=\"name\" type=\"text\"         value= '" + strLists[s].name + "'        style='background-color:#E2E2E2' readonly></input></td>";
    	        		 getStr += "<td><input name=\"description\" type=\"text\"  value= '" + strLists[s].description + "' style='background-color:#E2E2E2' readonly></input></td>";
    	        		 getStr += "<td><input name=\"parent\" type=\"text\"       value= '" + strLists[s].parent + "'      style='background-color:#E2E2E2' readonly></input></td>";
                    	 getStr += "<td><input name=\"rdOnly\" type=\"checkbox\" checked onClick=\"return false;\"></input></td>";
                     }
                     getStr += "</tr>";
                     $("#memDiv").append(getStr);
	        	 }
	        	 //object reset
	        	 strLists = [];
	         }
	         
            //create row
            $("#insertTr").click(function () {
                var inStr = "";
                inStr += "<tr>";
                inStr += "<td><input name=\"dbId\" type=\"hidden\" value= \"\"></input><input name=\"hdRdOnly\" type=\"hidden\" /></td>";
                inStr += "<td><input name=\"chk\" type=\"checkbox\" value= \"\"></input></td>";
                inStr += "<td><input name=\"id\" type=\"text\" value= \"\"></input></td>";
                inStr += "<td><input name=\"name\" type=\"text\" value= \"\"></input></td>";
                inStr += "<td><input name=\"description\" type=\"text\" value= \"\"></input></td>";
                inStr += "<td><input name=\"parent\" type=\"text\" value= \"\"></input></td>";
                inStr += "<td><input name=\"rdOnly\" type=\"checkbox\"></input></td>";
                inStr += "</tr>";
                $("#memDiv").append(inStr);
            });

            //delete row
            var delRowDbIds = [];
            $("#deleteTr").click(function () {
                var chkObj    = $("[name=chk]");
                var tempDbIds = $("[name=dbId]");
                var chkLength = chkObj.length;
                var checked   = 0;
                for (var i = chkLength - 1; i >= 0; i--) {
                    if (chkObj[i] == undefined) {
                        continue;
                    }
                    if (chkObj[i].checked) {
                    	//db saved Id to keep 
                    	if (tempDbIds[i].value != undefined && tempDbIds[i].value != null){
                    		delRowDbIds.push(tempDbIds[i].value);
                    	}
                        checked += 1;
                        $(chkObj[i]).parent().parent().remove();
                    }
                }
                if (checked == 0 ) {
                    alert("don't checked");
                    return;
                } else {
                    alert("delete count : " + checked);
                    return;
                }
            });
            
            //all delete
            $("#deleteAll").click(function () {
                if(confirm("Are you sure you want to delete all row?")){
                	//버젼 체크
                    var tempDbIds  = $("[name=dbId]");
                	for (var i = 0; i < tempDbIds.length; i++){
	                	//db saved Id to keep 
	                	if (tempDbIds[i].value != undefined && tempDbIds[i].value != null){
	                		delRowDbIds.push(tempDbIds[i].value);
	                	}
                	}
                    //변경 test
                	$("#memDiv").empty();
                } else {
                    return;
                }
            });

            //file upload
            $("#upload").bind("click", function () {
                var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;
                if (regex.test($("#fileUpload").val().toLowerCase())) {
                    if (typeof (FileReader) != "undefined") {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            //var table = $("<table />");
                            var rows = e.target.result.split("\n");
                            for (var i = 1; i < rows.length - 1; i++) {
                                var insFile = "";
                                insFile += "<tr>";
                                insFile += "<td><input name=\"dbId\" type=\"hidden\" value= \"\"></input><input name=\"hdRdOnly\" type=\"hidden\" /></td>";
                                insFile += "<td><input name=\"chk\" type=\"checkbox\" value= \"\"></input></td>";
                                var cells = rows[i].split("	");
                                var tempId       = cells[0].replace("\"", "");
                                var tempReadOnly = cells[4].replace("\"", "");
                                insFile += "<td><input name=\"id\" type=\"text\"           value= '" + tempId + "'></input></td>";
                                insFile += "<td><input name=\"name\" type=\"text\"         value= '" + cells[1] + "'></input></td>";
                                insFile += "<td><input name=\"description\" type=\"text\"  value= '" + cells[2] + "'></input></td>";
                                insFile += "<td><input name=\"parent\" type=\"text\"       value= '" + cells[3] + "'></input></td>";
                                if (tempReadOnly == 0) {
                                    insFile += "<td><input name=\"rdOnly\" type=\"checkbox\"></input></td>";
                                } else {
                                    insFile += "<td><input name=\"rdOnly\" type=\"checkbox\" checked></input></td>";
                                }
                                insFile += "</tr>";
                                $("#memDiv").append(insFile);
                            }
                        }
                        reader.readAsText($("#fileUpload")[0].files[0]);
                    } else {
                        alert("This browser does not support HTML5.");
                    }
                } else {
                    alert("Please upload a valid CSV file.");
                }
            });
			
          //serach
            $("#dbList").click(function () {
            	if(confirm("Are you sure you want to serach of database?")){
                    $("#memDiv").empty();
                    //변경 test
                    document.form.submit();
                } else {
                    return;
                }
            });
          	
            //apply
            $("#saveTr").click(function () {
            	//document.getElementById("strDelId").vlue = "DOM";
          		
                //delete db_id setting to String
                var tempId = "";
            	if (delRowDbIds.length > 0) {
                    tempId = delRowDbIds.join(",'");
            	}
            	
            	//check sent value just checked data and I did sent another value setting hdRdOnly
            	$('input:checkbox[name="rdOnly"]').each(function(idx) {
                    $(this).is(":checked") ? $(this).val("1") : $(this).val("0");
            	});
            	$("#strDelId").val("");
            	$("#strDelId").val(tempId);
            	delRowDbId = [];
                document.cudForm.submit();
                $("#memDiv").empty();
            });
            
            //csv file downLoad
            $("#fileDownlod").click(function (){
            	if(confirm("Are you sure you want to save data of database?")){
            		//var form = document.forms.downForm;
            		//form.getAttribute('action'));
            		var ret = window.open($('form[name="downForm"]').attr('action'), "List DownLoad", "");
                } else {
                    return;
                }
            });
        });
        /*
            $.getJSON(url, param, function (data, status) {
            var tags = [];
            
            if (data != null) {
                $.each(data.rows, function (idx, el) {
                tags.push("<tr>");
                tags.push('<td>' + el.memberId + '</td>');
                tags.push('<td>' + el.memberName + '</td>');
                tags.push('<td>' + el.memberAddr + '</td>');
                tags.push('</tr>');
                $("#memDiv").append(tags);
                });
            }
            });
        */
    </script>
</head>
<body>
	<div>
		<button id="dbList">DB List</button>
		<button id="insertTr">Add row</button>
		<button id="deleteTr">delete row</button>
		<button id="deleteAll">deleteAll row</button>
		<div style='float: right;'>
			<input type="file" id="fileUpload" />
			<input type="button" id="upload" value="Upload to view" />
		</div>
		<form name="form" method="post" action="index.jsp">
			<input id="searchType" type="hidden" value= "" />
		</form>
		<form name="downForm" method="post" action="downLoadAction.jsp"></form>
		<form name="cudForm"  method="post" action="cudAction.jsp">
		    <table>
		        <tr>
		            <th></th>
		            <th>
		                Check
		            </th>
		            <th>
		                ID
		            </th>
		            <th>
		                NAME
		            </th>
		            <th>
		                DESCRIPTION
		            </th>
		            <th>
		                PARENT
		            </th>
		            <th>
		                READ_ONLY
		            </th>
		        </tr>
		        <tbody id="memDiv"></tbody>
		    </table>
		    <input id="strDelId" name= "strDelId" type="hidden" value= "choose a file" />
	    </form>
		<button id="fileDownlod">csv file downlod</button>
		<button id="saveTr">Apply</button>
	</div>
</body>
</html>