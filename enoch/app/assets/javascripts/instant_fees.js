var updateInstantFeesTableFunction = function(data) {
	$.get('/instant_fees', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureInstantFeesTable($('#instantfees'));
		$('.tabs').updateTabs();
		$('#update_instant_fee_category').attr("disabled", true);
		$('#create_instant_fee_category').attr("disabled", false);
	});
}
function configureInstantFeesTable(tableNode) {
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
		}, {
			sType : 'string'
		}, {
			sType : 'string'
		}
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix"lf>',
		/*
		 * Callback to apply template setup
		 */
		fnDrawCallback : function() {
			this.parent().applyTemplateSetup();
		},
		fnInitComplete : function() {
			this.parent().applyTemplateSetup();
		}
	});
	// Sorting arrows behaviour
	table.find('thead .sort-up').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'asc']]);
		// Prevent bubbling
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'desc']]);
		// Prevent bubbling
		return false;
	});
};

$('.instantfees').each(function(i) {
	configureInstantFeesTable($(this));
});

$(document).ready(function() {
	$('#instantFees-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#instant_fee_name').val();
		var description = $('#instant_fee_description').val();
		var characterlength = characterLength();
		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(name.length >= 50) {
						$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(description.length >= 50) {
						$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Instant Fee name', {
				type : 'warning'
			});
		} else if(!description || description.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Instant Fee Description', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = $(this).attr('action');
			if(!target || target == '') {
				// Page url without hash
				target = document.location.href.match(/^([^#]+)/)[1];
			}
			// Request
			var data = {
				'instant_fee[name]' : name,
				'instant_fee[description]' : description
			}

			ajaxCreate(target, data, updateInstantFeesTableFunction, submitBt);
			resetInstantFeesForm();
		}
	});
});

$(document).on("click", 'a.update-instant-fees-master-href', function(event) {
	resetInstantFeesForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#instant_fee_name').val($('#instant_fee_name_' + object_id).html());
	$('#instant_fee_description').val($('#instant_fee_description_' + object_id).html());
	$('#current_object_id').val(object_id);

    $('#update_instant_fee_category').attr("class","");
	$('#update_instant_fee_category').attr("disabled", false);
	$('#create_instant_fee_category').attr("disabled", true);
	return false;
});

$(document).ready(function() {
	$('#update_instant_fee_category').on('click', function(event) {
		var name = $('#instant_fee_name').val();
		var description = $('#instant_fee_description').val();

		var characterlength = characterLength();

		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}

		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Instant Fee name', {
				type : 'warning'
			});
		} else if(!description || description.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Instant Fee Description', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var target = "/instant_fees/" + current_object_id
			// Request
			var data = {
				'instant_fee[name]' : name,
				'instant_fee[description]' : description,
				'_method' : 'put'
			}
			ajaxUpdate(target, data, updateInstantFeesTableFunction, submitBt);
			resetInstantFeesForm();
		}
	});
});
$(document).on("click", 'a.delete-instant-fees-master-href', function(event) {
	resetInstantFeesForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).ready(function() {
	resetInstantFeesForm()
	$('#reset_instant_fee_category').on('click', function(event) {
		resetInstantFeesForm();
	});
});
function resetInstantFeesForm() {
	$('#instant_fee_name').val("");
	$('#instant_fee_description').val("");
	$('#current_object_id').val("");
	$('#create_instant_fee_category').attr("class","");
	$('#update_instant_fee_category').attr("disabled", true);
	$('#create_instant_fee_category').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
}


//==========================================Instant Fee Particular=======================================//


$(document).on("click", 'a.add_instant-fees-master-href', function(event) {
	event.preventDefault()
   if(blockDoubleClick != true){
	blockDoubleClick = true;
	resetInstantFeesForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = "/instant_fee_particulars" + "/new" ;
	getInstantFeesParticular(remoteUrl, table, row, object_id);
	return false;
	}
}); 

function getInstantFeesParticular(remoteUrl, table, row, object_id){
	$.get(remoteUrl,{id : object_id},function(data){
	   particularDataModalBox(data,object_id);
	   configureInstantFeesParticularTable($('#modal #active-table'));	
	}).complete ( function(jqXHR){
	    blockDoubleClick = false;
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	
}

function particularDataModalBox(data,object_id){
	var modal_box_title = $("#instant_fee_name_"+object_id).text();
	$.modal({
		content : data,
		title : 'Create Particular for '+modal_box_title,
		width : 700,
		height :400,
		buttons : {
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
	resetInstantFeesParticularForm();
}

var updateInstantFeesParticularTableFunction = function(data) {
	var id  = document.getElementById('instant_fees_id').value;
	$.get('/instant_fee_particulars',{id : id}, function(data) {
		$('#modal #table-block').empty();
		$('#modal #table-block').html(data);
		configureInstantFeesParticularTable($('#modal #active-table'));
		$('#modal .tabs').updateTabs();
		$('#update_instant_fee_particular').attr("disabled", true);
		$('#create_instant_fee_particular').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}
function configureInstantFeesParticularTable(tableNode) {
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
		}, {
			sType : 'string'
		}, {
			sType : 'string'
		}, {
			sType : 'string'
		}
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix  no-margin"lf>',
		/*
		 * Callback to apply template setup
		 */
		fnDrawCallback : function() {
			this.parent().applyTemplateSetup();
		},
		fnInitComplete : function() {
			this.parent().applyTemplateSetup();
		}
	});
	// Sorting arrows behaviour
	table.find('thead .sort-up').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'asc']]);
		// Prevent bubbling
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'desc']]);
		// Prevent bubbling
		return false;
	});
};

