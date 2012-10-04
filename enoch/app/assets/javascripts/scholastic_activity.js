//handler - should call upon succes of ajax call
var updateScholasticActivityTableFunction = function(data) {
	$.get('/co_scholastic_activities', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureScholasticActivity($('#active-table_scholastic_activity'));
		configureScholasticActivity($('#inactive-table_scholastic_activity'));
		$('.tabs').updateTabs();
		$('#update_co_scholastic_activity').attr("disabled", true);
		$('#create_co_scholastic_activity').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#co_scholastic_activity-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#co_scholastic_activity_co_scholastic_activity_name').val();
		var stringReg = /^[a-z+\s+A-Z()]*$/
	    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var course_list = new Array();
		$('input[type=checkbox]').each(function () {
			           if (this.checked) {
			           	course_list.push(this.value)
			           }
		});
		
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter co scholastic activity name', {
				type : 'warning'
			});
			return false;
		}else if(course_list.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select Atleast One Course', {
				type : 'warning'
			});
			return false;
		}  else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/co_scholastic_activities'

			var status = $("input[name='co_scholastic_activity\\[status\\]']:checked").val();
			// Request
			var data = {
				'co_scholastic_activity[co_scholastic_activity_name]' : name,
				'co_scholastic_activity[status]' : status,
				'course_list' : course_list
			}

			ajaxCreate(target, data, updateScholasticActivityTableFunction, submitBt);
			resetScholasticActivityForm();
		}
	});
});

$(document).ready(function() {
	$('#update_co_scholastic_activity').on('click', function(event) {
		var name = $('#co_scholastic_activity_co_scholastic_activity_name').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    var course_list = new Array();
		$('input[type=checkbox]').each(function () {
	           if (this.checked) {
	           	course_list.push(this.value)
	           }
		});
	    if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter co scholastic activity name', {
				type : 'warning'
			});
			return false;
		}else if(course_list.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select Atleast One Course', {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='co_scholastic_activity\\[status\\]']:checked").val();
			// Target url
			var target = "/co_scholastic_activities/" + current_object_id
			// Request
			var data = {
				'co_scholastic_activity[co_scholastic_activity_name]' : name,
				'co_scholastic_activity[status]' : status,
				'course_list' : course_list,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateScholasticActivityTableFunction, submitBt);
			resetScholasticActivityForm();
		}
	});
});

$(document).ready(function() {
	resetScholasticActivityForm();
	$('#reset_co_scholastic_activity').on('click', function(event) {
		resetScholasticActivityForm();
	});
});

$(document).on("click", 'a.delete-scholastic_activity-href', function(event) {
	resetScholasticActivityForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-scholastic_activity-href', function(event) {
	resetScholasticActivityForm();
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
	$('#co_scholastic_activity_co_scholastic_activity_name').val($('#activity_name_' + object_id).html().replace(/&amp;/g, "&"));
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table_scholastic_activity'){
		$('#co_scholastic_activity_status_true').attr('checked', true);
	}
	else{
		$('#co_scholastic_activity_status_false').attr('checked', true);
	}
	$('#update_co_scholastic_activity').attr("class","");
    $('#create_co_scholastic_activity').attr("disabled", true);
	$('#update_co_scholastic_activity').attr("disabled", false);
	
	return false;
});
function resetScholasticActivityForm() {

	$('#co_scholastic_activity_co_scholastic_activity_name').val("");
	$('#co_scholastic_activity_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_co_scholastic_activity').attr("class","");
	$('#create_co_scholastic_activity').attr("disabled", false);
	$('#update_co_scholastic_activity').attr("disabled", true);
	$('input[id=course-list-assessment]').attr('checked', false);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}


$(document).on('click','#add-scholastic_activity_subskill',function(event){
    var activity_id = $(this).attr('scholastic_activity');
	var modal_box_title  = $('#activity_name_'+activity_id).text();
	event.preventDefault();
	if(blockDoubleClick != true){
		blockDoubleClick = true;
		var scholastic_activity = $(this).attr('scholastic_activity')
		var url = "/co_scholastic_sub_skill_activities/add_scholastic_activity_subskill?scholastic_activity="+scholastic_activity
	     
			$.get(url,function(data){
			$.modal({
					content : data,
					title : "Sub Skill for "+modal_box_title,
					width : 800,
					height : 400,
					buttons : {
				    'Close' : function(win) {
					win.closeModal();
				}}
				});
				
				configureViewGradingLevelDetailTable($(".view_grading_details"));
				resetCoScholasticActivitySkillForm();
			}).complete(function(jqXHR){
					    	blockDoubleClick = false;
			});
	}

});


