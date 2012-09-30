var updateSchoolSessionTableFunction = function(data) {
	$.get('/school_sessions/all_record', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureSchoolSessionTable($('#active-table'));
		configureSchoolSessionTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_school_session').attr("disabled", true);
		$('#create_school_session').attr("disabled", false);
	});
}

$(document).on("click", "#create_school_session", function(event){
	event.preventDefault();
	var is_current_session = ""
	var name = $('#school_session_name').val();
	var start_date = $('#school_session_start_date').val();
	var end_date = $('#school_session_end_date').val();
	var is_current_session = $('#school_session_current_session').is(':checked');
	var data = {
				'school_session[name]' : name,
				'school_session[start_date]' : start_date,
				'school_session[end_date]' : end_date,
				'school_session[current_session]' : is_current_session
			}
	if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Session Name', {
				type : 'warning'
			});
			return false;
	}
	if(!start_date || start_date.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Start Date', {
				type : 'warning'
			});
			return false;
	}
	if(!end_date || end_date.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter End Date', {
				type : 'warning'
			});
			return false;
	}
	var target = '/school_sessions'
	if(is_current_session == true){
		confirmSchoolSession(target,data,updateSchoolSessionTableFunction,"create_school_session");
	}else{
		ajaxCreateSchoolSession(target,data,updateSchoolSessionTableFunction)
		resetSchoolSessionForm();
	}
});
function confirmSchoolSession(target,data,updateSchoolSessionTableFunction,createOrUpdate) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You want to make it as school current Session...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				if(createOrUpdate == "create_school_session"){
                	ajaxCreateSchoolSession(target,data,updateSchoolSessionTableFunction);
                	resetSchoolSessionForm();
	            }else{
	               	ajaxUpdateSchoolSession(target,data,updateSchoolSessionTableFunction);
	               	resetSchoolSessionForm();
	            }
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
				return false;
			}
		}
	});
}
function ajaxCreateSchoolSession(target,session_data,updateSchoolSessionTableFunction) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : session_data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				updateSchoolSessionTableFunction(data)
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}
function ajaxUpdateSchoolSession(target,session_data,updateSchoolSessionTableFunction) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'put',
		data : session_data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				updateSchoolSessionTableFunction(data)
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				submitBt.enableBt();
			}	
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}

	$('#update_school_session').on('click', function(event) {
		var is_current_session = ""
		var name = $('#school_session_name').val();
		var start_date = $('#school_session_start_date').val();
		var end_date = $('#school_session_end_date').val();
		var is_current_session = $('#school_session_current_session').is(':checked');
		var data = {
				'school_session[name]' : name,
				'school_session[start_date]' : start_date,
				'school_session[end_date]' : end_date,
				'school_session[current_session]' : is_current_session
			}
		if(!name || name.length == 0) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Session Name', {
					type : 'warning'
				});
				return false;
		}
		if(!start_date || start_date.length == 0) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Start Date', {
					type : 'warning'
				});
				return false;
		}
		if(!end_date || end_date.length == 0) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter End Date', {
					type : 'warning'
				});
				return false;
		}
		var current_object_id = $('#current_object_id').val();
		var target = "/school_sessions/" + current_object_id
		if(is_current_session == true){
			confirmSchoolSession(target,data,updateSchoolSessionTableFunction,"update_school_session");
		}else{
			ajaxUpdateSchoolSession(target, data,updateSchoolSessionTableFunction)
			resetSchoolSessionForm();
		}
		});


$(document).ready(function() {
	 resetSchoolSessionForm();
});
	$('#reset_school_session').on('click', function(event) {
		resetSchoolSessionForm();
	});
function resetSchoolSessionForm() {
	$('#school_session_name').val("");
	$('#current_object_id').val("");
	$('#create_school_session').attr("class","");
	$('#update_school_session').attr("disabled", true);
	$('#create_school_session').attr("disabled", false);
	$('#school_session_current_session').attr("checked" ,false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
	$('input[type=checkbox].current_seesion_checkbox').next('.mini-switch-replace').removeClass('mini-switch-replace-checked');
}


$(document).on("click", "a.update-school_session-master-href", function(event) {
	resetSchoolSessionForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#school_session_name').val($('#session_name_' + object_id).html());
	$('#school_session_start_date').val($('#session_start_date_' + object_id).html());
	$('#school_session_end_date').val($('#session_end_date_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");

	if(name == 'active-table'){
		$('#tab-active').showTab();
		$('input[type=checkbox].current_seesion_checkbox').next('.mini-switch-replace').addClass('mini-switch-replace-checked');
	}else{
		$('#tab-inactive').showTab();
		$('input[type=checkbox].current_seesion_checkbox').next('.mini-switch-replace').removeClass('mini-switch-replace-checked');
	}
	 	$('#update_school_session').attr("class","");
 		$('#update_school_session').attr("disabled", false);
		$('#create_school_session').attr("disabled", true);
	return false;
});

function configureSchoolSessionTable(tableNode) {
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
		}// No sorting for actions column
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


$('.school_session_table').each(function(i) {
	configureSchoolSessionTable($(this));
});
