// $(document).on("click", "#skillsid", function(event) {
// var aLink = $(this);
// var elective_id = aLink.siblings('input').val();
// $.ajax({
// url : "/courses/skills/" + elective_id,
// });
// });
// $(document).on("click", ".tab-course_tab", function(event) {
// var aLink = $(this);
// var id =  $(this).attr('id');
// var course = $(this).attr('data-course');
// var object_id = aLink.siblings('input').val();
// $.get('/courses/viewall', { id: object_id, course_for: course }, function(data) {
// //$.get('/courses/viewall?id =' + object_id +','+ 'course_for ='+ course, function(data) {
// $('#tab_'+ object_id).empty();
// $('#tab_'+ object_id).html(data);
// $('.tabs').updateTabs();
//
// });
// });

// $(document).on("click", "#elective-skills_tab", function(event) {
// var aLink = $(this);
// var course = $(this).attr('data-course');
// var object_id = $(this).attr('data-elective');
// $.get('/elective_skills/show/'+ object_id, { course_id: course }, function(data) {
// //$.get('/courses/viewall?id =' + object_id +','+ 'course_for ='+ course, function(data) {
// $('#tab-elective_skills-tab_'+course+'_'+object_id).empty();
// $('#tab-elective_skills-tab_'+course+'_'+object_id).html(data);
// $('.tabs').updateTabs();
// });
// });

