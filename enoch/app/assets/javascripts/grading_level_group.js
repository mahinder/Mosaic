//handler - should call upon succes of ajax call
var updateGradingLevelGroupTable = function(data) {
	
	$.get('/grading_level_groups', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureGradingLevelGroupTable($('#active-table'));
		configureGradingLevelGroupTable($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_grading_level_group').attr("disabled", true);
		$('#create_grading_level_group').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#grading-level-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var numericity_check = numericTest();
		 var length= charactersLength()
		// Check fields
		var name = $('#grading_level_group_grading_level_group_name').val();
		var status = "";
		var stringReg = /^[a-z+\s+A-Z()]*$/
		if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	} 
		// if(!stringReg.test(name)) {
			// $('#outer_block').removeBlockMessages().blockMessage('Please enter characters for name', {
				// type : 'warning'
			// });
			// return false;
		// }
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Grading Level Group Name', {
				type : 'warning'
			});
		}  else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/grading_level_groups'

			
			var state = $("input[name='grading_level_group\\[is_active\\]']:checked").val();
			if (state == 1){
				status = state
			}else{
				status = $("input[name='grading_level_group\\[is_active\\]']").val();
			}
			// Requ@elective_skillsest
			var data = {
				'grading_level_group[grading_level_group_name]' : name,
				'grading_level_group[is_active]' : status
			}
$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			
			if(data.status =='created') {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				$.get('/grading_level_groups', function(data) {
					
		$('#table-block').empty();
		$('#table-block').html(data);
		configureGradingLevelGroupTable($('#active-table'));
		configureGradingLevelGroupTable($('#inactive-table'));
		$('.tabs').updateTabs();
		// $('#update_grading_level_group').attr("disabled", false);
		// $('#create_grading_level_group').attr("disabled", true);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
			}
			
		}
});
			resetGradingLevelGroupForm();

		}
	});
});

$(document).ready(function() {
	$('#update_grading_level_group').on('click', function(event) {
			var status = ""
			var name = $('#grading_level_group_grading_level_group_name').val();
		    var length= charactersLength()
		    if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Grading Level Group Name', {
				type : 'warning'
			});
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			
			var state = $("input[name='grading_level_group\\[is_active\\]']:checked").val();
			if (state == 1){
				status = state
			}else{
				status = $("input[name='grading_level_group\\[is_active\\]']").val();
			}
			
			// Target url
			var target = "/grading_level_groups/" + current_object_id
			// Request
			var data = {
				'grading_level_group[grading_level_group_name]' : name,
				'grading_level_group[is_active]' : status
			}
			ajaxUpdate(target, data, updateGradingLevelGroupTable, submitBt);
			resetGradingLevelGroupForm();
		}
	});
});

$(document).ready(function() {
	 resetGradingLevelGroupForm();
	$('#reset_grading_level_group').on('click', function(event) {
		resetGradingLevelGroupForm();
	});
});

function resetGradingLevelGroupForm() {
	
	$('#grading_level_group_grading_level_group_name').val("");
	
	$('#grading_level_group_is_active').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_grading_level_group').attr("disabled", true);
		$('#create_grading_level_group').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
}


$(document).on("click", "a.update-grading_level_group-href", function(event) {
	resetGradingLevelGroupForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#grading_level_group_grading_level_group_name').val($('#grading_level_group_name_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table')
		$('#grading_level_group_is_active').attr('checked', true);
	else
		$('#grading_level_group_is_active').attr('checked', false);
 $('#update_grading_level_group').attr("class","");
	$('#update_grading_level_group').attr("disabled", false);
	$('#create_grading_level_group').attr("disabled", true);
	return false;
});

$(document).on("click", "a.delete-grading_level_group-href", function(event) {
	resetGradingLevelGroupForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});
