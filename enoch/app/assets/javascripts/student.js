
$('#attachmore').on('click',function(event){
	event.preventDefault();
	nextvalue = parseInt($('#changeval').val())+1;
	$('#changeval').val(nextvalue)
	$('.add_more_attach').append('<br class = "upload_datafile'+nextvalue+'"/><input id="upload_datafile'+nextvalue+'" name="upload[datafile'+nextvalue+']" type="file"><a href="#" class = "attachremove" data-file = "upload_datafile'+nextvalue+'">Remove</a>')
	
	remove()
})
remove()
function remove()
{
$('.attachremove').on('click',function(event){
	event.preventDefault();
	index = 0;
	value = $(this).attr('data-file');
	$('#'+value).remove();
	$(this).remove();
	$('.'+value).remove();
	$('.add_more_attach input').each(function(i) {
	 index = index + 1;
		});
		
	$('#changeval').val(index)
})
}
function validateAdmission() {
	var result = null;
	var special_char = null;
	var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
	var admissionNo = $('#student_admission_no').val();
	for(var i = 0; i < admissionNo.length; i++) {
			if(iChars.indexOf(admissionNo.charAt(i)) != -1) {
				special_char = false;
			}
	}
	if(special_char == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Special Charcter are not allowed in Admission Number', {
			type : 'warning'
			});
			return false;
		}
	if(admissionNo.length!= ""){
	var admission = admissionNo.toLowerCase();
	var target = "admission_no" + '?id=' + admission
		$.ajax({
			url : target,
			type : 'GET',
			async: false,
			success : function(data) {
				result = data.valid
				document.getElementById('hiddenAdm').value = result;
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
	}else{
		$('#outer_block').removeBlockMessages();
	}
	if(result == true) {
				$('#outer_block').removeBlockMessages().blockMessage('Admission Number already exists', {
					type : 'warning'
		});
	}else if(result == false) {
		$('#outer_block').removeBlockMessages();
	}
	return result;
}

function validateStudentEmail() {
	var result = null;
	var studentemail = $('#student_email').val();
	var stdemail = studentemail.toLowerCase();
	var target = "email_validation" + '?id=' + stdemail
	$.ajax({
		url : target,
		type : 'get',
		async: false,
		success : function(data) {
			result = (data.valid);
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
	if(result == true) {
		$('#outer_block').removeBlockMessages().blockMessage('Email has already been taken', {
			type : 'warning'
		});
	} else if(result == false) {
		$('#outer_block').removeBlockMessages();
	}
	return result;
}

function picncodeCheck() {
	var pinCode = null;
	$(".pincode").each(function() {
		if($(this).val().length != 0) {
			if($(this).val().length < 6 || $(this).val().length > 6) {
				pinCode = false;
			}
		}
	});
	return pinCode;
}

function phoneValidation() {
	var phone_validation = null;
	$(".phone").each(function() {
		if($(this).val() != 0) {
			if($(this).val().length < 7 || $(this).val().length > 11) {
				phone_validation = false;
			}
		}
	});
	return phone_validation;
}

function mobileValidation() {
	var mobile_validation = null;
	$(".mobile").each(function() {
		if($(this).val().length != 0) {
			if($(this).val().length < 10 || $(this).val().length > 10) {
				mobile_validation = false;
			}
		}
	});
	return mobile_validation;
}

function parentMobileValidation() {
	var mobile_validation = null;
	$(".parent_mobile").each(function() {
		if($(this).val().length != 0) {
			if($(this).val().length < 10 || $(this).val().length > 10) {
				mobile_validation = false;
			}
		}
	});
	return mobile_validation;
}
function characterLength() {
	var character_array=new Array();
	var classfield = null;
	var field_name=null;
	$(".full-width").each(function() {
		if($(this).val().length >= 50) {	
			classfield = false;
			field_name=$(this).attr('field_name')
			character_array.push(classfield , field_name) 
		}
	});
	return character_array;
}

function parentCharacterLength() {
	var character_array=new Array();
	var classfield = null;
	var field_name=null;
	$(".parent_Class").each(function() {
		if($(this).val().length >= 50) {
			classfield = false;
			field_name=$(this).attr('field_name')
			character_array.push(classfield , field_name)
		}
	});
	return character_array;
}

function isSpclChar() {
	var character_array=new Array();
	var special_character = null;
	var field_name=null;
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
	return character_array;
}

function isParentSpclChar() {
	var character_array=new Array();
	var special_Character = null;
	var field_name=null;
	var iChars = "!$%^&*()+=[];{}:<>?";
	$(".parent_Class").each(function() {
		for(var i = 0; i < $(this).val().length; i++) {
			if(iChars.indexOf($(this).val().charAt(i)) != -1) {
				special_Character = false;
				field_name=$(this).attr('field_name')
			    character_array.push(special_Character , field_name)
			}
		}
	});
	return character_array;
}

function numericTest() {
	var character_array=new Array();
	var number = null;
	var field_name=null;
	$(".numeric").each(function() {
		if($(this).val() != 0) {
			if(isNaN($(this).val()) || $(this).val().indexOf(" ") != -1) {
				number = false;
				field_name=$(this).attr('field_name')
			    character_array.push(number , field_name)
			}
		}
	});
	return character_array;
}


$(document).on('click','#next_button', function(event) {
	var special_character = isSpclChar();
	var characterCheck = characterLength();
	var student_step = $('#student_step').val();
	var firstname = $('#student_first_name').val();
	var lastname = $('#student_last_name').val();
	var middlename = $('#student_middle_name').val();
	var admissiondate = $('#student_admission_date').val();
	var admissionNo = $('#student_admission_no').val();
	var dateofbirth = $('#student_date_of_birth').val();
	var batch_id = $('#student_batch_id').val();
	var dob = new Date(dateofbirth.split("-")[2], dateofbirth.split("-")[0], dateofbirth.split("-")[1]);
	var adm = new Date(admissiondate.split("-")[2], admissiondate.split("-")[0], admissiondate.split("-")[1]);
    var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
    var doadmission = dateConvertFunction(admissiondate)
    var dobirth = dateConvertFunction(dateofbirth)
    var status = validateAdmission();
    var admNos = document.getElementById('hiddenAdm').value;
    if(!admissionNo || admissionNo.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Admission Number', {
				type : 'warning'
			});
			return false;
	}else if(!admissiondate || admissiondate.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Admission Date', {
				type : 'warning'
			});
			return false;
	} 
    if(admNos == true){
	   $('#outer_block').removeBlockMessages().blockMessage('Admission Number already exists', {
			type : 'warning'
		});
		return false;
    }
    if(doadmission > new Date()){
    	$('#outer_block').removeBlockMessages().blockMessage('Admission Date can not be a Future Date', {
				type : 'warning'

			});
			return false;
    }
    if(dobirth > new Date()){
    	$('#outer_block').removeBlockMessages().blockMessage('Date of Birth can not be a Future Date', {
				type : 'warning'

			});
			return false;
    }
    var special_char = null
    for(var i = 0; i < firstname.length; i++) {
			if(iChars.indexOf(firstname.charAt(i)) != -1) {
				special_char = false;
			}
		}
	for(var i = 0; i < admissionNo.length; i++) {
			if(iChars.indexOf(admissionNo.charAt(i)) != -1) {
				special_char = false;
			}
	}
	var rex = /^\d{2}\-\d{2}\-\d{4}$/;
	   if(student_step == "personal") {
		
		if(dob > adm || (dob.setHours(0, 0, 0, 0) == adm.setHours(0, 0, 0, 0))) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid admission date or birth date', {
				type : 'warning'

			});
			return false;
		}
		if(special_char == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Special Charcter are not allowed in First name and Admission Number', {
			type : 'warning'
			});
			return false;
		}
		if(!rex.test(admissiondate) || !rex.test(dateofbirth))
		{
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid admission date or birth date', {
				type : 'warning'
			});
			return false;
		}
		var stringReg = /^[A-Za-z() ]*$/;
	    if(!stringReg.test(firstname)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for First name', {
					type : 'warning'
				});
			return false;
		}
		if(!stringReg.test(lastname)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for Last name', {
					type : 'warning'
				});
			return false;
		}
		if(!stringReg.test(middlename)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for Middle name', {
					type : 'warning'
				});
			return false;
		}
		if(!firstname || firstname.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter First Name', {
				type : 'warning'
			});
			return false;
		} else if(!lastname || lastname.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Last Name', {
				type : 'warning'
			});
			return false;
		} else if(!batch_id || batch_id.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Select Batch', {
				type : 'warning'
			});
			return false;
		} else if(!dateofbirth || dateofbirth.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Date of Birth', {
				type : 'warning'
			});
			return false;
		} 
		else if(status == true) {
			$('#outer_block').removeBlockMessages().blockMessage('Admission Number already exists', {
				type : 'warning'
			});
			return false;
		} 
		else if(characterCheck[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+ characterCheck[1], {
				type : 'warning'
			});
			return false;
		} else if(special_character[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage("Special characters are not allowed in "+special_character[1], {
				type : 'warning'
			});
			return false;
		} else {
			return true;
		}
	}

});

