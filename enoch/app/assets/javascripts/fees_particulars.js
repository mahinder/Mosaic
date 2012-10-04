$(document).on("ready",function(event){
	$(document).on("click", 'a.add_particular-masterCategory-master-href', function(event) {
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var remoteUrl = 'fees_particulars_new'+ "/" + object_id;
		var fees_name  = aLink.attr('fees_name');
		getFeeParticularForm(remoteUrl,object_id);	
	});
});
function getFeeParticularForm(remoteUrl,object_id){
	$.get(remoteUrl,function(data){
		$("#changeCategoryToParticular").empty();
		$("#changeCategoryToParticular").html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	}).complete(function() { resetFieldAfterClick(object_id); });	
}
function resetFieldAfterClick(object_id){
	resetMasterCategoryPaticularForm();
	resetRadioButton();
	resetPreviousSessionDropDown();
	getParticularsOfMasterCategory(object_id)	
}

function resetMasterCategoryPaticularForm() {
    $('#particulars_select_all').prop('checked', true);
	resetParticularFormField();
	$('#current_object_id').val("");
	$('#update_masterParticular_category').attr("disabled", true);
	$('#msaterFeeParticularCreate').attr("disabled", false);
	$("#replaceParticularsFor").empty();
	$('#replaceParticularsFor').show();
	$("#showPreviuosMasterCategory").empty();
	$("#previous_master_category").val("");
	$('#previous_master_category').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	enabledForPreviousSelection();
}
function getParticularsOfMasterCategory(object_id){
	$("#showPreviuosMasterCategory").hide();	
	$("#previousSession").val("");
	get_previous_master_data()
	var id = object_id;
        if(id== "" || id == null || id.length == 0){
        	$("#showPreviuosMasterCategory").hide();
        }
		$.get("master_category_particulars?id="+ id, function(data){
			  updateParticularList(data);
		      $('#particulars_select_all').prop('checked', true);
				resetParticularFormField();
				$('#current_object_id').val("");
				$('#update_masterParticular_category').attr("disabled", true);
				$('#msaterFeeParticularCreate').attr("disabled", false);
				$("#replaceParticularsFor").empty();
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
}
function replaceFieldWithRadioButton(data){
	$("#replaceParticularsFor").empty();
	$("#replaceParticularsFor").html(data);
}
$(document).on("click" , "#particulars_select_all", function(event){
	var select_value = $(this).val()
	$.get("student_or_student_category?select_value="+select_value , function(data){
		replaceFieldWithRadioButton(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});
$(document).on("click" , "#particulars_select_student", function(event){
	var select_value = $(this).val()
	$.get("student_or_student_category?select_value="+select_value , function(data){
		replaceFieldWithRadioButton(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});
$(document).on("click" , "#particulars_select_category", function(event){
	var select_value = $(this).val()
	$.get("student_or_student_category?select_value="+select_value , function(data){
		replaceFieldWithRadioButton(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});	
});

$(document).on("change","#previousSession",function(event){
	var id  = $("#previousSession").val();
	if(id== "" || id==null || id.length == 0){
		enabledForPreviousSelection();
	}
    	$.get("get_previous_master_category?id="+ id, function(data){
			resetPreviousMasterCategoryData(data)
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
		$("#showPreviuosMasterCategory").empty();
});


$(document).on("change", "#previous_master_category", function(event){
	var id  = $(this).val();
	if(id == "" || id == null || id.length == 0){
		$("#showPreviuosMasterCategory").hide();
		enabledForPreviousSelection();
	}else{
		diabledForPreviousSelection();
		$.get("show_master_categories_list?id="+id , function(data){
			$("#showPreviuosMasterCategory").show();
			$("#showPreviuosMasterCategory").empty();
			$("#showPreviuosMasterCategory").html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
	}
});

$(document).on("click" , "#reset_masterParticular_category", function(event){
		var id = document.getElementById('finance_fee_particulars_finance_fee_category_id').value;
		$("#showPreviuosMasterCategory").hide();
		$.get("master_category_particulars?id="+id, function(data){
			updateParticularList(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
	get_previous_master_data();
	resetMasterCategoryPaticularForm();
	resetRadioButton();
	resetPreviousSessionDropDown();
});
function diabledForPreviousSelection(){
	resetParticularFormField();
	$("#finance_fee_particulars_name").attr('disabled',true)
	$("#finance_fee_particulars_amount").attr('disabled',true)
	$("#finance_fee_particulars_description").attr('disabled',true)
}
function enabledForPreviousSelection(){
	$("#finance_fee_particulars_name").attr('disabled',false)
	$("#finance_fee_particulars_amount").attr('disabled',false)
	$("#finance_fee_particulars_description").attr('disabled',false)
}

function get_previous_master_data(){
	var id  = "";
	 $.get("get_previous_master_category?id="+ id, function(data){
			resetPreviousMasterCategoryData(data);
	 }).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	 });   
}
function refreshParticularFormAfterCreate(){
	$('#particulars_select_all').prop('checked', true);
	resetParticularFormField();
	$('#replaceParticularsFor').empty();
	$("#previousSession").val("");
}
function resetPreviousMasterCategoryData(data){
	$("#changeMasterCategoryForCurrent").empty()
	$("#changeMasterCategoryForCurrent").html(data)
}

function validateStudentadmissionWithBatch() {
	var result = null;
	var admissionNo = $("#finance_fee_particulars_admission_no").val();
	var batch = $("#finance_fee_particulars_finance_fee_category_id").val();
	var admission = admissionNo.toLowerCase();
	var data = {
		'student[admissionNo]' : admission,
		'student[master_category_id]' : batch
	}
	var target = "validate_student_batch"
	$.ajax({
		url : target,
		type : 'get',
		data : data,
		async : false,
		success : function(data) {
			result = (data.valid);
		}
	});
	return result;
}

$(document).on("click", 'a.delete-masterParticular-master-href', function(event) {
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var remoteUrl = 'master_category_particulars_delete' + "/" + object_id;
	confirmMasterParticularDelete(remoteUrl, table, row);
	return true;
});
function confirmMasterParticularDelete(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxMasterParticularDelete(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}
function ajaxMasterParticularDelete(remoteUrl, table, row) {
	$.get(remoteUrl,function(data){
		updateParticularList(data);
		$('#outer_block').removeBlockMessages().blockMessage('Successfully Deleted Particulars', {
			type : 'success'
		});
	$('#particulars_select_all').prop('checked', true);
	resetParticularFormField();
	$('#current_object_id').val("");
	$("#replaceParticularsFor").empty();
	}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
	});
}
$(document).on("click", 'a.update-masterParticular-master-href', function(event) {
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var des = $(this).attr('view_description')
	var category_name = $(this).attr('view_name')
	var category_amount = $(this).attr('view_amount')
    var admission_no = $(this).attr('view_admission')
	var student_category = $(this).attr('view_student')
	$('#finance_fee_particulars_name').val(category_name);
	$('#finance_fee_particulars_description').val(des);
	$("#finance_fee_particulars_amount").val(category_amount);
	// $("#finance_fee_particulars_finance_fee_category_id").attr("disabled", true);
	$('#current_object_id').val(object_id);
	var name = table.attr("id"); 
  	$('#update_masterParticular_category').attr("class","");
	$('#update_masterParticular_category').attr("disabled", false);
	$('#msaterFeeParticularCreate').attr("disabled", true);
	$('#previous_master_category').attr("disabled", true);
	$('#particulars_select_all').attr("disabled", true);
	$('#particulars_select_student').attr("disabled", true);
	$('#particulars_select_category').attr("disabled", true);
	$('#showPreviuosMasterCategory').hide();
	$('#particulars_select_all').prop('checked', true);
	$("#replaceParticularsFor").empty();
	$('#replaceParticularsFor').hide();
    $("#previousSession").val("");
    $("#previousSession").attr("disabled", true);
	enabledForPreviousSelection();
	return false;
});

$(document).on("click", '#update_masterParticular_category', function(event) {
	event.preventDefault()
	var master_category_id = document.getElementById("finance_fee_particulars_finance_fee_category_id").value;
	var particular_name = $("#finance_fee_particulars_name").val();
	var particular_description = $("#finance_fee_particulars_description").val();
	var particular_amount = $("#finance_fee_particulars_amount").val();
	var particular_admission_no = $("#finance_fee_particulars_admission_no").val();
	var student_category = $("#finance_fee_particulars_student_category_id").val();
	var valueRadio = $('input:radio[name=particulars[select]]:checked').val();
	var current_object_id = $('#current_object_id').val();
	var data = {
		'finance_fee_particulars[name]' : particular_name,
		'finance_fee_particulars[description]' : particular_description,
		'finance_fee_particulars[amount]' : particular_amount,
		'finance_fee_particulars[admission_no]' : particular_admission_no,
		'finance_fee_particulars[student_category_id]' : student_category,
		'finance_fee_particulars[finance_fee_category_id]' : master_category_id,
		'id' : current_object_id
	}
	if(valueRadio == "student"){
		if(particular_admission_no != null){
			var result = validateStudentadmissionWithBatch();
			if(result != true) {
				$('#outer_block').removeBlockMessages().blockMessage('Student doesnot belong to selected Batch', {
					type : 'warning'
				});
				return false;
			}
		}
		if(!particular_admission_no || particular_admission_no.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Admission Number', {
				type : 'warning'
			});
			return false;
		}
	}
	if(valueRadio == "category"){
		if(!student_category || student_category.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select the student category', {
				type : 'warning'
			});
			return false;
		}
	}
	if(!particular_name || particular_name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Particular Name', {
				type : 'warning'
			});
			return false;
	}
	if(!particular_amount || particular_amount.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Particular Amount', {
				type : 'warning'
			});
			return false;
	}
	if(!master_category_id || master_category_id.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select the Fees Category', {
				type : 'warning'
			});
			return false;
	}
	if(isNaN(particular_amount) || particular_amount.indexOf(" ") != -1) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Valid Particular Amount', {
				type : 'warning'
			});
			return false;
	}
	
	$.get("master_category_particulars_update" ,data, function(data){
		updateParticularList(data);
		$('#outer_block').removeBlockMessages().blockMessage('Successfully Updated Fees Particulars', {
			type : 'success'
		});
    $('#particulars_select_all').prop('checked', true);
	resetParticularFormField();
	$('#current_object_id').val("");
	$('#update_masterParticular_category').attr("disabled", true);
	$('#msaterFeeParticularCreate').attr("disabled", false);
	$('#previous_master_category').attr("disabled", false);
	$("#replaceParticularsFor").empty();
	resetRadioButton();
	$('#replaceParticularsFor').show();	
	resetPreviousSessionDropDown();	
	get_previous_master_data();
	}).error(function(jqXHR, textStatus, errorThrown) { 
		 window.location.href = "/signin"
	});
});

$(document).on("click","#msaterFeeParticularCreate",function(event){
	event.preventDefault();
	var previous_master_category_id = $("#previous_master_category").val();
	var master_category_id = document.getElementById("finance_fee_particulars_finance_fee_category_id").value;
	var particular_name = $("#finance_fee_particulars_name").val();
	var particular_description = $("#finance_fee_particulars_description").val();
	var particular_amount = $("#finance_fee_particulars_amount").val();
	var particular_admission_no = $("#finance_fee_particulars_admission_no").val();
	var student_category = $("#finance_fee_particulars_student_category_id").val();
	var valueRadio = $('input:radio[name=particulars[select]]:checked').val();
	if(!master_category_id || master_category_id.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select the Fees Category', {
				type : 'warning'
			});
			return false;
	}
	 if(previous_master_category_id.length != 0){ 
	    var category_ids = []
		$('#previous_category_ids_id').each(function() {
			if ($(this).attr('selected','selected')){
				category_ids.push($(this).val())
			}
	    });
	    if(category_ids == "") {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select At least One Previous Master Category Particular.', {
				type : 'warning'
			});
			return false;
		}else{
			$('#outer_block').removeBlockMessages();
		}
	}
	
	var data = {
		'finance_fee_particulars[name]' : particular_name,
		'finance_fee_particulars[description]' : particular_description,
		'finance_fee_particulars[amount]' : particular_amount,
		'finance_fee_particulars[admission_no]' : particular_admission_no,
		'finance_fee_particulars[student_category_id]' : student_category,
		'finance_fee_particulars[finance_fee_category_id]' : master_category_id,
		'particulars[select]' : valueRadio
	}
	
	if(valueRadio == "student"){
		if(particular_admission_no != null && master_category_id != ""){
			var result = validateStudentadmissionWithBatch();
			if(result != true) {
				$('#outer_block').removeBlockMessages().blockMessage('Student doesnot belongs to selected Batch', {
					type : 'warning'
				});
				return false;
			}
		}
		if(!particular_admission_no || particular_admission_no.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Admission Number', {
				type : 'warning'
			});
			return false;
		}
		if(master_category_id == "") {
			$('#outer_block').removeBlockMessages().blockMessage('Please select Master Category', {
				type : 'warning'
			});
			return false;
		}
	}
	if(valueRadio == "category"){
		if(!student_category || student_category.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select the student category', {
				type : 'warning'
			});
			return false;
		}
	}
	if(previous_master_category_id.length == 0){ 
		if(!particular_name || particular_name.length == 0) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Particular Name', {
					type : 'warning'
				});
				return false;
		}
		if(!particular_amount || particular_amount.length == 0) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter Particular Amount', {
					type : 'warning'
				});
				return false;
		}
		if(isNaN(particular_amount) || particular_amount.indexOf(" ") != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Please Enter Valid Particular Amount', {
					type : 'warning'
				});
				return false;
		}
	}

	var previousData = {
		'finance_fee_particulars[previous_particulars]' : category_ids,
		'finance_fee_particulars[finance_fee_category_id]' : master_category_id,
		'finance_fee_particulars[admission_no]' : particular_admission_no,
		'finance_fee_particulars[student_category_id]' : student_category,
		'particulars[select]' : valueRadio,
		'copy_data' : "copy_value"
    }
    if(previous_master_category_id.length != 0){ 
        createParticularWithAjax(previousData);	
    }else{
    	createParticularWithAjax(data);
  }
});

