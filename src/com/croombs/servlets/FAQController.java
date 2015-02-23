package com.croombs.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

 

 
public class FAQController extends HttpServlet { 

	Logger logger = Logger.getLogger(FAQController.class);
	
 	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
 		doPost(request, response);
	}
 	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

 		logger.debug("FAQ page");
 		// display faq.jsp
		request.getRequestDispatcher("/WEB-INF/jsps/faq.jsp").forward(request, response);		
	} 	
 }
