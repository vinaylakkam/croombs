package com.croombs.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.croombs.beans.Room;
import com.croombs.beans.UserProfile;
import com.croombs.service.RoomManager;
import com.croombs.service.UserProfileManager;

/**
 * MyBookingsController is the servlet class to handle requests of the 'my bookings' related screens
 *
 * The functionalities provided by this class are:
 * <ul>
 * 	<li>get my profile</li>
 * 	<li>save my profile</li>
 * </ul>
 *
 */
public class MyProfileController extends HttpServlet
{

	Logger logger = Logger.getLogger(MyProfileController.class);


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

		// Get context
		String context = request.getParameter("Hid_Context");

		logger.debug("My profile:: Context:" + context);

		if(context == null) {

			String isLoggedIn = "" + request.getSession().getAttribute("isLoggedIn");
			String userId   = "" + request.getSession().getAttribute("userId");

			if (isLoggedIn.equals("true")) {
				displayMyProfile(userId,request, response);
			}
			else {
				// LOGIN first
				// This should never be a case, because the login box should be shown at client side before coming to this flow.
			}
		}

		else if(context.equals("save_personal") || context.equals("save_preferences") ||
				context.equals("save_login") )
		{
			// save details
			boolean savedStatus = saveMyProfile(context, request);

			// ajax response
			response.getWriter().print(savedStatus +"_" + context );
		}

	}


	/**
	 * Displays the my profile screen
	 *
	 * @param userId		User id of the user (Employee id)
	 * @param request		ServletRequest object
	 * @param response  	ServletResponse object
	 */
	void displayMyProfile(String userId, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		// Get profile details of the user
		UserProfile userProfile = new UserProfileManager().getProfile(userId);

		// get room details from DB
		List<Room> roomList = new RoomManager().getRooms();

		// set attributes to use in jsp
		request.setAttribute("userProfile", userProfile);
		request.setAttribute("roomList", roomList);

		logger.debug("Displaying the my profile page");

		// display in bookings.jsp
		request.getRequestDispatcher("/WEB-INF/jsps/my_profile.jsp").forward(request, response);

	}

	/**
	 * Retrieves the profile details and saves into DB (using UserProfileManager)
	 *
	 * @param context 	Save context such as 'save_login','save_personal', 'save_preferences'
	 * @param request 	HttpServletRequest object
	 * @return 			save status (true/false)
	 */
	private boolean saveMyProfile(String context, HttpServletRequest request){

		String userId		= request.getParameter("userId");
		String password 	= request.getParameter("password");
		String name 	  	= request.getParameter("name");
		String contactNum 	= request.getParameter("contactNum");
		String eMail	  	= request.getParameter("email");
		String defRoom		= request.getParameter("defRoom");
		String defNDays		= request.getParameter("defNDays");
		int prefRoomId 		= (defRoom==null)?0:Integer.parseInt(defRoom);
		int prefBookDays	= (defRoom==null)?0:Integer.parseInt(defNDays);

		// Build userProfile object
		UserProfile userProfile = new UserProfile(userId,password,"",name,contactNum,eMail,prefRoomId,prefBookDays); 

		// Save profile
		boolean saveStatus = new UserProfileManager().saveProfile(userProfile, context);

		return saveStatus;
	}

}