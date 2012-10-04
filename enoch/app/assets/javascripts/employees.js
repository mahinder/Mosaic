$(document).ready(function() {
	$("#my_batches_first_name_id").val(0)
	$("#batch_emp_class").hide()

	$("#my_batches_first_name_id").live("change", (function(event) {
		var str = "";
		event.preventDefault();
		$("#my_batches_first_name_id option:selected").each(function() {
			str = $(this).val();
			$("#batch_emp_class").hide()
		});
		if(str == "") {
			$('#employee_batch_student').empty();
		} else {
			$("#batch_loding").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 /><strong></strong>');
			$.get('/employees/search_batch_student', {
				id : str
			}, function(dataFromGetRequest) {
				$('#employee_batch_student').empty();
				$('#employee_batch_student').html(dataFromGetRequest);
				$('#batch_loding').empty();
				configureStudentTable($('.students-table'));
				$("#batch_emp_class").show()
			}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
		}
	}));
});
$(document).on("click", ".view_time_table", function(event) {
	var id = $('#my_batches_first_name_id').val();
	window.location.href = "/timetable/student_view/" + id

});

$(document).on("click", "#archive_employee", function(event) {
	var description = $('#remove_status_description').val();
	if (description.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Reason for leaving', {
				type : 'warning'
			});
			return false;
	}


});

