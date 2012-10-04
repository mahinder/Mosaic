$("#courses_name").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('update_batch?course_name=' + str, function(data) {

		$("#update_batch").empty();
		$("#update_batch").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){

                                   window.location.href = "/signin"

                          });
});

$(document).on("click", "#new_exam", function(event) {
	var batch = $("#batch_value").val();
	var exam_option_name = $("#exam_option_assessment_name").val();
	var exam_option_exam_type = $("#exam_option_exam_type").val();
	var exam_option_exam_term = $("#exam_option_term_id").val();
	// var exam_option_exam_mode = $("#exam_option_exam_mode").val();
	
	if (exam_option_name.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please Choose Assessment name', {
			type : 'warning'
		});
		return false;
	}if (exam_option_exam_term.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please Choose Term Master', {
			type : 'warning'
		});
		return false;
	}else{
		// $('#outer_block').removeBlockMessages();
	var url = '/exams/update_exam_form';
	$("#exam-form").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.ajax({
		url : '/exams/update_exam_form',
		dataType : 'html',
		data : {
			'batch' : batch,
			'exam_option[name]' : exam_option_name,
			'exam_option[exam_type]' : exam_option_exam_type,
			'exam_option[term_id]' : exam_option_exam_term
			
		},
		success : function(data) {
			$("#exam-form").empty();
			$("#exam-form").html(data);
				configureExamMarksTable($('.exammarks'));
				configureExamGradesTable($('.examgrades'));
				$("input[id=marks_exam_start_time]").each(function(){
			$(this).datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'dd-mm-yyyy'
});
		});
		$("input[id=marks_exam_end_time]").each(function(){
			$(this).datetime({
	userLang : 'en',
	americanMode : true,
	dateFormat: 'dd-mm-yyyy'
});
		});
		
		}
		
	});
	return false;
	}

});
// edit exam
$(document).on("click", "#edit_exam", function(event) {

	var exam_maximum_marks = $("#exam_maximum_marks").val();
	var exam_minimum_marks = $("#exam_minimum_marks").val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	// if(!exam_maximum_marks || exam_maximum_marks.length == 0 || !numericReg.test(exam_maximum_marks)) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please enter Exam maximum marks in numeric format', {
			// type : 'warning'
		// });
		// return false;
	// }
	// if(!exam_minimum_marks || exam_minimum_marks.length == 0 || !numericReg.test(exam_minimum_marks)) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please enter Exam minimum marks in numeric format', {
			// type : 'warning'
		// });
		// return false;
	// }
	// if(exam_minimum_marks > exam_maximum_marks) {
		// $('#outer_block').removeBlockMessages().blockMessage('Exam minimum marks can`t be greater than Exam maximum Marks', {
			// type : 'warning'
		// });
		// return false;
	// }

});
//confirm exam delete
$(document).on("click", "#delete_exam", function(event) {
	var exam_id = $(this).attr('exam_id');
	
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				$.ajax({
					url : '/exams/destroy_exam',
					type : 'post',
					dataType : 'json',
					data : {
						'id' : exam_id
					},
					success : function(data) {
						if(data.valid){
							window.parent.window.location.reload();
                $('#outer_bloc').removeBlockMessages().blockMessage('Exam deleted succssfully', {
			type : 'success'
		});
		return false;
						}else{
							$('#outer_block').removeBlockMessages().blockMessage(data.errors, {
			type : 'warning'
		});
							
						}
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

//exam wise report

$("#exam_report_batch_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('list_exam_types?batch_id=' + str, function(data) {

		$("#exam-group-select").empty();
		$("#exam-group-select").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){

                                   window.location.href = "/signin"

                          });
});
//subject wise report

$("#subject_batch_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('list_subjects?batch_id=' + str, function(data) {
		$("#select_sub").empty();
		$("#select_sub").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){

                                   window.location.href = "/signin"

                          });
});
$("#grouped_exam_course_name").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('grouped_update_batch?course_name=' + str, function(data) {
		$("#grouped_update_batch").empty();
		$("#grouped_update_batch").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
$("#exam_reports_batch_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('final_report_type?batch_id=' + str, function(data) {
		$("#report_type").empty();
		$("#report_type").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

$("#exams_batch").live("change", function(event) {
	// var str = "";
	// str = $(this).val();
	// $.get('/exam_groups/index1',{'batch_id': str} , function(data) {
// $("#exam_grou_index").empty();
// $("#exam_grou_index").html(data);
// 
// 		
	// });
});

$("#exam_wise_report_course").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('exam_wise_batch_report?course_id=' + str, function(data) {

		$("#exam_wise_report_batch").empty();
		$("#exam_wise_report_batch").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});


$("#exam_report_subject_course_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('subject_wise_batch_report?course_id=' + str, function(data) {

		$("#subject_wise_batch_id").empty();
		$("#subject_wise_batch_id").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
//select deselect check box
$('#exam_group_select_all').on('click',function(event){
	var checked_status = this.checked;

			$("input[type=checkbox]").each(function(){
			this.checked = checked_status;
		});

});
//exam first
$('#exacreate').on('click',function(event){
	var current_user = $('#current_user').val();
	var cname = $('#courses_name').val();
	var batch = $('#exams_batch_id').val();
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
	}}
	else{
		if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		return false;
	}
	}
});
//additionalexam
$('#aex').on('click',function(event){
	var current_user = $('#current_user').val();
	var cname = $('#courses_name').val();
	var batch = $('#name_id').val();
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
	}
	else{
		if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		return false;
	}
	}
});
//examwisereport
$('#ewr').on('click',function(event){
	var current_user = $('#current_user').val();
	var cname = $('#exam_wise_report_course').val();
	var batch = $('#exam_report_batch_id').val();
	var egroup = $('#exam_report_exam_group_id').val();
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
	if(!egroup || egroup.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select exam group', {
			type : 'warning'
		});
		return false;
	}
	}else{
		if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		return false;
	}
	if(!egroup || egroup.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select exam group', {
			type : 'warning'
		});
		return false;
	}
	}
});
//subjectwise report
$('#swr').on('click',function(event){
	var current_user = $('#current_user').val();
	var cname = $('#exam_report_subject_course_id').val();
	var batch = $('#subject_batch_id').val();
	var egroup = $('#exam_report_subject_id').val();
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
	if(!egroup || egroup.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select subject', {
			type : 'warning'
		});
		return false;
	}
	}else{
		if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		return false;
	}
	if(!egroup || egroup.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select subject', {
			type : 'warning'
		});
		return false;
	}
		
	}

});
//grouped exam report
$('#gereport').on('click',function(event){
	var current_user = $('#current_user').val();
	var cname = $('#grouped_exam_course_name').val();
	var batch = $('#exam_reports_batch_id').val();
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
	}else{
		if(!batch || batch.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			type : 'warning'
		});
		return false;
	}
	}
	
});

