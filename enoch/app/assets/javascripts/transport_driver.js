//handler - should call upon succes of ajax call
var updateTransportDriverTableFunction = function(data) {
	$.get('/transport_drivers', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTransportDriver($('#active-table'));
		configureTransportDriver($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_driver').attr("disabled", true);
		$('#create_driver').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transport_driver-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var provider = $('#transport_driver_provider_id').val();
		var name = $('#transport_driver_name').val();
		var address = $('#transport_driver_address').val();
		var mobile = $('#transport_driver_mobile').val();
		var dl_valid = $('#transport_driver_dl_valid_upto').val();
		var licence_no = $('#transport_driver_licence_no').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Driver Name', {
				type : 'warning'
			});
			return false;
		}
		if(character_length[0] == false) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ character_length[1], {
					type : 'warning'
				});
				return false;
			}
		
		if(!provider || provider.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose transport provider name', {
				type : 'warning'
			});
			return false;
		}
		
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter driver name', {
				type : 'warning'
			});
		} else if(!address || address.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter address', {
				type : 'warning'
			});
		}else if(!numericReg.test(mobile)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter mobile in numeric format', {
			type : 'warning'
		});
		return false;
	}else if(mobile.length<10 || mobile.length>10){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter valid mobile number 10 digit', {
			type : 'warning'
		});
		return false;
	}else if(!dl_valid || dl_valid.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter licence valid upto', {
			type : 'warning'
		});
		return false;
	}else if(!licence_no || licence_no.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter licence number', {
			type : 'warning'
		});
		return false;
	}else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/transport_drivers'

			var status = $("input[name='transport_driver\\[status\\]']:checked").val();
			// Request
			var data = {
				'transport_driver[provider_id]' : provider,
				'transport_driver[name]' : name,
				'transport_driver[address]' : address,
				'transport_driver[mobile]' : mobile,
				'transport_driver[dl_valid_upto]' : dl_valid,
				'transport_driver[licence_no]' : licence_no,
				'transport_driver[status]' : status
			}

			ajaxCreate(target, data, updateTransportDriverTableFunction, submitBt);
			resetDriverForm();
		}
	});
});

$(document).ready(function() {
	$('#update_driver').on('click', function(event) {
		var provider = $('#transport_driver_provider_id').val();
		var name = $('#transport_driver_name').val();
		var address = $('#transport_driver_address').val();
		var mobile = $('#transport_driver_mobile').val();
		var dl_valid = $('#transport_driver_dl_valid_upto').val();
		var licence_no = $('#transport_driver_licence_no').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for driver name', {
				type : 'warning'
			});
			return false;
		}
		if(character_length[0] == false) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ character_length[1], {
					type : 'warning'
				});
				return false;
			}
		
		if(!provider || provider.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose transport provider name', {
				type : 'warning'
			});
			return false;
		}
		
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter driver name', {
				type : 'warning'
			});
		} else if(!address || address.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter address', {
				type : 'warning'
			});
		}else if(!numericReg.test(mobile)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter mobile in numeric format', {
			type : 'warning'
		});
		return false;
	}else if(mobile.length<10 || mobile.length>10){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter valid mobile number 10 digit', {
			type : 'warning'
		});
		return false;
	}else if(!dl_valid || dl_valid.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter licence valid upto', {
			type : 'warning'
		});
		return false;
	} else if(!licence_no || licence_no.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter licence number', {
			type : 'warning'
		});
		return false;
	}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='transport_driver\\[status\\]']:checked").val();
			// Target url
			var target = "/transport_drivers/" + current_object_id
			// Request
			var data = {
				'transport_driver[provider_id]' : provider,
				'transport_driver[name]' : name,
				'transport_driver[address]' : address,
				'transport_driver[mobile]' : mobile,
				'transport_driver[dl_valid_upto]' : dl_valid,
				'transport_driver[licence_no]' : licence_no,
				'transport_driver[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateTransportDriverTableFunction, submitBt);
			resetDriverForm();
		}
	});
});

$(document).ready(function() {
	resetDriverForm();
	$('#reset_driver').on('click', function(event) {
		resetDriverForm();
	});
});

$(document).on("click", 'a.delete-transport_driver-master-href', function(event) {
	resetDriverForm();
	$('html, body').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-transport_driver-master-href', function(event) {
	resetDriverForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#transport_driver_provider_id').val($('#driver_providers_' + object_id).val());
	$('#transport_driver_name').val($('#driver_name_' + object_id).html());
	$('#transport_driver_address').val($('#driver_address_' + object_id).html());
	$('#transport_driver_mobile').val($('#mobile_' + object_id).html());
	$('#transport_driver_dl_valid_upto').val($('#dl_valid_' + object_id).html());
	$('#transport_driver_licence_no').val($('#licence_no_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#transport_driver_status_true').attr('checked', true);
	}
	else{
		$('#transport_driver_status_false').attr('checked', true);
	}
	$('#update_driver').attr("class","");
    $('#create_driver').attr("disabled", true);
	$('#update_driver').attr("disabled", false);
	
	return false;
});
function resetDriverForm() {
	$('#transport_driver_provider_id').val("");
	$('#transport_driver_name').val("");
	$('#transport_driver_address').val("");
	$('#transport_driver_mobile').val("");
	$('#transport_driver_dl_valid_upto').val("");
	$('#transport_driver_licence_no').val("");
	$('#transport_driver_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_driver').attr("class","");
	$('#create_driver').attr("disabled", false);
	$('#update_driver').attr("disabled", true);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}

