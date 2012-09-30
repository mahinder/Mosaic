/*
 * Datepicker
 * Thanks to sbkyle! http://themeforest.net/user/sbkyle
 */

$('#pickerfield1').datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'dd-mm-yyyy'
});

$('.timepicker').datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'dd-mm-yyyy',
});


$('#pickerfield2').datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'dd-mm-yyyy'
});
$('.datepicker').datepick({

	alignment : 'bottom',
	showOtherMonths : true,
	selectOtherMonths : true,
	dateFormat : 'dd-mm-yyyy',
	yearRange : '1940:2100',
	renderer : {
		picker : '<div class="datepick block-border clearfix form"><div class="mini-calendar clearfix">' + '{months}</div></div>',
		monthRow : '{months}',
		month : '<div class="calendar-controls" style="white-space: nowrap">' + '{monthHeader:M yyyy}' + '</div>' + '<table cellspacing="0">' + '<thead>{weekHeader}</thead>' + '<tbody>{weeks}</tbody></table>',
		weekHeader : '<tr>{days}</tr>',
		dayHeader : '<th>{day}</th>',
		week : '<tr>{days}</tr>',
		day : '<td>{day}</td>',
		monthSelector : '.month',
		daySelector : 'td',
		rtlClass : 'rtl',
		multiClass : 'multi',
		defaultClass : 'default',
		selectedClass : 'selected',
		highlightedClass : 'highlight',
		todayClass : 'today',
		otherMonthClass : 'other-month',
		weekendClass : 'week-end',
		commandClass : 'calendar',
		commandLinkClass : 'button',
		disabledClass : 'unavailable',
		yearsRange : new Array(1971, 2100),
	}

});
function modal_box_datepicker(){
$('#modal .modal_date_picker').datepick({
	alignment : 'bottom',
	showOtherMonths : true,
	selectOtherMonths : true,
	dateFormat : 'dd-mm-yyyy',
	yearRange : '1940:2100',
	renderer : {
		picker : '<div class="datepick block-border clearfix form" style="position: fixed;"><div class="mini-calendar clearfix">' + '{months}</div></div>',
		monthRow : '{months}',
		month : '<div class="calendar-controls" style="white-space: nowrap">' + '{monthHeader:M yyyy}' + '</div>' + '<table cellspacing="0">' + '<thead>{weekHeader}</thead>' + '<tbody>{weeks}</tbody></table>',
		weekHeader : '<tr>{days}</tr>',
		dayHeader : '<th>{day}</th>',
		week : '<tr>{days}</tr>',
		day : '<td>{day}</td>',
		monthSelector : '.month',
		daySelector : 'td',
		rtlClass : 'rtl',
		multiClass : 'multi',
		defaultClass : 'default',
		selectedClass : 'selected',
		highlightedClass : 'highlight',
		todayClass : 'today',
		otherMonthClass : 'other-month',
		weekendClass : 'week-end',
		commandClass : 'calendar',
		commandLinkClass : 'button',
		disabledClass : 'unavailable',
		yearsRange : new Array(1971, 2100),
	}
});
}

function ajaxCreate(target, data, successFunction, submitBt) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				//individual domain need to implement this method
				successFunction(data);
				submitBt.enableBt();
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				submitBt.enableBt();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
	submitBt.enableBt();
}

function ajaxUpdate(remoteUrl, data, successFunction, submitBt) {
	$.ajax({
		url : remoteUrl,
		type : 'put',
		dataType : 'json',
		data : data, // it should have '_method' : 'put'
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				//individual domain need to implement this method
				successFunction(data);
				//populateTables();
				submitBt.enableBt();
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				submitBt.enableBt();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});
	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

function confirmDelete(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDelete(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDelete(remoteUrl, table, row) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				var dataTable = table.dataTable();
				dataTable.fnDeleteRow(row.index());

				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				
			} else {
				
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

function getErrorText(errors) {
	var message = "There are errors while processing your request<br/>";
	$.each(errors, function(key, value) {
		message = message + '<strong>' + key + '</strong> : ';
		$.each(value, function(index, arrayVal) {
			message = message + arrayVal + " "
		});
		message = message + "<br/>"
	});
	return message;
}

function populateTables() {
	var remoteUrl = $('#url_prefix').val();
	$.ajax({
		url : remoteUrl,
		success : function(data) {
			$('#').empty();
			$('#table-block').html(data);
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});
}

// numeric validation
// $('.numeric').keyup(function() {
	// $(this).removeClass("error");
	// $('#outer_block').removeBlockMessages()
	// var inputVal = $(this).val();
	// var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	// if(inputVal != "" && !numericReg.test(inputVal)) {
		// $(this).addClass("error");
		// $('#outer_block').removeBlockMessages().blockMessage('Please enter a numeric value', {
			// type : 'warning'
		// });
	// }
// });

$(document).on("keyup", ".special_char", function(event) {
	$(this).removeClass("error");
	$('#outer_block').removeBlockMessages()
	var inputVal = $(this).val();
	var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;

	if(inputVal != "" && !characterReg.test(inputVal)) {
		$(this).addClass("error");
		$('#outer_block').removeBlockMessages().blockMessage('Please enter a  value without special character', {
			type : 'warning'
		});
	}

});
$(document).on("keyup", ".special_char1", function(event) {
	$(this).removeClass("error");
	$('#modal #outer_block').removeBlockMessages()
	var inputVal = $(this).val();
	var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;

	if(inputVal != "" && !characterReg.test(inputVal)) {
		$(this).addClass("error");
		$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter a  value without special character', {
			type : 'warning'
		});
	}

});
$('.numeric1').keyup(function() {
	$(this).removeClass("error");
	$('#modal #outer_block').removeBlockMessages()
	var inputVal = $(this).val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	if(inputVal != "" && !numericReg.test(inputVal)) {
		$(this).addClass("error");
		$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter a numeric value', {
			type : 'warning'
		});
	}
});
//phone validation
// function phone_validation() {
	// var phone = null;
	// $(".phone").each(function() {
		// var inputVal = $(this).val();
		// var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		// var phone_format = /^(\+\d)*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2}$/;
		// if(inputVal != 0) {
			// if(inputVal.length < 7 || inputVal.length > 11 || !numericReg.test(inputVal)) {
				// phone = 'invalid';
			// }
		// }
	// });
	// return phone;
