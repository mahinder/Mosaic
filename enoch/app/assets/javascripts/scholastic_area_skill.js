
$(document).on("submit","#coscholasticareaskill-form",function(event){
	event.preventDefault();
	var name = $('#co_scholastic_sub_skill_area_co_scholastic_sub_skill_name').val();
		var scholastic_area=$('#co_scholastic_sub_skill_area_co_scholastic_area_id').val();
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
			var target = '/co_scholastic_sub_skill_areas'

			var status = $("input[name='co_scholastic_sub_skill_area\\[is_active\\]']:checked").val();
			// Request
			var data = {
				'co_scholastic_sub_skill_area[co_scholastic_sub_skill_name]' : name,
				'co_scholastic_sub_skill_area[co_scholastic_area_id]' : scholastic_area,
				'co_scholastic_sub_skill_area[is_active]' : status
			}
              ajaxSkillCreate(target,data,scholastic_area);
              $('#co_scholastic_sub_skill_area_co_scholastic_sub_skill_name').val("");
	$('#co_scholastic_sub_skill_area_is_active_true').attr('checked', true);
	$('#create_co_scholastic_area_skill').attr("disabled", false);
	
		}
});

function ajaxSkillCreate(target, data,scholastic_area) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				var url = "/co_scholastic_sub_skill_areas/view_scholastic_area_subskill?scholastic_area="+scholastic_area
				$.get(url,function(data){
					$("#viewSubSkillOFArea").empty();
					$("#viewSubSkillOFArea").html(data);
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

$(document).on('click','#view-scholastic_area_subskill',function(event){
	event.preventDefault();
	var scholastic_area = $(this).attr('scholastic_area')
	var url = "/co_scholastic_sub_skill_areas/view_scholastic_area_subskill?scholastic_area="+scholastic_area
     
	$.get(url,function(data){
		$.modal({
				content : data,
				title : 'View Co Scholastic Subskill Area',
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




$(document).on("click", "a.delete-area_sub_skill", function(event) {
    resetCoScholasticAreaSkillForm();
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
			$.get("/co_scholastic_sub_skill_areas/destroy/"+object_id, function(data){
		 	    $("#viewSubSkillOFArea").empty();
				$("#viewSubSkillOFArea").html(data);
				configureViewGradingLevelDetailTable($(".view_grading_details"));
				resetCoScholasticAreaSkillForm()
     		}).complete(function(jqXHR, textStatus, errorThrown){
				$('#modal #outer_block').removeBlockMessages().blockMessage("Sub Skill was Deleted Successfully.", {
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

var blockClick = false;
$(document).on("click", "a.add_indicator_value-href", function(event) {
	event.preventDefault();
	var subskill_id = $(this).attr('id');
	var new_id = subskill_id.replace("add-indicator-href-", "#modal #subSkill_name_")
	var modal_box_title  = $(new_id).text();
	if(blockClick != true){
		blockClick = true;
		resetCoScholasticAreaSkillForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var url_prefix = "/assessment_indicators/all_record"
		        $.get(url_prefix,{object_id : object_id},function(data){
		        	$.modal({
						content : data,
						title : "Assessment Indicator for "+modal_box_title,
						width : 800,
						height : 400,
						buttons : {
							'Close' : function(win) {
								win.closeModal();
							}
						}
					});
					configureAssessmentIndicatorTable($("#modal .assessmentIndicatorMaster"));
					resetAssementIndicatorMasterForm()
			    }).complete(function(jqXHR){
				    	blockClick = false;
				});
	}
});

$(document).on("click", "a.update-area_sub_skill-href", function(event) {
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#modal #co_scholastic_sub_skill_area_co_scholastic_sub_skill_name').val($('#subSkill_name_' + object_id).html().replace(/&amp;/g, "&"));
	$('#modal #current_object_id').val(object_id);

	var name = aLink.attr("status");

	if(name == 'true'){
		$('#modal #co_scholastic_sub_skill_area_is_active_true').attr('checked', true);
	}
	else{
		$('#modal #co_scholastic_sub_skill_area_is_active_false').attr('checked', true);
	}
	$('#modal #update_co_scholastic_area_skill').attr("class","");
    $('#modal #create_co_scholastic_area_skill').attr("disabled", true);
	$('#modal #update_co_scholastic_area_skill').attr("disabled", false);
	
	return false;
});

$(document).ready(function() {
	$(document).on('click','#update_co_scholastic_area_skill', function(event) {
		var name = $('#co_scholastic_sub_skill_area_co_scholastic_sub_skill_name').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter co scholastic area Sub Skill', {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#modal #current_object_id').val();
			var status = $("input[name='co_scholastic_sub_skill_area\\[is_active\\]']:checked").val();
			// Target url
			var target = "/co_scholastic_sub_skill_areas/update/" + current_object_id
			// Request
			var data = {
			'co_scholastic_sub_skill_area[co_scholastic_sub_skill_name]' : name,
			'co_scholastic_sub_skill_area[is_active]' : status,
			'_method' : 'put'
			}
			$.get(target,data, function(data){
			 	$("#viewSubSkillOFArea").empty();
				$("#viewSubSkillOFArea").html(data);
				configureViewGradingLevelDetailTable($(".view_grading_details"));
				resetCoScholasticAreaSkillForm()
         		}).complete(function(jqXHR, textStatus, errorThrown){
					$('#modal #outer_block').removeBlockMessages().blockMessage("Sub Skill was updated Successfully", {
						type : 'success'
					});
				});
		}
	});
});

$(document).on("ready" , function() {
	resetCoScholasticAreaSkillForm();
	$(document).on('click',"#reset_co_scholastic_area_skill", function(event) {
		resetCoScholasticAreaSkillForm();
	});
});

function resetCoScholasticAreaSkillForm() {
	$('#modal #co_scholastic_sub_skill_area_co_scholastic_sub_skill_name').val("");
	$('#modal #co_scholastic_sub_skill_area_is_active_true').attr('checked', true);
	$('#modal #current_object_id').val("");
	$('#modal #update_co_scholastic_area_skill').attr("disabled", true);
	$('#modal #create_co_scholastic_area_skill').attr("disabled", false);
	// $('#tab-active').showTab();
	$('#modal #outer_block').removeBlockMessages();
}
