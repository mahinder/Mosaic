$(document).on("click", "#attendance_datepicker  td", function(event) {
event.preventDefault();
var batch  = $('#student_attendance_batch_id').val();
$('#save_attendances').hide();
var tabss = document.getElementById('datatabl')
	if(tabss != null){
		destroyOldTable(tabss);
	}
 batchChangeEffect(batch)
})

function dateConvert(date){
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
				DObj = new Date(MD_Y, MD_M, MD_D );
			}
			return DObj;
}


$(document).on("change" ,"#attendance_course_search_course_id", function(event) {
	var str = $(this).val();  
	$('#save_attendances').hide();
	var tabss = document.getElementById('datatabl')
	if(tabss != null){
		destroyOldTable(tabss);
	}
     var url = 'attendances/attendance_change_batch' + '?q='  +str 
     createAttendance(url);
});
$(document).on("ready" , function(event){
	 var currentTime  =  new Date()
		var d = new Date(currentTime); 
		var today_date =  ("0" + d.getDate()).slice(-2) + "-" +
		    ("0" + (d.getMonth() + 1)).slice(-2) + "-" + 
		    d.getFullYear();
	$('#period_entry').val(today_date)
	$('#attendance_course_search_course_id').val("");
	$("#attendance_course_search_course_id").attr("disabled" ,false);
	$("#student_attendance_batch_id").attr("disabled" ,false);
    $('#period_entry_multiple_date').val(today_date);
    $("#changeMultiAteendancePageBatchWise").empty();
});

function setIdOfDatePicker(){
	$('.datepick-popup').attr('id',"attendance_datepicker");
}

function batchChangeEffect(batch){
	 var target = "/attendances/show" + '?batch_id=' +batch 
                var currentTime  =  new Date()
				var month = currentTime.getMonth() + 1
				var day = currentTime.getDate()
				var year = currentTime.getFullYear()
				if(day.length!= 1 && month.length != 1){
				var data_date = "0"+day + "-" + "0"+month + "-" + year
				}else{
					var data_date = day + "-" + month + "-" + year
				}
				
				DObj = dateConvert(data_date);

				var monthLocale = new Array(12);
				monthLocale[0] = "January";
				monthLocale[1] = "February";
				monthLocale[2] = "March";
				monthLocale[3] = "April";
				monthLocale[4] = "May";
				monthLocale[5] = "June";
				monthLocale[6] = "July";
				monthLocale[7] = "August";
				monthLocale[8] = "September";
				monthLocale[9] = "October";
				monthLocale[10] = "November";
				monthLocale[11] = "December";
			  if(batch != "" && batch.length!=0){
               getTableData(target,monthLocale,month,DObj);
              }else{
              	$("#student_attendance_batch_id").attr("disabled" ,false);
              	$("#attendance_course_search_course_id").attr("disabled" ,false);
              }
}

$(document).on("change","#student_attendance_batch_id", function(event) {
	$("#student_attendance_batch_id").attr("disabled" ,true);
	$('#newTable').empty();
	$('#save_attendances').hide();
              var batch = $(this).val();       
              if(batch == "" && batch.length==0){
              		var tabss = document.getElementById('datatabl')
              	    $('#save_attendances').hide();
					if(tabss != null){
						destroyOldTable(tabss);
					}
              }
              $("#attendance_course_search_course_id").attr("disabled" ,true);
              batchChangeEffect(batch); 
});

function createAttendance(url){
	       $.get(url , function(data){
       	    $('#change_attendance_batch').empty();
            $('#change_attendance_batch').html(data);
   }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
   });
};

