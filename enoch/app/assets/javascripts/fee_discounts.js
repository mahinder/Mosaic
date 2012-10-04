$(document).on("ready", function(event){
	$("#fees_discount_course_id").val("");
});

$(document).on("change", "#fees_discount_course_id", function(event){
	event.preventDefault();
	var course_id = $(this).val();
	$.get("/finance/load_discount_batch" , {id : course_id}, function(data){
		$("#feeDiscountBatch").empty();
		$("#createdFeesDiscount").empty();
		$("#feeDiscountBatch").html(data);
		$("#feeDiscountMasterCategory").hide();
	}).error(function(jqXHR, textStatus, errorThrown) { 
		window.location.href = "/signin"
	})
});

$(document).on("change", "#fees_discount_batch_id", function(event){
	event.preventDefault();
	var batch_id = $(this).val();
	$.get("/finance/update_master_fee_category_list" , {id : batch_id}, function(data){
		$("#feeDiscountMasterCategory").show();
		$("#feeDiscountMasterCategory").empty();
		$("#createdFeesDiscount").empty();
		$("#feeDiscountMasterCategory").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
		window.location.href = "/signin"
	})
});

$(document).on("change", "#master_fee_discount_category_id", function(event){
	event.preventDefault();
	var category_id = $(this).val();
	var batch_id = $("#fees_discount_batch_id").val();
	$.get("/finance/show_fee_discounts" , {id : category_id, batch_id : batch_id}, function(data){
		$("#createdFeesDiscount").empty();
		$("#createdFeesDiscount").html(data);
		configureMasterCategoryFeeDiscountTable($(".masterFeeDiscountCreation"));
	}).error(function(jqXHR, textStatus, errorThrown) { 
		window.location.href = "/signin"
	})
});

$(document).on("click", "#createFeesDiscount", function(event){
	event.preventDefault();
	var category_id = $("#master_fee_discount_category_id").val();
	$.get("/finance/fee_discount_new" , {id : category_id}, function(data){
		openDiscountCreationForm(data)
	}).error(function(jqXHR, textStatus, errorThrown) { 
		window.location.href = "/signin"
	})
});

