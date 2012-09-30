//handler - should call upon succes of ajax call
var updateAdditionalFieldTableFunction = function(data) {
	$.get('/additional_fields', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureAdditionalTable($('#active-table'));
		configureAdditionalTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_additional_field').attr("disabled", true);
		$('#create_additional_field').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#additional_fields-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#additional_field_name').val();
	 var length= charactersLength()
	var stringReg = /^[a-z+\s+A-Z()]*$/ 
	
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter additional field name', {
				type : 'warning'
			});
		} else if(!stringReg.test(name)){
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Name', {
				type : 'warning'
			});
			return false;
	    }else if(length[0]==false){
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/additional_fields'

			var status = $("input[name='additional_field\\[status\\]']:checked").val();
			// Request
			var data = {
				'additional_field[name]' : name,
				'additional_field[status]' : status
			}

			ajaxCreate(target, data, updateAdditionalFieldTableFunction, submitBt);
			resetAdditionalFieldForm();
		}
	});
});

$(document).ready(function() {
	$('#update_additional_field').on('click', function(event) {
		var length= charactersLength()
        var name = $('#additional_field_name').val();
        var stringReg = /^[a-z+\s+A-Z()]*$/ 
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter additional field name', {
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
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='additional_field\\[status\\]']:checked").val();
			// Target url
			var target = "/additional_fields/" + current_object_id
			// Request
			var data = {
				'additional_field[name]' : name,
				'additional_field[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateAdditionalFieldTableFunction, submitBt);
			resetAdditionalFieldForm();
		}
	});
});

$(document).ready(function() {
	 resetAdditionalFieldForm();
	$('#reset_additional_field').on('click', function(event) {
		
		resetAdditionalFieldForm();
	});
});

$(document).on("click", 'a.delete-additionalfield-master-href', function(event) {
	resetAdditionalFieldForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-additionalfield-master-href', function(event) {
	
	resetAdditionalFieldForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#additional_field_name').val($('#additional_field_name_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#additional_field_status_true').attr('checked', true);
	else
		$('#additional_field_status_false').attr('checked', true);
    $('#update_additional_field').attr("class","");
	$('#update_additional_field').attr("disabled", false);
	$('#create_additional_field').attr("disabled", true);
	return false;
});

function resetAdditionalFieldForm() {
	
	$('#additional_field_name').val("");
	$('#additional_field_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_additional_field').attr("disabled", true);
	$('#create_additional_field').attr("disabled", false);
	 $('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();

}
//special characters
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