function getTableData(target,monthLocale,month,DObj){    
	var period_entry_date = $('#period_entry').val();
	var rex = /^\d{2}\-\d{2}\-\d{4}$/;
	if(!rex.test(period_entry_date)){
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid date', {
				type : 'warning'
			});
			return false;
		}
	var href = $("a#stopBackWorking").attr('href');
	$("a#stopBackWorking").attr('href',"#");
	$("#loadingAttendance").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get(target ,{period_entry_date: period_entry_date} ,function(data){
		var roll_no = data.rollNo
		var student_name = data.student
		var admission_no = data.admission_no
		var student_id = data.studentId
		var absent_id = data.student_id
		var absentS_id = data.absentS_id
		var absentee = data.absentee
		var validPeriodData = dateConvert(period_entry_date)
		if (validPeriodData > new Date()){
				$('#outer_block').removeBlockMessages().blockMessage("You can only mark today's or previous days attendance!", {
					type : 'warning'
				});
			$("#loadingAttendance").empty();
		}else{
		    markAttendance(roll_no,student_name,admission_no,student_id,absent_id,absentee,absentS_id);	
			$("#loadingAttendance").empty();
		}
		
	}).error(function(jqXHR, textStatus, errorThrown) { 
		if(jqXHR.status != 0){
	    window.location.href = "/signin"
	    }
	}).complete(function(){
		$("#attendance_course_search_course_id").attr("disabled" ,false);
		$("#student_attendance_batch_id").attr("disabled" ,false);
		$("a#stopBackWorking").attr('href',href);
	});
}