$(document).on("click", ".select_employee", function(event) {
	var id = $(this).attr("data-id");
	var name = $(this).attr("data-name");
	$('#employee_reporting_manager_id').val(id);
	$('#reporting_text').val(name);
	$('#reporting').hide('slow');

});
// employee validation
$(document).on("click", "#next_button", function(event) {

	var current_step = $('#current_step').val();
	var employee_number = $('#employee_number').val();
	var first_name = $('#first_name').val();
	var last_name = $('#employee_last_name').val();
	var middle_name = $('#employee_middle_name').val();
	var father_name = $('#employee_father_name').val();
	var mother_name = $('#employee_mother_name').val();
	var spouse_name = $('#employee_spouse_name').val();
	var department = $('#employee_employee_department_id').val();
	var special_character = specialChar();
    var shift_start_time = $('#employee_shift_start_time_4i').val();
    var shift_end_time = $('#employee_shift_end_time_4i').val();
    var shift_startm_time = $('#employee_shift_start_time_5i').val();
    var shift_endm_time = $('#employee_shift_end_time_5i').val();
	var category = $('#employee_employee_category_id').val();
	var position = $('#employee_employee_position_id').val();
	var home_address_line1 = $('#employee_home_address_line1').val();
	var home_address_line2 = $('#employee_home_address_line2').val();
	var home_state = $('#employee_home_state').val();
	var home_city = $('#employee_home_city').val();
	var home_pincode = $('#employee_home_pin_code').val();
	var office_address_line1 = $('#employee_office_address_line1').val();
	var office_address_line2 = $('#employee_office_address_line2').val();
	var office_state = $('#employee_office_state').val();
	var office_city = $('#employee_office_city').val();
	var office_pincode = $('#employee_office_pin_code').val();
	var office_phone1 = $('#employee_office_phone1').val();
	var home_phone = $('#employee_home_phone').val();
	var office_phone2 = $('#employee_office_phone2').val();
	var fax = $('#employee_fax').val();
	var birth_date = $('#birth_date').val();
	var joining_date = $('#joining_date').val();
	var mobile = $('#employee_mobile_phone').val();
	var phone_format = /^(\+\d)*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2}$/;
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var email = $('#employee_email').val();
	var reg_for_date = /^\d{2}\-\d{2}\-\d{4}$/
	var image = $('#photo_id').val(); 
    var stringReg = /^[a-z+\s+A-Z()]*$/ 
    var length= charactersLength()
	var employee_qualification = $('#employee_qualification').val(); 
     var experience = $('#employee_experience_detail').val(); 
	if(current_step == 'summary') {
		var valid_employee_number=validateEmployeeNumber();

		var dob = new Date(birth_date.split("-")[2], birth_date.split("-")[0], birth_date.split("-")[1]);
	var doj = new Date(joining_date.split("-")[2], joining_date.split("-")[0], joining_date.split("-")[1]);
	if(!reg_for_date.test(birth_date) || !reg_for_date.test(joining_date))
		{
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid joining date or birth date', {
				type : 'warning'
			});
			return false;
		}
		else if(!employee_number || employee_number.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid Employee number', {
				type : 'warning'
			});
			return false;
		}else if(valid_employee_number == true) {
			$('#outer_block').removeBlockMessages().blockMessage('Employee Number already exists', {
				type : 'warning'
			});
			return false;
		}else if(!first_name || first_name.length == 0 ) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter First Name', {
				type : 'warning'
			});
			return false;

		}else if(!last_name || last_name.length == 0 ){
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Last Name', {
				type : 'warning'
			});
			return false;

		}else if(dob > doj || (dob.setHours(0, 0, 0, 0) == doj.setHours(0, 0, 0, 0))) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid joining date or birth date', {
				type : 'warning'

			});
			return false;
		}else if(!stringReg.test(first_name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for First Name', {
			type : 'warning'
		});
		return false;
	}else if(!stringReg.test(last_name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Last Name', {
			type : 'warning'
		});
		return false;
	}else if(!stringReg.test(middle_name)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Middle Name', {
			type : 'warning'
		});
		return false;
	}else if (special_character[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
			type : 'warning'
		});
		return false;

	}else if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
	}else if(current_step == 'professional') {
		if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
		if(experience.length > 500){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter Employee Experience Info Maximum 500 Characters', {
			type : 'warning'
		});
		return false;
	}
		if(!department || department.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the Department assigned to employee ', {
				type : 'warning'
			});
			return false;
		} else if(!category || category.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the Category assigned to employee', {
				type : 'warning'
			});
			return false;
		} else if(!position || position.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter the Position assigned to employee', {
				type : 'warning'
			});
			return false;
		}else if (special_character[0]==false){
			$('#outer_block').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});

			return false;

	   }else if(shift_start_time > shift_end_time){
			$('#outer_block').removeBlockMessages().blockMessage('Shift End Time can not be before the Shift Start Time ', {
				type : 'warning'
			});
			return false
			} else if(shift_start_time == shift_end_time && shift_startm_time == shift_endm_time || shift_startm_time > shift_endm_time ){
				$('#outer_block').removeBlockMessages().blockMessage('Shift End Time can not be equal to the Shift Start Time ', {
				type : 'warning'
			});
			return false
			}
	} else if(current_step == 'contact') {

		if (special_character[0]==false){
			$('#outer_block').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}
		if(isNaN(mobile) || mobile.indexOf(" ") != -1) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter 10 digit for Mobile', {
				type : 'warning'
			});

			return false;
		}
		if(mobile.length > 10) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter 10 digit for Mobile', {
				type : 'warning'
			});

			return false;
		}
		if(mobile.length < 10) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter 10 digit for mobile', {
				type : 'warning'

			});
			return false;
		}
		if(!email || email.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid Email', {
				type : 'warning'
			});
			return false;
		} 
		if(!emailReg.test(email)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter email in valid format', {
				type : 'warning'
			});

			return false;
		}
	      if(length[0]==false){
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
				type : 'warning'
			});
			return false;
		}
		if(!home_address_line1.length || home_address_line1.length ==0 ) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter home address line1 less than 25 characters', {
				type : 'warning'
			});
			return false;
		}  else if(!home_city || home_city.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter home city less than 25 characters', {
				type : 'warning'
			});

			return false;
		}else if(office_pincode.length > 0) {
			var pincode = pincode_validation();
			if(pincode == false) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid office pincode 6 digit', {
					type : 'warning'
				});

				return false;
			}
		} else if(!home_pincode || home_pincode.length < 6 || home_pincode.length == 0 || home_pincode.length > 6 || !numericReg.test(home_pincode)) {


				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid home pincode 6 digit', {
					type : 'warning'
				});

				return false;

		} else if(office_phone1.length > 0) {
			var phone = phone_validation();
			if(phone == 'invalid') {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid office phone1 number, 7-11 digit', {
					type : 'warning'
				});

				return false;
			}
		} else if(home_phone.length > 0) {
			var phone = phone_validation();
			if(phone == 'invalid') {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid home phone number, 7-11 digit', {
					type : 'warning'
				});

				return false;
			}
		} else if(office_phone2.length > 0) {
			var phone = phone_validation();
			if(phone == 'invalid') {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid office phone2 number, 7-11 digit', {
					type : 'warning'
				});

				return false;
			}
		}
		if(fax.length > 0) {
			var phone = phone_validation();
			if(phone == 'invalid') {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid fax number, 7-11 digit', {
					type : 'warning'
				});

				return false;
			}
		}
		  if(!stringReg.test(office_state)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for office state', {
			type : 'warning'
		});
		return false;
	}
	if(!stringReg.test(office_city)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for office city', {
			type : 'warning'
		});
		return false;
	}
	if(!stringReg.test(home_state)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for home state', {
			type : 'warning'
		});
		return false;
	}
	if(!stringReg.test(home_city)){
		$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for home city', {
			type : 'warning'
		});
		return false;
	}

	}

	if(current_step == 'personal') {
	    var stringReg = /^[a-z+\s+A-Z()]*$/
		var children_count = $('#employee_children_count').val();
		var spouse_name = $('#employee_husband_name').val();
		if(length[0]==false){
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
		if(children_count != "" && !numericReg.test(children_count)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter no of children in numeric format', {
				type : 'warning'
			});
			return false;
		}else if(children_count.length > 1) {
			$('#outer_block').removeBlockMessages().blockMessage('Wrong input for children count', {
				type : 'warning'
			});
			return false;
		} else if(!stringReg.test(father_name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for father name', {
				type : 'warning'
			});
			return false;
		} else if(!stringReg.test(mother_name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for mother name', {
				type : 'warning'
			});
			return false;
		} else if(!stringReg.test(spouse_name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for spouse name', {
				type : 'warning'
			});
			return false;
		} 
	}
	if(current_step == 'photo') {
	
		var photo_file = $('#photo_id').val();
		if(!photo_file || photo_file.length==0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please choose image file', {
				type : 'warning'
			});
			return false;
		}
		var imgpath = document.getElementById('photo_id').value;
	var nImg = document.getElementById('photo_id');
	var imageSize = nImg.files[0].size
	if(imageSize > 3145728) {
		$('#outer_block').removeBlockMessages().blockMessage('Image Size can not exceed 3 MB', {
			type : 'warning'
		});
		return false;
	}
	var checkimg = imgpath.toLowerCase();
	if(!checkimg.length == 0) {
		if(!checkimg.match(/(\.jpg|\.gif|\.png|\.JPG|\.GIF|\.PNG|\.jpeg|\.JPEG)$/)) {
			event.preventDefault();
			$('#outer_block').removeBlockMessages().blockMessage('Image Extension must be one of [.gif  or .jpg or .jpeg or .png]', {
				type : 'warning'
			});
		} else {
			return true;
		}
	}

	}
});
//modal save validation
$(document).on("submit", "#photo_form", function(event) {

	var emp_photo = $('#employee_employee_photo').val();
	if(!emp_photo || emp_photo.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please choose image file', {
			type : 'warning'
		});
		return false
	}
	var imgpath = document.getElementById('employee_employee_photo').value;
	var nImg = document.getElementById('employee_employee_photo');
	var imageSize = nImg.files[0].size
	if(imageSize > 3145728) {
		$('#outer_block').removeBlockMessages().blockMessage('Image Size can not exceed 3 MB', {
			type : 'warning'
		});
		return false;
	}
	var checkimg = imgpath.toLowerCase();
	if(!checkimg.length == 0) {
		if(!checkimg.match(/(\.jpg|\.gif|\.png|\.JPG|\.GIF|\.PNG|\.jpeg|\.JPEG)$/)) {
			event.preventDefault();
			$('#outer_block').removeBlockMessages().blockMessage('Image Extension must be one of [.gif  or .jpg or .jpeg or .png]', {
				type : 'warning'
			});
		} else {
			return true;
		}
	}

});
//change reporting manager search