$('#Cancel_Student_wizard').on('click', function(event) {
	var studentId = $('#studentID').val();
	if( typeof studentId === "undefined") {
		window.close();
	} else {
		var parent = window.opener;
		var href = "my_profile?q=" + studentId
		window.close();
		parent.location = href
	}

});
function student_modal(){
	$.modal({
		content : "<strong>Please wait while you request is being processed ....</strong>&nbsp;<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />",	
	});
    $('.action-tabs').hide();
}

$('#wizard_next_button').on('click', function(event) {
	
	
	var student_step = $('#student_step').val();
	
	if(student_step == "image") {
		var imgpath = document.getElementById('upload_image').value;
		if(imgpath.length == 0) {
			student_modal();
		}
		var nImg = document.getElementById('upload_image');
		var imageSize = nImg.files[0].size;
		if(imageSize > 3145728) {
			$('#outer_block').removeBlockMessages().blockMessage('Image Size must not exceed 3 MB', {
				type : 'warning'
			});
			return false;
		}
		var checkimg = imgpath.toLowerCase();
		if(!checkimg.length == 0) {
			if(!checkimg.match(/(\.jpg|\.gif|\.png|\.JPG|\.GIF|\.PNG|\.jpeg|\.JPEG)$/)) {
				$('#outer_block').removeBlockMessages().blockMessage('Type of image must be one of [.gif  or .jpg or .jpeg or .png]', {
					type : 'warning'
				});
				return false;
			}
		}
		student_modal();
	} else if(student_step == "address") {
		var pincode = picncodeCheck();
		var phone_check = phoneValidation();
		var characterCheck = characterLength();
		var mobileVal = mobileValidation();
		var special_character = isSpclChar();
		var numericity_check = numericTest();
		var student_mobile = $('#student_phone2').val();
		var student_phone = $('#student_phone1').val();
		var student_pinCode = $('#student_pin_code').val();
		var student_email = $('#student_email').val();
		var address1 = $('#student_address_line1').val();
		var city = $('#student_city').val();
		var state = $('#student_state').val();
		var spincode = $('#student_pin_code').val();
		var email_valisation = validateStudentEmail();
		var mobile = $('#student_phone2').val();
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		var stringReg =  /^[A-Za-z() ]*$/;
		if(!emailReg.test(student_email)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid email', {
				type : 'warning'
			});
			return false;
		}
	    if(!stringReg.test(city)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for City', {
					type : 'warning'
				});
			return false;
		}
		if(!stringReg.test(state)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter only characters for State', {
					type : 'warning'
				});
			return false;
		}
		if(mobileVal == false) {
			$('#outer_block').removeBlockMessages().blockMessage("Mobile Number must be 10 Digits long", {
				type : 'warning'
			});
			return false;
		}
		if(characterCheck[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in ' +characterCheck[1], {
				type : 'warning'
			});
			return false;
		}
		if(numericity_check[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter only numbers in '+numericity_check[1], {
				type : 'warning'
			});
			return false;
		}
		if(pincode == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Please Enter Valid 6 Digit Pincode', {
				type : 'warning'
			});
			return false;
		}
		if(phone_check == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Phone Number must be  7  - 11 Digit long', {
				type : 'warning'
			});
			return false;
		}
		if(special_character[0] == false) {
			$('#outer_block').removeBlockMessages().blockMessage("Special Character are not allowed in "+special_character[1], {
				type : 'warning'
			});
			return false;
		}
		if(email_valisation == true) {
			$('#outer_block').removeBlockMessages().blockMessage("This email has already been registered.", {
				type : 'warning'
			});
			return false;
		}
		if(student_phone != 0) {
			if(isNaN(student_phone) || student_phone.indexOf(" ") != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid Phone Number', {
					type : 'warning'
				});
				return false;
			}
		}
		if(student_email != 0) {
			if(!emailReg.test(student_email)) {
				$('#outer_block').removeBlockMessages().blockMessage('Please enter valid email', {
					type : 'warning'
				});
				return false;
			}
		}
		if(!address1 || address1.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Address', {
				type : 'warning'
			});
			return false;
		}
		if(!city || city.length == 0) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter City', {
				type : 'warning'
			});
			return false;
		}
		
		var is_sms_enabled = $("#student_is_sms_enabled").is(':checked');
		if((!mobile || mobile.length == 0) && is_sms_enabled == true) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter Mobile no. if you want to send sms', {
				type : 'warning'
			});
			return false;
		}

	}
});

$(document).ready(function() {
	$('#cropsbox').Jcrop({
		onChange : update_crop,
		onSelect : update_crop,
		setSelect : [0, 0, 100, 100],
		aspectRatio : 1
	});
});
function update_crop(coords) {
	var rx = 100 / coords.w;
	var ry = 100 / coords.h;
	var pw = document.getElementById("photo_width").value;
	var pwl = document.getElementById("photo_width_large").value;
	var phl = document.getElementById("photo_height_large").value;
	$('#previews').css({
		width : Math.round(rx * pwl) + 'px',
		height : Math.round(ry * phl) + 'px',
		marginLeft : '-' + Math.round(rx * coords.x) + 'px',
		marginTop : '-' + Math.round(ry * coords.y) + 'px'
	});
	var ratio = pw / pwl;
	$("#crop_x").val(Math.round(coords.x * ratio));
	$("#crop_y").val(Math.round(coords.y * ratio));
	$("#crop_w").val(Math.round(coords.w * ratio));
	$("#crop_h").val(Math.round(coords.h * ratio));
}
function dateConvertFunction(date){
				MyDate = date;
			MD_Date = MyDate.substring(0);
			MD_Time = MyDate.substring(1);
			MD_i2 = MD_Date.indexOf('-');
			MD_i3 = MD_Date.indexOf('-', MD_i2 + 1);
			MD_D = MD_Date.substring(0, MD_i2);
			MD_M = MD_Date.substring(MD_i2 + 1, MD_i3);
			MD_Y = MD_Date.substring(MD_i3 + 1);
			if((isNaN(MD_Y)) || (isNaN(MD_M)) || (isNaN(MD_D))) {
				alert('Not numeric.');
				DObj = '*** error';
			} else {
				MD_M = MD_M - 1;				
				DObj = new Date(MD_Y, MD_M, MD_D );
			}
			return DObj;
}

