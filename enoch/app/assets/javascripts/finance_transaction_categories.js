var updateTableFunction = function(data) {
	$.get('/finance_transaction_categories', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTransactionCategoryTable($('#finance_transaction_category'));
		attachTransactionCategoryDeleteHandler();
		attachTransactionCategoryUpdateHandler();
		 
	});
}



$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transaction_category-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#finance_transaction_category_name').val();
		var characterReg = /^\s*[a-zA-Z0-9,_,\s]+\s*$/;

		if(!name || name.length == 0  || !characterReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter grade name', {
				type : 'warning'
			});
		}else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/finance_transaction_categories'
			

			var description = $('#finance_transaction_category_description').val();
			var is_income = $('#finance_transaction_category_is_income').is(":checked");
			
			// Request
			var data = {
				'finance_transaction_category[name]' : name,
				'finance_transaction_category[description]' : description,
				'finance_transaction_category[is_income]' : is_income
				
			}
			
			ajaxCreate(target, data, updateTableFunction, submitBt);
			resettransaction_categoryForm();
		}
	});
});

$(document).ready(function() {
	$('#update_transaction_category').on('click', function(event) {
		var name = $('#finance_transaction_category_name').val();

		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter grade name', {
				type : 'warning'
			});
		}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var description = $('#finance_transaction_category_description').val();
			var is_income = $('#finance_transaction_category_is_income').is(":checked");
				// Target url
			var target = "/finance_transaction_categories/" + current_object_id
			// Request
			var data = {
				'finance_transaction_category[name]' : name,
				'finance_transaction_category[description]' : description,
				'finance_transaction_category[is_income]' : is_income,
				'_method' : 'put'
			}
			
			ajaxUpdate(target, data, updateTableFunction, submitBt);
			resettransaction_categoryForm();
		}
	});
});

$(document).ready(function() {
	attachTransactionCategoryDeleteHandler();
});

$(document).ready(function() {
	attachTransactionCategoryUpdateHandler();
});

$(document).ready(function() {	
	// resettransaction_categoryForm();
	$('#reset_transaction_category').on('click', function(event) {
		resettransaction_categoryForm();
	});
});

function attachTransactionCategoryDeleteHandler(){
	$('a.delete-finance-transaction-category-master-href').on('click', function(event) {
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
}

function attachTransactionCategoryUpdateHandler(){
	$('a.update-finance-transaction-category-master-href').on('click', function(event) {
		resettransaction_categoryForm();
			$('html, body').animate({ scrollTop: 0 }, 0);
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		
		$('#finance_transaction_category_name').val($('#transaction_category_name_' + object_id).html());
		$('#finance_transaction_category_description').val($('#transaction_category_description_' + object_id).html());
		var income = document.getElementById('transation_is_income_'+object_id).value
		if (income == 'true')
		{
			$('#finance_transaction_category_is_income').attr('checked', true);	
		}else
		{
			$('#finance_transaction_category_is_income').attr('checked', false);
		}
		$('#finance_transaction_category_is_income').val($('#transaction_category_is_income_' + object_id).html());
		$('#current_object_id').val(object_id);
		
		var name = table.attr("id");
		
		$('#update_transaction_category').attr("disabled", false);
		$('#create_transaction_category').attr("disabled", true);
		return false;
	});
}


function resettransaction_categoryForm() {
	$('#outer_block').removeBlockMessages()
	$('#finance_transaction_category_name').val("");
	$('#finance_transaction_category_description').val("");
	$('#finance_transaction_category_is_income').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_transaction_category').attr("disabled", true);
	$('#create_transaction_category').attr("disabled", false);
}