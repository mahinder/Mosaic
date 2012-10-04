//handler - should call upon succes of ajax call

var updateEmployeeGradeTable = function(data) {

	$.get('/employee_grades', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureGradeTable($('#active-table'));
		configureGradeTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_grade').attr("disabled", true);
		$('#create_grade').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#grades-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var numericity_check = numericTest();
		// Check fields
		var name = $('#employee_grade_name').val();
		var priority = $('#employee_grade_priority').val();
		var per_day = $('#employee_grade_max_hours_day').val();
		var per_week = $('#employee_grade_max_hours_week').val();
		 var length= charactersLength()
		 var stringReg = /^[a-z+\s+A-Z()]*$/ 
		if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	} 
				  if(!stringReg.test(name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
			type : 'warning'
		});
		return false;
	}
		if(numericity_check[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter numeric value in '+numericity_check[1], {
				type : 'warning'
			});
			return false;
		}
		if(per_day.length > 3) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid Max Period Per Day (Maximum 3 Digit)', {
				type : 'warning'
			});
			return false;
		}
		if(per_week.length > 3) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid Max Period Per Week (Maximum 3 Digit)', {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Grade Name', {
				type : 'warning'
			});
		} else if(!priority || priority.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Priority', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/employee_grades'

			var max_hour_in_day = $('#employee_grade_max_hours_day').val();
			var max_hours_in_week = $('#employee_grade_max_hours_week').val();
			var status = $("input[name='employee_grade\\[status\\]']:checked").val();
			// Requ@elective_skillsest
			var data = {
				'employee_grade[name]' : name,
				'employee_grade[priority]' : priority,
				'employee_grade[max_hours_day]' : max_hour_in_day,
				'employee_grade[max_hours_week]' : max_hours_in_week,
				'employee_grade[status]' : status
			}

			ajaxCreate(target, data, updateEmployeeGradeTable, submitBt);
			resetGradeForm();

		}
	});
});

$(document).ready(function() {
	$('#update_grade').on('click', function(event) {
		var name = $('#employee_grade_name').val();
		var priority = $('#employee_grade_priority').val();
		var numericity_check = numericTest();
		var length= charactersLength()
		 var stringReg = /^[a-z+\s+A-Z()]*$/ 
		if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	} 
				  if(!stringReg.test(name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
			type : 'warning'
		});
		return false;
	}
		if(numericity_check[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter numeric value in '+numericity_check[1], {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Grade Name', {
				type : 'warning'
			});
		} else if(!priority || priority.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Priority', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var max_hour_in_day = $('#employee_grade_max_hours_day').val();
			var max_hours_in_week = $('#employee_grade_max_hours_week').val();
			var status = $("input[name='employee_grade\\[status\\]']:checked").val();
			// Target url
			var target = "/employee_grades/" + current_object_id
			// Request
			var data = {
				'employee_grade[name]' : name,
				'employee_grade[priority]' : priority,
				'employee_grade[max_hours_day]' : max_hour_in_day,
				'employee_grade[max_hours_week]' : max_hours_in_week,
				'employee_grade[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateEmployeeGradeTable, submitBt);
			resetGradeForm();
		}
	});
});

$(document).ready(function() {
	 resetGradeForm();
	$('#reset_grade').on('click', function(event) {
		resetGradeForm();
	});
});

function resetGradeForm() {
	
	$('#employee_grade_name').val("");
	$('#employee_grade_priority').val("");
	$('#employee_grade_max_hours_day').val("");
	$('#employee_grade_max_hours_week').val("");
	$('#employee_grade_status_true').attr('checked', true);
	$('#current_object_id').val("");
	
	$('#update_grade').attr("disabled", true);
	$('#create_grade').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
}


$(document).on("click", "a.update-grade-href", function(event) {
	resetGradeForm();
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#employee_grade_name').val($('#grade_name_' + object_id).html());
	$('#employee_grade_priority').val($('#grade_priority_' + object_id).html());
	$('#employee_grade_max_hours_day').val($('#grade_max_hours_day_' + object_id).html());
	$('#employee_grade_max_hours_week').val($('#grade_max_hours_week_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#employee_grade_status_true').attr('checked', true);
	else
		$('#employee_grade_status_false').attr('checked', true);
 		$('#update_grade').attr("disabled", false);
		$('#create_grade').attr("disabled", true);
	return false;
});

$(document).on("click", "a.delete-grade-href", function(event) {
	resetGradeForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

//special char
function specialChar() {
	
	var special_character = null;
	var iChars = "!$%^&*()+=[];{}:<>?";
	$(".full-width").each(function() {
		for(var i = 0; i < $(this).val().length; i++) {
			if(iChars.indexOf($(this).val().charAt(i)) != -1) {
				special_character = false;
			}
		}
	});
	return special_character;
}