$(document).ready(function(event){
	 // $(".jjj").hide("slow");
 $(".lll").hide("slow");
  $(".student_toggle").on("click",function(event){
  	 $(this).addClass("toggleOpen")
  	// $(this).next('tr.toggleOpen').slideToggle('slow');
  	$(this).prevAll('tr.toggleOpen').each(function(event){
  		
  		$(this).next('tr').slideToggle("slow");
  		 $(this).removeClass("toggleOpen")
  	});
  		$(this).nextAll('tr.toggleOpen').each(function(event){
  		$(this).next('tr').slideToggle("slow");
  		 $(this).removeClass("toggleOpen")
  	});
  $(this).next('tr').slideToggle("slow");
  });
   // $(".lll").on("click",function(event){
   // $(this).next('tr').slideToggle("slow");
  // });

});

function configureScholasticActivity(tableNode) {
	// DataTable config
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		// aoColumns : [{
			// bSortable : false
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }// No sorting for actions column
		// ],
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


$('.scholastic_activity').each(function(i) {
	configureScholasticActivity($(this));
});



//============================================Activity Skill=============================================//



$(document).on("submit","#coscholasticactivityskill-form",function(event){
	event.preventDefault();
	var name = $('#co_scholastic_sub_skill_activity_co_scholastic_sub_skill_name').val();
		var scholastic_activity=$('#co_scholastic_sub_skill_activity_co_scholastic_activity_id').val();
		var stringReg = /^[a-z+\s+A-Z()]*$/
	    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		
		if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Sub Skill Name', {
				type : 'warning'
			});
			return false;
		}  else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/co_scholastic_sub_skill_activities'

			var status = $("input[name='co_scholastic_sub_skill_activity\\[is_active\\]']:checked").val();
			// Request
			var data = {
				'co_scholastic_sub_skill_activity[co_scholastic_sub_skill_name]' : name,
				'co_scholastic_sub_skill_activity[co_scholastic_activity_id]' : scholastic_activity,
				'co_scholastic_sub_skill_activity[is_active]' : status
			}
              ajaxActivitySkillCreate(target,data,scholastic_activity);
              $('#co_scholastic_sub_skill_activity_co_scholastic_sub_skill_name').val("");
	$('#co_scholastic_sub_skill_activity_is_active_true').attr('checked', true);
	$('#create_co_scholastic_activity_skill').attr("disabled", false);
	
		}
});

function ajaxActivitySkillCreate(target, data,scholastic_activity) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				var url = "/co_scholastic_sub_skill_activities/view_scholastic_activity_subskill?scholastic_activity="+scholastic_activity
				$.get(url,function(data){
					$("#viewSubSkillOFActivity").empty();
					$("#viewSubSkillOFActivity").html(data);
					configureViewGradingLevelDetailTable($(".view_grading_details"));
				}).complete(function(jqXHR, textStatus, errorThrown){
						$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
							type : 'success'
						});
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
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
				
			}	
		}
	});
}

$(document).on('click','#view-scholastic_activity_subskill',function(event){
	event.preventDefault();
	var scholastic_activity = $(this).attr('scholastic_activity')
	var url = "/co_scholastic_sub_skill_activities/view_scholastic_activity_subskill?scholastic_activity="+scholastic_activity
     
	$.get(url,function(data){
		$.modal({
				content : data,
				title : 'View Co Scholastic Subskill Activity',
				width : 800,
				height : 300,
				buttons : {
			    'Close' : function(win) {
				win.closeModal();
			}}
			});
			configureViewGradingLevelDetailTable($(".view_grading_details"));
	});
});




