$(document).ready(function() {
	$("#select3").fcbkcomplete({
		json_url : "/reminder/find",
		addontab : true,
		maxitems : 10,
		input_min_size : 0,
		height : 10,
		cache : true,
		newel : true,
		
	});
	$('.course_check').attr('checked', false);
	$('.department').attr('checked', false);
	$('#all_departments').attr('checked', false);
	$('#all_courses').attr('checked', false);
	$('#emp_all_courses').attr('checked', false);
	$('.empcourse_check').attr('checked', false);
});


$(document).on("click", ".delete-reminder", function(event) {
	var id2 = $(this).attr("id2");
	var reminder_id = $(this).attr("reminder_id");
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				delete_reminder(id2,reminder_id,win);
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
})


function delete_reminder(id2,reminder_id,win)
{
	var target = "/reminder/delete_reminder_by_recipient";
	$.get(target,{id2: id2, reminder_id: reminder_id},function(data){
    	
    }).success (function(){
    	window.location.href = "/reminder/index";
    	win.closeModal();
    }).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
}

$(document).on("click", ".view-sent-reminder-delete", function(event) {
	var id2 = $(this).attr("id2");
	
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				viewsentreminderdelete(id2,win);
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
})


function viewsentreminderdelete(id2,win)
{
	var target = "/reminder/delete_reminder_by_sender";
	$.get(target,{id2: id2},function(data){
    	
    }).success (function(){
    	window.location.href = "/reminder/sent_reminder";
    	win.closeModal();
    }).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
}


$(document).on("click", ".send", function(event) {
	att = []
	send_to_id = []
	index = 0

	$("#select3 option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			att[index] = $(this).text()
			send_to_id[index] = $(this).attr('value')
			index++
		} else {
			
		}

	})
	body = $('#reminder_body').val()
	subject = $('#reminder_subject').val()
	send_email = $('#email_send').is(":checked")
	if(att.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter person name  ', {
			type : 'warning'
		});
		return false;
	}
	if(!body || body.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter body', {
			type : 'warning'
		});
	} else if(!subject || subject.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter subject', {
			type : 'warning'
		});
	} else {
		// $(".loding").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$('#loader').html('Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />')
		$.getJSON('/reminder/sending', {
			send_to : att,
			body : body,
			subject : subject,
			send_to_id : send_to_id,
			send_email :send_email
		}, function(data) {
			if(data.valid) {
				 window.location.href = "/reminder";
				 $('#outer_block').removeBlockMessages().blockMessage(dataFromGetRequest.notice, {
					type : 'success'
					});
					
			} else {
				$(".loader").empty()
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
		// $(".loding").empty()
	}

})

$(document).on("click", "#send_to_all_department", function(event) {

})

$(document).on("click", ".admin_send", function(event) {
var departments = []
var courses = []
 students = []
index1 = 0
index2 = 0

	jQuery.each($("#all_departmant_li input").filter('[checked = checked]'),function(event){
		departments[index1] = $(this).attr('data_id')
		index1++
	})
	// jQuery.each($("#all_courses_li input").filter('[checked = checked]'),function(event){
			// courses[index2] = $(this).attr('data_id')
			// index2++
	// })
	jQuery.each($("#all_courses_li .course_check "),function(event){
		id = $(this).attr('data_id')
		if($(this).is(':checked'))
		{
			courses[index2] = $(this).attr('data_id')
			index2++
		}else{
			
			jQuery.each($("#all_courses_li .student_"+id).filter('[checked = checked]'),function(event){
				
				students.push($(this).attr('data_id'))
				
			})
		}
		
	})
	
	att = []
	send_to_id= []
	index = 0

	$("#select3 option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			att[index] = $(this).text()
			send_to_id[index] = $(this).attr('value')
			index++
		} else {
			
		}

	})
	body = $('#reminder_body').val()
	subject = $('#reminder_subject').val()
	send_email = $('#email_send').is(":checked")

	if(departments.length == 0 && courses.length == 0 && send_to_id.length == 0 && students.length == 0)
	{
		$('#outer_block').removeBlockMessages().blockMessage('Please select atleast one reciepient', {
			type : 'warning'
		});
	}else
	
	if(!body || body.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter body', {
			type : 'warning'
		});
	} else if(!subject || subject.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter subject', {
			type : 'warning'
		});
	} else {
		$('#loader').html('Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />')
		
		$.getJSON('/reminder/adminsending', {
			send_to : att,
			body : body,
			subject : subject,
			send_to_id : send_to_id,
			departments : departments,
			courses :courses,
			send_email :send_email,
			students   :students
		}, function(data) {
			if(data.valid) {
				 window.location.href = "/reminder";
				 $('#outer_block').removeBlockMessages().blockMessage(dataFromGetRequest.notice, {
					type : 'success'
					});
			} else {
				$(".loader").empty()
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
		
	}

})

$(document).on("click", ".emp_send", function(event) {
var departments = []
var courses = []
students = []
index2 = 0
	
	jQuery.each($("#emp_all_courses_li .emp_course_check"),function(event){
			// courses[index2] = $(this).attr('data_id')
			// index2++
			
			id = $(this).attr('data_id')
		if($(this).is(':checked'))
		{
			courses[index2] = $(this).attr('data_id')
			index2++
		}else{
			
			jQuery.each($("#emp_all_courses_li .student_"+id).filter('[checked = checked]'),function(event){
				
				students.push($(this).attr('data_id'))
				
			})
		}
	})
	att = []
	send_to_id= []
	index = 0

	$("#select3 option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			att[index] = $(this).text()
			send_to_id[index] = $(this).attr('value')
			index++
		} else {
			
		}

	})
	body = $('#reminder_body').val()
	subject = $('#reminder_subject').val()
	send_email = $('#email_send').is(":checked")
	if(courses.length == 0 && send_to_id.length == 0 && students.length == 0)
	{
		$('#outer_block').removeBlockMessages().blockMessage('Please select atleast one reciepient', {
			type : 'warning'
		});
	}else
	
	if(!body || body.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter body', {
			type : 'warning'
		});
	} else if(!subject || subject.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter subject', {
			type : 'warning'
		});
	} else {
		// $(".loding").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
// 	
$('#loader').html('Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />')
		$.getJSON('/reminder/empsending', {
			send_to : att,
			body : body,
			subject : subject,
			send_to_id : send_to_id,
			courses :courses,
			send_email :send_email,
			students   :students
		}, function(data) {
			if(data.valid) {
				 window.location.href = "/reminder";
				 $('#outer_block').removeBlockMessages().blockMessage(dataFromGetRequest.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				
				$('#loader').empty()
			}
		}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
		// $(".loding").empty()
	}

})





