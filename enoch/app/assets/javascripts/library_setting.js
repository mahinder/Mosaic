var updatesettingTable = function(data) {

	$.get('/library_settings', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureSettingTable($('#setting'));
		$('#update_setting').attr("disabled", true);
		$('#create_setting').attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}

$('#setting-form').submit(function(event) {
	// Stop full page load
	event.preventDefault();
	var category = $('#whatever').val();
	var books = $('#library_setting_no_of_books_to_be_issued').val();
	var defaultdays = $('#library_setting_default_no_of_days_for_issue').val();
	var renew = $('#library_setting_renew_period').val();
	var fine = $('#library_setting_fine_charged_per_day_after_due_date').val();

	var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
	var tagvalue = ""
	var numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/
	if(!books || books.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Numder Of Books To Be Issued', {
			type : 'warning'
		});
	} else if(books.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Numder Of Books To Be Issued should 3', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(books)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Numder Of Books To Be Issued', {
			type : 'warning'
		});
	} else if(!defaultdays || defaultdays.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Default Days For Issue', {
			type : 'warning'
		});
	} else if(defaultdays.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Default Days For Issue should 2', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(defaultdays)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Default Days For Issue', {
			type : 'warning'
		});
	} else if(!renew || renew.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Renew Period', {
			type : 'warning'
		});
	} else if(renew.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Renew Period should 2', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(renew)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Renew Period', {
			type : 'warning'
		});
	} else if(!fine || fine.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Fine Per Day', {
			type : 'warning'
		});
	} else if(fine.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Fine Per Day should 2', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(fine)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Fine Per Day', {
			type : 'warning'
		});
	} else {

		var submitBt = $(this).find('button[type=submit]');
		submitBt.disableBt();
		var target = '/library_settings'

		// Requ@elective_skillsest
		var data = {
			'library_setting[category]' : category,
			'library_setting[no_of_books_to_be_issued]' : books,
			'library_setting[default_no_of_days_for_issue]' : defaultdays,
			'library_setting[renew_period]' : renew,
			'library_setting[fine_charged_per_day_after_due_date]' : fine,

		}

		ajaxCreate(target, data, updatesettingTable, submitBt);
		resetsettingForm();

	}
});

$(document).on("click", "#update_setting", function(event) {

	event.preventDefault();
	var category = $('#whatever').val();
	var books = $('#library_setting_no_of_books_to_be_issued').val();
	var defaultdays = $('#library_setting_default_no_of_days_for_issue').val();
	var renew = $('#library_setting_renew_period').val();
	var fine = $('#library_setting_fine_charged_per_day_after_due_date').val();

	var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
	var tagvalue = ""
	var numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/
	if(!books || books.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Numder Of Books To Be Issued', {
			type : 'warning'
		});
	} else if(books.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Numder Of Books To Be Issued should 3', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(books)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Numder Of Books To Be Issued', {
			type : 'warning'
		});
	} else if(!defaultdays || defaultdays.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Default Days For Issue', {
			type : 'warning'
		});
	} else if(defaultdays.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Default Days For Issue should 2', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(defaultdays)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Default Days For Issue', {
			type : 'warning'
		});
	} else if(!renew || renew.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Renew Period', {
			type : 'warning'
		});
	} else if(renew.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Renew Period should 2', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(renew)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Renew Period', {
			type : 'warning'
		});
	} else if(!fine || fine.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Fine Per Day', {
			type : 'warning'
		});
	} else if(fine.length > 3) {
		$('#outer_block').removeBlockMessages().blockMessage('Maximum  length for Fine Per Day should 2', {
			type : 'warning'
		});
	} else if(!numericReg_for_nomeric.test(fine)) {
		$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed in Fine Per Day', {
			type : 'warning'
		});
	} else {

		var submitBt = $(this).find('button[type=submit]');
		submitBt.disableBt();
		var current_object_id = $('#current_object_id').val();
		var target = '/library_settings/' + current_object_id
		// Requ@elective_skillsest
		var data = {
			'library_setting[category]' : category,
			'library_setting[no_of_books_to_be_issued]' : books,
			'library_setting[default_no_of_days_for_issue]' : defaultdays,
			'library_setting[renew_period]' : renew,
			'library_setting[fine_charged_per_day_after_due_date]' : fine,
			'_method' : 'put'
		}

		// Requ@elective_skillsest

		ajaxUpdate(target, data, updatesettingTable, submitBt);
		resetsettingForm();

	}
});

$(document).ready(function() {
	resetsettingForm();
	$(document).on("click", "#reset_setting", function(event) {
		resetsettingForm();
	});
});
function resetsettingForm() {

	$('#whatever').val(0);
	$('#library_setting_no_of_books_to_be_issued').val("");
	$('#library_setting_default_no_of_days_for_issue').val("");
	$('#library_setting_renew_period').val("");
	$('#library_setting_fine_charged_per_day_after_due_date').val("");
	$('#current_object_id').val("");
	$('#update_setting').attr("disabled", true);
	$('#create_setting').attr("disabled", false);
	$('#outer_setting').removeBlockMessages();

}


$(document).on("click", "a.update-setting-href", function(event) {
	resetsettingForm();

	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	
	$('#whatever').val($('#setting_category_' + object_id).html());
	$('#library_setting_no_of_books_to_be_issued').val($('#setting_no_of_books_to_be_issued_' + object_id).html());
	$('#library_setting_default_no_of_days_for_issue').val($('#setting_default_no_of_days_for_issue_' + object_id).html());
	$('#library_setting_renew_period').val($('#setting_renew_period_' + object_id).html());
	$('#library_setting_fine_charged_per_day_after_due_date').val($('#setting_fine_charged_per_day_after_due_date_' + object_id).html());
	$('#current_object_id').val(object_id);
	$('#update_setting').attr("class", "");
	$('#update_setting').attr("disabled", false);
	$('#create_setting').attr("disabled", true);

});

$(document).on("click", "a.delete-setting-href", function(event) {
	resetsettingForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDeletelibrary_setting(remoteUrl, table, row);
	return false;
});
//-----------------------------------------------------------------

function confirmDeletelibrary_setting(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeletesetting(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeletesetting(remoteUrl, table, row) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				var dataTable = table.dataTable();
				dataTable.fnDeleteRow(row.index());

				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}