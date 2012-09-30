//handler - should call upon succes of ajax call
var updateFinancialAssetsTableFunction = function(data) {
	$.get('/financial_assets', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureFinancialAssetsTable($('#assets-active-table'));
		configureFinancialAssetsTable($('#assets-inactive-table'));
		$('.tabs').updateTabs();
		attachFinancialAssetsDeleteHandler();
		attachFinancialAssetsUpdateHandler();
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#financial-assets-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var title = $('#financial_asset_title').val();
		var description = $('#financial_asset_description').val();
        var amount = $('#financial_asset_amount').val();		
         var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		if(!title || title.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter asset title', {
				type : 'warning'
			});
		} else if(!amount || amount.length == 0 || !numericReg.test(amount)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter amount in valid format', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/financial_assets'

			
			var status = $("input[name='financial_asset\\[is_inactive\\]']:checked").val();
			var deleted = $("input[name='financial_asset\\[is_deleted\\]']:checked").val();
			// Request
			var data = {
				'financial_asset[title]' : title,
				'financial_asset[description]' : description,
				'financial_asset[amount]' : amount,
				'financial_asset[is_inactive]' : status,
				'financial_asset[is_deleted]' : deleted
			}
			
			ajaxCreate(target, data, updateFinancialAssetsTableFunction, submitBt);
			resetFinancialAssetsForm();
		}
	});
});

$(document).ready(function() {
	$('#update_asset').on('click', function(event) {
		var title = $('#financial_asset_title').val();
		var description = $('#financial_asset_description').val();
        var amount = $('#financial_asset_amount').val();	
       	 var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		if(!title || title.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter asset title', {
				type : 'warning'
			});
		} else if(!amount || amount.length == 0 || !numericReg.test(amount)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter amount in valid format', {
				type : 'warning'
			});
		}  else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var deleted = $("input[name='financial_asset\\[is_deleted\\]']:checked").val();
			 var status = $("input[name='financial_asset\\[is_inactive\\]']:checked").val();
			// Target url
			var target = "/financial_assets/" + current_object_id
			// Request
			var data = {
				'financial_asset[title]' : title,
				'financial_asset[description]' : description,
				'financial_asset[amount]' : amount,
				'financial_asset[is_inactive]' : status,
				'financial_asset[is_deleted]' : deleted,
				'_method' : 'put'
			}
			
			ajaxUpdate(target, data, updateFinancialAssetsTableFunction, submitBt);
		}
	});
});

$(document).ready(function() {
	attachFinancialAssetsDeleteHandler();
});

$(document).ready(function() {
	attachFinancialAssetsUpdateHandler();
});

$(document).ready(function() {	
	// resetFinancialAssetsForm();
	$('#reset_asset').on('click', function(event) {
		resetFinancialAssetsForm();
	});
});

function attachFinancialAssetsDeleteHandler(){
	$('a.delete-financial-master-href').on('click', function(event) {
		resetFinancialAssetsForm();
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

function attachFinancialAssetsUpdateHandler(){
	$('a.update-financial-master-href').on('click', function(event) {
		resetFinancialAssetsForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		
		$('#financial_asset_title').val($('#financial_asset_title_' + object_id).html());
		$('#financial_asset_description').val($('#financial_asset_description_' + object_id).html());
		$('#financial_asset_amount').val($('#financial_asset_amount_' + object_id).html());
		$('#current_object_id').val(object_id);
		
		var deleted = $('#financial_asset_is_deleted_' + object_id).html()
		if(deleted == 'true') $('#financial_asset_is_deleted_true').attr('checked', true);
		else $('#financial_asset_is_deleted_false').attr('checked', true);
		
		var name = table.attr("id");
		if(name == 'assets-active-table')	$('#financial_asset_is_inactive_false').attr('checked', true);
		else $('#financial_asset_is_inactive_true').attr('checked', true);
		
		$('#update_asset').attr("disabled", false);
		$('#create_asset').attr("disabled", true);
		return false;
	});
}

function resetFinancialAssetsForm() {
	$('#financial_asset_title').val("");
	$('#financial_asset_description').val("");
	$('#financial_asset_amount').val("");
	$('#financial_asset_is_deleted_false').attr('checked', true);
	$('#financial_asset_is_inactive_false').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_asset').attr("disabled", true);
	$('#create_asset').attr("disabled", false);
	$('#tab-active').showTab();
}
