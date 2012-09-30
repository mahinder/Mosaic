$("#student_assessment_courses_name").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('/student_co_scholastic_assessments/update_batch?course_name=' + str, function(data) {

		$("#update_batch").empty();
		$("#update_batch").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});

// $(document).on('click','#student_assessment_create',function(event){
// 	
	// var current_user = $('#current_user').val();
	// var cname = $('#student_assessment_courses_name').val();
	// var batch = $('#co_scholastic_assessment_batch_id').val();
	// if(current_user == 'Admin'){
	// if(!cname || cname.length == 0) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please select course', {
			// type : 'warning'
		// });
		// return false;
	// }
	// if(!batch || batch.length == 0) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			// type : 'warning'
		// });
		// return false;
	// }}else{
		// if(!batch || batch.length == 0) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			// type : 'warning'
		// });
		 // return false;
	// }
	// }
// });
$(document).on('click','#student_assessment_create',function(event){
	
	var current_user = $('#current_user').val();
	var cname = $('#student_assessment_courses_name').val();
	var batch = $('#co_scholastic_assessment_batch_id').val();
	var term = $('#assessment_term_master_id').val();
	if(current_user == 'Admin'){
	if(!cname || cname.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select course', {
			type : 'warning'
		});
		return false;
	}
	if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		return false;
	}
	if(!term || term.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select Term', {
			type : 'warning'
		});
		return false;
	}}else{
		if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		 return false;
	}if(!term || term.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select Term', {
			type : 'warning'
		});
		return false;
	}
	}
});


$(document).on("click","#studentAssementINdicator", function(event){
	
  event.preventDefault();
  
   var term_master_id =$('#assessment_term_master_id').val();
    var name =$('#student_co_scholastic_assessment_name').val();
   
   if(!name || name.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select Assessment name', {
			type : 'warning'
		});
		return false;
	}
   
  if(!term_master_id || term_master_id.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select Term', {
			type : 'warning'
		});
		return false;
	} else{
  var area_student_id = []
  var area_subskill_id = []
  var area_id = []
  var area_indicator_id = []
  var activity_student_id = []
  var activity_subskill_id = []
  var activity_id = []
  var activity_indicator_id = []
  var batch_id = $("#studenTBatchId").val();
   $(".indicator_area").each(function(event){
  	var select_tag = $(this).find('select');
	if(select_tag.val().length != 0){
		area_subskill_id.push($('option:selected', select_tag).attr('areasubskill'))
		area_student_id.push($('option:selected', select_tag).attr('student'))
		area_id.push($('option:selected', select_tag).attr('scholastic_area'))
		area_indicator_id.push(select_tag.val())
	}
	
	});
	 $(".indicator_activity").each(function(event){
  	var select_tag = $(this).find('select');
	if(select_tag.val().length != 0){
		activity_subskill_id.push($('option:selected', select_tag).attr('areasubskill'))
		activity_student_id.push($('option:selected', select_tag).attr('student'))
		activity_id.push($('option:selected', select_tag).attr('scholastic_area'))
		activity_indicator_id.push(select_tag.val())
	}
	
	});
	var inputDataArea ={
		'students' : area_student_id,
		'sub_skill_id' : area_subskill_id,
		'indicator' : area_indicator_id
	}
	var inputDataActivity ={
		'students' : activity_student_id,
		'sub_skill_id' : activity_subskill_id,
		'indicator' : activity_indicator_id
	}
	var inputData ={
		'student_assessment[inputDataArea]' : inputDataArea,
		'student_assessment[inputDataActivity]' : inputDataActivity,
		'term_id' : term_master_id,
		'batch_id' : batch_id,
		'name' : name
	}
	var target = "/student_co_scholastic_assessments"
	ajaxCreateStudentAssessment(target,inputData);
	}
});

