package com.croombs;

import java.util.Random;

import javax.servlet.http.Cookie;

public class Util {
	
	public static String getCookieValue(Cookie[] cookies, String cookieName) {
		
		if (cookies == null) return null; 
		
		for(int i=0; i<cookies.length; i++) {
			Cookie cookie = cookies[i];
			if (cookieName.equals(cookie.getName()))
				return(cookie.getValue());
		}
		return null;
	}
	
	public static String generateToken() {

		Random rand = new Random();
		return ""+ rand.nextInt(999999999);

	}
}