$(document).on("click", "#save_guardian", function(event) {
	event.preventDefault();
	// var phone_check = phoneValidation();
	var charactercheck = parentCharacterLength();
	var special_Character = isParentSpclChar();
	var guardian_name = document.getElementById("guardian_first_name").value;
	var guardian_last_name = document.getElementById("guardian_last_name").value;
	var guardian_dob = document.getElementById("guardian_dob").value;
	var guardian_relation = document.getElementById("relation").value;
	var guardian_education = document.getElementById("guardian_education").value;
	var guardian_occupation = document.getElementById("guardian_occupation").value;
	var studentId = document.getElementById('studentID').value;
	var parent_income = document.getElementById('income').value;
	var guardian_address1 = document.getElementById('office_address_line1').value;
	var guardian_address2 = document.getElementById('office_address_line2').value;
	var guardian_city = document.getElementById('city').value;
	var guardian_state = document.getElementById('state').value;
	var guardian_country = document.getElementById('guardian_country_id').value;
	var parent_email = document.getElementById('parent_email').value;
	var parent_office1 = document.getElementById('office_phone1').value;
	var parent_mobile = document.getElementById('mobile_phone').value;
	var mobileVal = mobileValidation();
	var numericity_check = numericTest();
	var dob = dateConvertFunction(guardian_dob);
	var stringReg = /^[a-zA-Z() ]*$/;
	if(dob > new Date()){
	$('#outer_block').removeBlockMessages().blockMessage('Date of Birth cannot be a future Date', {
				type : 'warning'
			});
		return false;	
	}
    if(!stringReg.test(guardian_city)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Guardian City', {
				type : 'warning'
			});
		return false;
	}
	if(!stringReg.test(guardian_state)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Guardian State', {
				type : 'warning'
			});
		return false;
	}
	if(!stringReg.test(guardian_name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Guardian First Name', {
				type : 'warning'
			});
		return false;
	}
	if(!stringReg.test(guardian_last_name)) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter characters for Guardian Last Name', {
				type : 'warning'
			});
		return false;
	}
	var guardian_data = {
		'first_name' : guardian_name,
		'last_name' : guardian_last_name,
		'dob' : guardian_dob,
		'relation' : guardian_relation,
		'occupation' : guardian_occupation,
		'city' : guardian_city,
		'state' : guardian_state,
		'office_address_line1' : guardian_address1,
		'office_address_line2' : guardian_address2,
		'income' : parent_income,
		'education' : guardian_education,
		'office_phone1' : parent_office1,
		'mobile_phone' : parent_mobile,
		'email' : parent_email,
		'ward_id' : studentId,
		'commit' : "Save",
		'guardian[country_id]' : guardian_country,
		'_method' : 'put'
	}
	if(mobileVal == false) {
			$('#outer_block').removeBlockMessages().blockMessage("Mobile Number must be 10 Digit long", {
				type : 'warning'
			});
			return false;
	}
	if(numericity_check[0] == false) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter only numbers in '+numericity_check[1], {
			type : 'warning'
		});
		return false;
	}
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	if(parent_office1 != 0) {
		var phone_check = phoneValidation();
		if(phone_check == false) {
			$('#outer_block').removeBlockMessages().blockMessage('Phone Number must be  7  - 11 Digit long', {
				type : 'warning'
			});
			return false;
		}
	}
	if(!guardian_name || guardian_name.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter First Name', {
			type : 'warning'
		});
		return false;
	}
	if(!emailReg.test(parent_email)) {
		$('#outer_block').removeBlockMessages().blockMessage('Please enter valid email', {
			type : 'warning'
		});
		return false;
	}
	if(parent_office1 != 0) {
		if(isNaN(parent_office1) || parent_office1.indexOf(" ") != -1) {
			$('#outer_block').removeBlockMessages().blockMessage('Please enter valid Phone Number', {
				type : 'warning'
			});
			return false;
		}
	}
	if(charactercheck[0] == false) {
		$('#outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+charactercheck[1], {
			type : 'warning'
		});
		return false;
	}
	if(special_Character[0] == false) {
		$('#outer_block').removeBlockMessages().blockMessage("Special Character are not allowed in "+special_Character[1], {
			type : 'warning'
		});
		return false;
	}
	Save_guardian(guardian_data, studentId);
});
function Save_guardian(guardian_data, studentId) {
	$.ajax({
		url : '/student/update',
		type : "PUT",
		data : guardian_data,
		success : function(data) {
			if(data.valid) {
				var href = "my_profile" + '?q=' + studentId
				var prev_location = window.opener;
				window.close();
				prev_location.location = href
			} else {
				$('#outer_block').removeBlockMessages().blockMessage(data.errors || 'An unexpected error occured, please try again', {
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

}


$(document).on('click','#update_student', function(event) {
	var length_check = characterLength();
	var special_character = isSpclChar();
	var firstname = $('#student_first_name').val();
	var student_id = $('#current_student').val();
	var lastname = $('#student_last_name').val();
	var middlename = $('#student_middle_name').val();
	var batch = $('#student_batch_id').val();
	var dob = $('#student_date_of_birth').val();
	var category = $('#student_student_category_id').val();
	var status = $("input[name='student\\[gender\\]']:checked").val();
	var bloodgroup = $('#student_blood_group').val();
	var religion = $('#student_religion').val();
	var nationalityid = $('#student_nationality_id').val();
	var iChars = "!@#$%^&*()+=[];{}:<>?";
	var special_char = null
    for(var i = 0; i < firstname.length; i++) {
			if(iChars.indexOf(firstname.charAt(i)) != -1) {
				special_char = false;
			}
		}
	if(special_character[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Special characters are not allowed in "+special_character[1], {
			type : 'warning'
		});
		return false;
	}
    var stringReg = /^[a-zA-Z() ]*$/;
    if(!stringReg.test(firstname)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for First Name', {
				type : 'warning'
			});
		return false;
	}
	 if(!stringReg.test(lastname)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Last Name', {
				type : 'warning'
			});
		return false;
	}
	 if(!stringReg.test(middlename)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Middle Name', {
				type : 'warning'
			});
		return false;
	}
	if(special_char == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Special characters are not allowed in First Name", {
			type : 'warning'
		});
		return false;
	}
	if(length_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+length_check[1], {
			type : 'warning'
		});
		return false;
	}
	if(!firstname || firstname.length == 0) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter First Name', {
			type : 'warning'
		});
		return false;
	} else if(!lastname || lastname.length == 0) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter Last Name', {
			type : 'warning'
		});
		return false;
	} else {
		var target = 'update_student' + '?id=' + student_id
		// Request
		var data = {
			'student[first_name]' : firstname,
			'student[last_name]' : lastname,
			'student[middle_name]' : middlename,
			'student[batch_id]' : batch,
			'student[student_category_id]' : category,
			'student[gender]' : status,
			'student[blood_group]' : bloodgroup,
			'student[date_of_birth]' : dob,
			'student[religion]' : religion,
			'student[nationality_id]' : nationalityid,
			'_method' : 'put'
		}
		$.ajax({
			url : target,
			dataType : 'json',
			data : data,
			success : function(data) {
				if(data.valid) {
						$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
							type : 'success'
						});
					$("#changeStudentName").html(data.student)
					} else {
					var errorText = getErrorText(data.errors);
						$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
							type : 'error'
						});
				}
			},
			error : function(jqXHR, data ) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
		});
	}
				
});

$('#update_contact').on('click', function(event) {
	var pincode = picncodeCheck();
	var phone_check = phoneValidation();
	var mobile_check = mobileValidation();
	var address1 = $('#student_address_line1').val();
	var student_id = $('#current_student').val();
	var address2 = $('#student_address_line2').val();
	var city = $('#student_city').val();
	var state = $('#student_state').val();
	var pinCode = $('#student_pin_code').val();
	var phone1 = $('#student_phone1').val();
	var phone2 = $('#student_phone2').val();
	var email = $('#student_email').val();
	var is_transport_enabled = $("#student_is_transport_enabled").is(':checked');
	var sms_feature = document.getElementById('student_is_sms_enabled');
	if(sms_feature!=null && sms_feature!=""){
	var is_sms_enabled = $("#student_is_sms_enabled").is(':checked');
	}
	var numericity_check = numericTest();
	var length_check = characterLength();
	var special_character = isSpclChar();
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var stringReg = /^[a-zA-Z() ]*$/;
    if(!stringReg.test(city)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for City', {
				type : 'warning'
			});
		return false;
	}
	if(!stringReg.test(state)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for State', {
				type : 'warning'
			});
		return false;
	}

	var target = 'update_student' + '?id=' + student_id
	var data1 = {
		'student[address_line1]' : address1,
		'student[address_line2]' : address2,
		'student[city]' : city,
		'student[state]' : state,
		'student[pin_code]' : pinCode,
		'student[phone1]' : phone1,
		'student[phone2]' : phone2,
		'student[email]' : email,
		'student[is_transport_enabled]' :is_transport_enabled,
		'student[is_sms_enabled]' :is_sms_enabled,
		'_method' : 'put'
	}
	if(!emailReg.test(email)) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter valid email', {
			type : 'warning'
		});
		return false;
	}
	if(special_character[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Special characters are not allowed in "+special_character[1], {
			type : 'warning'
		});
		return false;
	}
	if(phone_check == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Phone Number must be 7 - 11 Digit long", {
			type : 'warning'
		});
		return false;
	}
	if(!address1 || address1.length == 0) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter Address Line 1', {
			type : 'warning'
		});
		return false;
	}
	if(!city || city.length == 0) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter City', {
			type : 'warning'
		});
		return false;
	}
	// if(!phone2 || phone2.length == 0) {
		// $('#outer_bloc').removeBlockMessages().blockMessage('Please enter Mobile Number', {
			// type : 'warning'
		// });
		// return false;
	// }
	if(mobile_check == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Mobile Number must be 10 Digit long", {
			type : 'warning'
		});
		return false;
	}
	if(pincode == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Please enter valid 6 Digit Pincode", {
			type : 'warning'
		});
		return false;
	}
	if(numericity_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter only numbers in '+numericity_check[1], {
			type : 'warning'
		});
		return false;
	}
	if(length_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+length_check[1], {
			type : 'warning'
		});
		return false;
	}
	$.ajax({
		url : target,
		dataType : 'json',
		data : data1,
		success : function(data) {
		    if(data.valid) {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, data ) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

});

$(document).on("click", "#update_parent_office", function(event) {
	var currentTab = $("#tab-global .current").attr("id");
	event.preventDefault();
	var guardian_email = $('#parent_email' + currentTab).val();
	var ward_id = $('#current_student').val();
	var ward_admission_no = $('#current_student_admission_no').val();
	var guardian_office_address1 = $('#parent_address' + currentTab).val();
	var guardian_office_address2 = $('#parent_2address' + currentTab).val();
	var guardian_city = $('#parent_city' + currentTab).val();
	var guardian_state = $('#parent_state' + currentTab).val();
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var special_character = isSpclChar();
	var characterCheck = characterLength();
	var stringReg = /^[A-Za-z() ]*$/;
	
    if(!stringReg.test(guardian_city)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for City', {
				type : 'warning'
			});
		return false;
	}
	if(characterCheck[0] == false) {
			$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+characterCheck[1], {
				type : 'warning'
			});
			return false;
	}
	if(!stringReg.test(guardian_state)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for State', {
				type : 'warning'
			});
		return false;
	}
	var data = {
		'guardian[email]' : guardian_email,
		'guardian[office_address_line1]' : guardian_office_address1,
		'guardian[office_address_line2]' : guardian_office_address2,
		'guardian[city]' : guardian_city,
		'guardian[state]' : guardian_state,
		'guardian[ward_id]' : ward_id,
		'parent_id' : currentTab,
		'_method' : 'put'
	}
	if(special_character[0] == false) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Special charcters are not allowed in '+special_character[1], {
			type : 'warning'
			});
			return false;
    }
	if(!emailReg.test(guardian_email)) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter valid email', {
			type : 'warning'
		});
		return false;
	}
	var url = "update_guardian" + '?q=' + ward_admission_no
	$.ajax({
		url : url,
		dataType : 'json',
		data : data,
		success : function(data) {

			if(data.valid) {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, data ) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
	// }
});

$(document).on("click", "#delete_parent", function(event) {
	event.preventDefault();
	var currentTab = $("#tab-global .current").attr("id");
	var target = "del_guardian" + "?id=" + currentTab
	var ward_id = $('#current_student').val();
	var ward_admission_no = $('#current_student_admission_no').val();
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a Guardian...</p>',
		title : 'Delete Guardian?',
		maxWidth : 500,
		buttons : {
			'Ok' : function(win) {
				$.get(target,{q: ward_admission_no}, function(data) {
					if (!data.valid){
						$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
							type : 'warning'
						});
						win.closeModal();
						return false;
					}else{
					    win.closeModal();
						window.location.reload();
					}
				}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
				});
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});

});

