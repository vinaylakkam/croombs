<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@page import="java.util.*, java.text.DateFormat" %>
<%@page import="com.croombs.Constants, com.croombs.beans.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<title>CRoomBS - My Bookings</title>
		
		<style type="text/css">
			<%@ include file="/WEB-INF/css/main.css" %>
			<%@ include file="/WEB-INF/css/account_styles.css" %>
			<%@ include file="/WEB-INF/css/my_account.css" %>
		</style>
		<script type="text/javascript" language="Javascript">
			<%@ include file="/WEB-INF/js/my_bookings.js" %>
			
			<%@ include file="/WEB-INF/js/common.js" %>
			<%@ include file="/WEB-INF/js/common_ajax_util.js" %>
			<%@ include file="/WEB-INF/js/login.js" %>
			<%@ include file="/WEB-INF/js/header.js" %>				
		</script>
	</head>
	
	<body onload="javascript:initializePage()">

 		<!--  Common jsp data -->
 		<jsp:include page="common.jsp"/>

		<!--  Hidden login box -->
		<jsp:include page="login.jsp"/>
 		
 		<!--  Header -->
		<jsp:include page="header.jsp">
			<jsp:param name="current_page" value="my_account" />
		</jsp:include>

		<!--  Account Header -->
  		<div id="AccountHeader" >
			<h1 class="first">My Account Options</h1>
			<ul class="ac_tabs">
				<li class="first"><a class="current" href="#" onclick="return;">My Bookings</a></li>
				<li><a class="previous" href="MyProfile" onclick="javascript:submitForm('my_profile')">My Profile</a></li>
			</ul>		
		</div>	
  
		<!--  Wrapper -->
		<div id="div_wrapper">
			
			<div id="div_container">
				<%-- Form --%>
				<form name="Form_MyAccount" id="Form_MyAccount" action="" method="post">
					<input type="hidden" name="Hid_Context" value=""/>
				</form>
				
				<%
					int totalBookings = ((List)request.getAttribute("bookingList")).size();
					DateFormat longDf = DateFormat.getDateInstance(DateFormat.LONG);
				%>
				<p style="margin-top:20px"> 
					<c:if test="${context eq 'my_curr_bookings'}">
						See <a href="#" onclick="javascript:submitForm('my_prev_bookings')"> Previous Bookings</a>.
					</c:if>
					<c:if test="${context eq 'my_prev_bookings'}">
						See <a href="#" onclick="javascript:submitForm('my_curr_bookings')"> Active Bookings</a>.
					</c:if>					
				</p>
				
				<span style="margin-top:30px">
					<c:if test="${context eq 'my_curr_bookings'}">
						<strong><%=totalBookings %> Active bookings found.</strong>
					</c:if>
					<c:if test="${context eq 'my_prev_bookings'}">					
						<strong><%=totalBookings %> Previous bookings found.</strong>
					</c:if>
					<%if (totalBookings > 0){  %>(click on 'booking id' to see the details).<%} %>
				</span>
	 		
				<data id="totalBookings" value="<%=totalBookings %>"/>
 				
 				<%if (totalBookings > 0){  %>
					<table width="70%" style="margin-top:20px">
						<thead>
							<tr style="background-color:#5c99c7">
								<th width="10%"><b>Booking ID</b></th>
								<th width="26%"><b>Room</b></th>
								<th width="15%"><b>Date</b></th>
								<th width="10%"><b>From</b></th>
								<th width="10%"><b>To</b></th>
								<c:if test="${context eq 'my_prev_bookings'}">
									<th width="15%"><b>Status</b></th>
								</c:if>
								<c:if test="${context eq 'my_curr_bookings'}">
									<th width="17%" style="background-color:#ffffff">&nbsp;</th>
								</c:if>
	 						</tr>
						</thead>
						<tbody>
							<c:forEach var="booking" items="${bookingList}"  varStatus="itr" >
								<tr style="border: solid #0000FF">
									<td>
										<a href="javascript:displayBookingDtls(${itr.count})"> ${booking.bookingId}</a>
									</td>
									<td>${booking.room.name}</td> 
									<td>${booking.confDate} </td>
									<td>${booking.startTime}</td>
									<td>${booking.endTime}</td>
									<c:if test="${context eq 'my_prev_bookings'}">
										<td>
											<c:if test="${booking.status ne 'CANCELLED'}">EXPIRED</c:if>
											<c:if test="${booking.status eq 'CANCELLED'}">CANCELLED</c:if>
										</td>
									</c:if>
									<c:if test="${context eq 'my_curr_bookings'}">
										<td id="td_cancel_booking_${itr.count}">
											<input type="button" onclick="cancelBooking(${itr.count});" value="cancel"/>
											<div style="display:none;" id="div_cancel_booking_${itr.count}">Sure?
												<input type="radio" name="Rad_YesNo" value="yes" onclick="confirmCancel(this, ${booking.bookingId}, ${itr.count})"/>Yes
												<input type="radio" name="Rad_YesNo" value="no" onclick="noCancel(this, ${itr.count});"/>No
											</div>									
										</td>
									</c:if>
								</tr>
								
								<tr style="display:none" id="tr_booking_dtls_${itr.count}">
									<td>&nbsp;</td>
									<td colspan="5">
										<table id="tab_booking_dtls" border="0" >
											<tr>
												<th style="width:40%"/>
												<th style="width:60%"/>
											</tr>
											<tr>
												<th>Conference Name:</th>
												<td>${booking.confName}</td>
											</tr>
											<tr>
												<th>Conference Description:</th>
												<td>${booking.confDesc}</td>
											</tr>
											<tr>
												<th>Booking Date:</th>
												<td>${booking.boookingDate}</td>
											</tr>
											<tr>
												<th>Number Of Attendees:</th>
												<td>${booking.noOfAttn}</td>
											</tr>
											<tr>
												<th>Contact Number:</th>
												<td>${booking.contactNum}</td>
											</tr>
										</table>
									</td> 
								</tr>   
							</c:forEach>
						</tbody>
					</table>
				<%}%>
				
			</div>
		</div>
	 
		<!--  Footer -->
		<jsp:include page="footer.jsp"/>
	</body>
	
</html>