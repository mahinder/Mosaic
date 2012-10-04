var updateauthorsTable = function(data) {


	$.get('/library_authors', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureTagTable($('#tag'));
		
		$('.tabs').updateTabs();
		$('#update_author').attr("disabled", true);
		$('#create_author').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}


	
	$('#author-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var name = $('#library_author_name').val();
		
		var stringReg = /^[A-Za-z() ]*$/;
		var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter author Name', {
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
			var target = '/library_authors'
			
			// Requ@elective_skillsest
			var data = {
				'library_author[name]' : name,
				
			}

			ajaxCreate(target, data, updateauthorsTable, submitBt);
			resetAuthorForm();

		}
	});



	$(document).on("click", "#update_author", function(event) {
		event.preventDefault();
		var name = $('#library_author_name').val();

		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter author Name', {
				type : 'warning'
			});
		} else {
			var submitBt = $(this);
			submitBt.disableBt();
			var current_object_id = $('#current_object_id').val();

			var target = '/library_authors/' + current_object_id
			
			// Requ@elective_skillsest
			var data = {
				'library_author[name]' : name,
				'_method' : 'put'
				
			}

			ajaxUpdate(target, data, updateauthorsTable, submitBt);
			resetAuthorForm();

		}
	});


$(document).ready(function() {
	resetAuthorForm();
	$(document).on("click", "#reset_author", function(event) {
		resetAuthorForm();
	});
});
function resetAuthorForm() {

	$('#library_author_name').val("");
	$('#current_object_id').val("");
	$('#update_author').attr("disabled", true);
	$('#create_author').attr("disabled", false);
	$('#outer_block').removeBlockMessages();

}


$(document).on("click", "a.update-author-href", function(event) {
	resetAuthorForm();
	
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();

	$('#library_author_name').val($('#author_name_' + object_id).html());
	$('#current_object_id').val(object_id);
	$('#update_author').attr("class", "");
	$('#update_author').attr("disabled", false);
	$('#create_author').attr("disabled", true);
	
});

$(document).on("click", "a.delete-author-href", function(event) {
	resetAuthorForm();
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


function confirmDeletelibrary_author(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteauthor(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteauthor(remoteUrl, table, row) {
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