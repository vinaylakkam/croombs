package com.croombs.servlets;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;

import java.io.*;
import java.text.DateFormat;
import java.util.*;
import java.util.Date;
import java.sql.*;



import com.croombs.beans.*;
import com.croombs.service.BookingManager;
import com.croombs.service.DBManager;

/**
 * MyBookingsController is the servlet class to handle requests of the 'my bookings' related screens
 *
 * The functionalities provided by this class are:
 * <ul>
 * 	<li>display my bookings</li>
 * 	<li>cancel my booking</li>
 * </ul>
 *
 */
public class MyBookingsController extends HttpServlet
{

	Logger logger = Logger.getLogger(MyBookingsController.class);

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
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

		// Get the context
		String context =  (String) request.getParameter("Hid_Context");
		System.out.println("MyBookingsController:Context: " +context); 
		
		if(context == null ||
				context.equals("my_curr_bookings") ||
				context.equals("my_prev_bookings")) {

			context = (context == null)? "my_curr_bookings":context;

			String isLoggedIn = "" + request.getSession().getAttribute("isLoggedIn");
			String userId   = "" + request.getSession().getAttribute("userId");

			request.setAttribute("context", context);

			if (isLoggedIn.equals("true")) {
				displayMyBookings(userId, context, request, response);
			}
			else {
				// LOGIN first
				// This should never be a case, because the login box should be shown at client side before coming to this flow.
			}
		}

		else if(context.equals("cancel_booking"))
		{
			int bookingId = Integer.parseInt(request.getParameter("booking_id"));
			String rowId = request.getParameter("row_id");

			logger.debug("Cancel booking: bookingId:" + bookingId +" rowId:" + rowId);

			//cancel the booking
			boolean cancelledStatus = new BookingManager().cancelBooking( bookingId);

			// ajax response
			response.getWriter().print(cancelledStatus +"_" + rowId + "_" + bookingId);
		}

	}

	/**
	 * Displays the my booking screen depending on the context (current or previous bookings)
	 *
	 * @param userId		User id of the user (Employee id)
	 * @param bookingsType	Bookings type: current or previous
	 * @param request		ServletRequest object
	 * @param response  	ServletResponse object
	 */
	void displayMyBookings(String userId, String bookingsType, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		// Get bookings of the user
		List<Booking> bookingList = (new BookingManager()).getMyBookings(userId, bookingsType);

		// set attribute to use in jsp
		request.setAttribute("bookingList", bookingList);

		// display in bookings.jsp
		request.getRequestDispatcher("/WEB-INF/jsps/my_bookings.jsp").forward(request, response);

	}


}