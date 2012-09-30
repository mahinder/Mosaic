//handler - should call upon succes of ajax call
var updateDepartmentTableFunction = function(data) {
	$.get('/employee_departments', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureDepartmentTable($('#active-table'));
		configureDepartmentTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_department').attr("disabled", true);
		$('#create_department').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#departments-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#employee_department_name').val();
		var code = $('#employee_department_code').val();
		var stringReg = /^[a-z+\s+A-Z()]*$/
		var special_character = isSpclChar();
		var characterlength = characterLength();
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
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid department name', {
				type : 'warning'
			});
		} else if(!code || code.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter department code', {
				type : 'warning'
			});
		}else if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}  else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/employee_departments'

			var status = $("input[name='employee_department\\[status\\]']:checked").val();
			// Request
			var data = {
				'employee_department[name]' : name,
				'employee_department[code]' : code,
				'employee_department[status]' : status
			}

			ajaxCreate(target, data, updateDepartmentTableFunction, submitBt);
			resetDepartmentForm();
		}
	});
});

$(document).ready(function() {
	$('#update_department').on('click', function(event) {
		var name = $('#employee_department_name').val();
		var code = $('#employee_department_code').val();
		var stringReg = /^[a-z+\s+A-Z()]*$/
		var special_character = isSpclChar();
		var characterlength = characterLength();
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
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid department name', {
				type : 'warning'
			});
		} else if(!code || code.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter department code', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='employee_department\\[status\\]']:checked").val();
			// Target url
			var target = "/employee_departments/" + current_object_id
			// Request
			var data = {
				'employee_department[name]' : name,
				'employee_department[code]' : code,
				'employee_department[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateDepartmentTableFunction, submitBt);
			resetDepartmentForm();
		}
	});
});

$(document).ready(function() {
	resetDepartmentForm();
	$('#reset_department').on('click', function(event) {
		resetDepartmentForm();
	});
});

$(document).on("click", 'a.delete-department-master-href', function(event) {
	resetDepartmentForm();
	$('html, body').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-department-master-href', function(event) {
	resetDepartmentForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#employee_department_name').val($('#department_name_' + object_id).html());
	$('#employee_department_code').val($('#department_code_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#employee_department_status_true').attr('checked', true);
	}
	else{
		$('#employee_department_status_false').attr('checked', true);
	}
	$('#update_department').attr("class","");
    $('#create_department').attr("disabled", true);
	$('#update_department').attr("disabled", false);
	
	return false;
});
function resetDepartmentForm() {

	$('#employee_department_name').val("");
	$('#employee_department_code').val("");
	$('#employee_department_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_department').attr("class","");
	$('#create_department').attr("disabled", false);
	$('#update_department').attr("disabled", true);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}

