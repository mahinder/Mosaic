//handler - should call upon succes of ajax call
var updateAssessmentIndicatorTableFunction = function(data) {
	$.get('/assessment_indicators',{object_id : data.sub_skill},function(data) {
		$('#modal #table-block').empty();
		$('#modal #table-block').html(data);
		configureAssessmentIndicatorTable($('#modal #active-table'));
		configureAssessmentIndicatorTable($('#modal #inactive-table'));
		$('.tabs').updateTabs();
		$('#modal #update_assement_indicator').attr("disabled", true);
		$('#modal #create_assement_indicator').attr("disabled", false);
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$(document).on("submit" ,"#assementIndicator-form", function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var indicator_value = $('#modal #assessment_indicator_indicator_value').val();
		var indicator_description = $('#modal #assessment_indicator_indicator_description').val();
		var subSkillID = document.getElementById("co_scholastic_subskill_area_id").value;
		var characterlength = characterLength();
		if(characterlength[0] == false) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(indicator_value.length >= 10) {
				$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 10 character in name', {
					type : 'warning'
				});
			return false;
		}else if(!indicator_value || indicator_value.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter Indicator Value', {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			// Target url
			var target = '/assessment_indicators'
			var status = $("input[name='assessment_indicator\\[is_active\\]']:checked").val();
			// Request
			var data = {
				'assessment_indicator[indicator_value]' : indicator_value,
				'assessment_indicator[indicator_description]' : indicator_description,
				'assessment_indicator[is_active]' : status,
				'assessment_indicator[co_scholastic_sub_skill_area_id]' : subSkillID
			}
			
			ajaxCreateIndicator(target, data, updateAssessmentIndicatorTableFunction, submitBt);
			resetAssementIndicatorMasterForm();
		}
	});
});

$(document).ready(function() {
	$(document).on('click','#update_assement_indicator', function(event) {
		var indicator_value = $('#modal #assessment_indicator_indicator_value').val();
		var indicator_description = $('#modal #assessment_indicator_indicator_description').val();
		var course_list = new Array();
		$('input[type=checkbox]').each(function () {
	           if (this.checked) {
	           	course_list.push(this.value)
	           }
		});
		var characterlength = characterLength();
		if(characterlength[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterlength[1], {
				type : 'warning'
			});
			return false;
		}
		if(indicator_value.length >= 10) {
				$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 10 character in name', {
					type : 'warning'
				});
			return false;
		}else if(!indicator_value || indicator_value.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter Indicator Value', {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='assessment_indicator\\[is_active\\]']:checked").val();
			// Target url
			var target = "/assessment_indicators/" + current_object_id
			// Request
			var data = {
				'assessment_indicator[indicator_value]' : indicator_value,
				'assessment_indicator[indicator_description]' : indicator_description,
				'assessment_indicator[is_active]' : status,
			}
			ajaxUpdateIndicator(target, data, updateAssessmentIndicatorTableFunction, submitBt);
			resetAssementIndicatorMasterForm();
		}
	});
});

$(document).on("click", 'a.delete-assessment-indicator-master-href', function(event) {
	resetAssementIndicatorMasterForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = "/assessment_indicators";
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDeleteIndicator(remoteUrl, table, row);
	return true;
});

$(document).on("click", 'a.update-assessment-indicator-master-href', function(event) {
	resetAssementIndicatorMasterForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var courseId = aLink.attr('courseId')
	var courseList = courseId.split(',');
	$('input[type=checkbox]').each(function () {
	           if (jQuery.inArray(this.value, courseList) != -1) {
	           	this.checked= true;
	           }
		});
	$('#assessment_indicator_indicator_value').val($('#assessment_indicator_indicator_value_' + object_id).html().replace(/&amp;/g, "&"));
	$('#assessment_indicator_indicator_description').val($('#assessment_indicator_indicator_description_' + object_id).html().replace(/&amp;/g, "&"));
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#assessment_indicator_is_active_true').attr('checked', true);
	}else{
		$('#assessment_indicator_is_active_false').attr('checked', true);
	}
    $('#update_assement_indicator').attr("class","");
	$('#update_assement_indicator').attr("disabled", false);
	$('#create_assement_indicator').attr("disabled", true);
	return false;
});


$(document).ready(function() {
	resetAssementIndicatorMasterForm();
	$(document).on('click','#modal #reset_assement_indicator', function(event) {
		resetAssementIndicatorMasterForm();
	});
});

function resetAssementIndicatorMasterForm() {
	$('#modal #assessment_indicator_indicator_value').val("");
	$('#modal #assessment_indicator_indicator_description').val("");
	$('#modal #assessment_indicator_is_active_true').attr('checked', true);
	$('#modal #current_object_id').val("");
	$('#modal #update_assement_indicator').attr("disabled", true);
	$('#create_assement_indicator').attr("disabled", false);
	$('input[name=course-list-assessment]').attr('checked', false);
	$('#modal #outer_block').removeBlockMessages();
}

function ajaxCreateIndicator(target, data, successFunction, submitBt) {
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
function ajaxUpdateIndicator(remoteUrl, data, successFunction, submitBt) {
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
function confirmDeleteIndicator(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteIndicator(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteIndicator(remoteUrl, table, row) {
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

function configureAssessmentIndicatorTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		},{
			sType : 'string'
		},{
			sType : 'string'
		},{
			sType : 'string'
		},{
			sType : 'string'
		}// No sorting for actions column
		],
		"bRetrieve":true,
		"bDestroy"  : true,
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


$('#modal .assessmentIndicatorMaster').each(function(i) {
	configureAssessmentIndicatorTable($(this));
});
