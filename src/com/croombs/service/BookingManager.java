package com.croombs.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import com.croombs.beans.Booking;
import com.croombs.beans.Room;

public class BookingManager {

	Logger logger = Logger.getLogger(BookingManager.class);

	public BookingManager() {
		super();
 	}

	/**
	 * Retrieves the booking details from DB for particular period
	 *
	 * @param roomId	roomid as stored on ROOM table
	 * @param fromDate 	date from which the bookings need to be retrieved
	 * @param days		no of days' data to be retrieved from fromData
	 * @return			list of booking objects in an array list
	 */
	public List<Booking> getBookings(int roomId, Date fromDate, int days) {

		logger.debug("Get bookings for room:" + roomId+" from:" + fromDate + " for "+ days+" days");

		DBManager dbMgr = new DBManager();
		List<Booking> listBookings = new ArrayList<Booking>();
		Statement stmt = null;

		// short DateFormatter
		//DateFormat shortDf = DateFormat.getDateInstance(DateFormat.SHORT);
		DateFormat sDf = new SimpleDateFormat("dd-MMM-yy");

		// Find toDate: = fromDate + days
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		cal.add(Calendar.DAY_OF_WEEK, days);
		Date toDate = cal.getTime();

		// fromDate and toDate in short Date format
		String fDate = sDf.format(fromDate);
		String tDate = sDf.format(toDate);

		// Get DB connection
		Connection conn = dbMgr.getConnection();

		// SQL Query
		StringBuffer strQuery = new StringBuffer("");
		strQuery.append("SELECT B.ID, B.USER_ID, B.CONF_NAME, B.CONF_DESC, B.BOOKING_DATE, B.BOOKING_TIME, B.CONF_DATE, B.START_TIME, B.END_TIME, B.STATUS, B.NO_OF_ATTN, B.CONTACT_NUMBER, B.EMAIL, U.NAME FROM BOOKING B, USER_PROFILE U ")
				.append(" WHERE B.ROOM_ID =").append(roomId)
				.append(" AND B.CONF_DATE BETWEEN ")
				.append(" Format('").append(fDate).append("','DD-MMM-YY') AND")
				.append(" Format('").append(tDate ).append("','DD-MMM-YY') AND")
//				.append(fDate).append("' AND '").append(tDate).append("' AND ")
				.append(" B.STATUS = 'ACTIVE' AND")
				.append(" B.USER_ID = U.USER_ID ")
				.append(" ORDER BY B.CONF_DATE, B.START_TIME"); 

		logger.debug("DB Connection created. Query: "+ strQuery);
		logger.debug("Getting booking details from DB..");

		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(new String(strQuery));

			// For each booking entry, create
			while (rset.next()) {

				// Get data from the result set
				int bookingId 		= rset.getInt("ID");
				String userId 		= rset.getString("USER_ID");
				//int roomId 		= rset.getInt("ROOM_ID");
				String confName 	= rset.getString("CONF_NAME");
				String confDesc 	= rset.getString("CONF_DESC");
				Date boookingDate 	= rset.getDate("BOOKING_DATE");
				String bookingTime 	= rset.getString("BOOKING_TIME");
				Date confDate		= rset.getDate("CONF_DATE");
				String startTime 	= rset.getString("START_TIME");
				String endTime 		= rset.getString("END_TIME");
				String status 		= rset.getString("STATUS");
				int noOfAttn 		= rset.getInt("NO_OF_ATTN");
				String contactNum 	= rset.getString("CONTACT_NUMBER");
				String eMail 	= rset.getString("EMAIL");
				String userName	= rset.getString("NAME");

				// Create Booking object
				Booking booking = new Booking(bookingId, userId, new Room(roomId), confName,
						confDesc, boookingDate, bookingTime, confDate, startTime,
						endTime, status, noOfAttn, contactNum,eMail,userName);

				// Add to the Bookings list
				listBookings.add(booking);
			}

			logger.debug(listBookings.size()+" bookings are added to listBookings object");
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

		// return the list of Bookings
		return listBookings;
	}

