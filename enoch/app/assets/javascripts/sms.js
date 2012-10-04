// $(document).ready(function() {
// sms_general_setting();
// });

// function sms_general_setting() {
//
// }

$(document).on('click', '#sms_settings_application_enabled', function(event) {
	var is_check = $('#sms_settings_application_enabled').is(":checked");

	$.getJSON('/sms/update_application_sms_settings', {
		'sms_settings[application_enabled]' : is_check
	}, function(data_form) {
		if(data_form.valid) {
			$('#outer_block').removeBlockMessages().blockMessage('Sms settings application enabled', {
				type : 'success'
			});
			
			window.location.href = "/sms/settings"
		} else {
			$('#outer_block').removeBlockMessages().blockMessage('Problem in sms settings application enabled', {
				type : 'success'
			});
			window.location.href = "/sms/settings"
		}
	}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
});
