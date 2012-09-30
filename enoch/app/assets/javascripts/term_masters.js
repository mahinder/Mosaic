//handler - should call upon succes of ajax call
var updateTermMasterTableFunction = function(data) {
	$.get('/term_masters', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTermMasterTable($('#active-table-of-term-master'));
		configureTermMasterTable($('#inactive-table-of-term-master'));
		$('.tabs').updateTabs();
		$('#update_term_master').attr("disabled", true);
		$('#create_term_master').attr("disabled", false);
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#termMaster-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#term_master_name').val();
		var characterlength = characterLength();
		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(name.length >= 50) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 in name', {
					type : 'warning'
				});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Term name', {
				type : 'warning'
			});
		}else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/term_masters'

			var status = $("input[name='term_master\\[is_active\\]']:checked").val();
			// Request
			var data = {
				'term_master[name]' : name,
				'term_master[is_active]' : status
			}

			ajaxCreate(target, data, updateTermMasterTableFunction, submitBt);
			resetTermMasterForm();
		}
	});
});

$(document).ready(function() {
	$('#update_term_master').on('click', function(event) {
		var name = $('#term_master_name').val();
		var characterlength = characterLength();
		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Position name', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='term_master\\[is_active\\]']:checked").val();
			// Target url
			var target = "/term_masters/" + current_object_id
			// Request
			var data = {
				'term_master[name]' : name,
				'term_master[is_active]' : status
			}
			ajaxUpdate(target, data, updateTermMasterTableFunction, submitBt);
			resetTermMasterForm();
		}
	});
});

$(document).on("click", 'a.delete-term-master-href', function(event) {
	resetTermMasterForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return true;
});

$(document).on("click", 'a.update-term-master-href', function(event) {
	resetTermMasterForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#term_master_name').val($('#term_name_' + object_id).html().replace(/&amp;/g, "&"));
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table-of-term-master'){
		$('#term_master_is_active_true').attr('checked', true);
	}else{
		$('#term_master_is_active_false').attr('checked', true);
	}
    $('#update_term_master').attr("class","");
	$('#update_term_master').attr("disabled", false);
	$('#create_term_master').attr("disabled", true);
	return false;
});


$(document).ready(function() {
	resetTermMasterForm();
	$('#reset_term_master').on('click', function(event) {
		resetTermMasterForm();
	});
});

function resetTermMasterForm() {
	$('#term_master_name').val("");
	$('#term_master_is_active_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_term_master').attr("disabled", true);
	$('#create_term_master').attr("disabled", false);
	// $('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}
function configureTermMasterTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		}, // No sorting for this columns, as it only contains checkboxes
		{
			sType : 'string'
		},
		{
			bSortable : false
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
			sDom: '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix"lf>',
						
				/*
				 * Callback to apply template setup
				 */
				fnDrawCallback: function()
				{
					this.parent().applyTemplateSetup();
				},
				fnInitComplete: function()
				{
					this.parent().applyTemplateSetup();
				}
			});
				
				// Sorting arrows behaviour
				table.find('thead .sort-up').click(function(event)
				{
					// Stop link behaviour
					event.preventDefault();
					
					// Find column index
					var column = $(this).closest('th'),
						columnIndex = column.parent().children().index(column.get(0));
					
					// Send command
					oTable.fnSort([[columnIndex, 'asc']]);
					
					// Prevent bubbling
					return false;
				});
				table.find('thead .sort-down').click(function(event)
				{
					// Stop link behaviour
					event.preventDefault();
					
					// Find column index
					var column = $(this).closest('th'),
						columnIndex = column.parent().children().index(column.get(0));
					
					// Send command
					oTable.fnSort([[columnIndex, 'desc']]);
					
					// Prevent bubbling
					return false;
				});
};


$('.termMasters').each(function(i) {
	configureTermMasterTable($(this));
});

