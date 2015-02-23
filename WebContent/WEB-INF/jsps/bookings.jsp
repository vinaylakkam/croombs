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
			<%@ include file="/WEB-INF/css/bookings.css" %>
			<%@ include file="/WEB-INF/css/account_styles.css" %>
			<%@ include file="/WEB-INF/css/calendar.css" %>
		</style>
		<script type="text/javascript" language="Javascript">
			<%@ include file="/WEB-INF/js/bookings.js" %>
			<%@ include file="/WEB-INF/js/bookings_chart.js" %>

			<%@ include file="/WEB-INF/js/common.js" %>
			<%@ include file="/WEB-INF/js/common_ajax_util.js" %>
			<%@ include file="/WEB-INF/js/login.js" %>
			<%@ include file="/WEB-INF/js/header.js" %>

			<%@ include file="/WEB-INF/js/common_floating_div.js" %>
			<%@ include file="/WEB-INF/js/common_calendar.js" %>
			<%@ include file="/WEB-INF/js/common_calendar-setup.js" %>
			<%@ include file="/WEB-INF/js/common_calendar-en.js" %>
		</script>
	</head>

	<body onload="javascript:initializePage()">


 		<!--  Common jsp data -->
 		<jsp:include page="common.jsp"/>

		<!--  Hidden login box -->
		<jsp:include page="login.jsp"/>

 		<!--  Header -->
		<jsp:include page="header.jsp">
			<jsp:param name="current_page" value="bookings" />
		</jsp:include>

		<!--  Account Header -->
  		<!-- div id="AccountHeader">
			<h1>Booking Views</h1>
			<ul class="ac_tabs inline">
				<li class="first"><a class="current" href="#">Chart</a></li>
			</ul>

		</div-->

		<!--  Wrapper -->
		<div id="div_wrapper">

			<!-- div id="div_book" style="position:fixed;top:270px;left:10px">
				<img src="images/bookie.gif" onclick="javascript:newBooking()" alt="Goto Home page" />
			</div-->
			
			<div id="div_container">

				<%
					// Get request attributes roomId, number of days (nDays)
					int roomId = ((Integer)request.getAttribute("roomId")).intValue();
					int nDays = ((Integer)request.getAttribute("nDays")).intValue();

					DateFormat df = new SimpleDateFormat("MM/dd/yyyy"); // to use in js; js doesn't support dd-MMM-yy
					DateFormat sDf = new SimpleDateFormat("dd-MMM-yy"); // server/DB format

					String todayDate = df.format(new Date());
					String selectedDate = (String)session.getAttribute("selectedDate");

					if (selectedDate == null) {
						// todays date in MM/dd/yyyy
						selectedDate = todayDate;
					}
					else {
						// to MM/dd/yyyy
						selectedDate = df.format(sDf.parse(selectedDate));
					}

				%>

				<c:if test="${(new_booking_status ne null) or (home_page eq true)}">
					<div id="div_notification" >
						<a href="#" onclick="javascript:hideNotification('login')" style="float:right">Close</a>
						 <c:if test="${home_page eq true}"> To book the conference room, select conference date and time cells in the below chart and click 'Book' button</c:if>
						<c:if test="${new_booking_status eq true}">
							<span style="color:green;font-weight:bold">Your conference room booking is confirmed. 
								<c:if test="${send_mail_status eq true}"> The booking details are sent to your mail id.</c:if> 
							</span>
						</c:if>
						<c:if test="${new_booking_status eq false}"><span style="color:red">Sorry. Your conference room booking is failed. Please try again. </span></c:if> 
					</div>
				</c:if>


				<!--  Data Variables (to use in JS) -->
				<data id="nDays" value="<%=nDays%>"/>
				<data id="roomId" value="<%=roomId%>"/>
				<data id="todayDate" value="<%=todayDate%>"/>

				<!-- div style="display:none">
					<a href="#" onclick="javascript:deleteLoginCookies()">delete login cookies</a>
					<a href="#" onclick="javascript:showLoginCookies()">show login cookies</a><br/>
				</div-->

				<!--  BOOKING FORM -->
				<form name="Form_Bookings_Nav" id="Form_Bookings" action="" method="post">
					<div>
						<table style="width:100%; "> 
							<tr>
								<!--td align="left" width="33%">
									<input type="button" value="BOOK" onclick="javascript:newBooking()"/>
								</td-->
								<td align="left" width="33%">
									<!--  ROOMS Option box -->
									<select name="Opt_Rooms" id="Opt_Rooms" style="float:left" onchange="javascript:getBookings('get_curr_bookings')">
										<c:forEach var="room" items="${roomList}">
											<option value="${room.roomId}">${room.name}</option>
										</c:forEach>
									</select>
								</td>
								<td align="center" width="33%">
									<div id="div_booking_banner" style="float:center" >
										<!--  Booking banner details will be added dynamically when the booking selection is made -->
									</div>
								</td>								
								<td align="right" width="33%">
									<img src="images/bookie.gif" style="cursor:hand;" onclick="javascript:newBooking()" alt="Click here to book your selection" />
								</td>
							</tr>
						</table>
					</div>



					<!--  Navigation links (Prev, Current and Next) for BOOKING CHART-->
					<input type="hidden" name="Hid_NDays" value="<%=nDays%>"/>
					<input type="hidden" name="Hid_Context" value=""/>
					<input type="hidden" name="Hid_CurrSelectedDate" value="<%=selectedDate%>"/>

					<table class="chart_nav">
						<thead/>
						<tbody>
							<tr>
								<td align="left"><a style="color:#8b88e5" href="javascript:getBookings('get_prev_bookings')" title="See bookings chart for Previous <%=nDays%> days"><b>&lt; Prev</b></a></td>
								<td align="center">
									<input type="text" name="date" id="Inp_SelectedDate" value="<%=selectedDate%>" style="display:none" />
									<img src="images/calendar.gif" id="f_trigger_b"
										 style="width=100px;cursor: pointer; border: 1px solid red;"
										 title="Date selector" onmouseover="this.style.background='red';"
										 onmouseout="this.style.background=''" />
									<%--input type="button" value="Go" onclick="javascript:getBookings('get_bookings_by_date')"/--%>
								</td>

								<%--<td align="center"><a style="color:#8b88e5" href="javascript:getBookings('get_curr_bookings')" title="See bookings chart for Current <%=nDays%>  days">Current</a></td> --%>

								<td align="right"><a style="color:#8b88e5" href="javascript:getBookings('get_next_bookings')" title="See bookings chart for Next <%=nDays%>  days"><b>Next &gt;</b></a></td>
							</tr>
						</tbody>
					</table>


			 		<!--  BOOKINGS CHART-->
			 		<div id="div_chart">
						<jsp:include page="bookings_chart.jsp"/>
					</div>
				</form>

				<!--  NEW BOOKING DETAILS Form-->
				<div id="div_new_booking" style="display:none">
					<form name="Form_BookingDtls" id="Form_BookingDtls" action="" method="post">

						<!--  Hidden Variables (to use in JS) -->
						<input type="hidden" name="Hid_ConfDate"/>
						<input type="hidden" name="Hid_ConfStartTime"/>
						<input type="hidden" name="Hid_ConfEndTime"/>
						<input type="hidden" name="Hid_Context" value="new_booking"/>

						<table >
 							<tbody>
 								<tr><td id="Info_Txt_ConfName" colspan="2"></td></tr>
								<tr>
									<td><label id="Lbl_Txt_ConfName" for="Txt_ConfName">Conference Name <span style="color:red">*</span></label></td>
									<td><input type="text" id="Txt_ConfName" name="Txt_ConfName" maxlength="30" size="30" title="Conference Name"/></td>
								</tr>
								<tr><td id="Info_TxtArea_ConfDesc" colspan="2"></td></tr>
								<tr>
									<td><label id="Lbl_TxtArea_ConfDesc" for="TxtArea_ConfDesc">Description <br/>(max:50 char)</label></td>
									<td><textarea rows="3" name="TxtArea_ConfDesc" maxlength="10" cols="30"></textarea></td>
								</tr>
								<tr><td id="Info_Txt_NumOfAttendees" colspan="2"></td></tr>
								<tr>
									<td><label id="Lbl_Txt_NumOfAttendees" for="Txt_NumOfAttendees">Number Of Attendees</label></td>
									<td><input type="text" name="Txt_NumOfAttendees" maxlength="3"/></td>
								</tr>
								<tr><td id="Info_Txt_ContactNum" colspan="2"></td></tr>
								<tr>
									<td><label id="Lbl_Txt_ContactNum" for="Txt_ContactNum">Contact Number <span style="color:red">*</span><br/>(mobile only)</label></td>
									<td><input type="text" name="Txt_ContactNum" maxlength="15" size="20"/></td>
								</tr>
								<tr><td id="Info_Txt_Email" colspan="2"></td></tr>
								<tr>
									<td><label id="Lbl_Txt_Email" for="Txt_Email">E-mail</label></td>
									<td>
										<input type="text" name="Txt_Email" maxlength="50"/>
										<input type="checkbox" name="Chk_EMail"/>e-mail this booking details to me
									</td>
								</tr>

								<tr>
									<td/>
									<td><input type="button" onclick="submitNewBooking()" value=" Confirm"/> or <a href="#" onclick="javascript:hideNewBookingDtlsForm()">Cancel</a></td>
								</tr>
							</tbody>
						</table>

					</form>
				</div>

 				<!--  BOOKING DETAILS CALL OUT (BUBBLE) -->
				<!-- div id="div_confDtls_callout" style="display:none">
					<table>
							<caption> Details:</caption>
							<tbody>
								<tr class="heading">
									<td>Conference</td>
									<td id="call_td_conf_name"/>
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
				</div-->
				
 				<!--  BOOKING DETAILS CALL OUT (BUBBLE) -->
				<div id="div_confDtls_callout" style="display:none">

					<dl>
						<!-- li class="details">Details</li-->
						
						<dt >Conference:</dt>
						<dd id="call_conf_name"/>
						<dd id="call_conf_time"/>
						<dd id="call_no_of_atten"/>
						<dd>&nbsp;</dd>

						<dt >Booked By:</dt>
						<dd id="call_name"/>
						<dd id="call_user_id"/>
						<dd id="call_contact"/>
					</dl>
				</div>
			</div>
		</div>

		<!--  Footer -->
		<jsp:include page="footer.jsp"/>
	</body>

</html>