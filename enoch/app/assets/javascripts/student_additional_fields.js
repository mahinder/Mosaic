//handler - should call upon succes of ajax call
var updateStudentAdditionalFieldTableFunction = function(data) {
	$.get('/student_additional_fields', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureStudentAdditionalFieldTable($('#active-table'));
		configureStudentAdditionalFieldTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_student_additional_field').attr("disabled", true);
		$('#create_student_additional_field').attr("disabled", false);
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#studentsfield-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		var stringReg = /^[a-z+\s+A-Z()]*$/
		var name = $('#student_additional_field_name').val();
		var iChars = "!$@%^&*()+=[];{}:<>?";
			for(var i = 0; i < name.length; i++) {
				if(iChars.indexOf(name.charAt(i)) != -1) {
					$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Additional Field Name', {
						type : 'warning'
					});
					return false
				}
			}
		if(name.length >= 50) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in Name', {
					type : 'warning'
				});
				return false
		}
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Additional Field Name', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = $(this).attr('action');
			if(!target || target == '') {
				// Page url without hash
				target = document.location.href.match(/^([^#]+)/)[1];
			}

			var status = $("input[name='student_additional_field\\[status\\]']:checked").val();
			// Request
			var data = {
				'student_additional_field[name]' : name,
				'student_additional_field[status]' : status
			}

			ajaxCreate(target, data, updateStudentAdditionalFieldTableFunction, submitBt);
			resetStudentAdditionalFieldForm();
		}
	});
});

$(document).ready(function() {
	$('#update_student_additional_field').on('click', function(event) {
		var name = $('#student_additional_field_name').val();
        var stringReg = /^[a-z+\s+A-Z()]*$/
        var iChars = "!$@%^&*()+=[];{}:<>?";
			for(var i = 0; i < name.length; i++) {
				if(iChars.indexOf(name.charAt(i)) != -1) {
					$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Additional Field Name', {
						type : 'warning'
					});
					return false
				}
			}
        if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				type : 'warning'
			});
			return false;
		}
		if(name.length > 50) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in Name', {
					type : 'warning'
				});
				return false
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Additional Field Name', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='student_additional_field\\[status\\]']:checked").val();
			// Target url
			var target = "/student_additional_fields/" + current_object_id
			// Request
			var data = {
				'student_additional_field[name]' : name,
				'student_additional_field[status]' : status,
				'_method' : 'put'
			}
			ajaxUpdate(target, data, updateStudentAdditionalFieldTableFunction, submitBt);
		}
	});
});

$(document).ready(function() {
	resetStudentAdditionalFieldForm();
	$('#reset_student_additional_field').on('click', function(event) {
		resetStudentAdditionalFieldForm();
	});
});

$(document).on("click", 'a.delete-additionalfield-href', function(event) {
	resetStudentAdditionalFieldForm();
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-additionalfield-href', function(event) {
	resetStudentAdditionalFieldForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#student_additional_field_name').val($('#student_additional_field_name_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#student_additional_field_status_true').attr('checked', true);
	else
		$('#student_additional_field_status_false').attr('checked', true);

	$('#update_student_additional_field').attr("disabled", false);
	$('#create_student_additional_field').attr("disabled", true);
	return false;
});

function resetStudentAdditionalFieldForm() {

	$('#student_additional_field_name').val("");
	$('#student_additional_field_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_student_additional_field').attr("class", "");
	$('#create_student_additional_field').attr("disabled", false);
	$('#update_student_additional_field').attr("disabled", true);
	$('#tab-active').showTab()
	$('#outer_block').removeBlockMessages();
}