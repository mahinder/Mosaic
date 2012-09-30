$(document).on("ready", function() {
	$("#ptm_student_batch_id").val("")
});

$(document).on("change", "#ptm_student_batch_id", function(event) {
	var batch = $(this).val();
	if(batch == "") {
		$('#parent_teacher_meeting').empty();
	} else {
		$("#parent_teacher_meeting").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get('ptm_masters/ptm_student', {
			q : batch
		}, function(data) {
			$('#parent_teacher_meeting').empty();
			$('#parent_teacher_meeting').html(data);
			configurePtmStudentTable($('.ptmStudentAssign'));
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
	}
});

$(document).on("click", "#select-ptm_all", function(event) {
	var checked_status = this.checked;
	$("input[name=PTmStudent]").each(function() {
		this.checked = checked_status;
	});
});

$(document).on("click", "#Ptm_students_", function(event) {
	$('input[id=select-ptm_all]').attr('checked', false);

});

$(document).on("click", "#create_ptm_student", function(event) {
	var allVals = [];
	$("input:checkbox[name=PTmStudent]:checked").each(function() {
		allVals.push($(this).val());
	});
	if(allVals == "") {
		$('#outer_block').removeBlockMessages().blockMessage('Please Select Atleast 1 student', {
			type : 'warning'
		});
	} else {
		$('#outer_block').removeBlockMessages()
		createPTMStudent(allVals);
	}

});
function createPTMStudent(allVals) {
	var contents = $('#modal-box_ptm_student');
	var batch_id = $('#ptm_batch').val();
	$.modal({
		content : contents,
		title : 'Create PTM',
		maxWidth : 700,
		minWidth : 700,
		buttons : {
			'Create' : function(win) {
				var title = $("#modal #ptm_master_title ").val();
				var description = $("#modal #ptm_master_description ").val();
				var start_date = $("#modal #ptm_master_ptm_start_date ").val();
				var end_date = $("#modal #ptm_master_ptm_end_date ").val();
				var event_create = $('#modal #ptm_create_event').attr('checked');
				var sms_send = $('#modal #ptm_create_event_sms').is(':checked');
				if(!title || title.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Meeting Tilte', {
						type : 'warning'
					});
					return false;
				}
				if(!description || description.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Meeting Description', {
						type : 'warning'
					});
					return false;
				}
				if(!start_date || start_date.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Meeting Start Date', {
						type : 'warning'
					});
					return false;
				}
				if(!end_date || end_date.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Meeting End Date', {
						type : 'warning'
					});
					return false;
				}
				var data = {
					'ptm_master[title]' : title,
					'ptm_master[description]' : description,
					'ptm_master[batch_id]' : batch_id,
					'ptm_master[ptm_start_date]' : start_date,
					'ptm_master[ptm_end_date]' : end_date,
					'create_event' : event_create,
					'student_id' : allVals,
					'sms_send' : sms_send

				}
				createParentTeacherMeetingEvent(data, allVals);
				win.closeModal();
			},
			'Cancel' : function(win) {
				$('input[id=select-ptm_all]').attr('checked', false);
				$('input[name=PTmStudent]').attr('checked', false);
				win.closeModal();
			}
		}
	});
	modal_box_datepicker();
}

