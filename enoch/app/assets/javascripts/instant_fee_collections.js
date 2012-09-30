function configureInstantFeesStudentOrEmployeeTable(tableNode) {
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

$('.studentOrEmployeeTable').each(function(i) {
	configureInstantFeesStudentOrEmployeeTable($(this));
});


function configureInstantFeesCollectionTable(tableNode) {
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
		}, {
			sType : 'string', "sWidth": "30%"
		}
		],
		bRetrieve : true,
		bDestroy  :true,
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

$('.instantFeesCollectionTable').each(function(i) {
	configureInstantFeesCollectionTable($(this));
});


function validate_guest() {
	err_text = "";
	if($('#guest_name').val() == "") {
		err_text = "Please Enter Guest Name";
	}
	if(err_text != "") {
		return false;
	} else {
		return true;
	}
}

function validate_category() {
	err_text = "";
	if($('#custom_category_name').val() == "") {
		err_text = "Please Enter a Instant Fees Name";
	}else if($('#custom_category_description').val() == "") {
		err_text = "Please Enter a Instant Fees Description";
	}
	if(err_text != "") {
		return false;
	} else {
		return true;
	}
}

function validate_particular_name() {
	var flag = 0;
	$('.particular_name').each(function() {
		if($(this).val() == "")
			flag = 1;
	});
	if(flag == 1) {
		$('#outer_block').removeBlockMessages().blockMessage("Particular name missing", {
				type : 'warning'
		});
		return false;
	} else{
		return true;
	}
}

function validate_particular_select() {
	var flag = 0;
	var checkedFee = new Array();
	$('.par_check').each(function() {
		if($(this).attr('checked') == "checked"){
			flag = 1;
			checkedFee.push(1);
		}else{
			flag = 0;
		}
	});
	if(checkedFee.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage("Please select at least one particular", {
				type : 'warning'
		});
		// alert("Please select at least one particular");
		return false;
	} else
		return true;
}

var i = 1;
function insRow() {
	var tableID = document.getElementById('instantFeesCollect');
	var tableBody = tableID.tBodies[0]
	var name_field = document.createElement('input');
	var amount_field = document.createElement('input');
	var discount_field = document.createElement('input');
	var total_amount_field = document.createElement('input');
	var quantity_tag = document.createElement('select');
	var anchor = document.createElement('a');
	var anchortext = document.createTextNode('X');
	anchor.appendChild(anchortext);
	anchor.setAttribute('style', 'color : red');
	name_field.setAttribute('type', 'text');
	name_field.setAttribute('class', 'particular_name');
	name_field.setAttribute('name', 'name[]');
	amount_field.setAttribute('type', 'text');
	amount_field.setAttribute('class', 'input particular_amount');
	amount_field.setAttribute('name', 'amount[]');
	amount_field.setAttribute('id', 'amount_' + (i + (tableBody.rows.length+9999) - 4).toString());
	amount_field.setAttribute('onchange', 'update_total_by_amount(this)');
	amount_field.setAttribute('value', '0.0');
	discount_field.setAttribute('type', 'text');
	discount_field.setAttribute('class', 'input particular_discount');
	discount_field.setAttribute('name', 'discount[]');
	discount_field.setAttribute('id', 'discount_' + (i + (tableBody.rows.length+9999) - 4).toString());
	discount_field.setAttribute('onchange', 'update_total_by_discount(this)');
	discount_field.setAttribute('value', '0.0');
	total_amount_field.setAttribute('type', 'text');
	total_amount_field.setAttribute('class', 'particular_total particular_total_new');
	total_amount_field.setAttribute('name', 'total[]');
	total_amount_field.setAttribute('id', 'total_check_' + (i + (tableBody.rows.length+9999) - 4).toString());
	total_amount_field.setAttribute('value', '0.0');
	total_amount_field.setAttribute('readonly', 'true');
	quantity_tag.setAttribute('class', 'selected_quantity_new');
	quantity_tag.setAttribute('name', 'total[]');
	quantity_tag.setAttribute('id', 'selected_quantity_' + (i + (tableBody.rows.length+9999) - 4).toString());
	quantity_tag.setAttribute('onchange', 'update_total_by_quantity(this)');
	anchor.setAttribute('href', '#');
	anchor.setAttribute('onclick', 'delRow(event,this.parentNode.parentNode.rowIndex)');
	anchor.setAttribute('id', 'delete_row');
	var row = tableBody.insertRow(tableBody.rows.length );
	i = tableBody.rows.length;
	var q = row.insertCell(0);

	var y = row.insertCell(1);

	var z = row.insertCell(2);

	var m = row.insertCell(3);

	var n = row.insertCell(4);

	var o = row.insertCell(5);
   var options = new Array();
   for (var j=1; j <= 50; j++) {
     options[j] = document.createElement("option");
     options[j].text= j;
     options[j].value= j;
     quantity_tag.options.add(options[j]);  
   };

	
	q.innerHTML = "";
	// y.innerHTML = "" + i;
	y.appendChild(quantity_tag);
	z.appendChild(name_field);
	m.appendChild(amount_field);
	n.appendChild(discount_field);
	o.appendChild(total_amount_field);
	o.appendChild(anchor);
	i++;
	configureInstantFeesCollectionTable($("#instantFeesCollect"));
}

