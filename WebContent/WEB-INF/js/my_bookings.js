
function initializePage() {
	
	commonInit();
	loginInit();
 	
}
  
// shows or hides booking details row
function displayBookingDtls(rowId) {

	var totalBookings = document.getElementById("totalBookings").value;
	
	// booking details row (hidden) 
	var row = document.getElementById("tr_booking_dtls_" + rowId);			
	
	// show or hide 
	row.style.display = row.style.display=='block'? 'none':'block';

	// hide all other rows
	for ( i=1; i<= totalBookings; i++) {
		if( i != rowId)
		{
			document.getElementById("tr_booking_dtls_" + i).style.display= 'none';						
		}				
	}			
}


// displays "sure? yes no" option for the tobe cancelled row
function cancelBooking(rowId)
{	
	var totalBookings = document.getElementById("totalBookings").value;
	
	// display "sure? yes no"
	document.getElementById("div_cancel_booking_" + rowId).style.display = 'block';

	// hide "sure? yes no" for all other rows
	for ( i=1; i<= totalBookings; i++) {
		if( i != rowId)
		{
			if (document.getElementById("div_cancel_booking_" + i)) {
				document.getElementById("div_cancel_booking_" + i).style.display = 'none';
			}						
		}				
	}
}


// hides "sure? yes no" 
function noCancel(obj, rowId)
{
	document.getElementById("div_cancel_booking_" + rowId).style.display = 'none';
	obj.checked=false;
}


// sends ajax request to server to cancel the booking
function confirmCancel(obj, bookingId, rowId) {
	
	var url = protocol+ '://'+ server+ ':' + port + '/' + appName + '/MyBookings';
	var dataToSend = "Hid_Context=cancel_booking" + 
					 "&row_id=" + rowId +
					 "&booking_id=" + bookingId;
	var callBackFun = displayCancelledStatus;				  
	
	// send async ajax request to cancel the booking
	postDataGetText(url, dataToSend , callBackFun);
	
	obj.checked=false;
}
 

// displays cancelled status of the booking (ajax response callback function )
function displayCancelledStatus(responseText) {

	// response text is in the format : "responseStatus_rowId_bookingId"
	var respParams = responseText.split('_');
	
	if(respParams[0] == 'true') {
		var rowId = respParams[1];
		document.getElementById("td_cancel_booking_" + rowId).innerHTML = 'CANCELLED';
	}
	else {
		document.getElementById("td_cancel_booking_" + rowId).innerHTML = 'CANCELLATION FAILED' ;
	}
} 

function submitForm(context) 
{ 
	document.Form_MyAccount.Hid_Context.value = context;
	document.Form_MyAccount.submit();
}
