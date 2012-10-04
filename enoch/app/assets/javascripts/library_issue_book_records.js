$("#book_issue").live("change", (function(event) {
	var aLink = $(this);
	var str = "";
	event.preventDefault();
	$("#book_issue option:selected").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			str = $(this).val();
		} else {
			$('#outer_block').removeBlockMessages().blockMessage("Please Enter Proper value", {
				type : 'warning'
			});
		}

	});
	if(str != "") {
		$.get('/library_issue_book_records/book_info', {
			id : str
		}, function(data) {

			if(data == "Book is not Available") {
				$('#outer_block').removeBlockMessages().blockMessage("Book is not Available", {
					type : 'warning'
				});
			} else if(data == "All copies of books are issued") {
				$('#outer_block').removeBlockMessages().blockMessage("All copies of books are issued", {
					type : 'warning'
				});
			} else {
				$("#person_issue_p").show();
				$(".book_issue_section1").empty();
				$(".book_issue_section1").html(data);

			}

		});
	} else {
		$("#person_issue_p").hide();
		$(".book_issue_section1").empty();
		$(".book_issue_section2").empty();
		$("#person_issue").empty();

	}

}));

$("#person_issue").live("change", (function(event) {
	var aLink = $(this);
	var str = "";
	event.preventDefault();
	$("#person_issue option:selected").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			str = $(this).val();
		} else {
			$('#outer_block').removeBlockMessages().blockMessage("Please Enter Proper value", {
				type : 'warning'
			});
		}

	});
	if(str != "") {
		$.get('/library_issue_book_records/person_info', {
			id : str
		}, function(data) {
			if(data == "Student/Employee is not Available") {
				$('#outer_block').removeBlockMessages().blockMessage("Student/Employee is not in Available", {
					type : 'warning'
				});
			} else if(data == "User has no book avail balance") {
				$('#outer_block').removeBlockMessages().blockMessage("User has no book avail balance", {
					type : 'warning'
				});
			} else {
				$(".book_issue_section2").empty();
				$(".book_issue_section2").html(data);

			}
		});
	} else {

		$(".book_issue_section2").empty();
	}

}));

$("#book_issue").fcbkmcomplete({
	json_url : "/library_issue_book_records/find_book/",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : true,
	newel : true,
	// select_all_text : "select",
});

$("#book_wise_record").fcbkmcomplete({
	json_url : "/library_issue_book_records/find_book/",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : true,
	newel : true,
	// select_all_text : "select",
});

$("#person_issue").fcbkmcomplete({

	json_url : "/library_issue_book_records/find_student_employee/",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : false,
	newel : true,
	// select_all_text : "select",
});

$(document).on('click', '#issue_book_button', function() {
	var person = $('#hidden_person').val()
	var book = $(this).attr('data_book')
	if(person === undefined) {
		$('#outer_block').removeBlockMessages().blockMessage("Please select user for book issue", {
			type : 'warning'
		});
	} else {
		$.get('/library_issue_book_records/issue', {
			person : person,
			book : book
		}, function(data) {

			if(data == "Book Issue Successfuly") {
				$('#outer_block').removeBlockMessages().blockMessage("Book Issued Successfully", {
					type : 'success'
				});
				// $("#person_issue_p").hide();
				// $(".book_issue_section1").empty();
				// $(".book_issue_section2").empty();
				// $("#book_issue").empty();
				// available = $('.available_books').val();
				// already = $('#already').val();
				// avail = $('.avail').val();
				// $('.available_books').val( parseInt(available) - 1);
				// $('#already').val(parseInt(already) + 1);
				// $('#avail').val(parseInt(avail) -1 );
				window.location.href = "/library_issue_book_records/"
			} else {

				$('#outer_block').removeBlockMessages().blockMessage(data, {
					type : 'error'
				});
			}
		});
	}
})

$("#person_issue_p").hide();

