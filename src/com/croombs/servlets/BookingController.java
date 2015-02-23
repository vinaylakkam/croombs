package com.croombs.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.croombs.Mail;
import com.croombs.Util;
import com.croombs.beans.Booking;
import com.croombs.beans.Room;
import com.croombs.beans.UserProfile;
import com.croombs.service.BookingManager;
import com.croombs.service.DBManager;
import com.croombs.service.RoomManager;
import com.croombs.service.UserProfileManager;

/**
 * BookingController is the servlet class to handle requests of the 'bookings' related screens
 *
 * The functionalities provided by this class are:
 * <ul>
 * 	<li>TODO</li>
 * 	<li>TODO</li>
 * </ul>
 *
 */
public class BookingController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	Logger logger = Logger.getLogger(BookingController.class); 

	/**
	 * Handles get method requests
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
 		doPost(request, response);
	}


	/**
	 * Handles post method requests
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();

		// Get the context
		String context =  (String) request.getParameter("Hid_Context");
		System.out.println("BookingController:Context: " +context);
		
 
		/* HOME PAGE */
		if(context == null) {

			logger.info("CRoomBS accessed from client. IP: " + request.getLocalAddr());

			// Check if the user is already logged in
			checkLoginUser(request, response);

			// Get default room of the user TODO: Get from preferences.properties file
			int defaultRoomId = 1;
			int defaultDays = 10;

			// Set initial selectedDate as null (used in jsp)
			session.setAttribute("selectedDate", null);
			
			// Set attribute as home page
			request.setAttribute("home_page", "true");

			// Display the booking details with default details
			displayBookings(defaultRoomId, new Date(), defaultDays, request, response);

			return;
		}

		/* BOOKINGS PAGE (when clicked from other pages) */
		if(context.equals("bookings")) {

			// Get default room of the user TODO: Get from preferences.properties file
			int defaultRoomId = 1;
			int defaultDays = 10; // TODO: If logged in get user preferences (pref no of days)

			// Set initial selectedDate as null (used in jsp)
			session.setAttribute("selectedDate", null);
			
			// Display the booking details with default details
			displayBookings(defaultRoomId, new Date(), defaultDays, request, response);
			return;
		}		

		/* BOOKINGS NAVIGATION */
		if( context.equals("get_prev_bookings") ||  context.equals("get_next_bookings") ||
			context.equals("get_curr_bookings") ||  context.equals("get_bookings")||
			context.equals("get_bookings_by_date")) {

 			int nDays = Integer.parseInt(request.getParameter("Opt_DaysPerPage"));
 			int roomId = Integer.parseInt(request.getParameter("Opt_Rooms"));
			String selectedDate = request.getParameter("Hid_CurrSelectedDate");

			session.setAttribute("selectedDate", selectedDate); // to use in jsp

			DateFormat df = new SimpleDateFormat("dd-MMM-yy");
			Date fromDate = new Date();
			try {
				fromDate = df.parse(selectedDate);
			}
			 catch (ParseException e) {
				e.printStackTrace();
			}

			// display the booking details from 'from date' for nDays of room
			displayBookings(roomId, fromDate, nDays, request, response);
			return;			
		}

		/* NEW BOOKING */
		if(context.equals("new_booking")){

			// save new booking details
			boolean saveStatus = saveNewBooking(request);
			boolean sendMailStatus = false;

			logger.debug("New booking saved in DB?" + saveStatus);

			String sendMail = request.getParameter("Chk_EMail");

			// Send eMail to the user, if email details are provided.
			if( saveStatus && sendMail != null) {
				sendMailStatus = sendMailBooking(request);
			}

			// Get roomId, selected date (TODO)
			int roomId = (Integer)session.getAttribute("roomId");
			int defaultDays = 10;
			
			// set booking status in request attribute
			request.setAttribute("new_booking_status", saveStatus);
			if( sendMail != null){
				request.setAttribute("send_mail_status", sendMailStatus);
			}

			// display the booking details
			displayBookings(roomId, new Date(), defaultDays, request, response);
			return;			
		}
		
		return;
	}


	/**
	 * Saves the new booking details into DB (using BookingManager object)
	 *
	 * @param request HttpServletRequest object
	 * @return Save status (true/false)
	 */
	private boolean saveNewBooking(HttpServletRequest request) {

		BookingManager bookingMgr = new BookingManager();

		HttpSession session = request.getSession();
		DateFormat sDf = new SimpleDateFormat("dd-MMM-yy");

		// booking hour and minutes
		String bh = ""+ new Date().getHours();
		String bm = ""+ new Date().getMinutes();

		// Build column values
		String userId 		= ""+ session.getAttribute("userId");
		int roomId 			= ((Integer)session.getAttribute("roomId")).intValue();
		String confName 	= request.getParameter("Txt_ConfName");
		String confDesc 	= request.getParameter("TxtArea_ConfDesc");
		Date bookingDate 	= new Date();
		String bookingTime 	= (bh.length()==1 ? "0"+bh : bh) + (bm.length()==1 ? "0"+bm : bm);
		String startTime 	= request.getParameter("Hid_ConfStartTime");
		String endTime 		= request.getParameter("Hid_ConfEndTime");
		String status		="ACTIVE";
		String noOfAttnStr  = request.getParameter("Txt_NumOfAttendees");
		int noOfAttn 		= noOfAttnStr.equals("")? 0 : Integer.parseInt(noOfAttnStr);
		String contactNum 	= request.getParameter("Txt_ContactNum");
		String eMail		= request.getParameter("Txt_Email");

		Date confDate		= null;
		try {confDate = sDf.parse(request.getParameter("Hid_ConfDate"));}
		catch (ParseException e) {e.printStackTrace();}

		Booking newBooking  = new Booking(0, userId, new Room(roomId), confName,
				confDesc, bookingDate, bookingTime, confDate, startTime, endTime, status,
				noOfAttn, contactNum, eMail);

		return bookingMgr.saveNewBooking(newBooking);
	}

	/**
	 * Checks if the user is already logged into system (revisit) and sets attributes accordingly
	 *
	 * @param request	HttpServletRequest object
	 * @param response 	HttpServletResponse object
	 */
	private void checkLoginUser( HttpServletRequest request, HttpServletResponse response) {

		// Read login cookies
		Cookie[] cookies = request.getCookies();
		String token 	= Util.getCookieValue(cookies, "ck_token");
		String userId 	= Util.getCookieValue(cookies, "ck_userId");
		
		logger.debug("cookies:  userId:" + userId+" token:" + token);

		if (userId != null && token != null){

			// Might be user's revisit
			boolean isRevisit = isUserRevisit(userId, token);
			
			logger.debug("isRevisit?" + isRevisit);

			if (isRevisit) {
				// Get full profile from DB and set in session attribute (to be used in new booking form)
				UserProfile userProfile = (new UserProfileManager()).getProfile(userId);

				// Set session attributes
				request.getSession().setAttribute("userId", userId);
				request.getSession().setAttribute("isLoggedIn", "true");
				request.getSession().setAttribute("userName", userProfile.getName());
				request.getSession().setAttribute("userProfile", userProfile);
			}
			else {
				// Remove attributes; if available (safe side)
				request.getSession().removeAttribute("isLoggedIn");
				request.getSession().removeAttribute("userId");
				request.getSession().removeAttribute("userName");
				request.getSession().removeAttribute("userProfile");
			}
		}
		else {
			// remove attributes; if available (safe side)
			request.getSession().removeAttribute("isLoggedIn");
			request.getSession().removeAttribute("userId");
			request.getSession().removeAttribute("userName");
			request.getSession().removeAttribute("userProfile");			
		}
	}

 	/**
	 *  Retrieves Booking details and displays in bookings.jsp view
	 *
	 * @param roomId
	 * @param fromDate
	 * @param days
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	private void displayBookings(int roomId, Date fromDate, int nDays, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		BookingManager bookingMgr = new BookingManager();
		RoomManager roomMgr = new RoomManager();

 		// get existing bookings TODO: Display error page, in DB failure cases
		List<Booking> bookingList = bookingMgr.getBookings(roomId, fromDate, nDays);

		// get room details from DB
		List<Room> roomList = roomMgr.getRooms(); // TODO: write seperate method in RoomManager to get only roomid, room name

		//List bookingList = getBookingsStub(roomId, fromDate, nDays);
		//List<Room> roomList = getRoomsStub();

		logger.debug("Number of bookings in bookingList: " + bookingList.size());
		logger.debug("Number of rooms in roomList: " + roomList.size());

		// set request attributes to use in jsp
		request.setAttribute("bookingList", bookingList);
		request.setAttribute("roomList", roomList);
		request.setAttribute("roomId", roomId);
		request.setAttribute("fromDate", fromDate);
		request.setAttribute("nDays", nDays);

		// set session attributes
		session.setAttribute("roomId", roomId);
		session.setAttribute("roomName", roomList.get(roomId-1).getName()); // TODO: Need to get room name properly; probably by sorting and comparing

		logger.debug("Displaying the bookings page");

		// display in bookings.jsp
		request.getRequestDispatcher("/WEB-INF/jsps/bookings.jsp").forward(request, response);
	}


	/**
	 * Retrieves the room details from DB
	 *
	 * @return		list of room objects in an array list
	 */

	private boolean sendMailBooking(HttpServletRequest request) {

		DateFormat sDf = new SimpleDateFormat("dd-MMM-yy");
		HttpSession session = request.getSession();

		// booking hour and minutes
		String bh = ""+ new Date().getHours();
		String bm = ""+ new Date().getMinutes();

		String bookingDate 	= sDf.format(new Date());
		String bookingTime 	= (bh.length()==1 ? "0"+bh : bh) + (bm.length()==1 ? "0"+bm : bm);

		String roomName		= session.getAttribute("roomName").toString();
		String confName 	= request.getParameter("Txt_ConfName");
		String confDesc 	= request.getParameter("TxtArea_ConfDesc");
		String confereceDate= request.getParameter("Hid_ConfDate");
		String startTime 	= request.getParameter("Hid_ConfStartTime");
		String endTime 		= request.getParameter("Hid_ConfEndTime");
		String noOfAttn 	= request.getParameter("Txt_NumOfAttendees");
		String eMail		= request.getParameter("Txt_Email");

		System.out.println("roomName retrieved--------------->" +roomName);
		String subject  = "Conference Room booked on " + confereceDate;
		String body 	= "Your booking details:\n\n " +
						  "\nConference Room: " + roomName +
						  "\nConference Date: " + confereceDate +
						  "\nTime: " + startTime + " to " + endTime+

						  "\nConference Name: " + confName +
						  "\nDescription: " + confDesc +
						  "\nNumber Of Attendees: " + noOfAttn;

		return new Mail().sendMail(eMail, subject, body);
	}

	/**
	 * Checks if the user is revisited after earlier login;
	 *
	 * @param userId
	 * @param token
	 * @return
	 */
	public boolean isUserRevisit(String userId, String token) {

		boolean isAuthentic = false;

		Statement stmt = null;

		// Get DB connection
		Connection conn = new DBManager().getConnection();
		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery("SELECT USER_ID FROM USER_PROFILE WHERE USER_ID='" + userId + "' AND TOKEN = '" + token + "'");

			isAuthentic = rset.next(); // If record exists, it means the user is authentic
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		finally{
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return isAuthentic;
	}

	/**
	 * Connects to Database with default credentials and returns the connection object
	 *
	 * TODO: Move this method to a common class
	 * @return connection object
	 */
	public  Connection getDBConnection() {

		System.out.println("Creating DB connection...");

		Connection conn = null;
		try {
			conn = (new DBManager()).getConnection();
			conn.setAutoCommit(true);
		}
		catch(SQLException ex) {
			while (ex != null) {
				System.out.println("-----SQLException-----");
				System.out.println("Message:   "+ ex.getMessage ());
				System.out.println("SQLState:  "+ ex.getSQLState ());
				System.out.println("ErrorCode: "+ ex.getErrorCode ());
				ex = ex.getNextException();
				System.out.println("");
			}
		}

		return conn;

		/*
		try{

			// Create a OracleDataSource instance and set URL  TODO: Get the database properties from database.properties file
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:CROOMBS/CROOMBS@10.197.144.183:1521:r3db");

			// Connect to the database
			Connection conn = ods.getConnection ();
			conn.setAutoCommit(true);

			return conn;
		}
		catch(SQLException ex) {
			while (ex != null) {
				System.out.println("-----SQLException-----");
				System.out.println("Message:   "+ ex.getMessage ());
				System.out.println("SQLState:  "+ ex.getSQLState ());
				System.out.println("ErrorCode: "+ ex.getErrorCode ());
				ex = ex.getNextException();
				System.out.println("");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;*/
	}
}
