/** Global variables */
var prevSelectedDay='None';
var cX = 0, cY = 0; // cursor positions
var firstHighlightedCell='None', lastHighlightedCell='None';
var fromTime, toTime;
var fieldErrors = false;

// Initializes the page
function initializePage() {

 	document.getElementById('div_new_booking').style.top = 100;

	var roomId = document.getElementById('roomId').value;
	var nDays = document.getElementById('nDays').value;
	document.Form_Bookings_Nav.Opt_Rooms.value = roomId;
	document.Form_Bookings_Nav.Opt_DaysPerPage.value = nDays;

    // Setup calendar
    Calendar.setup({
        inputField     :    "Inp_SelectedDate",      // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        showsTime      :    false,           // will display a time selector
        button         :    "f_trigger_b",   // trigger for the calendar (button ID)
        singleClick    :    true,            // double-click mode
        step           :    1,               // show all years in drop-down boxes (instead of every other year as default)
        onUpdate	   :    calendarUpdated
    });

	commonInit();
	loginInit();
}

function displayBookingBanner(month,date,day) {

	// set first and last highlighted cells
	setFirstLastHighlightedCells();

	// calculate from and to time
	calculateFromToTimes();

 	var fTime = String(fromTime).substring(0,2)+ ":" + String(fromTime).substring(2,4);
	var tTime = String(toTime).substring(0,2)  + ":" + String(toTime).substring(2,4);

	//display booking banner with timings
	banner = document.getElementById('div_booking_banner');
	banner.style.display = 'none';
	banner.innerHTML = month + " " + date + " " + day + "<br/> " + fTime + ' to ' + tTime;

	//alert(prevSelectedDay+"\n\n"+fromTime+' to '+ toTime);
}


function hideNotification() {
	getById('div_notification').style.display = 'none';
}
function setFirstLastHighlightedCells() {

	firstHighlightedCell='None';
	lastHighlightedCell='None';

	// Get index of first and light highlighted cells
	for (var halfHour=0; halfHour<48; halfHour++) {

		var cell = document.getElementById('td_'+prevSelectedDay+'_'+halfHour);

		if(cell.isHighlighted == 'true' && firstHighlightedCell == 'None') {
			firstHighlightedCell = halfHour; // found firstHighlightedCell
		}
		if((firstHighlightedCell != 'None') && cell.isHighlighted != 'true') {
			lastHighlightedCell = halfHour-1; // found lastHighlightedCell
			break;
		}
	}
}

function calculateFromToTimes() {
	// calculate from and to time
	fromTime = firstHighlightedCell *50;
	toTime = parseInt(firstHighlightedCell *50) + parseInt((lastHighlightedCell-firstHighlightedCell+1)*50);
	if(fromTime % 100 != 0) fromTime-=20;
	if(toTime % 100 != 0) toTime-=20;

	// make fixed length 4 digit time e.g: 0330
	fromTime = fourDigitTime(fromTime);
	toTime = fourDigitTime(toTime);
}



// Calculates booking date, fromTime and toTime and displays "New Booking Details" form
function newBooking() {

	// If prevSelectedDay is not set (which means no cells are high lighted), alert warning and return
	if (prevSelectedDay == 'None') {
		alert('Please select the booking times before clicking \"Book\" button');
		return;
	}

	executeWithLogin('to book the conference room', displayNewBookingDtlsForm); // in login.js
}

