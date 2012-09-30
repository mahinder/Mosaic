$(document).on("click", "#create_exam", function(event) {
	var exam_group_name = $('#exam_group_name').val();
	var exam_group_maximum_marks = $('#exam_group_maximum_marks').val();
	var exam_group_minimum_marks = $('#exam_group_minimum_marks').val();
	var type = $('#type').val();
	
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var stringReg = /^[a-z+\s+A-Z()]*$/
	
	
		if(!exam_group_maximum_marks || exam_group_maximum_marks.length == 0 || !numericReg.test(exam_group_maximum_marks)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Exam Group maximum marks in numeric format', {
				type : 'warning'
			});
			return false;
		}
		if(!exam_group_minimum_marks || exam_group_minimum_marks.length == 0  || !numericReg.test(exam_group_minimum_marks)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Exam Group minimum marks in numeric format', {
				type : 'warning'
			});
			return false;
		}
		var numericityCheck=numericTest()
		if(numericityCheck[0] == false){
			$('#outer_block').removeBlockMessages().blockMessage('Please enter number in '+numericityCheck[1], {
				type : 'warning'
			});
			return false
		}
		var i=0
		$(".bolean").each(function(index){
			if (!$(this).attr('checked')){
			var maximum_marks = parseInt($('#exam_group_exams_attributes_'+index+'_maximum_marks').val());
			var minimum_marks = parseInt($('#exam_group_exams_attributes_'+index+'_minimum_marks').val());
			if (minimum_marks>maximum_marks || minimum_marks==maximum_marks){
				i+=1
			}}
		});
		if (i>0){
			$('#outer_block').removeBlockMessages().blockMessage('Minimum marks can not be greater than the maximum marks', {
					type : 'warning'
			});
		event.preventDefault();	
		}

	//end of each function
});
$(document).on("blur", "#exam_group_maximum_marks", function(event) {
	var exam_group_maximum_marks = $('#exam_group_maximum_marks').val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	if(!numericReg.test(exam_group_maximum_marks)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Exam Group maximum marks in numeric format', {
				type : 'warning'
			});
			$('#exam_group_minimum_marks').attr("disabled",true); 
			return false;
		}
		else{
			// $('#outer_block').removeBlockMessages();
			$('.maximum').val(exam_group_maximum_marks);
			$('#exam_group_minimum_marks').attr("disabled",false);
		}
		
	});
	
	
$(document).on("blur", "#exam_group_minimum_marks", function(event) {
	var exam_group_minimum_marks = $('#exam_group_minimum_marks').val();
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	if(!numericReg.test(exam_group_minimum_marks)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Exam Group minimum marks in numeric format and less than maximum marks', {
				type : 'warning'
			});
			return false;
		}
		else{
			// $('#outer_block').removeBlockMessages();
			$('.minimum').val(exam_group_minimum_marks);
			
		}

	});
	

$(document).on("click","#delete_exam_group",function(event){
	var current_batch =$(this).attr('data-for-batch');
	var exam_group = $(this).attr('data-for-examgroup');
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				$.ajax({
		url : '/exam_groups/delete_exam_group',
		type : 'post',
		dataType : 'json',
		data : {
			'id' : exam_group,
			'batch_id' :current_batch
			},
		success : function(data) {
			var batch = data.key;
			if(data.valid == true)
			{
				$.get('/exam_groups/changeExam',{'batch': batch}, function(data) {
					$('#changeExamgroup').empty();
					$('#changeExamgroup').html(data);
					$('#outer_bloc').removeBlockMessages().blockMessage('Exam Group Deleted', {
				type : 'success'
			});
					configureExamGroupIndexTable($('#examgroupindex'))
					$('.delete_exam_group').empty();
					$('.delete_exam_group').html('<p>'+'Exam Group Deleted'+'</p>');
				}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
			}
				}});
				win.closeModal();
				
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	
});

