//handler - should call upon succes of ajax call
var updateTransportVehicleTableFunction = function(data) {
	$.get('/transport_vehicles', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTransportVehicle($('#active-table'));
		configureTransportVehicle($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_vehicle').attr("disabled", true);
		$('#create_vehicle').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transport_vehicle-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var provider = $('#transport_vehicle_provider_id').val();
		var type = $('#transport_vehicle_vehicle_type').val();
		var registration_no = $('#transport_vehicle_registration_no').val();
		var capacity = $('#transport_vehicle_capacity').val();
		var hire_date = $('#transport_vehicle_date_of_hire').val();
		var expire_date = $('#transport_vehicle_date_of_expiry').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!stringReg.test(type)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Transport vehicle type', {
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
		
		if(!type || type.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport vehicle type', {
				type : 'warning'
			});
		}else if(!registration_no || registration_no.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter vehicle registration number', {
			type : 'warning'
		});
		return false;
	} else if(!capacity || capacity.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport vechile capacity', {
				type : 'warning'
			});
		}else if(!numericReg.test(capacity)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter transport vehicle capacity in digit', {
			type : 'warning'
		});
		return false;
	}else if(!hire_date || hire_date.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter vehicle date of hire', {
			type : 'warning'
		});
		return false;
	}else if(!expire_date || expire_date.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter vehicle date of expire', {
			type : 'warning'
		});
		return false;
	} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/transport_vehicles'

			var status = $("input[name='transport_vehicle\\[status\\]']:checked").val();
			// Request
			var data = {
				'transport_vehicle[provider_id]' : provider,
				'transport_vehicle[vehicle_type]' : type,
				'transport_vehicle[registration_no]' : registration_no,
				'transport_vehicle[capacity]' : capacity,
				'transport_vehicle[date_of_hire]' : hire_date,
				'transport_vehicle[date_of_expiry]' : expire_date,
				'transport_vehicle[status]' : status
			}

			ajaxCreate(target, data, updateTransportVehicleTableFunction, submitBt);
			resetVehicleForm();
		}
	});
});

$(document).ready(function() {
	$('#update_vehicle').on('click', function(event) {
		var provider = $('#transport_vehicle_provider_id').val();
		var type = $('#transport_vehicle_vehicle_type').val();
		var registration_no = $('#transport_vehicle_registration_no').val();
		var capacity = $('#transport_vehicle_capacity').val();
		var hire_date = $('#transport_vehicle_date_of_hire').val();
		var expire_date = $('#transport_vehicle_date_of_expiry').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!stringReg.test(type)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Transport vehicle type', {
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
		
		if(!type || type.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport vehicle type', {
				type : 'warning'
			});
		}else if(!registration_no || registration_no.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter vehicle registration number', {
			type : 'warning'
		});
		return false;
	} else if(!capacity || capacity.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport vechile capacity', {
				type : 'warning'
			});
		}else if(!numericReg.test(capacity)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter transport vehicle capacity in digit', {
			type : 'warning'
		});
		return false;
	}else if(!hire_date || hire_date.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter vehicle date of hire', {
			type : 'warning'
		});
		return false;
	}else if(!expire_date || expire_date.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter vehicle date of expire', {
			type : 'warning'
		});
		return false;
	}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='transport_vehicle\\[status\\]']:checked").val();
			// Target url
			var target = "/transport_vehicles/" + current_object_id
			// Request
			var data = {
				'transport_vehicle[provider_id]' : provider,
				'transport_vehicle[vehicle_type]' : type,
				'transport_vehicle[registration_no]' : registration_no,
				'transport_vehicle[capacity]' : capacity,
				'transport_vehicle[date_of_hire]' : hire_date,
				'transport_vehicle[date_of_expiry]' : expire_date,
				'transport_vehicle[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateTransportVehicleTableFunction, submitBt);
			resetVehicleForm();
		}
	});
});

$(document).ready(function() {
	resetVehicleForm();
	$('#reset_vehicle').on('click', function(event) {
		resetVehicleForm();
	});
});

$(document).on("click", 'a.delete-transport_vehicle-master-href', function(event) {
	resetVehicleForm();
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

$(document).on("click", 'a.update-transport_vehicle-master-href', function(event) {
	resetVehicleForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#transport_vehicle_provider_id').val($('#vehicle_providers_' + object_id).val());
	$('#transport_vehicle_vehicle_type').val($('#vehicle_type_' + object_id).html());
	$('#transport_vehicle_registration_no').val($('#registration_no_' + object_id).html());
	$('#transport_vehicle_capacity').val($('#capacity_' + object_id).html());
	$('#transport_vehicle_date_of_hire').val($('#hire_date_' + object_id).html());
	$('#transport_vehicle_date_of_expiry').val($('#expire_date_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#transport_vehicle_status_true').attr('checked', true);
	}
	else{
		$('#transport_vehicle_status_false').attr('checked', true);
	}
	$('#update_vehicle').attr("class","");
    $('#create_vehicle').attr("disabled", true);
	$('#update_vehicle').attr("disabled", false);
	
	return false;
});
function resetVehicleForm() {

	$('#transport_vehicle_provider_id').val("");
	$('#transport_vehicle_vehicle_type').val("");
	$('#transport_vehicle_capacity').val("");
	$('#transport_vehicle_registration_no').val("");
	$('#transport_vehicle_date_of_hire').val("");
	$('#transport_vehicle_date_of_expiry').val("");
	$('#transport_vehicle_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_vehicle').attr("class","");
	$('#create_vehicle').attr("disabled", false);
	$('#update_vehicle').attr("disabled", true);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}

function charactersLength() {
	var character_array=new Array();
	var classfield = null;
	
	$(".full-length").each(function() {
		if($(this).val().length >= 50) {
			classfield = false;
				field_name=$(this).attr('field_name')
			    character_array.push(classfield , field_name)
		}
	});
	return character_array;;
}