function markAttendance(roll_no,student_name,admission_no,student_id,absent_id,absentee,absentS_id){
    if(absentS_id == null){
    	$("a#stopBackWorking").attr('href','/student_attendance/index');
    	$('#save_attendances').hide();
    			$('#outer_block').removeBlockMessages().blockMessage("Period Entry Not found", {
					type : 'warning'
				});
				$("#loadingAttendance").empty();
				$("#attendance_course_search_course_id").attr("disabled" ,false);
				$("#student_attendance_batch_id").attr("disabled" ,false);
    }else{
    	$('#outer_block').removeBlockMessages()
    }
   
	var tabss = document.getElementById('datatabl')
	if(tabss != null){
		destroyOldTable(tabss);
	}

	           tbh_th = new Array();
                cont_text1 = new Array();
                tbody_td = new Array();
                cont_text = new Array();
                link = new Array();
                tbody_tr = new Array();
                cont_text2 = new Array();
                combo_box = new Array();
                div = document.createElement('div');
                div.setAttribute('id', 'datatabl');
				tab = document.createElement('table');
				tab.setAttribute('id', 'newtable');
				tab.setAttribute('class', 'table no-margin');
				tab.setAttribute('width', '100%');
				tbh = document.createElement('thead');			
				tbh_r = document.createElement('tr');

				for(i=0;i<4;i++){
					
					if(i==0){
						cont_text1[i] = document.createTextNode("Roll No.");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);		
						}
						else if(i==1){
						cont_text1[i] = document.createTextNode("Admission No.");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);
					    }
						else if(i==2){
						cont_text1[i] = document.createTextNode("Student Name");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);			
						}else{	
					    cont_text1[i] = document.createTextNode("Present/Absent");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);
						}
				}
				tbody = document.createElement('tbody');

				for(j=0;j<admission_no.length;j++){
				tbody_tr[j] = document.createElement('tr');
						for(k=0;k<4;k++){
							
							
							if(k==0){
							cont_text[k] = document.createTextNode(roll_no[j]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(cont_text[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}else if(k==1){
							cont_text[k] = document.createTextNode(admission_no[j]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(cont_text[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}else if(k==2){
							cont_text[k] = document.createTextNode(student_name[j])
							link[k] = document.createElement('a');
							link[k].href = '/student/my_profile/?q='+ admission_no[j]
							link[k].appendChild(cont_text[k]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(link[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}
							else{	
							combo_box[k] = document.createElement('select');
							combo_box[k].name = 'something';
							combo_box[k].id = student_id[j];
							
							choice = document.createElement('option');
							choice.value = 'option1';
							option1 = document.createTextNode('P')
							choice.appendChild(option1);
							combo_box[k].appendChild(choice);
							choice = document.createElement('option');
							choice.value = 'option2';
							option2 = document.createTextNode('A')
							choice.appendChild(option2);
							combo_box[k].appendChild(choice);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].setAttribute('id', student_id[j]);
							tbody_td[k].setAttribute('dates_id', $('#period_entry').val());
					if(absentS_id !="" ){
							for(var g=0; g<absentS_id.length; g++) {		
							  if (absentS_id[g] == tbody_td[k].getAttribute('id') ) {
								combo_box[k].selectedIndex = 1
								tbody_td[k].appendChild(combo_box[k]);
								}else{
								tbody_td[k].appendChild(combo_box[k]);
								}
							}
					}else{
						tbody_td[k].appendChild(combo_box[k]);
					}
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							
						}
						}
						tbody.appendChild(tbody_tr[j]);
				}
                div.appendChild(tab);
				tab.appendChild(tbh);
				tab.appendChild(tbody);
				tbh.appendChild(tbh_r);
				
				document.getElementById('newTable').appendChild(div);
				$('#save_attendances').show(); 
			 		initTables($('#newtable'));
			 	
			
}


function initTables(tablenode) {

	var table = tablenode
		
	var oTable = table.dataTable({
		bRetrieve: true,
        bDestroy: true,
		aoColumns : [{
			sType : 'numeric'
		}, // No sorting for this columns, as it only contains checkboxes
	    {
			sType : 'numeric'
		}, {
			sType : 'string'
		}, {
			bSortable : false
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
	new FixedColumns( oTable, {
		"iLeftColumns": 0,
		"iRightColumns": 1,
		"iRightWidth": 150

 	} );
 	
}

$(document).ready(function(){
	$('#save_attendances').hide();
});


function destroyOldTable(tableId){
	document.getElementById('newTable').removeChild(tableId);
}


$(document).on("click" ,"#save_attendances", function(event) {
var period_entry = $('#period_entry').val();
var batch = $("#student_attendance_batch_id").val();       
if(batch.length == 0 && batch==""){
	$('#outer_block').removeBlockMessages().blockMessage('Please select the batch', {
				type : 'warning'
	});
    return false;
}
 var batch_id = batch;
 var allVals = [];
$('#newtable').find('tr').each(function(){

 var absent = $(this).find('select').val();
 var absentId = $(this).find('select').attr('id');

    if(absent == "option2"){
	 allVals.push(absentId);
	 }
     
 });
 
  var data = {
				'attendance[student_id]' : allVals,
				'attendance[period_table_entry_id]' : period_entry,
				'batch_id' : batch_id
			}
 
 
 var target = "/attendances"

    $.ajax({
		url : target,
		dataType : 'json',
		type : "POST",
		data : data,
		success : function(data) {
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
				$("#attendance_course_search_course_id").attr("disabled" ,false);
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
});




//==================================Subject_wise_attendance==================================== //



$("#subject_course_search_course_id").live('change', function(event) {
$('#change_batch_wise_subjects').val("");
var str = "";
var subject_table = document.getElementById('datatablSubject')
	if(subject_table != null){
		destroySubjecttable(subject_table);
	}
     $("#subject_course_search_course_id option:selected").each(function () {
  
            str = $(this).val();       
           });
           var url = 'attendance_subject_wise_change_batch' + '?q='  +str 
         $.get(url , function(data){
       	    $('#change_attendance_batch_subject_wise').empty();
            $('#change_attendance_batch_subject_wise').html(data);
         }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		 });

         $("#student_subject_batch_id").live('change', function(event) {
         	var subjectTable = document.getElementById('datatablSubject')
			if(subjectTable != null){
				destroySubjecttable(subjectTable);
			}
         	var batch_id = ""
         	$("#student_subject_batch_id option:selected").each(function () {
                 batch_id = $(this).val();       
            });
         var subject_url = 'list_subject' + '?batch_id='  +batch_id
		         $.get(subject_url , function(data){
		         	  if(data!=null){
			       	    $('#change_batch_wise_subjects').empty();
			            $('#change_batch_wise_subjects').html(data);
			          }else{
			          	
			          }
		         }).error(function(jqXHR, textStatus, errorThrown) { 
			          window.location.href = "/signin"
				 });
         });

});

$(document).ready(function(){
	$('#subject_course_search_course_id').val("");
	$('#student_subject_batch_id').val("");
	$('#change_batch_wise_subjects').val("");
	$('#save_attendances_subject_wise').hide();
});


$("#subject_attendance_id").live('change', function(event) {
	var subject_id = "";

     $("#subject_attendance_id option:selected").each(function () {
  
            subject_id = $(this).val();       
           });
           if(subject_id != ""){ 
           getSubjectWisedata(subject_id);
           }else{
           	$('#save_attendances_subject_wise').hide();
           	var subjectTable = document.getElementById('datatablSubject')
				if(subjectTable != null){
					destroySubjecttable(subjectTable);
				}
           }
     
});

function getSubjectWisedata(subject_id){
	var batch_id = ""
	var subjectTable = document.getElementById('datatablSubject')
			if(subjectTable != null){
				destroySubjecttable(subjectTable);
			}
         	$("#student_subject_batch_id option:selected").each(function () {
                 batch_id = $(this).val();       
            });
          
	var target = "/attendances/show_subject_wise/?batch_id="+batch_id+",&subject_id="+subject_id
	var period_entry_date = $('#period_entry_subject_wise').val();
	$.get(target ,{period_entry_date: period_entry_date}, function(data){
		var student_name = data.student;
		var admission_no = data.admission_no
		var rollNo = data.rollNo
		var studentId = data.studentId
		var batchName = data.batchName
		var batchId = data.batchId
		var absents_batch_id  = data.absents_batch_id
		var absentS_id = data.absentS_id
	  	var period_id = data.period_id
		var validPeriodData = dateConvert(period_entry_date)
		if (validPeriodData > new Date()){
				$('#outer_block').removeBlockMessages().blockMessage("You can only mark present or past date attendance", {
					type : 'warning'
				});
				return false;
		}
		if(studentId == ""){
			
    	$('#save_attendances_subject_wise').hide();
    			$('#outer_block').removeBlockMessages().blockMessage("Student are not assigned", {
					type : 'warning'
				});
				return false;
	    }
	    if(period_id == null){
    	$('#save_attendances_subject_wise').hide();
    			$('#outer_block').removeBlockMessages().blockMessage("Period Entry Not found", {
					type : 'warning'
				});
				return false;
	    }
	    	$('#outer_block').removeBlockMessages()
	    	$('#save_attendances_subject_wise').show();
					createSubjectWiseAttendance(student_name,admission_no,rollNo,studentId,batchName,batchId,absents_batch_id,absentS_id)
	   
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
};

function createSubjectWiseAttendance(student_name,admission_no,rollNo,studentId,batchName,batchId,absents_batch_id,absentS_id){
	
var subjectTable = document.getElementById('datatablSubject')
	if(subjectTable != null){
		destroySubjecttable(subjectTable);
	}
	 tbh_th = new Array();
                cont_text1 = new Array();
                tbody_td = new Array();
                cont_text = new Array();
                tbody_tr = new Array();
                cont_text2 = new Array();
                combo_box = new Array();
                div = document.createElement('div');
                div.setAttribute('id', 'datatablSubject');
				tab = document.createElement('table');
				tab.setAttribute('id', 'newtableSubject');
				tab.setAttribute('class', 'table');
				tab.setAttribute('width', '100%');
				tbh = document.createElement('thead');			
				tbh_r = document.createElement('tr');

				for(i=0;i<4;i++){
					
					if(i==0){
						cont_text1[i] = document.createTextNode("Batch");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);		
						}
						else if(i==1){
						cont_text1[i] = document.createTextNode("Admission No.");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);
					    }
						else if(i==2){
						cont_text1[i] = document.createTextNode("Student Name");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);			
						}else{	
					    cont_text1[i] = document.createTextNode("Present/Absent");
						tbh_th[i] = document.createElement('th');
						tbh_th[i].appendChild(cont_text1[i]);
						tbh_r.appendChild(tbh_th[i]);
						}
				}
				tbody = document.createElement('tbody');

				for(j=0;j<student_name.length;j++){
				tbody_tr[j] = document.createElement('tr');
						for(k=0;k<4;k++){
	
							if(k==0){
							cont_text[k] = document.createTextNode(batchName[j]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(cont_text[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}else if(k==1){
							cont_text[k] = document.createTextNode(admission_no[j]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(cont_text[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}else if(k==2){
							cont_text[k] = document.createTextNode(student_name[j]);
							tbody_td[k] = document.createElement('td');
							tbody_td[k].appendChild(cont_text[k]);
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							}
							else{	
							combo_box[k] = document.createElement('select');
							combo_box[k].name = 'something';
							combo_box[k].id = 1;
							
							choice = document.createElement('option');
							choice.value = 'option1';
							// if(absent_id == student_id[j])
							option1 = document.createTextNode('Present')
							choice.appendChild(option1);
							combo_box[k].appendChild(choice);
							choice = document.createElement('option');
							choice.value = 'option2';
							option2 = document.createTextNode('Absent')
							choice.appendChild(option2);
							combo_box[k].appendChild(choice);
							combo_box[k].setAttribute('id', studentId[j]);
							combo_box[k].setAttribute('batch_id', batchId[j]);
							
							
							tbody_td[k] = document.createElement('td');
							tbody_td[k].setAttribute('id', studentId[j]);
							tbody_td[k].setAttribute('dates_id', $('#period_entry_subject_wise').val());
							tbody_td[k].setAttribute('batch_id', batchId[j]);
					if(absentS_id !="" ){
						
							for(var g=0; g<absentS_id.length; g++) {		
							  if (absentS_id[g] == tbody_td[k].getAttribute('id') ) {
								combo_box[k].selectedIndex = 1
								tbody_td[k].appendChild(combo_box[k]);
								}else{
								tbody_td[k].appendChild(combo_box[k]);
								}
							}
					}else{
						tbody_td[k].appendChild(combo_box[k]);
					}
							tbody_tr[j].appendChild(tbody_td[k]);
							tbody_tr[j].setAttribute('style','height: 50px;width: 5px;');
							
						}
						}
						tbody.appendChild(tbody_tr[j]);
				}
							
                div.appendChild(tab);
				tab.appendChild(tbh);
				tab.appendChild(tbody);
				tbh.appendChild(tbh_r);

				document.getElementById('subject_wise_table').appendChild(div);
				initSubjectTables($('#newtableSubject'));
}



$("#save_attendances_subject_wise").on('click', function(event) {
var period_entry = $('#period_entry_subject_wise').val();
var batch = ""
     $("#student_subject_batch_id option:selected").each(function () {
                    batch = $(this).val();       
      });
 var subject_id  =   $('#subject_attendance_id').val()
 var batch_id = batch;
 var allVals = [];
 var allBatchId = [];
$('#newtableSubject').find('tr').each(function(){
 var absent = $(this).find('select').val();
 var absentId = $(this).find('select').attr('id');
 var student_batch = $(this).find('select').attr('batch_id');

    if(absent == "option2"){
	 allVals.push(absentId);
	 allBatchId.push(student_batch);
	 }else{
	 	if( student_batch != null){
	 	allBatchId.push(student_batch);
	 	}
	 }
	 
 });
 
  var data = {
				'attendance[student_id]' : allVals,
				'attendance[period_table_entry_subject_wise_id]' : period_entry,
				'batch_id' : allBatchId,
				'subject_id' : subject_id
			}
 
 
 var target = "create_subject_wise_attendance"

    $.ajax({
		url : target,
		dataType : 'json',
		type : "POST",
		data : data,
		success : function(data) {
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
});

function destroySubjecttable(tableIds){
	document.getElementById('subject_wise_table').removeChild(tableIds);
};


$(document).ready(function(){
	 var currentTime  =  new Date()
		var d = new Date(currentTime); 
		var today_date =  ("0" + d.getDate()).slice(-2) + "-" +
		    ("0" + (d.getMonth() + 1)).slice(-2) + "-" + 
		    d.getFullYear();
	$('#period_entry_subject_wise').val(today_date)
	$('#subject_course_search_course_id').val("");
});

function emptySubjectWiseDatatable(){
	$('#save_attendances_subject_wise').hide();
	$('#student_subject_batch_id').val("");
	$('#subject_attendance_id').val("");
	var subjectTable = document.getElementById('datatablSubject')
	if(subjectTable != null){
		destroySubjecttable(subjectTable);
	}
}


function initSubjectTables(tablenode) {

	var table = tablenode
		
	var oTable = table.dataTable({
		bRetrieve: true,
        bDestroy: true,
		aoColumns : [{
			sType : 'string'
		}, // No sorting for this columns, as it only contains checkboxes
	    {
			sType : 'string'
		}, {
			sType : 'string'
		}, {
			bSortable : false
		}// No sorting for actions column
		],
		/*
		 * Set DOM structure for table controls
		 * @url http://www.datatables.net/examples/basic_init/dom.html
		 */
		sDom : '<"block-controls no-margin"<"controls-buttons"p>>rti<"block-footer clearfix"lf>',
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
		"iLeftColumns": 0,
		"iRightColumns": 1,
		"iRightWidth": 150

 	} );
 	
}

$(document).ready(function(event){
    var UserSIDS = $('#UserSIDS').val()
	if( UserSIDS == "Employee"){
	       $(document).on("change","#student_attendance_batch_id", function(event) {
               var batch = "";
                    $("#student_attendance_batch_id option:selected").each(function () {
                    batch = $(this).val();       
                      });
                      if(batch == ""){
                      		var tabss = document.getElementById('datatabl')
                      			$('#save_attendances').hide();
							if(tabss != null){
								destroyOldTable(tabss);
							}
                      }
                var target = "/attendances/show" + '?batch_id=' +batch 
                var currentTime  =  new Date()
				var month = currentTime.getMonth() + 1
				var day = currentTime.getDate()
				var year = currentTime.getFullYear()
				if(day.length!= 1 && month.length != 1){
				var data_date = "0"+day + "-" + "0"+month + "-" + year
				}else{
					var data_date = day + "-" + month + "-" + year
				}
				
				DObj = dateConvert(data_date);

				var monthLocale = new Array(12);
				monthLocale[0] = "January";
				monthLocale[1] = "February";
				monthLocale[2] = "March";
				monthLocale[3] = "April";
				monthLocale[4] = "May";
				monthLocale[5] = "June";
				monthLocale[6] = "July";
				monthLocale[7] = "August";
				monthLocale[8] = "September";
				monthLocale[9] = "October";
				monthLocale[10] = "November";
				monthLocale[11] = "December";
				if(batch!=""){
                 getTableData(target,monthLocale,month,DObj);
				}
      });
	}
});

//##################################################################################################//
							// Mark Multiple Attendance//
//##################################################################################################//


function setIdOfDatePickerMultiPleAttendance(){
	$('.datepick-popup').attr('id',"multiple_attendance_datepicker");
}

$(document).on("click", "#multiple_attendance_datepicker  td", function(event) {
event.preventDefault();
var date = $("#period_entry_multiple_date").val();
  openPage(date);
});

function openPage(date){
  $.post("/attendances/multiple_attendance", {date : date}, function(data){
  	$("#changeMultiAteendancePage").empty();
  	$("#changeMultiAteendancePage").html(data);
	configureMarkMultipleAttendance($('.multipleMarkAttendance'));
  }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
  });	
}

$(document).on("click", "#saveMultiAtten", function(event){
	event.preventDefault();
	var batch = []
	var roll_no = []
	var date = $("#period_entry_multiple_date").val();
	 $(".mark_multiple_attendance").map(function(){
		if($(this).val() != "") {
			  roll_no.push($(this).val());
			  batch.push($(this).attr('batch'));
	      }
	    }).get().join(", ");
	    
	    var data = {
	    	'roll_nos' : roll_no,
	    	'batches'  : batch,
	    	'date' : date
	    }
	    var target = "/attendances/multiple_attendance_save"
	    markMultipleAttendance(data,target,"#multipleTtendaceOuterBlock");
});

$(document).on("click", "#saveMultiAttenBatchWise", function(event){
	event.preventDefault();
	var period_entry = []
	var roll_no = []
	var batch = $("#multiple_batch_select_batch_id").val();
	 $(".mark_multiple_attendance_batch_wise").map(function(){
		if($(this).val() != "") {
			  roll_no.push($(this).val());
			  period_entry.push($(this).attr('period_entry'));
	      }
	    }).get().join(", ");
	    
	    var data = {
	    	'roll_nos' : roll_no,
	    	'period_entries'  : period_entry,
	    	'batch' : batch
	    }
	    var select_month = $("#multiple_batch_select_month_id").val();
	    if(select_month!= ""){
	    $('#multipleTtendaceOuterBlock').removeBlockMessages()
	    var target = "/attendances/multiple_attendance_save_batch_wise"
	    markMultipleAttendance(data,target,"#multipleTtendaceOuterBlockBatchWise");
	    }else{
	    $('#multipleTtendaceOuterBlock').removeBlockMessages().blockMessage("Please Select the Batch", {
					type : 'warning'
		});	
	    }
});

$(document).on("change","#multiple_batch_select_batch_id",function(event){
	$("#multiple_batch_select_month_id").val("");
	$("#changeMultiAteendancePageBatchWise").empty();
});

$(document).on("change","#multiple_batch_select_month_id",function(event){
	event.preventDefault();
	var batch = $("#multiple_batch_select_batch_id").val();
	var month = $(this).val();
	if(batch!=""){
		$('#multipleTtendaceOuterBlock').removeBlockMessages();
		$.post("/attendances/multiple_attendance", {batch : batch, month : month}, function(data){
		  	$("#changeMultiAteendancePageBatchWise").empty();
		  	$("#changeMultiAteendancePageBatchWise").html(data);
		  	configureMarkMultipleAttendanceBatchWise($('.multipleMarkAttendanceBatchWise'));
		  }).error(function(jqXHR, textStatus, errorThrown) { 
					        window.location.href = "/signin"
		  });
 	}else{
 		$('#multipleTtendaceOuterBlock').removeBlockMessages().blockMessage("Please Select the Batch", {
					type : 'warning'
		});
 	}
});

function refreshTable(href){
	if(href == "locales"){
	var currentTime  =  new Date()
		var d = new Date(currentTime); 
		var today_date =  ("0" + d.getDate()).slice(-2) + "-" +
		    ("0" + (d.getMonth() + 1)).slice(-2) + "-" + 
		    d.getFullYear();
    $('#period_entry_multiple_date').val(today_date);
    openPage(today_date);
	}else{
		$("#multiple_batch_select_month_id").val("");
		$("#multiple_batch_select_batch_id").val("");
	$("#changeMultiAteendancePageBatchWise").empty();
	}
}

function markMultipleAttendance(data,target,message_field){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				$(message_field).removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$(message_field).removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$(message_field).removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	
		}
	});

	// Message
	$(message_field).removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}


function configureMarkMultipleAttendanceBatchWise(tableNode) {
	// DataTable config
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		"bFilter": false,
		aoColumns : [{
			bSortable : false
		}, {
			sType : 'string'
		},{
		    bSortable : false
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

$('.multipleMarkAttendanceBatchWise').each(function(i) {
	configureMarkMultipleAttendanceBatchWise($(this));
});