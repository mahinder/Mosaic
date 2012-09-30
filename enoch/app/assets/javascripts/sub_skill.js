$(document).on("click", ".add_subskills-mandatory-skill-href", function(event) {

	var id = $(this).attr('data-skill')
	event.preventDefault();
	$.get('/sub_skills/subskill_find', {
		id : id
	}, function(data) {

		$.modal({
			content : data,
			title : 'Create Sub Skill',
			width : 700,
			maxHeight : 500,
			buttons : {
				'Close' : function(win) {
					win.closeModal();
				}
			}
		});
		configureSubskillTable($('#subskill'));
		resetSubskillForm();
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
})
function configureSubskillTable(tableNode) {
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
			bSortable : false
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix no-margin"lf>',
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

//-----------------------------------------------------------------------------------------------------------------------

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$(document).on("click", "#create_subskill", function(event) {
		// Stop full page load
		event.preventDefault();
		var id = $(this).attr('skill-data')
		var name = $('#modal #sub_skill_name').val();
		var stringReg = /^[A-Za-z() ]*$/;
		var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
		if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter subskill Name', {
				type : 'warning'
			});
		} else if(name.length > 25) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		}else if(!stringReg.test(name)) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(!characterReg.test(name)) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Special character not allowed', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			var target = '/sub_skills'
			var status = $("input[name='sub_skill\\[is_active\\]']:checked").val();
			// Requ@elective_skillsest
			var data = {
				'sub_skill[name]' : name,
				'sub_skill[is_active]' : status,
				'sub_skill[skill_id]' : id
			}

			ajaxCreateSubskill(target, data, id);
			resetSubskillForm();

		}
	});
});

$(document).ready(function() {
	$(document).on("click", "#update_subskill", function(event) {
		event.preventDefault();
		var id = $(this).attr('skill-data')
		var name = $('#modal #sub_skill_name').val();

		if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter subskill Name', {
				type : 'warning'
			});
		} else {
			var current_object_id = $('#current_object_id').val();

			var target = '/sub_skills/' + current_object_id
			var status = $("input[name='sub_skill\\[is_active\\]']:checked").val();
			// Requ@elective_skillsest
			var data = {
				'sub_skill[name]' : name,
				'sub_skill[is_active]' : status,
				'sub_skill[skill_id]' : id
			}

			ajaxUpdateSubskill(target, data, id);
			resetSubskillForm();

		}
	});
});

$(document).ready(function() {
	resetSubskillForm();
	$(document).on("click", "#reset_subskill", function(event) {
		resetSubskillForm();
	});
});
function resetSubskillForm() {

	$('#modal #sub_skill_name').val("");
	$('#modal #sub_skill_is_active_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#modal #update_subskill').attr("disabled", true);
	$('#modal #create_subskill').attr("disabled", false);
	$('#modal #outer_block').removeBlockMessages();

}


$(document).on("click", "a.update-subskill-href", function(event) {
	resetSubskillForm();
	$('#modal').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#modal #sub_skill_name').val($('#subskill_name_' + object_id).html());
	$('#modal #current_object_id').val(object_id);

	var name = $('#subskill_isactive_' + object_id).html();
	if(name == 'Active')
		$('#modal #sub_skill_is_active_true').attr('checked', true);
	else
		$('#modal #sub_skill_is_active_false').attr('checked', true);
	$('#modal #update_subskill').attr("disabled", false);
	$('#modal #create_subskill').attr("disabled", true);
	return false;
});

$(document).on("click", "a.delete-subskill-href", function(event) {
	resetSubskillForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDeletesubskill(remoteUrl, table, row);
	return false;
});
//-----------------------------------------------------------------
function ajaxCreateSubskill(target, data, id) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				//individual domain need to implement this method
				$.get('/sub_skills', {
					id : id
				}, function(data) {
					$('#table-block_subskill').empty();
					$('#table-block_subskill').html(data);
					configureSubskillTable($('#subskill'));
					$('#update_grade').attr("disabled", true);
					$('#create_grade').attr("disabled", false);
				}).error(function(jqXHR, textStatus, errorThrown) { 
	       				window.location.href = "/signin"
				});
				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}

		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}

function ajaxUpdateSubskill(remoteUrl, data, id) {
	$.ajax({
		url : remoteUrl,
		type : 'put',
		dataType : 'json',
		data : data, // it should have '_method' : 'put'
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				//individual domain need to implement this method
				$.get('/sub_skills', {
					id : id
				}, function(data) {
					$('#table-block_subskill').empty();
					$('#table-block_subskill').html(data);
					configureSubskillTable($('#subskill'));
					$('#update_grade').attr("disabled", true);
					$('#create_grade').attr("disabled", false);
				}).error(function(jqXHR, textStatus, errorThrown) {
					window.location.href = "/signin"
				});

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
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}

		}
	});
	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

function confirmDeletesubskill(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeletesubskill(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeletesubskill(remoteUrl, table, row) {
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
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}