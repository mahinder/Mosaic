$(document).ready(function() {
	$('#schoolconfiguration_student_attendance_type').attr('disabled',true)
})

// $(document).ready(function() {
	// $('#update_school_configration').on('click', function(event) {
		// event.preventDefault();
		// var name = $('#schoolconfiguration_institution_name').val();
		// var address = $('#schoolconfiguration_institution_address').val();
		// var phone = $('#schoolconfiguration_institution_phone_no').val();
		// if(!name || name.length == 0) {
			// $('#outer_block').removeBlockMessages().blockMessage('Please enter institute name', {
				// type : 'warning'
			// });
		// } else if(!address || address.length == 0) {
			// $('#outer_block').removeBlockMessages().blockMessage('Please enter institute address', {
				// type : 'warning'
			// });
		// } else if(!phone || phone.length == 0) {
			// $('#outer_block').removeBlockMessages().blockMessage('Please enter institute Phone', {
				// type : 'warning'
			// });
		// }else {
			// var submitBt = $(this);
			// var target = "/school_configurations"
			// // var network = $('#schoolconfiguration_network_state').val();
			// var start = $("#schoolconfiguration_financial_year_start_date").val();
			// var end = $("#schoolconfiguration_financial_year_end_date").val();
			// var datafile = $("input[name='upload\\[datafile\\]']").val();
			// alert(datafile)
			// // var datafile = 	document.getElementById('upload_datafile')
			// // $("#upload_datafile").val();
			// var type = $("#schoolconfiguration_currency_type").val();
			// var add_no= $("#schoolconfiguration_admission_number_auto_increment").is(":checked");
			// var emp_no= $("#schoolconfiguration_employee_number_auto_increment").is(":checked");
			// var sms= $("#schoolconfiguration_sms_enabled").is(":checked");
			// var attedance = $('#schoolconfiguration_student_attendance_type').val();
			// // Target url
			// // Request
			// var data = {
// 				
				// 'schoolconfiguration[institution_name' : name,
				// 'schoolconfiguration[institution_address]' : address,
				// 'schoolconfiguration[institution_phone_no]' : phone,
				// 'schoolconfiguration[student_attendance_type]' : attedance,
				// // 'schoolconfiguration[network_state]' : network,
				// 'schoolconfiguration[financial_year_start_date]' : start,
				// 'schoolconfiguration[financial_year_end_date]' : end,
				// 'upload[datafile]' : datafile,
				// 'schoolconfiguration[currency_type]' : type,
				// 'schoolconfiguration[admission_number_auto_increment]' : add_no,
				// 'schoolconfiguration[employee_number_auto_increment]' : emp_no,
				// 'schoolconfiguration[sms_enabled]' : sms,
				// '_method' : 'put'
			// }
// 			
			// Update(data, submitBt);
// 			
// 			
		// }	
	// });
// });
// 
// function Update(data, submitBt) {
	// $.ajax({
		// url : "/school_configurations/1",
		// type : 'post',
		// dataType : 'json',
		// data : data, // it should have '_method' : 'put'
		// success : function(data, textStatus, jqXHR) {
			// if(data.valid) {
				// //individual domain need to implement this method
// 				
				// //populateTables();
// 				
				// $('#outer_block').removeBlockMessages().blockMessage(data.notice, {
					// type : 'success'
				// });
			// } else {
				// var errorText = getErrorText(data.errors);
				// $('#outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					// type : 'error'
				// });
				// submitBt.enableBt();
			// }
		// },
		// error : function(jqXHR, textStatus, errorThrown) {
			// // Message
			// $('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
				// type : 'error'
			// });
			// submitBt.enableBt();
		// }
	// });
	// // Message
	// $('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		// type : 'loading'
	// });
// }