// }

// pincode validation
// function pincode_validation() {
	// var valid_pincode = null;
	// $(".pincode").each(function() {
		// var inputVal = $(this).val();
		// if(inputVal != 0) {
			// var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
			// if(inputVal.length > 6 || !numericReg.test(inputVal)) {
				// valid_pincode = false;
			// }
		// }
	// });
	// return valid_pincode;
// }

function text_validation() {
	var input = null;
	$(".class").each(function() {
		var inputVal = $(this).val();
		if(inputVal != 0) {
			if(inputVal.length > 25 || inputVal.length < 2) {
				input = 'invalid';
			}
		}
	});
	return input;
}
//special character
$(document).on("click", ".back", function(event) {
	$(document).ready(function() {
   var referrer =  document.referrer;
   window.location.href = referrer
});
})

//back_button
$(function() {
  $("#click").click(function(e){
    history.back();
  });
});




//=============================================================Shakti ToolTip======================================//

$(document).ready(function(){
$(function()
{
  var hideDelay = 500;  
  var currentID;
  var hideTimer = null;

  // One instance that's reused to show info for the current person
  var container = $('<div id="personPopupContainer">'
      + '<table width="" border="0" cellspacing="0" cellpadding="0" align="center" class="personPopupPopup">'
      + '<tr>'
      + '   <td class="corner topLeft"></td>'
      + '   <td class="top"></td>'
      + '   <td class="corner topRight"></td>'
      + '</tr>'
      + '<tr>'
      + '   <td class="left">&nbsp;</td>'
      + '   <td><div id="personPopupContent"></div></td>'
      + '   <td class="right">&nbsp;</td>'
      + '</tr>'
      + '<tr>'
      + '   <td class="corner bottomLeft">&nbsp;</td>'
      + '   <td class="bottom">&nbsp;</td>'
      + '   <td class="corner bottomRight"></td>'
      + '</tr>'
      + '</table>'
      + '</div>');

  $('.bodyClass').append(container);

  $('.personPopupTrigger').live('mouseover', function()
  {
      // format of 'rel' tag: pageid,personguid
      var settings = $(this).attr('rel').split(',');
       var id = $(this).attr('id');
      var pageID = settings[0];
      currentID = settings[1];

      // If no guid in url rel tag, don't popup blank
      if (currentID == '')
          return;

      if (hideTimer)
          clearTimeout(hideTimer);

      var pos = $(this).offset();
      var width = $(this).width();
      container.css({
          left: (pos.left - width - 200) + 'px',
          top: pos.top - 250 + 'px'
      });

      $('#personPopupContent').html('&nbsp;');

      $.ajax({
          type: 'GET',
          url: '/sessions/get_my_batch_birth_day_list',
          datatype: 'html',
          async: false,
          data: 'id=' + id + '&guid=' + currentID,
          success: function(data)
          {
              // Verify that we're pointed to a page that returned the expected results.
              // if (data.indexOf('personPopupResult') < 0)
              // {
                  $('#personPopupContent').html('<span >Page ' + pageID + ' did not return a valid result for person ' + currentID + '.<br />Please have your administrator check the error log.</span>');
              // }

              // Verify requested person is this person since we could have multiple ajax
              // requests out if the server is taking a while.
              // if (data.indexOf(currentID) > 0)
              // {                  
                  var text = $(data).find('.personPopupResult').html();

                  $('#personPopupContent').html(data);
              // }
          }
      });

      container.css('display', 'block');
  });

  $('.personPopupTrigger').live('mouseout', function()
  {
      if (hideTimer)container
          clearTimeout(hideTimer);
      hideTimer = setTimeout(function()
      {
          container.css('display', 'none');
      }, hideDelay);
  });

  // Allow mouse over of details without hiding details
  $('#personPopupContainer').mouseover(function()
  {
      if (hideTimer)
          clearTimeout(hideTimer);
  });

  // Hide after mouseout
  $('#personPopupContainer').mouseout(function()
  {
      if (hideTimer)
          clearTimeout(hideTimer);
      hideTimer = setTimeout(function()
      {
          container.css('display', 'none');
      }, hideDelay);
  });
});
});

function waitings_modal(){
		$.modal({
		content : 'Please wait while your request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />',
		});
		$('.action-tabs').hide();
}
$(document).on("click","#upload_school_data",function(event){
	waitings_modal()
}); 

