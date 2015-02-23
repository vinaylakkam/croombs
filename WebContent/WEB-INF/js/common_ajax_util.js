// Create XMLHttpRequest object
function createXMLHttpRequestObject(){

	var XMLHttpRequestObject = false;
 

            if (!XMLHttpRequestObject) {
                        if (window.XMLHttpRequest) {
                                    XMLHttpRequestObject = new XMLHttpRequest();
 
                                    if(XMLHttpRequestObject.overrideMimeType) {
                                                alert('XMLHttpRequestObject.overrideMimeType');
                                                XMLHttpRequestObject.overrideMimeType('text/xml');
                                    }
 
                        }
                        else if (window.ActiveXObject) {
                                    XMLHttpRequestObject = new ActiveXObject("Microsoft.XMLHTTP");
                        }
            }
 
            return XMLHttpRequestObject;
}
 
/*****************************************************************/
 
// To get the text from server using 'GET' method
function getText(urlToCall, functionToCallBack) {
            getTextOrXML(urlToCall, functionToCallBack, 'text');
}
 
// To get the XML from server using 'GET' method
function getXML(urlToCall, functionToCallBack) {
            getTextOrXML(urlToCall, functionToCallBack, 'XML');
}
 
// To get the text from server using 'POST' method
function postDataGetText(urlToCall, dataToSend, functionToCallBack) {
            postDataGetTextOrXML(urlToCall, dataToSend, functionToCallBack, 'text');
}
 
// To get the XML from server using 'POST' method
function postDataGetXml(urlToCall, dataToSend, functionToCallBack) {
            postDataGetTextOrXML(urlToCall, params, dataToSend, functionToCallBack, 'XML');
}
 
 
/*****************************************************************/
 
// To get the text/xml from server using 'GET' method
function getTextOrXML(urlToCall, functionToCallBack, textOrXML){
 
            // create XMLHttpRequest object
            var XMLHttpRequestObject = createXMLHttpRequestObject();
 
            // if XMLHttpRequest object is not created return;
            if(!XMLHttpRequestObject) {
                        alert("XMLHttpRequest object is not created!!!")
                        return;
            }
 
            // open XMLHttpRequest with method and URL
            XMLHttpRequestObject.open("GET", urlToCall, true);
 
            // handle state change of XMLHttpRequest
            XMLHttpRequestObject.onreadystatechange = function() {
 
                        // on return of OK response from server
                        if (XMLHttpRequestObject.readyState == 4 &&     XMLHttpRequestObject.status == 200) {
 
                                    // call the callback function specified
                                    if (textOrXML == 'text') {
                                                // pass response text to callback function
                                                functionToCallBack(XMLHttpRequestObject.responseText);
                                    }
                                    else if (textOrXML == 'XML'){
                                                // pass response XML to callback function
                                                functionToCallBack(XMLHttpRequestObject.responseXML);
                                    }
 
                                    // delete XMLHttpReqeust object
                                    delete XMLHttpRequestObject;
 
                                    // set null to XMLHttpRequest object
                                    XMLHttpRequestObject = null;
                        }
            }
 
            // send XMLHttpRequest
            XMLHttpRequestObject.send(null);
}
 
/*****************************************************************/
 
 
// To get the text/xml from server using 'POST' method
function postDataGetTextOrXML(urlToCall, dataToSend, functionToCallBack, textOrXML) {
 
            // create XMLHttpRequest object
            var XMLHttpRequestObject = createXMLHttpRequestObject();
 
            // if XMLHttpRequest object is not created return;
            if(!XMLHttpRequestObject) {
                        alert("XMLHttpRequest object is not created!!!")
                        return;
            }
 
            // open XMLHttpRequest with method and URL
            XMLHttpRequestObject.open("POST", urlToCall, true);
 
            // set Content-Type header
            XMLHttpRequestObject.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
 
            // handle state change of XMLHttpRequest
            XMLHttpRequestObject.onreadystatechange = function() {
 
                        // on return of OK response from server
                        if (XMLHttpRequestObject.readyState == 4 &&     XMLHttpRequestObject.status == 200) {
 
                                    // call the callback function specified
                                    if (textOrXML == 'text') {
                                                // pass response text to callback function
                                                functionToCallBack(XMLHttpRequestObject.responseText);
                                    }
                                    else if (textOrXML == 'XML'){
                                                // pass response XML to callback function
                                                functionToCallBack(XMLHttpRequestObject.responseXML);
                                    }
 
                                    // delete XMLHttpReqeust object
                                    delete XMLHttpRequestObject;
 
                                    // set null to XMLHttpRequest object
                                    XMLHttpRequestObject = null;
                        }
            }
 
            // send XMLHttpRequest
            XMLHttpRequestObject.send(dataToSend);
 
}
 