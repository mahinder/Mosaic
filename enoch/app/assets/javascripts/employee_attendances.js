
$(document).on('change', '#department_attendance_id' , function(event){
	var tabss = document.getElementById('empdatatabl')
	if(tabss != null){
		destroyEmpOldTable(tabss);
	}
	var dept_id= $(this).val();
	if(dept_id!=""){
	getAttendanceData(dept_id);
	}
});


function getAttendanceData(dept_id){
	var nextdate = $('#nextMonth').val();
	var target  = '/employee_attendances/show' + '?dept_id=' + dept_id
    $("#loader_show").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get(target, {next: nextdate } ,function(data){
		var name= data.employee_name;
		var emp_id = data.employee_id;
		var today = data.today;
		var start_date = data.start_date;
		var end_date = data.end_date;
	    var date_array = data.date_array;
	    var employee_attendance_id = data.employee_attendance_id;
	    var employee_attendance_date = data.employee_attendance_date;
	    var date_style = data.date_style;
	    var nextdate = data.today;
	    var holiday_date = data.holiday_date;
	    var employee_department = data.employee_department;
	    var department_holiday = data.department_holiday;
	    var common_holiday = data.common_holiday;
	    var department_holiday_date = data.department_holiday_date;
	    markEmployeeAttendance(name,date_array,emp_id,employee_attendance_id,employee_attendance_date,date_style,holiday_date,employee_department,department_holiday,common_holiday,department_holiday_date);
	}).error(function(jqXHR, textStatus, errorThrown) { 
	        window.location.href = "/signin"
	});

}

