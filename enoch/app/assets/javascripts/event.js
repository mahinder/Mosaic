
var local_variable = null;

var updateEventTable= function(data) {
	$.get('/event', function(data) {

	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
}

var modalBoxEvent = ""
function showEventInModalBox(data){
	modalBoxEvent= $.modal({
		content: data,
		width : 700,
		title : "Event List",
		maxHeight: 300,
		buttons : {
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
	return modalBoxEvent;
}
$(document).on('click' ,'.event_red',function(event) {
	local_variable = 0;
	var target = 'calendars/event_view' + '?id=' + $(this).attr('id')
	$.get(target, {for_holiday: "true"},function(data){
		showEventInModalBox(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).on('click' ,'.showUserEvents',function(event) {
	local_variable = 0;
	var target = 'calendars/event_view' + '?id=' + $(this).attr('id')
	$.get(target, {user_event: "true"},function(data){
		showEventInModalBox(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).on('click' ,'.event_blue',function(event) {

	var target = 'calendars/event_view' + '?id=' + $(this).attr('id')
	$.get(target, {for_Exam: "true"},function(data){
		showEventInModalBox(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).on('click' ,'.event_orange',function(event) {

	var target = 'calendars/event_view' + '?id=' + $(this).attr('id')
	$.get(target,{fees_event: "true"}, function(data){
		showEventInModalBox(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).on('click' ,'.my_red_class',function(event) {
	event.preventDefault();
	var target = $(this).attr('href')
	$.get(target,{is_holiday: "true"}, function(data){
		showEventInModalBox(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).on('click' ,'.not_holiday_event',function(event) {
	event.preventDefault();
	var target = $(this).attr('href');
	$.get(target,{not_holiday: "true"}, function(data){
		showEventInModalBox(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).ready(function(){
	$("#update_batch_tree").toggle();
	$('.un-selectedDepart input').attr('checked', false);
	$('.checkedss input').attr('checked', false);

});


$(document).on("click", "#selects_course", function(event) {
	event.preventDefault();
	var contents = $("#modal-boxsupdate_batch_tree");
	$.modal({
		content : contents,
		title : 'Batch & Department',
		width : 700,
		buttons : {
			'Save' : function(win) {
				createBatchAndDepartmentEvent(win);    
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
});
function createBatchAndDepartmentEvent(win){

   var allVals = []
		$("input:checkbox[classs=selected_batches]:checked").each(function(){
			allVals.push($(this).val());
	});
    var allDepartment = []
		$("input:checkbox[classs=employee_departmentss]:checked").each(function(){
			allDepartment.push($(this).val());
	});
	var id = $('#Event_id').val();
	var data = {
				'select_options[batch_id]' : allVals,
				'select_options[department_id]' : allDepartment,
				'id' : id
			}

	var target = '/event/course_event'

       $.ajax({
				url : target,
				dataType : 'json',
				data : data,
				success : function(data1) {
					if(data1.valid) {
						$('#outer_block').removeBlockMessages().blockMessage(data1.notice, {
							type : 'success'
						});
						win.closeModal();
						window.location.reload();
					} else {
						var errorText = getErrorText(data1.errors);
						$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
							type : 'error'
						});
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
				    if (jqXHR.status === 403) {
				        window.location.href = "/signin"
				    }else{
						$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
							type : 'error'
						});	
					}	
				}
			});
}


$(document).on("click", ".checkeds", function(event) {
$('.checkeds input').attr('checked', true);
	var active = $(this).find("input").attr("ids");
     var event_id = $('#Event_id').val();
        var target = '/event/remove_batch'	+ '?id='  +  event_id
        
        $.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a batch...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				     $.get(target, {event_id: event_id, batch_id: active}, function(data){
			        	 $('#outer_block').removeBlockMessages().blockMessage("Event deleted for the batch", {
							 type : 'success'
						 });
				      window.location.reload()

			        }).error(function(jqXHR, textStatus, errorThrown) { 
				        window.location.href = "/signin"
					});
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});

        $('#update_batch_tree').show();
	
});

$(document).on("click", ".selectedDepart", function(event) {
$('.selectedDepart input').attr('checked', true);
	var active = $(this).find("input").attr("id_dep");
     var event_id = $('#Event_id').val();
        var target = '/event/remove_department'	+ '?id='  +  event_id
        
        $.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a department...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				      $.get(target, {event_id: event_id, employee_department_id: active}, function(data){
				        	 $('#outer_block').removeBlockMessages().blockMessage("Event deleted for the department", {
								 type : 'success'
							 });
					      window.location.reload();
				        }).error(function(jqXHR, textStatus, errorThrown) { 
					        window.location.href = "/signin"
						});	 
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});

        $('#update_batch_tree').show();
});


$(document).on("click", "#Create_school_event",function(data){

  var event_title = $("#events_title").val();
  var event_description = $("#events_description").val();
  var event_start_date = $("#pickerfield1").val();
  var event_end_date = $("#pickerfield2").val();
  var charactercheck = characterLength()
  var special_character = isSpclChar();
  var stringReg = /^[a-zA-Z() ]*$/
   // if(!stringReg.test(event_title)) {
      // $('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Event Title', {
        // type : 'warning'
      // });
    // return false;
  // }
    if(charactercheck[0] == false) {
      $('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+charactercheck[1], {
        type : 'warning'
      });
      return false;
  }
  if(!event_title || event_title.length == 0) {
      $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Event Title', {
        type : 'warning'
      });
      return false;
  }
  if(!event_description || event_description.length == 0) {
      $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Event Description', {
        type : 'warning'
      });
      return false;
  }
  if(!event_start_date || event_start_date.length == 0) {
      $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Event Start Date', {
       type : 'warning'
      });
      return false;
  }
  if(!event_end_date || event_end_date.length == 0) {
      $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Event End Date', {
        type : 'warning'
      });
      return false;
  }
  // if(special_character[0] == false) {
      // $('#outer_bloc').removeBlockMessages().blockMessage('Special Charcter are not allowed in Event Title', {
      // type : 'warning'
      // });
      // return false;
    // }
});


function configureEventBatchDepartmentTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix no-margin"lf>',
		fnDrawCallback : function() {
			this.parent().applyTemplateSetup();
		},
		fnInitComplete : function() {
			this.parent().applyTemplateSetup();
		}
	});
	table.find('thead .sort-up').click(function(event) {
		event.preventDefault();
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		oTable.fnSort([[columnIndex, 'asc']]);
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		event.preventDefault();
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		oTable.fnSort([[columnIndex, 'desc']]);
		return false;
	});
};

$('.eventsBatchDepartment').each(function(i) {
	configureEventBatchDepartmentTable($(this));
});



$(document).on('click',"#delete_event",function(event){
	var id = $(this).attr('data-id');
		$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				deleteEvent(id,win);
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});

});


function deleteEvent(id,win){
    $.get("/calendars/event_delete/"+id,function(data){
		
	}).success(function(){
		window.location.reload();
		win.closeModal();
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
}

$('#smsatevent').attr('checked',false)
$(document).on("click","#ConfirmEvent", function(event){
		$.modal({
		content : 'Please wait while messages are being sent ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />',
		});
		$('.action-tabs').hide();
});


//####################################################################################################// 
//===========================================MY Event=================================================//
//####################################################################################################// 


$(document).on("click" ,".add-event", function(event) {
      local_variable = 0;
});
$(document).on("click" , ".event_red", function(event) {
      local_variable = 0;
});
$(document).on("click" ,".event_orange", function(event) {
      local_variable = 0;
});
$(document).on("click" ,".events",function(event) {
     local_variable = 0;
});
$(document).on("click" ,".showUserEvents",function(event) {
     local_variable = 0;
});
$(document).on('click' ,'.event_blue',function(event) {
	     local_variable = 0;
});

$(document).on("click",".add_my_event",function(event){
if(blockDoubleClick != true){
	blockDoubleClick = true;	
    if(local_variable==null){
    	var anchorTag = $(this).find('a');
	    if(anchorTag.length!= 0){
	    	var dateId = anchorTag.attr('dateId')
	    	$.get("/event/view_my_event_form",{aTag : dateId}, function(data){
		    	$.modal({
				content : data,
				title : 'My Event',
				width : 700,
				buttons : {
					'Create' : function(win) {
						var title = $("#modal #event_title").val();
						var description = $("#modal #event_description").val();
						var start_date = $("#modal #add_pickerfield1").val();
						var end_date = $("#modal #add_pickerfield2").val();
						var inputData = {
							'title' :title,
							'description' :description,
							'start_date' : start_date,
							'end_date' : end_date
						}
						var target = "/event/user_event/"+dateId
					  var charactercheck = characterLength()
					  var special_character = isSpclChar();
					  var stringReg = /^[a-zA-Z() ]*$/
					
					    if(charactercheck[0] == false) {
					      $('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+charactercheck[1], {
					        type : 'warning'
					      });
					      return false;
					  }
					  if(!title || title.length == 0) {
					      $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Event Title', {
					        type : 'warning'
					      });
					      return false;
					  }
					  if(!description || description.length == 0) {
					      $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Event Description', {
					        type : 'warning'
					      });
					      return false;
					  }			
						createMyEvent(target,win,inputData);
						local_variable=null;
						},
					'Close' : function(win) {
						win.closeModal();
						local_variable=null;
						blockDoubleClick = false;
						}
					}
				});
				dateTimePick();
	    	}).error (function(jqXHR, textStatus, errorThrown){
		         window.location.href = "/signin"
		    }).complete(function(jqXHR){
				blockDoubleClick = false;
			});
		}
    }else{
    	local_variable =null;
    }
  }
});

function createMyEvent(aTag,win,inputData){
	$.ajax({
		url : aTag,
		dataType : 'json',
		type : 'post',
		data : inputData,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				//individual domain need to implement this method
				$.get("/calendars/myEventView", function(data){
					$("#calendar").empty();
					$("#calendar").html(data);
				}).complete(function(){
					win.closeModal();
					$('#outer_blocks').removeBlockMessages().blockMessage(data.notice, {
						type : 'success'
					});
				})
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
	
}


$(document).on("click","#edit_event_of_self",function(event){
	event.preventDefault();
	var id = $(this).attr('data-id');
	$.get("/calendars/"+id+"/edit", function(data){
		$.modal({
				content : data,
				title : 'Edit Event',
				width : 700,
				maxHeight: 300, 
				buttons : {
					'Update' : function(win) {
						var title = $("#modal #event_title").val();
						var description = $("#modal #event_description").val();
						var start_date = $("#modal #add_pickerfield1").val();
						var end_date = $("#modal #add_pickerfield2").val();
						var inputData = {
							'event[title]' :title,
							'event[description]' :description,
							'event[start_date]' : start_date,
							'event[end_date]' : end_date
						}
						var target = "/event/update_user_event/"+id
					  var charactercheck = characterLength()
					  var special_character = isSpclChar();
					  var stringReg = /^[a-zA-Z() ]*$/
					
					    if(charactercheck[0] == false) {
					      $('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+charactercheck[1], {
					        type : 'warning'
					      });
					      return false;
					  }
					  if(!title || title.length == 0) {
					      $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Event Title', {
					        type : 'warning'
					      });
					      return false;
					  }
					  if(!description || description.length == 0) {
					      $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Event Description', {
					        type : 'warning'
					      });
					      return false;
					  }			
						updateMyEvent(target,win,inputData);
						local_variable=null;
						},
					'Close' : function(win) {
						win.closeModal();
						local_variable=null;
						blockDoubleClick = false;
						}
					}
				});
				dateTimePick();
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	
});

function updateMyEvent(aTag,win,inputData){
	$.ajax({
		url : aTag,
		dataType : 'json',
		type : 'post',
		data : inputData,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				//individual domain need to implement this method
				$.get("/calendars/myEventView", function(data){
					$("#calendar").empty();
					$("#calendar").html(data);
				}).complete(function(){
					win.closeModal();
					$('#outer_blocks').removeBlockMessages().blockMessage(data.notice, {
						type : 'success'
					});
					modalBoxEvent.closeModal();
					blockDoubleClick = false;
				})
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
	
}

function dateTimePick(){
$('#modal #add_pickerfield1').datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'yyy-mm-dd'
});
$('#modal #add_pickerfield2').datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'yyyy-mm-dd'
});

}