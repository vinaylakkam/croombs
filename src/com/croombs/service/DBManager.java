package com.croombs.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.croombs.servlets.MyBookingsController;

public class DBManager {

	Logger logger = Logger.getLogger(MyBookingsController.class);

	//Static class instantiation
	static {
		try{
			
			new com.croombs.pool.JDCConnectionDriver(
					"sun.jdbc.odbc.JdbcOdbcDriver", 
					"JDBC:ODBC:croombs",
					"croombs", "croombs"); //TODO: Get from properties file
			
//			new com.croombs.pool.JDCConnectionDriver(
//					"oracle.jdbc.driver.OracleDriver", 
//					"jdbc:oracle:thin:@10.197.144.183:1521:r3db",
//					"CROOMBS", "CROOMBS"); //TODO: Get from properties file
		}catch(Exception e){}
	}

	public Connection getConnection(){

		//logger.debug("Creating DB Connection ...");

		Connection conn = null;
		try {
			conn = DriverManager.getConnection("jdbc:jdc:jdcpool");
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

		//logger.debug("created.");
		return conn;
	}

}
