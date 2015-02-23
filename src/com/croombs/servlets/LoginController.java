package com.croombs.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import org.apache.log4j.Logger;

import com.croombs.Util;
import com.croombs.beans.UserProfile;
import com.croombs.service.DBManager;
import com.croombs.service.UserProfileManager;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;



public class LoginController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	Logger logger = Logger.getLogger(LoginController.class); 

	public LoginController() {
		super();
	}

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

		// Get context
		String context = request.getParameter("context");

		logger.debug("Login context:" +context);

		if(context.equals("login")) {

			String userId = request.getParameter("userId");
			
			// Login 
			boolean isLoginSuccess = logIn (request, response);
			
			// Send login status (ajax response)
			if (isLoginSuccess) {
				logger.debug("logged in successfully");
				
				// Get full profile from DB and set in session attribute (to be used in new booking form)
				UserProfile userProfile = (new UserProfileManager()).getProfile(userId);
				request.getSession().setAttribute("userProfile", userProfile); 

				// Build ajax response including user profile details
				StringBuilder loginAjaxResp = new StringBuilder("success___")
					.append("{userId:'").append(userProfile.getUserId()).append("', ")
					.append("name:'").append(userProfile.getName()).append("',")
					.append("profileType:'").append(userProfile.getProfileType()).append("',")
					.append("contactNum:'").append(userProfile.getContactNum()).append("',")
					.append("mail:'").append(userProfile.getMail()).append("',")
					.append("allowedBookHrs:'").append(userProfile.getAllowedBookHrs()).append("',")
					.append("prefRoomId:'").append(userProfile.getPrefRoomId()).append("',")
					.append("prefBookDays:'").append(userProfile.getPrefBookDays()).append("'}");

					
				// Set name of the user in session attribute
				request.getSession().setAttribute("userName", userProfile.getName());				
				
				// Send ajax response
				response.getWriter().print(loginAjaxResp);	
			}
			else {
				logger.debug("login failed");
				response.getWriter().print("failed");
			}
		}
		
		else if(context.equals("log_out")) {
			
			// Logout
			boolean logOutSuccess = logOut(request);

			// Send login status (ajax response)
			if (logOutSuccess) {
				logger.debug("logged out successfully");
				response.getWriter().print("success");	
			}
			else {
				logger.debug("log out failed");
				response.getWriter().print("failed");
			}
		}
	}


	/** 
	 * LogIn
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	private boolean logIn(HttpServletRequest request, HttpServletResponse response) {

		// Get login params
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		String rememberMe = request.getParameter("remember_me");

		logger.debug("login for user: " + userId);

		// Check if the user is authentic
		boolean isAuthentic = isAuthenticUser(userId, password);  
		
		if (isAuthentic) {

			// Authentic user
			logger.debug(userId + " is authenticated");
			
			// Set session attributes 
			request.getSession().setAttribute("isLoggedIn", "true");
			request.getSession().setAttribute("userId", userId);
			
			logger.debug("remember the user: " + userId+"?" + (rememberMe.equals("true")));
			
			// Remember the user
			if(rememberMe.equals("true")) {

				// Generate random token
				String token = Util.generateToken();

				// Save the token to UserProfile DB table
				boolean isRemembered = saveToken(userId, token);

				if(isRemembered) {
					// Add cookies to set in client PC
					Cookie cookieuserId = new Cookie("ck_userId", userId);
					Cookie cookieToken = new Cookie("ck_token", token);
					
					// These cookies are for ever (unless logged off)
					cookieuserId.setMaxAge(60*60*24*365);
					cookieToken.setMaxAge(60*60*24*365);

					response.addCookie(cookieuserId);
					response.addCookie(cookieToken);
					
					logger.debug("Cookies are set; Remembrance is SUCCESS");
				}
			}
		}
		return isAuthentic;
	}

	/**
	 * Logout
	 * 
	 * @param request
	 * @return
	 */
	private boolean logOut(HttpServletRequest request) {

		String userId = request.getParameter("userId");
		
		logger.debug("logout for user: " + userId);

		// set token in UserProfile table to empty 
		if (saveToken(userId, "")) {
			
			// remove isLoggedIn attribute on successful logout
			request.getSession().removeAttribute("isLoggedIn");
			request.getSession().removeAttribute("userId");
			request.getSession().removeAttribute("userName");
			request.getSession().removeAttribute("userProfile");
			return true;
		}
		return false;
	}

	/**
	 * Saves token of user in UserProfile table
	 * 
	 * @param userId
	 * @param token
	 * @return
	 */
	private boolean saveToken(String userId, String token) {

		Statement stmt = null;
		int updateRecords = 0; 

		// Get DB connection
		Connection conn = new DBManager().getConnection();

		StringBuffer strQuery = new StringBuffer("");
		strQuery.append("UPDATE USER_PROFILE SET")
		.append("TOKEN= '").append(token).append("' ")
		.append("WHERE USER_ID='").append(userId).append("'");

		logger.debug("DB Connection created. Query: "+ strQuery);
		logger.debug("Updating Token..");

		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			updateRecords = stmt.executeUpdate("UPDATE USER_PROFILE SET TOKEN ='" + token + "' WHERE USER_ID='" + userId + "'");
			
			logger.debug("updateRecords:" + updateRecords);
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

		logger.debug("Saved token ? " + (updateRecords != 0));
		return (updateRecords != 0);
	}

	/**
	 * Checks if the user is authentic
	 * 
	 * TODO: write in detail
	 * @param userId
	 * @param password
	 * @return
	 */
	private boolean isAuthenticUser(String userId, String password) {
		
		// Get DB connection
		Connection conn = new DBManager().getConnection();
		Statement stmt = null;
		
		boolean isAuthentic = false;
		
		try{
			// Run query to get booking details
			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery("SELECT NAME FROM USER_PROFILE WHERE USER_ID='" + userId +"'");

			boolean isUserAvailable = rset.next();
			
			logger.debug("isUserAvailable:"+isUserAvailable);
			
			if(isUserAvailable){

				// TODO: Passwords ignoring case
				// TODO: Get password from DB and compare.
				
				
				// If the user id is available on DB, check for authentication
				rset = stmt.executeQuery("SELECT USER_ID FROM USER_PROFILE WHERE USER_ID='" + userId + "' AND PASSWORD = '" + password + "'");
				isAuthentic = rset.next();
			} 
			else {
				/*
				// If the user id is not availabe on DB (first visit to this application)

				// insert user id with default password (userId and password is same by default)
				stmt.executeQuery("INSERT INTO USER_PROFILE(USER_ID, PASSWORD) VALUES('"+userId+"','"+userId+"')");
				
				logger.info(" NEW USER****** record inserted for " + userId);
				
				if (userId.equals(password)) {
					// In first visit, username and passwords are same.
					isAuthentic = true;
				}*/
			}
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
}