blockDoubleClick=false
$("input[name='grading_level_group\\[is_active\\]']:checked").val()
$(document).on("click", "#add-grading-level-details-href", function(event) {
	event.preventDefault();
	if(blockDoubleClick != true){
	blockDoubleClick = true;
	var grading_level_group = $(this).attr('grade-level-group')
	var grading_level_group_name=$("#grading_level_group_name_"+grading_level_group).text();
	var url = '/grading_level_details/add_grading_detail?grading_level_group='+grading_level_group
	$.get(url,function(data){
		$.modal({
				content : data,
				title : grading_level_group_name,
				width : 800,
				height : 350,
				buttons:  {
					 "<button id='saveChangeButtonId'>Save</button>" : function(win) {
							if ($(this).attr("id")=="saveChangeButtonId"){
										var g_name = $("#modal #grading_level_name").val();
										var g_min_score = $("#modal #grading_level_min_score").val();
										var g_group_id = $("#grading_level_group_id").val();
										$.get("/grading_level_details/create_grade",{'grading_level': {
											'grading_level_group_id': g_group_id,
											'grading_level_detail_name': g_name,
											'min_score': g_min_score
										}}, function(data) {
											if (data.valid) {
											$("#viewGradePartial").empty();
											$("#viewGradePartial").html(data.html);
											 configureViewGradingLevelDetailTable($(".view_grading_details"))
											$('#modal #outer_block').removeBlockMessages().blockMessage('Grading Level detail was created successfully', {
												type : 'success'
											});
											$("#modal #grading_level_name").val("");
											$("#modal #grading_level_min_score").val("");
											}else{
												var errorText = getErrorText(data.errors);
									 				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText, {
															type : 'error'
													});
											}
										}).error (function(jqXHR, textStatus, errorThrown){
									         window.location.href = "/signin"
									    })
							}
							else{
								var object_id = $(this).attr("object_id");
								var name = $("#modal #grading_level_name").val();
								var score = $("#modal #grading_level_min_score").val();
								var data = {
										'grading_level_detail_name' : name,
										'min_score' : score
									}
									if(!name || name.length==0){
										$('#modal #outer_block').removeBlockMessages().blockMessage("Grading Level Detail name can not be blank", {
												type : 'warning'
											});
											return false;
									}else if(!score || score.length==0){
										$('#modal #outer_block').removeBlockMessages().blockMessage("Grading Level Detail marks can not be blank", {
												type : 'warning'
											});
											return false;
									}
									else{
									$.getJSON("/grading_level_details/update/"+object_id,{grading_level_detail: data, id: object_id }, function(data){									 	
									 			if (data.valid) {
									 			$('#viewGradePartial').empty();
												 	$('#viewGradePartial').html(data.html);
												 	$('#modal #outer_block').removeBlockMessages().blockMessage("Successfully updated Grading Level Details", {
															type : 'success'
													});
													configureViewGradingLevelDetailTable($(".view_grading_details"))
												    $("#modal #grading_level_name").val("");
													$("#modal #grading_level_min_score").val("");
													$("#updateChangeButtonId").text("Save");
										            $("#updateChangeButtonId").attr("id","saveChangeButtonId");
									 			} else{
									 				var errorText = getErrorText(data.errors);
									 				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText, {
															type : 'error'
													});
									 			}
									 			
											}).error (function(jqXHR, textStatus, errorThrown){
									         window.location.href = "/signin"
									    })
							    		
								} //else end
							 } // inner button end
                       }, 
                        'Close' : function (win) {
							   win.closeModal();
							 }}// butoonend
});
	jQuery('#modal button:nth-child(1)').hide();
	configureViewGradingLevelDetailTable($(".view_grading_details"))
}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
}).complete ( function(jqXHR){
    blockDoubleClick = false;
});
}
});
//view grading level details

$(document).on("click", "#view_grading_level_details", function(event) {

	event.preventDefault();
	var grading_level_group = $(this).attr('grade-level-group')
	var url = '/grading_level_details/view_grading_detail?grading_level_group='+grading_level_group
	$.get(url,function(data){
		
		$.modal({
				content : data,
				title : 'View Grading Detail',
				width : 700,
				height : 300,
				buttons : {		
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});

}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

$(document).on("click", "a.delete-grading_detail", function(event) {

	var aLink = $(this);
	var object_id= $(this).attr('id');
	var url_prefix = "/grading_level_details/destroy"
	var remoteUrl = url_prefix + "/" + object_id;
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
					$.get("/grading_level_details/destroy/"+object_id, function(data){
		 	$('#view_details').empty();
		 	$('#view_details').html(data);
		 	$('#modal #outer_block').removeBlockMessages().blockMessage("Successfully Deleted Grading Level Details", {
					type : 'success'
				});
					  configureViewGradingLevelDetailTable($(".view_grading_details"))
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
$(document).on("click", "a.update-grading_detail-href", function(event) {

	var aLink = $(this);
	var object_id= $(this).attr('id');
	var level_name=$("#modal #grading_level_name_"+object_id).text();
	var level_score=$("#modal #grading_level_min_score_"+object_id).text();
	$("#modal #grading_level_name").val(level_name);
	$("#modal #grading_level_min_score").val(level_score);
		$("#saveChangeButtonId").text("Update");
		$("#saveChangeButtonId").attr("id","updateChangeButtonId");
		$("#updateChangeButtonId").attr("object_id",object_id);
});



