package com.croombs.beans;

import java.util.Date;

/**
 * Booking is the bean class contains all the details of a conference booking
 * 
 */
public class Booking { 

	int bookingId;
	String userId;
	Room room;
	String confName;
	String confDesc;
	Date boookingDate;
	String bookingTime;
	Date confDate;
	String startTime;
	String endTime;
	String status;
	int noOfAttn;
	String contactNum;
	String eMail;
	String userName;
	
	public Booking(int bookingId, String userId, Room room, String confName,
			String confDesc, Date boookingDate, String bookingTime,
			Date confDate, String startTime, String endTime, String status,
			int noOfAttn, String contactNum, String mail) {
		super();
		this.bookingId = bookingId;
		this.userId = userId;
		this.room = room;
		this.confName = confName;
		this.confDesc = confDesc;
		this.boookingDate = boookingDate;
		this.bookingTime = bookingTime;
		this.confDate = confDate;
		this.startTime = startTime;
		this.endTime = endTime;
		this.status = status;
		this.noOfAttn = noOfAttn;
		this.contactNum = contactNum;
		this.eMail = mail;
	}

	public Booking(int bookingId, String userId, Room room, String confName,
			String confDesc, Date boookingDate, String bookingTime,
			Date confDate, String startTime, String endTime, String status,
			int noOfAttn, String contactNum, String mail, String userName) {
		super();
		this.bookingId = bookingId;
		this.userId = userId;
		this.room = room;
		this.confName = confName;
		this.confDesc = confDesc;
		this.boookingDate = boookingDate;
		this.bookingTime = bookingTime;
		this.confDate = confDate;
		this.startTime = startTime;
		this.endTime = endTime;
		this.status = status;
		this.noOfAttn = noOfAttn;
		this.contactNum = contactNum;
		this.eMail = mail;
		this.userName = userName;
	}
	
	public int getBookingId() {
		return bookingId;
	}
	public void setBookingId(int bookingId) {
		this.bookingId = bookingId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Room getRoom() {
		return room;
	}
	public void setRoom(Room room) {
		this.room = room;
	}
	public String getConfName() {
		return confName;
	}
	public void setConfName(String confName) {
		this.confName = confName;
	}
	public String getConfDesc() {
		return confDesc;
	}
	public void setConfDesc(String confDesc) {
		this.confDesc = confDesc;
	}
	public Date getBoookingDate() {
		return boookingDate;
	}
	public void setBoookingDate(Date boookingDate) {
		this.boookingDate = boookingDate;
	}
	public String getBookingTime() {
		return bookingTime;
	}
	public void setBookingTime(String bookingTime) {
		this.bookingTime = bookingTime;
	}
	public Date getConfDate() {
		return confDate;
	}
	public void setConfDate(Date confDate) {
		this.confDate = confDate;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getNoOfAttn() {
		return noOfAttn;
	}
	public void setNoOfAttn(int noOfAttn) {
		this.noOfAttn = noOfAttn;
	}
	public String getContactNum() {
		return contactNum;
	}
	public void setContactNum(String contactNum) {
		this.contactNum = contactNum;
	}
	public String getEMail() {
		return eMail;
	}
	public void setEMail(String mail) {
		eMail = mail;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

}
