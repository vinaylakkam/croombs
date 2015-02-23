<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, java.text.DateFormat, java.text.SimpleDateFormat, java.text.ParseException, com.croombs.beans.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<title>CRoomBS - Bookings</title>

		<style type="text/css">
			<%@ include file="/WEB-INF/css/main.css" %>
			<%@ include file="/WEB-INF/css/faq.css" %>
			<%@ include file="/WEB-INF/css/account_styles.css" %>
			<%@ include file="/WEB-INF/css/calendar.css" %>
		</style>
		<script type="text/javascript" language="Javascript">

			<%@ include file="/WEB-INF/js/common.js" %>
			<%@ include file="/WEB-INF/js/common_ajax_util.js" %>
			<%@ include file="/WEB-INF/js/login.js" %>
			<%@ include file="/WEB-INF/js/header.js" %>

			<%@ include file="/WEB-INF/js/common_floating_div.js" %>
			<%@ include file="/WEB-INF/js/common_calendar.js" %>
			<%@ include file="/WEB-INF/js/common_calendar-setup.js" %>
			<%@ include file="/WEB-INF/js/common_calendar-en.js" %>

			function initializePage(){
				commonInit();
				loginInit();
			}
		</script>
	</head>

	<body onload="javascript:initializePage()">


 		<!--  Common jsp data -->
 		<jsp:include page="common.jsp"/>

		<!--  Hidden login box -->
		<jsp:include page="login.jsp"/>

 		<!--  Header -->
		<jsp:include page="header.jsp">
			<jsp:param name="current_page" value="" />
		</jsp:include>

		<!--  Wrapper -->
		<div id="div_wrapper">
			<div id="div_container">
				<br/>
				<h3>Frequently Asked Questions</h3>
				<br/><br/>

					<p><b>Q: What is CRoomBS?</b></p>
					<p><b>A:</b> CRoomBS stands for Conference Room Booking System. It is a web application for booking conference rooms in TCS-AXA Velacherry office.</p>

				<div id="div_user">
					<h4>
						<a href="#" style="float:right">Top</a>
						User
					</h4>

					<p><b>Q: Who can book the conference rooms?</b></p>
					<p><b>A:</b> Only Group Leaders, Project Managers, Project Leaders are allowed to book the conference rooms. Each of these people has been given a user id to access the application for booking the room. Others can access it to view the booking details. </p>

					<p><b>Q: I am a GL/PM/PL. Am I allowed to book the conference room?</b></p>
					<p><b>A:</b> Yes, if you are listed as GL/PM/PL in the ‘AXA call tree drill’ spreadsheet and have been given a user id. </p>

					<p><b>Q: I am a GL/PM/PL. But I am not listed in ‘AXA call tree drill’ spread sheet. How can I access this application to book the room? </b></p>
					<p><b>A:</b> Please update the spreadsheet and send a mail to <a href="mailto:vinay.l@tcs.com">admin</a> specifying your project name and contact number. You will be given a user id after approval.</p>

					<p><b>Q: I am not a GL/PM/PL. But I arrange conferences in my project. How can I access this application to book the room?</b></p>
					<p><b>A:</b> Send a mail to <a href="mailto:vinay.l@tcs.com">admin</a> specifying your project, PL’s name and contact number. You will be given a user id after approval.</p>

					<p><b>Q: I have lost my password. How to get it back?</b></p>
					<p><b>A:</b> Send a mail to <a href="mailto:vinay.l@tcs.com">admin</a> specifying your user id and contact number. New password will be given to you after verification.</p>
				</div>
				<div id="div_booking">
					<h4>
						<a href="#" style="float:right">Top</a>
						Booking
					</h4>

					<p><b>Q: How to book the conference room?</b></p>
					<b>A:</b>
					<ul>
						<li>Goto Bookings page.</li>
						<li>Select the conference room from the dropdown menu.</li>
						<li>Select the time slots on the booking chart for a particular day.</li>
						<li>Click on BOOK button. If you are not logged in already, you will be asked to log into the system.</li>
						<li>Enter conference details in the booking form. Click Save.</li>
					</ul>
					<p>You will be notified with a confirmation message, if the booking is successful.</p>

					<p><b>Q: How to know if a particular slot is available to book?</b></p>
					<p><b>A:</b> The white cells on the booking chart are available to book. The red cells are the ones which have been already booked. To know the details of the booked conference room, move your mouse over to those cells.</p>

					<p><b>Q: How to select or unselect time slot cells on booking chart?</b></p>
					<p><b>A:</b> Click on the cells to highlight. You can click on a cell and drag mouse to left or right without releasing the mouse click, to select set of cells. Or you can click on individual cells to select one by one.
					Use right click to cancel your selection. </p>

					<p><b>Q: How can I book a conference for more than X hours?</b></p>
					<p><b>A:</b> Each user is allowed to book only X hours at a time. If you need to book a conference with more than X hours, please send a mail to <a href="mailto:vinay.l@tcs.com">admin</a></p>

					<p><b>Q: How to get the details of available conference rooms? </b></p>
					<p><b>A:</b> Select Rooms option on the main menu.</p>

				</div>
				<div id="div_my_account">
					<h4>
						<a href="#" style="float:right">Top</a>
						My account
					</h4>

					<p><b>Q: How to view all my active bookings?</b></p>
					<p><b>A:</b> Select My Account option on the main menu. The displayed My profile page lists all your active bookings. Click on booking id to know the full details of the conference.</p>

					<p><b>Q: How to view my previous bookings?</b></p>
					<p><b>A:</b> Select My Account option on the main menu. The displayed My profile page lists all your active bookings. Click on ‘Previous Bookings’ to see your previous bookings (cancelled or expired).  Click on booking id to know the full details of the conference.</p>

					<p><b>Q: How to cancel my conference booking?</b></p>
					<p><b>A:</b> Select My Account option on the main menu. The displayed My profile page lists all your active bookings. Select cancel button for the conference you want to cancel. </p>

					<p><b>Q: How to change my password?</b></p>
					<p><b>A:</b> Goto My Account > My Profile. Select edit option on the Login details bar. Enter new password and click Save.</p>

					<p><b>Q: how to change my personal details (Name, Contact Number or Email id)?</b></p>
					<p><b>A:</b> Goto My Account > My Profile. Select edit option on the Personal details bar. Modify the details and click Save.</p>
				</div>
				<div id="div_my_account">
					<h4>
						<a href="#" style="float:right">Top</a>
						Other
					</h4>

					<p><b>Q: I have a comment/suggestion/query regarding this application. How to let you know?</b></p>
					<p><b>A:</b> Send a mail to <a href="mailto:vinay.l@tcs.com">admin</a>.</p>
				</div>


			</div>
		</div>

		<!--  Footer -->
		<jsp:include page="footer.jsp"/>
	</body>

</html>