<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@page import="java.util.*, java.text.DateFormat" %>
<%@page import="com.croombs.Constants, com.croombs.beans.*"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<%
		// Get startDate of bookings displayed
		Date fromDate = (Date) request.getAttribute("fromDate");	 			
		
		// Get bookingList
		List bookingList = (List) request.getAttribute("bookingList");
		
		//Get number of Days (nDays)
		int nDays = ((Integer)request.getAttribute("nDays")).intValue();
		
		// booking MATRIX with filled in data
		int bookingXX[][] =  getBookingXX(bookingList, fromDate, nDays);
	%>
	
 	<!--  ********************** Bookings CHART ************************ -->
	<!--  ************************************************************** -->
	<%@page import="java.text.SimpleDateFormat"%>
	<table class="chart">
		<thead>
			<tr>
				<th colspan="3">
					<!--  "Number of days per page" option box-->
					<select name="Opt_DaysPerPage" id="Opt_DaysPerPage" onchange="javascript:getBookings('get_bookings')">
						<c:forEach var="i" begin="1" end="31" step="1">
							<option value="${i}">${i}</option>
						</c:forEach>
					</select> days.				
				</th>
				<th align="center" id="th_full_normal_day" colSpan="25">
					<input id="full_normal_day" type="button" onclick="javascript:showChartByTimePeriod('full_day')" value="&lt;&lt  &gt;&gt;"/>
				</th>
				<th>
					<input src="images/refresh.png" width="25"  height="25" alt="Refreshes the booking chart" type="image" name="Btn_Refresh" value="Rf" onclick="javascript:getBookings('get_bookings')"/>				
				</th>
			</tr>
			<tr>
				<th colspan="3">
 				<th ><input id="left_button" type="button" align="center" onclick="javascript:showChartByTimePeriod('am_only')" value="&lt;"/></th>
				<% for (int hour=0; hour<24; hour++) {%>
					<th  id="th_<%=hour%>_hour" colSpan="2" align="left" style="color: #edf4f8; display:<%if (hour<8 || hour>19){%>none<%}else{%>block<%}%>">
						<span style="text-align:left; font-size:16px"><%=Constants.strHours[hour] %> </span>
						<%if(hour<12){%>am<%}else{%>pm<%} %></th>
				<%} %>
				<th><input colspan="2" id="right_button" type="button" align="center" onclick="javascript:showChartByTimePeriod('pm_only')" value="&gt;"/></th>
			</tr>
			<tr>
				<th colspan="3">
 				<th/>
				<% for (int hour=0; hour<24; hour++) { %>
					<th id="th_<%=hour%>_halfhour" type="th_mins" colSpan="2" align="center" style="display:<%if (hour<8 || hour>19){%>none<%}else{%>block<%}%>; font-size:10px">30</th>
				<%} %>
				<th/>
			</tr>						
		</thead>
		<tbody id="tbody_chart" >
			<%
			Calendar cal = Calendar.getInstance();
			cal.setTime(fromDate);

			Calendar cal2 = Calendar.getInstance();
			cal2.add(Calendar.DAY_OF_WEEK, 10); // Only next 10 days are allowed to book
			
			// Get today date and time
			Date toDayNow = new Date();
			Date toDay = new Date(toDayNow.getYear(),(toDayNow.getMonth()),toDayNow.getDate()); // TODO: +1 needs to be removed; taking next month; print itrDate and investigate
			
			// Calculate time now in 3 or 4 digit format (ex: 920, 1020)
			String tnm = ""+ toDayNow.getMinutes();
			String timeNowMins = (tnm.length()==1 ? "0"+tnm : tnm);
			int timeNow = Integer.parseInt(""+toDayNow.getHours()+""+timeNowMins);

			int intMonth = -1;
			for (int day = 0; day < nDays; day++) {

				// Find date difference between today and date in iteration [ to decide isExpired]
				Date itrDate = cal.getTime();
				itrDate = new Date(itrDate.getYear(),(itrDate.getMonth()),itrDate.getDate()); // TODO: +1 needs to be removed; taking next month; print itrDate and investigate
				int dateDiff = itrDate.compareTo(toDay);
			%>
				<tr>
					<td>
						<% if (cal.get(Calendar.MONTH)!= intMonth ) { %>
							<%= Constants.strMonths[cal.get(Calendar.MONTH)]%>
						<%
							intMonth = cal.get(Calendar.MONTH);
						 	}%>
					</td>
					<td >
						<% String dt = ""+cal.get(Calendar.DAY_OF_MONTH);
						   String dt2Digit = (dt.length()==1 ? "0"+dt : dt);
						%>
						<%=dt2Digit %>						
					</td>
					<td>
						<%= Constants.strDays[cal.get(Calendar.DAY_OF_WEEK)-1] %>
					</td>
					<td style="background:#dfdfdf">&nbsp;</td> 
					<% 
					int yIndex = 0;
					boolean isBooked = false;
					boolean isPrevCellBooked = false;
					boolean isSlotExpired = false;
					int matrixValue;
					boolean isDayNotAllowedToBook = itrDate.after(cal2.getTime()); // Allow to book only for few days
					
					Booking booking 	= null;
					String confName 	= "";
					String confDesc 	= "";
					String startTime 	= "";
					String endTime 		= "";
					String noOfAttn 	= "";					
					String bookedByUserId= "";
					String bookedByName = "";					
					String contactNum 	= "";
					String[] bookedBkgd	= {"#ED7967","#FF9999"}; 
					
					int ctr				= 1;
					
					for (int halfHour=0; halfHour<48; halfHour++) {
						
						// is booked
						matrixValue = bookingXX[day][halfHour];
						isBooked = matrixValue !=0? true: false;
						isPrevCellBooked = false;
						if(halfHour!=0) {
							isPrevCellBooked = (bookingXX[day][halfHour] == bookingXX[day][halfHour-1]);
						}
						// is date and time of slot expired
						isSlotExpired = (dateDiff<0) || ( dateDiff==0 && timeNow>(halfHour*50));
						
						// no of half hours for this booking
						int halfHours = noOfHalfHours(bookingXX[day], halfHour);

						if (isBooked) {
							booking = (Booking)bookingList.get(matrixValue-1);
							
							confName 	= booking.getConfName();
							confDesc 	= booking.getConfDesc();
							startTime = booking.getStartTime();
							endTime = booking.getEndTime();
							noOfAttn	= ""+ booking.getNoOfAttn();
							bookedByUserId 	= booking.getUserId();
							bookedByName	= booking.getUserName();
							contactNum 	= booking.getContactNum();
						}
					%>
					  	
					  	<td id="td_<%=day%>_<%=halfHour%>"  
					  		isBooked="<%=isBooked %>" 
					  		isHighlighted=""
							onmousedown="<%if(isBooked || isSlotExpired || isDayNotAllowedToBook){%> return false<%} %>; 
								onrightclick();initDragSelection(<%=day%>,<%=halfHour%>)"
					  		onmouseup="endDragSelection()"
					  		oncontextmenu="return false"
					  		onmouseover="<%if(isBooked){%>getCursorPosition();showConfDtlsCallOut('<%=confName %>', '<%=confDesc%>', '<%=startTime%>', '<%=endTime%>', '<%=noOfAttn%>', '<%=bookedByUserId%>', '<%=bookedByName%>', '<%=contactNum%>')<%}%>;
						  		continueDragSelection(<%=day%>,<%=halfHour%>)"
					  		onmouseout="<%if(isBooked){%>hideConfDtlsCallOut()<%}%>;"
					  		style="display:<%if (halfHour<16 || halfHour>39){%>none<%}else{%>block<%}%>;
					  				<% if(isBooked || isSlotExpired || isDayNotAllowedToBook){%>cursor:no-drop;<%} %>
					  				<% if(isBooked && !isPrevCellBooked){%>background:<%= bookedBkgd[++ctr % 2]%>;<%} %>
					  				<% if(isBooked && isPrevCellBooked){%>background:<%= bookedBkgd[ctr % 2]%>;<%} %> 
					  				"
					  			>
					  			
					  			
					  	</td>
	
					<%} %>
					
					<td style="background:#dfdfdf">&nbsp;</td>							
				</tr>
			<%
			cal.add(Calendar.DAY_OF_YEAR,1);
			}%>
		</tbody>					
	</table>

	
	<%!
	
	/* Returns the number of half hours of the conference */
	int noOfHalfHours( int bookingXXDay[], int halfHr) {
		int rtn = 1; 
		
		int cellValue = bookingXXDay[halfHr];
		for (int halfHour = halfHr+1; halfHour<48; halfHour++, rtn++) {
			if(bookingXXDay[halfHour] != cellValue) break;
		}
		
		return rtn;
	}
	int bookingHalfHoursX[];
	
	/* Returns the booking matrix object with booked details */
	int[][] getBookingXX( List bookingList, Date fromDate, int nDays) {
		
		// booking MATRIX
		int bookingXX[][] =  new int[nDays][48];
		
		bookingHalfHoursX = new int[bookingList.size()];
		
		// Calendar 
		Calendar cal = Calendar.getInstance();
		
		// short DateFormatter
		DateFormat shortDf = DateFormat.getDateInstance(DateFormat.SHORT);
		
		// For each booking in booking list
		for (int i=0; i<bookingList.size();i++) {

			// Get conference date of the booking item
			Booking bookingItem = (Booking)bookingList.get(i);
			String confDate = shortDf.format(bookingItem.getConfDate());
			 
			cal.setTime(fromDate);

			// for each day till nDays
			for (int day = 0; day < nDays; day++) {

				//System.out.println(day+":"+ shortDf.format(cal.getTime() ));
			
				// if bookingDate is of this day
				if( confDate.equals( shortDf.format(cal.getTime() ))){

					// Get timings of the booking item
					int confStartTime = Integer.parseInt(bookingItem.getStartTime());
					int confEndTime = Integer.parseInt(bookingItem.getEndTime());

					// Calculate starting yIndex for bookingXX matrix
					int yIndex = confStartTime/50;
					if (confStartTime %100 != 0) yIndex+=1;

					//System.out.print("\n Fill MATRIX for time between: " + confStartTime+" and "+confEndTime + ":: yIndexes:" );
					// Fill MATRIX cells from startTime till endTime
					for (int t=confStartTime, incrementBy, counter=0; t< confEndTime ; t+=incrementBy) {
						
						//System.out.print(yIndex + ", ");	
						
						bookingXX[day][yIndex++] = i+1; // filled
						incrementBy =  t%100 == 0 ? 30:70;
						
						bookingHalfHoursX[i] = ++counter;
					}
					break;
				}
				cal.add(Calendar.DAY_OF_MONTH, 1);
			}
		}
		return bookingXX;
	}
	
	
	%>				