function createParentTeacherMeetingEvent(data, allVals) {
	var target = "/ptm_masters"
	$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		type : 'POST',
		success : function(data) {
			if(data.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				$('input[id=select-ptm_all]').attr('checked', false);
				$('input[name=PTmStudent]').attr('checked', false);
				createPTmDetails(allVals, data.notice)
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
}

function createPTmDetails(allVals, message) {
	var data = {
		'student_id' : allVals
	}
	var target = "/ptm_details"
	$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		type : 'POST',
		success : function(data) {
			if(data.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(message, {
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
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

}


$(document).on("click", "#show_active_ptm", function(event) {
	var id = $('#ptm_batch').val();
	var ptm_id = ""
	$.get('/ptm_masters/' + id, function(data) {
		$.modal({
			content : data,
			title : 'PTM List',
			width : 700,
			height : 300,
			buttons : {
				'View' : function(win1) {
					var ptmMaster = $("#modal #PTMEvent").val();
					ptm_id = $('input:radio[name=PTMEvent]:checked').val();
					if(ptm_id != null) {
						createParentFeedBack(ptm_id, win1)
					} else {
						$('#modal #outer_block').removeBlockMessages().blockMessage("Please Select Atleast One from PTM List", {
							type : 'warning'
						});
					}
				},
				'Cancel' : function(win1) {
					win1.closeModal();
				}
			}
		});
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});
function createParentFeedBack(ptm_id, win1) {
	$.get('/ptm_details/' + ptm_id, function(data) {
		$.modal({
			content : data,
			title : 'FeedBack',
			width : 900,
			height : 400,
			buttons : {
				'Submit' : function(win2) {
					var parentFeedBack = [];
					var student_id = [];
					var for_student_id = [];
					var employeeFeedBack = [];
					$("input:text[name=parent_feedback]").each(function() {
						if($(this).val() != "") {
							parentFeedBack.push($(this).val());
							student_id.push($(this).attr('student'));
						}
					});
					$("input:text[name=employee_feedback]").each(function() {
						if($(this).val() != "") {
							employeeFeedBack.push($(this).val());
							for_student_id.push($(this).attr('employee'));
						}
					});
					updatePTMwithFeedBack(employeeFeedBack, parentFeedBack, for_student_id, student_id, ptm_id, win2);

				},
				'Cancel' : function(win2) {
					win2.closeModal();

				}
			}

		});
		win1.closeModal();
		configurePtmFeedBackStudentTable($('#ptmfeed'));
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}

function updatePTMwithFeedBack(employeeFeedBack, parentFeedBack, for_student_id, student_id, ptm_id, win2) {
	var data = {
		'ptm[teacher_notes]' : employeeFeedBack,
		'ptm[parent_feedback]' : parentFeedBack,
		'ptm[student_id]' : student_id,
		'ptm[for_student_id]' : for_student_id,
		'ptmId' : ptm_id
	}
	var target = "/ptm_details/" + ptm_id
	$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		type : 'PUT',
		success : function(data) {
			if(data.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				win2.closeModal();
			} else {
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

};


$(document).on("click", "#show_ptm_history", function(event) {

	var id = $('#ptm_batch').val();
	var ptm_id = ""
	$.get('/ptm_masters/' + id, {
		history : "history"
	}, function(data) {
		$.modal({
			content : data,
			title : 'PTM History List',
			width : 700,
			height : 300,
			buttons : {
				'View' : function(win1) {
					var ptmMaster = $("#modal #PTMEvent").val();
					ptm_id = $('input:radio[name=PTMEvent]:checked').val();
					if(ptm_id != null) {
						showParentFeedBack(ptm_id, win1)
					} else {
						$('#modal #outer_block').removeBlockMessages().blockMessage("Please Select Atleast One ptm from PTM List", {
							type : 'warning'
						});
					}
				},
				'Cancel' : function(win1) {
					win1.closeModal();
				}
			}
		});
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});
function showParentFeedBack(ptm_id, win1) {
	$.get('/ptm_details/' + ptm_id, function(data) {
		$.modal({
			content : data,
			title : 'FeedBack',
			width : 700,
			height : 300,
			buttons : {
				'Cancel' : function(win2) {
					win2.closeModal();
				}
			}
		});
		win1.closeModal();
		configurePtmFeedBackStudentTable($('#ptmfeed'));
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}


$(document).on("change", "#ptm_search_course_id", function(event) {
	var course_id = $(this).val();
	if(course_id == "") {
		$("#get_student_ptm").empty();
		$("#ptm_student_batch_wise").empty();
		return false;
	}
	$.get('/ptm_admin/show', {
		id : course_id
	}, function(data) {
		$("#change_ptm_batch").empty();
		$("#change_ptm_batch").html(data)
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});

$(document).on("change", "#ptm_student_batch_wise", function(event) {
	var batch_id = $(this).val();
	$("#get_student_ptm").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get('/ptm_admin/ptm', {
		id : batch_id
	}, function(data) {
		$("#get_student_ptm").empty();
		$("#get_student_ptm").html(data);
		configurePtmFeedBackStudentTable($('.ptmUpdateStudentAssign'));
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});

$(document).on("click", "#PTMSTatus", function(event) {
	event.preventDefault();
	var id = $(this).val()
	var stat = $(this).attr('status')
	$("#loadPTm" + id).html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get('/ptm_admin/update', {
		id : id,
		status : stat
	}, function(data) {
		$(".pClass" + id).toggle();
		$("#loadPTm" + id).html("")
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});

$(document).on("ready", function(event) {
	$("#change_ptm_batch").val("");
	$("#ptm_search_course_id").val("");
});
function configurePtmFeedBackStudentTable(tableNode) {
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


$(document).on("click", "a.update-href-ptm_admin", function(event) {
	event.preventDefault();
	var aLink = $(this);
	var object_id = aLink.siblings('input').val();
	$.get("ptm_admin/edit?id=" + object_id, function(data) {
		editParentTeacherMeeting(data, object_id);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});
function editParentTeacherMeeting(data, object_id) {
	$.modal({
		content : data,
		title : 'Edit Meeting',
		width : 700,
		height : 300,
		buttons : {
			'Update' : function(win2) { 
				var ptm_title = $("#ptm_master_title").val();
				var ptm_description = $("#ptm_master_description").val();
				var ptm_start_date = $("#ptm_master_ptm_start_date").val();
				var ptm_end_date = $("#ptm_master_ptm_end_date").val();
				var ptm_create_event = $("#ptm_create_event").is(':checked');
				if(!ptm_title || ptm_title.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Meeting Tilte', {
						type : 'warning'
					});
					return false;
				}
				if(!ptm_description || ptm_description.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Meeting Description', {
						type : 'warning'
					});
					return false;
				}
				var inputData = {
					'ptm_master[title]' : ptm_title,
					'ptm_master[description]' : ptm_description,
					'ptm_master[ptm_start_date]' : ptm_start_date,
					'ptm_master[ptm_end_date]' : ptm_end_date,
					'create_event' : ptm_create_event
				}
				updatePTMByAdmin(inputData, object_id, win2);
			},
			'Cancel' : function(win2) {
				win2.closeModal();
			}
		}
	});
	modal_box_datepicker();
}

function updatePTMByAdmin(inputData, object_id, win2) {
	$.ajax({
		url : "/ptm_masters/" + object_id,
		type : 'put',
		dataType : 'json',
		data : inputData, // it should have '_method' : 'put'
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				win2.closeModal();
				var batch_id = $("#ptm_student_batch_wise").val();
				$.get('/ptm_admin/ptm', {
					id : batch_id
				}, function(data1) {
					$("#get_student_ptm").empty();
					$("#get_student_ptm").html(data1);
					configurePtmFeedBackStudentTable($('.ptmUpdateStudentAssign'));

				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				}).complete(function(jqXHR, textStatus, errorThrown) {
					$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
						type : 'success'
					});
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
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