	/**
	 * Saves the new booking details to DB
	 *
	 * @param Booking	Booking object
	 * @return			Save status (true/false)
	 */
	public boolean saveNewBooking(Booking newBooking){

		DBManager dbMgr = new DBManager();
		DateFormat sDf = new SimpleDateFormat("dd-MMM-yy");
		Statement stmt = null;
		int saveRecords =0;

		// Build column values
		String userId 		= newBooking.getUserId();
		int roomId 			= newBooking.getRoom().getRoomId();
		String confName 	= newBooking.getConfName().replaceAll("\'", "A");
		String confDesc 	= newBooking.getConfDesc(); 
		String bookingDate 	= sDf.format(newBooking.getBoookingDate());
		String bookingTime 	= newBooking.getBookingTime();
		String startTime 	= newBooking.getStartTime();
		String endTime 		= newBooking.getEndTime();
		String status		= newBooking.getStatus();
		String noOfAttn 	= ""+ newBooking.getNoOfAttn();
		String contactNum 	= newBooking.getContactNum();
		String eMail		= newBooking.getEMail();
		String confDate		= sDf.format(newBooking.getConfDate());

		// Check availability before saving the new booking
		boolean isAvaliable = isSlotAvailable(roomId, confDate, startTime, endTime); 

		logger.debug("Is slot available for room: " + roomId + " confDate:" + confDate
				+ " startTime:" + startTime + "endTime:" +endTime+" ??? " + isAvaliable);

		// If the slot is not available can not save the new booking
		if(!isAvaliable) {
			logger.debug("Slot not available; returning false");
			return false;
		}

		// Get DB connection
		Connection conn = dbMgr.getConnection();

		// SQL Query
		StringBuffer strQuery = new StringBuffer("");
		strQuery.append("INSERT INTO BOOKING(USER_ID, ROOM_ID, CONF_NAME, CONF_DESC, BOOKING_DATE, BOOKING_TIME, CONF_DATE, START_TIME, END_TIME, STATUS, NO_OF_ATTN, CONTACT_NUMBER, EMAIL) ")
				.append("VALUES('")
				.append(userId).append("', ")
				.append(roomId).append(", '")
				.append(confName).append("', '")
				.append(confDesc).append("', '")
				.append(bookingDate).append("', '")
				.append(bookingTime).append("', '")
				.append(confDate).append("', '")
				.append(startTime).append("', '")
				.append(endTime).append("', '")
				.append(status).append("','")
				.append(noOfAttn).append("','")
				.append(contactNum).append("','")
				.append(eMail).append("')");

		logger.debug("DB Connection created. Query: "+ strQuery);
		logger.debug("Saving new booking details in DB..");

		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			saveRecords = stmt.executeUpdate(new String(strQuery));

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

		return (saveRecords != 0);
	}

	/**
	 * Retrieves the booking details of the user
	 *
	 * @param userId		User id of the user (Employee id)
	 * @param bookingsType	Bookings type: current or previous
	 * @return				list of booking objects in an array list
	 */
	public List<Booking> getMyBookings(String userId, String bookingType)
	{
		List<Booking> listBookings = new ArrayList<Booking>();
		Statement stmt = null;

		// current hour and minutes
		String bh = ""+ new Date().getHours();
		String bm = ""+ new Date().getMinutes();
		String currTime = (bh.length()==1 ? "0"+bh : bh) + (bm.length()==1 ? "0"+bm : bm);

		logger.debug("Get bookings of user:" + userId+" type:" +bookingType);

		// Get DB connection
		Connection conn = new DBManager().getConnection();

		// SQL Query
		StringBuffer strQuery = new StringBuffer("");
		if (bookingType.equals("my_curr_bookings")) {

			strQuery.append("SELECT")
					.append("	B.ID, B.USER_ID, B.ROOM_ID, B.CONF_NAME, B.CONF_DESC, B.BOOKING_DATE, B.BOOKING_TIME, ")
					.append("	B.CONF_DATE, B.START_TIME, B.END_TIME, B.STATUS, B.NO_OF_ATTN, B.CONTACT_NUMBER, B.EMAIL, R.NAME ")
					.append("FROM BOOKING B, ROOM R ")
					.append("WHERE ")
					.append("	USER_ID='").append(userId).append("' AND ")
					.append("   (")
					.append("      ( B.CONF_DATE = DATE() AND B.END_TIME >'").append(currTime).append("') OR ")
					.append("      ( B.CONF_DATE > DATE())")
					.append("	) AND")
					.append("   B.STATUS='ACTIVE' AND ")
					.append("	B.ROOM_ID= R.ID");
		}
		if (bookingType.equals("my_prev_bookings")) {

			strQuery.append("SELECT")
					.append("	B.ID, B.USER_ID, B.ROOM_ID, B.CONF_NAME, B.CONF_DESC, B.BOOKING_DATE, B.BOOKING_TIME, ")
					.append("	B.CONF_DATE, B.START_TIME, B.END_TIME, B.STATUS, B.NO_OF_ATTN, B.CONTACT_NUMBER, B.EMAIL, R.NAME ")
					.append("FROM BOOKING B, ROOM R ")
					.append("WHERE ")
					.append("	USER_ID='").append(userId).append("' AND ")
					.append("   (")
					.append("      ( B.CONF_DATE = DATE() AND B.END_TIME <'").append(currTime).append("') OR ")
					.append("      ( B.CONF_DATE < DATE())")
					.append("	) AND")
//					.append("   B.STATUS<>'ACTIVE' AND ")
					.append("	B.ROOM_ID= R.ID");
		}

		logger.debug("DB Connection created. Query: "+ strQuery);
		logger.debug("Get my booking details from DB..");

		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(new String(strQuery));

			// For each booking entry, create
			while (rset.next()) {

				// Get data from the result set
				int bookingId 		= rset.getInt("ID");
				//String userId 	= rset.getString("USER_ID");
				int roomId 			= rset.getInt("ROOM_ID");
				String confName 	= rset.getString("CONF_NAME");
				String confDesc 	= rset.getString("CONF_DESC");
				Date boookingDate 	= rset.getDate("BOOKING_DATE");
				String bookingTime 	= rset.getString("BOOKING_TIME");
				Date confDate		= rset.getDate("CONF_DATE");
				String startTime 	= rset.getString("START_TIME");
				String endTime 		= rset.getString("END_TIME");
				String status 		= rset.getString("STATUS");
				int noOfAttn 		= rset.getInt("NO_OF_ATTN");
				String contactNum 	= rset.getString("CONTACT_NUMBER");
				String roomName 	= rset.getString("NAME");
				String eMail	 	= rset.getString("EMAIL");

				// Create Booking object
				Booking booking = new Booking(bookingId, userId, new Room(roomId, roomName), confName,
						confDesc, boookingDate, bookingTime, confDate, startTime,
						endTime, status, noOfAttn, contactNum, eMail);

				// Add to the Bookings list
				listBookings.add(booking);
			}

			logger.debug(listBookings.size()+" bookings are added to listBookings object");
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

		// return the list of Bookings
		return listBookings;

	}


