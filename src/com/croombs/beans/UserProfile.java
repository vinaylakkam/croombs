package com.croombs.beans;

/**
 * UserProfile is the bean class contains all the details of the user	
 */
public class UserProfile {

	String userId;
	String password;
	String profileType;
	String name;
	String contactNum;
	String mail;
	int allowedBookHrs;
	int prefRoomId;
	int prefBookDays;
	
	// without password
	public UserProfile(String userId, String profileType, String name,
			String contactNum, String mail, int allowedBookHrs, int prefRoomId, int prefBookDays) {
		super();
		this.userId = userId;
		this.profileType = profileType;
		this.name = name;
		this.contactNum = contactNum;
		this.mail = mail;
		this.allowedBookHrs = allowedBookHrs;
		this.prefRoomId = prefRoomId;
		this.prefBookDays = prefBookDays;
	}
	
	// without allowedBookHrs, password
	public UserProfile(String userId, String profileType, String name,
			String contactNum, String mail, int prefRoomId, int prefBookDays) {
		super();
		this.userId = userId;
		this.profileType = profileType;
		this.name = name;
		this.contactNum = contactNum;
		this.mail = mail;
		this.prefRoomId = prefRoomId;
		this.prefBookDays = prefBookDays;
	}

	// without allowedBookHrs
	public UserProfile(String userId, String password, String profileType, String name,
			String contactNum, String mail,   int prefRoomId, int prefBookDays) {
		super();
		this.userId = userId;
		this.password = password;
		this.profileType = profileType;
		this.name = name;
		this.contactNum = contactNum;
		this.mail = mail;
		this.prefRoomId = prefRoomId;
		this.prefBookDays = prefBookDays;
	}
	
	
	// all fields
	public UserProfile(String userId, String password, String profileType, String name,
			String contactNum, String mail, int allowedBookHrs, int prefRoomId, int prefBookDays) {
		super();
		this.userId = userId;
		this.password = password;
		this.profileType = profileType;
		this.name = name;
		this.contactNum = contactNum;
		this.mail = mail;
		this.allowedBookHrs = allowedBookHrs;
		this.prefRoomId = prefRoomId;
		this.prefBookDays = prefBookDays;
	}
	
	
 
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}	
	public String getProfileType() {
		return profileType;
	}
	public void setProfileType(String profileType) {
		this.profileType = profileType;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getContactNum() {
		return contactNum;
	}
	public void setContactNum(String contactNum) {
		this.contactNum = contactNum;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public int getPrefRoomId() {
		return prefRoomId;
	}
	public void setPrefRoomId(int prefRoomId) {
		this.prefRoomId = prefRoomId;
	}
	public int getPrefBookDays() {
		return prefBookDays;
	}
	public void setPrefBookDays(int prefBookDays) {
		this.prefBookDays = prefBookDays;
	}

	public int getAllowedBookHrs() {
		return allowedBookHrs;
	}

	public void setAllowedBookHrs(int allowedBookHrs) {
		this.allowedBookHrs = allowedBookHrs;
	}
	
	
}
