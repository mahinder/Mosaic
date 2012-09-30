$(document).on("click", "#monthly_report" ,function(event){
	event.preventDefault();
	var start_date = $("#report_start_date").val();
	var end_date = $("#report_end_date").val();
	$.get("update_monthly_report",{start_date : start_date ,end_date : end_date},function(data){
		$("#showTransactionMonthlyReport").empty();
		$("#showTransactionMonthlyReport").html(data);
		configureFinanceTransactionTable($("#monthlyTransactionReport"));
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});


$(document).on("click", "#view_instant_fee_collection_detail",function(event){
	event.preventDefault();
	var start_date = $(this).attr('start');
	var end_date = $(this).attr('end');
	var id = $(this).attr('colection_id');
	var name = $(this).text();
	var inputData = {
		'start_date' : start_date,
		'end_date' : end_date, 
		'collection_id' : id,
		'name' : name
	}
	$.get("/instant_fee_collections/show", inputData , function(data){
		$.modal({
		content : data,
		title : 'Collection Detail',
		width : 700,
		buttons : {
			'Print Receipt' : function(win) {
				printReceipt(inputData,win,id,start_date,end_date);	
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}		
	});
	configureInstantFeeDetailTransactionTable($('.instantFeesCollectionDetailTable'));
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

function printReceipt(inputData,win,id,start_date,end_date){
	$.download('/instant_fee_collections/instant_fee_collection_receipt', inputData, 'filename=instant_fee_collection_receipt&format=pdf&content=' + inputData );			
	win.closeModal();
}

jQuery.download = function(url, data, method){
	//url and data options required
	if( url && data ){ 
		//data can be string of parameters or array/object
		data = typeof data == 'string' ? data : jQuery.param(data);
		//split params into form inputs
		var inputs = '';
		jQuery.each(data.split('&'), function(){ 
			var pair = this.split('=');
			inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
		});
		//send request
		jQuery('<form action="'+ url +'" method="'+ (method || 'post') +'">'+inputs+'</form>')
		.appendTo('body').submit().remove();
	};
};

function configureFinanceTransactionTable(tableNode) {
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

$('#monthlyTransactionReport').each(function(i) {
	configureFinanceTransactionTable($(this));
});

function configureInstantFeeDetailTransactionTable(tableNode) {
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
		}
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

$('.instantFeesCollectionDetailTable').each(function(i) {
	configureInstantFeeDetailTransactionTable($(this));
});