$(document).ready(function() {
	// configureExamSubjectWiseTable($('#ExSubjectRe'))
});
//connected exam report
$("#exam_reports_batch_id").live("change", function() {
	var batch_id = "";
	batch_id = $(this).val();
	$("#ce").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get('connect_exam_report?batch_id=' + batch_id, function(data) {

		$("#ce").empty();
		$("#ce").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

//connect save
$(document).on("click","#connect_save", function(event) {
	var stringReg = /^[a-z+\s+A-Z()]*$/ 
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var assessment_mode=$("#assessment_filter").val();
	var g_name = $("#exam_grouping_grouped_exam_name").val();
	var grading_group=$("#exam_grouping_grading_level_group_id").val();
	var weightage= ""
	// var special_character = specialChar();
// 	
	// if (special_character[0]==false){
		// $('#outer_bloc').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
			// type : 'warning'
		// });
		// return false;
// 		
	// }
		
	if(!g_name || g_name.length == 0){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter Grouped exam name ', {
			type : 'warning'
		});
			return false;
	}
	if(!grading_group || grading_group.length == 0){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please choose grading level group ', {
			type : 'warning'
		});
			return false;
	}
   if(assessment_mode=="weightage")	{
	    $("input[type=checkbox]:checked").each(function(){
			weightage = $('#weightage_'+ $(this).val()).val();
			if(weightage != "" && !numericReg.test(weightage)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter weightage in numeric format', {
				type : 'warning'
			});
			event.preventDefault();
			return false;
		}if(!weightage || weightage.length == 0){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter weightage for checked exam ', {
			type : 'warning'
		});
		event.preventDefault();
			return false;
	}
	
		});
	$("input[type=checkbox]:not(:checked)").each(function(){
		$('#weightage_'+ $(this).val()).val("");
	});
	}
});


