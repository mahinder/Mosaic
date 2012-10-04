$(document).on("ready", function(event){
	$('.batch_tag_list').each(function(){
		$(this).attr('checked', false);
	});
	$('.batchFolder').each(function(){
		$(this).attr('checked', false);
	});
})

$(document).on("click",".batch_tag_list", function(event){
	var data_array = getBatchList();
	getStudentPartialData(data_array)
});

function getStudentPartialData(data_array){
	$.post("/student/student_pdf" , {batch_ids : data_array} , function(data){
		var all_student_count = $("#allStudentCount").val();
		var viewed_count = $(data).find('input#student_list_pdf_val').val();
		var percentage_view = ((viewed_count / all_student_count)*100).toFixed(0)
		$("#prgressID").text(percentage_view+"%");
		$("#prgressID").css({width: percentage_view+"%"});
		$("#studentPDFFileLink").empty();
		$("#studentPDFFileLink").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}


function getBatchList(){
var array_data = []
$('.batch_tag_list').each(function(){
		if($(this).attr("checked") == 'checked'){
			array_data.push($(this).val())
		}else{
			var course_id = (this.id.replace("batch_tag_list",".batchFolder"));
			$(course_id).attr('checked', false);
		}
});
return array_data;
}

$(document).on("click","#studentPdfPageRefresh", function(event){
	event.preventDefault();
	$('.batch_tag_list').each(function(){
		$(this).attr('checked', false);
	});
	$('.batchFolder').each(function(){
		$(this).attr('checked', false);
	});
	var data_array = getBatchList();
	getStudentPartialData(data_array)
	$(".closedAllOpenCourse li").addClass('closed');
});

$(document).on("click","#reloadStudentPDF", function(event){
	window.location.reload();
});


$(document).on("click",".batchFolder", function(event){
   var status = $(this).is(":checked")
   selectAllCoursesBatch(this,status);
   var data_array = getBatchList();
   getStudentPartialData(data_array);
});

function selectAllCoursesBatch(check_box_tag,status){
	var check_box_class = check_box_tag.id.replace("batchFolder",".batch_tag_list");
	$(check_box_class).each(function(){
		if(status == true){
		      $(this).attr('checked', true);
		}else{
			  $(this).attr('checked', false);
		}
});
}