$(document).on("click", "#update_parent_contact", function(event) {
	var currentTab = $("#tab-global .current").attr("id");
	var numericity_check = numericTest();
	var phone_check = phoneValidation();
	var mobile_check = mobileValidation();
	event.preventDefault();
	var guardian_office_phone1 = $('#office1_phone' + currentTab).val();
	var ward_id = $('#current_student').val();
	var ward_admission_no = $('#current_student_admission_no').val();
	var guardian_office_phone2 = $('#office2_phone' + currentTab).val();
	var guardian_mobile_phone = $('#mobile_phone' + currentTab).val();
	var data = {
		'guardian[office_phone1]' : guardian_office_phone1,
		'guardian[office_phone2]' : guardian_office_phone2,
		'guardian[mobile_phone]' : guardian_mobile_phone,
		'guardian[ward_id]' : ward_id,
		'parent_id' : currentTab,
		'_method' : 'put'
	}
	if(phone_check == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Phone Number must be 7 - 11 Digit long", {
			type : 'warning'
		});
		return false;
	}
	if(mobile_check == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage("Mobile Number must be 10 Digit long", {
			type : 'warning'
		});
		return false;
	}
	if(numericity_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter only numbers in '+numericity_check[1], {
			type : 'warning'
		});
		return false;
	}
	var url = "update_guardian" + '?q=' + ward_admission_no
	$.ajax({
		url : url,
		dataType : 'json',
		data : data,
		success : function(data) {
			if(data.valid) {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, data ) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
});

$(document).on("click", "#update_parents", function(event) {
	var numericity_check = numericTest();
	var length_check = characterLength();
	var currentTab = $("#tab-global .current").attr("id");
	event.preventDefault();
	var guardian_first_name = $('#first_name' + currentTab).val();
	var ward_id = $('#current_student').val();
	var ward_admission_no = $('#current_student_admission_no').val();
	var guardian_last_name = $('#last_name' + currentTab).val();
	var relation = $('#relation' + currentTab).val();
	var guardian_dob = $('#dob' + currentTab).val();
	var guardian_education = $('#education' + currentTab).val();
	var guardian_occupation = $('#occupation' + currentTab).val();
	var guardian_income = $('#income' + currentTab).val();
    var guardian_country = $('#guardian_country_id' + currentTab).val();
    var special_character = isSpclChar();
	var characterCheck = characterLength();
	var stringReg = /^[A-Za-z() ]*$/;
	if(!stringReg.test(guardian_first_name)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter only characters for First Name', {
				type : 'warning'
			});
		return false;
	}
	if(!stringReg.test(guardian_last_name)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter only characters for Last Name', {
				type : 'warning'
			});
		return false;
	}
	if(characterCheck[0] == false) {
			$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+characterCheck[1], {
				type : 'warning'
			});
			return false;
	}
	var data = {
		'guardian[first_name]' : guardian_first_name,
		'guardian[last_name]' : guardian_last_name,
		'guardian[relation]' : relation,
		'guardian[dob]' : guardian_dob,
		'guardian[education]' : guardian_education,
		'guardian[occupation]' : guardian_occupation,
		'guardian[income]' : guardian_income,
		'guardian[country_id]' : guardian_country,
		'guardian[ward_id]' : ward_id,
		'parent_id' : currentTab,
		'_method' : 'put'
	}
	if(numericity_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter only numbers in '+numericity_check[1], {
			type : 'warning'
		});
		return false;
	}
	if(!guardian_first_name || guardian_first_name.length == 0) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter First name', {
			type : 'warning'
		});
		return false;
	}
	if(length_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+length_check[1], {
			type : 'warning'
		});
		return false;
	}

	var url = "update_guardian" + '?q=' + ward_admission_no
	$.ajax({
		url : url,
		dataType : 'json',
		data : data,
		success : function(data) {
			if(data.valid) {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, data ) {
		    if (jqXHR.status === 200) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

});

$("#add-more-parents").on('click', function(event) {
	var contents = $('#modal-box-parents');
	
	$.modal({
		content : contents,
		title : 'Add Guardian',
		width : 700,
		height : 400,
		buttons : {
			'Save' : function(win) {
				var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
				var numericity_check = numericTest();
				var length_check = characterLength();
				var phone_check = phoneValidation();
				var mobile_check = parentMobileValidation();
				var f_name = $('#modal #parent_detail_first_name').val();
				var l_name = $('#modal #parent_detail_last_name').val();
				var relation = $('#modal #relation').val();
				var dob = $('#modal #parent_detail_dob').val();
				var education = $('#modal #education').val();
				var occupation = $('#modal #occupation').val();
				var income = $('#modal #income').val();
				var email = $('#modal #parent_detail_email').val();
				var add_1 = $('#modal #parent_detail_office_address_line1').val();
				var add_2 = $('#modal #parent_detail_office_address_line2').val();
				var city = $('#modal #parent_detail_city').val();
				var state = $('#modal #parent_detail_state').val();
				var off_p_1 = $('#modal #parent_detail_office_phone1').val();
				var off_p_2 = $('#modal #parent_detail_office_phone2').val();
				var country = $('#modal #parent_detail_country_id').val();
				var mob_phone = $('#modal #parent_detail_mobile_phone').val();
				var ward_id = $('#current_student').val();
				var studentID = $('#current_student_admission_no').val();
				var charactercheck = characterLength()
    			var special_character = isSpclChar();
    			var stringReg = /^[A-Za-z() ]*$/;
			    if(!stringReg.test(city)) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter characters for City', {
							type : 'warning'
						});
					return false;
				}
				if(!stringReg.test(state)) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter characters for State', {
							type : 'warning'
						});
					return false;
				}
				if(!stringReg.test(l_name)) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter characters for Last name', {
							type : 'warning'
						});
					return false;
				}
				if(!stringReg.test(f_name)) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter characters for First name', {
							type : 'warning'
						});
					return false;
				}
    			if(charactercheck[0] == false) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+charactercheck[1], {
							type : 'warning'
						});
						return false;
				}
				if(special_character[0] == false) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Special Charcter are not allowed in '+special_character[1], {
						type : 'warning'
						});
						return false;
			    }
				if(!f_name || f_name.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please Enter First Name', {
						type : 'warning'
					});
					return false;
				}
				if(numericity_check[0] == false) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter only numbers in '+numericity_check[1], {
						type : 'warning'
					});
					return false;
				}
				if(length_check[0] == false) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+length_check[1], {
						type : 'warning'
					});
					return false;
				}
				if(phone_check == false) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Phone Number must be 7 - 11 Digit long', {
						type : 'warning'
					});
					return false;
				}
				if(mobile_check == false) {
					$('#modal #outer_block').removeBlockMessages().blockMessage("Mobile Number must be 10 Digit long", {
						type : 'warning'
					});
					return false;
				}
				if(!emailReg.test(email)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter valid email', {
						type : 'warning'
					});
					return false;
				}
				var target = 'add_guardian' + '?q=' + studentID
				var data = {
					'guardian[first_name]' : f_name,
					'guardian[last_name]' : l_name,
					'guardian[relation]' : relation,
					'guardian[dob]' : dob,
					'guardian[education]' : education,
					'guardian[occupation]' : occupation,
					'guardian[income]' : income,
					'guardian[country_id]' : country,
					'guardian[email]' : email,
					'guardian[office_address_line1]' : add_1,
					'guardian[office_address_line2]' : add_2,
					'guardian[mobile_phone]' : mob_phone,
					'guardian[city]' : city,
					'guardian[state]' : state,
					'guardian[office_phone1]' : off_p_1,
					'guardian[office_phone2]' : off_p_2,
					'guardian[ward_id]' : ward_id
				}

				ajaxAddGuardian(target, data, win, ward_id, studentID);

			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
	modal_box_datepicker();
	

});
function ajaxAddGuardian(target, data, win, ward_id, studentID) {

	$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				window.location.reload();
				win.closeModal();
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
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
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}


