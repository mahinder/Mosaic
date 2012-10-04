$(document).ready(function(){
	$('#mode_selection').hide();
	$('#month_hide_report').hide();	
	$('#year_hide_report').hide();
	$("#attendance_report_course_course_id").val("");
	$("#student_report_batch_id").val("");
	$("#mode_of_report_id").val("");
	$('#report_content_for_admin').empty()
	$('#month_hide_report').val("");	
	$('#year_hide_report').val("");		
});



$("#attendance_report_course_course_id").live('change', function(event) {
	$('#month_hide_report').hide();	
	$('#year_hide_report').hide();
	$('#report_content_for_admin').empty();
var str = "";

     $("#attendance_report_course_course_id option:selected").each(function () {
  
            str = $(this).val();       
           });
           $('#mode_selection').hide();
         var url = 'attendance_reports/attendance_report_batch' + '?q='  +str 
         $.get(url , function(data){
       	    $('#change_attendance_batch_report').empty();
            $('#change_attendance_batch_report').html(data);
         });

});

 $("#student_report_batch_id").live('change', function(event) {
	$('#month_hide_report').hide();	
	$('#year_hide_report').hide();
	$("#mode_of_report_id").val("");
	$('#report_content_for_admin').empty()
               var batch = "";
               
                    $("#student_report_batch_id option:selected").each(function () {
                    batch = $(this).val();       
                      });
                      if(batch==""){
                      	$('#mode_selection').hide(); 
                      	$('#month_hide_report').hide();	
						$('#year_hide_report').hide();
                      }else{
                      	$('#mode_selection').show();  
                      }
                    
                      
});

$("#mode_of_report_id").live('change', function(event) {
	$('#report_content_for_admin').empty()
	 var mode_of_report = "";
             
                    $("#mode_of_report_id option:selected").each(function () {
                    mode_of_report = $(this).val();       
                      });
	               if(mode_of_report==""){
						$('#month_hide_report').hide();	
						$('#year_hide_report').hide();	     	
                   }else if(mode_of_report=="Monthly"){
						$('#month_hide_report').show();	
						$('#year_hide_report').show();	
                   }else{
                        $('#month_hide_report').hide();	
						$('#year_hide_report').hide();
						$('#month_hide_report').val("");	
						$('#year_hide_report').val("");	
                   }
	
});


$(document).on("click", "#atten_report", function(event){
	$('#report_content_for_admin').empty()
var batch_id = $('#student_report_batch_id').val();
var mode = "";
var month_id = "";
var year_id = "";

     $("#mode_of_report_id option:selected").each(function () {
            mode = $(this).val();       
	           });
	           if( mode != "Monthly"){
	           	$("#month_report_id option:selected").each(function () {
		            month_id = ""       
		         });
                $("#year_report_year option:selected").each(function () {
		            year_id = ""      
		         });
	            }else{
                $("#month_report_id option:selected").each(function () {
		            month_id = $(this).val();       
		         });
                $("#year_report_year option:selected").each(function () {
		            year_id = $(this).val();       
		         });
          }
   
       var data = {
				'advance_search[mode]' : mode,
				'advance_search[subject_id]' : "",
				'advance_search[month]' : month_id,
				'advance_search[year]' : year_id,
				'advance_search[batch_id]' : batch_id
			    
			}

 var target = "/attendance_reports/show"
 
 if(batch_id=="" ){
 		$('#outer_block').removeBlockMessages().blockMessage('Please Select batch', {
		type : 'warning'
	});
	return false;
 }if(mode == ""){
 	$('#outer_block').removeBlockMessages().blockMessage('Please Select Mode', {
		type : 'warning'
	});
	return false;
 
 }
 if(mode == "Monthly"){
 	if(month_id == ""){
 	$('#outer_block').removeBlockMessages().blockMessage('Please Select Month', {
		type : 'warning'
	});
	return false;
	}
	if(year_id == ""){
 	$('#outer_block').removeBlockMessages().blockMessage('Please Select Year', {
		type : 'warning'
	});
	return false;
	}
 }

$('#outer_block').removeBlockMessages();
$("#report_content_for_admin").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
$.get(target, {data: data}, function(data1){
  $('#report_content_for_admin').empty();
  $('#report_content_for_admin').html(data1);	
  configureReportAdminAttendance($('#reportSAttAdmin'));
});



});

function configureReportAdminAttendance(tableNode) {
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
		}, {
			sType : 'string'
		}, {
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

$('.report_attendance_admin').each(function(i) {
	configureReportAdminAttendance($(this));
});



function configureArchievedReportAdminAttendance(tableNode) {
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
		}, {
			sType : 'string'
		}, {
			sType : 'string'
		},{
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

$('.archieved_attendance_report').each(function(i) {
	configureArchievedReportAdminAttendance($(this));
});


