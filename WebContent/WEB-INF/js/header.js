
function bookings(){
	// Set context as 'bookings' so it will not be treated as home page (login is preserved)
	document.Form_Common.Hid_Context.value = 'bookings';
	document.Form_Common.action = 'Home';
	document.Form_Common.submit();
}


function rooms(){
	document.Form_Common.Hid_Context.value = 'rooms';
	document.Form_Common.action = 'Rooms';
	document.Form_Common.submit();
}

function myAccount() {
	// login and display My bookings
	executeWithLogin("to view your bookings", getMyAccount);
}

function getMyAccount() {
	// My Account first page is: My bookings
	document.Form_Common.Hid_Context.value = 'my_curr_bookings';
	document.Form_Common.action = 'MyBookings';
	document.Form_Common.submit();
}