$(document).on("click", ".course_for_button", function(event) {

	var course_group = $(this).attr('data-course');
	var id = '#course_course_for_' + course_group;

	// Prevent link opening
	event.preventDefault();
	// Open modal

	$('#modal-box #course_course_name').val("");
	var contents = $('#modal-box');
	$.modal({
		content : contents,
		title : 'Course Creation',
		width : 700,
		height : 370,
		buttons : {

			'Create' : function(win) {

				var context = $('#modal #course_course_name');
				var course_name = $('#modal #course_course_name').val();
				var course_code = $('#modal #course_code').val();
				var section_name = $('#modal #course_section_name').val();
				var course_level = $('#modal #course_level').val();
				var batch = $('#modal #course_batches_attributes_0_name').val();
				var start_date = $('#modal #course_batches_attributes_0_start_date').val();
				var end_date = $('#modal #course_batches_attributes_0_end_date').val();
				var course_for = "#" + course_group;
				var characterReg = /^\s*[a-zA-Z0-9,_,\+,\-,\s]+\s*$/;
				var numcharacterReg = /^\s*[a-zA-Z0-9,_,\+\-,\s]+\s*$/;
				var numericReg = /^\s*[0-9,\-,\s]+\s*$/;
				if(!course_name || course_name.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course name', {
						type : 'warning'
					});
				} else if(!characterReg.test(course_name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only characters in course name field', {
						type : 'warning'
					});
				} else if(!course_code || course_code.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course code', {
						type : 'warning'
					});
				} else if(!numcharacterReg.test(course_code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('special characters are not allowed in course code ', {
						type : 'warning'
					});
				} else if(!characterReg.test(section_name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter section name', {
						type : 'warning'
					});
				} else if(!course_level || course_level.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course level', {
						type : 'warning'
					});
				} else if(!numericReg.test(course_level)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter valid range from -3 to 21 in course level', {
						type : 'warning'
					});
				} else if(!batch || batch.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter batch name', {
						type : 'warning'
					});
				} else if(!characterReg.test(batch)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only characters in batch name field', {
						type : 'warning'
					});
				} else {
					// Target url
					var target = '/courses'
					// Requ@elective_skillsest
					var data = {
						'course[course_name]' : course_name,
						'course[code]' : course_code,
						'course[section_name]' : section_name,
						'course[level]' : course_level,
						'course[batches_attributes][0][name]' : batch,
						'course[batches_attributes][0][start_date]' : start_date,
						'course[batches_attributes][0][end_date]' : end_date,

						'course_value' : course_group
					}

					ajaxCreateCourse(target, data, course_group, win);
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

$(document).on("click", ".course", function(event) {
	//common for montessary, primary and high school tabs (at top of screen)
	var course_group = $(this).attr('data-course');
	var add_course_id = 'course_' + course_group;
	//id for add button

	// Prevent link opening
	event.preventDefault();
	// Open modal

	$('#modal-box #course_course_name').val("");
	var contents = $('#modal-box');
	$.modal({
		content : contents,
		title : 'Course Creation',
		width : 700,
		height : 370,
		buttons : {

			'Create' : function(win) {
				var context = $('#modal #course_course_name');
				var course_name = $('#modal #course_course_name').val();
				var course_code = $('#modal #course_code').val();
				var section_name = $('#modal #course_section_name').val();
				var course_level = $('#modal #course_level').val();
				var batch = $('#modal #course_batches_attributes_0_name').val();
				var start_date = $('#modal #course_batches_attributes_0_start_date').val();
				var end_date = $('#modal #course_batches_attributes_0_end_date').val();
				var characterReg = /^\s*[a-zA-Z0-9,_,\+,\-,\s]+\s*$/;
				var numcharacterReg = /^\s*[a-zA-Z0-9,_,\+\-,\s]+\s*$/;
				var numericReg = /^\s*[0-9,\-,\s]+\s*$/;
				if(!course_name || course_name.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course name', {
						type : 'warning'
					});
				} else if(!characterReg.test(course_name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only characters in course name field', {
						type : 'warning'
					});
				} else if(!course_code || course_code.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course code', {
						type : 'warning'
					});
				} else if(!numcharacterReg.test(course_code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('special characters are not allowed in course code ', {
						type : 'warning'
					});
				} else if(!characterReg.test(section_name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter section name', {
						type : 'warning'
					});
				} else if(!course_level || course_level.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course level', {
						type : 'warning'
					});
				} else if(!numericReg.test(course_level)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter valid range from -3 to 21 in course level', {
						type : 'warning'
					});
				} else if(!batch || batch.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter batch name', {
						type : 'warning'
					});
				} else if(!characterReg.test(batch)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only characters in batch name field', {
						type : 'warning'
					});
				} else{
					// Target url
					var target = '/courses'
					// Requ@elective_skillsest
					var data = {
						'course[course_name]' : course_name,
						'course[code]' : course_code,
						'course[section_name]' : section_name,
						'course[level]' : course_level,
						'course[batches_attributes][0][name]' : batch,
						'course[batches_attributes][0][start_date]' : start_date,
						'course[batches_attributes][0][end_date]' : end_date,
						'course_value' : course_group // TODO change this varaiable name to course_group here and also in controller
					}

					ajaxCreateCourse(target, data, course_group, win);
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
// jQuery(document).on("click", "#course_<%= course_for %>", function(event) {
// alert('rajan')
// });
// $(document).on("click", "#create_course", function(event) {
// $(this).getModalWindow().setModalTitle('New title');
// var content = $(this).getModalWindow().getModalContentBlock();
// var tmp = $($.modal.current, 'form#course_code_rajan').val();
// alert(tmp);
// return false;
// });
// $(document).on("click", "#create_course", function(event) {
//var tmp = $($(this).getModalWindow(), '#course_code_rajan').val();
// var context = $('#outer_block_new');
// //var value = $(context, 'form#course_code').val();
// alert(context.attr("nodeName"));
// return false;
// });

function ajaxCreateCourse(target, data, course_group, win) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
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
				var course_id = data.course_id

				// window.location.href = window.location;
				$.get('/courses?course_for=' + course_group, function(dataFromGetRequest) {
					$('#' + course_group).empty();
					$('#' + course_group).html(dataFromGetRequest);
					$('.side-tabs').updateTabs();
					$('.tabs').updateTabs();
					window.parent.location.reload(window.location)
					// window.location.href = window.location;
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});
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

// batch delete
$(document).on("click", ".delete-batch-href", function(event) {

	var aLink = $(this);
	var course_id = $(this).attr('data-course');
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = "/batches/?id=" + object_id + "&course_id=" + course_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});
$(document).on("click", ".delete-course-href", function(event) {

	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = "/batches" + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});
///=========================================================course edit
$(document).on("click", ".update-course-href", function(event) {
	//$(".elective-skill-secound").each(function() {
	var aLink = $(this);
	var object_id = $(this).attr('data-course_id');
	var name = $(this).attr('data-name');
	var code = $(this).attr('data-code');
	var sec = $(this).attr('data-section');
	var course_group = $(this).attr('data-course_for');
	var dd = $('#course_name_text_' + object_id).html()
	$('#modal-box-edit #course_course_name').val(name);
	$('#modal-box-edit #course_code').val(code);
	$('#modal-box-edit #course_section_name').val(sec);
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-edit');

	$.modal({
		content : contents,
		title : 'Course Updation',
		width : 700,
		height : 250,
		buttons : {

			'Update' : function(win) {

				var context = $('#modal #course_course_name');
				var course_name = $('#modal #course_course_name').val();
				var course_code = $('#modal #course_code').val();
				var section_name = $('#modal #course_section_name').val();
				var characterReg = /^\s*[a-zA-Z0-9,_,\+,\-,\s]+\s*$/;
				var numcharacterReg = /^\s*[a-zA-Z0-9,_,\+\-,\s]+\s*$/;
				var numericReg = /^\s*[0-9,\-,\s]+\s*$/;
				if(!course_name || course_name.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course name', {
						type : 'warning'
					});
				} else if(!characterReg.test(course_name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only characters in course name field', {
						type : 'warning'
					});
				} else if(!course_code || course_code.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course code', {
						type : 'warning'
					});
				} else if(!numcharacterReg.test(course_code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('special characters are not allowed in course code ', {
						type : 'warning'
					});
				} else if(!characterReg.test(section_name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter section name', {
						type : 'warning'
					});
				}
				// else if(!numericReg.test(course_level)) {
				// $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course level', {
				// type : 'warning'
				// });
				// }
				else {
					// Target url
					var target = '/courses/' + object_id
					// Requ@elective_skillsest
					var data = {
						'course[course_name]' : course_name,
						'course[code]' : course_code,
						'course[section_name]' : section_name,
						'course_value' : course_group, // TODO change this varaiable name to course_group here and also in controller
						'_method' : 'put'

					}
					ajaxCreateCourse(target, data, course_group, win);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
});
/////==============================================delete

$(document).on("click", ".delete-course-tab-href", function(event) {
	var aLink = $(this);
	var object_id = aLink.siblings('input').val();
	var course_group = $(this).attr('data-course-for');
	var remoteUrl = "/courses" + "/" + object_id;
	confirmDeleteCourseModal(remoteUrl, course_group);
	return false;
});
function confirmDeleteCourseModal(remoteUrl, course_group) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				win.closeModal();
				ajaxDeleteCourseModal(remoteUrl, course_group);
				return false;
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteCourseModal(remoteUrl, course_group) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$.get('/courses?course_for=' + course_group, function(dataFromGetRequest) {
					$('#' + course_group).empty();
					$('#' + course_group).html(dataFromGetRequest);
					$('.side-tabs').updateTabs();
					$('.tabs').updateTabs();
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});
			} else {
				$('#warning').removeBlockMessages().blockMessage('This course cannot be deleted because of batches dependency', {
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

}