$("#adv_search_course_id").live('change', function(event) {

	var str = "";

	$("#adv_search_course_id option:selected").each(function() {
		str = $(this).val();
	});
	var url = 'change_batch' + '?q=' + str
	if(str == ""){
		$('#student_batch_id').empty();
		return false;
	}
	$.get(url, function(data) {
		$('#change_batch').empty();
		$('#change_batch').html(data);
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});

$("#advv_search_course_id").live('change', function(event) {
	$('#student_advanced_search').empty();
	document.getElementById('student_advanced_name').value = null;
	var str = "";
	$("#advv_search_course_id option:selected").each(function() {
		str = $(this).val();
	});
	if(str==""){
		$("#student_batch_id").val("")
		return false;
	}
	var url = 'change_batch' + '?q=' + str

	$.get(url, function(data) {
		$('#change_batch').empty();
		$('#change_batch').html(data);
		$("#student_batch_id").live('change', function(event) {
			document.getElementById('student_advanced_name').value = null;
			var batch = "";

			$("#student_batch_id option:selected").each(function() {
				batch = $(this).val();
			});
			var target = "student_advanced_search" + '?query=' + batch
			$("#student_advanced_search").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
			$.get(target, function(data) {
				$('#student_advanced_search').empty();
				$('#student_advanced_search').html(data);
			}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
			});
		});
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});

$('#target').keyup(function() {
	var search = $('#target').val();
	var student_type = $('#option').val();
	var data = [search, student_type];
	var url = "search_ajax" + '?query=' + data.join(',')
	var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
    var special_character = isSpclChar();
	if(search.length >= 3) {
		for(var i = 0; i < search.length; i++) {
			if(iChars.indexOf(search.charAt(i)) != -1) {
				$('#outer_block').removeBlockMessages().blockMessage('Special character are not allowed in Search Field', {
						type : 'warning'
					});
			     return false;
			}else{
				$('#outer_block').removeBlockMessages();
			}
		}
		$("#student_search").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(url,function(data) {
			$('#student_search').empty();
			$('#student_search').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
			if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	} else {
		$('#student_search').empty();
		$('#student_search').html();
	}
});

$('#student_advanced_name').keyup(function() {
	var search = $('#student_advanced_name').val();
	var course_id = $('#advv_search_course_id').val();
	var batch_id = $('#student_batch_id').val();
	var data = [search, course_id]
	var target = "student_advanced_search" + '?w=' + data.join(',')
	if(search.length >= 3) {
		$("#student_advanced_search").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(target, {batch_id : batch_id}, function(data) {
			$('#student_advanced_search').empty();
			$('#student_advanced_search').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
		    if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	} else if(search.length <= 0) {
		$("#student_advanced_search").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
		$.get(target, {query : batch_id}, function(data) {
			$('#student_advanced_search').empty();
			$('#student_advanced_search').html(data);
		}).error(function(jqXHR, textStatus, errorThrown) { 
		    if(jqXHR.status!= "0"){
		        window.location.href = "/signin"
		    }
		});
	} else {
		$('#student_advanced_search').empty();
		$('#student_advanced_search').html();
	}
});


function ChangeImmediateContact(student_id) {
	var value = student_id.getAttribute('value');

	var contents = $('#modal-box_update');
	$.get("get_guardian_id/"+value,function(data){
	$.modal({
		content : data,
		title : 'Change Immediate Contact',
		width : 300,
		height : 100,
		buttons : {
			'Close' : function(win) {
				win.closeModal();
			},
			'Update' : function(win) {
				var radios = document.getElementsByTagName('input');
				var values;
				for(var i = 0; i < radios.length; i++) {
					if(radios[i].type === 'radio' && radios[i].checked) {
						values = radios[i].id;
					}
				}
				if (values != "student_gender_m" && values != "student_gender_f" ){
					var target = "update_immediate"
					$.get(target, {	id : values, student_id : value	}, function(data) {
						win.closeModal();
						$('#myId').empty();
						var guardian_name = data.guardian;
						var guardian_number = data.guardian_number
						$('#myId').html('<a href=/student/my_profile?q=' + value + ' >' + guardian_name + '</a>('+guardian_number +')');
					}).error(function(jqXHR, textStatus, errorThrown) { 
					        window.location.href = "/signin"
					});
				}else{
					win.closeModal();
					$('#outer_bloc').removeBlockMessages().blockMessage('No Guardian Selected', {
						type : 'warning'
					});
				}
			}
		}
	});
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
};


$(document).on("click", "#update_student_previous_detail", function(event) {
	var numericity_check = numericTest();
	event.preventDefault();
	var institution_name = $('#student_previous_details_institution').val();
	var course_id = $('#student_previous_details_course').val();
	var year = $('#student_previous_details_year').val();
	var total_mark = $('#student_previous_details_total_mark').val();
	var ward_id = $('#current_student').val();
	var target = "previous_data" + '?id=' + ward_id
	var special_character = isSpclChar();
	var data = {
		'student_previous_data[institution]' : institution_name,
		'student_previous_data[year]' : year,
		'student_previous_data[course]' : course_id,
		'student_previous_data[total_mark]' : total_mark,
		'student_previous_data[student_id]' : ward_id
	}
	var charactercheck = characterLength()
	var stringReg = /^[A-Za-z() ]*$/;
    if(!stringReg.test(institution_name)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Institution Name', {
				type : 'warning'
			});
		return false;
	}
	if(charactercheck[0] == false) {
			$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+charactercheck[1], {
				type : 'warning'
			});
			return false;
	}
	if(numericity_check[0] == false) {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please enter only numbers in '+numericity_check[1], {
			type : 'warning'
		});
		return false;
	}
	if(special_character[0] == false) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Special Charcter are not allowed in '+special_character[1], {
			type : 'warning'
			});
			return false;
    }
    if(year.length != ""){
	    if(year.length<4 || year.length>4) {
				$('#outer_bloc').removeBlockMessages().blockMessage('Please Enter Full Year', {
				type : 'warning'
				});
				return false;
	    }
    }
    if(total_mark != "") {
	     if(total_mark.length<2 || total_mark.length>4) {
				$('#outer_bloc').removeBlockMessages().blockMessage('Please enter Exact Marks', {
				type : 'warning'
				});
				return false;
	    }
    }

	$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});

			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403 ) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});

	$('#outer_bloc').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

});

$(document).on("click", "#update_student_additional_field", function(event) {
	// event.preventDefault()
	var iChars = "!$%^&*()+=[];{}:<>?";
	 var allVals = null;
		$("input:text[ids=aditionalField]").each(function(){
			if($(this).val().length >= 50) {
				$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in '+$(this).attr('field_name'), {
						type : 'warning'
					});
					return false
			}
			for(var i = 0; i < $(this).val().length; i++) {
				if(iChars.indexOf($(this).val().charAt(i)) != -1) {
					$('#outer_bloc').removeBlockMessages().blockMessage('Special Character are not allowed in '+$(this).attr('field_name'), {
						type : 'warning'
					});
					allVals= false;
					return false
				}else{
					allVals= true;
					
				}
			}
	    });
	    if(allVals == true){
	    	window.location.reload()
	    }
});