function delRow(event,i) {
	event.preventDefault();
	document.getElementById('instantFeesCollect').deleteRow(i);
	col5total();
}

function roundVal(val) {
	var dec = 2;
	var result = Math.round(val * Math.pow(10, dec)) / Math.pow(10, dec);
	return result;
}

var total_global;
function assign_amt(che) {
	var discount = che.id.replace('check', "discount");
	var amount = che.id.replace('check', "amount");
	var select_tag = che.id.replace('check', "#selected_quantity");
	var quantity = $(select_tag).find("option:selected").text();
	var total = che.id.replace('check', "total_check");
	var check_amount = che.id.replace('check', "check");
	var chkAmt = document.getElementById(check_amount);
	var amount_text = document.getElementById(amount).value;
	var discount_text = document.getElementById(discount).value;
	if(isNaN(discount_text) == false && isNaN(amount_text) == false) {
		if(che.checked) {
			if(amount_text == 0 || "") {
				document.getElementById(total).value = 0.0;
				if(chkAmt!= null){
					document.getElementById(check_amount).setAttribute('checked_amount',0.0);
					document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
				}
				amount_text = document.getElementById(amount).value = 0.0
			} else {
				if(amount_text < 0) {
					$('#outer_block').removeBlockMessages().blockMessage("Amount can not be negative.", {
							type : 'warning'
					});
					document.getElementById(amount).value = 0.0
					return false;
				}
				if(discount_text == 0 || "") {
					document.getElementById(total).value = quantity*(amount_text.value);
					if(chkAmt!= null){
					document.getElementById(check_amount).setAttribute('checked_amount',amount_text.value);
					document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
					}
				}
				
				if(discount_text <= 100) {
					if(discount_text < 0) {
						$('#outer_block').removeBlockMessages().blockMessage("Discount cannot be negative.", {
								type : 'warning'
						});
						document.getElementById(discount).value = 0.0;
						return false;
					} else
						document.getElementById(total).value = quantity*(roundVal(parseFloat(amount_text - (amount_text * discount_text / 100))));
						if(chkAmt!= null){
						document.getElementById(check_amount).setAttribute('checked_amount',roundVal(parseFloat(amount_text)));
						document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
						}
				}
			}
		} else {
			document.getElementById(total).value = 0.0;
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount',0.0);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
		}
		col5total();
	} else
	    $('#outer_block').removeBlockMessages().blockMessage("Please enter numeric value for amount and discount", {
				type : 'warning'
		});
}

