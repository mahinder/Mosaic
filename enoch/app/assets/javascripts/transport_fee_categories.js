//handler - should call upon succes of ajax call
var updateTranportFeeCategoryTableFunction = function(data) {
	$.get('/transport_fee_categories', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTransportFee($('#active-table'));
		configureTransportFee($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_transport_fee_category').attr("disabled", true);
		$('#create_transport_fee_category').attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transport_fee_category-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var passenger_type = $('#transport_fee_category_passenger_type').val();
		var fee = $('#transport_fee_category_monthly_fee').val();
		var name = $('#transport_fee_category_name').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport fee category name', {
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
		if(!passenger_type || passenger_type.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose passenger type', {
				type : 'warning'
			});
			return false;
		}
		if(!fee || fee.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport monthly fee', {
				type : 'warning'
			});
			return false;
		}else if(!numericReg.test(fee)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter transport monthly fee in digit', {
			type : 'warning'
		});
		return false;
	} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/transport_fee_categories'

			var status = $("input[name='transport_fee_category\\[status\\]']:checked").val();
			// Request
			var data = {
				'transport_fee_category[passenger_type]' : passenger_type,
				'transport_fee_category[name]' : name,
				'transport_fee_category[monthly_fee]' : fee,
				'transport_fee_category[status]' : status
			}

			ajaxCreate(target, data, updateTranportFeeCategoryTableFunction, submitBt);
			resetFeeForm();
		}
	});
});

$(document).ready(function() {
	$('#update_transport_fee_category').on('click', function(event) {
		
		var passenger_type = $('#transport_fee_category_passenger_type').val();
		var name = $('#transport_fee_category_name').val();
		var fee = $('#transport_fee_category_monthly_fee').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var character_length=charactersLength();
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport fee category name', {
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
		if(!passenger_type || passenger_type.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose passenger type', {
				type : 'warning'
			});
			return false;
		}
		if(!fee || fee.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter transport monthly fee', {
				type : 'warning'
			});
			return false;
		}else if(!numericReg.test(fee)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter transport monthly fee in digit', {
			type : 'warning'
		});
		return false;
	}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='transport_fee_category\\[status\\]']:checked").val();
			// Target url
			var target = "/transport_fee_categories/" + current_object_id
			// Request
			var data = {
				'transport_fee_category[passenger_type]' : passenger_type,
				'transport_fee_category[name]' : name,
				'transport_fee_category[monthly_fee]' : fee,
				'transport_fee_category[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateTranportFeeCategoryTableFunction, submitBt);
			resetFeeForm();
		}
	});
});

$(document).ready(function() {
	resetFeeForm();
	$('#reset_transport_fee_category').on('click', function(event) {
		resetFeeForm();
	});
});

$(document).on("click", 'a.delete-transport_fee_category-master-href', function(event) {
	resetFeeForm();
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

$(document).on("click", 'a.update-transport_fee_category-master-href', function(event) {
	resetFeeForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	
	$('#transport_fee_category_passenger_type').val($('#passenger_type_' + object_id).html());
	$('#transport_fee_category_name').val($('#name_' + object_id).html());
	$('#transport_fee_category_monthly_fee').val($('#monthly_fee_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table') {
		$('#transport_fee_category_status_true').attr('checked', true);
	} else {
		$('#transport_fee_category_status_false').attr('checked', true);
	}
	$('#update_transport_fee_category').attr("class", "");
	$('#create_transport_fee_category').attr("disabled", true);
	$('#update_transport_fee_category').attr("disabled", false);

	return false;
});
function resetFeeForm() {

	
	$('#transport_fee_category_passenger_type').val("");
	$('#transport_fee_category_monthly_fee').val("");
	$('#transport_fee_category_name').val("");
	$('#transport_fee_category_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_transport_fee_category').attr("class", "");
	$('#create_transport_fee_category').attr("disabled", false);
	$('#update_transport_fee_category').attr("disabled", true);
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
