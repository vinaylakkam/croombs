var fieldErrors = false;

function initializePage(){
	commonInit();
	loginInit();
}

function editDetails(type) {

	getById('div_'+type+'_view').style.display = 'none';
	getById('div_'+type+'_edit').style.display = 'block';

	getById('span_edit_'+type).innerHTML= 'Cancel editing';
	getById('a_edit_'+type).onclick= function(){cancelEdit(type)};

	getById('span_'+type+'_save_status').innerHTML = '';
}

function cancelEdit(type) {
	getById('div_'+type+'_edit').style.display = 'none';
	getById('div_'+type+'_view').style.display = 'block';

	getById('span_edit_'+type).innerHTML= 'edit';
	getById('a_edit_'+type).onclick= function(){editDetails(type)};
	
	// clear if any errors on fields
	clearErrorMessages();
	
	// populate edit details back with original values
	populateEditDetails(type)
}

function validateMyProfile(type){
	var form = document.Form_MyAccount;

	clearErrorMessages();

	if(type == 'login') {
		var password1 = form.Txt_Password.value;
		var password2 = form.Txt_Password2.value;
		if( (password1 != password2)) {
			addError('Txt_Password', "Passwords don't match. Please re-enter.");

		}
	}

	if(type == 'personal') {
		field = form.Txt_Name;
		field.value = field.value.trim();

		if(field.value == '') {
			addError('Txt_Name', "Please enter valid 'Name'");
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
	}
}

function clearErrorMessages() {

	getById('Info_Txt_Password').innerHTML = '';
	getById('Lbl_Txt_Password').className = '';

	getById('Info_Txt_Name').innerHTML = '';
	getById('Lbl_Txt_Name').className = '';

	getById('Info_Txt_ContactNum').innerHTML = '';
	getById('Lbl_Txt_ContactNum').className = '';

	getById('Info_Txt_Email').innerHTML = '';
	getById('Lbl_Txt_Email').className = '';

	fieldErrors = false;
}

function addError(fieldName, errorValue){

	getById('Info_'+ fieldName).innerHTML = errorValue;
	getById('Info_'+ fieldName).className='fieldError';
	getById('Lbl_'+ fieldName).className='fieldError';

	fieldErrors = true;
}

function saveDetails(type) {

	// validate fields before submit
	validateMyProfile(type);
	
	//alert('fieldErrors:' + fieldErrors);
	
	if(fieldErrors) return;
	
	var dataToSend;
	if( type == 'login') {
		dataToSend = "Hid_Context=save_login" +
					 "&userId=" + userProfileObj.userId+
					 "&password=" + get('Txt_Password');
	}
	if( type == 'personal') {
		dataToSend = "Hid_Context=save_personal" +
					 "&userId=" + userProfileObj.userId+
					 "&name=" + get('Txt_Name')+
					 "&contactNum=" + get('Txt_ContactNum')+
					 "&email=" + get('Txt_Email');
	}
	if( type == 'preferences') {
		dataToSend = "Hid_Context=save_preferences" +
					 "&userId=" + userProfileObj.userId+
					 "&defRoom=" + get('Opt_DefRoom')+
					 "&defNDays=" + get('Opt_DefDays');
	}

	var url = protocol+ '://'+ server+ ':' + port + '/' + appName + '/MyProfile';
	
	// send async ajax request to save details
	postDataGetText(url, dataToSend , savedDetails);

	// show saving...
	getById('span_'+type+'_save_status').innerHTML = '<span style="color:brown; font-weight:bold">Saving...</span>';

	// hide details till response comes;
	getById('div_'+type+'_edit').style.display = 'none';
	getById('span_edit_'+type).innerHTML = '';
	
}

function savedDetails(responseText){

	var respParams = responseText.split('_');
	var type = respParams[2];
	
	//alert(respParams);

	if(respParams[0] == 'true') {
		//saved successfully
		getById('span_'+type+'_save_status').innerHTML = '<span style="color:green; font-weight:bold">Saved.</span>';
	}
	else {
		//save failed;
		getById('span_'+type+'_save_status').innerHTML = '<span style="color:red; font-weight:bold">Save Failed.</span>';
	}

	// display latest details in view
	populateViewDetails(type);

	// show edit again
	getById('span_edit_'+type).innerHTML= 'edit';
	getById('a_edit_'+type).onclick= function(){editDetails(type)};

}

function populateViewDetails(type) {

	getById('div_'+type+'_view').style.display = 'block';
	if (type == 'personal') {
		getById('view_name').innerHTML 		  = get('Txt_Name');
		getById('view_contact_num').innerHTML = get('Txt_ContactNum');
		getById('view_mail').innerHTML 		  = get('Txt_EMail');
	}
	if (type == 'preferences') {
		getById('view_def_roomid').innerHTML = getById('Opt_DefRoom').text;
		getById('view_def_ndays').innerHTML  = getById('Opt_DefDays').text;
	}
}

function populateEditDetails(type) {

	//getById('div_'+type+'_view').style.display = 'block';
	
	if (type == 'login') {
		getById('Txt_Password').value = '';
		getById('Txt_Password2').value = '';
	}
	if (type == 'personal') {
		getById('Txt_Name').value 		= getById('view_name').innerHTML;
		getById('Txt_ContactNum').value = getById('view_contact_num').innerHTML;
		getById('Txt_EMail').value 		= getById('view_mail').innerHTML;
	}
	if (type == 'preferences') {
		getById('Opt_DefRoom').text = getById('view_def_roomid').innerHTML;
		getById('Opt_DefDays').text = getById('view_def_ndays').innerHTML ;
	}
}

function get(elmtId) {
	return getById(elmtId).value;
}

function submitForm(context)
{
	document.Form_MyAccount.Hid_Context.value = context;
	document.Form_MyAccount.submit();
}