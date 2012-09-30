$("#additional_exam_course").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('update_additional_exam_batch',{'batch_id': str} , function(data) {

		$("#additional_batch_id").empty();
		$("#additional_batch_id").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

$("#additional_exam_group_batch_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('get_additional_exam',{'batch_id': str} , function(data) {

		$("#additional_group_id").empty();
		$("#additional_group_id").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
$("#select_all").on("click", function(event){
	var checked_status = this.checked;

			$("input[type=checkbox]").each(function(){
			this.checked = checked_status;
		});
});



$("#additional_exam").on("submit", function(event){

	event.preventDefault();
	var batch_id = $("#additional_exam_batch").val();
	var stringReg = /^[a-z+\s+A-Z()]*$/ 
	var name = $("#exam_option_name").val();
	var type = $("#exam_option_exam_type").val();
var special_character = specialChar();
	 var length= charactersLength()
	if(!stringReg.test(name)){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Additional Exam Name', {
			type : 'warning'
		});
		return false;
	}
	if(length[0]==false){
		$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
	if(!name || name.length == 0){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter Additional Exam group name', {
			type : 'warning'
		});
		return false;
	}else{
    selectedItems = [];
$('input.right').each(function(){
	if($(this).attr("checked") == 'checked'){
	selectedItems.push($(this).val())
	}
	});
	
 
if (selectedItems.length == 0) {
   $('#outer_bloc').removeBlockMessages().blockMessage('Please select at least one student', {
			type : 'warning'
		});
		return false;
}else{
$('#outer_bloc').removeBlockMessages();
    $.ajax({
	type: "POST",
	url: "/additional_exam/update_exam_form",
	data: {
		"students_list" :selectedItems,
		"batch" :batch_id,
		"exam_option" :{'name' :name,'exam_type' :type}
		},
	success: function (data) {
$("#exam-form").empty();
$("#exam-form").html(data);
	  }
	}
    )}
}
});

$(document).on("click", "#delete_additional_exam", function(event) {
	var exam_id = $(this).attr('exam_id');
	
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				$.ajax({
					url : '/additional_exam/destroy_additional_exam',
					type : 'post',
					dataType : 'json',
					data : {
						'id' : exam_id
					},
					success : function(data) {
						if(data.valid){
							window.parent.window.location.reload();
                $('#outer_bloc').removeBlockMessages().blockMessage('Exam deleted', {
			type : 'warning'
		});
		return false;
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



$(document).on("click", ".start_time", function(event) {
	$('input.start_time').each(function(){
	var startDt= $(this).val();
	});
});


//additional_exam_report
$('#additional_exa_g_report').on('click',function(event){
	
	var additional_course_name = $('#additional_exam_course').val();
	var batch = $('#additional_exam_group_batch_id').val();
	var additional_exam_group = $('#additional_exam_g_group_id').val();
	
	if(!additional_course_name || additional_course_name.length == 0) {
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
	if(!additional_exam_group || additional_exam_group.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select additional exam group', {
			type : 'warning'
		});
		return false;
	}
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