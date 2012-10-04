function configureFeesDetailOfStudentTable(tableNode) {
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

$('.feesDetailOfStudent').each(function(i) {
	configureFeesDetailOfStudentTable($(this));
});



function configureTransactionReportOfFinanceTable(tableNode) {
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
			sType : 'numeric'
		}],

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
	table.find('thead .sort-up').click(function(event) {
		event.preventDefault();
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		oTable.fnSort([[columnIndex, 'asc']]);
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		event.preventDefault();
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		oTable.fnSort([[columnIndex, 'desc']]);
		return false;
	});
};


$('.transactionDetails').each(function(i) {
	configureTransactionReportOfFinanceTable($(this));
});

function configureTransactionReportOfFinanceTablePerStudent(tableNode) {
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
			sType : 'numeric'
		},{
			sType : 'string'
		},{
			sType : 'string'
		}],

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
	table.find('thead .sort-up').click(function(event) {
		event.preventDefault();
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		oTable.fnSort([[columnIndex, 'asc']]);
		return false;
	});
	table.find('thead .sort-down').click(function(event) {
		event.preventDefault();
		var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		oTable.fnSort([[columnIndex, 'desc']]);
		return false;
	});
};


$('.transactionDetailsPerStudent').each(function(i) {
	configureTransactionReportOfFinanceTablePerStudent($(this));
});

