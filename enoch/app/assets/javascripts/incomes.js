var updateincomeTableFunction = function(data) {
	
}

$(document).ready(function() {
	
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#income-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var characterReg = /^\s*[a-zA-Z0-9,_,\s]+\s*$/;
		// Check fields
		var title = $('#finance_transaction_title').val();
		var category_id = $('#transaction_category_id').val();
		var amount = $('#finance_transaction_amount').val();
		var date = $('#finance_transaction_date').val();
	 		var description = $('#finance_transaction_description').val();
		if(!title || title.length == 0  || !characterReg.test(title))  {
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
			var target = '/incomes'
			// Request
			var data = {
				'finance_transaction[title]' : title,
				'finance_transaction[description]' : description,
				'finance_transaction[amount]' : amount,
				'finance_transaction[category_id]' : category_id,
				'finance_transaction[transaction_date]' : date
			}

			ajaxCreate(target, data, updateincomeTableFunction, submitBt);
			resetincomeForm();
		}
	});
});




$(document).ready(function() {
	$('#reset_income').on('click', function(event) {
	resetincomeForm();
	});
});



function resetincomeForm() {
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


$(document).on("click", "#income_list_view", function(event) {
	event.preventDefault();

		// Check fields
		var start_date = $('#start_date_income').val();
		var end_date = $('#end_date_income').val();
		var target = '/incomes/income_list/'
			// Request
			
			$.get('/incomes/income_list/',{start_date: start_date,end_date:end_date}, function(dataFromGetRequest) {
					$("#income-list").empty()
					$('#income-list').html(dataFromGetRequest);
					configureIncomesTable($('#income_table'));
					$('.tabs').updateTabs();
				
					
}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
	});



$(document).on("click", ".deleteincome-master-href", function(event) {
	
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var url_prefix = $('#url_prefix').val();
		var remoteUrl = url_prefix + "/" + object_id;
		confirmDelete(remoteUrl, table, row);
		return false;
	});