function displayNewBookingDtlsForm() {

	var nDays = document.getElementById('nDays').value;

	setFirstLastHighlightedCells();

	// If booking cells are not high lighted, alert warning and return
	if (firstHighlightedCell == 'None') {
		alert('Please select the booking times before clicking \"Book\" button');
		return;
	}

	if(!isUserAllowedtoBookSelectedHours()){
		alert("You are not allowed to book more than "+ userProfileObj.allowedBookHrs + " hours at a time. Please change the selection or contact admin.");
		return;
	}

 	// Get conference date
	var calendarBoxDate  = new Date(document.getElementById("Hid_CurrSelectedDate").value); // displayed in Calendar box page
	calendarBoxDate.setDate(calendarBoxDate.getDate() + parseInt(prevSelectedDay));
	var confDate /*in dd-MMM-yy format*/ = calendarBoxDate.getDate() + "-"+ months[calendarBoxDate.getMonth()] + "-"+  (calendarBoxDate.getYear());

	calculateFromToTimes();
	var formBookingDtls = document.getElementById('Form_BookingDtls');
	formBookingDtls.Hid_ConfDate.value = confDate;
	formBookingDtls.Hid_ConfStartTime.value = fromTime;
	formBookingDtls.Hid_ConfEndTime.value = toTime;

	/*alert("\Hid_ConfDate:"+ formBookingDtls.Hid_ConfDate.value +
	"\nHid_ConfStartTime:"+ formBookingDtls.Hid_ConfStartTime.value +
	"\nHid_ConfEndTime:"+ formBookingDtls.Hid_ConfEndTime.value );
	*/

	// display new booking details form
	displayAsFloatable("div_new_booking","New Booking Details",false, {width:500,height:300,left:300,top:200} );
	
	// update user profile related fileds
	document.Form_BookingDtls.Txt_ContactNum.value = userProfileObj.contactNum;
	document.Form_BookingDtls.Txt_Email.value = userProfileObj.mail; 
}

function hideNewBookingDtlsForm() {
	document.getElementById('div_new_booking').style.display = 'none';
}

function isUserAllowedtoBookSelectedHours() {

	// Get exact from and To times (ex: 1450 instead of 1430) 
	var fromTimeTemp = firstHighlightedCell *50;
	var toTimeTemp = parseInt(firstHighlightedCell *50) + parseInt((lastHighlightedCell-firstHighlightedCell+1)*50);

	//Find number of hours being booked
	diff = (toTimeTemp - fromTimeTemp) / 100;
	
	// return true if it is <= the allowed hours for this user
	return (diff <= userProfileObj.allowedBookHrs);
}

// returns four digit time eg:returns 0330 when 330 is recieved
function fourDigitTime(time) {
	var len = (""+time).length;
	switch (len) {
		case 1: ret ="000"+time; break;
		case 2: ret ="00"+time; break;
		case 3: ret ="0"+time; break;
		case 4: ret = time;
	}
	return ret;
}

function calendarUpdated() {

	var currSelectedDate = document.Form_Bookings_Nav.Hid_CurrSelectedDate.value
	var newSelectedDate = document.getElementById("Inp_SelectedDate").value;

	if (currSelectedDate!=newSelectedDate /* TODO : and calendar is closed*/){
		getBookings('get_bookings_by_date');
	}
}


// submit the page to get bookings (prev, current and next)
function getBookings(context) {

	// set context and page number
	var formBookings = document.Form_Bookings_Nav;

	var nDays = parseInt(document.getElementById('nDays').value);
	var todayDate = document.getElementById('todayDate').value;

	var currSelectedDate = document.getElementById("Hid_CurrSelectedDate").value;

	var newSelectedDate  = new Date(currSelectedDate); // initially set it to current selected date

	if (context == 'get_next_bookings') {
		newSelectedDate.setDate(newSelectedDate.getDate() + nDays);
	}
	if (context == 'get_prev_bookings') {
		newSelectedDate.setDate(newSelectedDate.getDate() - nDays);
	}
	if (context == 'get_curr_bookings') {

		//newSelectedDate.setDate(todayDate);
	}
	if (context == 'get_bookings') {
		newSelectedDate.setDate(newSelectedDate.getDate());
	}
	if (context == 'get_bookings_by_date') {
		newSelectedDate = new Date(document.getElementById("Inp_SelectedDate").value);
	}

	// set selected date to hidden variable in format dd-MMM-yy
	formBookings.Hid_CurrSelectedDate.value = newSelectedDate.getDate()+'-'+
											  months[newSelectedDate.getMonth()] + "-" +
											 newSelectedDate.getYear();
	formBookings.Hid_Context.value 	= context;
	//alert('Context: ' +context + '\n\n Date: '+formBookings.Hid_CurrSelectedDate.value);
	formBookings.submit();
}

