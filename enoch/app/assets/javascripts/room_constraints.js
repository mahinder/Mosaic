$('.room_constraints').on('click', function(event) {
	event.preventDefault();

	var room_id = $(this).attr('data_room_id')
	var contents = $('#modal-boxes_room');
	$.get('/rooms/find_room_constraints/?id=' + room_id, function(dataFromGetRequest) {
		week = dataFromGetRequest.forone
		class_time = dataFromGetRequest.forone1
		$("#modal #room_constraints_row input").attr('data_room', room_id)
		$("#modal #room_id_con").attr('value', room_id)
		$.each(week, function(index, value) {

			$("#modal #room_constraints_row input").filter('[data_week = ' + value + ']').filter('[data_class = ' + class_time[index] + ']').attr('checked', 'checked')

		});
	}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
	$.modal({
		content : contents,
		title : 'Room Constraints',
		width : 1200,
		height : 370,
		
	});

})

$('#assign_room_constraints').on('click', function(event) {
	var room_id = document.getElementById('room_id_con').value;
	var full = []
	var not_available = {}
	index2 = 0
	jQuery.each($("#room_constraints_row input").filter('[checked = checked]'), function(event) {
		not_available['weekday_id'] = $(this).attr('data_week')
		not_available['class_timing_id'] = $(this).attr('data_class')
		not_available['room_id'] = $(this).attr('data_room')
		full[index2] = not_available
		not_available = {}
		index2++

	})
	var target = '/room_constraints'
	var data = {
		'full' : full,
		'room_id' : room_id
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

			} else {
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	

		}
	})

})