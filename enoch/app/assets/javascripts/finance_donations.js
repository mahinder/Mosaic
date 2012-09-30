var updatedonationTableFunction = function(data) {
	
}

$(document).ready(function() {
	
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#donation-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#finance_donation_donor').val();
		
		var amount = $('#finance_donation_amount').val();
		var date = $('#finance_donation_date').val();
		var description = $('#finance_donation_description').val();
		 var characterReg = /^\s*[a-zA-Z0-9,_,\s]+\s*$/;
		
		
		if(!name || name.length == 0 || !characterReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Donor name', {
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
			var target = '/finance_donations'
			// Request
			var data = {
				'finance_donation[donor]' : name,
				'finance_donation[description]' : description,
				'finance_donation[amount]' : amount,
				'finance_donation[transaction_date]' : date
			}

			ajaxCreate(target, data, updateexpenseTableFunction, submitBt);
			resetdonationForm();
		}
	});
});

$(document).ready(function() {
	// resetdonationForm();
	$('#reset_donor').on('click', function(event) {
	resetdonationForm();
	});
});

function resetdonationForm() {
	$('#finance_donation_donor').val("");
	$('#finance_donation_amount').val("");
	$('#finance_donation_description').val("");
	$('#current_object_id').val(0);
	$('#update_donor').attr("disabled", true);
	$('#outer_block').removeBlockMessages()
	$('input').removeClass('error')
}


$(document).on("click", "#donation_list_view", function(event) {
	event.preventDefault();

		// Check fields
		var start_date = $('#start_date_donation').val();
		var end_date = $('#end_date_donation').val();
		var target = '/finance_donations/donation_list/'
			// Request
			
			$.get('/finance_donations/donation_list/',{start_date: start_date,end_date:end_date}, function(dataFromGetRequest) {
					$("#donation-list").empty()
					$('#donation-list').html(dataFromGetRequest);
					configureDonationTable($('#donation_table'));
					$('.tabs').updateTabs();
				
					
});
	});



$(document).on("click", ".deletedonation-master-href", function(event) {
	
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var url_prefix = $('#url_prefix').val();
		var remoteUrl = url_prefix + "/" + object_id;
		confirmDelete(remoteUrl, table, row);
		return false;
	});