$('#reporting_text').keyup(function() {
	$('#reporting').show();
	var reporting = $('#reporting_text').val();
	$.get('/employees/select_reporting_manager?q=' + reporting, function(data) {
		$('#reporting').empty();
		$('#reporting').html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	return false;
});
//reporting manager search
$(document).on("click", "#manager_search", function(event) {
	var reporting = $('#reporting_text').val();
	$.get('/employees/select_reporting_manager?q=' + reporting, function(data) {

		$('#reporting').empty();
		$('#reporting').html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	return false;
});
// skills search button

$(document).on("click", "#skill_search_button", function(event) {
	var skill = $('#skill_text').val();
	$.get('/employees/search_skill?q=' + skill, function(data) {
		$('#skills').empty();
		$('#skills').html(data);
		$('#skills').show();
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	return false;

});
// serach button coding
$(document).on("click", "#search_button", function(event) {
	var emp = $('#test').val();
	var name = $('#search').val();
	$.get('/employees/search_ajax?q=' + name, function(data) {
		$('#information').empty();
		$('#information').html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	return false;
});
// back button coding

//edit employee step1
$(document).on("click", "#general_button", function(event) {
	var shift_start_time = $('#employee_shift_start_time_4i').val();
    var shift_end_time = $('#employee_shift_end_time_4i').val();
    var shift_startm_time = $('#employee_shift_start_time_5i').val();
    var shift_endm_time = $('#employee_shift_end_time_5i').val();
	var employee_qualification = $('#employee_qualification').val();
	var position = $('#employee_employee_position_id').val();
	var special_character = specialChar();
	var length= charactersLength()
	if (special_character[0]==false){
			$('#tab-settings').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}
		if(length[0]==false){
		$('#tab-settings').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}	
	if(shift_start_time > shift_end_time){
			$('#tab-settings').removeBlockMessages().blockMessage('shift end time can not be before the shift start time ', {
				type : 'warning'
			});
			return false
			} else if(shift_start_time == shift_end_time && shift_startm_time == shift_endm_time || shift_startm_time > shift_endm_time ){
				$('#tab-settings').removeBlockMessages().blockMessage('shift end time can not be equal to the shift start time ', {
				type : 'warning'
			});
			return false
			}
			if(!position || position.length == 0) {
			$('#tab-settings').removeBlockMessages().blockMessage('Please enter the Position assigned to employee', {
				type : 'warning'
			});
			return false;
		}
});





$(document).on("click", "#general_button1", function(event) {

	var employee_number = $('#employee_number').val();
	var first_name = $('#first_name').val();
	var length= charactersLength()
	var middle_name = $('#employee_middle_name').val();
	var last_name = $('#employee_last_name').val();
	var birth_date = $('#birth_date').val();
	var joining_date = $('#joining_date').val();
	var special_character = specialChar();
	var phone_format = /^(\+\d)*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2}$/;
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   var reg_for_date = /^\d{2}\-\d{2}\-\d{4}$/
   var stringReg = /^[a-z+\s+A-Z()]*$/
	var dob = new Date(birth_date.split("-")[2], birth_date.split("-")[0], birth_date.split("-")[1]);
	var doj = new Date(joining_date.split("-")[2], joining_date.split("-")[0], joining_date.split("-")[1]);
	if(!reg_for_date.test(birth_date) || !reg_for_date.test(joining_date))
		{
			$('#tab-global').removeBlockMessages().blockMessage('Please enter valid joining date or birth date', {
				type : 'warning'
			});
			return false;
		}
	if(!employee_number || employee_number.length == 0) {

		// $('#tab-global').removeBlockMessages();
		$('#tab-global').blockMessage('Please enter valid Employee number', {
			type : 'warning'
		});
		return false;
	}
   if(length[0]==false){
		$('#tab-global').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
	if(!first_name || first_name.length == 0 ) {
		$('#tab-global').removeBlockMessages().blockMessage('Please enter First Name', {
			type : 'warning'
		});
		return false;
	}else if(!last_name || last_name.length == 0 ) {
		$('#tab-global').removeBlockMessages().blockMessage('Please enter Last Name', {
			type : 'warning'
		});
		return false;
	} else if(middle_name.length > 25) {
		$('#tab-global').removeBlockMessages().blockMessage('Please enter Middle Name Maximum 25 Characters', {
			type : 'warning'
		});
		return false;
	} else if (special_character[0]==false){
			$('#tab-global').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}
	if(dob > doj || (dob.setHours(0, 0, 0, 0) == doj.setHours(0, 0, 0, 0))) {
		$('#tab-global').removeBlockMessages().blockMessage('Please enter valid joining date or birth date', {
			type : 'warning'

		});
		return false;
	}
		 if(!stringReg.test(first_name)){
		$('#tab-global').removeBlockMessages().blockMessage('Please enter characters for first name', {
			type : 'warning'
		});
		return false;
	}
		  if(!stringReg.test(last_name)){
		$('#tab-global').removeBlockMessages().blockMessage('Please enter characters for last name', {
			type : 'warning'
		});
		return false;
	}
		  if(!stringReg.test(middle_name)){
		$('#tab-global').removeBlockMessages().blockMessage('Please enter characters for middle name', {
			type : 'warning'
		});
		return false;
	}
});
//step2
$(document).on("click", "#general_button2", function(event) {
    var stringReg = /^[a-z+\s+A-Z()]*$/
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var father_name = $('#employee_father_name').val();
	var mother_name = $('#employee_mother_name').val();
	var spouse_name = $('#employee_husband_name').val();
	var length= charactersLength()
	var children_count = $('#employee_children_count').val();
	var special_character = specialChar();
	if (special_character[0]==false){
			$('#tab-relations').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}
	if(length[0]==false){
		$('#tab-relations').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}

	if(children_count != "" && !numericReg.test(children_count)) {
		$('#tab-relations').removeBlockMessages().blockMessage('Please enter no of children in numeric format', {
			type : 'warning'
		});
		return false;
	   }else if(children_count.length > 1) {
			$('#tab-relations').removeBlockMessages().blockMessage('Wrong input for children count', {
				type : 'warning'
			});
			return false;
	   }else if(father_name.length > 25) {
		$('#tab-relations').removeBlockMessages().blockMessage('Please enter Father Name, Maximum 25 Characters', {
			type : 'warning'
		});
		return false;
	} else if(!stringReg.test(father_name)) {
			$('#tab-relations').removeBlockMessages().blockMessage('Please enter characters for father name', {
				type : 'warning'
			});
			return false;
		}  else if(mother_name.length > 25) {
		$('#tab-relations').removeBlockMessages().blockMessage('Please enter Mother Name, Maximum 25 Characters', {
			type : 'warning'
		});
		return false;
	} else if(!stringReg.test(mother_name)) {
			$('#tab-relations').removeBlockMessages().blockMessage('Please enter characters for mother name', {
				type : 'warning'
			});
			return false;
		}  else if(spouse_name.length > 25) {
		$('#tab-relations').removeBlockMessages().blockMessage('Please enter Spouse Name, Maximum 25 Characters', {
			type : 'warning'
		});
		return false;
	} else if(!stringReg.test(spouse_name)) {
			$('#tab-relations').removeBlockMessages().blockMessage('Please enter characters for spouse name', {
				type : 'warning'
			});
			return false;
		} 
});
//profession
$(document).on("click", "#general_button3", function(event) {
	var mobile = $('#employee_mobile_phone').val();
	var phone_format = /^(\+\d)*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2}$/;
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var email = $('#employeeee').val();
	var special_character = specialChar();
	var home_phone = $('#employee_home_phone').val();
	if(!email || email.length==0) {
		$('#tab-locales').removeBlockMessages().blockMessage('Please enter valid Email', {
			type : 'warning'
		});

		return false;
	}
	if(!emailReg.test(email)) {
		$('#tab-locales').removeBlockMessages().blockMessage('Please enter email in valid format', {
			type : 'warning'
		});

		return false;
	}

	if(isNaN(mobile) || mobile.indexOf(" ") != -1) {
		$('#tab-locales').removeBlockMessages().blockMessage('Please enter 10 digit for Mobile', {
			type : 'warning'
		});
		return false;
	}
	if(mobile.length > 10) {
		$('#tab-locales').removeBlockMessages().blockMessage('Please enter 10 digit for Mobile', {
			type : 'warning'
		});

		return false;
	}
	if(mobile.length < 10) {
		$('#tab-locales').removeBlockMessages().blockMessage('Please enter 10 digit for Mobile', {
			type : 'warning'
		});

		return false;
	}
	if(home_phone.length > 0) {
		var phone = phone_validation();
		if(phone == 'invalid') {
			$('#tab-locales').removeBlockMessages().blockMessage('Please enter valid home phone number, 7-11 digit', {
				type : 'warning'
			});

			return false;
		}
	} else if (special_character[0]==false){
			$('#tab-locales').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}

});
//home address
$(document).on("click", "#general_button4", function(event) {
	var home_address_line1 = $('#employee_home_address_line1').val();
	var home_address_line2 = $('#employee_home_address_line2').val();
	var home_state = $('#employee_home_state').val();
	var home_city = $('#employee_home_city').val();
	var home_pincode = $('#employee_home_pin_code').val();
	var stringReg = /^[a-z+\s+A-Z()]*$/
	var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
	var length= charactersLength()
	var special_character = specialChar();
     // true
   // true

   if(!stringReg.test(home_state)){
		$('#home_address').removeBlockMessages().blockMessage('Please enter characters for home state', {
			type : 'warning'
		});
		return false;
	}
	if(!stringReg.test(home_city)){
		$('#home_address').removeBlockMessages().blockMessage('Please enter characters for home city', {
			type : 'warning'
		});
		return false;
	}
   if(length[0]==false){
		$('#home_address').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	} else if(home_pincode.length > 0) {
		var pincode = pincode_validation();
		if(pincode == false) {
			$('#home_address').removeBlockMessages().blockMessage('Please enter valid home pincode 6 digit', {
				type : 'warning'
			});

			return false;
		}
	}else if (special_character[0]==false){
			$('#home_address').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}
});
//office address validation
$(document).on("click", "#general_button5", function(event) {
	var office_address_line1 = $('#employee_office_address_line1').val();
	var office_address_line2 = $('#employee_office_address_line2').val();
	var office_state = $('#employee_office_state').val();
	var office_city = $('#employee_office_city').val();
	var office_pincode = $('#employee_office_pin_code').val();
	var office_phone1 = $('#employee_office_phone1').val();
	var office_phone2 = $('#employee_office_phone2').val();
	var special_character = specialChar();
	var length= charactersLength()
	var stringReg = /^[a-z+\s+A-Z()]*$/
	var fax = $('#employee_fax').val();

     // true
   // true
   if(length[0]==false){
		$('#office_address').removeBlockMessages().blockMessage('You can not enter more than 25 Characters for '+length[1], {
			type : 'warning'
		});
		return false;
	}
   if(!stringReg.test(office_state)){
		$('#office_address').removeBlockMessages().blockMessage('Please enter characters for office state', {
			type : 'warning'
		});
		return false;
	}
	 if(!stringReg.test(office_city)){
		$('#office_address').removeBlockMessages().blockMessage('Please enter characters for office city', {
			type : 'warning'
		});
		return false;
	}
	if(office_address_line1.length > 25) {
		$('#office_address').removeBlockMessages().blockMessage('Please enter office address line1 less than 25 characters', {
			type : 'warning'
		});
		return false;
	} else if(office_address_line2.length > 25) {
		$('#office_address').removeBlockMessages().blockMessage('Please enter office address line2 less than 25 characters', {
			type : 'warning'
		});

		return false;
	} else if(office_pincode.length > 0) {
		var pincode = pincode_validation();
		if(pincode == false) {
			$('#office_address').removeBlockMessages().blockMessage('Please enter valid office pincode 6 digit', {
				type : 'warning'
			});

			return false;
		}
	}
	if(office_state.length > 25) {
		$('#office_address').removeBlockMessages().blockMessage('Please enter office state less than 25 characters', {
			type : 'warning'
		});

		return false;
	} else if(office_city.length > 25) {
		$('#office_address').removeBlockMessages().blockMessage('Please enter office city less than 25 characters', {
			type : 'warning'
		});

		return false;
	}
	if(office_phone1.length > 0) {
		var phone = phone_validation();
		if(phone == 'invalid') {
			$('#office_address').removeBlockMessages().blockMessage('Please enter valid office phone1 number, 7-11 digit', {
				type : 'warning'
			});

			return false;
		}
	}
	if(office_phone2.length > 0) {
		var phone = phone_validation();
		if(phone == 'invalid') {
			$('#office_address').removeBlockMessages().blockMessage('Please enter valid office phone2 number, 7-11 digit', {
				type : 'warning'
			});

			return false;
		}
	} else if (special_character[0]==false){
			$('#office_address').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}
	if(fax.length > 0) {
			var phone = phone_validation();
			if(phone == 'invalid') {
				$('#office_address').removeBlockMessages().blockMessage('Please enter valid fax number, 7-11 digit', {
					type : 'warning'
				});

				return false;
			}
		}
});
//bank field validation
$(document).on("click", "#bank_detai", function(event) {
	var special_character = specialChar();
	var length= charactersLength()
	if (special_character[0]==false){
			$('#bank').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}

if (length[0]==false){
	$('#bank').removeBlockMessages().blockMessage('You can not enter more than 25 characters for '+length[1], {
			type : 'warning'
		});
		return false
}

});
//additional field validation
$(document).on("click", "#additional_detai", function(event) {
	var special_character = specialChar();
	var length= charactersLength()
	if (special_character[0]==false){
			$('#tab-additional_field').removeBlockMessages().blockMessage('Special characters are not allowed for '+special_character[1], {
				type : 'warning'
			});
			return false
		}

	if (length[0]==false){
		$('#tab-additional_field').removeBlockMessages().blockMessage('You can not enter more than 25 characters for '+length[1], {
				type : 'warning'
			});
			return false
	}
});
//cscsddf
$(document).on("click", "#image", function(event) {
	var id = $('#image_employee').val();
	var url = "/employees/change_image?id=" + id;
	$.get(url, function(data) {
		$('#hum').empty();
		$('#hum').html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

$(document).ready(function() {
	$('#skills').hide();
	$('#cropbox').Jcrop({
		onChange : update_crop,
		onSelect : update_crop,
		setSelect : [0, 0, 500, 500],
		aspectRatio : 1
	});
});

$(document).ready(function() {

	$('#crop_box').Jcrop({
		onChange : update_employee_crop,
		onSelect : update_employee_crop,
		setSelect : [0, 0, 500, 500],
		aspectRatio : 1
	});
});
function update_employee_crop(coords) {

	var rx = 100 / coords.w;
	var ry = 100 / coords.h;
	var iw = document.getElementById('image_width').value;
	var iwl = document.getElementById('image_width_large').value;
	var ihl = document.getElementById('image_height_large').value;
	$('#preview').css({
		width : Math.round(rx * iwl) + 'px',
		height : Math.round(ry * ihl) + 'px',
		marginLeft : '-' + Math.round(rx * coords.x) + 'px',
		marginTop : '-' + Math.round(ry * coords.y) + 'px'
	});
	var ratio = iw / iwl;
	$('#crop_x').val(Math.floor(coords.x * ratio));
	$('#crop_y').val(Math.floor(coords.y * ratio));
	$('#crop_w').val(Math.floor(coords.w * ratio));
	$('#crop_h').val(Math.floor(coords.h * ratio));
};

function update_crop(coords) {

	var rx = 100 / coords.w;
	var ry = 100 / coords.h;
	var iw = document.getElementById('image_width').value;
	var iwl = document.getElementById('image_width_large').value;
	var ihl = document.getElementById('image_height_large').value;
	$('#preview').css({
		width : Math.round(rx * iwl) + 'px',
		height : Math.round(ry * ihl) + 'px',
		marginLeft : '-' + Math.round(rx * coords.x) + 'px',
		marginTop : '-' + Math.round(ry * coords.y) + 'px'
	});
	var ratio = iw / iwl;
	$('#crop_x').val(Math.floor(coords.x * ratio));
	$('#crop_y').val(Math.floor(coords.y * ratio));
	$('#crop_w').val(Math.floor(coords.w * ratio));
	$('#crop_h').val(Math.floor(coords.h * ratio));
};


$('#query').keyup(function() {
	var status = ""
	var search = $('#query').val();
	var stats = $('#search_present_students_radios').attr('checked');
	if (stats =='checked'){
	status = stats
	}
	else{
		status ='unchecked'
	}


	var data = {
		'q' :search,
		'status' :status
	}
	if(search.length >= 2) {
		var url = "/employees/employee_search?"
		$("#employees_search").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(url,data, function(data) {
			$('#employees_search').empty();
			$('#employees_search').html(data);
		}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
	} else if(search.length < 5) {
		$('#employees_search').empty();
	}
});
//simple edit profile

$(document).on("click", "#simple_edit", function(event) {
	var current_emp = $('#emp_profile').val();
	$.get('edit_employee?q=' + current_emp, function(data) {

		$('#main_block').empty();
		$('#main_block').html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
//================
//advance search
$("#employee_employee_category_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('update_positions?category_id=' + str, function(data) {

		$("#updated_position").empty();
		$("#updated_position").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
//update employee
$("#employees_employee_category_id").live("change", function() {
	var str = "";
	str = $(this).val();
	$.get('update_positions?category_id=' + str, function(data) {

		$("#up").empty();
		$("#up").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
// skip photo=============
$(document).on("click", "#skip_button", function(event) {
	$(this).attr('disabled',true);
	var url = "/employees/save";
	waiting_modal()
	$.post(url, function(data) {
		if(data.valid) {
			var emp_id = data.employee_id;
			var parent = window.opener;
			window.close();
			var href = 'edit_employee?q=' + emp_id;
			parent.location = href
		}
	}).success (function(jqXHR){
		$('.action-tabs').show();
	});

});

function waiting_modal(){
		$.modal({
		content : 'Please wait while you request is being processed ....<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />',
		});
		$('.action-tabs').hide();
}

//photo crop==================

// $(document).on("click", "#employee_photo_crop", function(event) {
	// var id = $('#croped_employee').val();
	// var url = "/employees/edit_employee?q=" + id;
	// var parent = window.opener;
	// window.close();
	// var href = url
	// parent.location = href
// 
// });
// wizard crop============
$(document).on("click", "#wizard_crop", function(event) {
	var crop_x = $('#crop_x').val();
	var crop_y = $('#crop_y').val();
	var crop_w = $('#crop_w').val();
	var crop_h = $('#crop_h').val();
	$.ajax({
		url : 'demo',
		dataType : 'json',
		data : {
			'employee[crop_x]' : crop_x,
			'employee[crop_y]' : crop_y,
			'employee[crop_w]' : crop_w,
			'employee[crop_h]' : crop_h
		},
		success : function(data) {
			var emp_id = data.employee_id;
			var url = "/employees/edit_employee?q=" + emp_id;
			var parent = window.opener;
			window.close();
			var href = url
			parent.location = href
		}
	});
});
//open new window
var childWindow = null;
function OpenChildWindow() {
	var windowWidth = 960;
	var windowHeight = 650;
	var centerWidth = (window.screen.width - windowWidth) / 2;
	var centerHeight = (window.screen.height - windowHeight) / 2;
	childWindow = window.open("/employees/wizard_first_step", "mywindow", 'width=' + windowWidth + ',height=' + windowHeight + ',left=' + centerWidth + ',top=' + centerHeight + ',directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no');

}

function ChildWindowStatus() {
	if(!childWindow || childWindow.closed) {
		OpenChildWindow();
	} else {
		childWindow.focus();
	}
}


$(document).on("click", "#new_employee", function(event) {	ChildWindowStatus();

});
// end new window

function validateEmployeeNumber() {
	var result = null;
	var emp_number = $('#employee_number').val();
	var employee_number = emp_number.toLowerCase();
	var target = "employee_no" + '?employee_number=' + employee_number;
	$.ajax({
		url : target,
		type : 'get',
		async : false,
		success : function(data) {
			result = (data.valid);
		}
	});
	// if(result == true) {
		// $('#outer_block').removeBlockMessages().blockMessage('Employee No has already been taken', {
			// type : 'warning'
		// });
		// return false
	// } else if(result == false) {
		// $('#outer_block').removeBlockMessages();
	// }
	return result;
}


// $(document).on("blur", "#employee_number", function(event) {	var emp_number = validateEmployeeNumber();
// if(emp_number == true) {
		// $('#outer_block').removeBlockMessages().blockMessage('Employee No has already been taken', {
			// type : 'warning'
		// });
		// return false
	// } else if(emp_number == false) {
		// $('#outer_block').removeBlockMessages();
	// }
// });
//validate email uniqueness
function validateEmployeeEmail() {
	var result = null;
	var emp_email = $('#employee_email').val();
	var employee_email = emp_email.toLowerCase();
	var target = "employee_mail" + '?employee_email=' + employee_email;
	$.ajax({
		url : target,
		type : 'get',
		async : false,
		success : function(data) {
			result = (data.valid);
		}
	});
	if(result == true) {
		$('#outer_block').removeBlockMessages().blockMessage('Employee email address has already been taken', {
			type : 'warning'
		});
	} else if(result == false) {
		$('#outer_block').removeBlockMessages();
	}
	return result;
}


$(document).on("blur", "#employee_email", function(event) {	validateEmployeeEmail();

});
//

$("#select_all_privilege").on("click", function(event) {
	var checked_status = this.checked;

	$("input[type=checkbox]").each(function() {
		this.checked = checked_status;
	});
});
//assign skill in edit privilege

$(".emp_skill").on("click", function(event) {
	var skill_id = $(this).val();
	var skill_name = $(this).attr('skill_name');
	var is_check = $(this).is(":checked");
	if(is_check) {

		$("#assigned_skill").append('<li class="' + skill_id + '">' + skill_name + '</li>');

	} else {
		$('#assigned_skill .' + skill_id).remove();

	}

});
//advance search for search ajax
// $('#asps').on('click', function(event) {
	// event.preventDefault();
	// var ah = $('#aaha').val();
	// var allVal = []
	// var url = 'advance_search_pdf'
	// var t = $('#empAdList').find('tr').each(function(index) {
// 
		// if($(this).find('td').attr('id') != null) {
			// allVal.push($(this).find('td').attr('id'))
		// }
	// });
	// $.get(url, {
		// allVal : allVal
	// }, function(data) {
		// alert(data)
	// }).error (function(jqXHR, textStatus, errorThrown){
         // window.location.href = "/signin"
    // });
// });
//cancel employee
$('#Cancel_Employee_wizard').on('click', function(event) {
	event.preventDefault();
	window.close();

});
//
function specialChar() {
	var character_array=new Array();
	var special_character = null;
	var iChars = "!$%^&*()+=[];{}:<>?";
	$(".full-width").each(function() {
		for(var i = 0; i < $(this).val().length; i++) {
			if(iChars.indexOf($(this).val().charAt(i)) != -1) {
			special_character = false;
				field_name=$(this).attr('field_name')
			    character_array.push(special_character , field_name)
			}
		}

	});
	return character_array;;
}

//
function pincode_validation() {
	var valid_pincode = null;
	$(".pincode").each(function() {
		var inputVal = $(this).val();
		if(inputVal != 0) {
			var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
			if(inputVal.length < 6 || inputVal.length > 6 || !numericReg.test(inputVal)) {
				valid_pincode = false;
			}
		}
	});
	return valid_pincode;
}

//phone validation
function phone_validation() {
	var phone = null;
	$(".phone").each(function() {
		var inputVal = $(this).val();
		var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
		var phone_format = /^(\+\d)*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2}$/;
		if(inputVal != 0) {
			if(inputVal.length < 7 || inputVal.length > 11 || !numericReg.test(inputVal)) {
				phone = 'invalid';
			}
		}
	});
	return phone;
}



$(document).on("click",".folder",function(event)
{
	return false
})

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

//select department employee
$("#payroll_department_id").live("change", function() {
	var str = "";
	str = $(this).val();

	$.get('payroll_department?department_id=' + str, function(data) {

		$("#payroll_employee").empty();
		$("#payroll_employee").html(data);
		configureViewEmployeeDepartmentDetailsTable($(".department_employee"));
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
$("#individual_payslip_department_id").live("change", function() {
	var str = "";
	str = $(this).val();

	$.get('update_rejected_employee_list?department_id=' + str, function(data) {

		$("#employees_select_list").empty();
		$("#employees_select_list").html(data);
		// configureViewEmployeeDepartmentDetailsTable($(".department_employee"));
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});

$(document).on("click","#one_click_payslip_generator", function(event) {
	event.preventDefault();

	$.get("payslip_date_select",function(data){

		$("#one_click_payslip").empty();
		$("#one_click_payslip").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });


});

$(document).on("click","#one_click_p", function(event) {
	event.preventDefault();
	var salary_date = $("#salary_date").val();

	$.get("one_click_payslip_generation?salary_date="+salary_date,function(data){

		$("#one_click_payslip").empty();
		$("#one_click_payslip").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });


});
/////
$(document).on("click","#one_click_payslip_revert", function(event) {
	event.preventDefault();
			$.modal({
		content : "This will delete the entire payslip record of all the employees(of the month you select),  from the system. Are you sure ?",
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
					$.get("payslip_revert_date_select",function(data){
						$("#one_click_payslip").empty();
						$("#one_click_payslip").html(data);
					}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });

				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	// 

});
////
$(document).on("click","#one_click_p_re", function(event) {
	event.preventDefault();
	var salary_date = $("#one_click_payslip_salary_date").val();
	var data = {
				'one_click_payslip[salary_date]' : salary_date

			}
	$.get("one_click_payslip_revert",data,function(data){

		$("#one_click_payslip").empty();
		$("#one_click_payslip").html(data);
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });


});
//one_click_approve_salary_date
$("#one_click_approve_salary_date").live("change", function() {
	var str = "";
	str = $(this).val();

	$.get('one_click_approve?salary_date=' + str, function(data) {

		$("#approve").empty();
		$("#approve").html(data);

	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
//archived employee

$("#archived_employee_id").live("change", function() {
	var str = "";
	str = $(this).val();

	$.get('archived_employee_list?department_id=' + str, function(data) {

		$("#archive_employee_list").empty();
		$("#archive_employee_list").html(data);
		configureViewArchivedEmployeeTable($(".archive_employee"));
	}).error (function(jqXHR, textStatus, errorThrown){
         window.location.href = "/signin"
    });
});
function disableF5(e) { if (e.which == 116) e.preventDefault(); };
if($(document).find(".wizard-steps").length > 0){
	$(document).bind("keydown", disableF5);
}else{
	$(document).unbind("keydown", disableF5);
}


$(document).on("click" , "#employee_photo_crop", function(event){
	event.preventDefault();
     var crop_x = $("#crop_x").val();
     var crop_y = $("#crop_y").val();
     var crop_w = $("#crop_w").val();
     var crop_h = $("#crop_h").val();
     var studt_id = document.getElementById("croped_employee").value;
     var data = {
     	'employee[crop_x]' : crop_x,
     	'employee[crop_y]' : crop_y,
     	'employee[crop_w]' : crop_w,
     	'employee[crop_h]' : crop_h,
     	             'q'  : studt_id
     }
     
     $.ajax({
     	url : "/employees/crop_employee_image",
     	dataType : 'json',
     	type : "get",
		data : data,
		success : function(data) {
			if(data.valid){
				window.opener.location.reload(); 
				window.close();
			}else{
				$('#outer_block').removeBlockMessages().blockMessage('Image can not be croped', {
					type : 'error'
				});
			}
			},
			error : function(jqXHR, data ) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
    });
});

