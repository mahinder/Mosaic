//handler - should call upon succes of ajax call

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#leave_form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#leave_type_name').val();
		var code = $('#leave_type_code').val();
		var max_leave_count = $('#leave_type_max_leave_count').val();
		var carry_forward = $('#leave_type_carry_forward').is(":checked");
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
        var stringReg = /^[a-z+\s+A-Z()]*$/ 
 
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Leave name', {
				type : 'warning'
			});
			return false
		}else if(name.length >25) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Leave name less than 25 characters', {
				type : 'warning'
			});
			return false
		}else if(!stringReg.test(name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Leave name', {
			type : 'warning'
		});
		return false;
	}else if(!max_leave_count || max_leave_count.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter max leave count', {
				type : 'warning'
			});
		return false
		}else if(!numericReg.test(max_leave_count)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter max leave count in numeric format', {
				type : 'warning'
			});
			return false
		} else if(max_leave_count.length > 2) {
			$('#outer_block').removeBlockMessages().blockMessage('wrong input for max leave count', {
				type : 'warning'
			});
		return false
		}else if(!code || code.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter code', {
				type : 'warning'
			});
		return false
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/EmployeeAttendance/ajax_add_leaves_types'

			var status = $("input[name='leave_type\\[status\\]']:checked").val();
			// Requ@elective_skillsest

			$.ajax({
				url : target,
				dataType : 'json',
				data : {
					'leave_type[name]' : name,
					'leave_type[code]' : code,
					'leave_type[max_leave_count]' : max_leave_count,
					'leave_type[carry_forward]' : carry_forward,
					'leave_type[status]' : status
				},
				success : function(data) {
					if(data.valid){
					$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
				type : 'success'
			});
			$.get('/employee_attendance/refresh_table', function(data) {
						$('#table-block').empty();
						$('#table-block').html(data);
						configureLeaveTable($('#active-table'));
						configureLeaveTable($('#inactive-table'));
						$('.tabs').updateTabs();
						attachLeavesUpdateHandler();
                        attachLeavesDeleteHandler();
					$('#update_leave').attr("disabled", true);
					$('#create_leave').attr("disabled", false);
									}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
			}else{
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
					
				}
			});
			resetLeaveForm();

		}
	});
});
//update employee leave

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#update_leave').on('click', function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var current_object_id = $('#current_object_id').val();
		var name = $('#leave_type_name').val();
		var code = $('#leave_type_code').val();
		var max_leave_count = $('#leave_type_max_leave_count').val();
		var carry_forward = $('#leave_type_carry_forward').is(":checked");
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
       var stringReg = /^[a-z+\s+A-Z()]*$/ 

		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Leave name', {
				type : 'warning'
			});
			return false
		}else if(name.length >25) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Leave name less than 25 characters', {
				type : 'warning'
			});
			return false
		}else if(!stringReg.test(name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Leave name', {
			type : 'warning'
		});
		return false;
	    }else if(max_leave_count.length > 2) {
			$('#outer_block').removeBlockMessages().blockMessage('wrong input for max leave count', {
				type : 'warning'
			});
		return false
		}else if(!numericReg.test(max_leave_count)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter max leave count in numeric format', {
				type : 'warning'
			});
			return false
		}else if(!code || code.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter code', {
				type : 'warning'
			});
			return false
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/EmployeeAttendance/edit_leave_types?id=' + current_object_id

			var status = $("input[name='leave_type\\[status\\]']:checked").val();
			// Requ@elective_skillsest

			$.ajax({
				url : target,
				dataType : 'json',
				data : {
					'leave_type[name]' : name,
					'leave_type[code]' : code,
					'leave_type[max_leave_count]' : max_leave_count,
					'leave_type[carry_forward]' : carry_forward,
					'leave_type[status]' : status
				},
				success : function(data) {
					$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
				type : 'success'
			});
					$.get('/employee_attendance/refresh_table', function(data) {
						$('#table-block').empty();
						$('#table-block').html(data);
						configureLeaveTable($('#active-table'));
						configureLeaveTable($('#inactive-table'));
						$('.tabs').updateTabs();
                        attachLeavesUpdateHandler();
                        attachLeavesDeleteHandler();
                        $('#update_leave').attr("disabled", true);
					$('#create_leave').attr("disabled", false);
						
					}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
				}
			});
			resetLeaveForm();

		}
	});
});
//reset button script

$(document).ready(function() {
	resetLeaveForm();
	$('#reset_leave').on('click', function(event) {
		resetLeaveForm();
	});
});
//update leave script
$(document).ready(function() {
	
	attachLeavesUpdateHandler();
});
$(document).ready(function() {
	
	attachLeavesDeleteHandler();
});

function attachLeavesDeleteHandler() {
$('a.delete-leave-href').on('click', function(event) {
		resetLeaveForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var remoteUrl = '/EmployeeAttendance/delete_leave_types?id=' + object_id;
		confirmDelete(remoteUrl, table, row);
		return false;
	});
}