function update_total_by_amount(text_box) {
	var discount = text_box.id.replace('amount', "discount");
	var select_tag = text_box.id.replace('amount', "#selected_quantity");
	var quantity = $(select_tag).find("option:selected").text();
	var total = text_box.id.replace('amount', "total_check");
	var check_amount = text_box.id.replace('amount', "check");
	var chkAmt = document.getElementById(check_amount);
	var discount_text = document.getElementById(discount).value
	if(isNaN(discount_text) == false && isNaN(text_box.value) == false) {
		if(text_box.value < 0) {
			$('#outer_block').removeBlockMessages().blockMessage("Amount can not be negative.", {
				type : 'warning'
			});
			text_box.value = 0.0;
			document.getElementById(total).value = 0.0;
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount', 0.0);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
			return false;
		}
		if(text_box.value == "") {
			text_box.value = 0.0;
			document.getElementById(total).value = 0.0;
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount', 0.0);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
			return false;
		}
		if(discount_text == 0 || "") {
			document.getElementById(total).value = quantity*(text_box.value);
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount',text_box.value);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
			document.getElementById(discount).value = 0.0
		}
		if(discount_text <= 100) {
			if(discount_text < 0) {
				$('#outer_block').removeBlockMessages().blockMessage("Discount can not be negative.", {
					type : 'warning'
				});
				document.getElementById(discount).value = 0.0
				return false;
			} else
				document.getElementById(total).value = quantity*(roundVal(parseFloat(text_box.value - (text_box.value * discount_text / 100))));
				if(chkAmt!= null){
				document.getElementById(check_amount).setAttribute('checked_amount',roundVal(parseFloat(text_box.value)));
				document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
				}
		} else
			$('#outer_block').removeBlockMessages().blockMessage("Discount cannot be greater than 100% ", {
					type : 'warning'
			});
		col5total();
	} else {
		text_box.value = 0.0
		document.getElementById(total).value = 0.0
		if(chkAmt!= null){
		document.getElementById(check_amount).setAttribute('checked_amount',0.0);
		document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
		}
		$('#outer_block').removeBlockMessages().blockMessage("Please enter numeric value for amount and discount", {
					type : 'warning'
		});
		col5total();
	}
}

function update_total_by_discount(text_box) {
	var amount = text_box.id.replace('discount', "amount");
	var select_tag = text_box.id.replace('discount', "#selected_quantity");
	var quantity = $(select_tag).find("option:selected").text();
	var total = text_box.id.replace('discount', "total_check");
	var check_amount = text_box.id.replace('discount', "check");
	var chkAmt = document.getElementById(check_amount);
	var amount_text = document.getElementById(amount).value;
	if(isNaN(amount_text) == false && isNaN(text_box.value) == false) {
		if(text_box.value == "") {
			text_box.value = 0.0;
			document.getElementById(total).value = quantity*(amount_text);
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount',amount_text);
			document.getElementById(check_amount).setAttribute('checked_discount',text_box.value);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);		
			}
			return false;
		}
		if(amount_text == 0) {
			document.getElementById(total).value = 0.0;
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount',0.0);
			document.getElementById(check_amount).setAttribute('checked_discount',text_box.value);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
		}
		if(amount_text < 0) {
			$('#outer_block').removeBlockMessages().blockMessage("Amount can not be negative.", {
					type : 'warning'
			});
			document.getElementById(amount).value = 0.0;
			return false;
		} else {
			if(text_box.value <= 100) {
				if(text_box.value < 0) {
					$('#outer_block').removeBlockMessages().blockMessage("discount can not be negative.", {
							type : 'warning'
					});
					text_box.value = 0.0;
					document.getElementById(total).value = quantity*(amount_text);
					if(chkAmt!= null){
					document.getElementById(check_amount).setAttribute('checked_amount',amount_text);
					document.getElementById(check_amount).setAttribute('checked_discount',text_box.value);
					document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
					}
					return false;
				} else {
					document.getElementById(total).value = quantity*(roundVal(parseFloat(amount_text - (amount_text * text_box.value / 100))));
					if(chkAmt!= null){
					document.getElementById(check_amount).setAttribute('checked_amount',roundVal(parseFloat(amount_text)));
					document.getElementById(check_amount).setAttribute('checked_discount',text_box.value);
					document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
					}
				}
			} else {
				text_box.value = 0.0
				$('#outer_block').removeBlockMessages().blockMessage("Discount cannot be greater than 100% ", {
							type : 'warning'
				});
			}
			col5total();
		}
	} else {
		text_box.value = 0.0
		document.getElementById(total).value = quantity*(amount_text);
		if(chkAmt!= null){
		    document.getElementById(check_amount).setAttribute('checked_amount',amount_text);
			document.getElementById(check_amount).setAttribute('checked_discount',text_box.value);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
		}
		$('#outer_block').removeBlockMessages().blockMessage("Please enter numeric value for amount and discount", {
					type : 'warning'
		});
		return false;
		// alert('Please enter numeric value for amount and discount')
	}
}

