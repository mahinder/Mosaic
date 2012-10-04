$(document).on("click", "#mobile_user", function(event) {
	event.preventDefault();
	$.get('/users/user_mobile_no', function(data) {
				
				$.modal({
					content : data,
					title : 'Phone Numbers Lists',
					maxWidth : 500,
					buttons : {
						'OK' : function(win) {
							win.closeModal();
						}
					}
				});
				
			});
	
	
})












$("#reset_password_admin").fcbkmcomplete({
	json_url : "/users/find",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : true,
	newel : true,
	// select_all_text : "select",
});

$("#privilages_admin").fcbkmcomplete({
	json_url : "/users/find_employee",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : true,
	newel : true,
	// select_all_text : "select",
});

$(document).on("click", "#edit_privilages", function(event) {
	
var value = "";
	$("#privilages_admin option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			values = $(this).text();
			value_arr = values.split(',')
			value = value_arr[1]
		} else {

		}
		})
	if(value == "")
	{
		$('#outer_block').removeBlockMessages().blockMessage("Please enter the correct user name!", {
					type : 'warning'
				});
	}
	else{
		window.location.href = "/employees/edit_privilege?id=" + value;
	}
})

$(document).on("click", "#reset-password", function(event) {
	$.modal({
		content : '<h3>Are you sure? </h3>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				resetPasswordforanyuser(win);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			},
		}
	});

})
function resetPasswordforanyuser(win) {
	var value = "";
	$("#reset_password_admin option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			value = $(this).attr('value')
		} else {

		}
		})
	if(value == "")
	{
		$('#outer_block').removeBlockMessages().blockMessage("Please enter the correct user name!", {
					type : 'warning'
				});
	}
	else{
		$.get('/users/reset',{user : value}, function(data) {
			if(data.valid)
			{
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			}
			else{
				
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'warning'
				});
			}
		});
	
}
}

$(document).on('click','#import_csv',function(event){
	var file = $('input[type=file]').prop('files')[0];

   if ( ! file) {
      $('#outer_bloc').removeBlockMessages().blockMessage('Please choose file', {
					type : 'warning'
				});
       event.preventDefault();
       return;
   } 

   var mime = file.type;

   if (mime != 'text/csv') {
      $('#outer_bloc').removeBlockMessages().blockMessage('Only csv format is allowed', {
					type : 'warning'
				});
       event.preventDefault();
   }


});


$(document).on('click','#import_excel',function(event){
	var file = $('input[type=file]').prop('files')[0];

   if ( ! file) {
      $('#outer_bloc').removeBlockMessages().blockMessage('Please choose file', {
					type : 'warning'
				});
       event.preventDefault();
       return;
   } 

   var mime = file.type;
   if (mime != 'application/vnd.ms-excel') {
      $('#outer_bloc').removeBlockMessages().blockMessage('Only excel format is allowed', {
					type : 'warning'
				});
       event.preventDefault();
   }


});
