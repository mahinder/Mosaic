// $("#student_assessment_courses_name").live("change", function() {
	// var str = "";
	// str = $(this).val();
	// $.get('/exams/update_batch?course_name=' + str, function(data) {
// 
		// $("#update_batch").empty();
		// $("#update_batch").html(data);
	// }).error(function(jqXHR, textStatus, errorThrown) {
		// window.location.href = "/signin"
	// });
// });
// 
// 
// $('#student_assessment_create').on('click',function(event){
	// var current_user = $('#current_user').val();
// 	
	// var cname = $('#student_assessment_courses_name').val();
	// var batch = $('#exams_batch_id').val();
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
	// }else{
		// if(!batch || batch.length == 0) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
			// type : 'warning'
		// });
		// return false;
	// }
	// }
// });
// 
// $(document).on("click","#studentAssementINdicator", function(event){
// 	
  // event.preventDefault();
  // alert("kkk")
   // var term =$('#assessment_term_master_id').val();
  // if(!term || term.length == 0) {
		// $('#outer_block').removeBlockMessages().blockMessage('Please select Term', {
			// type : 'warning'
		// });
		// return false;
	// } else{
  // var area_student_id = []
  // var area_subskill_id = []
  // var area_id = []
  // var area_indicator_id = []
  // var activity_student_id = []
  // var activity_subskill_id = []
  // var activity_id = []
  // var activity_indicator_id = []
  // var term_master_id = $("#termMaster").val();
  // var batch_id = $("#studenTBatchId").val();
  // alert(batch_id)
  // $(".indicator_area").each(function(event){
  	// var select_tag = $(this).find('select');
	// if(select_tag.val().length != 0){
		// area_subskill_id.push($('option:selected', select_tag).attr('areasubskill'))
		// area_student_id.push($('option:selected', select_tag).attr('student'))
		// area_id.push($('option:selected', select_tag).attr('scholastic_area'))
		// area_indicator_id.push(select_tag.val())
	// }
// 	
	// });
	 // $(".indicator_activity").each(function(event){
  	// var select_tag = $(this).find('select');
	// if(select_tag.val().length != 0){
		// activity_subskill_id.push($('option:selected', select_tag).attr('areasubskill'))
		// activity_student_id.push($('option:selected', select_tag).attr('student'))
		// activity_id.push($('option:selected', select_tag).attr('scholastic_area'))
		// activity_indicator_id.push(select_tag.val())
	// }
// 	
	// });
	// var inputDataArea ={
		// 'students' : area_student_id,
		// 'sub_skill_id' : area_subskill_id,
		// 'indicator' : area_indicator_id
	// }
	// var inputDataActivity ={
		// 'students' : activity_student_id,
		// 'sub_skill_id' : activity_subskill_id,
		// 'indicator' : activity_indicator_id
	// }
	// var inputData ={
		// 'student_assessment[inputDataArea]' : inputDataArea,
		// 'student_assessment[inputDataActivity]' : inputDataActivity,
		// 'term_id' : term_master_id,
		// 'batch_id' : batch_id
	// }
	// var target = "/student_co_scholastic_assessments"
	// ajaxCreateStudentAssessment(target,inputData);
	// }
// });
// 
// function ajaxCreateStudentAssessment(target, inputData){
	// $.ajax({
		// url : target,
		// dataType : 'json',
		// type : 'post',
		// data : inputData,
		// success : function(data, textStatus, jqXHR) {
// 
			// if(data.valid) {
				// $('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					// type : 'success'
				// });
			// } else {
				// // Message
				// var errorText = getErrorText(data.errors);
				// $('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					// type : 'error'
				// });
			// }
		// },
		// error : function(jqXHR, textStatus, errorThrown) {
			// if (jqXHR.status === 403) {
		        // window.location.href = "/signin"
		    // }else{
				// $('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					// type : 'error'
				// });	
			// }	
		// }
	// });
// 
	// // Message
	// $('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		// type : 'loading'
	// });
// };
// 
// $(document).ready(function(event){
		// $(".lll").hide("fast");
// });
// 
  // $(document).on("click",".kkk",function(event){
  		 // $(this).addClass("toggleOpen");
  	  	// $(this).prevAll('tr.toggleOpen').each(function(event){
	  		// $(this).next('tr').slideToggle("fast");
	  		// $(this).removeClass("toggleOpen")
	  		 // $(this).removeClass("highlight");
  		// });
  		// $(this).nextAll('tr.toggleOpen').each(function(event){
	  		// $(this).next('tr').slideToggle("fast");
	  		// $(this).removeClass("toggleOpen")
	  		 // $(this).removeClass("highlight");
		// });
  // $(this).next('tr').slideToggle("fast");
   // $(this).addClass("highlight");
  // });
//  
 // function getDescription(indicator,student){
 	// var select_tag = "#"+indicator.id
 	 // var checkbox=indicator.id.replace('skill_indicator', "#indicator_description");
 		 // $(document).on("change",select_tag, function(event){
		 // $(checkbox).html($('option:selected', this).attr('description'))
	// });
 // }
// 
// $(document).ready(function(event){
	// $(".indicator_area").each(function(event){
		// $(this).find('select').val("");
	// });
	// $(".indicator_activity").each(function(event){
		// $(this).find('select').val("");
	// });
// });
// 
// 
// $(document).ready(function(event){
// alert("hhhhh");
// })