package com.java.board;

public class User {
	private String dbId;//PK
	private String id;
	private String name;
	private String description;
	private String parent;
	private String readOnly;
	private String strDelId;
	
	public String getDbId() {
		return dbId;
	}
	public void setDbId(String dbId) {
		this.dbId = dbId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
	}
	public String getReadOnly() {
		return readOnly;
	}
	public void setReadOnly(String readOnly) {
		this.readOnly = readOnly;
	}
	public String getStrDelId() {
		return strDelId;
	}
	public void setStrDelId(String strDelId) {
		this.strDelId = strDelId;
	}
	
}