function configureFeesSearchSubmissionStudentTable(tableNode) {
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


$('.feesSubmitSearchStudent').each(function(i) {
	configureFeesSearchSubmissionStudentTable($(this));
});

function configureFeesSubmissionStudentTable(tableNode) {
	var table = tableNode, oTable = table.dataTable({
		/*
		 * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 * @url http://www.datatables.net/usage/columns
		 */
		iDisplayLength : 100,
		aoColumns : [{
			bSortable : false
		}, // No sorting for this columns, as it only contains checkboxes
		{
			bSortable : false
		}, {
			bSortable : false
		}, {
			bSortable : false
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


$('.feesSubmitStudent').each(function(i) {
	configureFeesSubmissionStudentTable($(this));
});

function configureMaterFeesToBatchTable(tableNode) {
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
		}, {
			sType : 'string',sWidth : '10%'
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


$('.masterFeeBatchAssign').each(function(i) {
	configureMaterFeesToBatchTable($(this));
});


// function configureMaterFeesParticularToBatchTable(tableNode) {
	// var table = tableNode, oTable = table.dataTable({
		// /*
		 // * We set specific options for each columns here. Some columns contain raw data to enable correct sorting, so we convert it for display
		 // * @url http://www.datatables.net/usage/columns
		 // */
		// aoColumns : [{
			// bSortable : false
		// }, // No sorting for this columns, as it only contains checkboxes
		// {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }, {
			// sType : 'string'
		// }// No sorting for actions column
		// ],
		// /*
		 // * Set DOM structure for table controls
		 // * @url http://www.datatables.net/examples/basic_init/dom.html
		 // */
		// sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix"lf>',
		// /*
		 // * Callback to apply template setup
		 // */
		// fnDrawCallback : function() {
			// this.parent().applyTemplateSetup();
		// },
		// fnInitComplete : function() {
			// this.parent().applyTemplateSetup();
		// }
	// });
	// // Sorting arrows behaviour
	// table.find('thead .sort-up').click(function(event) {
		// // Stop link behaviour
		// event.preventDefault();
		// // Find column index
		// var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// // Send command
		// oTable.fnSort([[columnIndex, 'asc']]);
		// // Prevent bubbling
		// return false;
	// });
	// table.find('thead .sort-down').click(function(event) {
		// // Stop link behaviour
		// event.preventDefault();
		// // Find column index
		// var column = $(this).closest('th'), columnIndex = column.parent().children().index(column.get(0));
		// // Send command
		// oTable.fnSort([[columnIndex, 'desc']]);
		// // Prevent bubbling
		// return false;
	// });
// };
// 
// 
// $('.masterCategory_particular').each(function(i) {
	// configureMaterFeesParticularToBatchTable($(this));
// });


function configureFeeCollectionDateTable(tableNode) {
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
		sDom : '<"block-controls"<"controls-buttons"p>>rti<"block-footer clearfix no-margin"lf>',
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


$('.fee_collection_Lists').each(function(i) {
	configureFeeCollectionDateTable($(this));
});
$(document).on("click","#SaveMasterCategory",function(event){
	event.preventDefault();
	var category_name = $('#finance_fee_category_name').val();
	var description = $('#finance_fee_category_description').val();
	var allVals = []
	// var iChars = "!$%^*()+=[];{}:<>?";
		// for(var i = 0; i < category_name.length; i++) {
			// if(iChars.indexOf(category_name.charAt(i)) != -1) {
				// $('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Category Name', {
					// type : 'warning'
				// });
				// return false;
			// }
		// }
	if(!category_name || category_name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the Category Name', {
				type : 'warning'
			});
		return false;
	}
	if(!description || description.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the Description', {
				type : 'warning'
			});
		return false;
	}
	
	$('#batch_fee_master_id').each(function() {
		if ($(this).attr('selected','selected')){
			allVals.push($(this).val())
		}
    });
    if(allVals == "" || allVals == null) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select the Batch', {
				type : 'warning'
			});
		return false;
	}
    var data = {
			'finance_fee_category[name]' : category_name,
			'finance_fee_category[description]' : description,
			'batch_fee_master[id]' : allVals
		}
    $.post('master_category_create',data,function(data){
    	if (!data.errors || data.errors.length == 0){
    	$("#updateMasterCategoryList").empty();
    	$("#updateMasterCategoryList").html(data);
    	configureMaterFeesToBatchTable($('.masterFeeBatchAssign'));
		$('#batch_fee_master_id option').removeAttr('selected')
		$('#finance_fee_category_name').val("");
		$('#finance_fee_category_description').val("");
    	$('#outer_block').removeBlockMessages().blockMessage("Master category successfully created.", {
			type : 'success'
		});
		}else{
			// var errorText = getErrorText(data.errors);
				// $("#outer_block").removeBlockMessages().blockMessage(data.errors || 'An unexpected error occured, please try again', {
					// type : 'error'
				// });
				$("#outer_block").removeBlockMessages().blockMessage("Master Category can not be created" || 'An unexpected error occured, please try again', {
					type : 'error'
				});
		}
    });
});
$(document).on("click", 'a.delete-masterCategory-master-href', function(event) {
	// $('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = 'master_category_delete' + "/" + object_id;
	confirmMasterCategoryDelete(remoteUrl, table, row);
	return true;
});

$(document).on("click", 'a.update-masterCategory-master-href', function(event) {
	// resetMasterCategoryForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var des = $(this).attr('view_description')
	var batch = $(this).attr('view_batch').split(",");
	$('#finance_fee_category_name').val($('#master_category_name_' + object_id).html().replace(/&amp;/g, "&"));
	$('#finance_fee_category_description').val(des);
	$('#current_object_id').val(object_id);
		$('#batch_fee_master_id option').each(function(){
		    if(jQuery.inArray($(this).text(), batch) != -1){
		   	    $(this).attr('selected','selected')
		    }else{
		    	$(this).removeAttr('selected')
		    }
		});
	disableSelection();
	var name = table.attr("id");
	$("#batch_fee_master_id").attr("disabled", true);
    
  	$('#update_master_category').attr("class","");
	$('#update_master_category').attr("disabled", false);
	$('#SaveMasterCategory').attr("disabled", true);
	return false;
});
function disableSelection(){
	$("#selectionOfAllBatch").hide();
	$("#selectionOfNoneBatch").hide();
}
function enableSelection(){
	$("#selectionOfAllBatch").show();
    $("#selectionOfNoneBatch").show();
}

function resetMasterCategoryForm() {
	
	$('#finance_fee_category_name').val("");
	$('#finance_fee_category_description').val("");
	$('#batch_fee_master_id option').removeAttr('selected')
	$('#current_object_id').val("");
	$('#update_master_category').attr("disabled", true);
	$('#SaveMasterCategory').attr("disabled", false);
	$("#batch_fee_master_id").attr("disabled", false);
	// $('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
	enableSelection();
}

$(document).ready(function() {
	resetMasterCategoryForm();
	$('#reset_master_category').on('click', function(event) {
		resetMasterCategoryForm();
});
});


function confirmMasterCategoryDelete(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxMasterDelete(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxMasterDelete(remoteUrl, table, row) {
	// $.get(remoteUrl,function(data){
		// $("#updateMasterCategoryList").empty();
    	// $("#updateMasterCategoryList").html(data);
    	// configureMaterFeesToBatchTable($('.masterFeeBatchAssign'));
		// $('#batch_fee_master_id option').removeAttr('selected')
		// $('#finance_fee_category_name').val("");
		// $('#finance_fee_category_description').val("");
    	// $('#outer_block').removeBlockMessages().blockMessage("Master category deleted successfully.", {
			// type : 'success'
		// });
	// }).error(function(jqXHR, textStatus, errorThrown) { 
			        // window.location.href = "/signin"
	// });
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				var dataTable = table.dataTable();
				dataTable.fnDeleteRow(row.index());
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				
			} else {
				
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


$(document).ready(function() {
	$('#update_master_category').on('click', function(event) {
		var category_name = $('#finance_fee_category_name').val();
		var description = $('#finance_fee_category_description').val();
        // var iChars = "!$%^*()+=[];{}:<>?";
		// for(var i = 0; i < category_name.length; i++) {
			// if(iChars.indexOf(category_name.charAt(i)) != -1) {
				// $('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in Category Name', {
					// type : 'warning'
				// });
				// return false;
			// }
		// }
		if(!category_name || category_name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Master Category Name', {
				type : 'warning'
			});
		} else if(!description || description.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the description', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			
			// Target url
			var target = "master_category_update"+ "/" +current_object_id
			var allVals = []
				$('#batch_fee_master_id').each(function() {
					if ($(this).attr('selected','selected')){
						allVals.push($(this).val())
					}
			    });
			var data = {
				'finance_fee_category[name]' : category_name,
				'finance_fee_category[description]' : description,
				'batch_fee_master[id]' : allVals
			}
			 ajaxMasterUpdate(target, data, submitBt);
			 resetMasterCategoryForm();
		}
	});
});


function ajaxMasterUpdate(remoteUrl, data, row) {
	$.get(remoteUrl,data,function(data){
		$("#updateMasterCategoryList").empty();
    	$("#updateMasterCategoryList").html(data);
    	configureMaterFeesToBatchTable($('.masterFeeBatchAssign'));
		$('#batch_fee_master_id option').removeAttr('selected')
		$('#finance_fee_category_name').val("");
		$('#finance_fee_category_description').val("");
    	$('#outer_block').removeBlockMessages().blockMessage("Master category updated successfully.", {
			type : 'success'
		});
    $('#update_master_category').attr("class","");
	$('#update_master_category').attr("disabled", true);
	$('#SaveMasterCategory').attr("disabled", false);
	$("#batch_fee_master_id").attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
}

//==================================================Fee Collection New===================================// 



$(document).on("change", '#finance_fee_collection_fee_category_id', function(event) {
	var name = $("#finance_fee_collection_fee_category_id").val()
	if (!name ||name.length == 0){
				$("#changeBatchFeeCollection").empty()
	}else{
		$.get("fee_collection_batch_update", {id : name},function(data){
			$("#changeBatchFeeCollection").empty()
			$("#changeBatchFeeCollection").html(data)
		    $('#category_ids_id option').attr('selected','selected')
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});

	}
});


$(document).ready(function(event){
	$("#finance_fee_collection_fee_category_id").val("")
	$("#changeBatchFeeCollection").empty()
	$("#finance_fee_collection_name").val("")
});


$(document).on("click", '#save_fee_collection', function(event) {
	event.preventDefault();
	var category_ids = []
	$('#category_ids_id').each(function() {
		if ($(this).attr('selected','selected')){
			category_ids.push($(this).val())
		}
    });
    var category = $("#finance_fee_collection_fee_category_id").val();
    var collection_name = $("#finance_fee_collection_name").val();
    var start_date = $("#finance_fee_collection_start_date").val();  
    var end_date = $("#finance_fee_collection_end_date").val();
    var due_date = $("#finance_fee_collection_due_date").val();
    if(!category || category.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select the Category', {
				type : 'warning'
			});
			return false;
	}
	if(category_ids == "") {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select the Batch', {
				type : 'warning'
			});
			return false;
	}
	if(!collection_name || collection_name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter the Collection Name ', {
				type : 'warning'
			});
			return false;
	}
	var data = {
		'finance_fee_collection[start_date]' : start_date,
		'finance_fee_collection[name]' : collection_name,
		'finance_fee_collection[due_date]' : due_date,
		'finance_fee_collection[fee_category_id]' : category,
		'finance_fee_collection[end_date]' : end_date,
		'fee_collection[category_ids]' : category_ids
	}
	createFeeCollection(data)

});


