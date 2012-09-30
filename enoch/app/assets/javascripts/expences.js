var updateexpenseTableFunction = function(data) {
	resetexpenseForm();
}

$(document).ready(function() {
	
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#expense-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var characterReg = /^\s*[a-zA-Z0-9,_,\s]+\s*$/;
		// Check fields
		var title = $('#finance_transaction_title').val();
		var category_id = $('#transaction_category_id').val();
		var amount = $('#finance_transaction_amount').val();
		var date = $('#finance_transaction_date').val();
		var description = $('#finance_transaction_description').val();
		
		if(!title || title.length == 0  || !characterReg.test(title)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter title', {
				type : 'warning'
			});
		} else if(!category_id || category_id.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Category name', {
				type : 'warning'
			});
		} else if(!amount || amount.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter amount', {
				type : 'warning'
			});
		} else if(!date || date.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter date', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/expenses'
			// Request
			var data = {
				'finance_transaction[title]' : title,
				'finance_transaction[description]' : description,
				'finance_transaction[amount]' : amount,
				'finance_transaction[category_id]' : category_id,
				'finance_transaction[transaction_date]' : date
			}

			var tempvar = ajaxCreate(target, data, updateexpenseTableFunction, submitBt);
			
			
		}
	});
});




$(document).ready(function() {
	$('#reset_expense').on('click', function(event) {
	resetexpenseForm();
	});
});


function resetexpenseForm() {
	$('#finance_transaction_title').val("");
	$('#finance_transaction_description').val("");
	$('#finance_transaction_amount').val("");
	$('#outer_block').removeBlockMessages()
	$('#transaction_category_id').val("");
	$('#current_object_id').val(0);
	$('#update_income').attr("disabled", true);
	$('#create_income').attr("disabled", false);
	$('input').removeClass('error')
}

$(document).on("click", "#expense_list_view", function(event) {
	event.preventDefault();

		// Check fields
		var start_date = $('#start_date_expense').val();
		var end_date = $('#end_date_expense').val();
		var target = '/expenses/expense_list/'
			// Request
			
			$.get('/expenses/expense_list/',{start_date: start_date,end_date:end_date}, function(dataFromGetRequest) {
					$("#expense-list").empty()
					$('#expense-list').html(dataFromGetRequest);
					configureExpenseTable($('#expense_table'));
					$('.tabs').updateTabs();
				
					
}).error(function(jqXHR, textStatus, errorThrown) { 
       window.location.href = "/signin"
});
	});



$(document).on("click", ".deleteexpense-master-href", function(event) {
	
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var url_prefix = $('#url_prefix').val();
		var remoteUrl = url_prefix + "/" + object_id;
		confirmDelete(remoteUrl, table, row);
		return false;
	});

