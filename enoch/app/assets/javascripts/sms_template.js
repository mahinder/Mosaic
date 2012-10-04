//handler - should call upon succes of ajax call
$(document).ready(function() {
	$("#sms_sending").fcbkcomplete({
		json_url : "/sms/find",
		addontab : true,
		maxitems : 10,
		input_min_size : 0,
		height : 10,
		cache : true,
		newel : true,
		select_all_text : "select",
	});

});
var updateSmsTable = function(data) {
	$.get('/sms_templates', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureSmsTable($('#active-table_sms'));
		configureSmsTable($('#inactive-table_sms'));
		$('.tabs').updateTabs();
		attachSmsDeleteHandler();
		attachSmsUpdateHandler();
	}).error(function(jqXHR, textStatus, errorThrown) {
		window.location.href = "/signin"
	});
}

$(document).ready(function() {
	// We'll catch form submission to do it in AJAX, but this works also with JS disabled
	$('#sms-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var code = $('#sms_template_template_code').val();
		var text = $('#sms_template_text').val();

		if(!code || code.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter code', {
				type : 'warning'
			});
		} else if(!text || text.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter template', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			// Target url
			var target = '/sms_templates'
			if($('#is_active_active').is(":checked")) {
				var is_inactive = false
			} else {
				var is_inactive = true
			}
			// Requ@elective_skillsest
			var data = {
				'sms_template[template_code]' : code,
				'sms_template[text]' : text,
				'sms_template[is_inactive]' : is_inactive,

			}

			ajaxCreate(target, data, updateSmsTable, submitBt);
			resetsmsForm();

		}
	});
});

$(document).ready(function() {
	$('#update_template').on('click', function(event) {
		event.preventDefault();
		var current_object_id = $('#current_object_id').val();
		var code = $('#sms_template_template_code').val();
		var text = $('#sms_template_text').val();

		if(!code || code.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter code', {
				type : 'warning'
			});
		} else if(!text || text.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter template', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			// Target url
			var target = '/sms_templates/' + current_object_id
			if($('#is_active_active').is(":checked")) {
				var is_inactive = false
			} else {
				var is_inactive = true
			}
			// Requ@elective_skillsest
			var data = {
				'sms_template[template_code]' : code,
				'sms_template[text]' : text,
				'sms_template[is_inactive]' : is_inactive,
				'_method' : 'put'
			}

			ajaxUpdate(target, data, updateSmsTable, submitBt);
			resetsmsForm();
		}
	});
});

$(document).ready(function() {
	attachSmsDeleteHandler();
});

$(document).ready(function() {
	attachSmsUpdateHandler();
});

$(document).ready(function() {
	// resetGradeForm();
	$('#reset_template').on('click', function(event) {
		resetsmsForm();
	});
});
function attachSmsDeleteHandler() {
	$('a.delete-template-href').on('click', function(event) {
		resetsmsForm();
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
}

function attachSmsUpdateHandler() {
	$('a.update-template-href').on('click', function(event) {
		$('html, body').animate({
			scrollTop : 0
		}, 0);
		resetsmsForm();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();

		$('#sms_template_template_code').val($('#template_code_' + object_id).html());
		$('#sms_template_text').val($('#template_text_' + object_id).text());
		// $('#employee_grade_max_hours_day').val($('#is_active_' + object_id).html());
		$('#current_object_id').val(object_id);

		var name = table.attr("id");
		if(name == 'active-table_sms') {
			$('#is_active_active').attr('checked', true);
		} else {
			$('#is_active_inactive').attr('checked', true);
		}
		$('#update_template').attr("disabled", false);
		$('#create_template').attr("disabled", true);
		$('#update_template').attr("class", "");
		return false;
	});
}

function resetsmsForm() {
	$('#sms_template_template_code').val("");
	$('#sms_template_text').val("");
	$('#is_active_active').attr('checked', true);
	$('#outer_block').removeBlockMessages();
	$('#update_template').attr("disabled", true);
	$('#create_template').attr("disabled", false);
	$('#outer_block').removeBlockMessages();
}


$(document).on("click", "#sms_all_courses", function(event) {
	if($(this).is(":checked")) {
		$('.sms_course_check').attr('checked', true);
	} else {
		$('.sms_course_check').attr('checked', false);
	}
})
$(document).on("click", ".sms_course_check", function(event) {
	$('#sms_all_courses').attr('checked', false);
	if($(this).is(":checked")) {
		$(this).attr('checked', true);
	} else {
		$(this).attr('checked', false);
	}

})
$(document).on("click", ".sms_send", function(event) {

	var departments = []
	var courses = []
	index2 = 0
	template = $('#template_text_box').val()
	jQuery.each($("#sms_all_courses_li input").filter('[checked = checked]'), function(event) {

		courses[index2] = $(this).attr('data_id')
		index2++
	})
	send_to_id = []
	index = 0
	$("#sms_sending option").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			send_to_id[index] = $(this).attr('value')
			index++
		} else {

		}

	})
	if(template.length == 0 || template.nil) {
		$('#outer_block').removeBlockMessages().blockMessage('Please Enter message! ', {
			type : 'warning'
		});
	} else if(template.length > 160) {
		$('#outer_block').removeBlockMessages().blockMessage('Please Enter message with maximum 160 characters!', {
			type : 'warning'
		});
	} else if(courses.length == 0 && send_to_id.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please select atleast one reciepient', {
			type : 'warning'
		});
	} else {
		$('#loader').html('Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />')
		$.getJSON('/sms/sms_emp_send', {
			send_to_id : send_to_id,
			courses : courses,
			template : template
		}, function(data) {
			if(data.valid) {
				window.location.reload();
			} else {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'error'
				});
				$('#loader').empty()
			}
		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
	}

})

$(document).ready(function() {
	$("#sms_templates_template_code").live("change", (function(event) {
		var str = "";

		$("#sms_templates_template_code option:selected").each(function() {
			str1 = $(this).val();
		});
		$.getJSON('/sms/template_find', {
			id : str1
		}, function(dataFromGetRequest) {
			$('#template_text_box').empty();
			$('#template_text_box').val(dataFromGetRequest.message);

		}).error(function(jqXHR, textStatus, errorThrown) {
			window.location.href = "/signin"
		});
	}));
});
