<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="div_header">
	
	<!--  Logo -->
	<div>
		<div id="div_logo_line">
			<a>
				<img src="images/logo1.jpeg" style="cursor:hand;" onclick="javascript:bookings()" alt="Goto Home page" />
			</a>
		</div>
 		<div id="div_header_options" > 
			<ul> 
				<li class="first" id="option_loggedinUser"><a href="#" onclick="javascript:executeWithLogin('',function(){})">Login</a> </li>
				<li><a href="Faq"> FAQ</a></li>
			</ul>
		</div>
		<div id="div_header_loggedin_options" style="display:none"> 
			<ul>
				<li class="first"> Hello <span id="span_userName"></span> !!!</li>
				<li><a href="#" onclick="javascript:logOut()"> Log out</a></li>
				<li><a href="Faq"> FAQ</a></li>
			</ul> 
		</div>
	</div>
	
	<% String currPage = request.getParameter("current_page");%>
	<data id="data_current_page" value="<%=currPage %>"/> 
		<!-- Tabs -->
		<div id="div_tabs">

			<ul id="div_mainTabs">
				<li class="first"> 
					<% if (currPage.equals("bookings")) {%>
						<img src="images/bookings2.gif"/>
					<%} %>
					<% if (!currPage.equals("bookings")) {%>
						<img src="images/bookings1.gif" style="cursor:hand;" onclick="javascript:bookings()" alt="Goto Bookings" />
					<%} %>				
				</li>
				<li>
					<% if (currPage.equals("rooms")) {%>
						<img src="images/rooms2.gif"/>
					<%} %>
					<% if (!currPage.equals("rooms")) {%>
						<img src="images/rooms1.gif" style="cursor:hand;" onclick="javascript:rooms()" alt="Goto Rooms" />					
					<%} %>				
				</li>
				<li>
					<% if (currPage.equals("my_account")) {%>
						<img src="images/my_account2.gif"/>
					<%} %>
					<% if (!currPage.equals("my_account")) {%>
						<img src="images/my_account1.gif" style="cursor:hand;" onclick="javascript:myAccount()" alt="Goto My account" />					
					<%} %>				
 			
				</li>								
			</ul>			
		</div>
		<input type="hidden" name="Hid_Context" value=""/>

</div>