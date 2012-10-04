$(document).on("click", ".pick", function(event) {
	//$(".elective-skill-secound").each(function() {
		// Open modal
		var contents = $('#modal-box');
		
			$.modal({
				content : contents,
				title : 'Update  course',
				width : 700,
				height : 200,
				buttons : {
					'Close' : function(win) {
						win.closeModal();
					}
				}
			});
			return false
		});
		

$("#grade_course_name").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('grade_update_batch?course_name=' + str, function(data) {
		$("#update_grades").empty();
		$("#update_grades").html(data);
	});
	if(str == "")
	{
	$.get('/grading_levels?batch_id='+str, function(data) {
		$("#grade_change").empty();
		 $("#grade_change").html(data);
	});
	}
});
$("#grade_batch_id").live("change", function() {
	var str = "";
	str = $(this).val();
		$.get('/grading_levels?batch_id='+str, function(data) {

		$("#grade_change").empty();
		 $("#grade_change").html(data);

	});
});

$(document).on("click", "#add_grades", function(event) {
	event.preventDefault();
	 $("#grading_level_name").val("");
	 $("#grading_level_min_score").val("");
	$.modal({
		content : $("#modal-box"),
		title : 'New Grade',
		maxWidth : 500,
		buttons : {
			'Save' : function(win) {
				var g_name = $("#modal #grading_level_name").val();
	var g_min_score = $("#modal #grading_level_min_score").val();
	var g_batch_id = $("#grading_level_batch_id").val();
				$.get("create_grade",{'grading_level': {
					'batch_id': g_batch_id,
					'name': g_name,
					'min_score': g_min_score
				}}, function(data) {
					if(data == 'Grading Level Name is exist'){
					$('#outer_block').removeBlockMessages().blockMessage('Grading Level Name is exist', {
			type : 'error'
		});
		return false;	
					}else{
					$("#grade_change").empty();
		$("#grade_change").html(data);
		$('#outer_block').removeBlockMessages().blockMessage('Grade Created Successfuly', {
			type : 'success'
		});
		return false;
				}});
				
		win.closeModal();
				},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});

});	

$(document).on("click", "#delete_grade", function(event) {
	event.preventDefault();
	var grade_id = $(this).attr('grade_id');
		$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				$.get("destroy/"+grade_id,function(data){
				$("#grade_change").empty();
		       $("#grade_change").html(data);
		       $('#outer_block').removeBlockMessages().blockMessage('Grade Inactive Successfuly', {
			type : 'success'
		});
		return false;
				});
				
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
		
	
});
