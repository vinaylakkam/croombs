function showChartByTimePeriod(timePeriod) {

	var nDays = document.getElementById('nDays').value;
	
	if(timePeriod == 'full_day') {
	
		// display all hours cells
		for (var hour=0; hour<24; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'block';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'block';
		}
		
		// display all booking cells
		for (var halfHour=0; halfHour<48; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
			}
		}			
		
		// hide left and right buttons  
		document.getElementById('left_button').style.display = 'none';
		document.getElementById('right_button').style.display = 'none';		

		// assign onclick function to full/normal day button
		document.getElementById('full_normal_day').value="< 8am to 8pm >";
		document.getElementById('th_full_normal_day').colSpan="49";
		document.getElementById('full_normal_day').onclick = function(){showChartByTimePeriod("am_pm")};		
	}
		
	if(timePeriod == 'am_only') {
	
		// display am only hours (00 to 12pm)
		for (var hour=0; hour<12; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'block';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'block';
		}
		
		// display am only booking cells (00 to 12pm)
		for (var halfHour=0; halfHour<24; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
			}
		}	
				
		// hide pm only hours (12pm to 00am)
		for (var hour=12; hour<24; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'none';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'none';
		}	
		
		// hide pm only booking cells (12pm to 00am)
		for (var halfHour=24; halfHour<48; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
			}
		}	
		
		// hide left (am only) button  
		document.getElementById('left_button').style.display = 'none';

		// show right (am_pm) button  
		document.getElementById('right_button').style.display = 'block';

		// assign onclick function to right button  
		document.getElementById('right_button').onclick = function(){showChartByTimePeriod("am_pm")};
	}

	if(timePeriod == 'am_pm') {
	
		// hide hours from 00 to 8am
		for (var hour=0; hour<8; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'none';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'none';
 		}

		// hide booking cells from 00 to 8am
		for (var halfHour=0; halfHour<16; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
			}
		}
		
		// display hours from 08 to 8pm
		for (var hour=8; hour<20; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'block';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'block';
		}

		// display booking cells from 08 to 8pm
		for (var halfHour=16; halfHour<40; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
			}
		}
		
		// hide hours from 08pm to 00am
		for (var hour=20; hour<24; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'none';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'none';
		}				
		// hide booking cells from 08pm to 00am
		for (var halfHour=40; halfHour<48; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
			}
		}

		// show left (am only) and right (pm only) buttons  
		document.getElementById('left_button').style.display = 'block'; 
		document.getElementById('right_button').style.display = 'block';

		// assign onclick functions
		document.getElementById('left_button').onclick =  function(){showChartByTimePeriod("am_only")};
		document.getElementById('right_button').onclick =  function(){showChartByTimePeriod("pm_only")};

		// assign onclick function to full/normal day button
		document.getElementById('full_normal_day').value="<< >>";
		document.getElementById('th_full_normal_day').colSpan="25";
		document.getElementById('full_normal_day').onclick = function(){showChartByTimePeriod("full_day")};		
							
	}


	if(timePeriod == 'pm_only') {
	
		// hide am only hours 00 to 12pm
		for (var hour=0; hour<12; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'none';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'none';
 		}

		// hide am only booking cells (00 to 12pm)
		for (var halfHour=0; halfHour<24; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'none';
			}
		} 		
		
		// display pm only hours 12pm to 00am
		for (var hour=12; hour<24; hour++) {
			document.getElementById('th_'+hour+'_hour').style.display = 'block';
			document.getElementById('th_'+hour+'_halfhour').style.display = 'block';
		}

		// display pm only hours 12pm to 00am
		for (var halfHour=24; halfHour<48; halfHour++) {
			for (var day=0; day<nDays; day++){
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
				document.getElementById('td_'+day+'_'+halfHour).style.display = 'block';
			}
		}			
		
		// show left (am_pm) button  
		document.getElementById('left_button').style.display = 'block';

		// hide right (pm only) button  
		document.getElementById('right_button').style.display = 'none';

		// assign onclick function to right button  
		document.getElementById('left_button').onclick =  function(){showChartByTimePeriod("am_pm")};			
	}		
}

// Highlights the bookings cells with Yellow colour, when selected
function highlightNewBookingCells(selectedDay, selectedHour) {
	
	//alert(selectedDay+'_'+ prevSelectedDay);
	var selectedHourCell = document.getElementById('td_'+selectedDay+'_'+selectedHour);
	
	// If sleected cell is already booked then just return;
	if(selectedHourCell.isBooked == 'true') return;	

	// If current selected day != previous selected day; Unhighlight selected hours of previously selected day 
	if(prevSelectedDay!='None' && selectedDay != prevSelectedDay ) {
		unhighlightAllBookingsOfTheDay(prevSelectedDay);
	}
	
	// Check if any adjusant booking cells are highlighted otherwise it is a new highlight
	var leftAdjusantCell = document.getElementById('td_'+selectedDay+'_'+ (selectedHour-1));
	var rightAdjusantCell = document.getElementById('td_'+selectedDay+'_'+ (selectedHour+1));
 
	// If adjusant cells are not highlighted; clear the row first
	if((leftAdjusantCell && leftAdjusantCell.isHighlighted!='true') &&
	   (rightAdjusantCell && rightAdjusantCell.isHighlighted!='true')) {
	   unhighlightAllBookingsOfTheDay(selectedDay);
	}

	//highlight selected booking Cell
	selectedHourCell.isHighlighted = 'true';
	selectedHourCell.style.background = '#A6CA04'; // TODO; use css
	
	prevSelectedDay = selectedDay; 	
	
}

