$('#assign_employee_constraints').on('click', function(event) {
	var employee_id = document.getElementById('image_employee').value;
	var full = []
	var not_available = {}
	index2 = 0
	jQuery.each($("#employee_constraints_row input").filter('[checked = checked]'), function(event) {
		not_available['weekday_id'] = $(this).attr('data_week')
		not_available['class_timing_id'] = $(this).attr('data_class')
		not_available['employee_id'] = employee_id
		full[index2] = not_available
		not_available = {}
		index2++
	})
	
		var target = '/employee_constraints'
		var data = {
			'full' : full,
			'employee_id' : employee_id
		}
		$.ajax({
			url : target,
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data, textStatus, jqXHR) {
				if(data.valid) {
					$('#tab-employee_constraints').removeBlockMessages().blockMessage(data.notice, {
						type : 'success'
					});

				} else {
					var errorText = getErrorText(data.errors);
					$('#tab-employee_constraints').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
						type : 'error'
					});

				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				// Message
				$('#tab-employee_constraints').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});

			}
		})
})