function markEmployeeAttendance(name,date_array,emp_id,employee_attendance_id,employee_attendance_date,date_style,holiday_date,employee_department,department_holiday,common_holiday,department_holiday_date){
  // array4 = holiday_date.filter(function(item, i) {
        // var ok = common_holiday.indexOf(item) === -1;
        // return ok;
  // });
	           tbh_th = new Array();
                cont_text1 = new Array();
                tbody_td = new Array();
                cont_text = new Array();
                tbody_tr = new Array();
                cont_text2 = new Array();
                combo_box = new Array();
                div = document.createElement('div');
                div.setAttribute('id', 'empdatatabl');
				tab = document.createElement('table');
				tab.setAttribute('id', 'empnewtable');
				tab.setAttribute('class', 'table');
				tab.setAttribute('width', '100%');
				// tab.setAttribute('style','margin-top: -1px;');
				tbh = document.createElement('thead');			
				tbh_r = document.createElement('tr');

				for(i=0;i<=date_array.length;i++){
					
					if(i==0){
						cont_text1[i] = document.createTextNode("Name");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);		
						}else{	
					    cont_text1[i] = document.createTextNode(date_style[i-1]);
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_th[i].setAttribute('date_id',date_array[i-1] );
						if(tbh_th[i].innerHTML.match(/Sun*/)){
						tbh_th[i].setAttribute('style','background: #50A3C8;');
						}
						for (var n=0; n < holiday_date.length; n++) {
							  if(tbh_th[i].getAttribute('date_id')==holiday_date[n]){
								tbh_th[i].setAttribute('style','background: #50A3C8;');
								}
						};	
						tbh_r.appendChild(tbh_th[i]);
						}
				}
				tbody = document.createElement('tbody');
				for(j=0;j<name.length;j++){
				tbody_tr[j] = document.createElement('tr');
						for(k=0;k<=date_array.length;k++){

							if(k==0){
							cont_text[k] = document.createTextNode(name[j]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(cont_text[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}else{
							tbody_td[k-1] = document.createElement('td');
							tbody_tr[j].appendChild(tbody_td[k-1]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							tbody_td[k-1].setAttribute('date_id',date_array[k-1] );
							tbody_td[k-1].setAttribute('id',emp_id[j] );
							tbody_td[k-1].setAttribute('date_s',date_style[k-1] );
							tbody_td[k-1].setAttribute('employee_department',employee_department[j] );
						     var currentTime  =  new Date()
							var d = new Date(currentTime); 
							var today_date = d.getFullYear()  + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" +("0" + d.getDate()).slice(-2) 
							if(tbody_td[k-1].getAttribute('date_s').match(/Sun*/)){
							tbody_td[k-1].setAttribute('style','background: #50A3C8;');
							}
							if(tbody_td[k-1].getAttribute('date_id') == today_date){
							tbody_td[k-1].setAttribute('style','background: #C3FDB8;');
							}
								for (var l=0; l < department_holiday_date.length; l++) {
								  	if(tbody_td[k-1].getAttribute('date_id')==department_holiday_date[l] &&  tbody_td[k-1].getAttribute('employee_department')==department_holiday[l]){
									    tbody_td[k-1].setAttribute('style','background: #50A3C8;');
									}
								};
							for (var l=0; l < common_holiday.length; l++) {
								if(tbody_td[k-1].getAttribute('date_id')==common_holiday[l]){
									tbody_td[k-1].setAttribute('style','background: #50A3C8;');
								}
							};
							 // if(tbody_td[k-1].getAttribute('style')!= "background: #50A3C8;" || !tbody_td[k-1].getAttribute('date_s').match(/Sun*/)){
							 // if((jQuery.inArray(tbody_td[k-1].getAttribute('date_id'), array4) == -1  || jQuery.inArray(tbody_td[k-1].getAttribute('employee_department'), department_holiday.toString()) == -1) && !tbody_td[k-1].getAttribute('date_s').match(/Sun*/) && jQuery.inArray(tbody_td[k-1].getAttribute('date_id'), common_holiday) == -1){
							// tbody_td[k-1].addEventListener("click", function () { hellos($(this).attr('id'),$(this).attr('date_id'),$(this).text(),this,holiday_date,$(this).attr('employee_department'),common_holiday,department_holiday); }, false);
							tbody_td[k-1].addEventListener("dblclick", function () {
								
							   if(((this.getAttribute('style')!= "background: #50A3C8;") && (this.getAttribute('style')!= "background: rgb(80, 163, 200);")) && !this.getAttribute('date_s').match(/Sun*/)){
								hellos($(this).attr('id'),$(this).attr('date_id'),$(this).text(),this,holiday_date,$(this).attr('employee_department'));
							   }
							  }, false);
							// }
							
							tbody_tr[j].appendChild(tbody_td[k-1]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');	
								
								if(employee_attendance_id !="" || employee_attendance_date!= "" ){
								    for(var g=0; g<employee_attendance_id.length; g++) {
								    	
								                if (employee_attendance_id[g] == tbody_td[k-1].getAttribute('id') && employee_attendance_date[g]==tbody_td[k-1].getAttribute('date_id') ) {
								                  	cont_text[k] = document.createTextNode("X");
								                  	tbody_td[k-1].appendChild(cont_text[k]);		
					 							}else{
				 									cont_text[k] = document.createTextNode("")
				 									tbody_td[k-1].appendChild(cont_text[k]);
					 							}
										
								 	}
						 	}else{
									cont_text[k] = document.createTextNode("")
									tbody_td[k-1].appendChild(cont_text[k]);
							}
							
						}
						}
						tbody.appendChild(tbody_tr[j]);
				}
                div.appendChild(tab);
				tab.appendChild(tbh);
				tab.appendChild(tbody);
				tbh.appendChild(tbh_r);
				document.getElementById('emloyee_attendnce_register').appendChild(div);
			 		initEmployeeTables($('#empnewtable'));
			        $("#loader_show").empty();
}

function hellos(employee_id, dates, text,thiss,holiday_date,employee_department){

var multiple_date = ""
if(text == "X"){
	$(thiss).html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get('/employee_attendances/edit', {id2: employee_id, id: dates}, function(data){
		$(thiss).empty();
		$(thiss).append("X");
		var contents = data	
		$.modal({
		content : contents,
		title : 'Edit',
		maxWidth : 500,
		buttons : {
			'Update' : function(win) {
				var leave_type_id = $('#modal #attendance_employee_leave_type_id').val();
				var is_half_day = $("input:checked").val()
				var reason = $('#modal #attendance_reason').val()
				var edit_start_date = $('#modal #edit_start_date_attendance').val()
				var edit_end_date  = $('#modal #edit_end_date_attendance').val()
				var new_start_date = dateConvert(edit_start_date);
				var new_end_date = dateConvert(edit_end_date);
				
				if(new_start_date > new_end_date) {
							 $('#modal #outer_block').removeBlockMessages().blockMessage('End Date can not be less than Start Date', {
								 type : 'warning'
							 });
							 return false;
			     }
				edit_multiple_date = showGetResult(edit_start_date,edit_end_date)
				if(!leave_type_id || leave_type_id.length == 0) {
							 $('#modal #outer_block').removeBlockMessages().blockMessage('Please Select leaves type', {
								 type : 'warning'
							 });
							 return false;
			     }
			     if(!reason || reason.length == 0) {
							 $('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter Reason', {
								 type : 'warning'
							 });
							 return false;
			     }
				ajaxAttendanceEmployeeUpdate(leave_type_id,reason,is_half_day,edit_multiple_date,employee_id);
				win.closeModal();
			},
			'Delete' : function(win) {
				var leave_type_id = $('#modal #attendance_employee_leave_type_id').val();
				var is_half_day = $("input:checked").val()
				var reason = $('#modal #attendance_reason').val()
				var edit_start_date = $('#modal #edit_start_date_attendance').val()
				var edit_end_date  = $('#modal #edit_end_date_attendance').val()
				edit_multiple_date = showGetResult(edit_start_date,edit_end_date)
				confirmEmployeeAttendanceDelete(leave_type_id,reason,is_half_day,edit_multiple_date,employee_id,thiss);
				win.closeModal();
			}
		}
	});
var now = dateConvertInEmployeeAttendance(dates);
var today_date =  ("0" + now.getDate()).slice(-2) + "-" +
		    ("0" + (now.getMonth() + 1)).slice(-2) + "-" + 
		    now.getFullYear();
	$('#modal #edit_start_date_attendance').val(today_date)
	$('#modal #edit_end_date_attendance').val(today_date)
	modal_box_datepicker();
		}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});

}else{
	$(thiss).disabled = true;
 $(thiss).html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get('/employee_attendances/index', {id2: employee_id, id: dates}, function(data){
		$(thiss).empty()
		var contents = data	
		$.modal({
		content : contents,
		title : 'Create',
		maxWidth : 500,
		minWidth : 500,
		buttons : {
			'Submit' : function(win) {
				var leave_type_id = $('#modal #employee_attendance_employee_leave_type_id').val();
				var is_half_day = $("input:checked").val()
				var reason = $('#modal #attendance_reason').val()
				var start_date = $('#modal #start_date_attendance').val()
				var end_date  = $('#modal #end_date_attendance').val()
				var new_start_date = dateConvert(start_date);
				var new_end_date = dateConvert(end_date);
				
				if(new_start_date > new_end_date) {
							 $('#modal #outer_block').removeBlockMessages().blockMessage('End Date can not be less than Start Date', {
								 type : 'warning'
							 });
							 return false;
			     }
				multiple_date = showGetResult(start_date,end_date)
				if(!leave_type_id || leave_type_id.length == 0) {
							 $('#modal #outer_block').removeBlockMessages().blockMessage('Please Select leaves type', {
								 type : 'warning'
							 });
							 return false;
			     }
			     if(!reason || reason.length == 0) {
							 $('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter Reason', {
								 type : 'warning'
							 });
							 return false;
			     }
			   
				ajaxAttendanceEmployeeCreate(leave_type_id,reason,is_half_day,multiple_date,employee_id,thiss,holiday_date,employee_department);
                win.closeModal();
         
                  // });
				
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
var now = dateConvertInEmployeeAttendance(dates);
var today_date =  ("0" + now.getDate()).slice(-2) + "-" +
		    ("0" + (now.getMonth() + 1)).slice(-2) + "-" + 
		    now.getFullYear();
	$('#modal #start_date_attendance').val(today_date)
	$('#modal #end_date_attendance').val(today_date)
	modal_box_datepicker();
	}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});

}

}
function dateConvertInEmployeeAttendance(date){
				MyDate = date;
			MD_Date = MyDate.substring(0);
			MD_Time = MyDate.substring(1);
			MD_i2 = MD_Date.indexOf('-');
			MD_i3 = MD_Date.indexOf('-', MD_i2 + 1);
			MD_D = MD_Date.substring(0, MD_i2);
			MD_M = MD_Date.substring(MD_i2 + 1, MD_i3);
			MD_Y = MD_Date.substring(MD_i3 + 1);
			if((isNaN(MD_Y)) || (isNaN(MD_M)) || (isNaN(MD_D))) {
				alert('Not numeric.');
				DObj = '*** error';
			} else {
				MD_M = MD_M - 1;				
				DObj = new Date( MD_D, MD_M,MD_Y);
			}
			return DObj;
}

function showGetResult(start_date, end_date){
	var data ={
		'start_date' : start_date,
		'end_date' : end_date
	}
     var result = null;
     var url = '/employee_attendances/date_attandance_array';
     $.ajax({
        url: url,
        type: 'get',
        data: data,
        dataType: 'json',
        async: false,
        success: function(data1) {
            result = data1.multi_date;
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
     return result;
}




function ajaxAttendanceEmployeeCreate(leave_type_id,reason,is_half_day,multiple_date,employee_id,thiss,holiday_date,employee_department){
	var target = '/employee_attendances/create'
		 	 var data1 = {
								'employee_attendance[employee_id]' : employee_id,
								'employee_attendance[employee_leave_type_id]' : leave_type_id,
								'employee_attendance[attendance_date]' : multiple_date,
								'employee_attendance[reason]' : reason,
								'employee_attendance[is_half_day]' : is_half_day,
								'employee_department' :employee_department
						}
							
		$.ajax({
		url : target,
		dataType : 'json',
		type : 'POST',
		data : data1,
		success : function(data2, textStatus, jqXHR) {
			if(data2.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(data2.notice, {
					type : 'success'
				});
					for (var i=0; i < multiple_date.length; i++) {
						($("#empnewtable td").filter('[id ='+ employee_id+']')).each(function() {
							if( multiple_date[i]==$(this).attr('date_id')){
							    if(this.getAttribute('style')!= "background: #50A3C8;" && !this.getAttribute('date_s').match(/Sun*/)){
									if ($(this).html()!= "X") {
										$(this).append("X")
										$(this).setAttribute('style','background: red;')
									};
								}
							}
					 });
					};	
			} else {
				var errorText = getErrorText(data2.errors);
				$('#outer_block').removeBlockMessages().blockMessage(data2.errors || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});

}


function ajaxAttendanceEmployeeUpdate(leave_type_id,reason,is_half_day,edit_multiple_date,employee_id){
	var target = '/employee_attendances/update'
		 	 var data = {
								'employee_attendance[employee_id]' : employee_id,
								'employee_attendance[employee_leave_type_id]' : leave_type_id,
								'employee_attendance[attendance_date]' : edit_multiple_date,
								'employee_attendance[reason]' : reason,
								'employee_attendance[is_half_day]' : is_half_day
								
							}
		$.ajax({
		url : target,
		dataType : 'json',
		type : 'POST',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});						
			} else {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				 if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}		
			}	
		}
	});
}


function ajaxAttendanceEmployeeDelete(leave_type_id,reason,is_half_day,edit_multiple_date,employee_id,thiss){

	var target = '/employee_attendances/destroy'
		 	 var data = {
								'employee_attendance[employee_id]' : employee_id,
								'employee_attendance[employee_leave_type_id]' : leave_type_id,
								'employee_attendance[attendance_date]' : edit_multiple_date,
								'employee_attendance[reason]' : reason,
								'employee_attendance[is_half_day]' : is_half_day
								
							}
		$.ajax({
		url : target,
		dataType : 'json',
		type : 'POST',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
					for (var i=0; i < edit_multiple_date.length; i++) {
						($("#empnewtable td").filter('[id ='+ employee_id+']')).each(function() {
							if( edit_multiple_date[i]==$(this).attr('date_id')){
								if(!this.getAttribute('date_s').match(/Sun*/)){
									if ($(this).html()== "X") {
										$(this).empty();	
									};
								}
							}
					 });
					}
				  			
			} else {
				// Message
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'error'
				})
				
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});

}




function initEmployeeTables(tablenode) {

	var table = tablenode
		
	var oTable = table.dataTable({
		bRetrieve: true,
        bDestroy: true,
        "sScrollX": "100%",
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
	new FixedColumns( oTable, {
		"iLeftColumns": 1,
        "iLeftWidth": 150
 	} );
 	
}


function destroyEmpOldTable(tableId){
	document.getElementById('emloyee_attendnce_register').removeChild(tableId);
}

$(document).ready(function(event){
	$('#department_attendance_id').val("")
});

function confirmEmployeeAttendanceDelete(leave_type_id,reason,is_half_day,edit_multiple_date,employee_id,thiss) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxAttendanceEmployeeDelete(leave_type_id,reason,is_half_day,edit_multiple_date,employee_id,thiss);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}



$(document).on('change', '#employee_department_department_id', function(event){
	$.get('/employee_attendance/update_attendance_report', {department_id: $(this).val()},function(data){
		$('#attendance_report_employee').empty()
		$('#attendance_report_employee').html(data)
		configureEmployeeAttendanceNoTable($('#listing_employee_attendance'))
	}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
});


$(document).ready(function(event){
	$('#employee_department_department_id').val("")
	$('#attendance_report_employee').empty()

});




$(document).on('click', '#leaveHistory', function(event){
event.preventDefault();
var start_date =$('#period_start_date').val()
var end_date =$('#period_end_date').val()
var id = $('#employeeLeaveId').val()

$.get('/employee_attendance/update_leave_history', {period: {start_date: start_date, end_date: end_date},id: id },function(data){
	$('#updateleaveHistory').empty();
	$('#updateleaveHistory').html(data);
}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
});
});


function configureEmployeeAttendanceNoTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
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

$('.employeeAttendanceReport').each(function(i) {
	configureEmployeeAttendanceNoTable($(this));
});



$(document).ready(function(){
	var tabss = document.getElementById('empdatatabl')
	if(tabss != null){
		destroyEmpOldTable(tabss);
	}
	$('#department_attendance_id').val("")
	var dept_id =  "true"
	var userSIDS = $('#userSIDS').val()
	if( userSIDS == "Admin"){
	getAttendanceData(dept_id);
	}
});

$(document).on('click', '#allDepartmentEmployee',function(event){
	var tabss = document.getElementById('empdatatabl')
	if(tabss != null){
		destroyEmpOldTable(tabss);
	}
	$('#department_attendance_id').val("")
	var dept_id =  "true"
	getAttendanceData(dept_id);
});


$(document).on('click', '#edit_employee_leave',function(event){
	var leave_id = $(this).attr('leave_id')
	var leave_type = $(this).attr('leave_type')
	var leave_count = $(this).attr('leave_count')

	$.get('employee_leave_count_edit',{id: leave_id,leave_type: leave_type,leave_count: leave_count}, function(data){
		updateEmplyeeLeave(data,leave_id);
	}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
	
	return false;
});

function updateEmplyeeLeave(data,leave_id){
	$.modal({
		content : data,
		title : 'Update Leave',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				var leave_count = $('#modal #leave_count_leave_count').val();
		if(!leave_count || leave_count.length == 0) {
          $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Leave Count', {
            type : 'warning'
          });
          return false;
        }
        if(isNaN(leave_count) || leave_count.indexOf(" ") != -1) {
          $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only Numeric value', {
            type : 'warning'
          });
          return false;
        }
        if(leave_count.length>2) {
          $('#modal #outer_block').removeBlockMessages().blockMessage('Please enter valid leave count', {
            type : 'warning'
          });
          return false;
        }
				$.get('employee_leave_count_update',{id: leave_id, leave_count: leave_count},function(data){
					window.location.reload()
					win.closeModal();
				}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});	
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}
