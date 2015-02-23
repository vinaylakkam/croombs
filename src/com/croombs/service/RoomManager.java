/**
 * 
 */
package com.croombs.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;

import com.croombs.beans.Room;

public class RoomManager {

	Logger logger = Logger.getLogger(RoomManager.class);	
	
	public RoomManager() {
		super();
	}
	
	public List<Room> getRooms() {
		
		logger.debug("Get all rooms from DB");
		
		DBManager dbMgr = new DBManager();
		List<Room> listRooms = new ArrayList<Room>();
		Statement stmt = null;		

		// Get DB connection
		Connection conn = dbMgr.getConnection();
		
		// SQL Query 
		String strQuery = "SELECT ID, NAME, DESCRIPTION, NO_OF_SEATS, CONTACT_NUMBER FROM ROOM ORDER BY ID";
		
		logger.debug("DB Connection created. Query: "+ strQuery);
		logger.debug("Getting room details from DB..");

		try {
			// Run query to get booking details
 			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(strQuery);

			// For each booking entry, create
			while (rset.next()) {
		
				// Get data from the result set
				int roomId 			= rset.getInt("ID");
 				String name			= rset.getString("NAME");
 				String description 	= rset.getString("DESCRIPTION");
 				int noOfSeats 		= rset.getInt("NO_OF_SEATS");
 				String contactNum	= rset.getString("CONTACT_NUMBER");

 				// Add to the room list
				listRooms.add(new Room(roomId, name, description, noOfSeats, contactNum));
			}

			logger.debug(listRooms.size()+" rooms are added to listBookings object");
		} 
		catch(SQLException ex) {
			ex.printStackTrace();
		}  
		finally{
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		// return the list of rooms
		return listRooms;
	}

	/**
	 * getRoomsStub - Stub method
	 * @return
	 */
	private List<Room> getRoomsStub() {

		List<Room> listRooms = new ArrayList<Room>();

		// Create Room object
		Room room1 = new Room(1, "Zone 1 Conference Room");
		Room room2 = new Room(2, "Zone 2 Conference Room");

		// Add to the Rooms list
		listRooms.add(room1);
		listRooms.add(room2);

		return listRooms;
	}
}
