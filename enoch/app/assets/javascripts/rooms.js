//handler - should call upon succes of ajax call
var updateRoomsTable = function(data) {
	$.get('/rooms', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureRoomTable($('#active-table-room'));
		configureRoomTable($('#inactive-table-room'));
		$('.tabs').updateTabs();
	$('#update_room').attr("disabled", true);
	$('#create_room').attr("disabled", false);
	}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
}
$(document).on("click", "#modal .toggle", function(event) {
	$(this).toggleBranchOpen();
})

$(document).on("click", '#create_room_skill', function(event) {
	var room_id = document.getElementById('assign_skill_to_room').value;
	var full = []
	index2 = 0
	// jQuery.each($("#assigned_skill_room input").filter('[checked = checked]'), function(event) {
		jQuery.each($("#assigned_skill_room input"), function(event) {
		full[index2] = $(this).attr('data_skill')
		index2++

	})
	
	var target = '/rooms/room_skill_assign'
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




$(document).on("click", '#room_skills', function(event) {
	event.preventDefault();
	var contents = $('#modal-boxes_room_skill');
	var room = $(this).attr('data_room')
	$('#assign_skill_to_room').attr('value', room);
	$.get('/rooms/find_room_skill/?id=' + room, function(dataFromGetRequest) {
		skills = dataFromGetRequest.forone
		name = dataFromGetRequest.name
		$("#modal #room_skill_asign input").attr('data_room', room)
		$.each(skills, function(index, value) {
			$("#modal #room_skill_asign input").filter('[data_skill = ' + value + ']').attr('checked', 'checked')
			
		});
		arr = []
		if(name.length != 0)
		{
		arr = name.split(',')
		$.each(arr, function(index, value) {
			$("#modal #assigned_skill_room").append('<li><input type="checkbox" name="assign_skill"  checked disabled data_skill ="'+skills[index]+'"/>    '+value+'</li>')
		});
		}
	}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
	$.modal({
		content : contents,
		title : 'Skills Assigments',
		width : 700,
		height : 500,

	});

})

$(document).on("click", '.check_room_assign', function(event) {
	
	var is_check = $(this).is(":checked");
	var skill = $(this).attr("data_skill");
	if(is_check)
	{
	$("#modal #assigned_skill_room").append('<li ><input type="checkbox" name="assign_skill"  checked disabled data_skill ="'+skill+'"/>    '+$(this).attr('data_skill_name')+'</li>')
	}
	else
	{
		$("#modal #assigned_skill_room input").filter('[data_skill = ' + skill + ']').parent().remove();
	}
});

$("#advv_room_search_course_id").live('change', function(event) {
	var str = "";

	$("#advv_room_search_course_id option:selected").each(function() {
		str = $(this).val();
	});
	var url = 'change_room_batch' + '?q=' + str
	$.get(url, function(data) {
		$('#change_room_batch').empty();
		$('#change_room_batch').html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
});

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#rooms-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#room_name').val();
		var capacity = $('#room_capacity').val();
		var roomtype = $('#room_roomtype').val();
		var employee = $('#room_employee_id').val();
		var numericity_check = numericTest();
		var special_char = isSpclChar();
		var stringReg = /^[A-Za-z() ]*$/;
		if(numericity_check[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter numbers in '+numericity_check[1], {
				type : 'warning'
			});
			return false;
		}
		if(special_char[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in '+special_char[1], {
				type : 'warning'
			});
			return false;
		}
		 if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter a name for Room', {
				type : 'warning'
			});
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		} else if(!capacity || capacity.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the capacity', {
				type : 'warning'
			});
		} else if(capacity.length > 4) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum capacity length should 4 digit', {
				type : 'warning'
			});
		} else if(!roomtype || roomtype.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select the Room Type', {
				type : 'warning'
			});
		} else if(!employee || employee.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select a Owner for Room', {
				type : 'warning'
			});
		} else{
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/rooms'
			var status = $("input[name='room\\[status\\]']:checked").val();
			var batch = $('#room_batch_id').val();
			
			// Request
			var data = {
				'room[name]' : name,
				'room[capacity]' : capacity,
				'room[status]' : status,
				'room[roomtype]' : roomtype,
				'room[batch_id]' : batch,
				'room[employee_id]' : employee
			}

			ajaxCreate(target, data, updateRoomsTable, submitBt);
			resetRoomForm();
		}
	});
});

$(document).ready(function() {
	$('#update_room').on('click', function(event) {
		var name = $('#room_name').val();
		var capacity = $('#room_capacity').val();
		var roomtype = $('#room_roomtype').val();
		var employee = $('#room_employee_id').val();
		var numericity_check = numericTest();
		var special_char = isSpclChar();
		var stringReg = /^[A-Za-z() ]*$/;
		if(numericity_check[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter numbers in '+numericity_check[1], {
				type : 'warning'
			});
			return false;
		}
		else if(special_char[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Special Character are not allowed in '+special_char[1], {
				type : 'warning'
			});
			return false;
		}
		else if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter a name for Room', {
				type : 'warning'
			});
		} else if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		} else if(!capacity || capacity.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter capacity', {
				type : 'warning'
			});
		} else if(capacity.length > 4) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum capacity length should 4 digit', {
				type : 'warning'
			});
		} else if(!roomtype || roomtype.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select the Room Type', {
				type : 'warning'
			});
		} else if(!employee || employee.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please select the Room Owner', {
				type : 'warning'
			});
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();

			var status = $("input[name='room\\[status\\]']:checked").val();
			var batch = $('#room_batch_id').val();
			

			// Target url
			var target = "/rooms/" + current_object_id
			// Request
			var data = {
				'room[name]' : name,
				'room[capacity]' : capacity,
				'room[status]' : status,
				'room[roomtype]' : roomtype,
				'room[batch_id]' : batch,
				'room[employee_id]' : employee,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateRoomsTable, submitBt);
			resetRoomForm();
		}
	});
});

$(document).ready(function() {
	resetRoomForm();
	$('#reset_room').on('click', function(event) {
		resetRoomForm();
	});
});

$(document).on("click", 'a.delete-room-href', function(event) {
	resetRoomForm();
	$('html, body').animate({ scrollTop: 0 }, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-room-href', function(event) {
	resetRoomForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#room_name').val($('#room_name_' + object_id).text());
	$('#room_capacity').val($('#room_capacity_' + object_id).html());
	$('#room_roomtype').val($('#room_roomtype_' + object_id).html());
	$('#room_employee_id').val(document.getElementById('room_employee_' + object_id).value);
	$('#room_batch_id').val(document.getElementById('room_batch_' + object_id).value);
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table-room')
		$('#room_status_true').attr('checked', true);
	else
		$('#room_status_false').attr('checked', true);

	$('#update_room').attr("disabled", false);
	$('#create_room').attr("disabled", true);
	return false;
});
function resetRoomForm() {
	// $('html, body').animate({
		// scrollTop : 0
	// }, slow);
	$('#room_name').val("");
	$('#room_capacity').val("");
	$('#room_roomtype').val("");
	$('#room_batch_id').val("");
	$('#room_employee_id').val("");
	$('#room_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#update_room').attr("disabled", true);
	$('#create_room').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
	$('#advv_room_search_course_id').val("Select");
	$('#tab-active').showTab();
}