block = false
$(document).on("click", "#reportemployeedaily", function(event) {
	
	event.preventDefault();
	if(block == false)
	{
		block = true
	var empid = $(this).attr('data_emp');
	var subd = $(this).attr('data_sub');
	
	if(empid.length != 0) {
		start_date = $('#report_start_date').val();
		end_date = $('#report_end_date').val();

		var reg_for_date = /^\d{2}\-\d{2}\-\d{4}$/
		if(start_date.length == 0 || end_date.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Both Dates', {
				type : 'warning'
			});
			return false
		} else if(!reg_for_date.test(start_date) || !reg_for_date.test(end_date)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid dates ', {
				type : 'warning'
			});
			return false;
		} else {
			sdate = $.datepicker.parseDate('dd-mm-yy', start_date);
			edate = $.datepicker.parseDate('dd-mm-yy', end_date);

			if(sdate > edate) {
				$('#outer_block').removeBlockMessages().blockMessage('Start date should be less then end date', {
					type : 'warning'
				});
				return false
			} else if(sdate == edate) {
				$('#outer_block').removeBlockMessages().blockMessage('Must be one month gape between Start date and end date', {
					type : 'warning'
				});
			} else {

				$.get('/timetable/timetable_substitution_daily_report', {
					emp_id : empid,
					start_date : start_date,
					end_date : end_date,
					subd : subd
				}, function(data) {
				
					$.modal({
						content : data,
						width : 700,
						
						buttons : {
							'PDF' : function(win) {
								var inputData = {
									'emp_id' : empid,
									'start_date' : start_date,
									'end_date' : end_date,
									'subd' : subd
								}
								$.download('/timetable/dailytimetable_pdf', inputData, 'filename=timetable_pdf&format=pdf&content=' + inputData );			
									// window.location.href = "/timetable/dailytimetable_pdf?emp_id ="+ empid +"&start_date =" +start_date "&end_date ="+ end_date +"&subd =" + subd
							},
							'Close' : function(win) {
								win.closeModal();
							}
						}
					});
					
					configuredailyreportimployeeTable($('.report_employee_daily'));
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});
			}
		}

	}
	block = false
}

});

$(document).on("click", "#emp_rep_but", function(event) {
	event.preventDefault();
	start_date = $('#report_start_date').val();
	end_date = $('#report_end_date').val();
	checked_substitite_criteria =  $('#Substituted_Teacher_Wise').is(':checked')
	checked_substititewith_criteria =  $('#Substituted_With_Teacher_Wise').is(':checked')
	var howreport = "";
	var reg_for_date = /^\d{2}\-\d{2}\-\d{4}$/
	if(checked_substitite_criteria == false && checked_substititewith_criteria == false)
	{
		$('#outer_block').removeBlockMessages().blockMessage('Please Select Report Criteria', {
			type : 'warning'
		});
		return false
	}
	
	else if(start_date.length == 0 || end_date.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Both Dates', {
			type : 'warning'
		});
		return false
	} else if(!reg_for_date.test(start_date) || !reg_for_date.test(end_date)) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter valid dates ', {
			type : 'warning'
		});
		return false;
	} else {
		// start = start_date.split("-");
		// end = end_date.split("-");
		// alert(start)
		// alert(end)
		// s = new Date(start[2], start[1] - 1, start[0]);
		// e = new Date(end[2], end[1] - 1, end[0]);
		// alert(s)
		// alert(e)
		if(checked_substitite_criteria == true)
		{
			howreport = "substitute";
		}else
		{
			howreport = "substitutewith";
		}
		sdate = $.datepicker.parseDate('dd-mm-yy', start_date);
		edate = $.datepicker.parseDate('dd-mm-yy', end_date);

		if(sdate > edate) {
			$('#outer_block').removeBlockMessages().blockMessage('Start date should be less then end date', {
				type : 'warning'
			});
			return false
		} else if(sdate == edate) {
			$('#outer_block').removeBlockMessages().blockMessage('Must be one month gape between Start date and end date', {
				type : 'warning'
			});
		} else {
			$.get('/timetable/timetable_substitution_monthly_report', {
				start_date : start_date,
				end_date : end_date,
				howreport : howreport
			}, function(dataFromGetRequest) {
				$('#employee_monthly_report').empty();
				$('#employee_monthly_report').html(dataFromGetRequest);
				configurereportimployeeTable($('.report_employee'));
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		}
	}
})

