package com.java.board;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

public class UserDao {
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String dbURL = "";
	private String dbID  = "";
	private String dbPassword = "";
	
	public UserDao(){
		try {
			dbURL = "jdbc:mysql://localhost:3306/HJH";
			System.out.println("git test 02");
			dbID  = "root";
			System.out.println("git test");
			dbPassword = "root";
			System.out.println("git test");
			Class.forName("com.mysql.cj.jdbc.Driver");
			System.out.println("git test");
		} catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	//select list
	public ArrayList<User> selectInfo (String actionType) throws Exception {
		System.out.println("java check selectInfo #######################################\n");
		
		ArrayList<User> listUser = new ArrayList<>();
		String SQL = "";
		SQL  = " SELECT ";
		SQL += " 	 DB_ID ";
		SQL += " 	,ID ";
		SQL += " 	,NAME ";
		SQL += " 	,DESCRIPTION ";
		SQL += " 	,PARENT ";
		SQL += " 	,READ_ONLY ";
		SQL += " FROM HJH.INT_USER;";
		try {
			Connection conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				User user = new User();
				user.setDbId(rs.getString(1));
				user.setId(rs.getString(2));
				user.setName(rs.getString(3));
				user.setDescription(rs.getString(4));
				user.setParent(rs.getString(5));
				user.setReadOnly(rs.getString(6));
				listUser.add(user);
			}
		} catch(Exception ex){
			ex.printStackTrace();
		}
		return listUser;
	}

	public int cudProcess (HttpServletRequest request){
		System.out.println("java check cudProcess #######################################\n");
		
		int ret = 1;
		String strDelId = request.getParameter("strDelId");
		
		try{
			Connection conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			
			//delete process
			if (strDelId != null && strDelId != "") {
				
				//,' to split
				String[] strDelIds = strDelId.split(",'");
				String delSQL = "";
				delSQL  = " DELETE ";
				delSQL += " FROM HJH.INT_USER";
				delSQL += " WHERE DB_ID IN (";
				// mulite del
				for (int dels = 0; dels < strDelIds.length; dels++) {
					if (dels == 0) delSQL += " ?";
					else delSQL += " ,?";
				}
				delSQL += " );";
				
				pstmt = conn.prepareStatement(delSQL);
				for (int dels = 0; dels < strDelIds.length; dels++) {
					pstmt.setString(dels + 1, strDelIds[dels]);
				}
				pstmt.executeUpdate();
			}
			
			//insert and update process
			String[] strDbIds = request.getParameterValues("dbId");
			
			if (strDbIds != null) {
				if (strDbIds.length != 0) {
					String[] strIds          = request.getParameterValues("id");
					String[] strNames        = request.getParameterValues("name");
					String[] strDescriptions = request.getParameterValues("description");
					String[] strParents      = request.getParameterValues("parent");
					String[] strReadOnlys    = request.getParameterValues("hdRdOnly");
					
					String insertSQL = "";
					String updateSQL = "";
	
					for (int i = 0; i < strDbIds.length; i++) {
						
						//insert
						if (strDbIds[i] == null || strDbIds[i] == "") {
							
							insertSQL = "";
							insertSQL  = "INSERT INTO HJH.INT_USER(";
							insertSQL += "  DB_ID";
							insertSQL += " ,ID";
							insertSQL += " ,NAME";
							insertSQL += " ,DESCRIPTION";
							insertSQL += " ,PARENT";
							insertSQL += " ,READ_ONLY";
							insertSQL += " )";
							insertSQL += " SELECT ";
							insertSQL += " 	(SELECT (IFNULL(MAX(DB_ID), '0') + 1) AS DB_ID FROM HJH.INT_USER)";
							insertSQL += " 	,?";
							insertSQL += " 	,?";
							insertSQL += " 	,?";
							insertSQL += " 	,?";
							insertSQL += " 	,?";
							insertSQL += " FROM DUAL;";
							
							pstmt = conn.prepareStatement(insertSQL);
							pstmt.setString(1, strIds[i]);
							pstmt.setString(2, strNames[i]);
							pstmt.setString(3, strDescriptions[i]);
							pstmt.setString(4, strParents[i]);
							pstmt.setString(5, strReadOnlys[i]);
							pstmt.executeUpdate();
	
						//update
						} else {
							updateSQL  = "";
							updateSQL  = " UPDATE HJH.INT_USER";
							updateSQL += " SET";
							updateSQL += "  ID             = ?";
							updateSQL += " ,NAME           = ?";
							updateSQL += " ,DESCRIPTION    = ?";
							updateSQL += " ,PARENT         = ?";
							updateSQL += " ,READ_ONLY      = ?";
							updateSQL += " WHERE DB_ID     = ?";
							updateSQL += " AND   READ_ONLY = '0'";
							updateSQL += ";";
							
							pstmt = conn.prepareStatement(updateSQL);
							pstmt.setString(1, strIds[i]);
							pstmt.setString(2, strNames[i]);
							pstmt.setString(3, strDescriptions[i]);
							pstmt.setString(4, strParents[i]);
							pstmt.setString(5, strReadOnlys[i]);
							pstmt.setString(6, strDbIds[i]);
							pstmt.executeUpdate();
						}
					}
				}
			}
		} catch(Exception ex){
			ret = 0;
			ex.printStackTrace();
		}
		return ret;
	}
	
	//csv file downLoad
	public int listDownLoad () {
		System.out.println("java check listDownLoad #######################################\n");
		int ret = 1;
		try {
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
			String strTime = format.format(new Date());
			
			//SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INT_USER' //COLUMN INFOMATION
			StringBuffer sb = new StringBuffer();
			sb.append("ID");
			sb.append(",");
			sb.append("NAME");
			sb.append(",");
			sb.append("DESCRIPTION");
			sb.append(",");
			sb.append("PARENT");
			sb.append(",");
			sb.append("READ_ONLY");
			sb.append("\r\n");
			
			ArrayList<User> list = this.selectInfo("");
			if (list.size() != 0) {
				for (int i = 0; i < list.size(); i++) {
					sb.append(list.get(i).getId());
					sb.append(",");
					sb.append(list.get(i).getName());
					sb.append(",");
					sb.append(list.get(i).getDescription());
					sb.append(",");
					sb.append(list.get(i).getParent());
					sb.append(",");
					sb.append(list.get(i).getReadOnly());
					sb.append("\r\n");
				}
			}
			FileWriter fw     = new FileWriter("D://listDown_"+ strTime +".csv", true);
			BufferedWriter bw = new BufferedWriter(fw);
			PrintWriter pw    = new PrintWriter(bw);
			pw.println(sb.toString());
			pw.flush();
			pw.close();
		} catch (Exception ex) {
			ret = 0;
			ex.printStackTrace();
		}
		return ret;
	}
}