function update_total_by_quantity(select_tag){
	var quantity = $(select_tag).find("option:selected").text();
    var amount = select_tag.id.replace('selected_quantity', "amount");
	var total = select_tag.id.replace('selected_quantity', "total_check");
	var discount = select_tag.id.replace('selected_quantity', "discount");
	var check_amount = select_tag.id.replace('selected_quantity', "check");
	var chkAmt = document.getElementById(check_amount);
	var amount_text = document.getElementById(amount).value;
	var amount_field = document.getElementById(amount);
	var discount_text = document.getElementById(discount).value;
	if(isNaN(amount_text) == false && isNaN(amount_field.value) == false) {
		if(amount_field.value < 0) {
			$('#outer_block').removeBlockMessages().blockMessage("Amount can not be negative.", {
				type : 'warning'
			});
			amount_field.value = 0.0;
			document.getElementById(total).value = 0.0;
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount', 0.0);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
			return false;
		}
		if(amount_field.value == "") {
			amount_field.value = 0.0;
			document.getElementById(total).value = 0.0;
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount', 0.0);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
			return false;
		}
		if(amount_text == 0 || "") {
			document.getElementById(total).value = quantity*(amount_field.value);
			if(chkAmt!= null){
			document.getElementById(check_amount).setAttribute('checked_amount',amount_field.value);
			document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
			}
			document.getElementById(discount).value = 0.0
		}
		if(discount_text <= 100) {
			if(discount_text < 0) {
				$('#outer_block').removeBlockMessages().blockMessage("Discount can not be negative.", {
					type : 'warning'
				});
				document.getElementById(discount).value = 0.0
				return false;
			} else
				document.getElementById(total).value = quantity*(roundVal(parseFloat(amount_field.value - (amount_field.value * discount_text / 100))));
				if(chkAmt!= null){
				document.getElementById(check_amount).setAttribute('checked_amount',roundVal(parseFloat(amount_field.value)));
				document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
				}
		} else
			$('#outer_block').removeBlockMessages().blockMessage("Discount cannot be greater than 100% ", {
					type : 'warning'
			});
		col5total();
	} else {
		amount_field.value = 0.0
		document.getElementById(total).value = 0.0
		if(chkAmt!= null){
		document.getElementById(check_amount).setAttribute('checked_amount',0.0);
		document.getElementById(check_amount).setAttribute('checked_quantity',quantity);
		}
		$('#outer_block').removeBlockMessages().blockMessage("Please enter numeric value for amount and discount", {
					type : 'warning'
		});
		col5total();
	}
}

function attacher() {
	$('.par_check').invoke('observe', 'change', assign_amt);
	col5total()
}

function col5total() {
	var total = 0;
	$('.particular_total').each(function() {
		
		if(isNaN($(this).val()) == false ||$(this).val() != "") {
			total = roundVal(total + parseFloat($(this).val()));
		} else {
			$(this).val(0.0);
			$('#outer_block').removeBlockMessages().blockMessage("please enter a numeric value for total", {
					type : 'warning'
			});
			return false;
			// alert('please enter a numeric value for total');
		}
	});
	$("#total").val("Rs. "+total+" only");
	document.getElementById('total_fees').value = total;
}

