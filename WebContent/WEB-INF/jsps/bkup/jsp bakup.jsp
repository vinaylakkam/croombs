<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.util.*, java.text.DateFormat, com.croombs.beans.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="com.croombs.Constants"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<title>CRoomBS - Bookings</title>
		
		<!-- link href="styles.css" rel="stylesheet" type="text/css"/-->
		<style type="text/css">
			<%@ include file="/WEB-INF/css/main.css" %>
		</style>
		<script type="text/javascript" language="Javascript">
			<%@ include file="/WEB-INF/js/bookings.js" %>
		</script>
	</head>
	<body>
 		<!--  Header -->
		<jsp:include page="header.jsp">
			<jsp:param value="currentPage" name="bookings"/>
		</jsp:include>
		
		<!--  Wrapper -->
		<div id="div_wrapper">
			<div id="div_container">
			
				<%
				// Get number of Days (nDays)
				int nDays = Integer.parseInt((String)request.getAttribute("nDays"));
	
				// Get bookingList
				List bookingList = (List) request.getAttribute("bookingList");

				// booking MATRIX
				int bookingXX[][] =  new int[nDays][48];

				// short DateFormatter
				DateFormat shortDf = DateFormat.getDateInstance(DateFormat.SHORT);
				
				System.out.println("******************JSP************************");
				
				/** Fill the booking MATRIX **/

				Calendar cal = Calendar.getInstance();
				Date toDay = new Date();
				
				// for each booking in booking list
				for (int i=0; i<bookingList.size();i++) {

					System.out.println("\n~~~~~~~~BOOKING~~~~~~~~~~~ : " + i);
					
					// Get conference date of the booking item
					Booking bookingItem = (Booking)bookingList.get(i);
					String confDate = shortDf.format(bookingItem.getConfDate());
					 
					System.out.println("Booking ConfDate:" + confDate);
					cal.setTime(toDay);

					// for each day till nDays
					for (int day = 0; day < nDays; day++) {

						System.out.println(day+":"+ shortDf.format(cal.getTime() ));
					
						// if bookingDate is of this day
						if( confDate.equals( shortDf.format(cal.getTime() ))){

							// Get timings of the booking item
							int confStartTime = Integer.parseInt(bookingItem.getStartTime());
							int confEndTime = Integer.parseInt(bookingItem.getEndTime());

							// Calculate starting yIndex for bookingXX matrix
							int yIndex = confStartTime/50;
							if (confStartTime %100 != 0) yIndex+=1;

							System.out.print("\n Fill MATRIX for time between: " + confStartTime+" and "+confEndTime + ":: yIndexes:" );
							// Fill MATRIX cells from startTime till endTime
							for (int t=confStartTime, incrementBy; t< confEndTime ; t+=incrementBy) {
								
								System.out.print(yIndex + ", ");	
								
								bookingXX[day][yIndex++] = i+1; // filled
								incrementBy =  t%100 == 0 ? 30:70;
							}
							break;
						}
						cal.add(Calendar.DAY_OF_MONTH, 1);
					}
				}
				
				%>
				<!--  Data Variables (to use in JS) -->
				<data id="nDays" value="<%=nDays%>"/>
				
				
				<!--  **************************************************************-->
				<!--  ********************** Bookings CHART ************************-->
				<!--  **************************************************************-->
				<table class="chart">
					<thead>
						<tr>
							<th align="center" id="th_full_normal_day" colspan="30">
								<input id="full_normal_day" type="button" onclick="javascript:showChartByTimePeriod('full_day')" value="&lt;&lt full day &gt;&gt;"/>
							</th>
						</tr>
						<tr>
							<th/>
							<th/>
							<th><input id="left_button" type="button" onclick="javascript:showChartByTimePeriod('am_only')" value="&lt;"/></th>
							<% for (int hour=0; hour<24; hour++) {%>
								<th id="th_<%=hour%>_hour" colspan="2" align="center" style="display:<%if (hour<8 || hour>19){%>none<%}else{%>block<%}%>"><span class=""/><%=Constants.strHours[hour] %> am</th>
							<%} %>
							<th><input id="right_button" type="button" onclick="javascript:showChartByTimePeriod('pm_only')" value="&gt;"/></th>
						</tr>
						<tr>
							<th/>
							<th/>
							<th/>
							<% for (int hour=0; hour<24; hour++) { %>
								<th id="th_<%=hour%>_halfhour" colspan="2" align="center" style="display:<%if (hour<8 || hour>19){%>none<%}else{%>block<%}%>">30</th>
							<%} %>
							<th/>
						</tr>						
					</thead>
					<tbody>
						<%
						cal.setTime(new Date());
						int intMonth = -1;
						
						for (int day = 0; day < nDays; day++) {
						%>
						<!--  TODO : change these to c:if etc -->
							<tr>
								<td>
									<% if (cal.get(Calendar.MONTH)!= intMonth ) { %>
										<%= Constants.strMonths[cal.get(Calendar.MONTH)]%>
									<%
										intMonth = cal.get(Calendar.MONTH);
									 	}%>
								</td>
								<td >
									<%= cal.get(Calendar.DAY_OF_MONTH)%>
								</td>
								<td>
									<%= Constants.strDays[cal.get(Calendar.DAY_OF_WEEK)-1] %>
								</td> 

								<% 
								int yIndex = 0;
								boolean isBooked = false;
								for (int hour=0; hour<24; hour++) {
									
									// is booked
									isBooked = bookingXX[day][(hour*2)]!=0? true: false;
								%>
								  	
								  	<td id="td_<%=day%>_<%=hour%>_first30mins" isBooked="<%=isBooked %>" isHighlighted=""
								  		onclick="highlightNewBookingCells(<%=day%>,<%=hour%>, 'first30mins')"
								  		style="display:<%if (hour<8 || hour>19){%>none<%}else{%>block<%}%>;
								  				<% if(bookingXX[day][(hour*2)]!=0){%>cursor:no-drop;background:#ffe6ea<%} %>"/>
								  	
								  	<% isBooked = bookingXX[day][(hour*2)+1]!=0? true: false;%>
								  	
								  	<td id="td_<%=day%>_<%=hour%>_last30mins" isBooked="<%=isBooked %>" isHighlighted=""
								  		onclick="highlightNewBookingCells(<%=day%>,<%=hour%>, 'last30mins')"
								  		style="display:<%if (hour<8 || hour>19){%>none<%}else{%>block<%}%>;
								  				<% if(bookingXX[day][(hour*2)+1]!=0){%>cursor:no-drop;background:#ffe6eb<%} %>"/>
								<%} %>
								<td>&nbsp;</td>							
							</tr>
						<%
						cal.add(Calendar.DAY_OF_YEAR,1);
						}%>
					</tbody>					
				</table>
			</div>
		</div>
		
		<!--  Footer -->
		<!-- jsp:include page="footer.jsp"/-->
	</body>
	
</html>