var counter = 2;
$(document).on("ready",function(){
	$("#assignment_batch_id").val("")
	$("#view_assignment_batch_id").val("")
	$("#assignment_subject").val("")
	$('#assignments_to_student').empty();
	$('#assignments_to_student_list').empty();
});


$(document).on("change","#assignment_batch_id",function(event){
	var batch = $(this).val();
	$('#assignments_to_student').empty();
	if(batch==""){
		$('#assignment_subject').empty();
		$('#assignments_to_student').empty();
	}else{
		$.get('/assignments/new', {id : batch}, function(data) {
			$("#change_assignment_subject").empty();
			$("#change_assignment_subject").html(data);

			
          }).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"


		  });	
          }
});
function assignment_datepicker(){
$('#attachment_datebox,#datebox1').datepick({
	alignment : 'bottom',
	showOtherMonths : true,
	selectOtherMonths : true,
	dateFormat : 'dd-mm-yyyy',
	yearRange : '1940:2100',
	minDate: 0 ,
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
}
function assignment_datepicker_forQuestion(counter){
$("#datebox" + counter).datepick({
	alignment : 'bottom',
	showOtherMonths : true,
	selectOtherMonths : true,
	dateFormat : 'dd-mm-yyyy',
	yearRange : '1940:2100',
	minDate: 0 ,
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
}
$(document).on('change', "#assignment_subject" ,function(event) {
	           var batch = $("#assignment_batch_id").val();
               var subject =  $(this).val(); 
                if(subject=="" || batch =="" ){
				$('#assignments_to_student').empty();
				}else{      
               var target = "/assignments/student_assigned" + '?id=' +batch 
               $("#assignments_to_student").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
                $.get(target,{subject_id: subject},function(data){
	              	$('#assignments_to_student').empty();
	                $('#assignments_to_student').html(data);
	                configurePtmStudentTable($('.ptmStudentAssign'));
	                assignment_datepicker();
	                document.getElementById('subject_assignment').value = subject;
                }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});
               }           
});


$(document).on("click", "#select-assignment_all", function(event){
	var checked_status = this.checked;
		$("input[id=assignment_students_]").each(function(){
			this.checked = checked_status;
		});
});

$(document).on("click", "#assignment_students_", function(event){
			$('input[id=select-assignment_all]').attr('checked', false);

});

$(document).on("click", "#getButtonValue", function(event){
	var allVals = [];
	$("input:checkbox[id=assignment_students_]:checked").each(function(){
			allVals.push($(this).val());
	});
	if(allVals == ""){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please Select Atleast 1 student', {
				type : 'warning'
		});
	}else{
		$('#outer_bloc').removeBlockMessages()
		var msg = [];
		var hint_msg = [];
		var date_msg = [];
		for(i=1; i<counter; i++){
		  if ($('#textbox' + i).val()!= "" && $('#textbox' + i).val()!= null) {
	   	  msg.push($('#textbox' + i).val());  
	   	  hint_msg.push($('#hintbox' + i).val());
	   	  date_msg.push($('#datebox' + i).val());
	   	  };
		}
		for (var k=0; k < date_msg.length; k++) {
			var confirmDate = dateConvert(date_msg[k])
			var newDate = new Date()
			newDate.setDate(newDate.getDate()-1)
			if (confirmDate < newDate) {
			   	 $('#outer_bloc').removeBlockMessages().blockMessage("Date of completion of assignment can not be a past date", {
						type : 'warning'
			    });	
			     return false
		   	 };	
		};
		if(msg!= "" ){
			confirmAssignment(allVals,msg,hint_msg,date_msg)	
		}else{
			$('#outer_bloc').removeBlockMessages().blockMessage("Please Enter Atleast One Question", {
					type : 'warning'
		    });	
		}
	}

});

function confirmAssignment(allVals,msg,hint_msg,date_msg){
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to create an assignment...</p>',
		title : 'Confirm Assignment',
		maxWidth : 500,
		buttons : {
			'Confirm' : function(win) {
				createAssignmentToStudent(allVals,msg,hint_msg,date_msg);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	
}


function createAssignmentToStudent(allVals,msg,hint_msg,date_msg){

		var batch_id = $('#batch_assignment').val();
		var subject_id = $("#assignment_subject").val();
		var target = '/assignments'
		 	 var data = {
								'assignment[batch_id]' : batch_id,
								'assignment[subject_id]' : subject_id,
								'assignment[hint_msg]' : hint_msg,
								'assignment[date_msg]' : date_msg,
								'assignment[msg]' : msg,
								'assignment[student_id]' : allVals
								
							}
		$.ajax({
		url : target,
		dataType : 'json',
		type : 'POST',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});	
				$('input[id=select-assignment_all]').attr('checked', false);
				$('input[id=assignment_students_]').attr('checked', false);
				$("#TextBoxesGroup").empty();
				counter =1;					
			} else {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice || 'An unexpected error occured, please try again', {
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
$(document).on("click","#addTextButton",function (event) {

	if(counter>10){
            alert("Only 10 textboxes allow");
            return false;
	}  
	var now = new Date();
	var year = now.getFullYear();
	var months = now.getMonth()+1;
	var month = months.toString();
	var date = now.getDate().toString();
	if(date.length== "1"){
		date = "0" + date 
	}
	if(month.length == "1"){
		month = "0" + month 
	}
	var newDiv = $(document.createElement('div'))
	var newDiv1 = $(document.createElement('div'))
	newDiv.attr("class", 'column') 
	newDiv1.attr("class", 'columns') 
	var newTextBoxP1 = $(document.createElement('p'))
	var newTextBoxP2 = $(document.createElement('p'))
	var newTextBoxP3 = $(document.createElement('p'))
	newTextBoxP1.attr("id", 'TextBoxDiv1' + counter)
	newTextBoxP1.attr("class", 'colx1-left required')
	newTextBoxP1.html('<label>Question #'+ counter + ' : </label>' +
	      '<input type="text" name="textbox' + counter + 
	      '" id="textbox' + counter + '" value="" class="full-width">');
	newTextBoxP2.attr("id", 'TextBoxDiv2' + counter)
	newTextBoxP2.attr("class", 'colx2-left')
	newTextBoxP2.html('<label>Hint #'+ counter + ' : </label>' +
	      '<input type="text" name="hintbox' + counter + 
	      '" id="hintbox' + counter + '" value="" class="full-width" >');
	newTextBoxP3.attr("id", 'TextBoxDiv3' + counter)
	newTextBoxP3.attr("class", 'colx2-right')
	newTextBoxP3.html('<label>To be completed #'+ counter + ' : </label>' +
	      '<span class="input-type-text"><input type="text" name="datebox' + counter + 
	      '" id="datebox' + counter + '" value="'+date+"-"+month+"-"+year+'" class="datepicker" readonly="readonly" ><img src="/assets/icons/fugue/calendar-month.png" /></span>');      
	     newTextBoxP1.appendTo(newDiv); 
	     newTextBoxP2.appendTo(newDiv1);
	     newTextBoxP3.appendTo(newDiv1);
	     newDiv.appendTo("#TextBoxesGroup");
	     newDiv1.appendTo("#TextBoxesGroup");
	     assignment_datepicker_forQuestion(counter);
		 counter++;
});
     
$(document).on("click","#removeButton",function (event) {
	if(counter==1){
          alert("No more textbox to remove");
          return false;
       }   
 
	counter--;
 
        $("#TextBoxDiv1" + counter).remove();
        $("#TextBoxDiv2" + counter).remove();
        $("#TextBoxDiv3" + counter).remove();
 
});

$(document).on("click","#showFullQuestion",function (event) {
	event.preventDefault();
	var id = $(this).attr('ids')
	$.get('/assignments/'+id+'/edit',function(data){
		$.modal({
			content : data,
			title : 'View Assignment',
			maxWidth : 700,
			buttons : {
				'Cancel' : function(win) {
					win.closeModal();
				}
			}
		});
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});

$(document).on("click","#showEmployeeFullQuestion",function (event) {
	event.preventDefault();
	if(blockDoubleClick != true){
	blockDoubleClick = true;
	var id = $(this).attr('ids')
	$.get('/assignments/'+id+'/edit',function(data){
		$.modal({
		content : data,
		title : 'View Assignment',
		maxWidth : 700,
		buttons : {
			'Update' : function(win) {
				var quest = $("#modal #editQuestion").val();
				var hint = $("#modal #editHint").val();
				var date = $("#modal #editDate").val();
				if(quest!= ""){
					updateAssignment(id,quest,hint,date,win)
				}else{
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter the Question', {
						type : 'warning'
					});
					return false;
				}
			},
			'Delete' : function(win1) {
				confirmDeleteAssignment(id,win1)
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	$("#modal #editDate").datepicker({beforeShow: function() {
        $('#ui-datepicker-div').css('z-index', 9999);
    },dateFormat: 'yy-mm-dd' })
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	}).complete(function(){
		blockDoubleClick = false;
	})
  }
});

function updateAssignment(id,quest,hint,date,win){
	var target = '/assignments/'+id
		 	 var data = {
								'assignment[question]' : quest,
								'assignment[hint]' : hint,
								'assignment[to_be_completed]' : date	
							}
		$.ajax({
		url : target,
		dataType : 'json',
		type : 'PUT',
		data : data,
		success : function(data1, textStatus, jqXHR) {
			if(data1.valid) {
				var batch=$("#view_assignment_batch_id").val()
				var subject= $("#view_assignment_subject").val()
				var target = "/assignments/view_student_assigned" + '?id=' +batch 
               $("#assignments_to_student_list").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
                $.get(target,{subject_id: subject},function(data){
	              	$('#assignments_to_student_list').empty();
	                $('#assignments_to_student_list').html(data);
	                configureAssignmentTable($('.assignmentStudentAssign'));
                }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});	
                $('#outer_bloc').removeBlockMessages().blockMessage(data1.notice, {
					type : 'success'
				});	
				
                win.closeModal();			
			} else {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice || 'An unexpected error occured, please try again', {
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

function deleteAssignment(id,win2){
	var target = '/assignments/'+id
		$.ajax({
		url : target,
		dataType : 'json',
		type : 'DELETE',
		success : function(data1, textStatus, jqXHR) {
			if(data1.valid) {
				var batch=$("#view_assignment_batch_id").val()
				var subject= $("#view_assignment_subject").val()
				var target = "/assignments/view_student_assigned" + '?id=' +batch 
               $("#assignments_to_student_list").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
                $.get(target,{subject_id: subject},function(data){
	              	$('#assignments_to_student_list').empty();
	                $('#assignments_to_student_list').html(data);
	                configureAssignmentTable($('.assignmentStudentAssign'));
                }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});	
                win2.closeModal();
                $('#outer_bloc').removeBlockMessages().blockMessage(data1.notice, {
					type : 'success'
				});	
						
			} else {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice || 'An unexpected error occured, please try again', {
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

function confirmDeleteAssignment(id,win1) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win2) {
				deleteAssignment(id,win2)
			},
			'Cancel' : function(win2) {
				win2.closeModal();
			}
		}
	});
	 win1.closeModal();	
}



$(document).on("change","#view_assignment_batch_id",function(event){
	var batch = $(this).val();
	$('#assignments_to_student_list').empty();
	if(batch==""){
		$('#view_assignment_subject').empty();
		$('#assignments_to_student_list').empty();
	}else{
		$.get('/assignments/new', {id : batch,view : true}, function(data) {
			$("#change_assignment_subject").empty();
			$("#change_assignment_subject").html(data);

        }).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
		});

	}
});

$(document).on('change', "#view_assignment_subject" ,function(event) {
	           var batch = $("#view_assignment_batch_id").val();
               var subject =  $(this).val();       
               var target = "/assignments/view_student_assigned" + '?id=' +batch 
               $("#assignments_to_student_list").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
                $.get(target,{subject_id: subject},function(data){
	              	$('#assignments_to_student_list').empty();
	                $('#assignments_to_student_list').html(data);
	                configureAssignmentTable($('.assignmentStudentAssign'));
                }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});
});


$(document).on('click', "#viewStudentAssignment", function(event) {
	if(blockDoubleClick != true){
	blockDoubleClick = true;
	var batch = $(this).attr('batch_id');
	var id = $(this).attr('assignment_id');
	var allVals = []
	var assigned_student = $(this).attr('assigned_student');
	var target = "/assignments/student_assigned" + '?id=' + batch
	$.get(target, {	already_assigned : "true"}, function(data) {
		$.modal({
			content : data,
			title : 'Assigned Student',
			height : 350,
			width : 700,
			buttons : {
				'Update' : function(win2) {
					$('input:checkbox[id=assignment_students_]:checked').each(function() {
						if($.inArray($(this).val(), allVals) === -1) {
							allVals.push($(this).val());
						}
					});
					if(allVals == "") {
						$('#modal #outer_block').removeBlockMessages().blockMessage("Please Select atleast one Student", {
							type : 'warning'
						});
					} else {
						updateStudentAssigned(id, allVals, win2);
					}
				},
				'Cancel' : function(win2) {
					win2.closeModal();
				}
			}
		});
		var attributeIds = new Array();
		attributeIds = assigned_student.split(',');
		$("input[id=assignment_students_]").each(function() {
			for(var i = 0; i < attributeIds.length; i++) {
				if(attributeIds[i] === $(this).val()) {
					this.checked = true;
				}
			}
		});
		configureAssignmentTable($('.ptmStudentAssign'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
		      window.location.href = "/signin"
	}).complete(function(){
		blockDoubleClick = false;
	});
}
});



function updateStudentAssigned(id,allVals,win2){
	var target = '/assignments/'+id
	var data = {
		'assignment[student_id]' : allVals
	}
		$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		type : 'PUT',
		success : function(data1, textStatus, jqXHR) {
			if(data1.valid) {
			   var batch = $("#view_assignment_batch_id").val();
               var subject =  $("#view_assignment_subject").val();       
               var target = "/assignments/view_student_assigned" + '?id=' +batch 
                $.get(target,{subject_id: subject},function(data){
	              	$('#assignments_to_student_list').empty();
	                $('#assignments_to_student_list').html(data);
	                configureAssignmentTable($('.assignmentStudentAssign'));
                }).success(function() {
                	 $('#outer_block').removeBlockMessages().blockMessage(data1.notice, {
					type : 'success'
				   });
                }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});
                 win2.closeModal();	
                		
			} else {
				$('#modal #outer_block').removeBlockMessages().blockMessage(data1.errors || 'An unexpected error occured, please try again', {
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

function configureAssignmentTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		// aoColumns : [{
			// bSortable : false
		// }, // No sorting for this columns, as it only contains checkboxes
		// {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }// No sorting for actions column
		// ],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix no-margin"lf>',
		/*
		 * Callback to apply template setup
		 */
		fnDrawCallback : function() {
			this.parent().applyTemplateSetup();
		},
		fnInitComplete : function() {
			this.parent().applyTemplateSetup();
		}
	});
	// Sorting arrows behaviour
	table.find('thead .sort-up').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'asc']]);
		// Prevent bubbling
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'desc']]);
		// Prevent bubbling
		return false;
	});
};


$(document).on("click", "#assignment_create", function(event){
	// event.preventDefault()
	
    var allVals = [];
	$("input:checkbox[id=assignment_students_]:checked").each(function(){
			allVals.push($(this).val());
	});
	if (allVals == "") {
		 $('#outer_bloc').removeBlockMessages().blockMessage("Please select atleast 1 student", {
					type : 'warning'
		 });
		 return false	
	} 
	if ($("#attachment").val() == "") {
		 $('#outer_bloc').removeBlockMessages().blockMessage("Please select the assignment", {
					type : 'warning'
		 });
		 return false	
	} else{
		
	};
	var filePath = document.getElementById('attachment');
	var fileSize = filePath.files[0].size
	if(fileSize > 3145728) {
		$('#outer_bloc').removeBlockMessages().blockMessage('File Size can not exceed 3 MB', {
			type : 'warning'
		});
		return false;
	}
});

$(document).on("change", "#assignment_course_search_course_id", function(event){
	var viewAssignment = document.getElementById('viewAssignment').value;
	var id = $(this).val();
	$("#assignments_to_student").empty();
	if(id.length== 0){
		$("#assignment_subject").empty();	
	}
	$.get("/assignments/show_batch?id="+id,{viewAssignment : viewAssignment} ,function(data){
		$("#change_batch_for_admin").empty();
		$("#change_batch_for_admin").html(data);
        }).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
		});
});