$(document).on("click", "#all_departments", function(event) {
	if($(this).is(":checked")) {
		$('.department').attr('checked', true);
	} else {
		$('.department').attr('checked', false);
	}
})
$(document).on("click", "#all_courses", function(event) {
	if($(this).is(":checked")) {
		$('.course_check').attr('checked', true);
		$('.batches_check').attr('checked', true);
		$('.student_check').attr('checked', true);
	} else {
		$('.course_check').attr('checked', false);
		$('.batches_check').attr('checked', false);
		$('.student_check').attr('checked', false);
	}
})
$(document).on("click", ".department", function(event) {
	$('#all_departments').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
	} else {
		$(this).attr('checked', false);
	}

})
$(document).on("click", ".course_check", function(event) {
	
	id = $(this).attr('data_id')
	$('#all_courses').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
		$('.batches_check_'+id).attr('checked', true);
		$('.student_'+id).attr('checked', true);
	} else {
		$(this).attr('checked', false);
		$('.batches_check_'+id).attr('checked', false);
		$('.student_'+id).attr('checked', false);
	}

})


$(document).on("click", "#emp_all_courses", function(event) {
	if($(this).is(":checked")) {
		$('.emp_course_check').attr('checked', true);
		$('.batches_check').attr('checked', true);
		$('.student_check').attr('checked', true);
	} else {
		$('.emp_course_check').attr('checked', false);
		$('.batches_check').attr('checked', false);
		$('.student_check').attr('checked', false);
	}
})
$(document).on("click", ".emp_course_check", function(event) {
	id = $(this).attr('data_id')
	$('#emp_all_courses').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
		$('.batches_check_'+id).attr('checked', true);
		$('.student_'+id).attr('checked', true);
	} else {
		$(this).attr('checked', false);
		$('.batches_check_'+id).attr('checked', false);
		$('.student_'+id).attr('checked', false);
	}

})


$(document).on("click", ".batches_check", function(event) {
	
	id = $(this).attr('data_id')
	course = $(this).attr('data_course')
	$('#all_courses').attr('checked', false);
	$('#emp_all_courses').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
		$('.student_check_'+id).attr('checked', true);
		
	} else {
		$(this).attr('checked', false);
		$('.student_check_'+id).attr('checked', false);
		$('#course_check_'+course).attr('checked', false);
		$('#emp_course_check_'+course).attr('checked', false);
	}

})


$(document).on("click", ".student_check", function(event) {
	
	id = $(this).attr('data_id')
	course = $(this).attr('data_course')
	batch = $(this).attr('data_batch')
	$('#all_courses').attr('checked', false);
	$('#emp_all_courses').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
	} else {
		$(this).attr('checked', false);
		$('#batches_check_'+batch).attr('checked', false);
		$('#course_check_'+course).attr('checked', false);
		$('#emp_course_check_'+course).attr('checked', false);
	}

})
