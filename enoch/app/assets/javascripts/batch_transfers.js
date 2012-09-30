$("#course_search_course_id").live('change', function(event) {
$('#student_list_table').empty();
var str = "";
var tr = $("#trns").val();

     $("#course_search_course_id option:selected").each(function () {
            str = $(this).val();       
           });
            var url = '/batch_transfers/change_batch' + '?q='  +str
           // if (str == ""){ 
           	    // $('#student_batch_id').empty(); 
				// $('#student_list_table').empty();
	           	// return false;
           // }
       $.get(url , function(data){
       	    $('#change_batch_for_batch_transfer').empty();
            $('#change_batch_for_batch_transfer').html(data);
            $("#student_batch_transfer_id").live('change', function(event) {
               var batch = "";
             
                    $("#student_batch_transfer_id option:selected").each(function () {
                    	batch = $(this).val();       
                      });
                      if (batch == ""){
                      	$('#student_list_table').empty();
		                	$('#outer_block').removeBlockMessages().blockMessage("Please Select the batch", {
										type : 'warning'
									});
									return false;
		               }else{
		               	$('#outer_block').removeBlockMessages();
		               }
                       var target = "/batch_transfers/index" + '?id=' +batch 
                       $("#student_list_table").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
                $.get(target,{trns: tr},function(data){
	              	$('#student_list_table').empty();
	                $('#student_list_table').html(data);
	                configureBatchTransferTable($('#mysortable'));
                }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});
             });
        }).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
		});
});


$(document).on("click", "#select-all", function(event){
	var checked_status = this.checked;
		$("input[name=paradigm]").each(function(){
			this.checked = checked_status;
		});
});

$(document).ready(function(event){
	$('#course_search_course_id').val("");
	$('#student_batch_id').val("Select"); 
	$('#student_list_table').empty();
});					

$(document).on("click", "#transfer", function(event){
	var course_id = $('#course_search_course_id').val();
	var contents = $('#modal-box-transfer');
	var allVals = [];
	var tr = $("#trns").val();
	$("input:checkbox[name=paradigm]:checked").each(function(){
			allVals.push($(this).val());
	});
	if(allVals!= ""){
	$.modal({
				content : contents,
				title : 'Transfer to Batch',
				width : 700,
				height : 150,
				buttons : {
					'Close' : function(win) {
						win.closeModal();
						$('#outer_block').removeBlockMessages();
					},
					'Transfer' : function(win) {
						 var id =document.getElementById("batch_ID").value;
   						 var changed_batch_id = $('#modal #student_batch_transfer_batch_id').val();
   						 if (changed_batch_id != "" && course_id != "" && changed_batch_id != null){
					     var url = '/batch_transfers/transfer' 
					     $.get(url, {student: allVals, id:id , q: course_id ,to: changed_batch_id,trns: tr}, function(data){
						     $('#student_list_table').empty();
							 $('#student_list_table').html(data);
							 configureBatchTransferTable($('#mysortable'));	
						    $('#outer_block').removeBlockMessages().blockMessage("Students transferred successfully", {
								type : 'success'
							});				 
					      }).error(function(jqXHR, textStatus, errorThrown) { 
						        window.location.href = "/signin"
						  });	
					     win.closeModal();	
					    } else{
					    	$('#modal #outer_block').removeBlockMessages().blockMessage("Please Select the course and batch", {
								type : 'warning'
							});
					    	// win.closeModal();	
					    }
					     					       
					}
				}
			});
		}else{
			$('#outer_block').removeBlockMessages().blockMessage("Please Select atleast one student", {
								type : 'warning'
			});	
		}
});
	
$("#modal #courses_search_course_id").live('change', function(event) {

var str = "";

     $("#modal #courses_search_course_id option:selected").each(function () {
            str = $(this).val();   
           });
            var url = '/batch_transfers/update_batch' + '?q='  +str
            if (str == ""){ 
           	    $('#modal #student_batch_transfer_batch_id').empty(); 
	           	return false;
           }
       $.get(url , function(data){
       	    $('#modal #change_batch').empty();
            $('#modal #change_batch').html(data);
        }).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
		});
});
	
$(document).on("click", "#graduate", function(event){	
	var course_id = $('#course_search_course_id').val();
	var allVals = [];
	$("input:checkbox[name=paradigm]:checked").each(function(){
			allVals.push($(this).val());
	});
	var contents = $('#modal-box-graduate');
	if(allVals!= ""){
	$.modal({
				content : contents,
				title : 'Status Description',
				width : 700,
				height : 150,
				buttons : {
					'Graduate' : function(win) {
   						var status_description = $('#modal #status_description').val();
   						var id =$('#batch_ID').val();
					     var url = '/batch_transfers/graduation' 
					     $.get(url, {ids: allVals, id:id, status_description: status_description,trns: ""}, function(data){
						     $('#student_list_table').empty();
							 $('#student_list_table').html(data);
							 configureBatchTransferTable($('#mysortable'));
							   $('#outer_block').removeBlockMessages().blockMessage("Students graduated successfully", {
									type : 'success'
								});
					      }).error(function(jqXHR, textStatus, errorThrown) { 
						        window.location.href = "/signin"
						  });		
					     win.closeModal();				       
					},
					'Cancel': function(win) { win.closeModal(); }
				}
			});
			}else{
			$('#outer_block').removeBlockMessages().blockMessage("Please Select atleast one student", {
								type : 'warning'
			});	
		}

});
			
	
			