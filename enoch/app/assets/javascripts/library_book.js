
var updatebookTable = function(data) {


	$.get('/library_books', function(data) {
		$('#table-block').empty();
		$('#table-block').html(data);
		configureBookTable($('#book'));
		$('.tabs').updateTabs();
		$('#update_book').attr("disabled", true);
		$('#create_book').attr("disabled", false);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
    $.get('/library_books/library_select_update', function(data1) {
		$('.change_select').empty();
		$('.change_select').html(data1);
		
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
}


	
	$('#book-form').submit(function(event) {
		// Stop full page load
		event.preventDefault();
		var name = $('#library_book_name').val();
		var title = $('#library_book_title').val();
		var copies = $('#library_book_no_of_copies').val();
		var author = $('#select_authors').val();
		var tag = $('#select_tags').val();
		var custom = $('#custom_tag_input').val();
		var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
		var status = $('#library_book_status').is(':checked')
		var tagvalue = ""
		var numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/ 
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter book Name', {
				type : 'warning'
			});
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		}else if(!characterReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Special character not allowed', {
				type : 'warning'
			});
		}else if(tag.length == 0 && custom.length == 0)
		{
			$('#outer_block').removeBlockMessages().blockMessage('Please select tag or enter custom tag', {
				type : 'warning'
			});
		}
		// else if(copies.length == 0 || copies.length > 2 || copies == 0)
		// {
			// $('#outer_block').removeBlockMessages().blockMessage('Please enter copies minimum 1 maximum with 2 digit', {
				// type : 'warning'
			// });
		// }
		else if(copies.length > 0 && !numericReg_for_nomeric.test(copies)) {
			$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed', {
				type : 'warning'
			});
		}else  {
			if(copies.length == 0)
			{
				copies = 0;
				
			}
			if(tag.length != 0 )
			{
				tagvalue = tag
			}
			else{
				tagvalue = custom
			}
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			var target = '/library_books'
			
			// Requ@elective_skillsest
			var data = {
				'library_book[name]' : name,
				'library_book[title]' : title,
				'library_book[no_of_copies]' : copies,
				'library_book[available_no_of_copies]' : copies,
				'library_book[library_author_id]' : author,
				'library_book[library_tag_id]' : tagvalue,
				'library_book[status]' : status,
			}

			ajaxCreate(target, data, updatebookTable, submitBt);
			resetbookForm();

		}
	});



	$(document).on("click", "#update_book", function(event) {
		
		event.preventDefault();
		var name = $('#library_book_name').val();
		var title = $('#library_book_title').val();
		var copies = $('#library_book_no_of_copies').val();
		var author = $('#select_authors').val();
		var tag = $('#select_tags').val();
		var custom = $('#custom_tag_input').val();
		var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
		var status = $('#library_book_status').is(':checked')
		var tagvalue = ""
		var available_copy = ""
		var numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/ 
		if(!name || name.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter book Name', {
				type : 'warning'
			});
		} else if(name.length > 25) {
			$('#outer_block').removeBlockMessages().blockMessage('Maximum character length for name should 25', {
				type : 'warning'
			});
		}else if(!characterReg.test(name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Special character not allowed', {
				type : 'warning'
			});
		}else if(tag.length == 0 && custom.length == 0)
		{
			$('#outer_block').removeBlockMessages().blockMessage('Please select tag or enter custom tag', {
				type : 'warning'
			});
		}
		// else if(copies.length == 0 || copies.length > 2 || copies == 0)
		// {
			// $('#outer_block').removeBlockMessages().blockMessage('Please enter copies minimum 1 maximum with 2 digit', {
				// type : 'warning'
			// });
		// }
		else if(copies.length > 0 && !numericReg_for_nomeric.test(copies)) {
			$('#outer_block').removeBlockMessages().blockMessage('Only numeric value allowed', {
				type : 'warning'
			});
		}else  {
			if(copies.length == 0)
			{
				copies = 0;
			}
			if(tag.length != 0 )
			{
				tagvalue = tag
			}
			else{
				tagvalue = custom
			}
			var submitBt = $(this).find('button[type=submit]');
			submitBt.disableBt();
			var current_object_id = $('#current_object_id').val();
			 available = parseInt(document.getElementById('available_value_'+ current_object_id).value)
			 old_copies = parseInt($('#book_copies_' + current_object_id).text())
			 new_copies = parseInt(copies)
			 if(new_copies < old_copies)
			 {
			 	available_copy = available - (old_copies - new_copies)
			 }
			 else if(new_copies > old_copies)
			 {
			 	available_copy = available + ( new_copies - old_copies )
			 }
			var target = '/library_books/' + current_object_id
			
			// Requ@elective_skillsest
			if(available_copy == "")
			{
				var data = {
				'library_book[name]' : name,
				'library_book[title]' : title,
				'library_book[no_of_copies]' : copies,
				'library_book[library_author_id]' : author,
				'library_book[library_tag_id]' : tagvalue,
				'library_book[status]' : status,
				'_method' : 'put'
			}
			}
			else
			{
			var data = {
				'library_book[name]' : name,
				'library_book[title]' : title,
				'library_book[no_of_copies]' : copies,
				'library_book[library_author_id]' : author,
				'library_book[available_no_of_copies]' : available_copy,
				'library_book[library_tag_id]' : tagvalue,
				'library_book[status]' : status,
				'_method' : 'put'
			}
			}
			
			// Requ@elective_skillsest
			
			ajaxUpdate(target, data, updatebookTable, submitBt);
			resetbookForm();

		}
	});


$(document).ready(function() {
	resetbookForm();
	$(document).on("click", "#reset_book", function(event) {
		resetbookForm();
	});
});
function resetbookForm() {

	$('#library_book_name').val("");
	$('#library_book_title').val("");
	$('#library_book_no_of_copies').val("");
	$('#select_authors').val("");
	$('#select_tags').val("");
	$('#custom_tag_input').val("");
	$('#current_object_id').val("");
	$('#update_book').attr("disabled", true);
	$('#create_book').attr("disabled", false);
	$('#outer_block').removeBlockMessages();

}


$(document).on("click", "a.update-book-href", function(event) {
	resetbookForm();
	
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
		$('#library_book_name').val($('#book_name_' + object_id).html());
		$('#library_book_title').val($('#book_title_' + object_id).html());
		$('#library_book_no_of_copies').val($('#book_copies_' + object_id).html());
		var author = document.getElementById('author_id_value_'+ object_id).value
		$('#select_authors').val(author);
		$('#select_tags').val(document.getElementById('tag_id_value_'+ object_id).value);
		$('#custom_tag_input').val("");
	if($('#book_status_' + object_id).html() == "Active")
	{
		$('#library_book_status').attr('checked',true)
	}else
	{
		$('#library_book_status').attr('checked',false)
	}
	
	$('#current_object_id').val(object_id);
	$('#update_book').attr("class", "");
	$('#update_book').attr("disabled", false);
	$('#create_book').attr("disabled", true);
	
});

$(document).on("click", "a.delete-book-href", function(event) {
	resetbookForm();
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = $('#url_prefix').val();
	var remoteUrl = url_prefix + "/" + object_id;
	confirmDeletelibrary_book(remoteUrl, table, row);
	return false;
});
//-----------------------------------------------------------------


function confirmDeletelibrary_book(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeletebook(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeletebook(remoteUrl, table, row) {
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