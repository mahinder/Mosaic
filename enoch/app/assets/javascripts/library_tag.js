var updatetagTable = function(data) {


	$.get('/library_tags', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTagTable($('#tag'));
		
		$('.tabs').updateTabs();
		$('#update_tag').attr("disabled", true);
		$('#create_tag').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}


	
	$('#tag-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var name = $('#library_tag_name').val();
		
		var stringReg = /^[A-Za-z() ]*$/;
		var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter tag Name', {
				type : 'warning'
			});
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		}else if(!stringReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for name', {
				type : 'warning'
			});
			return false;
		} else if(!characterReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Special character not allowed', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			var target = '/library_tags'
			
			// Requ@elective_skillsest
			var data = {
				'library_tag[name]' : name,
				
			}

			ajaxCreate(target, data, updatetagTable, submitBt);
			resetTagForm();

		}
	});



	$(document).on("click", "#update_tag", function(event) {
		event.preventDefault();
		var name = $('#library_tag_name').val();

		if(!name || name.length == 0) {
			$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter tag Name', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();
			var current_object_id = $('#current_object_id').val();

			var target = '/library_tags/' + current_object_id
			
			// Requ@elective_skillsest
			var data = {
				'library_tag[name]' : name,
				'_method' : 'put'
				
			}

			ajaxUpdate(target, data, updatetagTable, submitBt);
			resetTagForm();

		}
	});


$(document).ready(function() {
	resetTagForm();
	$(document).on("click", "#reset_tag", function(event) {
		resetTagForm();
	});
});
function resetTagForm() {

	$('#library_tag_name').val("");
	$('#current_object_id').val("");
	$('#update_tag').attr("disabled", true);
	$('#create_tag').attr("disabled", false);
	$('#outer_block').removeBlockMessages();

}


$(document).on("click", "a.update-tag-href", function(event) {
	resetTagForm();
	
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#library_tag_name').val($('#tag_name_' + object_id).html());
	$('#current_object_id').val(object_id);
	$('#update_tag').attr("class", "");
	$('#update_tag').attr("disabled", false);
	$('#create_tag').attr("disabled", true);
	
});

$(document).on("click", "a.delete-tag-href", function(event) {
	resetTagForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDeletelibrary_tag(remoteUrl, table, row);
	return false;
});
//-----------------------------------------------------------------


function confirmDeletelibrary_tag(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeletetag(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeletetag(remoteUrl, table, row) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				var dataTable = table.dataTable();
				dataTable.fnDeleteRow(row.index());

				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if(jqXHR.status === 403) {
				window.location.href = "/signin"
			} else {
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