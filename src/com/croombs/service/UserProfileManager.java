package com.croombs.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import com.croombs.beans.UserProfile;

public class UserProfileManager {


	Logger logger = Logger.getLogger(UserProfileManager.class);
	
	/** 
	 * Retrieves the profile details of the user
	 * 
	 * @param userId		User id of the user (Employee id) 
	 * @return				UserProfile object
	 */
	public UserProfile getProfile(String userId)
	{
		UserProfile user = null;
		Statement stmt = null;

 		// Get DB connection
		Connection conn = new DBManager().getConnection(); 

		// SQL Query 
		StringBuffer strQuery = new StringBuffer("");
		strQuery.append("SELECT")
				.append("	PROFILE_TYPE, NAME, CONTACT_NUMBER, EMAIL, BOOK_HRS, PREF_BOOK_DAYS, PREF_ROOM_ID ")
				.append("FROM USER_PROFILE ")
				.append("WHERE ")
				.append("	USER_ID='").append(userId).append("'");
		
		System.out.println("Query: "+ strQuery);


		try {
			// Run query to get booking details
			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(new String(strQuery));

			// For each booking entry, create
			while (rset.next()) {

				// Get data from the result set
				String profileType  = rset.getString("PROFILE_TYPE");
				String name 		= rset.getString("NAME");
 				String contactNum 	= rset.getString("CONTACT_NUMBER");
				String eMail		= rset.getString("EMAIL");
				int allowedBookHrs	= rset.getInt("BOOK_HRS");
				int prefBookDays	= rset.getInt("PREF_BOOK_DAYS");
				int prefRoomId		= rset.getInt("PREF_ROOM_ID");
				
				// Create User object
				user = new UserProfile(userId, profileType, name,
						contactNum, eMail, allowedBookHrs, prefRoomId, prefBookDays); 

			}

			System.out.println(userId + " User retrieved.");
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
		return user;		
	}
	
	
	/**
	 * Updates profile details in DB
	 * 
	 * @param userProfile 	UserProfile object
	 * @param context 		Context such as 'save_login','save_personal', 'save_preferences'
	 * @return				save status (true/false)
	 */
	public boolean saveProfile(UserProfile userProfile, String context){
		
		Statement stmt = null;
		int savedRecords = 0; 

		// Get DB connection
		Connection conn = new DBManager().getConnection();

		StringBuffer strQuery = new StringBuffer("");

		String userId	  = userProfile.getUserId();

		if(context.equals("save_login")){
			
			String password = userProfile.getPassword();
 			strQuery.append("UPDATE USER_PROFILE SET ")
					.append("PASSWORD='").append(password).append("' ")
					.append("WHERE USER_ID='").append(userId).append("' ");
		}
		
		if(context.equals("save_personal")){
			
			String name 	  = userProfile.getName();
			String contactNum = userProfile.getContactNum();
			String eMail	  = userProfile.getMail();
			
			strQuery.append("UPDATE USER_PROFILE SET ")
					.append("NAME='").append(name).append("', ")
					.append("CONTACT_NUMBER='").append(contactNum).append("', ")
					.append("EMAIL='").append(eMail).append("' ")
					.append("WHERE USER_ID='").append(userId).append("' ");
			
		}
		
		if(context.equals("save_preferences")){
			
			int defRoom  = userProfile.getPrefRoomId();
			int defNDays	= userProfile.getPrefBookDays();
			
			strQuery.append("UPDATE USER_PROFILE SET ")
					.append("PREF_ROOM_ID=").append(defRoom).append(", ")
					.append("PREF_BOOK_DAYS=").append(defNDays).append(" ")
					.append("WHERE USER_ID='").append(userId).append("' ");
		}
		
		logger.debug("DB Connection created. Context: "+ context + " Query: "+ strQuery);
		logger.debug("Saving User profile details in DB..");

		try {
			// Run query to svae profile details
			stmt = conn.createStatement();
			savedRecords = stmt.executeUpdate(new String(strQuery));
			
			logger.debug("savedRecords:" + savedRecords);
		} 
		catch(Exception e){
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
		
		logger.debug("Profile updated ? " + (savedRecords != 0));
		return (savedRecords != 0);
	}


	/**
	 * Gets the name of user id
	 * 
	 * @param userId	User ID 
	 * @return			User name
	 */
	public String getUserName(String userId) {

		String userName = "";

		// Get DB connection
		Connection conn = new DBManager().getConnection();
		Statement stmt = null;
		
		try {
			logger.debug("Getting User name of user:.." + userId);
			
			// Run query to get booking details
			stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery("SELECT NAME FROM USER_PROFILE WHERE USER_ID= '"+ userId +"'");
			rset.next();
			
			userName = rset.getString("NAME");
			
			logger.debug("Query: SELECT NAME FROM USER_PROFILE WHERE USER_ID= '"+ userId +"'");
			
			logger.debug("UserName:" + userName);
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

		// return userName
		return userName;	
	}	
}