function openDiscountCreationForm(data){
	$.modal({
		content : data,
		title : 'Create Discount',
		width : 700,
		height : 280,
		buttons : {
			'Create' : function(win) {
				var b_id = $("#modal #fee_discount_fee_discount_batch_name").val();
				var cat_id = $("#modal #fee_discount_fee_discount_masterCategory_name").val();
				var discount_name = $("#modal #fee_discount_name").val();
				var discount = $("#modal #fee_discount_discount").val();
				var student_category = $("#modal #fee_discount_receiver_id").val();
				var discount_type = $("#modal #fees_discount_type_id").val();
				var inputData ={
					'fee_discount[name]' : discount_name,
					'fee_discount[discount]' : discount,
					'fee_discount[receiver_id]' : student_category,
					'batch_id' : b_id,
					'discount_type' : discount_type,
					'master_category_id' : cat_id
 				}
				validFeeDiscountCreate(inputData,win);
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
}

$(document).on("change", "#fees_discount_type_id", function(event){
	event.preventDefault();
	var discount_type = $(this).val();
	var batch_id = $("#fees_discount_batch_id").val();
	var category_id = $("#master_fee_discount_category_id").val();
	var inputData = {
		'type' : discount_type,
		'batch_id' : batch_id,
		'category_id' : category_id
	}
	$.get("/finance/load_discount_create_form" , inputData, function(data){
		$("#DiscountFormAsPerType").empty();
		$("#DiscountFormAsPerType").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
		window.location.href = "/signin"
	})
});

function validFeeDiscountCreate(inputData,win){
	var target =""
	var b_id = $("#modal #fee_discount_fee_discount_batch_name").val();
	var cat_id = $("#modal #fee_discount_fee_discount_masterCategory_name").val();
	var discount_name = $("#modal #fee_discount_name").val();
	var discount = $("#modal #fee_discount_discount").val();
	var discount_type = $("#modal #fees_discount_type_id").val();
	var student_adm_no = $("#modal #students").val();
	var inputDataForStudent ={
		'fee_discount[name]' : discount_name,
		'fee_discount[discount]' : discount,
		'fee_discount[finance_fee_category_id]' : cat_id,
		'students' : student_adm_no,
		'batch_id' : b_id,
		'discount_type' : discount_type,
		'master_category_id' : cat_id
 	}
	if (inputData.discount_type == "batch_wise"){
		target = "/finance/batch_wise_discount_create"
		createFeesDiscountForBatchAndCategory(inputData,target,win);
	}else if(inputData.discount_type == "category_wise"){
		target = "/finance/category_wise_fee_discount_create"
		createFeesDiscountForBatchAndCategory(inputData,target,win);
	}else if(inputData.discount_type == "student_wise"){
		target = "/finance/student_wise_fee_discount_create"
		createFeesDiscountForStudents(inputDataForStudent,target,win)
	}
}

function createFeesDiscountForBatchAndCategory(inputData,target,win){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : inputData,
		success : function(success_data, textStatus, jqXHR) {
			if(success_data.valid) {
				$.get("/finance/show_fee_discounts" , {id : inputData.master_category_id, batch_id : inputData.batch_id}, function(data){
					$("#createdFeesDiscount").empty();
					$("#createdFeesDiscount").html(data);
					configureMasterCategoryFeeDiscountTable($(".masterFeeDiscountCreation"));
				}).error(function(jqXHR, textStatus, errorThrown) { 
					window.location.href = "/signin"
				}).complete(function(jqXHR){
					win.closeModal();
					$('#outer_block').removeBlockMessages().blockMessage(success_data.notice, {
						type : 'success'
					});
					
				});
				
			} else {
				// Message
				var errorText = getErrorText(success_data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
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

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}
function createFeesDiscountForStudents(inputDataForStudent,target,win){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : inputDataForStudent,
		success : function(success_data, textStatus, jqXHR) {
			if(success_data.valid) {
				$.get("/finance/show_fee_discounts" , {id : inputDataForStudent.master_category_id, batch_id : inputDataForStudent.batch_id}, function(data){
					$("#createdFeesDiscount").empty();
					$("#createdFeesDiscount").html(data);
					configureMasterCategoryFeeDiscountTable($(".masterFeeDiscountCreation"));
				}).error(function(jqXHR, textStatus, errorThrown) { 
					window.location.href = "/signin"
				}).complete(function(jqXHR){
					win.closeModal();
					$('#outer_block').removeBlockMessages().blockMessage(success_data.notice, {
						type : 'success'
					});
					
				});
				
			} else {
				// Message
				var errorText = getErrorText(success_data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
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

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}

$(document).on("click", ".delete-fee-discount-master-href" , function(event){
	event.preventDefault();
	var id = $(this).attr("id");
	var batch_id = $(this).attr("batch_id");
	var category_id = $(this).attr("category_id");
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				var target = "/finance/delete_fee_discount"
				var input_data = {
					'id' : id
				}
				ajaxDeleteFeesDiscount(target,id,batch_id,category_id,win,input_data);
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
});

function ajaxDeleteFeesDiscount(target,id,batch_id,category_id,win,input_data){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : input_data,
		success : function(success_data, textStatus, jqXHR) {
			if(success_data.valid) {
				$.get("/finance/show_fee_discounts" , {id : category_id, batch_id : batch_id}, function(data){
					$("#createdFeesDiscount").empty();
					$("#createdFeesDiscount").html(data);
					configureMasterCategoryFeeDiscountTable($(".masterFeeDiscountCreation"));
				}).error(function(jqXHR, textStatus, errorThrown) { 
					window.location.href = "/signin"
				}).complete(function(jqXHR){
					win.closeModal();
					$('#outer_block').removeBlockMessages().blockMessage(success_data.notice, {
						type : 'success'
					});
				});
			} else {
				// Message
				var errorText = getErrorText(success_data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
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
	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

$(document).on("click", ".update-fee-discount-master-href" , function(event){
	event.preventDefault();
	var id = $(this).attr("id");
	var batch_id = $(this).attr("batch_id");
	var category_id = $(this).attr("category_id");
	$.get("/finance/edit_fee_discount" , {id : id}, function(data){
		editFeesDiscount(data,id,batch_id,category_id)
	}).error(function(jqXHR, textStatus, errorThrown) { 
		window.location.href = "/signin"
	}).complete(function(jqXHR){

	});
});

function editFeesDiscount(data,id,batch_id,category_id){
	$.modal({
		content : data,
		title : 'Edit Discount',
		width : 500,
		height : 150,
		buttons : {
			'Update' : function(win) {
				var fees_discount = $("#modal #fee_discount_discount").val();
				var inputData = {
					'fee_discount[discount]' : fees_discount,
					'id' : id
				}
				var target = "/finance/update_fee_discount"
				updateFeesDiscount(target,inputData,id, win,batch_id,category_id)
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
}

function updateFeesDiscount(target,inputData,id, win,batch_id,category_id){
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : inputData,
		success : function(success_data, textStatus, jqXHR) {
			if(success_data.valid) {
				$.get("/finance/show_fee_discounts" , {id : category_id, batch_id : batch_id}, function(data){
					$("#createdFeesDiscount").empty();
					$("#createdFeesDiscount").html(data);
					configureMasterCategoryFeeDiscountTable($(".masterFeeDiscountCreation"));
				}).error(function(jqXHR, textStatus, errorThrown) { 
					window.location.href = "/signin"
				}).complete(function(jqXHR){
					win.closeModal();
					$('#outer_block').removeBlockMessages().blockMessage(success_data.notice, {
						type : 'success'
					});
				});
			} else {
				// Message
				var errorText = getErrorText(success_data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
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
	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

function configureMasterCategoryFeeDiscountTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		// aoColumns : [{
			// bSortable : false
		// }, // No sorting for this columns, as it only contains checkboxes
		// {
			// sType : 'string'
		// }, {
			// bSortable : false
		// }// No sorting for actions column
		// ],

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


$('.masterFeeDiscountCreation').each(function(i) {
	configureMasterCategoryFeeDiscountTable($(this));
});