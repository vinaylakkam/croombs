<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

		<jsp:include page="header.jsp">
			<jsp:param value="currentPage" name="bookings"/>
		</jsp:include> 		

					<thead>
						<tr>
							<th><input type="button" onclick="javascript:showChartByTimePeriod('am')" value="&lt;"/></th>
							<th id="12am_hours_th" colspan="2" style="display:none"><div class="timeHours">12 <span class="amPm">am</span></div></th>
							<th id="1am_hours_th" colspan="2" style="display:none"><div class="timeHours">1 <span class="amPm">am</span></div></th>
							<th id="2am_hours_th" colspan="2" style="display:none"><div class="timeHours">2 <span class="amPm">am</span></div></th>
							<th id="3am_hours_th" colspan="2" style="display:none"><div class="timeHours">3 <span class="amPm">am</span></div></th>
							<th id="4am_hours_th" colspan="2" style="display:none"><div class="timeHours">4 <span class="amPm">am</span></div></th>
							<th id="5am_hours_th" colspan="2" style="display:none"><div class="timeHours">5 <span class="amPm">am</span></div></th>
							<th id="6am_hours_th" colspan="2" style="display:none"><div class="timeHours">6 <span class="amPm">am</span></div></th>
							<th id="7am_hours_th" colspan="2" style="display:none"><div class="timeHours">7 <span class="amPm">am</span></div></th>
							
							<th id="8am_hours_th" colspan="2"><div class="timeHours">8 <span class="amPm">am</span></div></th>
							<th id="9am_hours_th" colspan="2"><div class="timeHours">9 <span class="amPm">am</span></div></th>
							<th id="10am_hours_th" colspan="2"><div class="timeHours">10 <span class="amPm">am</span></div></th>
							<th id="11am_hours_th" colspan="2"><div class="timeHours">11 <span class="amPm">am</span></div></th>
							<th id="12pm_hours_th" colspan="2"><div class="timeHours">12 <span class="amPm">pm</span></div></th>
							<th id="1pm_hours_th" colspan="2"><div class="timeHours">1 <span class="amPm">pm</span></div></th>
							<th id="2pm_hours_th" colspan="2"><div class="timeHours">2 <span class="amPm">pm</span></div></th>
							<th id="3pm_hours_th" colspan="2"><div class="timeHours">3 <span class="amPm">pm</span></div></th>
							<th id="4pm_hours_th" colspan="2"><div class="timeHours">4 <span class="amPm">pm</span></div></th>
							<th id="5pm_hours_th" colspan="2"><div class="timeHours">5 <span class="amPm">pm</span></div></th>
							<th id="6pm_hours_th" colspan="2"><div class="timeHours">6 <span class="amPm">pm</span></div></th>
							<th id="7pm_hours_th" colspan="2"><div class="timeHours">7 <span class="amPm">pm</span></div></th>
							
							<th id="8pm_hours_th" colspan="2" style="display:none"><div class="timeHours">8 <span class="amPm">pm</span></div></th>
							<th id="9pm_hours_th" colspan="2" style="display:none"><div class="timeHours">9 <span class="amPm">pm</span></div></th>
							<th id="10pm_hours_th" colspan="2" style="display:none"><div class="timeHours">10 <span class="amPm">pm</span></div></th>
							<th id="11pm_hours_th" colspan="2" style="display:none"><div class="timeHours">11 <span class="amPm">pm</span></div></th>
							
							<th><input type="button" onclick="javascript:showChartByTimePeriod('pm')" value="&gt;"/></th>
						</tr>
						<tr>
							<th/>
							<th id="12am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="1am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="2am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="3am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="4am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="5am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="6am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="7am_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>

							<th id="8am_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="9am_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="10am_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="11am_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="12pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="1pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="2pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="3pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="4pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="5pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="6pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>
							<th id="7pm_mins_th" colspan="2" align="center"><div class="timeMins">30</div></th>

							<th id="8pm_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="9pm_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="10pm_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							<th id="11pm_mins_th" colspan="2" align="center" style="display:none"><div class="timeMins">30</div></th>
							
							<th/>
						</tr>						
					</thead>

<c:forEach var="booking" items="${bookingList}">
							<tr>
	 							<td> Apr 2 <br/> Sun</td>
								<td>${booking.}</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								
								<td>8</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								
								<td>9</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
								<td>1</td>
							</tr>
						</c:forEach>

</body>
</html>