//handler - should call upon succes of ajax call
var updateLiabilityTableFunction = function(data) {
	$.get('/liabilities', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureLiabilityTable($('#active-table'));
		configureLiabilityTable($('#inactive-table'));
		$('.tabs').updateTabs();
		attachLiabilitiesDeleteHandler();
		attachLiabilitiesUpdateHandler();
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#liabilities-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var title = $('#liability_title').val();
		var description = $('#liability_description').val();
        var amount = $('#liability_amount').val();		

		if(!title || title.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter liability title', {
				type : 'warning'
			});
		} else if(!amount || amount.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter amount in valid format', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/liabilities'

			
			var solved = $("input[name='liability\\[is_solved\\]']:checked").val();
			var deleted = $("input[name='liability\\[is_deleted\\]']:checked").val();
			// Request
			var data = {
				'liability[title]' : title,
				'liability[description]' : description,
				'liability[amount]' : amount,
				'liability[is_solved]' : solved,
				'liability[is_deleted]' : deleted
			}
			
			ajaxCreate(target, data, updateLiabilityTableFunction, submitBt);
			resetLiabilitiesForm();
		}
	});
});

$(document).ready(function() {
	$('#update_liability').on('click', function(event) {
		var title = $('#liability_title').val();
		var description = $('#liability_description').val();
        var amount = $('#liability_amount').val();	
        // var solved = $('#liability_is_solved').val();	
		if(!title || title.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter liability title', {
				type : 'warning'
			});
		} else if(!amount || amount.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter amount in valid format', {
				type : 'warning'
			});
		}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var deleted = $("input[name='liability\\[is_deleted\\]']:checked").val();
			 var solved = $("input[name='liability\\[is_solved\\]']:checked").val();
			// Target url
			var target = "/liabilities/" + current_object_id
			// Request
			var data = {
				'liability[title]' : title,
				'liability[description]' : description,
				'liability[amount]' : amount,
				'liability[is_solved]' : solved,
				'liability[is_deleted]' : deleted,
				'_method' : 'put'
			}
			
			ajaxUpdate(target, data, updateLiabilityTableFunction, submitBt);
		}
	});
});

$(document).ready(function() {
	attachLiabilitiesDeleteHandler();
});

$(document).ready(function() {
	attachLiabilitiesUpdateHandler();
});

$(document).ready(function() {	
	// resetLiabilitiesForm();
	$('#reset_liability').on('click', function(event) {
		resetLiabilitiesForm();
	});
});

function attachLiabilitiesDeleteHandler(){
	$('a.delete-liability-master-href').on('click', function(event) {
		resetLiabilitiesForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var url_prefix = $('#url_prefix').val();
		var remoteUrl = url_prefix + "/" + object_id;
		confirmDelete(remoteUrl, table, row);
		return false;
	});
}

function attachLiabilitiesUpdateHandler(){
	$('a.update-liability-master-href').on('click', function(event) {
		resetLiabilitiesForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		
		$('#liability_title').val($('#liability_title_' + object_id).html());
		$('#liability_description').val($('#liability_description_' + object_id).html());
		$('#liability_amount').val($('#liability_amount_' + object_id).html());
		// $('#liability_is_solved').val($('#liability_is_solved_' + object_id).html());
		$('#current_object_id').val(object_id);
		var solved = $('#liability_is_solved_' + object_id).html()
		if(solved == 'true') $('#liability_is_solved_false').attr('checked', true);
		else $('#liability_is_solved_true').attr('checked', true);
		
		var name = table.attr("id");
		if(name == 'active-table')	$('#liability_is_deleted_false').attr('checked', true);
		else $('#liability_is_deleted_true').attr('checked', true);
		
		$('#update_liability').attr("disabled", false);
		$('#create_liability').attr("disabled", true);
		return false;
	});
}

function resetLiabilitiesForm() {
	$('#liability_title').val("");
	$('#liability_description').val("");
	$('#liability_amount').val("");
	$('#liability_is_deleted_false').attr('checked', true);
	$('#liability_is_solved_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_liability').attr("disabled", true);
	$('#create_liability').attr("disabled", false);
}
