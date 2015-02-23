package com.croombs.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.croombs.beans.Room;
import com.croombs.service.RoomManager;

/**
 * RoomController is the servlet class to handle requests of the 'Rooms' related screens
 *
 * The functionalities provided by this class are:
 * <ul>
 * 	<li> Display rooms</li>
 * </ul>
 *
 */
public class RoomController extends HttpServlet { 
	
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
		
		// Get the context
		String context =  (String) request.getParameter("Hid_Context");
		System.out.println("RoomController:Context: " +context);

		/* ROOMS PAGE */
		if(context.equals("rooms")) { 
			// Display all the rooms
			displayRooms(request, response);			
		}
	}

	/**
	 * Retries room details (using RoomManager) and displays in rooms.jsp

	 * @param request	HttpServletRequest object 
	 * @param response 	HttpServletResponse object
	 * @throws ServletException
	 * @throws IOException 
	 */
	private void displayRooms(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RoomManager roomMgr = new RoomManager();
		
		// get rooms TODO: Display error page, in DB failure cases
		List<Room> roomsList = roomMgr.getRooms();		

		// set attrributes to use in jsp
		request.setAttribute("roomList", roomsList);
		
		// display in bookings.jsp
		request.getRequestDispatcher("/WEB-INF/jsps/rooms.jsp").forward(request, response);	
		
	}
 
}
