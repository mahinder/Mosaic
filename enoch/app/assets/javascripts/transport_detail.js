//handler - should call upon succes of ajax call
var updateDetailTableFunction = function(data) {
	$.get('/transport_details', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureSchoolTransportDetail($('#active-table'));
		configureSchoolTransportDetail($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_detail').attr("disabled", true);
		$('#create_detail').attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transport_detail-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var route = $('#transport_detail_transport_route_id').val();
		var vehicle = $('#transport_detail_transport_vehicle_id').val();
		var driver = $('#transport_detail_transport_driver_id').val();
		var intime = $('#transport_detail_intime_4i').val();
		var outtime = $('#transport_detail_outtime_4i').val();
		var intimem = $('#transport_detail_intime_5i').val();
		var outtimem = $('#transport_detail_outtime_5i').val();
		var character_length=charactersLength();
		if(!route || route.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose transport route', {
				type : 'warning'
			});
			return false;
		}
		if(character_length[0] == false) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ character_length[1], {
					type : 'warning'
				});
				return false;
			}
		if(!vehicle || vehicle.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose vehicle type', {
				type : 'warning'
			});
			return false;
		}
		if(!driver || driver.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter  choose driver', {
				type : 'warning'
			});
			return false;
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/transport_details'

			var status = $("input[name='transport_detail\\[status\\]']:checked").val();
			// Request
			var data = {
				'transport_detail[transport_route_id]' : route,
				'transport_detail[transport_vehicle_id]' : vehicle,
				'transport_detail[transport_driver_id]' : driver,
				'transport_detail[intime]' : intime + ':' + intimem,
				'transport_detail[outtime]' : outtime + ':' + outtimem,
				'transport_detail[status]' : status
			}

			ajaxCreate(target, data, updateDetailTableFunction, submitBt);
			resetDetailForm();
		}
	});
});

$(document).ready(function() {
	$('#update_detail').on('click', function(event) {
		var route = $('#transport_detail_transport_route_id').val();
		var vehicle = $('#transport_detail_transport_vehicle_id').val();
		var driver = $('#transport_detail_transport_driver_id').val();
		var intime = $('#transport_detail_intime_4i').val();
		var outtime = $('#transport_detail_outtime_4i').val();
		var intimem = $('#transport_detail_intime_5i').val();
		var outtimem = $('#transport_detail_outtime_5i').val();
		var character_length=charactersLength();
		if(!route || route.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose transport route', {
				type : 'warning'
			});
			return false;
		}
		if(character_length[0] == false) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ character_length[1], {
					type : 'warning'
				});
				return false;
			}
		if(!vehicle || vehicle.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose vehicle type', {
				type : 'warning'
			});
			return false;
		}
		if(!driver || driver.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose driver', {
				type : 'warning'
			});
			return false;
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='transport_detail\\[status\\]']:checked").val();
			// Target url
			var target = "/transport_details/" + current_object_id
			// Request
			var data = {
				'transport_detail[transport_route_id]' : route,
				'transport_detail[transport_vehicle_id]' : vehicle,
				'transport_detail[transport_driver_id]' : driver,
				'transport_detail[intime]' : intime + ':' + intimem,
				'transport_detail[outtime]' : outtime + ':' + outtimem,
				'transport_detail[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateDetailTableFunction, submitBt);
			resetDetailForm();
		}
	});
});

$(document).ready(function() {
	resetDetailForm();
	$('#reset_detail').on('click', function(event) {
		resetDetailForm();
	});
});

$(document).on("click", 'a.delete-transport_detail-master-href', function(event) {
	resetDetailForm();
	$('html, body').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-transport_detail-master-href', function(event) {
	resetDetailForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#transport_detail_transport_route_id').val($('#deatil_route_names_' + object_id).val());
	$('#transport_detail_transport_vehicle_id').val($('#detail_vehicle_names_' + object_id).val());
	$('#transport_detail_transport_driver_id').val($('#detail_driver_names_' + object_id).val());
	$('#transport_detail_intime_4i').val(set_timing($('#detail_intime_' + object_id).text()));
	$('#transport_detail_outtime_4i').val(set_timing($('#detail_outtime_' + object_id).text()));
	$('#transport_detail_outtime_5i').val(set_minute_timing($('#detail_outtime_' + object_id).text()));
	$('#transport_detail_intime_5i').val(set_minute_timing($('#detail_intime_' + object_id).text()));
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table') {
		$('#transport_detail_status_true').attr('checked', true);
	} else {
		$('#transport_detail_status_false').attr('checked', true);
	}
	$('#update_detail').attr("class", "");
	$('#create_detail').attr("disabled", true);
	$('#update_detail').attr("disabled", false);

	return false;
});
function resetDetailForm() {

	$('#transport_detail_transport_route_id').val("");
	$('#transport_detail_transport_vehicle_id').val("");
	$('#transport_detail_transport_driver_id').val("");
	$('#transport_detail_intime_4i').val("");
	$('#transport_detail_outtime_4i').val("");
	$('#transport_detail_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_detail').attr("class", "");
	$('#create_detail').attr("disabled", false);
	$('#update_detail').attr("disabled", true);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}