function validate_make_fee() {
	if($('.particular_name').length > 0) {
		return validate_particular_name();
	} else {
		if(validate_particular_select())
			return true;
		else { {
			$('#outer_block').removeBlockMessages().blockMessage("Please enter at least one particular detail", {
					type : 'warning'
			});
				return false;
			}
		}
	}
}

function validate_make_fee_from_custom_category() {
	if(validate_category()) {
		if($('.particular_name').length > 0) {
			return validate_particular_name();
		} else {
			$('#outer_block').removeBlockMessages().blockMessage("Please enter at least one particular detail", {
					type : 'warning'
			});
			// alert("Please enter at least one particular detail");
			return false;
		}
	} else {
		return false;
	}
}

function validate_make_fee_for_guest() {
	if(validate_guest()) {
		return validate_particular_name();
	} else
		return true;
}

function validate_make_fee_for_guest_from_custom_category() {
	if(validate_guest()) {
		if(validate_category()) {
			if($('.particular_name').length > 0) {
				return validate_particular_name();
			} else {
				if(validate_particular_select())
					return true;
				else { {
					    $('#outer_block').removeBlockMessages().blockMessage("Please enter at least one particular detail", {
								type : 'warning'
						});
						// alert("Please enter at least one particular detail");
						return false;
					}
				}
			}
		} else
			return false;
	} else
		return false;
}

$(document).on("ready", function(event){
	$('#name_query').val("");
	$('#search_Student').attr("checked",true);
	$('#name_query').attr('disabled',false);
});

