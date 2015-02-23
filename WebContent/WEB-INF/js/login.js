var loggedInCallBackFun = 'None';
var userProfile = null;

function loginInit() {

	var isLoggedIn = document.getElementById('data_is_loggedin').value;
	var userId = document.getElementById('data_userId').value;
	var userName = document.getElementById('data_userName').value;
	
	userProfileObj = eval("("+document.getElementById('div_user_profile').innerHTML+")");
	
	//alert(userProfileObj.userId == '');
	//alert("isLoggedIn:"+isLoggedIn);
	
	if(isLoggedIn == 'true') {

		// display div_header_loggedin_options and assign userId
		document.getElementById('div_header_loggedin_options').style.display = 'block';
		document.getElementById('span_userName').innerHTML = userName;

		// hide div_header_options
		document.getElementById('div_header_options').style.display = 'none';
	}
}

// checks if the  user is logged in, and executes the callBackFun after logging in.
function executeWithLogin(loginCaption, callBackFun){

	var userId = document.getElementById('data_userId').value;
	var isLoggedIn = document.getElementById('data_is_loggedin').value;

	//alert("userId:"+userId+"\nisLoggedIn:"+isLoggedIn);

	if (userId!= null && isLoggedIn=='true') {
		// user have alredy logged in ;
		callBackFun();
	}
	else {
		// user is not logged in

		// set call back function (to call after loggin success)
		loggedInCallBackFun = callBackFun;

		// display login window as floatable.
		displayAsFloatable("div_login", "Login",false, {width:250,height:250,left:350,top:200});

		document.getElementById('login_caption').innerHTML = loginCaption;

	}

}

function deleteCookie(name) {
	document.cookie = name + "=; expires=Thu, 01-Jan-70 00:00:01 GMT" + "; path=/";
}


function login() {

	
	// set user id in hidden variable
	document.getElementById('data_userId').value = document.getElementById('Inp_userId').value;

	//var url = "http://localhost:9090/CRoomBS-NEW/Login";
	var url = protocol+ '://'+ server+ ':' + port + '/' + appName + '/Login';
 	var dataToSend = "context=login" +
					 "&userId=" + document.getElementById('Inp_userId').value +
					 "&password=" + document.getElementById('Inp_Password').value+
					 "&remember_me=" + document.getElementById('Chk_RememberMe').checked;

	// hide login table
	document.getElementById('tab_login').style.display = 'none';
	document.getElementById('logging_in').style.display = 'block';

	document.getElementById('Inp_Password').value = '';
	document.getElementById('Chk_RememberMe').checked = false;

	// send async ajax request to login
	postDataGetText(url, dataToSend , loggedIn);
}

function loggedIn(responseText){

	// response text is in the format : "loginStatus_userName"
	var respParams = responseText.split('___');

	if (respParams[0] == 'success') {
	
		// Get into userprofile object (global variable)
		userProfileObj = eval("("+respParams[1]+")");

		document.getElementById('data_userName').value = userProfileObj.name; 
		
		// hide login window and div_header_options
		document.getElementById('div_login').style.display = 'none';
		document.getElementById('div_header_options').style.display = 'none';

		// display div_header_loggedin_options and assign userId
		document.getElementById('div_header_loggedin_options').style.display = 'block';
		document.getElementById('span_userName').innerHTML = document.getElementById('data_userName').value;

		// set data_is_loggedin
		document.getElementById('data_is_loggedin').value = 'true';

		// call loggedIn call back function
		if(loggedInCallBackFun != 'None') {
			loggedInCallBackFun();
		}
	}
	else {
		//Login failed

		// show login table with error
		document.getElementById('tab_login').style.display = 'block';
		document.getElementById('div_login_error').style.display = 'block'; // TODO: display appropriate error msg from server
	}

	// enable login table (for next time)
	document.getElementById('tab_login').style.display = 'block';
	document.getElementById('logging_in').style.display = 'none';

}

function logOut() {

	//var url = "http://localhost/croombs/Login";
	var url = protocol+ '://'+ server+ ':' + port + '/' + appName + '/Login';
 	var dataToSend = "context=log_out" +
					 "&userId=" +  document.getElementById('data_userId').value;

	// send async ajax request to logout
	postDataGetText(url, dataToSend , loggedOut);
}

function loggedOut(responseText){

	if (responseText == 'success') {

		// display div_header_options (without 'login failed')
		document.getElementById('div_header_options').style.display = 'block';

		// hide div_header_loggedin_options
		document.getElementById('div_header_loggedin_options').style.display = 'none';

		// set data fields
		document.getElementById('data_is_loggedin').value = 'false';
		document.getElementById('data_userId').value = '';
		//document.Form_Login.Hid_userId.value ='';

		// delete cookies
		deleteLoginCookies();
		
		// if the user is in my_account page, throw him out
		isMyAccountPage = getById('data_current_page').value == 'my_account';
		if(isMyAccountPage){
			document.Form_Common.Hid_Context.value = 'bookings';
			document.Form_Common.submit();
		}
	}
}
function cancelLogin() {
	// hide login window and div_header_options
	document.getElementById('div_login').style.display = 'none';
}

function deleteLoginCookies(){
	deleteCookie("ck_userId");
	deleteCookie("ck_token");
}

function showLoginCookies(){
	alert("userId: "+ getCookie("ck_userId")+
		  "\n\n Token: "+ getCookie("ck_token"));
}

function getCookie(c_name)
{
if (document.cookie.length>0)
  {
  c_start=document.cookie.indexOf(c_name + "=");
  if (c_start!=-1)
    {
    c_start=c_start + c_name.length+1 ;
    c_end=document.cookie.indexOf(";",c_start);
    if (c_end==-1) c_end=document.cookie.length
    return unescape(document.cookie.substring(c_start,c_end));
    }
  }
return ""
}
