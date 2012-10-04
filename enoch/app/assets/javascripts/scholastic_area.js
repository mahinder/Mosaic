//handler - should call upon succes of ajax call
var updateScholasticAreaTableFunction = function(data) {
	$.get('/co_scholastic_areas', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureScholasticArea($('#active-table_scholastic_area'));
		configureScholasticArea($('#inactive-table_scholastic_area'));
		$('.tabs').updateTabs();
		$('#update_co_scholastic_area').attr("disabled", true);
		$('#create_co_scholastic_area').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#co_scholastic_area-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#co_scholastic_area_co_scholastic_area_name').val();
		var stringReg = /^[a-z+\s+A-Z()]*$/
	    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var course_list = new Array();
		$('input[type=checkbox]').each(function () {
			           if (this.checked) {
			           	course_list.push(this.value)
			           }
		});
		
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter co scholastic area name', {
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
			var target = '/co_scholastic_areas'

			var status = $("input[name='co_scholastic_area\\[status\\]']:checked").val();
			// Request
			var data = {
				'co_scholastic_area[co_scholastic_area_name]' : name,
				'co_scholastic_area[status]' : status,
				'course_list' : course_list
			}

			ajaxCreate(target, data, updateScholasticAreaTableFunction, submitBt);
			resetScholasticAreaForm();
		}
	});
});

$(document).ready(function() {
	$('#update_co_scholastic_area').on('click', function(event) {
		var name = $('#co_scholastic_area_co_scholastic_area_name').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    var course_list = new Array();
		$('input[type=checkbox]').each(function () {
	           if (this.checked) {
	           	course_list.push(this.value)
	           }
		});
	    if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter co scholastic area name', {
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
			var status = $("input[name='co_scholastic_area\\[status\\]']:checked").val();
			// Target url
			var target = "/co_scholastic_areas/" + current_object_id
			// Request
			var data = {
				'co_scholastic_area[co_scholastic_area_name]' : name,
				'co_scholastic_area[status]' : status,
				'course_list' : course_list,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateScholasticAreaTableFunction, submitBt);
			resetScholasticAreaForm();
		}
	});
});

$(document).ready(function() {
	resetScholasticAreaForm();
	$('#reset_co_scholastic_area').on('click', function(event) {
		resetScholasticAreaForm();
	});
});

$(document).on("click", 'a.delete-scholastic_area-href', function(event) {
	resetScholasticAreaForm();
	$('html, body').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-scholastic_area-href', function(event) {
	resetScholasticAreaForm();
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
	$('#co_scholastic_area_co_scholastic_area_name').val($('#area_name_' + object_id).html().replace(/&amp;/g, "&"));
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table_scholastic_area'){
		$('#co_scholastic_area_status_true').attr('checked', true);
	}
	else{
		$('#co_scholastic_area_status_false').attr('checked', true);
	}
	$('#update_co_scholastic_area').attr("class","");
    $('#create_co_scholastic_area').attr("disabled", true);
	$('#update_co_scholastic_area').attr("disabled", false);
	
	return false;
});
function resetScholasticAreaForm() {

	$('#co_scholastic_area_co_scholastic_area_name').val("");
	$('#co_scholastic_area_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_co_scholastic_area').attr("class","");
	$('#create_co_scholastic_area').attr("disabled", false);
	$('#update_co_scholastic_area').attr("disabled", true);
	$('input[id=course-list-assessment]').attr('checked', false);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}


$(document).on('click','#add-scholastic_area_subskill',function(event){
	var area_id = $(this).attr('scholastic_area');
	var modal_box_title  = $('#area_name_'+area_id).text();
	event.preventDefault();
	if(blockDoubleClick != true){
		blockDoubleClick = true;
		var scholastic_area = $(this).attr('scholastic_area')
		var url = "/co_scholastic_sub_skill_areas/add_scholastic_area_subskill?scholastic_area="+scholastic_area
	     
		$.get(url,function(data){
			$.modal({
					content : data,
					title : "Sub Skill for " +modal_box_title,
					width : 800,
					height : 400,
					buttons : {
				    'Close' : function(win) {
					win.closeModal();
				}}
				});
				
				configureViewGradingLevelDetailTable($(".view_grading_details"));
				resetCoScholasticAreaSkillForm();
		}).complete(function(jqXHR){
				    	blockDoubleClick = false;
		});
	}

});

function getStudentId(student){

	var id=student.id;
	$("#coll_"+id).slideToggle("slow");
	
}



