//handler - should call upon succes of ajax call
var updatePositionTableFunction = function(data) {
	$.get('/employee_positions', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configurePositionTable($('#active-table'));
		configurePositionTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_position').attr("disabled", true);
		$('#create_position').attr("disabled", false);
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#positions-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#employee_position_name').val();
		var stringReg = /^[a-z+\s+A-Z()]*$/
		var special_character = isSpclChar();
		var characterlength = characterLength();
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				type : 'warning'
			});
			return false;
		}
		if(special_character[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Special characters are not allowed in '+ special_character[1], {
				type : 'warning'
			});
			return false
		}
		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		var iChars = "!@#$%^&*()+=[];{}:<>?";
		for(var i = 0; i < name.length; i++) {
			if(iChars.indexOf(name.charAt(i)) != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Position Name', {
					type : 'warning'
				});
				return false;
			}
		}
		if(name.length >= 50) {
						$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		var category = $('#employee_position_employee_category_id').val();

		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Position name', {
				type : 'warning'
			});
		} else if(!category || category.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select category', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/employee_positions'

			var status = $("input[name='employee_position\\[status\\]']:checked").val();
			// Request
			var data = {
				'employee_position[name]' : name,
				'employee_position[employee_category_id]' : category,
				'employee_position[status]' : status
			}

			ajaxCreate(target, data, updatePositionTableFunction, submitBt);
			resetPositionForm();
		}
	});
});

$(document).ready(function() {
	$('#update_position').on('click', function(event) {
		var name = $('#employee_position_name').val();
		var category = $('#employee_position_employee_category_id').val();
        var stringReg = /^[a-z+\s+A-Z()]*$/
		var special_character = isSpclChar();
		var characterlength = characterLength();
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				type : 'warning'
			});
			return false;
		}
		if(special_character[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Special characters are not allowed in '+ special_character[1], {
				type : 'warning'
			});
			return false
		}
		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Position name', {
				type : 'warning'
			});
		} else if(!category || category.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select category', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='employee_position\\[status\\]']:checked").val();
			// Target url
			var target = "/employee_positions/" + current_object_id
			// Request
			var data = {
				'employee_position[name]' : name,
				'employee_position[employee_category_id]' : category,
				'employee_position[status]' : status,
				'_method' : 'put'
			}
			ajaxUpdate(target, data, updatePositionTableFunction, submitBt);
			resetPositionForm();
		}
	});
});

$(document).ready(function() {
	resetPositionForm();
	$('#reset_position').on('click', function(event) {
		resetPositionForm();
	});
});

$(document).on("click", 'a.delete-position-master-href', function(event) {
	resetPositionForm();
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return true;
});

$(document).on("click", 'a.update-position-master-href', function(event) {
	resetPositionForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#employee_position_name').val($('#position_name_' + object_id).html());
	$('#employee_position_employee_category_id').val(document.getElementById('positions_category_' + object_id).value);
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#employee_position_status_true').attr('checked', true);
	else
		$('#employee_position_status_false').attr('checked', true);
  $('#update_position').attr("class","");
	$('#update_position').attr("disabled", false);
	$('#create_position').attr("disabled", true);
	return false;
});
function resetPositionForm() {
	
	$('#employee_position_name').val("");
	$('#employee_position_employee_category_id').val("Select");
	$('#employee_position_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_position').attr("disabled", true);
	$('#create_position').attr("disabled", false);
	// $('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}