$(document).on("click", "#button_employee_info", function(event) {
	event.preventDefault();
	$('#create_form_time').empty();
})

$(document).on("click", ".employee_info_click", function(event) {
	event.preventDefault();
	str1 = $(this).parent('li').attr("data_employee")
	$.get('/timetable/employee_info', {
		id : str1
	}, function(dataFromGetRequest) {

		$('#create_form_time').empty();
		$('#create_form_time').html(dataFromGetRequest);

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
})
$("#employee_find_batch").fcbkmcomplete({
	json_url : "/timetable/find",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : true,
	newel : true,
	// select_all_text : "select",
});

function showCursorMessage(data, emp_assign) {
	$.cursorMessage(data + emp_assign, {
		hideTimeout : 0
	});
}

function showCursorMessage1(emp_assign) {
	$.cursorMessage(emp_assign, {
		hideTimeout : 0
	});
}

function hideCursorMessage() {
	$.hideCursorMessage();
}


$(document).ready(function() {
	$('#employees_first_name_id').val(0);

	var d = new Date();
	$('.day' + (d.getDay() + 1)).css({
		'background' : '-moz-linear-gradient(center top , white, #72C6E4 4%, #0C5FA5) repeat scroll 0 0 transparent',
		'border-color' : '#50A3C8 #297CB4 #083F6F'
	})

});
function calculateSum() {
	sum = 0;
	var serial_nos = document.getElementById('serial_id').value
	for( i = 1; i <= serial_nos; i++) {
		if(!isNaN(document.getElementById('text_serial_' + i).value) && document.getElementById('text_serial_' + i).value.length != 0) {
			sum += parseInt(document.getElementById('text_serial_' + i).value);
		}
	}
	if(sum > document.getElementById('simple-batch-class').value) {
		$('#error').show();
		document.getElementById('simple-batch-assign').value = document.getElementById('simple-batch-class').value
		document.getElementById('simple-batch-unassign').value = (document.getElementById('simple-batch-class').value - document.getElementById('simple-batch-assign').value)
	} else {
		$('#error').hide();
		document.getElementById('simple-batch-assign').value = sum
		document.getElementById('simple-batch-unassign').value = (document.getElementById('simple-batch-class').value - document.getElementById('simple-batch-assign').value)
	}
	t = setTimeout('calculateSum()', 100);
}


$(document).ready(function() {
	$(".course-select-timetable").live("change", (function(event) {
		var str = "";
		event.preventDefault();
		$(".course-select-timetable option:selected").each(function() {
			str1 = $(this).val();
		});
		if(str1 == "") {
			$("#time_batch p").empty();
			$("#class_per_week input").val(0);
			$("#assign_per_week input").val(0);
			$("#unassign_per_week input").val(0);
			$("#timetable_setting").empty()
		} else {
			$("#class_per_week input").val(0);
			$("#assign_per_week input").val(0);
			$("#unassign_per_week input").val(0);
			$("#timetable_setting").empty()
			$.get('/timetable/batch', {
				id : str1
			}, function(dataFromGetRequest) {
				$('#time_batch p').empty();
				$('#time_batch p').html(dataFromGetRequest);
				$("#timetable_setting").empty()
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		}

	}));
});
$(document).ready(function() {
	$(".timetable_batch").live("change", (function(event) {
		var str = "";
		event.preventDefault();
		$(".timetable_batch option:selected").each(function() {
			str = $(this).val();
		});
		if(str == "") {
			$("#class_per_week input").val(0);
			$("#assign_per_week input").val(0);
			$("#unassign_per_week input").val(0);
			$("#timetable_setting").empty()
		} else {
			$.get('/timetable/timetable_setting', {
				batch_id : str
			}, function(dataFromGetRequest) {
				$("#timetable_setting").empty()
				$('#timetable_setting').html(dataFromGetRequest);
				$("#timetable_button").show();
				$("#simple-batch-class").val(document.getElementById('batch_classes_per_week').value)
				calculateSum()
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		}

	}));
});

$(document).ready(function() {

	refresh()

});
function refresh() {
	$(".course-select-timetable").val(0);
	$("#time_batch p").empty();
	$("#class_per_week input").val(0);
	$("#assign_per_week input").val(0);
	$("#unassign_per_week input").val(0);
	$("#timetable_setting").empty();
	// $("#timetable_button").hide();
}


$(document).on("click", "#today_timetable_substitution", function(event) {
	event.preventDefault();
	link = $(this)
	class_time = link.attr('data_class');
	emp = link.attr('data_emp');
	emp1 = link.attr('data_emp1');
	sub = link.attr('data_sub');
	modalBox = $.modal({
		content : 'Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />',
	});
	$('.action-tabs').hide();
	$.get('/timetable/timetable_substitude_reassign', {
		class_time : class_time,
		emp : emp,
		emp1 : emp1,
		sub : sub
	}, function(data) {

		$.modal({
			content : data,
			title : 'Resubstitution',
			width : 1000,
			height : 300,
			buttons : {

				'Reassign/Deassign' : function(win) {

					var val = $(".today_timetable_sub input[type='radio']:checked")
					old = $("#substitute_with").is(':checked')
					var assign_emp = ""
					var deassign = ""
					var employee = link.attr('data_emp')
					var subject = link.attr('data_sub')
					var batch = link.attr('data_batch')
					var class_time = link.attr('data_class')
					var date = link.attr('data_date')
					if(old == true) {
						$.modal({
							content : '<h3>Are you sure?</h3><br/><br/><p>You are about to substitute same employee for Assign new or deassign please uncheck substitute with</p>',
							title : 'Warning',
							maxWidth : 500,
							buttons : {
								'OK' : function(win2, wind) {

									win2.closeModal();

								},
								'Cancel' : function(win2) {
									win2.closeModal();
								}
							}
						});
					} else {
						deassign = $("#substitute_with").attr('data_emp')
						assign_emp = val.attr('id')

						$.modal({
							content : '<h3>Are you sure?</h3><br/><br/><p>You are about to Re-substitute </p>',
							title : 'Warning',
							maxWidth : 500,
							buttons : {
								'OK' : function(win1, win) {

									$.getJSON('/timetable/reassign_substitute', {
										deassign : deassign,
										employee : employee,
										subject : subject,
										batch : batch,
										class_time : class_time,
										date : date,
										assign_emp : assign_emp
									}, function(dataFromGetRequest) {
										if(dataFromGetRequest.valid) {

											window.parent.location.reload()
											// {
											// message = row_count+" Time Slots Found"
											// }
											// else
											// {
											// message = row_count+" Time Slot Found"
											// }
											// var tab = '#table_'+employee+' li'

										} else {
											var errorText = getErrorText(data.errors);
											$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
												type : 'error'
											});
										}
									});

									win1.closeModal();
								},
								'Cancel' : function(win1) {
									win1.closeModal();
								}
							}
						});
					}

				},
				'Close' : function(win) {
					win.closeModal();
				}
			}
		});
		modalBox.closeModal();
		configurereassignTimetableSubTable($('#modal .today_timetable_sub'));

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
})

$(document).on("click", "#click_on_batch_name", function(event) {
	return false
})

$(document).on("click", "#create_timetable", function(event) {

	var aButton = $(this);
	var count = aButton.attr('data_count');
	var map = {}
	var object_id = document.getElementById('batch_class').value
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	emp_arr = []
	slot_arr = []
	for(var i = 1; i <= count; i++) {
		var subject = $('#td_' + i).attr('data_subject')
		var employee_max = $('#time_table_employee_' + subject).find('select').val()

		var slot_mx = $('#time_table_class_' + subject).find('select').val()
		if(slot_mx === undefined) {
			$('#outer_block').removeBlockMessages().blockMessage("Please  arrange All slots first", {
				type : 'warning'
			});
			emp_arr = []
			slot_arr = []
			return false
		} else {
			if(employee_max != undefined) {
				emp_arr.push(employee_max);
			}
			slot_arr.push(slot_mx);
		}
	}

	if(emp_arr.length > 0) {
		$.getJSON('/timetable/emp_max_find', {
			emp_arr : emp_arr,
			object_id : object_id,
			slot_arr : slot_arr
		}, function(dataFromGetRequest) {

			if(dataFromGetRequest.valid) {

				gowork()
			} else {
				$.modal({
					content : '<p> Are you Sure ' + dataFromGetRequest.notice + ' are already assigned on the same slot to other classes </p>',
					title : 'Warning',
					maxWidth : 500,
					buttons : {
						'OK' : function(win) {
							gowork()
							win.closeModal();
						},
						'Cancel' : function(win) {
							win.closeModal();
						}
					}
				});
			}
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
	} else {
		gowork()
	}
	function gowork() {

		for(var i = 1; i <= count; i++) {
			var subject = $('#td_' + i).attr('data_subject')
			var max_class = $('#time_table_text_' + subject).find('input').val()
			var employee = $('#time_table_employee_' + subject).find('select').val()
			var slot = $('#time_table_class_' + subject).find('select').val()
			var room = $('#time_table_room_' + subject).find('select').val()
			if(max_class == "" || !numericReg.test(max_class)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter proper Classes/Week', {
					type : 'warning'
				});
				map = {}
				return false
			} else if(slot === undefined) {
				$('#outer_block').removeBlockMessages().blockMessage("Please arrange All slots", {
					type : 'error'
				});
				map = {}
				return false

			} else {
				var str = subject + ',' + max_class + ',' + employee + ',' + slot + ',' + room
				map[i] = str
			}
		}
		map_index = 0
		$.map(map, function(a) {
			map_index = map_index + 1
		});
		if(map_index > 0) {
			$.ajax({
				url : '/timetable',
				dataType : 'json',
				type : 'post',
				data : {
					map : map,
					batch_id : object_id
				},
				success : function(data, textStatus, jqXHR) {
					if(data.already) {
						$.modal({
							content : '<p> Timetable is already created for batch </p>',
							title : 'Warning',
							maxWidth : 500,
							buttons : {
								'OK' : function(win) {

									window.location.href = "/timetable/" + data.batch_id;
									win.closeModal();
								},
							}
						});

					} else {
						if(data.valid) {
							var object_id = document.getElementById('batch_class').value
							$.getJSON('/timetable/set_timetable/' + object_id, function(dataFromGetRequest) {
								window.location.href = "/timetable/" + object_id;
							});

							$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
								type : 'success'
							});

						} else {
							// Message
							var errorText = getErrorText(data.errors);
							$('#outer_block').removeBlockMessages().blockMessage('An unexpected error occured, please try again', {
								type : 'error'
							});

						}
					}
				},
			});
		}
		// Message

	}

});
// $(document).on("click", "#window_open", function(event) {
// var object_id = document.getElementById('batch_class').value
// //
// // $.getJSON('/timetable/set_timetable/' + object_id, function(dataFromGetRequest) {
// //
// // });
// var url = "/timetable/";
// $.get(url + object_id, function(dataFromGetRequest) {
//
// });
//
// // window.open(url + object_id, windowName);
// event.preventDefault();
// });
function load(e) {
	$(".li_select").draggable({
		helper : "clone",
		start : function(event, ui) {
			var id = $(this).attr('data_sub_id')
			var emp = $(this).attr('data_employee')
			var batch = document.getElementById('timebatch').value
			$.getJSON('/timetable/find_max_class/' + id, {
				emp : emp,
				batch : batch
			}, function(dataFromGetRequest) {
				if(dataFromGetRequest.valid) {
					showCursorMessage(dataFromGetRequest.notice, dataFromGetRequest.emp_assign);
				} else {
					$("#cart li.orange").css('background', '#B3E6B1')
					showCursorMessage1(dataFromGetRequest.emp_assign);
				}
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		},
		stop : function(event, ui) {
			hideCursorMessage()
			$('#message_max').removeBlockMessages()
			$("#cart li.orange").css('background', '')

		}
	});
	$("#cart .sun .dropable").droppable({

		activeClass : "ui-state-default",
		hoverClass : "over",
		accept : ":not(.ui-sortable-helper)",
		drop : function(event, ui) {
			$(this).css('background', '')
			if(ui.draggable.hasClass('orange')) {
			} else {
				if(ui.draggable.hasClass('purple')) {
					var id = ui.draggable.attr('data_sub')
					var classtime = $(this).attr('data_class')
					var week = $(this).attr('data_week')
					var teacher = ui.draggable.attr('data_emp')
					var batch = document.getElementById("timebatch").value
					var classtime1 = ui.draggable.attr('data_class')
					var week1 = ui.draggable.attr('data_week')

					var tt = ui.draggable
					$(this).attr('data_emp', teacher).attr('data_id_elec', ui.draggable.attr('data_id_elec')).attr('data_sub', ui.draggable.attr('data_sub')).removeClass("orange ui-droppable ui-state-default").addClass("purple ui-draggable").empty().append(ui.draggable.html())
					ui.draggable.empty().attr('data_id_elec', '').attr('data_sub', '').attr('data_emp', '').removeClass("purple ui-draggable draggable ui-draggable-dragging").addClass("orange");
					$.getJSON('/timetable/add_entry/' + id, {
						classtime : classtime,
						week : week,
						teacher : teacher,
						batch : batch,
						classtime1 : classtime1,
						week1 : week1
					}, function(dataFromGetRequest) {

					}).error(function(jqXHR, textStatus, errorThrown) {
						window.location.href = "/signin"
					});
				} else {

					var id = ui.draggable.attr('data_sub_id')
					var classtime = $(this).attr('data_class')
					var week = $(this).attr('data_week')
					var teacher = ui.draggable.attr('data_employee')
					var batch = document.getElementById("timebatch").value
					$(this).attr('data_sub', id).attr('data_emp', teacher).attr('data_id_elec', ui.draggable.attr('data_elective')).removeClass("orange ui-droppable ui-state-default").addClass("purple ui-draggable").empty().append(ui.draggable.attr('data_sub_name') + '<ul class="mini-menu wigh" ><li>' + ui.draggable.text() + '<img width="16" height="16" src="/assets/icons/fugue/cross-circle.png" class = "delete"></li><li></li></ul>')

					$.getJSON('/timetable/add_entry/' + id, {
						classtime : classtime,
						week : week,
						teacher : teacher,
						batch : batch
					}, function(dataFromGetRequest) {

					}).error(function(jqXHR, textStatus, errorThrown) {
						window.location.href = "/signin"
					});
					stack:"#cart"
				}

				load(e)
			}
		}
	});

	$("#cart .sun .purple").draggable({

		drag : function(event, ui) {
			var hig = $(this).height();
			var widt = $(this).width();
			$(this).height(hig);
			$(this).width(widt);

		},
		start : function(event, ui) {
			var li_id = $(this).parents('li').css('z-index', '100')
			$(this).css('z-index', '2')
			$(this).siblings().css('z-index', '1')
		},
		stop : function(event, ui) {
			var li_id = $(this).parents('li').css('z-index', 'auto')
			$(this).css('z-index', 'auto')
			$(this).siblings().css('z-index', 'auto')
		},
		containment : "#cart",
		scroll : false,
		// stack : "#cart li",
		revert : true
	});
}


$(document).ready(function(e) {
	load(e);
	$("#subject_select_teacher").val(0);

});
$(document).on("click", ".delete", function(event) {
	var li_id = $(this).parents('li.purple')
	var classtime = li_id.attr('data_class')
	var week = li_id.attr('data_week')
	var batch = li_id.attr('data_batch')

	$.getJSON('/timetable/remove_entry/', {
		classtime : classtime,
		week : week,
		batch : batch
	}, function(data) {

		if(data.valid) {
			li_id.empty().removeClass("purple ui-draggable draggable ui-draggable-dragging").addClass("orange");
		}

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
	load(event);

})

$(document).ready(function() {

	$("#subject_select_teacher").live("change", (function(event) {
		var aLink = $(this);
		var str = "";
		event.preventDefault();
		$("#subject_select_teacher option:selected").each(function() {
			str = $(this).val();
		});
		if(str == "") {
			$('#catalog').empty();
			$('#create_form_time').empty();
		} else {
			$.get('/timetable/list_employee_by_subject/' + str, function(dataFromGetRequest) {
				$('#catalog').empty();
				$('#catalog').html(dataFromGetRequest);
				load(event);
			}).error(function(jqXHR, textStatus, errorThrown) {
				window.location.href = "/signin"
			});
		}
	}));
});
$(document).on("click", "#Publish", function(event) {
	var aLink = $(this);
	var batch_id = document.getElementById("timebatch").value
	var arr = [];
	var class_time = []
	var week = []
	index = 0;
	($("#cart li").filter('[data_id_elec = elective]')).each(function() {
		arr[index] = $(this).attr('data_sub')
		class_time[index] = $(this).attr('data_class')
		week[index] = $(this).attr('data_week')
		index++
	});
	$.getJSON('/timetable/generate_subject_wise/' + batch_id, {
		arr : arr,
		week : week,
		class_time : class_time
	}, function(dataFromGetRequest) {

	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});

	$(".lodar").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 /><strong></strong>');
	$.getJSON('/timetable/generate/' + batch_id, function(dataFromGetRequest) {
		$('#outer_block').removeBlockMessages().blockMessage(dataFromGetRequest.notice, {
			type : 'success'
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
		$(".lodar").empty()
	});
	return false
})
togal = 0;
togals = 0;
$(document).on("click", "#elective", function(event) {
	if(togal == 0) {
		$("#cart li").filter('[data_id_elec = elective]').css('background', '#e6f7d9')
		togal = 1
	} else {
		$("#cart li").filter('[data_id_elec = elective]').css('background', '')
		togal = 0
	}
	return false
})
$(document).on("click", "#empty", function(event) {
	if(togals == 0) {
		$("#cart li.orange").css('background', '#B3E6B1')
		togals = 1
	} else {
		$("#cart li.orange").css('background', '')
		togals = 0
	}
	return false
})
$(document).on("click", "#elective1", function(event) {
	if(togal == 0) {
		$("#cart1 li").filter('[data_id_elec = elective]').css('background', '#e6f7d9')
		togal = 1
	} else {
		$("#cart1 li").filter('[data_id_elec = elective]').css('background', '')
		togal = 0
	}
	return false
})
$(document).on("click", "#empty1", function(event) {
	if(togals == 0) {
		$("#cart1 li.orange").css('background', '#B3E6B1')
		togals = 1
	} else {
		$("#cart1 li.orange").css('background', '')
		togals = 0
	}
	return false
});

$(document).on("click", ".view_employees_time_table", function(event) {
	var str = "";
	$("#employee_find_batch option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			str = $(this).attr('value')
		} else {

		}

	})
	$('#loading').show();
	if(str != "") {
		window.location.href = "/timetable/employee_full_view/" + str;
	} else {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter valid entry', {
			type : 'error'
		});
	}

});

$(document).on("click", "#substitude", function(event) {
	event.preventDefault();
	link = $(this)
	class_time = link.attr('data_class');
	emp = link.attr('data_emp')
	sub = link.attr('data_sub')
	modalBox = $.modal({
		content : 'Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />',
	});
	$('.action-tabs').hide();

	$.get('/timetable/free_teacher', {
		class_time : class_time,
		emp : emp,
		sub : sub
	}, function(dataFromGetRequest) {
		$('#modal-box-emp_substitute').empty();
		$('#modal-box-emp_substitute').html(dataFromGetRequest);
		change(event, link, modalBox)
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});
function change(event, link, modalBox) {

	var contents = $('#modal-box-emp_substitute');
	$.modal({
		content : contents,
		title : 'List of Teachers',
		width : 700,
		height : 375,
		buttons : {
			'Assign' : function(win) {
				var val = $(".substitute_table input[type='radio']:checked")
				var assign_emp = val.attr('data-emp')
				var employee = link.attr('data_emp')
				var subject = link.attr('data_sub')
				var batch = link.attr('data_batch')
				var class_time = link.attr('data_class')
				var date = link.attr('data_date')
				var tr = link.attr('data_tr')
				$.modal({
					content : '<h3>Are you sure?</h3><br/><br/><p>You are about to substitute employee...</p>',
					title : 'Warning',
					maxWidth : 500,
					buttons : {
						'OK' : function(win1, win) {

							$.getJSON('/timetable/assign_substitute', {
								employee : employee,
								subject : subject,
								batch : batch,
								class_time : class_time,
								date : date,
								assign_emp : assign_emp
							}, function(dataFromGetRequest) {
								if(dataFromGetRequest.valid) {
									window.parent.location.reload()
									// {
									// message = row_count+" Time Slots Found"
									// }
									// else
									// {
									// message = row_count+" Time Slot Found"
									// }
									// var tab = '#table_'+employee+' li'

								} else {
									var errorText = getErrorText(data.errors);
									$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
										type : 'error'
									});
								}
							}).error(function(jqXHR, textStatus, errorThrown) {
								window.location.href = "/signin"
							});

							win1.closeModal();
						},
						'Cancel' : function(win1) {
							win1.closeModal();
						}
					}
				});

			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
	modalBox.closeModal();
	configurereassignTimetableSubTable($('#modal .today_timetable_sub'));
}