	/**
	 * Cancels the booking by setting the status to 'CANCELLED'
	 *
	 * @param bookingId 	bookingId to be canceled
	 * @return canceled status
	 */
	public boolean cancelBooking(int bookingId)
	{
		logger.info("Cancelling booking id:" + bookingId);

		Statement stmt = null;
		int cancelledRecords = 0;

		// Get DB connection
		Connection conn = new DBManager().getConnection();
		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			cancelledRecords = stmt.executeUpdate("UPDATE BOOKING SET STATUS='CANCELLED' WHERE ID=" + bookingId );

			logger.debug("cancelledRecords:" + cancelledRecords);
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

		logger.debug("Booking cancelled ? " + (cancelledRecords != 0));
		return (cancelledRecords != 0);
	}

	/**
	 *  Checks if the slot is available on the BOOKING table
	 *
	 * @param confDate	Conference date
	 * @param startTime	Conference start time
	 * @param endTime	Conference end time
	 * @return 			available or not (true or false)
	 */
	private boolean isSlotAvailable(int roomId, String confDate, String startTime, String endTime) {

		DBManager dbMgr = new DBManager();
		Statement stmt = null;
		boolean isAvailable = false;

		// Get DB connection
		Connection conn = dbMgr.getConnection();

		StringBuffer strQuery = new StringBuffer("");
		strQuery.append("SELECT ID FROM BOOKING WHERE ")
				.append("ROOM_ID = ").append(roomId).append(" AND ") 
				.append("STATUS = 'ACTIVE' AND ")
				.append("CONF_DATE = Format('").append(confDate).append("','DD-MMM-YY') AND (")
				.append("(START_TIME >= '").append(startTime).append("' AND START_TIME < '").append(endTime).append("') OR ")
				.append("(END_TIME > '").append(startTime).append("' AND END_TIME <= '").append(endTime).append("') OR ")
				.append("(START_TIME <= '").append(startTime).append("' AND END_TIME >= '").append(endTime).append("') )");

		System.out.println("isSlotAvailable Query -->" + strQuery);

		try {
			// Run query to get check if slot is available
 			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(new String(strQuery));

			isAvailable = ! rset.next(); // If any record exists, it means the slot is not available
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
		return isAvailable;
	}

	/**
	 * getBookings - Stub method
	 *
	 * @param roomId
	 * @param fromDate
	 * @param days
	 * @return
	 */
	public List<Booking> getBookingsStub(int roomId, Date fromDate, int days) {

		List<Booking> listBookings = new ArrayList<Booking>();
		Calendar cal = Calendar.getInstance();

		// Create Booking object
		Booking booking1 = new Booking(10, "210146", new Room(1), "Gen-eSys",
				"Training on Gen-eSys framework", new Date(), "1000", new Date("08-MAY-09"), "0200",
				"0330", "ACTIVE", 10, "6881","vinay.l@tcs.com");

		Booking booking2 = new Booking(11, "210146", new Room(1), "Spring",
				"Training on Springs", new Date(), "1000", new Date("06-MAY-09"), "0900",
				"1030", "ACTIVE", 10, "6281","vinay.l@tcs.com");

		Booking booking3 = new Booking(12, "210146", new Room(1), "Struts",
				"Training on Gen-eSys framework", new Date(), "1000", new Date("07-MAY-09"), "1700",
				"1830", "ACTIVE", 10, "6851","vinay.l@tcs.com");

		// Add to the Bookings list
		listBookings.add(booking1);
		listBookings.add(booking2);
		listBookings.add(booking3);

		return listBookings;
	}



}
