var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
	
function commonInit() {

// data variables (fetched from defined in common.jsp)
	protocol = document.getElementById("data_protocol").value;
	server 	 = document.getElementById("data_server").value;
	port 	 = document.getElementById("data_port").value;
	appName  = document.getElementById("data_app_name").value;
}

String.prototype.trim = function() {
	a = this.replace(/^\s+/, '');
	return a.replace(/\s+$/, '');
}

function isUnsignedInteger(s) {
	return (s.toString().search(/^[0-9]+$/) == 0);
}

function validateValue(strValue, strMatchPattern) {
    var objRegExp = new RegExp(strMatchPattern);
    return objRegExp.test(strValue);
}

function getById(elementId) {
	return document.getElementById(elementId);
}