// Unhighlights all cells of the day
function unhighlightAllBookingsOfTheDay(day) {

	//alert('unhighlight all hours of the day');

	for (var halfHour=0; halfHour<48; halfHour++) {
		var cell = document.getElementById('td_'+day+'_'+halfHour);
		if( cell.isHighlighted == 'true'){
			cell.style.background = '#fff';
			cell.isHighlighted = 'false';
		}
 	}
}

// Updates cursor position when mousehover on chart table
function updateCursorPosition(e){ 
	if(document.all) {
		//IE
		cX = event.clientX; cY = event.clientY;
	}
	else {
		cX = e.pageX; cY = e.pageY;
	}
}
var cursor = {x:0, y:0};
function getCursorPosition(e) {
    e = e || window.event;
    
    if (e.pageX || e.pageY) {
        cursor.x = e.pageX;
        cursor.y = e.pageY;
    } 
    else { // always here
        var de = document.documentElement;
        var b = document.body;

        /*alert("e.clientX:"+e.clientX +
        	  "\nde.scrollLeft:"+de.scrollLeft +
        	  "\nb.scrollLeft:"+b.scrollLeft +
        	  "\nde.clientLeft:"+de.clientLeft +
        	  "\nde.clientRight:"+de.clientRight +
        	  "\nscreen.width:"+screen.width +
        	  "\nscreen.width:"+screen.height );*/
        	  
        cursor.x = e.clientX + 
            (de.scrollLeft || b.scrollLeft) - (de.clientLeft || 0);
        cursor.y = e.clientY + 
            (de.scrollTop || b.scrollTop) - (de.clientTop || 0);
    }
    return cursor;
}

// Displays conference details call out 
function showConfDtlsCallOut(confName, confDesc, startTime, endTime, noOfAttn, bookedByUserId, bookedByName, contactNum) {

	if(dragState == true)
		return;
	
	// find x, y  coordinates to display the callout. 
	if(document.all){
		availW = document.body.clientWidth;
		availH = document.body.clientHeight;
	}
	else{
		availW = innerWidth; availH = innerHeight;
	}	
	var finalX = (cursor.x + 150 > availW)? cursor.x - 170: cursor.x;
	var finalY = (cursor.y + 150 > availH)? cursor.y - 170: cursor.y;

	// set position and display
	var callOut = document.getElementById('div_confDtls_callout');
	callOut.style.left = finalX + "px";
	callOut.style.top = finalY + "px";
	callOut.style.display = 'block';
	
	// populate values in call out
	document.getElementById("call_conf_name").innerHTML = confName + "  ";
	document.getElementById("call_conf_time").innerHTML = startTime + " to " + endTime;
	//document.getElementById("call_td_conf_desc").innerHTML = ": " + confDesc;
	document.getElementById("call_no_of_atten").innerHTML = noOfAttn + " Attendees ";
	
	document.getElementById("call_name").innerHTML = bookedByName + "  ";
	document.getElementById("call_user_id").innerHTML = "Emp# " + bookedByUserId + "  ";;
	document.getElementById("call_contact").innerHTML = "Ph: " + contactNum + "  ";;
}

// Hides conference details call out
function hideConfDtlsCallOut(){
	document.getElementById('div_confDtls_callout').style.display = 'none';
}

// Unhighlights highlighted cells on rightclick on the booking chart 
function onrightclick(e) {
	
	if(!(document.all && window.event.button==2) &&
		!(document.layers && e.which==3)) {
		//if not rightclicked then return
		return false; 
	}

	if(prevSelectedDay != 'None') {
		unhighlightAllBookingsOfTheDay(prevSelectedDay);
		prevSelectedDay = 'None';

		// hide booking banner
		banner = document.getElementById('div_booking_banner');
		banner.innerHTML = '';
		banner.style.display = 'none';	
	}
	
	rtClickFlag = true;
	return true; 
}
var rtClickFlag = false;
var dragState = false;

function initDragSelection(day, hour) {
	//alert('in initDragSelection()');
	
	// If it is a right click selection; stop dragging state
	if(rtClickFlag == true) {
		//alert('rightclick found');
		dragState = false;
		rtClickFlag = false;
		return false;
	}
 
	// set dragState
	dragState = true;
	
	// highlight the cell
	highlightNewBookingCells(day, hour); 
	
	//alert('in initDragSelection():dragState:' + dragState);
}

function continueDragSelection(day, hour) {

	// if in dragging state continue highlighting
	if (dragState == true) {
		if (prevSelectedDay == day) {
			highlightNewBookingCells(day, hour);
		}
		else {
			dragState = false;
		}
	}
}

function endDragSelection() {
	// end dragstate
	dragState = false;
}