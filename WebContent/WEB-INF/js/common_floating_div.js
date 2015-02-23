var isMozilla;
var objDiv = null;
var divID = "";
var mouseOver = false;
isMozilla = (document.all) ? 0 : 1;


function displayAsFloatable(divId, headerTitle, closeButton, dim) {
	
	var div = document.getElementById(divId); 
	
	div.onmousedown = onMouseDown;
	div.onmousemove = onMouseMove;
	div.onmouseup = onMouseUp;
    
    if(headerTitle != undefined) {
    
 	    // dimensions
 	    div.style.width = dim.width + 'px';
	    div.style.height = dim.height + 'px';
	    div.style.left = dim.left + 'px';
	    div.style.top = dim.top + 'px';
	    
		existingHeader = document.getElementById(divId + '_header');
		if(existingHeader) {
			//delete header, if already exists
			existingHeader.parentNode.removeChild(existingHeader);
		}
		
		var closeButtonTD='';
		if(closeButton){
			closeButtonTD='<td style="width:18px" align="right">'+
								'<a href="javascript:hiddenFloatingDiv(\'' + divId + '\');void(0);">' +
     								'<img alt="Close..." title="Close..." src="close.jpg" border="0">' +
     							'</a>'+
     						'</td>';
     	}
		
		var header = '<table id="'+divId+'_header" style="width:'+ dim.width + 'px" class="floatingHeader">' +
	            			'<tr>' +
	            				'<td style="cursor:move;height:18px;" align="center" colspan="2" ondblclick="void(0);" onmouseover="mouseOver=true;" onmouseout="mouseOver=false;" colspan="2">' +
	            					headerTitle +
	            				'</td>' + closeButtonTD +
 	            			'</tr>' +
	            		'</table>';

		// add header to the div
		div.innerHTML = header + div.innerHTML;
	}
	
	div.className='floatableDiv';
	div.style.display='block';
	divID = divId;
 
}
if (isMozilla) {
    document.captureEvents(Event.MOUSEDOWN | Event.MOUSEMOVE | Event.MOUSEUP);
}

function onMouseDown(e) {

	//alert(divID + " divID"); 
    if (mouseOver)
    {
        if (isMozilla) {
            objDiv = document.getElementById(divID);
            X = e.layerX;
            Y = e.layerY;
            return false;
        }
        else {
            objDiv = document.getElementById(divID);
            objDiv = objDiv.style;
            X = event.offsetX;
            Y = event.offsetY;
        }
    }
}

function onMouseMove(e) {
    if (objDiv) {
        if (isMozilla) {
            objDiv.style.top = (e.pageY-Y) + 'px';
            objDiv.style.left = (e.pageX-X) + 'px';
            return false;
        }
        else
        {
            objDiv.pixelLeft = event.clientX-X + document.body.scrollLeft;
            objDiv.pixelTop = event.clientY-Y + document.body.scrollTop;
            return false;
        }
    }
}

function onMouseUp() { objDiv = null;}
function onMouseOver() { mouseOver = true;}
function onMouseOut() { mouseOver = false;}
