$(document).on("blur", "#additional_exam_group_maximum_marks", function(event) {
	var additional_exam_group_maximum_marks = $('#additional_exam_group_maximum_marks').val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	if(!numericReg.test(additional_exam_group_maximum_marks)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter additional Exam Group maximum marks in numeric format', {
				type : 'warning'
			});
			$('#additional_exam_group_minimum_marks').attr("disabled",true); 
			return false;
		}
		else{
			$('#outer_block').removeBlockMessages();
			$('.maximum').val(additional_exam_group_maximum_marks);
			$('#additional_exam_group_minimum_marks').attr("disabled",false);
		}
	
	});
	
	
$(document).on("blur", "#additional_exam_group_minimum_marks", function(event) {
	var additional_exam_group_minimum_marks = $('#additional_exam_group_minimum_marks').val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	if(!numericReg.test(additional_exam_group_minimum_marks)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter additional Exam Group minimum marks in numeric format and less than maximum marks', {
				type : 'warning'
			});
			return false;
		}
		else{
			$('#outer_block').removeBlockMessages();
			$('.minimum').val(additional_exam_group_minimum_marks);
			
		}
	
	});
	


$(document).on("click","#additional_exam_group_destroy", function(event){
	event.preventDefault();
	var batch_id = $(this).attr('batch_id');
	var additional_exam_group =  $(this).attr('additional_exam_group_id');
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				$.ajax({
		url : '/additional_exam_groups/delete_additional_exam_group',
		type : 'post',
		dataType : 'json',
		data : {
			'id' : additional_exam_group,
			'batch_id' :batch_id
			},
		success : function(data) {
			if(data.valid == true){
							window.parent.window.location.reload();
                $('#outer_bloc').removeBlockMessages().blockMessage('additional Exam group deleted', {
					type : 'warning'
				});
				return false;
						}
		},
		error : function(jqXHR, textStatus, errorThrown){
            if(jqXHR.status === 403){
                 window.location.href = "/signin"
            }else{
                 $("#outer_bloc").removeblockMessages().blockMessage("Error while contacting server, please try again" , {
                     type :  'error'
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

$(document).on("click", "#create_additional_exam", function(event) {
	// event.preventDefault();
	var startTime=[];
	var endTime=[];
	var exam_group_name = $('#additional_exam_group_name').val();
	var exam_group_maximum_marks = $('#additional_exam_group_maximum_marks').val();
	var exam_group_minimum_marks = $('#additional_exam_group_minimum_marks').val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var special_character = specialChar();
	 var length= charactersLength()
	var stringReg = /^[a-z+\s+A-Z()]*$/
	
	if(!stringReg.test(exam_group_name)){
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Additional Exam Group Name', {
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
	if(!exam_group_name || exam_group_name.length == 0) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter Additional Exam Group Name', {
				type : 'warning'
			});
			return false;
		}else{
			$('input.start_time').each(function(){
	var startDt = $(this).val().split(' ');
	       startTime.push(startDt[0]);
		});
	}
	
	//gg
	$(".bolean").each(function(index){
    if (!$(this).attr('checked')){
    	var ind= index+1;
	var maximum_marks = parseInt($('#max'+ind).val());
	var minimum_marks=parseInt($('#min'+ind).val());
	if (minimum_marks>maximum_marks || minimum_marks==maximum_marks){
	$('#outer_bloc').removeBlockMessages().blockMessage('Minimum marks can not be greater than the maximum marks', {
				type : 'warning'
			});
			event.preventDefault();	
	}
}
});
	//hh
	
	
		
});

// $(document).on("click", "#edit_additional_exam", function(event) {
// 	
	// var exam_group_maximum_marks = $('#additional_exam_maximum_marks').val();
	// var exam_group_minimum_marks = $('#additional_exam_minimum_marks').val();
	// var additional_exam_start_time = $('#additional_exam_start_time').val();
	// var additional_exam_end_time = $('#additional_exam_end_time').val();
	// var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
// 	
		// if(!numericReg.test(exam_group_maximum_marks)) {
			// $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Additional Exam  maximum marks in numeric format', {
				// type : 'warning'
			// });
			// return false;
		// }
		// if(!numericReg.test(exam_group_minimum_marks)) {
			// $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Additional Exam minimum marks in numeric format and less than maximum marks', {
				// type : 'warning'
			// });
			// return false;
		// }
// });
//set maximum marks
$("#additional_exam_group_exam_group_id").live("change", function() {
	var str = "";
	var index = $("#index").val();
	str = $(this).val();
	$("#additional_exam_group_maximum_marks").val('');
	$("#additional_exam_group_minimum_marks").val('');
	$('.minimum').val('');
		$('.maximum').val('');
		
	// var i=1;
	var j=0
	
		
	$.getJSON('get_max_min_marks',{'exam_group_id': str} , function(data) {
		$("#additional_exam_group_maximum_marks").val(data.maximum_marks[j]);
		$("#additional_exam_group_minimum_marks").val(data.minimum_marks[j]);
		for(var i=1;i<=index; i++)
		{
			var min = "min"+i
			var max = "max"+i
			document.getElementById(max).value = data.maximum_marks[j]
			document.getElementById(min).value = data.minimum_marks[j]
			j += 1;
		}	
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
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