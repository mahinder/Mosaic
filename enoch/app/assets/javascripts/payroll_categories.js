var updatePayrollTableFunction = function(data) {
	$.get('/payroll_categories', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configurePayrollTable($('#earning-active-table'));
		configurePayrollTable($('#earning-inactive-table'));
		$('.tabs').updateTabs();
		$('#update_category').attr("disabled", true);
		$('#create_category').attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled

	$('#payroll-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var stringReg = /^[A-Za-z() ]*$/;
		var name = $('#payroll_category_name').val();
		var percentage = $('#payroll_category_percentage').val();
		var percentage_of = $('#payroll_category_payroll_category_id').val();
		var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Category Name', {
				type : 'warning'
			});
		}else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		}else if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(!characterReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Special character not allowed', {
				type : 'warning'
			});
		} else if(!percentage && percentage_of) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter percentage', {
				type : 'warning'
			});
		} else if(percentage && !percentage_of) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select percentage of', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/payroll_categories'

			var deduct = $('#payroll_category_is_deduction').is(":checked");
			var status = $("input[name='payroll_category\\[status\\]']:checked").val();
			var isdeduct
			if(deduct == true) {
				isdeduct = "true"
			} else {
				isdeduct = "false"
			}
			// Request
			var data = {
				'payroll_category[name]' : name,
				'payroll_category[percentage]' : percentage,
				'payroll_category[payroll_category_id]' : percentage_of,
				'payroll_category[is_deduction]' : isdeduct,
				'payroll_category[status]' : status
			}

			ajaxCreate(target, data, updatePayrollTableFunction, submitBt);
			resetpayrollForm();
		}
	});
});

$(document).ready(function() {
	$('#update_category').on('click', function(event) {
		var name = $('#payroll_category_name').val();
		var percentage = $('#payroll_category_percentage').val();
		var percentage_of = $('#payroll_category_payroll_category_id').val();
		var stringReg = /^[A-Za-z() ]*$/;
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter category name', {
				type : 'warning'
			});
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		}else if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(!percentage && percentage_of) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter percentage', {
				type : 'warning'
			});
		} else if(percentage && !percentage_of) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select percentage of', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();

			var deduct = $('#payroll_category_is_deduction').is(":checked");
			var status = $("input[name='payroll_category\\[status\\]']:checked").val();
			// Target url
			var target = "/payroll_categories/" + current_object_id
			// Request
			var data = {
				'payroll_category[name]' : name,
				'payroll_category[percentage]' : percentage,
				'payroll_category[payroll_category_id]' : percentage_of,
				'payroll_category[is_deduction]' : deduct,
				'payroll_category[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updatePayrollTableFunction, submitBt);
			resetpayrollForm();
		}
	});
});

$(document).ready(function() {
	resetpayrollForm();
	$('#reset_category').on('click', function(event) {
		resetpayrollForm();
	});
});

$(document).on("click", 'a.delete-payroll-master-href', function(event) {
	resetpayrollForm();
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

$(document).on("click", 'a.update-payroll-master-href', function(event) {

	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#payroll_category_name').val($('#category_name_' + object_id).html());
	$('#payroll_category_percentage').val($('#category_percentage_' + object_id).html());
	$('#payroll_category_payroll_category_id').val(document.getElementById('category_percentage_of_' + object_id).value);
	var is_ex = $('#category_is_deduction_' + object_id).html()
	
	if( is_ex == "Expense") {
		$('#payroll_category_is_deduction').attr('checked', true);
	} else {
		$('#payroll_category_is_deduction').attr('checked', false);
	}

	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'earning-active-table' || name == 'expense-active-table')
		$('#payroll_category_status_true').attr('checked', true);
	else
		$('#payroll_category_status_false').attr('checked', true);

	$('#update_category').attr("disabled", false);
	$('#create_category').attr("disabled", true);
	return false;
});
function resetpayrollForm() {
	// $('html, body').animate({
	// scrollTop : 0
	// }, slow);
	$('#payroll_category_name').val("");
	$('#payroll_category_percentage').val("");
	$('#payroll_category_payroll_category_id').val("");
	$('#payroll_category_is_deduction').attr('checked', false);
	$('#payroll_category_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_category').attr("disabled", true);
	$('#create_category').attr("disabled", false);
	$('#outer_block').removeBlockMessages()
}