<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@page import="java.util.List, com.croombs.beans.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<title>CRoomBS - Rooms</title>
		
		<style type="text/css">
			<%@ include file="/WEB-INF/css/main.css" %>
			<%@ include file="/WEB-INF/css/account_styles.css" %>
		</style>
		<script type="text/javascript" language="Javascript">
			<%@ include file="/WEB-INF/js/rooms.js" %>
			
			<%@ include file="/WEB-INF/js/common.js" %>
			<%@ include file="/WEB-INF/js/common_ajax_util.js" %>
			<%@ include file="/WEB-INF/js/login.js" %>
			<%@ include file="/WEB-INF/js/header.js" %>
			
			<%@ include file="/WEB-INF/js/common_floating_div.js" %>
							
		</script>
	</head> 
	
	<body onload="javascript:initializePage()">

 		<!--  Common jsp data -->
 		<jsp:include page="common.jsp"/>

		<!--  Hidden login box -->
		<jsp:include page="login.jsp"/>
 		
 		<!--  Header -->
		<jsp:include page="header.jsp">
			<jsp:param name="current_page" value="rooms" />
		</jsp:include>

		
		<!--  Wrapper -->
		<div id="div_wrapper">
			
			<div id="div_container">

				<%  int totalRooms = ((List<Room>)request.getAttribute("roomList")).size(); %>
				
				<data id="totalRooms" value="<%=totalRooms%>"/>
				
				<span style="margin-top:30px">
					<strong><%=totalRooms %> rooms found.</strong>
				</span>
			
				<%if (totalRooms > 0){  %>
					<table width="70%" style="margin-top:20px">
						<thead>
							<tr style="background-color:#5c99c7">
								<th>Room ID</th>
								<th>Name</th>
								<th>Description</th>
								<th>Seats</th>
								<th>Contact Number</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="room" items="${roomList}"  varStatus="itr" >
								<tr style="border: solid #0000FF">
									<td>${room.roomId}
										<%--a href="javascript:displayRoomDetails(${itr.count})"> ${room.roomId}</a--%>
									</td>
									<td>${room.name}</td>
									<td>${room.description}</td>
									<td>${room.noOfSeats}</td>
									<td>${room.contactNum}</td>
									<%-- %>td id="td_delete_room_${itr.count}">
										<input type="button" onclick="deleteRoom(${itr.count});" value="cancel"/>
										<div style="display:none" id="div_delete_room_${itr.count}">Sure?
											<input type="radio" name="group1" value="yes" onclick="confirmDelete(${room.roomId}, ${itr.count})"/>Yes
											<input type="radio" name="group1" value="no" onclick="noCancel(${itr.count});"/>No
										</div>									
									</td--%>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				<%} %>
			</div>
		</div>
	 
		<!--  Footer -->
		<jsp:include page="footer.jsp"/>


	</body>
</html>