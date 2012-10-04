$(document).on("ready",function(data){
	$("#term_master_id").val("");
	$("#student_term_course_id").val("");
	$("#remarks_type_field_id").val("");
});

$(document).on("change","#student_term_course_id",function(data){
	var id = $(this).val();
	$("#enterStudentTermRemarks").empty();
	$.get("student_term_remarks/change_student_term_batch?id="+id, function(data){
		$("#change_batch_for_student_term").empty();
		$("#change_batch_for_student_term").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
});

$(document).on("change","#term_master_id",function(event){
	$.get("student_term_remarks/change_student_term_batch?id=", function(data){
		$("#change_batch_for_student_term").empty();
		$("#change_batch_for_student_term").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
	$("#student_term_course_id").val("");
	$("#enterStudentTermRemarks").empty();
});

$(document).on("change","#student_term_batch_id",function(event){
	var remarks_type = $("#remarks_type_field_id").val();
	var termId = $("#term_master_id").val();
	var batch_id = $(this).val();
	if(termId == "" ){
		$('#outer_block').removeBlockMessages().blockMessage('Please Select the Term', {
					type : 'warning'
				});
		return false;
	}
	if(batch_id == "" ){
		$('#outer_block').removeBlockMessages().blockMessage('Please Select the Batch', {
					type : 'warning'
				});
		return false;
	}
	if (batch_id != "" && batch_id!= null && batch_id.length!= 0) {
	$('#outer_block').removeBlockMessages();
	$.get("student_term_remarks/"+batch_id,{term_master_id : termId,remarks_type : remarks_type}, function(data){
		$("#enterStudentTermRemarks").empty();
		$("#enterStudentTermRemarks").html(data);
		configureStudentTermRemarksMasterTable($("#studentTermRemarksTable"));
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
	}else{
	  changeStudentRecord();
	}
});

$(document).on("change","#remarks_type_field_id",function(event){
	var remarks_type = $(this).val();
	var termId = $("#term_master_id").val();
	var batch_id = $("#student_term_batch_id").val();
	if(termId == "" ){
		$('#outer_block').removeBlockMessages().blockMessage('Please Select the Term', {
					type : 'warning'
				});
		return false;
	}
	if(batch_id == "" ){
		$('#outer_block').removeBlockMessages().blockMessage('Please Select the Batch', {
					type : 'warning'
				});
		return false;
	}
	if (batch_id != "" && batch_id!= null && batch_id.length!= 0) {
	$('#outer_block').removeBlockMessages();
	$.get("student_term_remarks/"+batch_id,{term_master_id : termId,remarks_type : remarks_type}, function(data){
		$("#enterStudentTermRemarks").empty();
		$("#enterStudentTermRemarks").html(data);
		configureStudentTermRemarksMasterTable($("#studentTermRemarksTable"));
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
	}else{
	  changeStudentRecord();
	}
});


$(document).on("click","#CreateStudentTermRemarks",function(event){
	event.preventDefault();
	var student_id= []
	var remarks= []
	$('.student_term_remarks_rmk').each(function(){
		// if($(this).val()!= "" && $(this).val()!= null){
			remarks.push($(this).val())
			student_id.push($(this).attr('student_id'))
		// };
	});
	// if(remarks == "" ){
		// $('#outer_block').removeBlockMessages().blockMessage('Please Enter the Remarks', {
					// type : 'warning'
				// });
		// return false;
	// }
	var term_id = $("#term_master_id").val();
	var batch_id = $("#student_term_batch_id").val();
	var remarks_type = $("#remarks_type_field_id").val();
	var inputData = {
		'students' :student_id,
		'remarks' :remarks,
		'student_term_remark[batch_id]' : batch_id,
		'student_term_remark[term_master_id]' : term_id,
		'student_term_remark[remarks_type]' : remarks_type
	}
	var target = "/student_term_remarks"
   createStudentRemarks(target,inputData);
	
});

function changeStudentRecord(){
	$('#outer_block').removeBlockMessages();
	$.get("student_term_remarks/id", function(data){
		$("#enterStudentTermRemarks").empty();
		$("#enterStudentTermRemarks").html(data);
		configureStudentTermRemarksMasterTable($("#studentTermRemarksTable"));
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}

function createStudentRemarks(target,inputData){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : inputData,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				//individual domain need to implement this method
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

function configureStudentTermRemarksMasterTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		}, // No sorting for this columns, as it only contains checkboxes
		{
			sType : 'numeric'
		}, 
		{
			sType : 'numeric'
		},
		{
			sType : 'string'
		},
		{
			bSortable : false
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>ri<"block-footer clearfix"lf>',
		/*
		 * Callback to apply template setup
		 */
		fnDrawCallback : function() {
			this.parent().applyTemplateSetup();
		},
		fnInitComplete : function() {
			this.parent().applyTemplateSetup();
		}
	});
	// Sorting arrows behaviour
	table.find('thead .sort-up').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'asc']]);
		// Prevent bubbling
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		// Stop link behaviour
		event.preventDefault();
		// Find column index
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// Send command
		oTable.fnSort([[columnIndex, 'desc']]);
		// Prevent bubbling
		return false;
	});
};

$('.studentTermRemarksTable').each(function(i) {
	configureStudentTermRemarksMasterTable($(this));
});