$('#modal .instantfeesParticulars').each(function(i) {
	configureInstantFeesParticularTable($(this));
});

$(document).on("submit", "#instantFeesParticulars-form", function(event){
		event.preventDefault();

		var name = $('#instant_fee_particular_name').val();
		var description = $('#instant_fee_particular_description').val();
		var amount = $('#instant_fee_particular_amount').val();
		var instant_fee_id = document.getElementById('instant_fees_id').value;
		var characterlength = characterLength();
		if(characterlength[0] == false) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(name.length >= 50) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(description.length >= 50) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(amount.length >= 6) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter valid amount', {
							type : 'warning'
						});
					return false;
		}
		if(isNaN(amount) || amount.indexOf(" ") != -1) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter Valid Particular Amount', {
				type : 'warning'
			});
			return false;
	    }
		if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter particular name', {
				type : 'warning'
			});
		}else if(!description || description.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter particular Description', {
				type : 'warning'
			});
		}else if(!amount || amount.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter particular Amount', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = $(this).attr('action');
			if(!target || target == '') {
				// Page url without hash
				target = document.location.href.match(/^([^#]+)/)[1];
			}
			// Request
			var data = {
				'instant_fee_particular[name]' : name,
				'instant_fee_particular[description]' : description,
				'instant_fee_particular[amount]' : amount,
				'instant_fee_particular[instant_fee_id]' : instant_fee_id,
				'instant_fee_particular[is_deleted]' : false
			}

			ajaxCreateInstantFeesParticular(target, data, updateInstantFeesParticularTableFunction, submitBt);
			resetInstantFeesParticularForm();
		}
	});

$(document).on("click", 'a.update-particular_fee-master-href', function(event) {
	resetInstantFeesParticularForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#instant_fee_particular_name').val($('#particular_fee_name_' + object_id).html());
	$('#instant_fee_particular_description').val($('#particular_fee_description_' + object_id).html());
	$('#instant_fee_particular_amount').val($('#particular_fee_amount_' + object_id).html());
	$('#current_object_id').val(object_id);

    $('#update_instant_fee_particular').attr("class","");
	$('#update_instant_fee_particular').attr("disabled", false);
	$('#create_instant_fee_particular').attr("disabled", true);
	return false;
});

$(document).on("click", "#update_instant_fee_particular", function(event){
		var name = $('#instant_fee_particular_name').val();
		var description = $('#instant_fee_particular_description').val();
		var amount = $('#instant_fee_particular_amount').val();
		var instant_fee_id = document.getElementById('instant_fees_id').value;
		var characterlength = characterLength();

		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(name.length >= 50) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(description.length >= 50) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
		}
		if(amount.length >= 6) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter valid amount', {
							type : 'warning'
						});
					return false;
		}
		if(isNaN(amount) || amount.indexOf(" ") != -1) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter Valid Particular Amount', {
				type : 'warning'
			});
			return false;
	    }
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Instant Fee name', {
				type : 'warning'
			});
		} else if(!description || description.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Instant Fee Description', {
				type : 'warning'
			});
		}else if(!amount || amount.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter particular Amount', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var target = "/instant_fee_particulars/" + current_object_id
			// Request
			var data = {
				'instant_fee_particular[name]' : name,
				'instant_fee_particular[description]' : description,
				'instant_fee_particular[amount]' : amount,
				'instant_fee_particular[instant_fee_id]' : instant_fee_id,
				'instant_fee_particular[is_deleted]' : false,
				'_method' : 'put'
			}
			ajaxParticularsUpdate(target, data, updateInstantFeesParticularTableFunction, submitBt);
			resetInstantFeesParticularForm();
		}
	});
// });
$(document).on("click", 'a.delete-particular_fee-master-href', function(event) {
	resetInstantFeesParticularForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#modal #url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmParticularDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click","#reset_instant_fee_particular",function(event){
		resetInstantFeesParticularForm();
});

function resetInstantFeesParticularForm() {
	$('#instant_fee_particular_name').val("");
	$('#instant_fee_particular_description').val("");
	$('#instant_fee_particular_amount').val("");
	$('#current_object_id').val("");
	$('#create_instant_fee_particular').attr("class","");
	$('#update_instant_fee_particular').attr("disabled", true);
	$('#create_instant_fee_particular').attr("disabled", false);
	$('#modal #outer_block').removeBlockMessages();
	$('#modal #tab-active').showTab();
}
function ajaxCreateInstantFeesParticular(target, data, successFunction, submitBt) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				//individual domain need to implement this method
				successFunction(data);
				submitBt.enableBt();
				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				submitBt.enableBt();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
	submitBt.enableBt();
}

function ajaxParticularsUpdate(remoteUrl, data, successFunction, submitBt) {
	$.ajax({
		url : remoteUrl,
		type : 'put',
		dataType : 'json',
		data : data, // it should have '_method' : 'put'
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				//individual domain need to implement this method
				successFunction(data);
				//populateTables();
				submitBt.enableBt();
				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				submitBt.enableBt();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});
	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

function confirmParticularDelete(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxParticularDelete(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxParticularDelete(remoteUrl, table, row) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				var dataTable = table.dataTable();
				dataTable.fnDeleteRow(row.index());

				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				
			} else {
				
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}