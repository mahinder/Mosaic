function class_time(batch_name, batch) {
	var time_start_hour = ""
	var time_start_minute = ""

	$.get('/class_timings/find_class_timing', {
		batch_name : batch_name,
		batch : batch
	}, function(getData) {
		
		$("#modal-box #class_timing_start_time_4i").val(getData.time_start_hour);
		$("#modal-box #class_timing_start_time_5i").val(getData.time_start_minute);
		$("#modal-box #class_timing_end_time_4i").val(getData.change);
		$("#modal-box #class_timing_end_time_5i").val(getData.time_start_minute);

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}


$(document).on("click", ".class_timing", function(event) {
	var batch = $(this).attr('data-batch_id');
	var batch_name = $(this).attr('data-batch');
	$("#modal-box h1").html("Add New Class Timing For " + batch_name);
	class_time(batch_name, batch)

	// Prevent link opening
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box');
	$.modal({
		content : contents,
		title : 'Add Class Timing',
		width : 700,
		height : 250,
		buttons : {
			
			'Create' : function(win) {

				var name = $('#modal #class_timing_name').val();
				var start_time1 = $('#modal #class_timing_start_time_1i').val();
				var start_time2 = $('#modal #class_timing_start_time_2i').val();
				var start_time3 = $('#modal #class_timing_start_time_3i').val();
				var start_time4 = $('#modal #class_timing_start_time_4i').val();
				var start_time5 = $('#modal #class_timing_start_time_5i').val();
				var end_time1 = $('#modal #class_timing_end_time_1i').val();
				var end_time2 = $('#modal #class_timing_end_time_2i').val();
				var end_time3 = $('#modal #class_timing_end_time_3i').val();
				var end_time4 = $('#modal #class_timing_end_time_4i').val();
				var end_time5 = $('#modal #class_timing_end_time_5i').val();
				var is_break = $('#modal #class_timing_is_break').is(":checked");
				var common = ""
				if(is_break == true) {
					common = "true"
				} else {
					common = "false"
				}

				$.get('/class_timings/find_class_timing', {
					batch_name : batch_name,
					batch : batch
				}, function(getData) {
					
					// if(getData.time_start_hour != start_time4 || getData.time_start_minute != start_time5) {
						// $('#modal #outer_block').removeBlockMessages().blockMessage('Please set start timing from previous class timing end time', {
							// type : 'warning'
						// });
					// } else 
					if(!name || name.length == 0) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter  name', {
							type : 'warning'
						});
					} else {
						// Target url
						var target = '/class_timings'
						// Requ@elective_skillsest
						var data = {
							'class_timing[name]' : name,
							'class_timing[start_time(1i)]' : start_time1,
							'class_timing[start_time(2i)]' : start_time2,
							'class_timing[start_time(3i)]' : start_time3,
							'class_timing[start_time(4i)]' : start_time4,
							'class_timing[start_time(5i)]' : start_time5,
							'class_timing[end_time(1i)]' : end_time1,
							'class_timing[end_time(2i)]' : end_time2,
							'class_timing[end_time(3i)]' : end_time3,
							'class_timing[end_time(4i)]' : end_time4,
							'class_timing[end_time(5i)]' : end_time5,
							'class_timing[is_break]' : common,
							'class_timing[batch_id]' : batch,

						}
						ajaxCreatetiming(target, data, win)

					}
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},'Close' : function(win) {
				win.closeModal();
			},
		}
	});
});
function ajaxCreatetiming(target, data, win) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {

				$('#loading').show();
				var getData = {
					//'course_value' : data_course_value,
					'class_timing_id' : data.class_timing_id
				}
				$.get('/class_timings/time', {
					class_timing_id : data.class_timing_id
				}, function(getData) {
					$('#class_timming').empty();
					$('#class_timming').html(getData);
					$('#loading').hide();

				});

				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
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

}

function ajaxUpdatetiming(target, data, win) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'put',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#loading').show();
				var getData = {
					//'course_value' : data_course_value,
					'class_timing_id' : data.class_timing_id
				}
				$.get('/class_timings/time', {
					class_timing_id : data.class_timing_id
				}, function(getData) {
					$('#class_timming').empty();
					$('#class_timming').html(getData);
					$('#loading').hide();

				});

				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
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
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}

		}
	});

}