$("input[name='search']").click(function(){
	var search = $('#name_query').val();
	var person_type = $('input:radio[name=search]:checked').val();
	var inputData = {
		'search' : search,
		'person_type' : person_type
	}
	$("#updateInstantFeeSearch").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
   if(person_type!= "Guest"){
   	$('#name_query').attr('disabled',false);
    $.get("instant_fee_collections/get_student_or_employee_data",inputData,function(data) {
			$('#updateInstantFeeSearch').empty();
			$('#updateInstantFeeSearch').html(data);
			configureInstantFeesStudentOrEmployeeTable($("#instantFeesStudent"));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	}else{
		$('#name_query').val("");
		$('#name_query').attr('disabled',true);
		$.get("instant_fee_collections/get_partial_for_instant_fee_collection",inputData,function(data) {
			$('#updateInstantFeeSearch').empty();
			$('#updateInstantFeeSearch').html(data);
			configureInstantFeesStudentOrEmployeeTable($("#instantFeesStudent"));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	}
})
$('#name_query').keyup(function() {
	var search = $('#name_query').val();
	var person_type = $('input:radio[name=search]:checked').val();
	var inputData = {
		'search' : search,
		'person_type' : person_type
	}
	var url = "instant_fee_collections/get_student_or_employee_data"
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
		$("#updateInstantFeeSearch").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(url,inputData,function(data) {
			$('#updateInstantFeeSearch').empty();
			$('#updateInstantFeeSearch').html(data);
			configureInstantFeesStudentOrEmployeeTable($("#instantFeesStudent"));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	} else {
		$('#updateInstantFeeSearch').empty();
		$('#updateInstantFeeSearch').html();
	}
});

$(document).on("click","#select_instant_fee_category", function(event){
	event.preventDefault();
	var id= $(this).attr('person_id');
	var person_type = $('input:radio[name=search]:checked').val();
	var inputData = {
		'id' : id,
		'person_type' : person_type
	}
	$.get("instant_fee_collections/get_partial_for_instant_fee_collection",inputData,function(data) {
			$('#updateInstantFeeSearch').empty();
			$('#updateInstantFeeSearch').html(data);
			configureInstantFeesStudentOrEmployeeTable($("#instantFeesStudent"));
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	
});

$(document).on("change","#selected_instant_fees_id", function(event){
	event.preventDefault();
	var id= $(this).val();
	var person_id = document.getElementById('personId').value;
	
	var inputData = {
		'id' : id,
		'person_id' : person_id
	}
	getInstantFeeCollectionTableInPartial(inputData);
});

function getInstantFeeCollectionTableInPartial(inputData){
	$.get("instant_fee_collections/get_instant_fee_collection_table",inputData, function(data){
		$('#getInstantFeeCollectionTable').empty();
		$('#getInstantFeeCollectionTable').html(data);	
		configureInstantFeesCollectionTable($("#instantFeesCollect"));
	}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
	});
}

$(document).on("click" ,"#addrow",function(event){
	event.preventDefault();
	insRow();
});

$(document).on("click" ,"#pay_button",function(event){
	event.preventDefault();
	var is_custom = document.getElementById('is_customFee').value;
	var personId = $("#personId").val();
    var valid_name = validate_particular_name();
    var validate_fee = validate_make_fee();
    var particular_name = new Array(); 
    var particular_amount = new Array();
    var particular_discount = new Array();
    var particular_total = new Array();
    var particular_quantity = new Array();
    var checkedFee = new Array();
    var checkedFeeAmount = new Array();
    var checkedFeeDiscount = new Array();
    var checkedFeeQuantity = new Array();
    var guest_name = ""
    if(personId == "Guest"){
    	if(validate_guest()== false){
	    	$('#outer_block').removeBlockMessages().blockMessage("Please enter Guest Name", {
				type : 'warning'
			});
			return false;	
    	}else{
    		guest_name = $("#guest_name").val();
    	}
    }
    // if(validate_fee == false){
    	// $('#outer_block').removeBlockMessages().blockMessage("Please enter particular detail", {
			// type : 'warning'
		// });
		// return false;
    // }
    if(is_custom == "Custom"){
    	var valid_category = validate_category();
    	var name = $("#custom_category_name").val();
    	var description = $("#custom_category_description").val();
    	var person_id = document.getElementById("empOrStd").value;
    	var person_type = document.getElementById("empOrStdtype").value;
    	var total_amount = document.getElementById("total_fees").value;
    	if(valid_category == false){
	    	$('#outer_block').removeBlockMessages().blockMessage("Please enter Instant Fees Detail", {
				type : 'warning'
			});
			return false;
	    }
	    if(validate_fee == false){
	    	$('#outer_block').removeBlockMessages().blockMessage("Please enter particular detail", {
				type : 'warning'
			});
			return false;
	    }
	    if(valid_name == false){
			return false;
	    }
    	$('.particular_name').each(function() {
			if($(this).val() != ""){
				particular_name.push($(this).val())
			}
		});
		$('.particular_amount').each(function() {
				particular_amount.push($(this).val());	
		});
		$('.particular_discount').each(function() {
				particular_discount.push($(this).val());
		});
		$('.particular_total_new').each(function() {
				particular_total.push($(this).val());
		});
		$('.selected_quantity_new').each(function() {
				particular_quantity.push($(this).find("option:selected").text());
		});
		
		var data = {
			'instant_fee_collection[particular_name]' : particular_name,
			'instant_fee_collection[particular_amount]' : particular_amount,
			'instant_fee_collection[particular_discount]' : particular_discount,
			'instant_fee_collection[particular_total]' : particular_total,
			'instant_fee_collection[particular_quantity]' : particular_quantity,
			'instant_fee_collection[name]' : name,
			'instant_fee_collection[description]' : description,
			'person_id' : person_id,
			'person' : personId,
			'guest_name' : guest_name,
			'person_type' : person_type,
			'total_amount' : total_amount,
			'is_custom' : is_custom
		}
		ajaxCreateInstantFeesCollection("/instant_fee_collections", data);
    }else{
    	var instant_fee_id = $("#selected_instant_fees_id").val();
    	var valid_particular_select = validate_particular_select();
    	var person_id = document.getElementById("empOrStd").value;
    	var person_type = document.getElementById("empOrStdtype").value;
    	var total_amount = document.getElementById("total_fees").value;
    	$('.par_check').each(function() {
			if($(this).attr('checked') == "checked"){
				checkedFee.push($(this).val());
				checkedFeeAmount.push($(this).attr('checked_amount'));
				checkedFeeDiscount.push($(this).attr('checked_discount'));
				checkedFeeQuantity.push($(this).attr('checked_quantity'));	
			}
		});
    	$('.particular_name').each(function() {
			if($(this).val() != ""){
				particular_name.push($(this).val())
			}
		});
		$('.particular_amount').each(function() {
				particular_amount.push($(this).val());
		});
		$('.particular_discount').each(function() {
				particular_discount.push($(this).val());
		});
		$('.particular_total_new').each(function() {
				particular_total.push($(this).val());
		});
		$('.selected_quantity_new').each(function() {
				particular_quantity.push($(this).find("option:selected").text());
		});
		if(checkedFee!=""){
	    	if(valid_particular_select == false){
		    	$('#outer_block').removeBlockMessages().blockMessage("Please select at least one particular", {
					type : 'warning'
				});
				return false;
		    }
	   	}
	   	if(validate_fee == false){
	    	$('#outer_block').removeBlockMessages().blockMessage("Please enter particular detail", {
				type : 'warning'
			});
			return false;
	    }
	    var data = {
			'instant_fee_collection[particular_name]' : particular_name,
			'instant_fee_collection[particular_amount]' : particular_amount,
			'instant_fee_collection[particular_discount]' : particular_discount,
			'instant_fee_collection[particular_total]' : particular_total,
			'instant_fee_collection[particular_quantity]' : particular_quantity,
			'person_id' : person_id,
			'person_type' : person_type,
			'total_amount' : total_amount,
			'person' : personId,
			'guest_name' : guest_name,
			'instant_fee_collection[instant_fee_id]' : instant_fee_id,
			'checkedFee' : checkedFee,
			'checkedFeeAmount' : checkedFeeAmount,
			'checkedFeeDiscount' : checkedFeeDiscount,
			'checkedFeeQuantity' : checkedFeeQuantity
			
		}
		ajaxCreateInstantFeesCollection("/instant_fee_collections", data);
    }
});


function ajaxCreateInstantFeesCollection(target, data) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data1, textStatus, jqXHR) {

			if(data1.valid) {
				//individual domain need to implement this method
				var person_id = document.getElementById('personId').value;
				var inputD = {
					'person_id' : person_id
				}
				var inputData = {
					'collection_id' : data1.instant_fee_collection,
					'start_date' : data1.start_date,
					'end_date' : data1.end_date
				}
				$.get("instant_fee_collections/get_instant_fee_collection_table",inputD, function(data){
					$('#getInstantFeeCollectionTable').empty();
					$('#getInstantFeeCollectionTable').html(data);
					$('#outer_block').removeBlockMessages().blockMessage(data1.notice, {
						type : 'success'
					});
					$("#selected_instant_fees_id").val("");
					configureInstantFeesCollectionTable($("#instantFeesCollect"));
				}).error(function(jqXHR, textStatus, errorThrown) { 
						if(jqXHR.status!= "0"){
					        window.location.href = "/signin"
					    }
				}).complete (function(jqXHR, textStatus, errorThrown){
					newPrintReceipt(inputData)
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

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}
function newPrintReceipt(inputData){
	$.download('/instant_fee_collections/instant_fee_collection_receipt', inputData, 'filename=instant_fee_collection_receipt&format=pdf&content=' + inputData );			
    // $("#selected_instant_fees_id").val("");
    $('#name_query').val("");
    $('#guest_name').val("");
	$('#search_Student').attr("checked",true);
	$('#name_query').attr('disabled',false);
	// $('#getInstantFeeCollectionTable').empty();
}