function ajaxCreateStudentAssessment(target, inputData){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : inputData,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
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
			}	
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}


	$(".skill_row").hide("fast");


  $(document).on("click",".student_row",function(event){
  
  	if ($(this).hasClass("toggleOpen")){
  		$(this).removeClass("toggleOpen");
  		$(this).removeClass("highlight");
  		$(this).next('tr').slideToggle("fast");
  	}else{
  		 $(this).addClass("toggleOpen");
  		 $(this).prevAll('tr.toggleOpen').each(function(event){
	  		$(this).next('tr').slideToggle("fast");
	  		$(this).removeClass("toggleOpen")
	  		$(this).removeClass("highlight");
  		});
  		$(this).nextAll('tr.toggleOpen').each(function(event){
	  		$(this).next('tr').slideToggle("fast");
	  		$(this).removeClass("toggleOpen")
	  		$(this).removeClass("highlight");
		});
	    $(this).next('tr').slideToggle("fast");
	    $(this).addClass("highlight");
  	}
  	  	
  });
 
 function getDescription(indicator,student){
 	var select_tag = "#"+indicator.id
 	 var checkbox=indicator.id.replace('skill_indicator', "#indicator_description");
 		 $(document).on("change",select_tag, function(event){
		 $(checkbox).html($('option:selected', this).attr('description'))
	});
 }

$(document).ready(function(event){
	$(".indicator_area").each(function(event){
		$(this).find('select').val("");
	});
	$(".indicator_activity").each(function(event){
		$(this).find('select').val("");
	});
});

//update assessment
$(document).on("click","#updateStudentAssementINdicator", function(event){
	
  event.preventDefault();
  
   var term_master_id =$('#assessment_term_master_id').val();
    var name =$('#student_co_scholastic_assessment_name').val();
    var student_co_scholastic_assessment=$('#student_co_scholastic_assessment').val();
   
   if(!name || name.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select Assessment name', {
			type : 'warning'
		});
		return false;
	}
   
  if(!term_master_id || term_master_id.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select Term', {
			type : 'warning'
		});
		return false;
	} else{
  var area_student_id = []
  var area_subskill_id = []
  var area_id = []
  var area_indicator_id = []
  var activity_student_id = []
  var activity_subskill_id = []
  var activity_id = []
  var activity_indicator_id = []
  var batch_id = $("#studenTBatchId").val();
   $(".indicator_area").each(function(event){
  	var select_tag = $(this).find('select');
	if(select_tag.val().length != 0){
		area_subskill_id.push($('option:selected', select_tag).attr('areasubskill'))
		area_student_id.push($('option:selected', select_tag).attr('student'))
		area_id.push($('option:selected', select_tag).attr('scholastic_area'))
		area_indicator_id.push(select_tag.val())
	}
	
	});
	 $(".indicator_activity").each(function(event){
  	var select_tag = $(this).find('select');
	if(select_tag.val().length != 0){
		activity_subskill_id.push($('option:selected', select_tag).attr('areasubskill'))
		activity_student_id.push($('option:selected', select_tag).attr('student'))
		activity_id.push($('option:selected', select_tag).attr('scholastic_area'))
		activity_indicator_id.push(select_tag.val())
	}
	
	});
	var inputDataArea ={
		'students' : area_student_id,
		'sub_skill_id' : area_subskill_id,
		'indicator' : area_indicator_id
	}
	var inputDataActivity ={
		'students' : activity_student_id,
		'sub_skill_id' : activity_subskill_id,
		'indicator' : activity_indicator_id
	}
	var inputData ={
		'student_assessment[inputDataArea]' : inputDataArea,
		'student_assessment[inputDataActivity]' : inputDataActivity,
		'term_id' : term_master_id,
		'batch_id' : batch_id,
		'name' : name,
		'id' : student_co_scholastic_assessment
	}
	var target = "/student_co_scholastic_assessments/"+student_co_scholastic_assessment
	ajaxUpdateStudentAssessment(target,inputData);
	}
});

function ajaxUpdateStudentAssessment(remoteUrl, data) {
	$.ajax({
		url : remoteUrl,
		type : 'put',
		dataType : 'json',
		data : data, // it should have '_method' : 'put'
		success : function(data) {
			
			if(data.valid) {
				//individual domain need to implement this method
				
				//populateTables();
				
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
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





$(document).on("click","#delete_student_co_scholastic_assessment",function(event){
	var id=$(this).attr("student_co_scholastic_assessment")
	var target="/student_co_scholastic_assessments/"+id
	
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a Guardian...</p>',
		title : 'Delete Guardian?',
		maxWidth : 500,
		buttons : {
			'Ok' : function(win) {
					$.ajax({
					url : target,
					dataType : 'html',
					type : 'DELETE',		
					success : function(data) {
						$("#updated_new").empty();
						$("#updated_new").html(data);
						configureExamGroupIndexTable($(".examgindex"));
						$('#outer_bloc').removeBlockMessages().blockMessage("Student Co Scholastic Assessment Deleted Successfuly", {
						type : 'success'
						});
					}
				});
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
});