function attachLeavesUpdateHandler() {
	$('a.update-leave-href').on('click', function(event) {
		resetLeaveForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		$('#leave_type_name').val($('#leave_name_' + object_id).html());
		$('#leave_type_code').val($('#leave_code_' + object_id).html());
		$('#leave_type_max_leave_count').val($('#leave_max_leave_count_' + object_id).html());
		var carry_fwd = $('#leave_is_carry_forward_' + object_id).html();
		if(carry_fwd == 'true') {
			$('#leave_type_carry_forward').attr('checked', true);
		} else {
			$('#leave_type_carry_forward').attr('checked', false);
		}

		$('#current_object_id').val(object_id);

		var name = table.attr("id");
		if(name == 'active-table')
			$('#leave_type_status_true').attr('checked', true);
		else
			$('#leave_type_status_false').attr('checked', true);

		$('#update_leave').attr("disabled", false);
		$('#create_leave').attr("disabled", true);
		return false;
	});
}

//reset leave form with default setting
function resetLeaveForm() {
	$('#leave_type_name').val("");
	$('#leave_type_code').val("");
	$('#leave_type_max_leave_count').val("");
	$('#leave_type_carry_forward').attr('checked', false);
	$('#leave_type_status_true').attr('checked', true);
	$('#update_leave').attr("disabled", true);
	$('#create_leave').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#tab-active').showTab();
}

//reset all leave
$('#leave_reset').on('click',function(event){
	$.get('/EmployeeAttendance/update_employee_leave_reset_all',function(data){
		$('#reset-box').empty();
		$('#reset-box').html(data);
		
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
//department
$("#leave_employee_department_department_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('/EmployeeAttendance/list_department_leave_reset?department_id=' + str, function(data) {

		$("#department-list").empty();
		$("#department-list").html(data);
		configuredepartmentListEmmployeeTable($('#empDepList'))
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});




function configuredepartmentListEmmployeeTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		},{
			sType : 'string'
		},{
			sType : 'string'
		},{
			sType : 'string'
		},{
			sType : 'string'
		}
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

$('.departmentListEmmployee').each(function(i) {
	configuredepartmentListEmmployeeTable($(this));
});
// advance search
function configureEmpListTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		aoColumns : [{
			bSortable : false
		},{
			sType : 'string'
		},{
			sType : 'string'
		},{
			sType : 'string'
		},{
			sType : 'string'
		}
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

$('.emp_list').each(function(i) {
	configureEmpListTable($(this));
});

// employee search by department or position or grade
$('#view_emp').on('click',function(event){
	var name = $('#advance_query').val();
	var department = $('#employee_employee_department').val();
	var category = $('#employee_employee_category').val();
	var position = $('#employee_employee_position_id').val();
	var grade = $('#employee_employee_grade').val();
	var url ='employee_search_ajax'
	var data ={'employee_department_id': department,
	           'employee_category_id': category,
	           'employee_position_id': position,
	           'employee_grade_id': grade,
	           'query': name
	           }
	$.get(url,data,function(data){
		$('#emp_search').empty();
		$('#emp_search').html(data);
		configureEmpListTable($('#empList'));
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	
});
// emp leave list of particular employee


//preset button
$('#preset').on('click', function(event){
	var emp_id = $('#pemployee').val();
	$.get('/EmployeeAttendance/employee_wise_leave_reset?id='+emp_id,function(data){
		$('.particularlist').empty();
		$('.particularlist').html(data);
		configurePEmpLeaveListTable($('#empListTables'))
		
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

// subject assignment department id
$("#subject_assignment_department_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('/EmployeeAttendance/employees_list?department_id=' + str, function(data) {
     $('#employee_list').empty();
     $('#employee_list').html(data);
     
		
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
//all checkbox
$(document).on('click','#chch',function(){
var checked_status = this.checked;

			$("input[type=checkbox]").each(function(){
			this.checked = checked_status;
		});
});
	

//employee all
$("#employee_employee_category").live("change", function() {
	
	var str = "";
	str = $(this).val();
	$.get('/employees/update_positions?category_id=' + str, function(data) {
		

		$("#leave_p").empty();
		$("#leave_p").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

//reset validation
$(document).on('click',"#edlist",function(event){
	 selectedItems = [];
$('input.batches_box').each(function(){
	if($(this).attr("checked") == 'checked'){
	selectedItems.push($(this).val())
	}
	});
if (selectedItems.length == 0) {
   $('#outer_bloc').removeBlockMessages().blockMessage('Please select at least one employee', {
			type : 'warning'
		});
		return false;
}
	
});
function specialChar() {
	
	var special_character = null;
	var iChars = "!$%^&*()+=[];{}:<>?";
	$(".full-width").each(function() {
		for(var i = 0; i < $(this).val().length; i++) {
			if(iChars.indexOf($(this).val().charAt(i)) != -1) {
				special_character = false;
			}
		}
	});
	return special_character;
}