$(document).ready(function() {
	$('#crop_image').Jcrop({
		onChange : update_photo_crop,
		onSelect : update_photo_crop,
		setSelect : [0, 0, 100, 100],
		aspectRatio : 1
	});
});
function update_photo_crop(coords) {
	var rx = 100 / coords.w;
	var ry = 100 / coords.h;
	var pw = document.getElementById("photo_width").value;
	var pwl = document.getElementById("photo_width_large").value;
	var phl = document.getElementById("photo_height_large").value;
	$('#preview').css({
		width : Math.round(rx * pwl) + 'px',
		height : Math.round(ry * phl) + 'px',
		marginLeft : '-' + Math.round(rx * coords.x) + 'px',
		marginTop : '-' + Math.round(ry * coords.y) + 'px'
	});
	var ratio = pw / pwl;
	$("#crop_x").val(Math.round(coords.x * ratio));
	$("#crop_y").val(Math.round(coords.y * ratio));
	$("#crop_w").val(Math.round(coords.w * ratio));
	$("#crop_h").val(Math.round(coords.h * ratio));
}

$(document).on("submit", "#student_images", function(event) {
	// event.preventDefault();
	var imgpath = document.getElementById('student_student_photo').value;
	var checkimg = imgpath.toLowerCase();
	if(!checkimg || checkimg.length == 0) {
		$('#outer_block').removeBlockMessages().blockMessage('Please choose the image', {
			type : 'warning'
		});
		return false
	}
	var nImg = document.getElementById('student_student_photo');
		var imageSize = nImg.files[0].size
		if(imageSize > 3145728) {
			$('#outer_block').removeBlockMessages().blockMessage('Image Size must not exceed 3 MB', {
				type : 'warning'
			});
			return false;
		}
	if(!checkimg.length == 0) {
		if(!checkimg.match(/(\.jpg|\.gif|\.png|\.JPG|\.GIF|\.PNG|\.jpeg|\.JPEG)$/)) {
			$('#outer_block').removeBlockMessages().blockMessage('Type of image must be one of [.gif  or .jpg or .jpeg or .png]', {
				type : 'warning'
			});
			return false
		}
	}
});
var studentchildWindow = null;
function OpenStudentChildWindow() {
	var windowWidth = 960;
	var windowHeight = 650;
	var centerWidth = (window.screen.width - windowWidth) / 2;
	var centerHeight = (window.screen.height - windowHeight) / 2;
	studentchildWindow = window.open('/student/student_wizard_first_step', 'StudentAdmission', 'width=' + windowWidth + ',height=' + windowHeight + ',left=' + centerWidth + ',top=' + centerHeight + ',directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no');
}

function StudentChildWindowStatus() {
	if(!studentchildWindow || studentchildWindow.closed) {
		OpenStudentChildWindow();
	} else {
		studentchildWindow.focus();
	}
}


$(document).on("click", "#new_student", function(event) {
	StudentChildWindowStatus();
});

$("#batch_search_course_id").on('change', function(event) {
	$('#change_batchwise_student').empty();
	var str = "";
	$("#batch_search_course_id option:selected").each(function() {
		str = $(this).val();
	});
	if(str==""){
				$('#change_batchwise_student').empty();
	}
	var url = 'assign_roll_no' + '?q=' + str
	$.get(url, function(data) {
		$('#change_batch_students').empty();
		$('#change_batch_students').html(data);
		$("#student_batch_wise_student").on('change', function(event) {
			var batch = "";
			$("#student_batch_wise_student option:selected").each(function() {
				batch = $(this).val();
			});
			if(batch == ""){
				$('#change_batchwise_student').empty();
				return false;
			}
			var target = "assign_roll_no" + '?id=' + batch
			$.get(target, function(data) {
				$('#change_batchwise_student').empty();
				$('#change_batchwise_student').html(data);
				$('#roll_no_assign_outer_block').removeBlockMessages();
				configureRollNoTable($('#batchwise'));
			}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
			});
		});
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});

$(document).ready(function(event) {
	var current_user = $('#cuurent_user').val()
	if(current_user == "Employee") {
		$("#student_batch_wise_student").live('change', function(event) {
			var batch = "";

			$("#student_batch_wise_student option:selected").each(function() {
				batch = $(this).val();
			});
			var target = "/student/assign_roll_no" + '?id=' + batch
			if(batch != "") {
				$.get(target, function(data) {
					$('#change_batchwise_student').empty();
					$('#change_batchwise_student').html(data);
					configureRollNoTable($('#batchwise'));
				}).error(function(jqXHR, textStatus, errorThrown) { 
				        window.location.href = "/signin"
				});
			} else {
				$('#change_batchwise_student').empty();
			}

		});
	};
});

$(document).on("click", "#Assign_Roll_No", function(event) {
	var batch_id = "";
	$("#student_batch_wise_student option:selected").each(function() {
		batch_id = $(this).val();
	});
	var radios = document.getElementsByTagName('input');
	var values;
	for(var i = 0; i < radios.length; i++) {
		if(radios[i].type === 'radio' && radios[i].checked) {
			values = radios[i].id;
		}
	}

	if(values == null) {
		$('#roll_no_assign_outer_block').blockMessage('Please Select Option for sorting', {
			type : 'warning'
		});
		return false;
	}
	var target = "change_roll_number" + "?query=" + values
	$.get(target, {batch_id : batch_id}, function(data) {
		$('#change_batchwise_student').empty();
		$('#change_batchwise_student').html(data);
		$('#roll_no_assign_outer_block').removeBlockMessages().blockMessage('Successfully Assigned Roll No.', {
			type : 'success'
		});
		configureRollNoTable($('#batchwise'));
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});

$(document).ready(function() {
	$('#batch_search_course_id').val("");
	$('#mode_id').val("");
	$('#month_hide').hide();
	$('#year_hide').hide();
});

$("#mode_id").live('change', function(event) {
	$('#report_content').empty();
	var mode = "";
	$("#mode_id option:selected").each(function() {
		mode = $(this).val();
	});
	if(mode == "Monthly") {
		$('#month_hide').show();
		$('#year_hide').show();
	} else {
		$('#month_hide').hide();
		$('#year_hide').hide();
	}
});
$(document).on("click", "#stdent_atten_report", function(event) {

	var mode = "";
	var month_id = "";
	var year_id = "";

	var student_id = $('#current_student').val();
	var student_admission_no = document.getElementById('current_student_admission_no').value;
	$("#mode_id option:selected").each(function() {
		mode = $(this).val();
	});
	if(mode != "Monthly") {
		$("#month_id option:selected").each(function() {
			month_id = ""
		});
		$("#advance_search_year option:selected").each(function() {
			year_id = ""
		});
	} else {
		$("#month_id option:selected").each(function() {
			month_id = $(this).val();
		});
		$("#advance_search_year option:selected").each(function() {
			year_id = $(this).val();
		});
	}
	if(mode == "") {
		$('#outer_bloc').removeBlockMessages().blockMessage('Please select the mode', {
			type : 'warning'
		});
		return false;
	}
	if(mode == "Monthly") {
		if(month_id == "") {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please select the month', {
				type : 'warning'
			});
			return false;
		}
		if(year_id == "") {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please select the Year', {
				type : 'warning'
			});
			return false;
		}
		
	}
	var data = {
		'advance_search[mode]' : mode,
		'advance_search[subject_id]' : "",
		'advance_search[month]' : month_id,
		'advance_search[year]' : year_id,
		'id' : student_id,
	}

	var target = "/student_attendance/student"
	$("#report_content").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	$.get(target, {data : data, q : student_admission_no}, function(data1) {
		$('#outer_block').removeBlockMessages();
		$('#report_content').empty();
		$('#report_content').html(data1);
		configureReportAttendance($('#reportSAtt'));
		$('#outer_bloc').removeBlockMessages();
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});


// ============================Student Award============================================ //


$(document).on("click", "#create_student_award", function(event) {
	event.preventDefault();
	var title = $('#award_title').val();
	var awardDate = $('#student_award_date').val();
	var awardDescription = $('#award_description').val();
	var studentId = $('#student_award_id').val();
	var batch_id = $('#student_award_batch').val();
	var special_character = isSpclChar();
	var stringReg = /^[A-Za-z() ]*$/;
    if(!stringReg.test(title)) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter characters for Award Title', {
				type : 'warning'
			});
		return false;
	}
	if(title.length >= 50) {
			$('#outer_bloc').removeBlockMessages().blockMessage('You can not enter more than 50 character in Title', {
				type : 'warning'
			});
		return false;
	}
	if(special_character[0] == false) {
			$('#outer_bloc').removeBlockMessages().blockMessage('Special Charcter are not allowed in '+special_character[1], {
			type : 'warning'
			});
			return false;
    }
	   if(awardDate == "") {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please select the Date', {
				type : 'warning'
			});
			return false;
		}
		if(title.length == "") {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter the Title', {
				type : 'warning'
			});
			return false;
		}
		if(awardDescription == "") {
			$('#outer_bloc').removeBlockMessages().blockMessage('Please enter the Description', {
				type : 'warning'
			});
			return false;
		}
	var data = {
		'student_award[title]' : title,
		'student_award[award_date]' : awardDate,
		'student_award[description]' : awardDescription,
		'student_award[student_id]' : studentId,
		'student_award[batch_id]' : batch_id
	}
	var target = "/student_awards"
	$.ajax({
		url : target,
		dataType : 'json',
		data : data,
		type : "POST",
		success : function(data) {
			if(data.valid) {
				$('#award_title').val("");
				$('#award_description').val("");
				$.get('/student_awards', {id : studentId}, function(data) {
					$('#replcae_awardList').empty();
					$('#replcae_awardList').html(data);
					configureStudentAwardListTable($('.awardListsortable'));
				}).error(function(jqXHR, textStatus, errorThrown) { 
					        window.location.href = "/signin"
				});
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403 ) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
});

$(document).on("click",'a.delete-studentAward-master-href', function(event) {
		event.preventDefault();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var remoteUrl = '/student_awards/destroy' + "/" + object_id;
		confirmAwardDelete(remoteUrl, table, row);
		return true;
	});


$(document).on("click",'a.update-studentAward-master-href', function(event) {
		event.preventDefault();
		var aLink = $(this);
		var table = aLink.parents('table');
		var row = aLink.parents('tr');
		var object_id = aLink.siblings('input').val();
		var batch_id = $('#student_award_batch').val();
		$.get('/student_awards/' + object_id + '/edit', {id : object_id}, function(data) {
			editStudentAward(data, object_id, batch_id);	
		}).error(function(jqXHR, textStatus, errorThrown) { 
			        window.location.href = "/signin"
		});
	});



function confirmAwardDelete(remoteUrl, table, row) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxAwardDelete(remoteUrl, table, row);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxAwardDelete(remoteUrl, table, row) {
	$.ajax({
		url : remoteUrl,
		type : 'DELETE',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data) {
			if(data.valid) {
				var dataTable = table.dataTable();
				dataTable.fnDeleteRow(row.index());
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success',
				});
				dataTable.fnUpdate();	
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
}

function editStudentAward(contents, object_id, batch_id) {
	var students_id = $('#students_id').val();
	$.modal({
		content : contents,
		title : 'Edit Award',
		width : 700,
		buttons : {
			'Update' : function(win) {
				var title = $('#modal #award_title').val();
				var description = $('#modal #award_description').val();
				var awarddate = $('#modal #student_award_date').val();
				var special_character = isSpclChar();
				if(special_character[0] == false) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Special Charcter are not allowed in '+special_character[1], {
						type : 'warning'
						});
						return false;
			    }
				if(title == "") {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter the Title', {
						type : 'warning'
					});
					return false;
				}
				if(description == "") {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter the Description', {
						type : 'warning'
					});
					return false;
				}
				var stringReg = /^[A-Za-z() ]*$/;
			    if(!stringReg.test(title)) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter characters for Award Title', {
							type : 'warning'
						});
					return false;
				}
				if(title.length >= 50) {
						$('#modal #outer_block').removeBlockMessages().blockMessage('You can not enter more than 50 character in field', {
							type : 'warning'
						});
					return false;
				}
				ajaxAwardUpdate(students_id, batch_id, title, description, awarddate, win, object_id);
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
	modal_box_datepicker();
}