function set_timing(sunset) {
	var hour = sunset.substring(0, sunset.length - 5);
	var forma = sunset.substring(5)
	if(forma == 'PM') {
		hour = parseInt(hour) + 12
	}
	return hour
}

function set_minute_timing(sunset) {
	return sunset.substring(3, sunset.length - 2)
}


$(document).on('click','#add-passanger',function(event){
	event.preventDefault();
	
	$("#modal #type").val('student');
	var transport_detail = $(this).attr('current_detail')
		var data = {
		"transport_detail" : transport_detail,
		"type" : 'student'
	}
	var route=$("#detail_route_name_"+transport_detail).text();
	var vehicle=$("#detail_vehicle_type_"+transport_detail).text();
	var url = '/transport_details/add_passenger_index'
     
	$.get(url,data,function(data){
		$.modal({
				content : data,
				title : route+ '/' +vehicle,
				width : 800,
				height : 350,
				buttons : {
			    'Close' : function(win) {
				win.closeModal();
			}}
			});
	});
});

//passanger course
$("#passanger_course_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('change_batch?id=' + str, function(data) {
		$("#update_batch").empty();
		$("#update_batch").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){

                                   window.location.href = "/signin"

                          });
});
//passanger batch
$("#passanger_batch_id").live("change", function() {
	var transport_detail_id = $("#transport_detail_id").val();
	var str = "";
	str = $(this).val();
	var data = {
				'batch_id' : str,
				'id' : transport_detail_id
			}
	$.get('get_student',data, function(data) {

		$("#passangers").empty();
		$("#passangers").html(data);
		configureSchoolPassangerDetail($('.student_passangers'));
	}).error (function(jqXHR, textStatus, errorThrown){

                                   window.location.href = "/signin"

                          });
                          	
});




$(document).on("click","#modal #passanger_ids",function(event){
	
	var passanger = $(this).val();
	var transport_detail_id = $("#transport_detail_id").val();
	var board=  $("#board_"+passanger).val();
	var type=$("#type").val();
	if ($(this).attr('checked')=="checked"){
	
	if (!board || board.length==0){
		$('#modal #outer_block').removeBlockMessages().blockMessage('Please select Boarding station ', {
				type : 'warning'
			});
			return false
	}
else{
			var target = "save_passanger_detail"
			var data = {
			  'passanger' : passanger,
			  'transport_detail' :transport_detail_id,
			  'board' : board,
			  'type' : type
			}
		$.ajax({
			url : target,
			dataType : 'json',
		    type : 'post',
			data : data,
			success : function(data) {
				if (data.valid){
					$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				}
			
			},
			error : function(jqXHR, data ) {
			    if (jqXHR.status === 403) {
			        window.location.href = "/signin"
			    }else{
					$('#modal #outer_block').removeBlockMessages().blockMessage(data.errors, {
						type : 'error'
					});
				}
			}
		});
	}
}else{
	$('#modal #outer_block').removeBlockMessages()
}
	
});




