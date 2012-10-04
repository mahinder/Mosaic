function configureSubjectTopiceTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		}, // No sorting for this columns, as it only contains checkboxes
		{
			sType : 'string'
		}, {
			sType : 'string'
		}, {
			sType : 'string'
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		// sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix"lf>',
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


$(document).on("click", ".topic_view", function(event) {
	var id = $(this).attr('data-subject')
	event.preventDefault();
	$.get('/sub_skills/subject_subskill', {
		id : id
	}, function(data) {

		$.modal({
			content : data,
			title : 'Topic List',
			width : 700,
			maxHeight : 500,
			buttons : {
				'Close' : function(win) {
					win.closeModal();
				}
			}
		});
		configureSubjectTopiceTable($('#subject'));

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
})

$(document).on("click", ".batch_create", function(event) {
	var course_id = $(this).attr('data-course');
	var id = '#batch_create_button_' + course_id;
	var tab_id = '#tab-batch-tab_' + course_id;
	event.preventDefault();
	// Open modal
	$('#modal-box-batch #batch_create_new').val("");
	var contents = $('#modal-box-batch');
	$.modal({
		content : contents,
		title : 'Batch Creation',
		width : 750,
		height : 250,
		buttons : {

			'Create' : function(win) {
				var batch = $('#modal #batch_create_new').val();
				var start_date = $('#modal #batch_start_date').val();
				var end_date = $('#modal #batch_end_date').val();
				var characterReg = /^\s*[a-zA-Z0-9,_,\+,\-,\s]+\s*$/;
				// var characterReg = /^\s*[a-zA-Z,_,\-,\s]+\s*$/;
				if(!batch || batch.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Batch name', {
						type : 'warning'
					});
				} else if(!characterReg.test(batch)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only character for Batch name', {
						type : 'warning'
					});
				} else{
					// Target url
					var target = '/batches'
					// Requ@elective_skillsest
					var data = {

						'batch[name]' : batch,
						'batch[start_date]' : start_date,
						'batch[end_date]' : end_date,
						'course_id' : course_id

					}

					ajaxCreateBatch(target, data, tab_id, course_id, win);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
modal_box_datepicker();
});
function ajaxCreateBatch(target, data1, tab_id, course_id, win) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data1,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				win.closeModal();
				//individual domain need to implement this method
				//var data_course_value = data.course_value
				//alert(data_course_value)
				//var data_course_for = data.course_for // TODO change this varaiable name to course_group here and also in controller
				// var getData = {
				// //'course_value' : data_course_value,
				// 'course_for'  : course_group
				// }

				$.get('/batches?course_id=' + course_id, function(data) {
					
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs(); 
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});

			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
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

///=========================================================batch edit
$(document).on("click", ".update-batch-href", function(event) {
	//$(".elective-skill-secound").each(function() {
	var aLink = $(this);
	var course_id = $(this).attr('data-course');
	var tab_id = '#tab-batch-tab_' + course_id;
	var object_id = aLink.siblings('input').val();
	var objname = $(this).attr('data-name');
	var objstartdate = $('#batch_start_date_' + object_id).html();
	var objenddate = $('#batch_end_date_' + object_id).html();
	$('#modal-box-batch-edit #batch_create_edit').val(objname);
	$('#modal-box-batch-edit #batch_start_date').val(objstartdate);
	$('#modal-box-batch-edit #batch_end_date').val(objenddate);

	// $('#current_object_id').val(object_id);

	// Prevent link opening
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-batch-edit');

	$.modal({
		content : contents,
		title : 'Batch Updation',
		width : 700,
		height : 250,
		buttons : {

			'Update' : function(win) {

				var batch = $('#modal #batch_create_edit').val();
				var start_date = $('#modal #batch_start_date').val();
				var end_date = $('#modal #batch_end_date').val();
				var characterReg = /^\s*[a-zA-Z0-9,_,\+,\-,\s]+\s*$/;
				// var characterReg = /^\s*[a-zA-Z,_,\-,\s]+\s*$/;
				if(!batch || batch.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Batch name', {
						type : 'warning'
					});
				} else if(!characterReg.test(batch)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only character for Batch name', {
						type : 'warning'
					});
				} else {
					// Target url
					var target = '/batches/' + object_id
					// Requ@elective_skillsest
					var data = {

						'batch[name]' : batch,
						'batch[start_date]' : start_date,
						'batch[end_date]' : end_date,
						'course_id' : course_id,
						'_method' : 'put'

					}

					ajaxCreateBatch(target, data, tab_id, course_id, win);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});modal_box_datepicker();
});
//=============================delete

function WarningBatchModal() {
	$.modal({
		content : '<h3>This batch cannot be deleted because of various dependencies</h3>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				win.closeModal();
			},
		}
	});
}


$(document).on("click", ".delete-batch-tab-href", function(event) {

	var aLink = $(this);
	var course_id = $(this).attr('data-course');
	var tab_id = '#tab-batch-tab_' + course_id;
	var object_id = aLink.siblings('input').val();
	var remoteUrl = "/batches/" + object_id
	confirmDeleteBatch(remoteUrl, course_id, tab_id);
	return false;
});
function confirmDeleteBatch(remoteUrl, course_id, tab_id) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteBatch(remoteUrl, course_id, tab_id);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteBatch(remoteUrl, course_id, tab_id) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'course_id' : course_id,
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$.get('/batches?course_id=' + course_id, function(data) {
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs();

				});
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				// $('#modal #outer_block').removeBlockMessages()
			} else {
				WarningBatchModal()
				return false
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	// Message
}

