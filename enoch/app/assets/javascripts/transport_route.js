//handler - should call upon succes of ajax call
var updateRouteTableFunction = function(data) {
	$.get('/transport_routes', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureSchoolTransportRoute($('#active-table'));
		configureSchoolTransportRoute($('#inactive-table'));
		$('.tabs').updateTabs();
		$('#update_route').attr("disabled", true);
		$('#create_route').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}

$(document).ready(function() {

	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#transport_route-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();

		// Check fields
		var name = $('#transport_route_name').val();
		var start_place = $('#transport_route_start_place').val();
		var end_place = $('#transport_route_end_place').val();
		var distance = $('#transport_route_distance').val();
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var character_length=charactersLength();
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter name', {
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
		
		if(!start_place || start_place.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter start place', {
				type : 'warning'
			});
		} else if(!end_place || end_place.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter end place', {
				type : 'warning'
			});
		}else if(distance.length == 0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter route distance', {
			type : 'warning'
		});
		return false;
		} else  if(!numericReg.test(distance)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter route distance in Numeric format', {
			type : 'warning'
		});
		return false;
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();

			// Target url
			var target = '/transport_routes'

			var status = $("input[name='transport_route\\[status\\]']:checked").val();
			// Request
			var data = {
				'transport_route[start_place]' : start_place,
				'transport_route[end_place]' : end_place,
				'transport_route[distance]' : distance,
				'transport_route[name]' : name,
				'transport_route[status]' : status
			}

			ajaxCreate(target, data, updateRouteTableFunction, submitBt);
			resetRouteForm();
		}
	});
});

$(document).ready(function() {
	$('#update_route').on('click', function(event) {
		var name = $('#transport_route_name').val();
		var start_place = $('#transport_route_start_place').val();
		var end_place = $('#transport_route_end_place').val();
		var distance = $('#transport_route_distance').val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	    var stringReg = /^[a-z+\s+A-Z()]*$/
	    var character_length=charactersLength();
	    
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter name', {
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
		 if(distance.length == 0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter route distance', {
			type : 'warning'
		});
		return false;
	}
	 if(!numericReg.test(distance)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter route distance in Numeric format', {
			type : 'warning'
		});
		return false;
	}
	
		if(!start_place || start_place.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter start place', {
				type : 'warning'
			});
		} else if(!end_place || end_place.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter end place', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();

			var current_object_id = $('#current_object_id').val();
			var status = $("input[name='transport_route\\[status\\]']:checked").val();
			// Target url
			var target = "/transport_routes/" + current_object_id
			// Request
			var data = {
				'transport_route[start_place]' : start_place,
				'transport_route[end_place]' : end_place,
				'transport_route[distance]' : distance,
				'transport_route[name]' : name,
				'transport_route[status]' : status,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateRouteTableFunction, submitBt);
			resetRouteForm();
		}
	});
});

$(document).ready(function() {
	resetRouteForm();
	$('#reset_route').on('click', function(event) {
		resetRouteForm();
	});
});

$(document).on("click", 'a.delete-transport_route-master-href', function(event) {
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

$(document).on("click", 'a.update-transport_route-master-href', function(event) {
	resetRouteForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#transport_route_start_place').val($('#route_start_place_' + object_id).html());
	$('#transport_route_name').val($('#route_name_' + object_id).html());
	$('#transport_route_end_place').val($('#route_end_place_' + object_id).html());
	$('#transport_route_distance').val($('#route_distance_' + object_id).html());
	$('#current_object_id').val(object_id);

	var name = table.attr("id");
	if(name == 'active-table'){
		$('#transport_route_status_true').attr('checked', true);
	}
	else{
		$('#transport_route_status_false').attr('checked', true);
	}
	$('#update_route').attr("class","");
    $('#create_route').attr("disabled", true);
	$('#update_route').attr("disabled", false);
	
	return false;
});
function resetRouteForm() {

	$('#transport_route_start_place').val("");
	$('#transport_route_end_place').val("");
	$('#transport_route_distance').val("");
	$('#transport_route_name').val("");
	$('#transport_route_status_true').attr('checked', true);
	$('#current_object_id').val("");
	$('#create_route').attr("class","");
	$('#create_route').attr("disabled", false);
	$('#update_route').attr("disabled", true);
	$('#tab-active').showTab();
	$('#outer_block').removeBlockMessages();
}

function charactersLength() {
	var character_array=new Array();
	var classfield = null;
	
	$(".full-length").each(function() {
		if($(this).val().length >= 50) {
			classfield = false;
				field_name=$(this).attr('field_name')
			    character_array.push(classfield , field_name)
		}
	});
	return character_array;;
}