$(document).on("click", "#view-passanger", function(event) {
	event.preventDefault();
	var id=$(this).attr("current_detail");
	var route_name=$("#detail_route_name_"+id).text();
	var vehicle_type=$("#detail_vehicle_type_"+id).text();
	
	if(blockDoubleClick != true){
		blockDoubleClick = true;

	var transport_detail = $(this).attr('current_detail')
	var url = 'view_passanger?transport_detail='+transport_detail
	$.get(url,function(data){
		
		$.modal({
			    title : route_name+"/"+vehicle_type,
				content :data,
				width : 800,
				height : 350,
				buttons : {		
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
configureViewPassanger($(".view_passenger"));
}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    }).complete(function(jqXHR){
				    	blockDoubleClick = false;
		});
   }
});




$(document).on('click',"#passenger_type_student",function(event){
	$("#passangers").empty();
	var type =$(this).val();
	$("#type").val(type);
	var transport_detail = $("#transport_detail_id").val();
	var data = {
		"transport_detail" : transport_detail,
		"type" : type
	}
	var url = '/transport_details/add_passenger'
	$.get(url,data,function(data){
		$("#passenger_type").empty();
		$("#passenger_type").html(data);
		
	});
});

$(document).on('click',"#passenger_type_employee",function(event){
	$("#passangers").empty();
	var type =$(this).val();
	$("#type").val(type);
	var transport_detail = $("#current_det").val();
	
	var data = {
		"transport_detail" : transport_detail,
		"type" : type
	}
	var url = '/transport_details/add_passenger'
	$.get(url,data,function(data){
		$("#passenger_type").empty();
		$("#passenger_type").html(data);
		
	});
});



$("#passanger_department").live("change", function() {
var transport_detail_id = $("#transport_detail_id").val();
	
	var str = $(this).val();
	var data = {
				'department' : str,
				'id' : transport_detail_id
			}
	$.get('passanger_department',data, function(data) {

		$("#passangers").empty();
		$("#passangers").html(data);
		configureSchoolPassangerDetail($('.student_passangers'));
	}).error (function(jqXHR, textStatus, errorThrown){

                                   window.location.href = "/signin"

                          });
});




$(document).on("click", "a.delete-passenger-href", function(event) {

	var aLink = $(this);
	var object_id= $(this).attr('id');
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
					$.get("/transport_details/delete_passenger?id="+object_id, function(data){
		 	$('#view_details').empty();
		 	$('#view_details').html(data);
		 	$('#modal #outer_block').removeBlockMessages().blockMessage("Successfully Deleted Passenger", {
					type : 'success'
				});
				configureViewPassanger($(".view_passenger"));
         }).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
				win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
		  
	});
	
	return false;
});


