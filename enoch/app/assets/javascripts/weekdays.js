$(document).ready(function() {
	$(".course-select-week").val(0);
	
});

$(document).ready(function() {
 $(".course-select-week").live("change", (function (event) {
          var str = "";
          event.preventDefault();
           $(".course-select-week option:selected").each(function () {
           	$('#loading').show();
            str = $(this).val();
            });
            if(str == "")
            {
            	 $.get('/weekdays/week',{batch_id: str}, function(dataFromGetRequest) {
					$('#weekdays').empty();
					$('#weekdays').html(dataFromGetRequest);
					$('#loading').hide();
				}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
				
				$.get('/weekdays/batch',{id: str}, function(dataFromGetRequest) {
					$('#batch-select-batch').empty();
					$('#batch-select-batch').html(dataFromGetRequest);
					$('#loading').hide();
				}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
            }else
            {
                $.get('/weekdays/batch',{id: str}, function(dataFromGetRequest) {
					$('#batch-select-batch').empty();
					$('#batch-select-batch').html(dataFromGetRequest);
					$('#loading').hide();
				}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
				$.get('/weekdays/week',{batch_id: ""}, function(dataFromGetRequest) {
					$('#weekdays').empty();
					$('#weekdays').html(dataFromGetRequest);
					$('#loading').hide();
				}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
            } 
          
        })
     );

});

$(document).ready(function() {
 $(".week").live("change", (function (event) {
          var str = "";
          event.preventDefault();
           $("select option:selected").each(function () {
           	$('#loading').show();
            str = $(this).val();
            });
                $.get('/weekdays/week',{batch_id: str}, function(dataFromGetRequest) {
					$('#weekdays').empty();
					$('#weekdays').html(dataFromGetRequest);
					$('#loading').hide();
				}).error(function(jqXHR, textStatus, errorThrown) { 
	       window.location.href = "/signin"
	});
             
          
        })
     );

});



$(document).on("click", ".week-button", function(event) {
		var aLink = $(this);
		$.modal({
		content : "This will delete all timetable entries and Attendance entries for the weekdays, Proceed with changing weekdays ?",
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				win.closeModal();
			},
			'Cancel' : function(win) {
				
				win.closeModal();
				return false
			}
		}
	});
	});


$(document).on("click", "#window_reload", function(event) {
	
	// window.location.href = "/weekdays";
})

function confirm_for_weekday()
{
	var weekdays = []
	jQuery.each($("#modal #weekday_select_checkbox input").filter('[checked = checked]'), function(event) {
		
		weekdays.push($(this).attr('value'))
	})
	
	var batch_id = document.getElementById('weekday_batch_id').value
	
	$.modal({
		content : "This will delete all timetable entries and Attendance entries for the weekdays, Proceed with changing weekdays ?",
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				proceed_with_change(weekdays)
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function proceed_with_change(weekdays)
{
	
	var batch_id = document.getElementById('weekday_batch_id').value
	var target = '/weekdays'
		var data = {
			'weekday[batch_id]' : batch_id,
			'weekdays' : weekdays
		}
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {

			if(data.valid) {
				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				window.location.href = '/weekdays';
			} else {
				var errorText = getErrorText(data.errors);
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



















