//handler - should call upon succes of ajax call
var updateBoardTableFunction = function(data) {
	$.get('/transport_boards', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureSchoolTransportBoard($('#active-table'));
		configureSchoolTransportBoard($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_board').attr("disabled", true);
		$('#create_board').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transport_board-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
 
		// Check fields
		var route = $('#transport_board_transport_route_id').val();
		var name = $('#transport_board_name').val();
		var picktime = $('#transport_board_picktime_4i').val();
		var droptime = $('#transport_board_droptime_4i').val();
		var picktimem = $('#transport_board_picktime_5i').val();
		var droptimem = $('#transport_board_droptime_5i').val();
		var passenger = $('#transport_board_no_of_passenger').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var character_length=charactersLength();
	    if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter name', {
				type : 'warning'
			});
			return false;
		}
		
		if(!passenger || passenger.length==0 || !numericReg.test(passenger)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter number of passengers in numeric', {
				type : 'warning'
			});
			return false;
		}
		if(!route || route.length==0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose transport route', {
				type : 'warning'
			});
			return false;
		}
		if(character_length[0] == false) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ character_length[1], {
					type : 'warning'
				});
				return false;
			}else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/transport_boards'

			var status = $("input[name='transport_board\\[status\\]']:checked").val();
			// Request
			var data = {
				'transport_board[transport_route_id]' : route,
				'transport_board[name]' : name,
				'transport_board[picktime]' : picktime+':'+picktimem,
				'transport_board[droptime]' : droptime+':'+droptimem,
				'transport_board[no_of_passenger]' : passenger,
				'transport_board[status]' : status
			}

			ajaxCreate(target, data, updateBoardTableFunction, submitBt);
			resetBoardForm();
		}
	});
});

$(document).ready(function() {
	$('#update_board').on('click', function(event) {
		var route = $('#transport_board_transport_route_id').val();
		var name = $('#transport_board_name').val();
		var picktime = $('#transport_board_picktime_4i').val();
		var droptime = $('#transport_board_droptime_4i').val();
		var picktimem = $('#transport_board_picktime_5i').val();
		var droptimem = $('#transport_board_droptime_5i').val();
		var passenger = $('#transport_board_no_of_passenger').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var character_length=charactersLength();
		if(!route || route.length==0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose transport route', {
				type : 'warning'
			});
			return false;
		}
		if(character_length[0] == false) {
				$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ character_length[1], {
					type : 'warning'
				});
				return false;
			}
		if(!passenger || passenger.length==0 || !numericReg.test(passenger)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter number of passengers in numeric', {
				type : 'warning'
			});
			return false;
		}
		
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter name', {
				type : 'warning'
			});
			return false;
		}else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='transport_board\\[status\\]']:checked").val();
			// Target url
			var target = "/transport_boards/" + current_object_id
			// Request
			var data = {
				'transport_board[transport_route_id]' : route,
				'transport_board[name]' : name,
				'transport_board[picktime]' : picktime+':'+picktimem,
				'transport_board[droptime]' : droptime+':'+droptimem,
				'transport_board[no_of_passenger]' : passenger,
				'transport_board[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateBoardTableFunction, submitBt);
			resetBoardForm();
		}
	});
});

$(document).ready(function() {
	resetBoardForm();
	$('#reset_board').on('click', function(event) {
		resetBoardForm();
	});
});

$(document).on("click", 'a.delete-transport_board-master-href', function(event) {
	resetRouteForm();
	$('html, body').animate({
		scrollTop : 0
	}, 0);
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDelete(remoteUrl, table, row);
	return false;
});

$(document).on("click", 'a.update-transport_board-master-href', function(event) {
	resetBoardForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	
	
	$('#transport_board_transport_route_id').val($('#board_route_names_' + object_id).val());
	$('#transport_board_name').val($('#board_name_' + object_id).html());
	$('#transport_board_picktime_4i').val(set_timing($('#board_picktime_' + object_id).text()));
	$('#transport_board_droptime_4i').val(set_timing($('#board_droptime_' + object_id).text()));
	$('#transport_board_droptime_5i').val(set_minute_timing($('#board_droptime_' + object_id).text()));
	$('#transport_board_picktime_5i').val(set_minute_timing($('#board_picktime_' + object_id).text()));
	$('#transport_board_no_of_passenger').val($('#board_passanger_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#transport_board_status_true').attr('checked', true);
	}
	else{
		$('#transport_board_status_false').attr('checked', true);
	}
	$('#update_board').attr("class","");
    $('#create_board').attr("disabled", true);
	$('#update_board').attr("disabled", false);
	
	return false;
});
function resetBoardForm() {

	$('#transport_board_transport_route_id').val("");
	$('#transport_board_name').val("");
	$('#transport_board_picktime_4i').val("");
	$('#transport_board_droptime_4i').val("");
	$('#transport_board_no_of_passenger').val("");
	$('#transport_board_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_board').attr("class","");
	$('#create_board').attr("disabled", false);
	$('#update_board').attr("disabled", true);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}
function set_timing(sunset){
	var hour = sunset.substring(0, sunset.length-5);
var forma = sunset.substring(5)
if (forma=='PM'){
	hour = parseInt(hour)+12
}
return hour
}
function set_minute_timing(sunset){
  return  sunset.substring(3, sunset.length-2)
}

function charactersLength() {
	var character_array=new Array();
	var classfield = null;
	
	$(".full-length").each(function() {
		if($(this).val().length >=50) {
			classfield = false;
				field_name=$(this).attr('field_name')
			    character_array.push(classfield , field_name)
		}
	});
	return character_array;;
}