$(document).on("click", "a.update-passenger-href", function(event) {

	var aLink = $(this);
	var object_id= $(this).attr('id');
	var transport_detail=$(this).attr('transport_detail');
	var data={
		'id' : object_id,
		'transport_detail' : transport_detail
	}
	var url_prefix = "edit_passenger"
	$.get(url_prefix,data,function(data){
		$.modal({
		content : data,
		title : 'Edit Passenger',
		maxWidth : 500,
		buttons : {
			'Update' : function(win) {
		 var board = $("#modal #board").val();
		$.get("update_passenger/?id="+object_id,{transport_board : board}, function(data){
		 	$('#view_details').empty();
		 	$('#view_details').html(data);
		 	 configureViewPassanger($(".view_passenger"));
		 	$('#modal #outer_block').removeBlockMessages().blockMessage("Successfully updated Passenger", {
					type : 'success'
				});
         });
        
				win.closeModal();
			}
			,
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	
	
	return false;
	
});



 $("#transport_report_route").on('click',function(event){
 	 $("#type_mode").val($(this).val());
 	 $("#get_report").empty();
 var type = $(this).val();
 var url = "/transport_details/transport_report_index?type="+type
 $.get(url,function(data){
 	$("#report_index").empty();
 	$("#report_index").html(data);
 	
 })
 });
 
 $("#transport_report_board").on('click',function(event){
 	 $("#type_mode").val($(this).val());
 	 $("#get_report").empty();
 var type = $(this).val();
 var url = "/transport_details/transport_report_index?type="+type
 $.get(url,function(data){
 	$("#report_index").empty();
 	$("#report_index").html(data);
 	
 })
 });
 
  $(document).on('change',"#route_report",function(event){
   var str = $(this).val();
 	 var url = "/transport_details/get_transport_report"
 	 var data={
 	 	'route' : str,
 	 	'board' : ""
 	 }
    $.get(url,data,function(data){
 	$("#get_report").empty();
 	$("#get_report").html(data);
 	configureTransportViewReport($(".transport_view_report"));
 	
 })
 });
 
 $(document).on('change',"#route_board_id",function(event){
  
 	 var str = $(this).val();
 	 var url = "/transport_details/get_transport_report"
 	 var data={
 	 	'route' : "",
 	 	'board' : str
 	 }
    $.get(url,data,function(data){
 	$("#get_report").empty();
 	$("#get_report").html(data);
 	configureTransportViewReport($(".transport_view_report"));
 })
 });
 
   $(document).on('change',"#board_route_report",function(event){
  $("#get_report").empty();
 	 var str = $(this).val();
 	 var url = "/transport_details/get_route_board?route="+str
    $.get(url,function(data){
 	$("#change_board").empty();
 	$("#change_board").html(data);
 	
 })
 });


 $("#transport_collection_student").on('click',function(event){
 	 $("#type_mode").val($(this).val());
 	 $("#collection").empty();
 var type = $(this).val();
 var url = "/transport_details/collection_index?type="+type
 $.get(url,function(data){
 	$("#collection_index").empty();
 	$("#collection_index").html(data);
 	
 })
 });

$("#transport_collection_employee").on('click',function(event){
 	 $("#type_mode").val($(this).val());
 	$("#collection").empty();
 var type = $(this).val();
 var url = "/transport_details/collection_index?type="+type
 $.get(url,function(data){
 	$("#collection_index").empty();
 	$("#collection_index").html(data);
 	
 })
 });
 
$(document).on('change',"#transport_fee_collection_course_id",function(event){
  
 	 var str = $(this).val();
 	 var url = "/transport_details/collection_batch?course_id="+str
    $.get(url,function(data){
 	$("#update_batch").empty();
 	$("#update_batch").html(data);
 	
 })
 });


$(document).on('change',"#transport_fee_collection_batch_id",function(event){
  var type = $("#type_mode").val();
 	 var str = $(this).val();
 	 var url = "/transport_details/get_transport_fee_collection"
 	 var data ={
 	 	'id' : str,
 	 	'type' : type
 	 }
 	 $("#collection").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
    $.get(url,data,function(data){
 	$("#collection").empty();
 	$("#collection").html(data);
 	configureStudentTransportFeeCollection($(".student_transport_fee_collection"))
 	
 })
 });
 
 $(document).on('change',"#fee_collection_department",function(event){
  var type = $("#type_mode").val();
 	 var str = $(this).val();
 	 var url = "/transport_details/get_transport_fee_collection"
 	 var data ={
 	 	'id' : str,
 	 	'type' : type
 	 }
 	 $("#collection").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
    $.get(url,data,function(data){
 	$("#collection").empty();
 	$("#collection").html(data);
 	configureStudentTransportFeeCollection($(".student_transport_fee_collection"))
 	
 })
 });
 

$(document).on("click","#collection_save",function(event){
		var type = $("#type_mode").val();
		var passengers=new Array();
		var fee_categories=new Array();
		var amounts=new Array();
		var discounts=new Array();
		$(".collection_checkbox").each(function(event){
			if ($(this).attr("checked")=="checked"){
				passengers.push($(this).attr("student"));
				fee_categories.push($(this).attr("fee_category"));
				amounts.push($(this).attr("amount"));
				discounts.push($(this).attr("discount"));
			}
		});
		var data ={
			"transport_fee_collection[passenger_id]" : passengers,
			"transport_fee_collection[transport_fee_category_id]" : fee_categories,
			"transport_fee_collection[amount]" : amounts,
			"transport_fee_collection[discount]" : discounts,
			"transport_fee_collection[passenger_type]" : type
		}
		if(passengers=="") {
			$('#outer_block').removeBlockMessages().blockMessage('Please select at least one passenger', {
					type : 'warning'
				});
				return false;
		}
		
		if(fee_categories == "") {
			$('#outer_block').removeBlockMessages().blockMessage('Please select transport fee category', {
					type : 'warning'
				});
				return false;
		}else{
			var target="/transport_fee_collections/"
			CreateTransportCollection(data,target);
		}
	});
 function setAmount(discount){
 	 
 	var collection_discount = discount.value;
 	var fee_actual_amounts = discount.id.replace('collection_discount', "fee_collection_category");
 	var cam=document.getElementById(fee_actual_amounts);
 	var select_value=$(cam).find("option:selected").attr("monthly_fee")
 	var fee_amount = discount.id.replace('collection_discount', "collection_amount");
 	var checkbox=discount.id.replace('collection_discount', "transport_fee_checkbox");
 	// var amount = document.getElementById(fee_amount); 
 	var collection_checked=document.getElementById(checkbox)
 		if (collection_discount!=0){
 	var payable_amount=parseFloat(select_value - (select_value * collection_discount / 100));
 	document.getElementById(fee_amount).value = payable_amount.toFixed(2);
 	collection_checked.setAttribute("amount",payable_amount.toFixed(2));
  collection_checked.setAttribute("discount",collection_discount);
}
  
 }
 
 function setFeeAmount(Fee_category){
 	var checkbox=Fee_category.id.replace('fee_collection_category', "transport_fee_checkbox");
 	var collection_amount_field = Fee_category.id.replace('fee_collection_category', "collection_amount");
 	var collection_discount_field = Fee_category.id.replace('fee_collection_category', "collection_discount");
 	var collection_discount = document.getElementById(collection_discount_field).value;
    var collection_amount = document.getElementById(collection_amount_field).value;
    var collection_checked=document.getElementById(checkbox)
    var fee_amount = $(Fee_category).find("option:selected").attr("monthly_fee");
  if (!fee_amount){
 	document.getElementById(collection_amount_field).value = 0;
 }else{
 	var payable_amount=parseFloat(fee_amount - (fee_amount * collection_discount / 100));
 	fee_amount = document.getElementById(collection_amount_field).value = payable_amount.toFixed(2);
 }
  collection_checked.setAttribute("amount",fee_amount);
  collection_checked.setAttribute("discount",collection_discount);
  collection_checked.setAttribute("fee_category",Fee_category.value);
 	
 }
 
 function checkClick(check){
 	if ($(check).attr('checked')=='checked'){
 		var student = $(check).attr('student');
 		var fee_category = $("#fee_collection_category_"+student).val();
 	    var amount=$("#collection_amount_"+student).val();
 	    var discount=$("#collection_discount_"+student).val();
 	    $(check).attr('amount',amount);
 	    $(check).attr('discount',discount);
 	    $(check).attr('fee_category',fee_category);
 	}

 };
 
 function CreateTransportCollection(data,target){
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
					var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
				
			}
			}
		});
 }
 function charactersLength() {
	var character_array=new Array();
	var classfield = null;
	
	$(".full-length").each(function() {
		if($(this).val().length >= 50) {
			classfield = false;
				field_name=$(this).attr('field_name')
			    character_array.push(classfield , field_name)
		}
	});
	return character_array;;
}
///
$(document).ready(function(event){
	$("#report_option").hide();
	// $("#report_option_collection").hide();
});
$(document).on("click","#report_option_basic",function(event){
	$("#report_option_collection").empty();
	$("#report_index").empty();
	$("#get_report").empty();
	$("#report_option").show();

});

$(document).on("click","#report_option_fee_collection",function(event){
	$("#report_option").hide();
	$("#report_index").empty();
	$("#get_report").empty();
	$.get("/transport_details/get_fee_collection_filter",function(data){
		 $("#report_option_collection").empty();
		   $("#report_option_collection").html(data);
		   $("#collection_date").datepick({
	alignment : 'bottom',
	showOtherMonths : true,
	selectOtherMonths : true,
	dateFormat : 'dd-mm-yyyy',
	yearRange : '1940:2100',
	renderer : {
		picker : '<div class="datepick block-border clearfix form"><div class="mini-calendar clearfix">' + '{months}</div></div>',
		monthRow : '{months}',
		month : '<div class="calendar-controls" style="white-space: nowrap">' + '{monthHeader:M yyyy}' + '</div>' + '<table cellspacing="0">' + '<thead>{weekHeader}</thead>' + '<tbody>{weeks}</tbody></table>',
		weekHeader : '<tr>{days}</tr>',
		dayHeader : '<th>{day}</th>',
		week : '<tr>{days}</tr>',
		day : '<td>{day}</td>',
		monthSelector : '.month',
		daySelector : 'td',
		rtlClass : 'rtl',
		multiClass : 'multi',
		defaultClass : 'default',
		selectedClass : 'selected',
		highlightedClass : 'highlight',
		todayClass : 'today',
		otherMonthClass : 'other-month',
		weekendClass : 'week-end',
		commandClass : 'calendar',
		commandLinkClass : 'button',
		disabledClass : 'unavailable',
		yearsRange : new Array(1971, 2100),
	}
		});   
	});
});


$(document).on("click","#view_collection_report",function(event){

	var passenger_type=$("#fee_collection_passenger_type").val();
	var fee_category=$("#fee_collection_fee_category").val();
	var date=$("#collection_date").val();
	var data={
		'passenger_type' : passenger_type,
		'fee_category' :fee_category,
		'date' :date
	}
	$.get("/transport_fee_collections/transport_fee_report",data,function(data){
		$("#get_report").html(data);
		   configureTransportFeeReport($(".transport_fee_report"))
	});
});