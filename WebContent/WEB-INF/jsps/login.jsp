<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.croombs.beans.UserProfile" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<data id="data_is_loggedin" value="<%= request.getSession().getAttribute("isLoggedIn") %>"/>
<data id="data_userId" value="<%= request.getSession().getAttribute("userId") %>"/>
<data id="data_userName" value="<%= request.getSession().getAttribute("userName") %>"/>

<div id="div_login" style="display:none;">
	<div id="div_login_error" style="display:none"> Invalid User ID or Password.</div>
	<br/>
	<table id="tab_login">
		<caption> Please login <span id="login_caption"></span>.</caption>		
 		<tbody>
 			<tr>
 				<td>&nbsp;</td>
 				<td/>
 			</tr>
			<tr>
				<td>User ID</td>
				<td>
					<input id="Inp_UserId" name="Inp_UserId" type="text" value=""/>
				</td>
			</tr>
			<tr>
				<td>Password</td>
				<td>
					<input id="Inp_Password" name="Inp_Password" type="password" value="aaaaa"/>
				</td>
			</tr>
			<tr>
				<td/>
				<td>
					<input class="checkbox" type="checkbox" name="Chk_RememberMe" id="Chk_RememberMe" title="Remember password" /> 
					<label for="remember">Remember me.</label>
	            </td> 
			</tr>
 			<tr>
 				<td>&nbsp;</td>
 				<td/>
 			</tr>			
			<tr>
				<td/>
				<td align="center">
					<input type="button" id="Btn_Login" value="Login" onclick="javascript:login()"/> or
					<a href="#" onclick="cancelLogin()"> Cancel</a>
				</td>
			</tr>			
		</tbody>
	</table>
	
	<span id="logging_in" style="display:none; valign:center;haglign=center"> Logging in ... Please wait.</span>	
</div>

<!--  For user profile java script object -->
<div id="div_user_profile" style="display:none">
	{
		userId:'${userProfile.userId}',
		name:'${userProfile.name}',
		profileType:'${userProfile.profileType}',
		contactNum:'${userProfile.contactNum}',
		mail:'${userProfile.mail}',
		allowedBookHrs:'${userProfile.allowedBookHrs}',
		prefRoomId:'${userProfile.prefRoomId}',
		prefBookDays:'${userProfile.prefBookDays}'
	}
</div>