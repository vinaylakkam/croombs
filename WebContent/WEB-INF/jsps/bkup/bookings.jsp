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
			<%@ include file="/WEB-INF/css/account_styles.css" %>
		</style>
		<script type="text/javascript" language="Javascript">
			<%@ include file="/WEB-INF/js/bookings.js" %>
		</script>
	</head>
	
	<body onload="javascript:initializePage()">

 		<!--  Header -->
		<jsp:include page="header.jsp"/>

		<!--  Account Header -->
  		<div id="AccountHeader">
			<h1 class="first">Booking Views</h1>
			<ul class="ac_tabs inline">
				<li class="first"><a class="current" href="#">Chart</a></li>
				<li><a class="previous" href="#">Normal</a></li>
			</ul>
		</div>	
				
		<!--  Wrapper -->
		<div id="div_wrapper">
			<div id="div_container">
			
				<%
					// Get request attributes roomId, number of days (nDays)and page number(pageNum)
					int roomId = ((Integer)request.getAttribute("roomId")).intValue();
					int nDays = ((Integer)request.getAttribute("nDays")).intValue();
					int pageNum = ((Integer)request.getAttribute("pageNum")).intValue();
				%>
				
				<!--  Data Variables (to use in JS) -->
				<data id="nDays" value="<%=nDays%>"/>
				<data id="roomId" value="<%=roomId%>"/>

				<!--  BOOKING FORM -->
				<form name="Form_Bookings" id="Form_Bookings" action="" method="post">
				
					<!--  ROOMS Option box -->
					<select name="Opt_Rooms" id="Opt_Rooms" onchange="javascript:getBookings('get_curr_bookings',0)">
						<option value="1">Zone1 Conf Room</option>
						<option value="2">Zone2 Conf Room</option>
					</select>
					
					<!--  BOOK button -->
					<input type="button" value="Book" onclick="javascript:displayNewBookingDtlsForm()"/>

					<!--  Navigation links (Prev, Current and Next) for BOOKING CHART-->
					<input type="hidden" name="Hid_PageNum" value=""/>
					<input type="hidden" name="Hid_NDays" value="<%=nDays%>"/>
					<input type="hidden" name="Hid_Context" value=""/>
					<table class="chart_nav">
						<thead/>
						<tbody>
							<tr>
								<td align="left"><a style="color:#8b88e5" href="javascript:getBookings('get_prev_bookings',<%=pageNum-1%>)" title="See bookings chart for Previous <%=nDays%> days">&lt; Prev</a></td> 
								<td align="center"><a style="color:#8b88e5" href="javascript:getBookings('get_curr_bookings',0)" title="See bookings chart for Current <%=nDays%>  days">Current</a></td>
								<td align="right"><a style="color:#8b88e5" href="javascript:getBookings('get_next_bookings',<%=pageNum+1%>)" title="See bookings chart for Next <%=nDays%>  days">Next &gt;</a></td> 
							</tr>
						</tbody>						
					</table>
				</form>				

		 		<!--  BOOKINGS CHART-->
		 		<div id="div_chart">
					<jsp:include page="bookings_chart.jsp"/>
				</div>
				
				<!--  NEW BOOKING DETAILS Form-->
				<form name="Form_BookingDtls" id="Form_BookingDtls" action="" method="post">
					
					<!--  Hidden Variables (to use in JS) -->
					<input type="hidden" name="Hid_ConfDate_Days"/>
					<input type="hidden" name="Hid_ConfStartTime"/>
					<input type="hidden" name="Hid_ConfEndTime"/>
					<input type="hidden" name="Hid_Context" value="new_booking"/>

					<div id="div_new_booking" style="display:none; background:#E5E4E2; width:500px; ">
						<table align="center">
							<caption>Please enter conference details and click 'Confirm':</caption>
							<tbody>
								<tr>
									<td>Conference Name <span style="color:red">*</span></td>
									<td><input type="text" name="Txt_ConfName"/></td>
								</tr>
								<tr>
									<td>Description</td>
									<td><textarea rows="3" name="TxtArea_ConfDesc" maxlength="2" cols="30"></textarea></td>
								</tr>
								<tr>
									<td>Number Of Attendees</td>
									<td><input type="text" name="Txt_NumOfAttendees"/></td>
								</tr>
								<tr>
									<td>Contact Number</td>
									<td><input type="textarea" name="Txt_ContactNum"/></td>
								</tr>
								<tr>
									<td>E=mail</td>
									<td>
										<input type="text" name="Txt_Email"/>
										<input type="checkbox" name="Chk_EMail"/>e-mail booking details
									</td>
								</tr>							
								<tr>
									<td><input type="button" value="Cancel" onclick="javascript:hideNewBookingDtlsForm()"/></td>
									<td><input type="submit" value=" Confirm"/></td>
								</tr>							
							</tbody>
						</table>																					
					</div>
				</form>
				
				<!--  BOOKING DETAILS CALL OUT (BUBBLE) -->
				<div id="div_confDtls_callout" style="background-image:url(); 
					filter:alpha(opacity=100); display:none; width:200px; height:300px ;">
					<table border="1">
							<caption>Details:</caption>
							<tbody>
								<tr>
									<td>Conference</td>
									<td id="call_td_conf_name"/>
								</tr>
								<tr>
									<td>Description</td>
									<td id="call_td_conf_desc"/>
								</tr>
								<tr>
									<td>Attendees</td>
									<td id="call_td_no_of_atten"/>
								</tr>
								<tr>
									<td>Booked by</td>
									<td id="call_td_booked_by"/>
								</tr>								
								<tr>
									<td>Contact</td>
									<td id="call_td_contact"/>
								</tr>
							</tbody>					
					</table>						
				</div>
				
			</div>
		</div>
		
		<!--  Footer -->
		<jsp:include page="footer.jsp"/>
	</body>
	
</html>