function buildDimmerDiv()
{
    document.write('<div id="dimmer" class="dimmer" style="width:'+ window.screen.width + 'px; height:' + window.screen.height +'px"></div>');
}

//buildDimmerDiv(); //http://www.w3.org/Style/Examples/007/shadows


function submitNewBooking() {
	var formBookings = document.Form_Bookings_Nav;

	if (validateNewBooking()){

		var currSelectedDate = new Date(formBookings.Hid_CurrSelectedDate.value);
		// Set Hid_CuuSelectedDate in dd-MMM-yy
		formBookings.Hid_CurrSelectedDate.value = currSelectedDate.getDate()+'-'+
											      months[currSelectedDate.getMonth()] + "-" +
											      currSelectedDate.getYear();

		document.Form_BookingDtls.submit();
	}
}

function validateNewBooking(){
	var form = document.Form_BookingDtls;

	clearErrorMessages();

	field = form.Txt_ConfName;
	if(field.value == '' || field.value.replace(/^\s+|\s+$/g,"").length == 0) {
		addError('Txt_ConfName', "Please enter 'Conference Name'");
	}

	field = form.TxtArea_ConfDesc;
	field.value = field.value.trim();
	if(field.value.length >50) {
		addError('TxtArea_ConfDesc', "Please enter 'Description' with less than 50 chars");
	}

	field = form.Txt_NumOfAttendees;
	field.value = field.value.trim();

	if(field.value != '' && !isUnsignedInteger(field.value)) {
		addError('Txt_NumOfAttendees', "Please enter valid 'Number Of Attendies'");
	}

	field = form.Txt_ContactNum;
	field.value = field.value.trim();
	
	if(field.value == '' || field.value.length <10) {
		addError('Txt_ContactNum', "Please enter valid 'Contact number'");
	}

	field = form.Txt_Email;
	if(field.value != '' && !validateValue(field.value, "\\b[a-zA-Z][\\d.A-Za-z-_]*@[a-zA-Z0-9._-]+.[a-zA-Z]+\\b")) {
		addError('Txt_Email', "Please enter valid 'E-mail' address");
	}

	if(field.value =='' && form.Chk_EMail.checked) {
		addError('Txt_Email', "Please enter 'E-mail' address to recieve booking details");
	}

	return !fieldErrors;
}

function clearErrorMessages() {
	document.getElementById('Info_Txt_ConfName').innerHTML = '';
	document.getElementById('Lbl_Txt_ConfName').className = '';

	document.getElementById('Info_TxtArea_ConfDesc').innerHTML = '';
	document.getElementById('Lbl_TxtArea_ConfDesc').className = '';

	document.getElementById('Info_Txt_NumOfAttendees').innerHTML = '';
	document.getElementById('Lbl_Txt_NumOfAttendees').className = '';

	document.getElementById('Info_Txt_ContactNum').innerHTML = '';
	document.getElementById('Lbl_Txt_ContactNum').className = '';

	document.getElementById('Info_Txt_Email').innerHTML = '';
	document.getElementById('Lbl_Txt_Email').className = '';

	fieldErrors = false;
}

function addError(fieldName, errorValue){

	document.getElementById('Info_'+ fieldName).innerHTML = errorValue;
	document.getElementById('Info_'+ fieldName).className='fieldError';
	document.getElementById('Lbl_'+ fieldName).className='fieldError';

	fieldErrors = true;
}

 
function hasSplChar(str){
	spchar="`()(\\~!^&*+\"|%:=,<>";

	for (var i = 0; i < str.length; i++) {
		if (spchar.indexOf(str.charAt(i)) != -1) {
			return true;
		}
	}
	return false;
}
 