function createParticularWithAjax(modalData){
	 $.ajax({
				url : "fees_particulars_create",
				dataType : 'json',
				type : 'get',
				data : modalData,
				success : function(data, textStatus, jqXHR) {
					if(data.valid) {
						$("#updateMasterCategoryParticularList").empty()
						$("#updateMasterCategoryParticularList").html(data.html)
					    configureMaterFeesParticularToBatchTable($(".masterCategory_particular"));
						$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
							type : 'success'
						});
				        refreshParticularFormAfterCreate();
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
$(document).on("click","#reset_masterParticular_category",function(event){
		$("#showPreviuosMasterCategory").hide();
		resetPreviousSessionDropDown();
		$("#previous_master_category").val("");
			resetRadioButton();
			var id = document.getElementById("finance_fee_particulars_finance_fee_category_id").value;
		$.get("master_category_particulars?id="+id, function(data){
		   updateParticularList(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
		get_previous_master_data();
		resetMasterCategoryPaticularForm();
});
function resetParticularFormField(){
	$('#finance_fee_particulars_name').val("");
	$('#finance_fee_particulars_description').val("");
	$('#finance_fee_particulars_amount').val("");
}

function resetPreviousSessionDropDown(){
	$("#previousSession").val("");
	$('#previousSession').attr("disabled", false);
}

function resetRadioButton(){
	$('#particulars_select_all').attr("disabled", false);
	$('#particulars_select_student').attr("disabled", false);
	$('#particulars_select_category').attr("disabled", false);
}

function updateParticularList(data){
	$("#updateMasterCategoryParticularList").empty();
	$("#updateMasterCategoryParticularList").html(data);
	configureMaterFeesParticularToBatchTable($(".masterCategory_particular"));
}

function configureMaterFeesParticularToBatchTable(tableNode) {
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


$('.masterCategory_particular').each(function(i) {
	configureMaterFeesParticularToBatchTable($(this));
});