//handler - should call upon succes of ajax call
var updateTransportProviderTableFunction = function(data) {
	$.get('/providers', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTransportProvider($('#active-table'));
		configureTransportProvider($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_provider').attr("disabled", true);
		$('#create_provider').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#provider-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
        
		// Check fields
		var name = $('#provider_name').val();
		var address = $('#provider_address').val();
		var city = $('#provider_city').val();
		var mobile = $('#provider_mobile').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		
		
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Transport provider name', {
				type : 'warning'
			});
			return false;
		}
		if(!stringReg.test(city)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for city', {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider name', {
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
		
		if(!address || address.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider address', {
				type : 'warning'
			});
		} else if(!city || city.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider city', {
				type : 'warning'
			});
		}else if(mobile.length>10 || mobile.length<10 || !numericReg.test(mobile)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider mobile number of 10 digit', {
			type : 'warning'
		});
		return false;
	}  else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/providers'

			var status = $("input[name='provider\\[status\\]']:checked").val();
			// Request
			var data = {
				'provider[name]' : name,
				'provider[address]' : address,
				'provider[city]' : city,
				'provider[mobile]' : mobile,
				'provider[status]' : status
			}

			ajaxCreate(target, data, updateTransportProviderTableFunction, submitBt);
			resetProviderForm();
		}
	});
});

$(document).ready(function() {
	$('#update_provider').on('click', function(event) {
		var name = $('#provider_name').val();
		var address = $('#provider_address').val();
		var city = $('#provider_city').val();
		var mobile = $('#provider_mobile').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Transport provider name', {
				type : 'warning'
			});
			return false;
		}
		if(!stringReg.test(city)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for city', {
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
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider name', {
				type : 'warning'
			});
			return false;
		}
		
		if(!address || address.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider address', {
				type : 'warning'
			});
		} else if(!city || city.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider city', {
				type : 'warning'
			});
		}else if(mobile.length>10 || mobile.length<10 || !numericReg.test(mobile)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter transport provider mobile number of 10 digit', {
			type : 'warning'
		});
		return false;
	}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='provider\\[status\\]']:checked").val();
			// Target url
			var target = "/providers/" + current_object_id
			// Request
			var data = {
				'provider[name]' : name,
				'provider[address]' : address,
				'provider[city]' : city,
				'provider[mobile]' : mobile,
				'provider[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateTransportProviderTableFunction, submitBt);
			resetProviderForm();
		}
	});
});

$(document).ready(function() {
	resetProviderForm();
	$('#reset_provider').on('click', function(event) {
		resetProviderForm();
	});
});

$(document).on("click", 'a.delete-provider-master-href', function(event) {
	resetProviderForm();
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

$(document).on("click", 'a.update-provider-master-href', function(event) {
	resetProviderForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#provider_name').val($('#provider_name_' + object_id).html());
	$('#provider_address').val($('#provider_address_' + object_id).html());
	$('#provider_city').val($('#provider_city_' + object_id).html());
	$('#provider_mobile').val($('#provider_mobile_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#provider_status_true').attr('checked', true);
	}
	else{
		$('#provider_status_false').attr('checked', true);
	}
	$('#update_provider').attr("class","");
    $('#create_provider').attr("disabled", true);
	$('#update_provider').attr("disabled", false);
	
	return false;
});
function resetProviderForm() {

	$('#provider_name').val("");
	$('#provider_address').val("");
	$('#provider_city').val("");
	$('#provider_mobile').val("");
	$('#provider_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_provider').attr("class","");
	$('#create_provider').attr("disabled", false);
	$('#update_provider').attr("disabled", true);
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