function createFeeCollection(data){
	$.ajax({
		url : "fee_collection_create",
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
				$('#outer_block').removeBlockMessages().blockMessage(data.errors || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			var contentType = jqXHR.getResponseHeader("Content-Type");
		    if (jqXHR.status === 200 && contentType.toLowerCase().indexOf("text/html") >= 0) {
		        // assume that our login has expired - reload our current page
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

$(document).on("click", '#view_fee_collection', function(event) {
	event.preventDefault();
	 $.get('fee_collection_view',function(data){
		$.modal({
		content : data,
		title : 'Fee Collection Dates',
		height : 400,
		width : 700,
		buttons : {
			'Close' : function(win) {
				win.closeModal();
			}
		}
		});
	$.get('fee_collection_dates_batch', function(data){
		$("#fee_collection_dates").empty();
		$("#fee_collection_dates").html(data);
	    configureFeeCollectionDateTable($('.fee_collection_Lists'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
	$("#outer_block").removeBlockMessages();
});

$(document).on("change", '#fee_colection_course_id', function(event) {
	var course_id = $("#fee_colection_course_id").val();
	$.get("fee_collection_view?id="+ course_id,function(data){
		$("#change_fee_collection_batch").empty();
		$("#change_fee_collection_batch").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});


$(document).on("change", '#batch_fee_id', function(event) {
	var batch_id= $(this).val()
	if(batch_id == ""){
		$.get('fee_collection_dates_batch', function(data){
			$("#fee_collection_dates").empty();
			$("#fee_collection_dates").html(data);
		    configureFeeCollectionDateTable($('.fee_collection_Lists'));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
	}else{
		$.get('fee_collection_dates_batch?id='+ batch_id, function(data){
			$("#fee_collection_dates").empty();
			$("#fee_collection_dates").html(data);
		    configureFeeCollectionDateTable($('.fee_collection_Lists'));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
	}
});

$(document).on("click", 'a.delete-feeCollect-master-href', function(event) {
	// $('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = 'fee_collection_delete' + "/" + object_id;
	confirmMasterFeeCollectionDelete(remoteUrl, table, row);
	return true;
});

function confirmMasterFeeCollectionDelete(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxMasterFeeCollectionDelete(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxMasterFeeCollectionDelete(remoteUrl, table, row) {

	$.get(remoteUrl,function(data){
		$("#fee_collection_dates").empty();
		$("#fee_collection_dates").html(data);
		configureFeeCollectionDateTable($('.fee_collection_Lists'));
		$('#modal #outer_block').removeBlockMessages().blockMessage('Successfully Deleted Fee Collection', {
			type : 'success'
		});
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
}

$(document).on("click", 'a.update-feeCollect-master-href', function(event) {
	// $('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = 'fee_collection_edit' + "/" + object_id;
	editMasterFeeCollection(remoteUrl, table, row, object_id);
	return true;
});

function editMasterFeeCollection(remoteUrl, table, row, object_id){
	
	$.get(remoteUrl ,function(data){
		$.modal({
		content : data,
		title : 'Edit Fee Collection',
		height : 400,
		width : 700,
		buttons : {
			'Update' : function(win) {
				var collection_name = $("#modal #finance_fee_collection_name").val()
				var start_date = $("#finance_fee_collection_start_date_edit").val()
				var end_date = $("#finance_fee_collection_end_date_edit").val()
				var due_date = $("#finance_fee_collection_due_date_edit").val()
				var data = {
					'finance_fee_collection[start_date]' : start_date,
					'finance_fee_collection[name]' : collection_name,
					'finance_fee_collection[due_date]' : due_date,
					'finance_fee_collection[end_date]' : end_date,
					'id' : object_id
				}
				updateFeeCollection(data);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	modal_box_datepicker();
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});

}

function updateFeeCollection(data){
	var batch_id = $('#batch_fee_id').val();
	$.get("fee_collection_update",data,function(data){
		if (data.errors == null){
		    $("#fee_collection_dates").empty();
		    $("#fee_collection_dates").html(data);
			configureFeeCollectionDateTable($('.fee_collection_Lists'));
			$('#modal #outer_block').removeBlockMessages().blockMessage("Successfully Updated Fee Collection", {
			 type : 'success'
			});
		}else{
			// $.get('fee_collection_dates_batch?id=' + batch_id, function(data){
				// $("#fee_collection_dates").empty();
				// $("#fee_collection_dates").html(data);
			    // configureFeeCollectionDateTable($('.fee_collection_Lists'));
			// }).error(function(jqXHR, textStatus, errorThrown) { 
			        // window.location.href = "/signin"
			// });
			var errorText = getErrorText(data.errors);
			$('#modal #outer_block').removeBlockMessages().blockMessage(errorText, {
			 type : 'error'
			});
		}
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
}




//=============================================Fee Submission=====================================//


$(document).ready(function () {
        $('#fees_submission_batch').show();
        $('#fees_student_search').show();
});

$(document).on("click" ,"#fees_submission_batch", function(event){
	event.preventDefault();
	$.get("fees_submission_batch",function(data){
		$("#asPerRequirement").empty();
		$("#asPerRequirement").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});

$(document).on("change" ,"#fees_submission_course_id", function(event){
	$("#studentFeeSubmission").empty();
	$.get("update_fees_collection_dates?batch_id=",function(data){
			$("#fees_collection_datesID").empty();
			$("#fees_collection_datesID").html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
				        window.location.href = "/signin"
	});
	var id = $(this).val();
	if(id.length!= 0){
	$.get("assign_batch?id="+id,function(data){
		$("#change_feesbatch").empty();
		$("#change_feesbatch").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
	}else{
		$.get("assign_batch?id="+id,function(data){
			$("#change_feesbatch").empty();
			$("#change_feesbatch").html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
				        window.location.href = "/signin"
		});
		$.get("update_fees_collection_dates?batch_id=",function(data){
			$("#fees_collection_datesID").empty();
			$("#fees_collection_datesID").html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
				        window.location.href = "/signin"
		});	
		$("#studentFeeSubmission").empty();
	}
});
// update_fees_collection_dates

$(document).on("change" ,"#fees_submission_batch_id", function(event){
	$("#studentFeeSubmission").empty();
	var id = $(this).val();
	if(id.length!= 0){
	$.get("update_fees_collection_dates?batch_id="+id,function(data){
		$("#fees_collection_datesID").empty();
		$("#fees_collection_datesID").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
	}else{
		$("#studentFeeSubmission").empty();
		$.get("update_fees_collection_dates?batch_id=",function(data){
			$("#fees_collection_datesID").empty();
			$("#fees_collection_datesID").html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
				        window.location.href = "/signin"
		});
	}	
});

$(document).on("change" ,"#fees_submission_dates_id", function(event){
	var batch_id = $("#fees_submission_batch_id").val();
	var id = $(this).val();
	if (id!= "" && id!= null && id.length!= 0){
	$.get("load_fees_submission_batch", {batch_id: batch_id , date: id}, function(data){
		$("#studentFeeSubmission").empty();
		$("#studentFeeSubmission").html(data);
		configureFeesSubmissionStudentTable($(".feesSubmitStudent"));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
	}else{
		$("#studentFeeSubmission").empty();
	}	
});

$(document).on("click" ,".nextPayFee", function(event){
	event.preventDefault();
	var batch_id = $(this).attr('batch_id');
	var date = $(this).attr('date');
	var student = $(this).attr('student');
	$.get("load_fees_submission_batch",{batch_id: batch_id, date: date, student: student},function(data){
		$("#studentFeeSubmission").empty();
		$("#studentFeeSubmission").html(data);
		configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});
$(document).on("click" ,".prevPayFee", function(event){
	event.preventDefault();
	var batch_id = $(this).attr('batch_id');
	var date = $(this).attr('date');
	var student = $(this).attr('student');
	$.get("load_fees_submission_batch",{batch_id: batch_id, date: date, student: student},function(data){
		$("#studentFeeSubmission").empty();
		$("#studentFeeSubmission").html(data);
		configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});

 // {"commit"=>"Add Fine", "action"=>"update_fine_ajax", "authenticity_token"=>"GUguP9WTwPjWCuO/Tkq/tctYJbr0Wwzp
// oFB5uEwQArQ=", "fine"=>{"batch_id"=>"3", "date"=>"22", "fee"=>"10", "student"=>"3"}, "controller"=>"finance"}
$(document).on("click" , "#add_fine_to_fees", function(event){
	event.preventDefault();
	var batch_id = document.getElementById('fine_fees_for_batch_id').value;
	var date = document.getElementById('fine_fees_for_date').value;
	var student = document.getElementById('fine_fees_for_student').value;
	var fee = $("#fine_fee").val();
	if(fee != 0) {
			if(isNaN(fee) || fee.indexOf(" ") != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Numeric Value', {
					type : 'warning'
				});
				return false;
			}
	}
	var inputData = {
		'fine[batch_id]' : batch_id,
		'fine[date]' : date,
		'fine[fee]' : fee,
		'fine[student]' : student,
	}
	$.post("update_fine_ajax",inputData,function(data){
		$("#studentFeeSubmission").empty();
		$("#studentFeeSubmission").html(data);
	    configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});

$(document).on("click" ,"#payStudenFees", function(event){
	event.preventDefault();
	var batch_id = $(this).attr('batch_id');
	var date = $(this).attr('date');
	var student = $(this).attr('student');
	var fees = $("#fees_fees_paid").val();
	var fine  = $(this).attr('fine');
	if(fees != 0) {
			if(isNaN(fees) || fees.indexOf(" ") != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Numeric Value', {
					type : 'warning'
				});
				return false;
				
			}
	}

	var total_fees = document.getElementById('total_fees').value;
	$.get("update_ajax",{batch_id: batch_id, date: date, student: student,fees: {fees_paid: fees}, total_fees: total_fees,fine : fine},function(data){
		if(data.valid == null){
		$("#studentFeeSubmission").empty();
		$("#studentFeeSubmission").html(data);
		$('#outer_block').removeBlockMessages().blockMessage('Fees Submitted Successfully', {
				type : 'success'
			});
			configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
		}else{
			var errorText = getErrorText(data.errors);
					$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
						type : 'error'
			});
		}
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});

$(document).on("click" ,"#fees_student_search", function(event){
	event.preventDefault();
	$.get("fees_student_search",function(data){
		$("#asPerRequirement").empty();
		$("#asPerRequirement").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});

$(document).on("keyup","#studentFeequery",function(event) {
	var search = $('#studentFeequery').val();
	var url = "search_logic?query=" + search
	if(search.length >= 3) {
		$("#information").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(url, function(data) {
			$('#information').empty();
			$('#information').html(data);
			configureFeesSearchSubmissionStudentTable($('.feesSubmitSearchStudent'));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
	} else {
		$('#information').empty();
		$('#information').html();
	}
});

$(document).on("click","#feeStudentDates",function(event) {
	event.preventDefault();
	var id= $(this).attr('studentId');
	$.get("fees_student_dates?id="+id,function(data){
		$.modal({
		content : data,
		title : 'Fees Submission',
		height : 400,
		width : 800,
		buttons : {
			'Pay Fees' : function(win) {
				if($("#fees_submission_student_dates_id").val()==""){
				$('#modal #outer_block').removeBlockMessages().blockMessage('Please Select Fees Collection Date', {
					type : 'warning'
				});
				return false;
				}else{
				payStudentSezrchFees()
				}	
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
	
});


$(document).on("change","#fees_submission_student_dates_id",function(event) {
	event.preventDefault();
	var ids= $(this).val();
	var student_id = document.getElementById('getStudentID').value
	$.get("fees_submission_student",{date: ids, id: student_id},function(data){
		$("#fee_submission").empty();
		$("#fee_submission").html(data);
		configureFeesSubmissionStudentTable($(".feesSubmitStudent"));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
});

$(document).on("click","#modal #add_fine_of_student_to_fees",function(event) {
	event.preventDefault();
	var date = document.getElementById('fine_fees_for_selected_date').value;
	var student = document.getElementById('fine_fees_for_select_student').value;
	var fee = $("#fine_fee").val();
	if(fee != 0) {
			if(isNaN(fee) || fee.indexOf(" ") != -1) {
				$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Numeric Value', {
					type : 'warning'
				});
				return false;
			}
	}
	var inputData = {
		'fine[date]' : date,
		'fine[fee]' : fee,
		'fine[student]' : student,
	}
	$.post("update_student_fine_ajax",inputData,function(data){
		$("#fee_submission").empty();
		$("#fee_submission").html(data);
	    configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
	
});

function payStudentSezrchFees(){
	var date = $("#payStudenFeesSearch").attr('date');
	var student = $("#payStudenFeesSearch").attr('student');
	var fees = $("#fees_fees_paid").val();
	var fine = $("#payStudenFeesSearch").attr('fine');
	if(fees != 0) {
			if(isNaN(fees) || fees.indexOf(" ") != -1) {
				$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Numeric Value', {
					type : 'warning'
				});
				return false;
				
			}
	}
	var total_fees = document.getElementById('total_fees').value;
	var data = {
					'date' : date,
					'student' : student,
					'fine' :fine,
					'fees[fees_paid]' : fees,
					'total_fees' : total_fees
				}
	$.ajax({
			url : "fees_submission_save",
			dataType : 'json',
			data : data,
			type : 'POST',
			success : function(data) {
				if(data.valid) {	
					var student_id = document.getElementById('getStudentID').value
					$.get("fees_submission_student",{date: date, id: student_id},function(data){			
						$("#fee_submission").empty();
						$("#fee_submission").html(data);		
						configureFeesSubmissionStudentTable($(".feesSubmitStudent"));
						$('#modal #outer_block').removeBlockMessages().blockMessage('Fees Submitted Successfully', {
								type : 'success'
						});
					}).error(function(jqXHR, textStatus, errorThrown) { 
						        window.location.href = "/signin"
					});
				}else {
					var errorText = getErrorText(data.errors);
					alert("dfd")
					$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
						type : 'error'
					});
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			var contentType = jqXHR.getResponseHeader("Content-Type");
		    if (jqXHR.status === 200 && contentType.toLowerCase().indexOf("text/html") >= 0) {
		        // assume that our login has expired - reload our current page
		        window.location.href = "/signin"
		    }else{
			$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
				type : 'error'
			});	
			}	
		}
		});

}



//############################################## FEES STRUCTURE ##################################################### //

$('#fee_structure_search_query').keyup(function() {
	var search = $('#fee_structure_search_query').val();
	var url = "/finance/fees_student_structure_search_logic" + '?query=' + search
	var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
    var special_character = isSpclChar();
	if(search.length >= 3) {
		for(var i = 0; i < search.length; i++) {
			if(iChars.indexOf(search.charAt(i)) != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Special character are not allowed in Search Field', {
						type : 'warning'
					});
			     return false;
			}else{
				$('#outer_block').removeBlockMessages();
			}
		}
		$("#feesStudentStructureSearchLogic").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(url,function(data) {
			$('#feesStudentStructureSearchLogic').empty();
			$('#feesStudentStructureSearchLogic').html(data);
			configureFeesStructureStudentDetailTable($("#feeStructureStudentTable"));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	} else {
		$('#feesStudentStructureSearchLogic').empty();
		$('#feesStudentStructureSearchLogic').html();
	}
});

$(document).on("ready", function(event){
	$("#fees_submission_detail_dates_id").val("");
	$("#fees_defaulters_course_id").val("");
});

function fee_structure_for_student(student_id,select_tag){
	var input_data = {
		'date' : select_tag.value,
		'id' : student_id
	}
	var url ="/finance/fees_structure_for_student";
	$.get(url,  input_data , function(data) {
			$('#fees_structure_Of_Student').empty();
			$('#fees_structure_Of_Student').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
}

function configureFeesStructureStudentDetailTable(tableNode) {
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
		}, {
			sType : 'string'
		}, {
			sType : 'string'
		}, {
			sType : 'numeric'
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

$('#feeStructureStudentTable').each(function(i) {
	configureFeesStructureStudentDetailTable($(this));
});



//########################################################## FEES DEFAULTER ##################################################//


$(document).on("change", "#fees_defaulters_course_id", function(event){
	event.preventDefault();
	$('#student_defaulters').empty();
	var id = $(this).val();
	$.get("/finance/update_fees_collection_batch_defaulters/" + id, function(data) {
			$('#changeFeesDefaulterBatchID').empty();
			$('#changeFeesDefaulterBatchID').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	$.get("/finance/update_fees_collection_dates_defaulters" , {batch_id : null}, function(data) {
			$('#changeFeesDefaulterCollectionDate').empty();
			$('#changeFeesDefaulterCollectionDate').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});	
});


$(document).on("change", "#student_defaulters_batch_id", function(event){
	event.preventDefault();
	$('#student_defaulters').empty();
	var batch_id = $(this).val();
	$.get("/finance/update_fees_collection_dates_defaulters" , {batch_id : batch_id}, function(data) {
			$('#changeFeesDefaulterCollectionDate').empty();
			$('#changeFeesDefaulterCollectionDate').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
});

$(document).on("change", "#fees_defaulters_dates_id", function(event){
	event.preventDefault();
	var date_id = $(this).val();
	var batch_id =  $("#student_defaulters_batch_id").val();
	$("#student_defaulters").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	if(date_id == ""){
		$('#student_defaulters').empty();
		return false;
	}
	$.get("/finance/fees_defaulters_students" , {batch_id : batch_id , date : date_id}, function(data) {
			$('#student_defaulters').empty();
			$('#student_defaulters').html(data);
			configureStudentDefaultersListTable($('.studentDefaulterList'));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
});

function configureStudentDefaultersListTable(tableNode) {
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
		}, {
			sType : 'string'
		}, {
			bSortable : false
		}
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

$('.studentDefaulterList').each(function(i) {
	configureStudentDefaultersListTable($(this));
});


//############################################################# DEFAULTER FEES ###################################################//

$(document).on("click", "#add_fine_to_fees_defaulter", function(event){
event.preventDefault();
	var date = $('#fine_fees_for_defaulter_date').val();
	var student = $('#fine_fees_for_defaulter_student').val();
	var fee = $("#fine_fee").val();
	if(fee != 0) {
			if(isNaN(fee) || fee.indexOf(" ") != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Numeric Value', {
					type : 'warning'
				});
				return false;
			}
	}
	var inputData = {
		'fine[date]' : date,
		'fine[fee]' : fee,
		'fine[student]' : student
	}
	$.ajax({
		url : "/finance/update_defaulters_fine_ajax",
		type : 'get',
		dataType : 'json',
		data : inputData,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				var input_Data = {
					'date' : data.date,
					'id' : data.id,
					'fine' :data.fine
				}
				$.get("/finance/pay_fees_defaulters_after_adding_fine",input_Data,function(succes_data){
					$("#feesSubmitStudentChangeFine").empty();
					$("#feesSubmitStudentChangeFine").html(succes_data);
				    configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
				}).error(function(jqXHR, textStatus, errorThrown) { 
						        window.location.href = "/signin"
				});	
			} else {	
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
		},
		complete : function(jqXHR, textStatus, errorThrown) {
			$("#fine_fee").val("");
		}
	});
});

$(document).on("click" ,"#payStudentDefaulterFees", function(event){
	event.preventDefault();
	var batch_id = $(this).attr('batch_id');
	var date = $(this).attr('date');
	var student = $(this).attr('student');
	var fees = $("#fees_fees_paid").val();
	var fine  = $(this).attr('fine');
	if(fees != 0) {
			if(isNaN(fees) || fees.indexOf(" ") != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Numeric Value', {
					type : 'warning'
				});
				return false;
				
			}
	}

	var total_fees = document.getElementById('total_fees').value;
	$.post("/finance/pay_fees_defaulters_fine",{batch_id: batch_id, date: date, id: student,fees: {fees_paid: fees}, total_fees: total_fees,fine : fine},function(data){
		$("#feesSubmitStudentChangeFine").empty();
		$("#feesSubmitStudentChangeFine").html(data);
			configureFeesSubmissionStudentTable($('.feesSubmitStudent'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	}).complete(function(jqXHR){
		$('#outer_block').removeBlockMessages().blockMessage('Fees Submitted Successfully', {
				type : 'success'
			});
	});
});
