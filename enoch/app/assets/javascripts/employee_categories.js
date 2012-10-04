//handler - should call upon succes of ajax call
var updateCategoryTableFunction = function(data) {
	$.get('/employee_categories', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureCategoryTable($('#active-table'));
		configureCategoryTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_employee_category').attr("disabled", true);
		$('#create_employee_category').attr("disabled", false);
	});
}
// We'll catch form submission to do it in AJAX, but this works also with JS disabled
$(document).ready(function() {
	$('#categories-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#employee_category_name').val();
		var iChars = "!@#$%^&*()+=[];{}:<>?";
		var stringReg = /^[a-z+\s+A-Z()]*$/
		var special_character = isSpclChar();
		var characterlength = characterLength();
		for(var i = 0; i < name.length; i++) {
			if(iChars.indexOf(name.charAt(i)) != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Category Name', {
					type : 'warning'
				});
				return false;
			}
		}
		var prefix = $('#employee_category_prefix').val();
		for(var i = 0; i < prefix.length; i++) {
			if(iChars.indexOf(prefix.charAt(i)) != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Prefix', {
					type : 'warning'
				});
				return false;
			}
		}
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
		if(name.length >= 50) {
						$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(prefix.length >= 50) {
						$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter category name', {
				type : 'warning'
			});
		} else if(!prefix || prefix.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Category Prefix', {
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

			var status = $("input[name='employee_category\\[status\\]']:checked").val();
			// Request
			var data = {
				'employee_category[name]' : name,
				'employee_category[prefix]' : prefix,
				'employee_category[status]' : status
			}

			ajaxCreate(target, data, updateCategoryTableFunction, submitBt);
			resetEmployeeCategoryForm();
		}
	});
});

$(document).ready(function() {
	$('#update_employee_category').on('click', function(event) {
		var name = $('#employee_category_name').val();
		var prefix = $('#employee_category_prefix').val();
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
			$('#outer_block').removeBlockMessages().blockMessage('Please enter category name', {
				type : 'warning'
			});
		} else if(!prefix || prefix.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter priority', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='employee_category\\[status\\]']:checked").val();
			// Target url
			var target = "/employee_categories/" + current_object_id
			// Request
			var data = {
				'employee_category[name]' : name,
				'employee_category[prefix]' : prefix,
				'employee_category[status]' : status,
				'_method' : 'put'
			}
			ajaxUpdate(target, data, updateCategoryTableFunction, submitBt);
			resetEmployeeCategoryForm();
		}
	});
});

$(document).ready(function() {
	resetEmployeeCategoryForm()
	$('#reset_employee_category').on('click', function(event) {
		resetEmployeeCategoryForm();
	});
});

$(document).on("click", 'a.delete-employee-category-master-href', function(event) {
	resetEmployeeCategoryForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-employee-category-master-href', function(event) {
	resetEmployeeCategoryForm();
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#employee_category_name').val($('#category_name_' + object_id).html());
	$('#employee_category_prefix').val($('#category_prefix_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#employee_category_status_true').attr('checked', true);
	else
		$('#employee_category_status_false').attr('checked', true);

$('#update_employee_category').attr("class","");
	$('#update_employee_category').attr("disabled", false);
	$('#create_employee_category').attr("disabled", true);

		

	return false;
});

function resetEmployeeCategoryForm() {
	// $('html, body').animate({
		// scrollTop : 0
	// }, 'slow');
	$('#employee_category_name').val("");
	$('#employee_category_prefix').val("");
	$('#employee_category_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_employee_category').attr("class","");
	$('#update_employee_category').attr("disabled", true);
	$('#create_employee_category').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
}