$("input[type=checkbox]").click(function() {
 	
   if ($(this).attr("checked") == null){
 
   	 $('#weightage_'+ $(this).val()).val("");
   	
   }
});


$("#compare_marks").on("click", function(event) {
	var flag =0
	$("input[type=checkbox]").each(function(event){
		if($(this).attr('checked')=='checked'){
			flag +=1
		}
	});
	if (flag ==0){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please select batch to compare ', {
			type : 'warning'
		});
			return false;
	}

});

//delete grouped exam

$(document).on("click","#delete_grouped_exam", function(event) {
	var batch_id = $(this).attr('batch_id')
	var grouped_exam_id = $(this).attr('grouped_exam_id')
	var remoteUrl ="destroy_grouped_exam"
	
		$.modal({
				content : '<h3>Are you sure?</h3><br/><br/><p>Do You want to delete this grouped exam record...</p>',
				title : 'Delete Grouped Exam',
				width : 500,
				buttons : {	
					'Ok' : function (win) {
						
									$.ajax({
									url : remoteUrl,
									type : 'post',
									dataType : 'json',
									data : {
										'id' : grouped_exam_id
									},
									success : function(data) {
										if(data.valid==true){
											$.get('delete_view_grouping?id='+batch_id,function(data){
												$('#outer_bloc').removeBlockMessages().blockMessage('Grouped Exam deleted successfully ', {
			type : 'success'
		});
												$('#view_group').empty();
												$('#view_group').html(data);
											}).error (function(jqXHR, textStatus, errorThrown){
										         window.location.href = "/signin"
										    });
										}
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


function specialChar() {
	var character_array=new Array();
	var special_character = null;
	var iChars = "!$%^&*()+=[];{}:<>?";
	$(".full-width").each(function() {
		for(var i = 0; i < $(this).val().length; i++) {
			if(iChars.indexOf($(this).val().charAt(i)) != -1) {
			special_character = false;
				field_name=$(this).attr('field_name')
			    character_array.push(special_character , field_name)
			}
		}
		
	});
	return character_array;;
}
////demo

$(document).on("click","#assessment_mode_weightage",function(event){
		$("#connect_assess").empty();
		$("#marks_and_mg").empty();
		var assessment_mode=$(this).val();
		var url="/exams/grouping_assessment_mode?assessment_mode="+assessment_mode
		$.get(url,function(data){
			$("#marks_and_mg").empty();
			$("#marks_and_mg").html(data);
		});
		
});
$(document).on("click","#assessment_mode_no_weightage",function(event){
		$("#connect_assess").empty();
		$("#marks_and_mg").empty();
		var assessment_mode=$(this).val();
		var url="/exams/grouping_assessment_mode?assessment_mode="+assessment_mode
		$.get(url,function(data){
			$("#marks_and_mg").empty();
			$("#marks_and_mg").html(data);
		});
});

$(document).on("click","#assessment_filter_Marks",function(event){
	    var filter=$(this).val();
		var batch=$("#batch_id").val();
		var assessment_mode=$("#assessment_filter").val();
	    var url="/exams/grouping"
	    var data={
	    	'id' : batch,
	    	'assessment_mode' : assessment_mode,
	    	'filter' : filter
	    }
		$.get(url,data,function(data){
			$("#connect_assess").empty();
			$("#connect_assess").html(data);
			configureExamGroupingTable($('.examgrouping'));
		});
});


$(document).on("click","#assessment_filter_Grades",function(event){
	    var filter=$(this).val();
		var batch=$("#batch_id").val();
		var assessment_mode=$("#assessment_filter").val();
	    var url="/exams/grouping"
	    var data={
	    	'id' : batch,
	    	'assessment_mode' : assessment_mode,
	    	'filter' : filter
	    }
		$.get(url,data,function(data){
			$("#connect_assess").empty();
			$("#connect_assess").html(data);
			configureExamGroupingTable($('.examgrouping'));
		});
});




$(document).on("click","#assessment_filter_MarksAndGrades",function(event){
	
	    var filter=$(this).val();
		var batch=$("#batch_id").val();
		var assessment_mode=$("#assessment_filter").val();
	    var url="/exams/grouping"
	    var data={
	    	'id' : batch,
	    	'assessment_mode' : assessment_mode,
	    	'filter' : filter
	    }
		$.get(url,data,function(data){
			$("#connect_assess").empty();
			$("#connect_assess").html(data);
			configureExamGroupingTable($('.examgrouping'));
		});
});