$(document).on('click', '#report_bookwise', function() {
	var book_id = ""
	book_id = $("#book_wise_record").val();
	
	if(book_id != "") {
		$.get('/library_issue_book_records/bookwisereport', {
			id : book_id,
			report : "books"
		}, function(data) {
			
			$('#main_block').html(data)
			configureBookwiseReportTable($('.bookwise_report'));
			
		});
		
	} else {
		$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
			type : 'warning'
		});

	}
})

$("#book_return").live("change", (function(event) {
	var aLink = $(this);
	var str = "";
	event.preventDefault();
	$("#book_return option:selected").each(function() {
		if($(this).attr('value').match('^(0|[1-9][0-9]*)$')) {
			str = $(this).val();
		} else {
			$('#outer_block').removeBlockMessages().blockMessage("Please Enter Proper value", {
				type : 'warning'
			});
		}

	});
	if(str != "") {
		$.get('/library_issue_book_records/issued_book_info', {
			id : str
		}, function(data) {

			$(".book_return_section1").empty();
			$(".book_return_section1").html(data);
		});
		$.get('/library_issue_book_records/person_issued_info', {
			id : str
		}, function(data) {

			$(".book_return_section2").empty();
			$(".book_return_section2").html(data);
			configureissuedpersonTable($('.book_return_info'));
		});
	} else {
		$(".book_return_section1").empty();
		$(".book_return_section2").empty();

	}

}));

$("#book_return").fcbkmcomplete({
	json_url : "/library_issue_book_records/find_issue_book/",
	addontab : true,
	maxitems : 1,
	input_min_size : 0,
	height : 10,
	cache : false,
	newel : true,
	// select_all_text : "select",
});

$(document).on("click", "a.return-book-href", function(event) {
	var aLink = $(this);
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	var url_prefix = "/library_issue_book_records/book_return"
	var remoteUrl = url_prefix + "/" + object_id;
	var numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/
	$.get('/library_issue_book_records/fineinfo', {
		id : object_id
	}, function(data) {
		if(data == "Fine Not Available") {
			confirmreturn(remoteUrl, table, row, 0, 0)
		} else {
			$.modal({
				content : data,
				title : 'Fine Information',
				maxWidth : 500,
				buttons : {
					'Collect' : function(win) {
						actual = $("#modal #Actual_fine_taken").val();
						already = $("#modal #all_fine_taken").val();
						if(actual.length == 0) {
							$('#modal #outer_block').removeBlockMessages().blockMessage("Please Enter fine amount", {
								type : 'warning'
							});
							return false;
						} else if(!numericReg_for_nomeric.test(actual)) {
							$('#modal #outer_block').removeBlockMessages().blockMessage('Only numeric value allowed ', {
								type : 'warning'
							});
						} else {
							alreadyamount = parseInt(already)
							actualamount = parseInt(actual);

							if(actualamount > alreadyamount) {
								$('#modal #outer_block').removeBlockMessages().blockMessage("fine amount should be equal or less then  calculated amount", {
									type : 'warning'
								});
								return false;
							} else {

								confirmreturn(remoteUrl, table, row, actualamount, alreadyamount)
								win.closeModal();
							}
						}

					},
					'Cancel' : function(win) {
						win.closeModal();
					}
				}
			});
		}

	});
	// confirmreturn(remoteUrl, table, row);
	return false;
});
//-----------------------------------------------------------------

function confirmreturn(remoteUrl, table, row, actualamount, alreadyamount) {

	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to return Book...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxReturn(remoteUrl, table, row, actualamount, alreadyamount);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxReturn(remoteUrl, table, row, actualamount, alreadyamount) {

	$.get(remoteUrl, {
		actualamount : actualamount,
		alreadyamount : alreadyamount
	}, function(data) {
		if(data == "Book Return Successfuly") {
			$('#outer_block').removeBlockMessages().blockMessage("Book Returned Successfully", {
				type : 'success'
			});
			available = $('.available_books').val();
			$('#available_books').val(available - 1);
			var dataTable = table.dataTable();
			dataTable.fnDeleteRow(row.index());
		} else {

			$('#outer_block').removeBlockMessages().blockMessage("Book is not available for return", {
				type : 'error'
			});

		}

	});
}