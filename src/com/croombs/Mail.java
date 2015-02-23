/**
 * 
 */
package com.croombs;

import lotus.domino.Database;
import lotus.domino.DbDirectory;
import lotus.domino.Document;
import lotus.domino.NotesException;
import lotus.domino.NotesFactory;
import lotus.domino.NotesThread;
import lotus.domino.Registration;
import lotus.domino.Session;

public class Mail {

	public boolean sendMail(String targetMailId, String subject, String body) {
		
		boolean sendMailStatus = false;
		Database db = getMailDatabase();
		try {
			sendMailStatus = send(db.createDocument(), targetMailId, subject, body);
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return sendMailStatus;
	}
	
	private Database getMailDatabase() {
		Database db = null;

		try{
			NotesThread.sinitThread();
			Session session = NotesFactory.createSession();
			String mailPswd = "Password1";
			
			Registration reg = session.createRegistration();
			reg.switchToID("C:\\Documents and Settings\\144037\\Local Settings\\Application Data\\Lotus\\Notes\\Data\\144037.id", mailPswd);

			DbDirectory dir = session.getDbDirectory("InchnM05");
			db = dir.openMailDatabase();
		}
		
		catch (Exception e){ 
			e.printStackTrace();	    	
		}
		return db;
	}

	private boolean send(Document doc, String to, String subject, String msg)throws NotesException {
		doc.appendItemValue("Form", "Memo");
		doc.appendItemValue("Subject", subject);
		doc.appendItemValue("Body", msg);
		doc.send(to);
		System.out.println("Mail Sent Successfully !!");
		
		return true;
	}
	public static void main(String[] args) {

		Mail sm = new Mail();

		try{
			NotesThread.sinitThread();
			Session session = NotesFactory.createSession();
			
			System.out.println("session created");

			Registration reg = session.createRegistration();
			System.out.println("reg created");
			reg.switchToID("C:\\Documents and Settings\\144037\\Local Settings\\Application Data\\Lotus\\Notes\\Data\\144037.id", "Password;077");

			
			//DbDirectory dir = session.getDbDirectory("InchnM05"); 
			//Database db = dir.openDatabase("Mail\\mailindb\\VelacherryAXACRoomBS.nsf");
			
			Database db = session.getDatabase("InchnM05", "Mail\\mailindb\\VelacherryAXACRoomBS.nsf", true);
			
			//Database db = dir.openMailDatabase();
			sm.send(db.createDocument(), "vinay.l@tcs.com", "Hi, It's Me...", "Test Mail");

		} catch (Exception e){
			e.printStackTrace();	    	
		}


	}
}