///==================================
$(document).on("click", ".delete-batch-subject-tab-href", function(event) {

	var aLink = $(this);
	var course_id = $(this).attr('data-course');
	var tab_id = '#tab-batch-tab_' + course_id;
	var object_id = aLink.siblings('input').val();
	var remoteUrl = "/batches/" + object_id
	confirmDeleteBatch1(remoteUrl, course_id, tab_id);
	return false;
});
function confirmDeleteBatch1(remoteUrl, course_id, tab_id) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteBatch1(remoteUrl, course_id, tab_id);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteBatch1(remoteUrl, course_id, tab_id) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'course_id' : course_id,
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {

				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				WarningBatchModal()
				return false
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

////============================Auto-complete
$(function() {

	// $( "#tags" ).autocomplete({
	// source: $("#tags").data('autocomplete-source')
	// });

	$("#teacher").autocomplete({
		source : $("#teacher").data('autocomplete-source')
	});
});
//============================= batch subject edit==
$(document).on("click", ".update-batch-subject-href", function(event) {
	//$(".elective-skill-secound").each(function() {
	var aLink = $(this);
	var object_id = aLink.siblings('input').val();
	
	var objname = $(this).attr('data-name');
	var course_id = $(this).attr('data-course');
	var objstartdate = $(this).attr('data-start');
	var objenddate = $(this).attr('data-end');
	$('#modal-box-batch-subject-edit #batch_create_edit').val(objname);
	$('#modal-box-batch-subject-edit #batch_start_date').val(objstartdate);
	$('#modal-box-batch-subject-edit #batch_end_date').val(objenddate);

	// $('#current_object_id').val(object_id);

	// Prevent link opening
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-batch-subject-edit');

	$.modal({
		content : contents,
		title : 'Update  Batch',
		width : 700,
		height : 200,
		buttons : {

			'Update' : function(win) {

				var batch = $('#modal #batch_create_edit').val();
				var start_date = $('#modal #batch_start_date').val();
				var end_date = $('#modal #batch_end_date').val();
				var characterReg = /^\s*[a-zA-Z0-9,_,\+,\-,\s]+\s*$/;
				// var characterReg = /^\s*[a-zA-Z,_,\-,\s]+\s*$/;
				if(!batch || batch.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Batch name', {
						type : 'warning'
					});
				} else if(!characterReg.test(batch)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only character for Batch name', {
						type : 'warning'
					});
				} else{
					// Target url
					var target = '/batches/' + object_id
					// Requ@elective_skillsest
					var data = {

						'batch[name]' : batch,
						'batch[start_date]' : start_date,
						'batch[end_date]' : end_date,
						'course_id' : course_id,
						'_method' : 'put'

					}
					
					ajaxUpdateBatchSubject(target, data, win, course_id, object_id);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});modal_box_datepicker();
});
function ajaxUpdateBatchSubject(target, data, win, course_id, object_id) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				win.closeModal();
				$.get('update_batch_subject', {
					course_id : course_id,
					id : object_id
				}, function(data) {
					
					$('#subject_batch').empty();
					$('#subject_batch').html(data);
					batch_replace()
					$.get('/batches/select_batch', {
						course_id : course_id
					}, function(dataFromGetRequest) {
						$('#batch-select').empty();
						$('#batch-select').html(dataFromGetRequest);
						$('#batch_name').val(object_id)
					}).error(function(jqXHR, textStatus, errorThrown) {
						window.location.href = "/signin"
					});
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});
				// $('.update-batch-subject-href').attr('')
				// $('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
				// type : 'success'
				// });

			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
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

