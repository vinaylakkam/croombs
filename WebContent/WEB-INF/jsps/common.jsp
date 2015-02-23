<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


	<data id="data_protocol" value="http"/>
	<data id="data_server" value="<%=request.getServerName()%>"/>
	<data id="data_port" value="<%=request.getServerPort()%>"/>
	<data id="data_app_name" value="croombs"/>
	
	<form name="Form_Common" id="Form_Common" action="Home" method="post">
		<!--  This form can be used to get the home page (currently used in login.js when loggout happens in my accounts page) -->
		<input type="hidden" name="Hid_Context" value=""/>		
	</form>

