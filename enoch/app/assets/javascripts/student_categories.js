//handler - should call upon succes of ajax call
var updateStudentCategoryFieldTableFunction = function(data) {
	$.get('/student_categories', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureStudentCategoryFieldTable($('#active-table'));
		configureStudentCategoryFieldTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_student_category_field').attr("disabled", true);
		$('#create_student_category_field').attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#studentcategory-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#student_category_name').val();
		var iChars = "!@#$%^&*()+=[];{}:<>?";
		for(var i = 0; i < name.length; i++) {
			if(iChars.indexOf(name.charAt(i)) != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Category Name', {
					type : 'warning'
				});
				return false;
			}
		}

		var stringReg = /^[A-Za-z() ]*$/;
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Category Name', {
				type : 'warning'
			});
		} else if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
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

			var status = $("input[name='student_category\\[is_deleted\\]']:checked").val();
			// Request
			var data = {
				'student_category[name]' : name,
				'student_category[is_deleted]' : status
			}

			ajaxCreate(target, data, updateStudentCategoryFieldTableFunction, submitBt);
			resetStudentCategoryFieldForm();
		}
	});
});

$(document).ready(function() {
	$('#update_student_category_field').on('click', function(event) {
		var name = $('#student_category_name').val();
		var stringReg = /^[A-Za-z() ]*$/;
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Category Name', {
				type : 'warning'
			});
		} else if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='student_category\\[is_deleted\\]']:checked").val();
			// Target url
			var target = "/student_categories/" + current_object_id
			// Request
			var data = {
				'student_category[name]' : name,
				'student_category[is_deleted]' : status,
				'_method' : 'put'
			}
			ajaxUpdate(target, data, updateStudentCategoryFieldTableFunction, submitBt);
		}
	});
});

$(document).ready(function() {
	resetStudentCategoryFieldForm();
	$('#reset_student_category_field').on('click', function(event) {
		resetStudentCategoryFieldForm();
	});
});

$(document).on("click", 'a.delete-studentcategoryfield-href', function(event) {
	resetStudentCategoryFieldForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-studentcategoryfield-href', function(event) {
	resetStudentCategoryFieldForm();
	$('html, body').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#student_category_name').val($('#student_category_name_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#student_category_is_deleted_false').attr('checked', true);
	else
		$('#student_category_is_deleted_true').attr('checked', true);

	$('#update_student_category_field').attr("disabled", false);
	$('#create_student_category_field').attr("disabled", true);
	return false;
});
function resetStudentCategoryFieldForm() {
	// $('html, body').animate({
	// scrollTop : 0
	// }, slow);
	$('#student_category_name').val("");
	$('#student_category_is_deleted_false').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_student_category_field').attr("disabled", true);
	$('#create_student_category_field').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
}