// $(document).on("click", ".update-time-href", function(event) {
// //$(".elective-skill-secound").each(function() {
//
// var aLink = $(this);
// var object_id = $(this).attr('data-id');
// var start1 = $(this).attr('data-start1');
// var start2 = $(this).attr('data-start2');
//
// var end = $(this).attr('data-end');
// var name = $('#time_name_' + object_id).html();
// $('#modal-box-edit #class_timing_name').val(name);
// $('#modal-box-edit #class_timing_start_time_4i').val(10);
// $('#modal-box-edit #course_section_name').val(end);
// event.preventDefault();
// // Open modal
// var contents = $('#modal-box-edit');
//
// $.modal({
// content : contents,
// title : 'Update  course',
// width : 700,
// height : 200,
// buttons : {
// 'Close' : function(win) {
// win.closeModal();
// },
// 'Update' : function(win) {
//
// var context = $('#modal #course_course_name');
// var course_name = $('#modal #course_course_name').val();
// var course_code = $('#modal #course_code').val();
// var section_name = $('#modal #course_section_name').val();
// if(!course_name || course_name.length == 0) {
// $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter course name', {
// type : 'warning'
// });
// }  else {
// // Target url
// var target = '/courses/'+object_id
// // Requ@elective_skillsest
// var data = {
// 'course[course_name]' : course_name,
// 'course[code]' : course_code,
// 'course[section_name]' : section_name,
// 'course_value': course_group, // TODO change this varaiable name to course_group here and also in controller
// '_method' : 'put'
//
// }
// ajaxCreateCourse(target, data, course_group, win);
// }
// //var element = $(context, '#course_course_name');
//
// //win.closeModal();
// }
// }
// });
// });

$(document).ready(function() {
	$(".time").val(0);
	$(".course-select").val(0);

});

$(document).ready(function() {
	$(".time").live("change", (function(event) {
		var str = "";
		event.preventDefault();
		$(".time option:selected").each(function() {
			$('#loading').show();
			str = $(this).val();
		});
		$.get('/class_timings/1', {
			batch_id : str
		}, function(dataFromGetRequest) {
			$('#class_timming').empty();
			$('#class_timming').html(dataFromGetRequest);
			$('#loading').hide();
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
	}));
});

$(document).ready(function() {
	$(".course-select").live("change", (function(event) {
		var str = "";
		event.preventDefault();
		$(".course-select option:selected").each(function() {
			$('#loading').show();
			str1 = $(this).val();
		});
		$.get('/class_timings/batch', {
			id : str1
		}, function(dataFromGetRequest) {
			$('#batch-select').empty();
			$('#batch-select').html(dataFromGetRequest);
			$('#loading').hide();
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
	}));
});

$(document).on("click", ".delete-time-href", function(event) {

	var aLink = $(this);
	var object_id = aLink.siblings('input').val();
	var batch = $(this).attr('id');
	var remoteUrl = "/class_timings" + "/" + object_id;
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				$.ajax({
					url : remoteUrl,
					type : 'post',
					dataType : 'json',
					data : {
						'_method' : 'delete'
					},
					success : function(data, textStatus, jqXHR) {
						if(data.valid) {
							var batch_id = data.batch_id
							$.get('/class_timings/del_class_time', {
								id : batch_id
							}, function(data) {
								$('#class_timming').empty();
								$('#class_timming').html(data);
							});

							$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
								type : 'success'
							});
						} else {
							$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
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
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	return false;
});
