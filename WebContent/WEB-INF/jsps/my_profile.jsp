<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@page import="java.util.*, java.text.DateFormat" %>
<%@page import="com.croombs.Constants, com.croombs.beans.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<title>CRoomBS - My Profile</title>
		
		<style type="text/css">
			<%@ include file="/WEB-INF/css/main.css" %>
			<%@ include file="/WEB-INF/css/account_styles.css" %>
			<%@ include file="/WEB-INF/css/my_account.css" %>
		</style>
		<script type="text/javascript" language="Javascript">
			<%@ include file="/WEB-INF/js/my_profile.js" %>
			
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
			<ul class="ac_tabs inline">
				<li class="first"><a  class="previous" href="MyBookings" onclick="javascript:submitForm('my_bookings')">My Bookings</a></li>
				<li><a class="current" href="#" onclick="return;">My Profile</a></li>
			</ul>
		</div>	
  
		<!--  Wrapper -->
		<div id="div_wrapper">
			
			<div id="div_container">
				<div id="div_my_profile">
					<br/>
					<%-- Form --%>
					<form name="Form_MyAccount" id="Form_MyAccount" action="" method="post">
						<input type="hidden" name="Hid_Context" value=""/>
					
						<!--  LOGIN DETAILS -->
						<div id="div_login">					
							<h4> 
								<a href="#" id="a_edit_login" onclick="javascript:editDetails('login')" style="float:right">
									<span id="span_edit_login">edit</span>
								</a> Login details 
							</h4>
							<div id="div_login_view"> 
								<table class="tableView"> 
									<tr>
										<td class="label"> User ID:</td>
										<td id="view_userid">${userProfile.userId}</td>
									</tr>
									<tr>
										<td class="label"> Password:</td>
										<td id="view_password">xxxxxxx</td>
									</tr>								
								</table>
							</div>  
							<div id="div_login_edit"  style="display:none"> 
								<table class="tableEdit"> 
									<tr>
										<td class="label"> 
											<label for="Inp_UserId">User ID</label>
										</td>
										<td>${userProfile.userId}</td>
									</tr>
 	 								<tr><td id="Info_Txt_Password" colspan="2"></td></tr>									
									<tr>
										<td class="label">
											<label id="Lbl_Txt_Password" for="Txt_Password">Password</label>
										</td>
										<td>
											<input type="password" id="Txt_Password" name="Txt_Password" maxlength="50" size="30" title="Password" value=""/>
										</td>									
									</tr>
									<tr>
										<td class="label">
											<label id="Lbl_Txt_Password2" for="Txt_Password2">Confirm Password</label>
										</td>
										<td>
											<input type="password" id="Txt_Password2" name="Txt_Password2" maxlength="50" size="30" title="Password" value=""/>
										</td>									
									</tr>
	 								<tr style="padding-top:10px">
										<td colspan="2">
											<input type="button" value="Save" onclick="javascript:saveDetails('login')"/> or
											<a href="#" onclick="cancelEdit('login')"> Cancel</a>
										</td>
									</tr>
								</table>
							</div>
							<span id="span_login_save_status" style="padding-top:20px"></span>
						</div>
											
							<div id="div_personal">					
							<h4> 
								<a href="#" id="a_edit_personal" onclick="javascript:editDetails('personal')" style="float:right">
									<span id="span_edit_personal">edit</span>
								</a> Personal details 
							</h4>
							<div id="div_personal_view"> 
								<table class="tableView">
									<tr>
										<td class="label"> Name:</td>
										<td id="view_name">${userProfile.name}</td>
									</tr>
									<tr>
										<td class="label"> Contact Number:</td>
										<td id="view_contact_num">${userProfile.contactNum}</td>
									</tr>								
									<tr>
										<td class="label"> E-Mail:</td>
										<td id="view_mail">${userProfile.mail}</td>
									</tr>								
								</table>
							</div>  
							<div id="div_personal_edit"  style="display:none"> 
								<table class="tableEdit">

									<tr>
										<td id="Info_Txt_Name" colspan="2"></td>
									</tr>									
									<tr>
										<td class="label">
											<label id="Lbl_Txt_Name" for="Txt_Name">Name</label>
										</td>
										<td>
											<input type="text" id="Txt_Name" name="Txt_Name" maxlength="50" size="30" title="Name" value="${userProfile.name}"/>
										</td>									
									</tr>								 

									<tr>
										<td id="Info_Txt_ContactNum" colspan="2"></td>
									</tr>
									<tr>
										<td class="label">
											<label id="Lbl_Txt_ContactNum" for="Txt_ContactNum">Contact Number <br/>(mobile only)</label>
										</td>
										<td>
											<input type="text" name="Txt_ContactNum" maxlength="15" size="30" title="10 digit mobile number" value="${userProfile.contactNum}"/>
										</td>
									</tr>

									<tr>
										<td id="Info_Txt_Email" colspan="2"></td>
									</tr>
									<tr>
										<td class="label"><label id="Lbl_Txt_Email" for="Txt_Email">E-mail</label></td>
										<td>
											<input type="text" name="Txt_Email" maxlength="50" size="30" title="Email address" value="${userProfile.mail}"/>
										</td>
									</tr>


	 								<tr style="padding-top:10px">
										<td colspan="2">
											<input type="button" value="Save" onclick="javascript:saveDetails('personal')"/> or
											<a href="#" onclick="cancelEdit('personal')"> Cancel</a>
										</td>
									</tr>
								</table>
							</div>
							<span id="span_personal_save_status" style="padding-top:20px"></span>
						</div>
						
						
					</form>					

							
				</div>
				
			</div>
		</div>
	 
		<!--  Footer -->
		<jsp:include page="footer.jsp"/>
	</body>
	
</html>