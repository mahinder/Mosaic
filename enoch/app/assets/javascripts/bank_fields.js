//handler - should call upon succes of ajax call
var updateBankFieldTableFunction = function(data) {
	$.get('/bank_fields', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureBankFieldTable($('#active-table'));
		configureBankFieldTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_bank_field').attr("disabled", true);
		$('#create_bank_field').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#bank_fields-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#bank_field_name').val();
        var special_character = specialChar();
        var stringReg = /^[a-z+\s+A-Z()]*$/ 
        var length= charactersLength()
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter bank field name', {
				type : 'warning'
			});
		}else if(!stringReg.test(name)){
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Name', {
				type : 'warning'
			});
			return false;
	    }else if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/bank_fields'

			var status = $("input[name='bank_field\\[status\\]']:checked").val();
			// Request
			var data = {
				'bank_field[name]' : name,
				'bank_field[status]' : status
			}

			ajaxCreate(target, data, updateBankFieldTableFunction, submitBt);
			resetBankFieldForm();
		}
	});
});

$(document).ready(function() {
	$('#update_bank_field').on('click', function(event) {
		var name = $('#bank_field_name').val();
        var stringReg = /^[a-z+\s+A-Z()]*$/ 
        var length= charactersLength()
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter bank field name', {
				type : 'warning'
			});
		}else if(!stringReg.test(name)){
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Name', {
				type : 'warning'
			});
			return false;
	    }else if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='bank_field\\[status\\]']:checked").val();
			// Target url
			var target = "/bank_fields/" + current_object_id
			// Request
			var data = {
				'bank_field[name]' : name,
				'bank_field[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateBankFieldTableFunction, submitBt);
			resetBankFieldForm();

		}
	});
});

$(document).ready(function() {
	 resetBankFieldForm();
	$('#reset_bank_field').on('click', function(event) {
		resetBankFieldForm();
	});
});

$(document).on("click", 'a.delete-bank_field-master-href', function(event) {
	resetBankFieldForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-bank_field-master-href', function(event) {
	resetBankFieldForm();
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#bank_field_name').val($('#bank_field_name_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#bank_field_status_true').attr('checked', true);
	else
		$('#bank_field_status_false').attr('checked', true);

	$('#update_bank_field').attr("disabled", false);
	$('#create_bank_field').attr("disabled", true);
	return false;
});

function resetBankFieldForm() {
	$('#bank_field_name').val("");
	$('#bank_field_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_bank_field').attr("disabled", true);
	$('#create_bank_field').attr("disabled", false);
	// $('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}

//special characters
function charactersLength() {
	var character_array=new Array();
	var classfield = null;
	
	$(".full-length").each(function() {
		if($(this).val().length >=50) {
			classfield = false;
				field_name=$(this).attr('field_name')
			    character_array.push(classfield , field_name)
		}
	});
	return character_array;;
}