$(document).on("click", "a.delete-activity_sub_skill", function(event) {
    resetCoScholasticActivitySkillForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#modal #url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
			$.get("/co_scholastic_sub_skill_activities/destroy/"+object_id, function(data){
		 	    $("#viewSubSkillOFActivity").empty();
				$("#viewSubSkillOFActivity").html(data);
				configureViewGradingLevelDetailTable($(".view_grading_details"));
				resetCoScholasticActivitySkillForm()
     		}).complete(function(jqXHR, textStatus, errorThrown){
				$('#modal #outer_block').removeBlockMessages().blockMessage("Successfully Deleted Sub Skills.", {
					type : 'success'
				});
			}).error (function(jqXHR, textStatus, errorThrown){
		         window.location.href = "/signin"
		    });
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	
	return false;
});

var blockDoubleClick = false;
$(document).on("click", "a.add-activity-indicator-href", function(event) {
	event.preventDefault();
	var subskill_id = $(this).attr('id');
	var new_id = subskill_id.replace("add-activity-indicator-href-", "#modal #subSkill_name_")
	var modal_box_title  = $(new_id).text();
	if(blockDoubleClick != true){
		blockDoubleClick = true;
		resetCoScholasticActivitySkillForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var url_prefix = "/co_scholastic_activity_assessment_indicators/all_record"
		        $.get(url_prefix,{object_id : object_id},function(data){
		        	$.modal({
						content : data,
						title : "Assessment Indicator for " +modal_box_title,
						width : 800,
						height : 400,
						buttons : {
							'Close' : function(win) {
								win.closeModal();
							}
						}
					});
					configureAssessmentIndicatorTable($("#modal .assessmentIndicatorMaster"));
					resetActivityAssementIndicatorMasterForm()
			    }).complete(function(jqXHR){
			    	blockDoubleClick = false;
			    });
	}
	
});

$(document).on("click", "a.update-activity_sub_skill-href", function(event) {
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#modal #co_scholastic_sub_skill_activity_co_scholastic_sub_skill_name').val($('#subSkill_name_' + object_id).html().replace(/&amp;/g, "&"));
	$('#modal #current_object_id').val(object_id);

	var name = aLink.attr("status");

	if(name == 'true'){
		$('#modal #co_scholastic_sub_skill_activity_is_active_true').attr('checked', true);
	}
	else{
		$('#modal #co_scholastic_sub_skill_activity_is_active_false').attr('checked', true);
	}
	$('#modal #update_co_scholastic_activity_skill').attr("class","");
    $('#modal #create_co_scholastic_activity_skill').attr("disabled", true);
	$('#modal #update_co_scholastic_activity_skill').attr("disabled", false);
	
	return false;
});

$(document).ready(function() {
	$(document).on('click','#update_co_scholastic_activity_skill', function(event) {
		var name = $('#co_scholastic_sub_skill_activity_co_scholastic_sub_skill_name').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter co scholastic activity Sub Skill', {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#modal #current_object_id').val();
			var status = $("input[name='co_scholastic_sub_skill_activity\\[is_active\\]']:checked").val();
			// Target url
			var target = "/co_scholastic_sub_skill_activities/update/" + current_object_id
			// Request
			var data = {
			'co_scholastic_sub_skill_activity[co_scholastic_sub_skill_name]' : name,
			'co_scholastic_sub_skill_activity[is_active]' : status
			}
			$.get(target,data, function(data){
			 	$("#viewSubSkillOFActivity").empty();
				$("#viewSubSkillOFActivity").html(data);
				configureViewGradingLevelDetailTable($(".view_grading_details"));
				resetCoScholasticActivitySkillForm()
         		}).complete(function(jqXHR, textStatus, errorThrown){
					$('#modal #outer_block').removeBlockMessages().blockMessage("Sub Skill was updated Successfully", {
						type : 'success'
					});
				});
		}
	});
});

$(document).on("ready" , function() {
	resetCoScholasticActivitySkillForm();
	$(document).on('click',"#reset_co_scholastic_activity_skill", function(event) {
		resetCoScholasticActivitySkillForm();
	});
});

function resetCoScholasticActivitySkillForm() {
	$('#modal #co_scholastic_sub_skill_activity_co_scholastic_sub_skill_name').val("");
	$('#modal #co_scholastic_sub_skill_activity_is_active_true').attr('checked', true);
	$('#modal #current_object_id').val("");
	$('#modal #update_co_scholastic_activity_skill').attr("disabled", true);
	$('#modal #create_co_scholastic_activity_skill').attr("disabled", false);
	// $('#tab-active').showTab();
	$('#modal #outer_block').removeBlockMessages();
}
 