function ajaxAwardUpdate(students_id, batch_id, title, description, awarddate, win, object_id) {
	$.ajax({
		url : '/student_awards/' + object_id,
		type : 'PUT',
		dataType : 'json',
		data : {
			'student_award[title]' : title,
			'student_award[description]' : description,
			'student_award[award_date]' : awarddate,
			'student_award[student_id]' : students_id,
			'student_award[batch_id]' : batch_id,
			'id' : object_id
		},
		success : function(data) {
			if(data.valid) {
				win.closeModal();
				$.get('/student_awards', {id : students_id}, function(data) {
					$('#replcae_awardList').empty();
					$('#replcae_awardList').html(data);	
					configureStudentAwardListTable($('.awardListsortable'));
				}).error(function(jqXHR, textStatus, errorThrown) { 
					        window.location.href = "/signin"
				});
				$('#outer_bloc').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});		
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_bloc').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_bloc').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
}

//==========================================================================================// 

//student meeting center
$(document).on("click", "#student_meeting", function(event) {
	event.preventDefault();
	var student = $(this).attr('student');
	var admission_no = $(this).attr('admission_no');
	var ptm_master = $(this).attr('ptm_master');
	var ptm_detail = $(this).attr('ptm_detail');
	var url ='student_meeting_details'
	var data ={
		'student' :student,
		'ptm_master' :ptm_master,
		'q' : admission_no
	}
	$.get(url,data,function(data){
		$.modal({
		content : data,
		title : 'Student Meeting',
		maxWidth : 1000,
	    maxHeight : 1000,
	    buttons : {
			'Update' : function(win) {
				var feedback = $("#modal #parent_feed").val();
				enterParentFeedBack(feedback,ptm_detail,win)
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	    });
	}).error(function(jqXHR, textStatus, errorThrown) { 
		        window.location.href = "/signin"
	});
});


function enterParentFeedBack(feedback,ptm_detail,win){
	$.ajax({
		url : '/ptm_details/update_parent_feedback',
		type : 'GET',
		dataType : 'json',
		data : {
			'id' : ptm_detail,
			'parent_feedback' : feedback
		},
		success : function(data) {
			if(data.valid) {
				$('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
				win.closeModal();	
			} else {
				var errorText = getErrorText(data.errors);
				$('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		    if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});
			}
		}
	});
}

function disableF5(e) { if (e.which == 116) e.preventDefault(); };
if($(document).find(".wizard-steps").length > 0){
	$(document).bind("keydown", disableF5);
}else{
	$(document).unbind("keydown", disableF5);
}


function submitform(){
	window.opener.location.reload(); 
	window.close();
}

$(document).on("click" , "#Crop_image", function(event){
	event.preventDefault();
     var crop_x = $("#crop_x").val();
     var crop_y = $("#crop_y").val();
     var crop_w = $("#crop_w").val();
     var crop_h = $("#crop_h").val();
     var studt_id = document.getElementById("studt_id").value;
     var student_id = document.getElementById("student_id").value;
     var data = {
     	'student[crop_x]' : crop_x,
     	'student[crop_y]' : crop_y,
     	'student[crop_w]' : crop_w,
     	'student[crop_h]' : crop_h,
     	             'q'  : studt_id,
			'student_id'  : student_id
     }
     
     $.ajax({
     	url : "/student/update_crop_image",
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

$(document).ready(function() {
	$('#report_gender').attr('checked', false);
});
$(document).on("click","#report_gender",function(event){
	var type =$("#type").val($(this).val());
	if ($("#reports_all").attr('checked')=="checked"){
		gender_all();
	}else if($("#reports_course").attr('checked')=="checked"){
		gender_course();
		}else if($("#reports_Batch").attr('checked')=="checked"){
		gender_batch();
		}else{
	$("#view_report_index").empty();
	$("#get_report").empty();
}
});
$(document).on("click","#report_religion",function(event){
	var type =$("#type").val($(this).val());
		if ($("#reports_all").attr('checked')=="checked"){
		gender_all();
	}else if($("#reports_course").attr('checked')=="checked"){
		gender_course();
		}else if($("#reports_Batch").attr('checked')=="checked"){
		gender_batch();
		}else{
	$("#view_report_index").empty();
	$("#get_report").empty();
}
});
$(document).on("click","#report_category",function(event){
	var type =$("#type").val($(this).val());
	if ($("#reports_all").attr('checked')=="checked"){
		gender_all();
	}else if($("#reports_course").attr('checked')=="checked"){
		gender_course();
		}else if($("#reports_Batch").attr('checked')=="checked"){
		gender_batch();
		}else{
	$("#view_report_index").empty();
	$("#get_report").empty();
}
	
});

$(document).on("click","#reports_all",function(event){
	
	$("#get_report").empty();
	var type =$("#type").val();
	var query=$(this).val();
	var data= {
		'type' : type,
		'query' : query
	}
	var url="view_report"
	$.get(url,data,function(data){
		$("#view_report_index").empty();
		$("#view_report_index").html(data);
		
	});
});
$(document).on("click","#reports_course",function(event){
	$("#get_report").empty();
	var type =$("#type").val();
	var query=$(this).val();
	var data= {
		'type' : type,
		'query' : query
	}
	var url="view_report"
	$.get(url,data,function(data){
		$("#view_report_index").empty();
		$("#view_report_index").html(data);
		
	});
});
$(document).on("click","#reports_Batch",function(event){
	$("#get_report").empty();
	var type =$("#type").val();
	var query=$(this).val();
	var data= {
		'type' : type,
		'query' : query
	}
	var url="view_report"
	$.get(url,data,function(data){
		$("#view_report_index").empty();
		$("#view_report_index").html(data);
		
	});
});

$(document).on("change","#gender_all",function(event){
	
	var query=$(this).val();
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_all_gender_report?query="+query
	$.get(url,function(data){
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
});
$(document).on("change","#religion_all",function(event){
	
	var query=$(this).val();
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_all_religion_report?query="+query
	$.get(url,function(data){
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
});
$(document).on("change","#category_all",function(event){
	var query=$(this).val();
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_all_category_report?query="+query
	$.get(url,function(data){
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
});

$(document).on("change","#gender_cours",function(event){
	$("#get_report").empty();
	var course=$(this).val();
	var gender = $("#gender_course").val();
	if (!gender || gender.length==0){
			$('#outer_block').removeBlockMessages().blockMessage('Please select gender', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
	gen_course(course,gender);
	}
});

$(document).on("change","#gender_course",function(event){
	$("#get_report").empty();
	var course=$("#gender_cours").val();
	var gender = $(this).val();
	if (!course || course.length==0){
			$('#outer_block').removeBlockMessages().blockMessage('Please select course', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
	gen_course(course,gender);
	}
});
$(document).on("change","#religion_cours",function(event){
	$("#get_report").empty();
	var religion=$("#religion_course").val();
	var course = $(this).val();
	if (!religion || religion.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please select religion', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
	religion_course(course,religion);
	}
});
$(document).on("change","#religion_course",function(event){
	$("#get_report").empty();
	var course=$("#religion_cours").val();
	var religion = $(this).val();
	if (!course || course.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please select course', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
	religion_course(course,religion);
	}
});

$(document).on("change","#category_course",function(event){
		$("#get_report").empty();
	var course=$("#category_cours").val();
	var category = $(this).val();
	if(!course || course.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please select course', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
		category_course(course,category);
	}
	
});

$(document).on("change","#category_cours",function(event){
		$("#get_report").empty();
	var course=$(this).val();
	var category = $("#category_course").val();
	if(!category || category.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please select student category', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
		category_course(course,category);
	}
});


$(document).on("click","#gender_bat",function(event){
	$("#get_report").empty();
	var course=$(this).val();
	var url="change_student_batch?course="+course
	$.get(url,function(data){
		$("#change_student_batch").empty();
		$("#change_student_batch").html(data);
		
	});
});

$(document).on("click","#re_course",function(event){
	$("#get_report").empty();
	var course=$(this).val();
	var url="change_student_course_batch?course="+course
	$.get(url,function(data){
		$("#change_student_batch").empty();
		$("#change_student_batch").html(data);
		
	});
});

$(document).on("click","#category_cou",function(event){
	$("#get_report").empty();
	var course=$(this).val();
	var url="change_student_category_batch?course="+course
	$.get(url,function(data){
		$("#change_student_batch").empty();
		$("#change_student_batch").html(data);
		
	});
});


$(document).on("change","#gender_batche",function(event){
	$("#get_report").empty();
	var batch=$("#gender_batch").val();
	var gender = $(this).val();
	if (!batch || batch.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
	ge_batch(batch,gender);
	}
});

$(document).on("change","#gender_batch",function(event){
	$("#get_report").empty();
	var gender=$("#gender_batche").val();
	var batch = $(this).val();
	if (!gender || gender.length==0){
		$('#outer_block').removeBlockMessages().blockMessage('Please select gender', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages()
	ge_batch(batch,gender);
	}
});


$(document).on("change","#religion_batch",function(event){
	$("#get_report").empty();
	var batch=$("#religion_batche").val();
	var religion = $(this).val();
	if (!batch || batch.length==0){
			$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages();
		get_religion_batch(batch,religion);
	}
});


$(document).on("change","#religion_batche",function(event){
	$("#get_report").empty();
	var religion=$("#religion_batch").val();
	var batch = $(this).val();
	if (!religion || religion.length==0){
			$('#outer_block').removeBlockMessages().blockMessage('Please select religion', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages();
		get_religion_batch(batch,religion);
	}
});


$(document).on("change","#category_batch",function(event){
	$("#get_report").empty();
	var batch=$("#category_batche").val();
	var category = $(this).val();
	if (!batch || batch.length==0){
			$('#outer_block').removeBlockMessages().blockMessage('Please select batch', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages();
		get_category_batch(batch,category);
	}
});

$(document).on("change","#category_batche",function(event){
	$("#get_report").empty();
	var category=$("#category_batch").val();
	var batch = $(this).val();
	if (!category || category.length==0){
			$('#outer_block').removeBlockMessages().blockMessage('Please select category', {
					type : 'warning'
				});
	}else{
		$('#outer_block').removeBlockMessages();
		get_category_batch(batch,category);
	}
});



function gender_all(){
	
	$("#get_report").empty();
	var type =$("#type").val();
	var query=$("#reports_all").val();
	var data= {
		'type' : type,
		'query' : query
	}
	var url="view_report"
	$.get(url,data,function(data){
		$("#view_report_index").empty();
		$("#view_report_index").html(data);
		
	});
}
function gender_course(){
	
	$("#get_report").empty();
	var type =$("#type").val();
	var query=$("#reports_course").val();
	var data= {
		'type' : type,
		'query' : query
	}
	var url="view_report"
	$.get(url,data,function(data){
		$("#view_report_index").empty();
		$("#view_report_index").html(data);
		
	});
	
}
function gender_batch(){
	$("#get_report").empty();
	var type =$("#type").val();
	var query=$("#reports_Batch").val();
	var data= {
		'type' : type,
		'query' : query
	}
	var url="view_report"
	$.get(url,data,function(data){
		$("#view_report_index").empty();
		$("#view_report_index").html(data);
		
	});
}


function religion_course(course,religion){
	var data={
		'course' : course,
		'religion' : religion
	}
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_religion_course_report"
	$.get(url,data,function(data){
		$('#outer_block').removeBlockMessages()
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
}


function category_course(course,category){
	
	var data={
		'course' : course,
		'category' : category
	}
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_category_course_report"
	$.get(url,data,function(data){
		
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
	
}

function gen_course(course,gender){
	var data={
		'course' : course,
		'gender' : gender
	}
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_gender_course_report"
	$.get(url,data,function(data){
		
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
}

function ge_batch(batch,gender){
	var data={
		'batch' : batch,
		'gender' : gender
	}
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_gender_batch_report"
	$.get(url,data,function(data){
		
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
}

function get_religion_batch(batch,religion){
	var data={
		'batch' : batch,
		'religion' : religion
	}
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_religion_batch_report"
	$.get(url,data,function(data){
		
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
}


function get_category_batch(batch,category){
		var data={
		'batch' : batch,
		'category' : category
	}
	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
	var url="get_category_batch_report"
	$.get(url,data,function(data){
		
		$("#get_report").empty();
		$("#get_report").html(data);
		configureGenderAllTable($(".gender_all_report"));
	});
}



//page count in pdf


$(document).ready(function() {
	var pdfInfo = {};
  var x = document.location.search.substring(1).split('&');

  for (var i in x) { var z = x[i].split('=',2); pdfInfo[z[0]] = unescape(z[1]); }
  function getPdfInfo() {
    var page = pdfInfo.page || 1;
    var pageCount = pdfInfo.topage || 1;
  }
  
});


   $(document).on("click","#report_center_student",function(event) {
   	$("#get_report").empty();
   	$("#view_report_index").empty();
   	$("#report_center_employee_view").hide();
	$("#report_center_student_view").show();
	});
	
	$(document).on("click","#report_center_employee",function(event) {
		$("#get_report").empty();
		$("#view_report_index").empty();
		$("#report_center_student_view").hide();
	$("#report_center_employee_view").show();
	});

$(document).ready(function(event) {
	$("#partcular_student").hide();
	$("#report_center_student_view").hide();
    $("#report_center_employee_view").hide();

});


$(document).on("change","#report_index_employee_department",function(event) {
   	var str=$(this).val();
   	var url="/student/employee_report_center?id="+str
   	$("#get_report").html('<img src=/assets/ajax-loader.gif style=vertical-align:middle;margin:0 10px 0 0 />');
   	$.get(url,function(data){
   	$("#get_report").empty();
	$("#get_report").html(data);	
	configureAllEmployeeReportTable($(".gender_all_employee_report"));
   	});
   	
	});


$(document).on("change","#report_card_course_name",function(event) {
var str=$(this).val();
var url="/student/update_batch?id="+str
$.get(url,function(data){
	$("#update_batch").empty();
	$("#update_batch").html(data);
});
});

$(document).on("click","#report_card_particular",function(event) {
	
	var batch=$("#report_card_batch_id").val();
	var url="/student/particular_student?batch="+batch
	$.get(url,function(data){
	$("#partcular_student").empty();
	$("#partcular_student").html(data);
	$("#partcular_student").show();
});
});