package com.croombs.beans;

/**
 * Room is the bean class contains all the details of a conference room 	
 */
public class Room {
	int roomId;
	String name;
	String description;
	int noOfSeats;
	String contactNum;
	// XML??
	
	
	public Room(int roomId) {
		super();
		this.roomId = roomId;
	}
	public Room(int roomId, String name) {
		super();
		this.roomId = roomId;
		this.name = name;
	}
	public Room(int roomId, String name, String description, int noOfSeats) {
		super();
		this.roomId = roomId;
		this.name = name;
		this.description = description;
		this.noOfSeats = noOfSeats;
	}
	
	
	public Room(int roomId, String name, String description, int noOfSeats,
			String contactNum) {
		super();
		this.roomId = roomId;
		this.name = name;
		this.description = description;
		this.noOfSeats = noOfSeats;
		this.contactNum = contactNum;
	}
	public int getRoomId() {
		return roomId;
	}
	public void setRoomId(int roomId) {
		this.roomId = roomId;
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
	public int getNoOfSeats() {
		return noOfSeats;
	}
	public void setNoOfSeats(int noOfSeats) {
		this.noOfSeats = noOfSeats;
	}
	public String getContactNum() {
		return contactNum;
	}
	public void setContactNum(String contactNum) {
		this.contactNum = contactNum;
	}

	
//	TODO: how to compare int values?? (after reading generics)
//	public int compareTo(Room room) {
//		return roomId.compareTo(room.getRoomId());
//	}
	
}
	