//================================change batch according to course
$(document).ready(function() {
	$("#course_id_course_name").val(0);
	$("#batch_name").val(0);

});

$(document).ready(function() {
	$("#course_id_course_name").live("change", (function(event) {
		var str1 = "";
		event.preventDefault();
		$("#course_id_course_name option:selected").each(function() {
			str1 = $(this).val();
		});
		$(".load").append('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 /><strong></strong>');
		$.get('/batches/select_batch', {
			course_id : str1
		}, function(dataFromGetRequest) {
			$('#batch-select').empty();
			$('#batch-select').html(dataFromGetRequest);

		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
		$.get('/batches/show1', {
			course_id : str1
		}, function(dataFromGetRequest) {
			if(dataFromGetRequest == "") {
				$('#full_page').empty();
				$('#batch-select').hide();
				$('#full_page').html("<h3>Currently no batch in this course</h3>");
				$(".load img").remove();
				$(".load strong").remove();
			} else {
				$('#batch-select').show();
				$('#full_page').empty();
				$('#full_page').html(dataFromGetRequest);
				$('.tabs').updateTabs();
				configureStudentTable($('.students-table'));
				configureSubjectTable($('#subject-table'));
				$(".load img").remove();
				$(".load strong").remove();
			}
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
		batch_replace()
	}));
});

$(document).ready(function() {

	$("#batch_name").live("change", (function(event) {
		var aLink = $(this);
		var course_id = aLink.siblings('input').val();
		var str = "";
		event.preventDefault();
		$("#batch_name option:selected").each(function() {
			$('#loading').show();
			str = $(this).val();
		});
		$.get('/batches/' + str, {
			course_id : course_id
		}, function(dataFromGetRequest) {
			$('#full_page').empty();
			$('#full_page').html(dataFromGetRequest);
			$('.tabs').updateTabs();
			configureStudentTable($('.students-table'));
			configureSubjectTable($('#subject-table'));
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
		batch_replace()
	}));
});
//------------------------------Assignment
$('#tags').keyup(function() {
	var value = document.getElementById("tags").value
	var aLink = $(this);
	var course_id = document.getElementById("room_course_id").value
	if(value.length > 0) {
		$.get('/batches/room?course_id=' + course_id + "&value=" + value, function(dataFromGetRequest) {
			$('#room_assign').empty();
			$('#room_assign').html(dataFromGetRequest);

		});
	} else {
		$('#room_assign').empty();
	}
});
function batch_replace() {
	$('#teacher').keyup(function() {
		
		var value = document.getElementById("teacher").value
		var aLink = $(this);
		var course_id = document.getElementById("emp_course_id").value
		var batch_id = document.getElementById("emp_batch_id").value
		if(value.length > 0) {
			$.get('/batches/teacher?course_id=' + course_id + "&value=" + value, {
				batch_id : batch_id
			}, function(dataFromGetRequest) {
				$('#teacher_assign').empty();
				$('#teacher_assign').html(dataFromGetRequest);

			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		} else {
			$('#teacher_assign').empty();
		}
	});
}


$(document).on("click", ".home_room", function(event) {
	var aLink = $(this);
	var id = $(this).attr('data-id');
	var check_box_id = $(this).attr('id');
	var is_check = $(this).is(":checked")
	$('.home_room').attr('checked', false);
	if(is_check == true) {
		$(this).attr('checked', true);
	}

	if($(this).is(":checked")) {
		document.getElementById("room_id").value = id
	} else {
		document.getElementById("room_id").value = ""
	}
});
$(document).on("click", ".skill_check", function(event) {
	return false
});

$(document).on("click", ".home_teacher", function(event) {
	var aLink = $(this);
	var id = $(this).attr('data-id');
	var check_box_id = $(this).attr('id');
	var is_check = $(this).is(":checked")
	$('#teacher').val($(this).attr('data_employee'))

	var course_id = document.getElementById("emp_course_id").value
	var batch_id = document.getElementById("emp_batch_id").value
	var room = document.getElementById("room_id").value
	var target = '/batches/assign_home_teacher_and_room'
	// Requ@elective_skillsest
	var data = {
		'course_id' : course_id,
		'batch_id' : batch_id,
		'room' : room,
		'teacher' : id
	}
	// $.getJSON('/batches/assign_home_teacher_and_room?course_id='+course_id +"&batch_id="+batch_id+"&room="+room+"&teacher="+teacher, function(dataFromGetRequest) {
	//
	// });
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#teacher_assign').empty();
				// $('#room_assign').empty();
				//
				var batch_teacher = data.batch_teacher
				// var batch_room = data.batch_room
				// if(batch_teacher.length >0)
				// {
				// $('#replace_teacher  span').html(batch_teacher);
				// }
				// if(batch_room.length >0)
				// {
				// $('#replace_room  span').html(batch_room);
				// }
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				$('#tags').val("");
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}

		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

	// $('.home_teacher').attr('checked', false);
	// if (is_check == true)
	// {
	// $(this).attr('checked', true);
	// }
	//
	// if ($(this).is(":checked"))
	// {
	// document.getElementById("emp_id").value = id
	// }else
	// {
	// document.getElementById("emp_id").value = ""
	// }
});

$(document).on("click", ".assign-href", function(event) {

	event.preventDefault();
	var aLink = $(this);
	var course_id = $(this).attr('data-course');
	var batch_id = $(this).attr('data-batch');
	var room = document.getElementById("room_id").value
	var teacher = document.getElementById("emp_id").value
	var target = '/batches/assign_home_teacher_and_room'
	// Requ@elective_skillsest
	var data = {

		'course_id' : course_id,
		'batch_id' : batch_id,
		'room' : room,
		'teacher' : teacher
	}
	// $.getJSON('/batches/assign_home_teacher_and_room?course_id='+course_id +"&batch_id="+batch_id+"&room="+room+"&teacher="+teacher, function(dataFromGetRequest) {
	//
	// });
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#teacher_assign').empty();
				$('#room_assign').empty();

				var batch_teacher = data.batch_teacher
				var batch_room = data.batch_room
				if(batch_teacher.length > 0) {
					$('#replace_teacher  span').html(batch_teacher);
				}
				if(batch_room.length > 0) {
					$('#replace_room  span').html(batch_room);
				}
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				$('#tags').val("");
				$('#teacher').val("");
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

});
///---------------------------------------

function assined_student(subject_id, elective, course_id, batch) {

	$.getJSON('/batches/subject_batch_student/' + subject_id, {
		elective : elective,
		course_id : course_id,
		batch : batch
	}, function(data) {
		students = data.all_students
		document.getElementById('assigned_student').value = students
		arr2 = students.split(',')
		
		jQuery.each(arr2, function(j, item1) {
			$('#modal .assign_student_batch_' + item1).attr('checked', true);
		})
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}


$(document).on("click", ".assign-student", function(event) {
	//$(".elective-skill-secound").each(function() {
	$('.modal-window block-border').css('top', '0px')
	var aLink = $(this);
	var subject_id = $(this).attr('data_subject');
	var course_id = document.getElementById('course_id_remove').value
	var elective = document.getElementById('elective_subject_id_group_' + subject_id).value;
	$('#modal-box-student #course_subject_id').val(subject_id)
	$('#modal-box-student #course_elective_id').val(elective)
	event.preventDefault();
	var contents = $('#modal-box-student');

	$.modal({
		content : contents,
		title : 'Assign Student To Subject',
		width : 500,
		height : 400,
		buttons : {

			'Assign/Deassign' : function(win) {
				
				
				if($('#batch_name').val() == $('#modal #batch_select_batch_course_id').val())
				{
					$('#modal  #outer_block').removeBlockMessages().blockMessage('Cannot Assign or Deassign All students are permanent students', {
						type : 'error'
					});
				}else
				{
				if(document.getElementById("serial_no").value != "0") {
					var serial = document.getElementById("serial_no").value

					var students_ids = []
					index = 0
					for( i = 1; i <= serial; i++) {

						var is_select = $("#modal #select-student-id_" + i).is(":checked")
						if(is_select) {
							$("#modal #select-student-id_" + i).attr('data-student')
							students_ids[index] = $("#modal #select-student-id_" + i).attr('data-student')
							index++
						}

					}
					var target = '/batches/assign_student_to_sub1'
					// Requ@elective_skillsest
					var assign = document.getElementById('assigned_student').value

					var elective = $('#modal #course_elective_id').val()
					
					$.post(target, {
						subject_id : subject_id,
						students_ids : students_ids,
						course_id : course_id,
						assign : assign,
						elective : elective
					}, function(data) {

						win.closeModal();

					}).error(function(jqXHR, textStatus, errorThrown) {
						window.location.href = "/signin"
					});
				} else {
					$('#modal  #outer_block').removeBlockMessages().blockMessage('Cannot Assign or Deassign ', {
						type : 'error'
					});
				}}
			},
			'SelectAll' : function(win) {
				$('.select_all').attr('checked', true);
			},
			'DeselectAll' : function(win) {
				$('.select_all').attr('checked', false);
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
});
//==================== assign student

$(document).ready(function() {
	batch_replace()
	$("#modal #batch_select_batch_course_id").live("change", (function(event) {
		var aLink = $(this);
		var course_id = aLink.siblings('input').val();
		var str = "";
		event.preventDefault();
		$("#modal #batch_select_batch_course_id option:selected").each(function() {
			str = $(this).val();
		});
		if(str > 0) {
			$.get('/batches/assign_student_to_sub', {
				course_id : course_id,
				id : str
			}, function(dataFromGetRequest) {
				$('#modal #temp').empty();
				$('#modal #temp').html(dataFromGetRequest);
				$('.tabs').updateTabs();

				var elective = $('#modal #course_elective_id').val()
				var subject_id = $('#modal #course_subject_id').val()
				batch = $('#batch_name').val()
				
				assined_student(subject_id, elective, course_id, batch)
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		} else {
			$('#modal #temp').empty();

		}
	}));
});
function removestudent(win) {
	var serial = document.getElementById("student_serial_no").value
	var subject_id = document.getElementById("subject_id_remove").value
	var course_id = document.getElementById("course_id_remove").value
	var elective = $('#modal #course_elective_id').val()
	var students_ids = []
	index = 0
	for( i = 1; i <= serial; i++) {

		var is_select = $("#modal #student-id-select_" + i).is(":checked")
		if(is_select) {

			students_ids[index] = $("#modal #student-id-select_" + i).attr('data-student')
			index++
		}

	}
	var target = '/batches/remove_student_to_sub1'
	// Requ@elective_skillsest

	$.getJSON(target, {
		subject_id : subject_id,
		students_ids : students_ids,
		course_id : course_id,
	}, function(data) {

		win.closeModal();
		// for(i=1;i<=serial;i++)
		// {
		//
		// var is_select = $("#modal #student-id-select_"+i).is(":checked")
		// if(is_select)
		// {
		//
		// $("#modal #student-id-select_"+i).empty();
		// }
		//
		// }

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}


$(document).on("click", ".add-subject-batch-tab-href", function(event) {

	event.preventDefault();
	var course_id = $(this).attr('data-course');
	var object_id = $(this).siblings('input').val();
	var contents = $('#modal-box-batch-subject-assign_' + course_id + "_" + object_id);
	$(".child_checkbox").attr('checked', false);
	$(".parent_checkbox").attr('checked', false);
	$.getJSON('/batches/find_batch_subjects', {
		batch_id : object_id,
		course_id : course_id
	}, function(data) {
		subject = data.subject
		$(".modal-window #count_of_data").val(data.count)
		$.each(subject, function(index, value) {
			$(".modal-window #skills_selected input").filter('[data_skill_id = ' + value + ']').attr('checked', true)
		})
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});

	$.modal({
		content : contents,
		title : 'Step 1 :- Subject Selection',
		width : 450,
		height : 450,
		buttons : {

			'Assign' : function(win1) {
				var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
				skills_ids = []
				full_data = []
				single = {}
				blank = ""
				is_noneric = ""
				actual_count = 0
				jQuery.each($(".modal-window #skills_selected input").filter('[checked = checked]').filter('.child_checkbox'), function(event) {
					skills_ids.push($(this).attr('data_skill_id'))
					single = {}
					single["name"] = $("#modal #name_" + $(this).attr('data_skill_id')).text()
					single["max_weekly_classes"] = $("#modal #clases_" + $(this).attr('data_skill_id') + " input").val()
					actual_count = actual_count + parseInt(single["max_weekly_classes"])
					if(single["max_weekly_classes"] != "" && !numericReg.test(single["max_weekly_classes"])) {
						is_noneric = "no"
					}

					single["batch_id"] = object_id
					single["code"] = $.trim($("#modal #code_" + $(this).attr('data_skill_id')).text())

					// if($("#modal #code_" + $(this).attr('data_skill_id') + " input").val() == "") {
					// blank = "yes"
					// }
					single["is_common"] = $("#modal #common_" + $(this).attr('data_skill_id') + " input").is(':checked')
					if($("#modal #exam_" + $(this).attr('data_skill_id') + " input").is(':checked')) {
						single["no_exams"] = true
					} else {
						single["no_exams"] = false
					}
					single["class_timing_id"] = $("#modal #period_" + $(this).attr('data_skill_id') + " select").val();

					single["employee_id"] = $("#modal #teacher_" + $(this).attr('data_skill_id') + " select").val();
					single["skill_id"] = $(this).attr('data_skill_id')
					full_data.push(single)
				});
				// } else {
				// Target url

				required_count = $("#modal #count_of_data").val()

				var target = '/batches/assign_skill_to_batch'
				// Requ@elective_skillsest
				if(skills_ids.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage("Please select atleast one skill", {
						type : 'warning'
					});
					return false
				} else if(blank == "yes") {
					$('#modal #outer_block').removeBlockMessages().blockMessage("Code can't be blank", {
						type : 'warning'
					});
					return false
				} else if(is_noneric == "no") {
					$('#modal #outer_block').removeBlockMessages().blockMessage("Max weekly classes should be numeric", {
						type : 'warning'
					});
					return false
				}
				// else if(actual_count != required_count) {
				// $('#modal #outer_block').removeBlockMessages().blockMessage("Max weekly classes should be " + required_count, {
				// type : 'warning'
				// });
				// return false
				// }
				else {
					data = {
						'full_data' : full_data,
						'batch_id' : object_id,
						'course_id' : course_id,
						'skills_id' : skills_ids,
					}

					skill_assign_subject(target, data, course_id, object_id, win1);
				}

			},
			'Close' : function(win) {
				win.closeModal();

			}
		}
	});

})
function skill_assign_subject(target, data, course_id, object_id, win1) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				if(data.name_sub.length > 0) {
					modal_fun(data.name_sub);
					next_step(course_id, object_id)
					win1.closeModal();
					return false
					// $('#modal #outer_block').removeBlockMessages().blockMessage(data.name_sub, {
					// type : 'warning'
					// });

				} else {
					$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
						type : 'success'
					});
					next_step(course_id, object_id)
					win1.closeModal();
				}
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
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

function next_step(course_id, object_id) {

	$.getJSON('/batches/find_batch_subjects', {
		batch_id : object_id,
		course_id : course_id
	}, function(data) {
		subject = data.sub_id
		name_sub = data.sub_name
		elective = data.sub_elective
		if(subject.length == 0) {
			$("#modal #skills_elective_assign").append('<tr><td colspan="2">Subjects are not available</td></tr>')
		} else {
			$.each(subject, function(index, value) {
				$("#modal #skills_elective_assign").append('<tr><td ><input type="checkbox" name="batch_assign_subject" class = "child_checkbox_elective" data_sub = "' + value + '"/></td><td>' + name_sub[index] + '</td><td id = "elective_' + value + '">' + elective[index] + '</td></tr>')
			})
		}
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
	var cont = $('#modal-box_next_step');

	$.modal({
		content : cont,
		closeButton : false,
		title : 'Step 2 :- Make Electives',
		width : 700,
		height : 300,
		buttons : {
			'Create' : function(win) {
				subject_ids = []
				jQuery.each($("#modal #skills_elective_assign input").filter('[checked = checked]'), function(event) {
					subject_ids.push($(this).attr('data_sub'))
				})
				if(subject_ids.length < 2) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please select atleast two  subject', {
						type : 'warning'
					});
				} else {
					var content_modal = $('#modal-box_elective_group');
					$.modal({
						content : content_modal,
						title : 'Elective Group',
						maxWidth : 500,
						buttons : {
							'Create' : function(win3) {
								var name = $('#modal #elective_group_text').val()
								var notnumericcharacterReg = /^\s*[a-zA-Z,_,\-,\.,\s]+\s*$/;
								if(name.length == 0) {
									$('#modal-box_elective_group #outer_block').removeBlockMessages().blockMessage('Please enter name', {
										type : 'warning'
									});
								} else if(!notnumericcharacterReg.test(name)) {
									$('#modal-box_elective_group #outer_block').removeBlockMessages().blockMessage('Please enter only character value for name', {
										type : 'warning'
									});
								} else {
									$.getJSON('/batches/create_elective_group', {
										batch_id : object_id,
										course_id : course_id,
										subject_ids : subject_ids,
										name : name
									}, function(data) {
										if(data.valid) {
											win3.closeModal();
											$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
												type : 'success'
											});
											$.each(subject_ids, function(index, value) {
												$("#modal #elective_" + value).text(name)
											})
										} else if(data.valid == "error") {
											$('#modal-box_elective_group #outer_block').removeBlockMessages().blockMessage(data.notice, {
												type : 'warning'
											});
										} else {
											var errorText = getErrorText(data.errors);
											$('#modal-box_elective_group  #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
												type : 'error'
											});

										}

									})
								}
							},
							'Close' : function(win3) {
								win3.closeModal();

							},
						}
					})

				}

			},
			'Close' : function(win) {
				win.closeModal();
				window.parent.location.reload()
			}
		}
	});
}

function modal_fun(name_sub) {
	$.modal({
		content : name_sub + " subject can't be deleted",
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win2) {
				win2.closeModal();

			},
		}
	})
}


$(document).on("click", ".parent_checkbox", function(event) {
	if($(this).is(":checked")) {
		$('.child_checkbox').attr('checked', true);
	} else {
		$('.child_checkbox').attr('checked', false);
	}
})

$(document).on("click", ".child_checkbox", function(event) {
	$('.parent_checkbox').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
	} else {
		$(this).attr('checked', false);
	}

})
$(document).on("click", ".parent_checkbox_elective", function(event) {
	if($(this).is(":checked")) {
		$('.child_checkbox_elective').attr('checked', true);
	} else {
		$('.child_checkbox_elective').attr('checked', false);
	}
})

$(document).on("click", ".child_checkbox_elective", function(event) {
	$('.parent_checkbox_elective').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
	} else {
		$(this).attr('checked', false);
	}

})
//====================history
$(document).ready(function() {
	$("#history_select_courses").val(0);
	$("#history_batch_select").val(0);

});

$(document).ready(function() {
	$("#history_select_courses").live("change", (function(event) {
		var str1 = "";
		event.preventDefault();
		$("#history_select_courses option:selected").each(function() {
			str1 = $(this).val();
		});

		$(".load").append('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 /><strong></strong>');
		if(str1.length == 0) {
			$("#history_batch_select").val(0);
			$(".load img").remove();
			$(".load strong").remove();
			$('#full_history').empty();

		} else {
			$.get('/batches/history_select_course', {
				course_id : str1
			}, function(dataFromGetRequest) {
				$('#history_batch_select_batch').empty();
				$('#history_batch_select_batch').html(dataFromGetRequest);
				$(".load img").remove();
				$(".load strong").remove();
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		}

	}));
});

$(document).ready(function() {

	$("#history_batch_select").live("change", (function(event) {
		var aLink = $(this);
		var course_id = $("#history_select_courses").val();
		var str = "";
		event.preventDefault();
		$("#history_batch_select option:selected").each(function() {
			$('#loading').show();
			str = $(this).val();
		});
		if(str.length == 0) {
			$("#history_select_courses").val(0);
			$('#full_history').empty();

		} else {
			$.get('history_select_batch/' + str, {
				course_id : course_id
			}, function(dataFromGetRequest) {
				$('#full_history').empty();
				$('#full_history').html(dataFromGetRequest);
				$('.tabs').updateTabs();
				configureStudentTable($('.students-table'));
				configureHistorySubjectTable($('#history_subject-table'));
				configureHistoryEmpAdvanceListTable($('.history_emp_add_list'));
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		}
	}));
});
