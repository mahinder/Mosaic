$(document).ready(function(){
	$("tr.rows").removeClass("odd");
	$("tr.rows").removeClass("even");
    var datenew = new Date();
    $("#written_until_month").val(datenew.getMonth() + 1)
    $('.active-current').showTab();
    
});

$(document).on("change" , "#written_until_month",  function(event){
	var month_id = $(this).val();
	var id = $("#empIDTD").val();
	$.get("/teacher_diaries/"+id,{month_id : month_id}, function(data){
		$("#teacherDiariesPartial").empty();
		$("#teacherDiariesPartial").html(data);
		$('.tabs').updateTabs();
		$('.active-current').showTab();
	});
});

$(document).on("click" , "#saveTeacherDiary",  function(event){
	event.preventDefault();
	var matter = []
	var date_id = []
	var timing = []
	var id = $("#empIDTD").val();
	$(".teacherDiaryText").each(function(){
		if($(this).val() != "" && $(this).val()!= null){
			matter.push($(this).val())
			date_id.push($(this).attr('id'))
		}
	});
	var data = {
		'teacher_diary[description]' : matter,
		'teacher_diary[date_id]' : date_id,
		'id' : id
	}
	var target = "/teacher_diaries"
	createTeacherDiary(target,data);
});


function createTeacherDiary(target,data){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
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
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

$(document).on("click", ".viewEmployeeDiary", function(event){
	event.preventDefault();
	var start_date =$("#start_date_view_diary").val()
	var end_date =$("#end_date_view_diary").val()
	var id = $(this).attr('employee_id')
	var data ={
		'start_date' : start_date,
		'end_date' : end_date,
		'id' : id,
	}
	var target ="/teacher_diaries/view_diary"
	viewTeacherDiaryDetail(target,data);
})

function viewTeacherDiaryDetail(target,data){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				$('#getViewDiaryDetail').empty()
				$('#getViewDiaryDetail').html(data.html)
				configureAllEmployeeDiaryViewTable($('.allEmployeeDiaryViewTable'));
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block_new').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block_new').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});
	$('#outer_block_new').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

$(document).on("click", "#viewMyOwnDiary", function(event){
	event.preventDefault();
	var start_date =$("#start_date_my_diary").val()
	var end_date =$("#end_date_my_diary").val()
	var id = $(this).attr('employee_id')
	var data ={
		'start_date' : start_date,
		'end_date' : end_date,
		'id' : id,
	}
	var target ="/teacher_diaries/view_my_diary_details"
	viewTeacherDiaryOwnDetail(target,data);
})

function viewTeacherDiaryOwnDetail(target,data){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				$('#getViewDiaryDetail').empty()
				$('#getViewDiaryDetail').html(data.html)
				configureAllEmployeeDiaryViewTable($('.allEmployeeDiaryViewTable'));
			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#outer_block_new').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block_new').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});
	$('#outer_block_new').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

function configureAllEmployeeDiaryTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		}, // No sorting for this columns, as it only contains checkboxes
		{
			sType : 'string'
		},{
			sType : 'string'
		}
		,{
			sType : 'string'
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>ri<"block-footer clearfix"lf>rti<"block-footer clearfix"lf>',
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


$('.allEmployeeDiary').each(function(i) {
	configureAllEmployeeDiaryTable($(this));
});


function configureAllEmployeeDiaryViewTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		}, // No sorting for this columns, as it only contains checkboxes
		{
			sType : 'string'
		},{
			sType : 'string'
		}
		,{
			sType : 'string'
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix"lf>',
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


$('.allEmployeeDiaryViewTable').each(function(i) {
	configureAllEmployeeDiaryViewTable($(this));
});