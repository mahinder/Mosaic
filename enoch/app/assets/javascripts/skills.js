
$(document).on("click", ".skills_course_for_button", function(event) {
	//$(".elective-skill-secound").each(function() {
	var course = $(this).attr('data-course');
	var course_name = $(this).attr('data-course-name');
	var tab_id = "#tab-mandatory_skills-tab_" + course
	// Prevent link opening
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-skills');
	$.modal({
		content : contents,
		title : 'Skill Creation',
		width : 700,
		height : 375,
		buttons : {

			'Create' : function(win) {

				var name = $('#modal #skill_name').val();
				var classes = $('#modal #skill_max_weekly_classes').val();
				var exam = $('#modal #skill_no_exam').val();
				var code = $('#modal #skill_code').val();
				var is_exam = $('#modal #skill_no_exam').is(":checked");
				var is_common = $('#modal #skill_is_common').is(":checked");
				var is_scholastic = $('#modal #skill_is_scholastic').is(":checked");
				var common = ""
				if(is_common == true) {
					common = "true"
				} else {
					common = "false"
				}
				if(is_exam == true) {
					exam = "true"
				} else {
					exam = "false"
				}
				var course_id = course;
				var notnumericcharacterReg = /^\s*[a-zA-Z,_,\-,\.,\s]+\s*$/;
				var characterReg = /^\s*[a-zA-Z0-9,_,\-,\.,\s]+\s*$/;
				var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
				if(!name || name.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill name', {
						type : 'warning'
					});
				} else if(!notnumericcharacterReg.test(name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('please enter only character for name', {
						type : 'warning'
					});
				} else if(name.length > 25) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('please enter maximum 25 character for name', {
						type : 'warning'
					});
				} else if(!code || code.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill code', {
						type : 'warning'
					});
				} else if(code.length > 25) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter maximum 25 character for code', {
						type : 'warning'
					});
				} else if(!characterReg.test(code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('special characters are not allowed in code', {
						type : 'warning'
					});
				} else if(!numericReg.test(classes)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('PLEASE ENTER A NUMERIC VALUE IN MAXIMUM CLASES', {
						type : 'warning'
					});
				} else if(classes.length > 2) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('please enter maximum 2 digit for maximum classes per week', {
						type : 'warning'
					});
				} else if(!classes || classes.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill max classes', {
						type : 'warning'
					});
				} else{
					// Target url
					var target = '/skills'
					// Requ@elective_skillsest
					var data = {
						'skill[name]' : name,
						'skill[max_weekly_classes]' : classes,
						'skill[no_exam]' : exam,
						'skill[course_id]' : course,
						'skill[elective_skill_id]' : "",
						'skill[code]' : code,
						'skill[is_common]' : common,
						'course_id' : course_id,
						'skill[full_name]' : course_name + "-" + name,
						'skill[is_scholastic]' : is_scholastic ,
						'course_id' : course
					}

					ajaxCreateMandatorySkillCreate(target, data, course_id, win, tab_id);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
});
function ajaxCreateMandatorySkillCreate(target, data, course_id, win, tab_id) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				win.closeModal();
				//individual domain need to implement this method
				//var data_course_value = data.course_value
				//alert(data_course_value)
				// $.get('/courses/view_skills', {

					// id : course_id
				// }, function(data) {
					// $(tab_id).empty();
					// $(tab_id).html(data);
					// $('.tabs').updateTabs();
				// }).error(function(jqXHR, textStatus, errorThrown) { 
		      			 // window.location.href = "/signin"
		       // window.location.href = "/signin"
				// });
				window.parent.location.reload()
				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});
					
			} else {
				// Message
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

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}


$(document).on("click", ".elective_skills_skills", function(event) {
	//$(".elective-skill-secound").each(function() {
	$('#modal-box-skills-elective #batch_ul').empty();
	var aLink = $(this);
	var course = $(this).attr('data-course');
	var course_name = $(this).attr('data-course-name');
	var batch_id = $(this).attr('data-batch_id');
	var batch_name = $(this).attr('data-batch_name');
	var id = $(this).attr('data-elective');
	$('#modal-box-skills-elective #skill_is_common').attr('checked', true);
	var tab_id = "#tab-elective_skills-tab_" + course + '_' + id
	var arr = batch_id.split(',')
	var arr1 = batch_name.split(',')
	var slr = 1
	var index = 0
	jQuery.each(arr, function() {
		$('#modal-box-skills-elective #batch_ul').append('<li style = "width:300px">' + slr + '  <input type="checkbox" name="batch" id ="course_batch_select_' + this + '" data-id ="' + this + '" class = "select_student_all"> <ul class="tags float-right"><li> <b>' + arr1[index] + '</b></li></ul></li>');
		slr = (slr + 1);
		index = index + 1;
	})
	// Prevent link opening
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-skills-elective');
	$.modal({
		content : contents,
		title : 'Skill Creation',
		width : 700,
		height : 350,
		buttons : {
			'SelectAll' : function(win) {
				$('.select_student_all').attr('checked', true);
			},
			'DeselectAll' : function(win) {
				$('.select_student_all').attr('checked', false);
			},
			'Create' : function(win) {

				var students_ids = []
				index = 0

				jQuery.each(arr, function() {

					var is_select = $("#modal #course_batch_select_" + this).is(":checked")
					if(is_select) {
						students_ids[index] = $("#modal #course_batch_select_" + this).attr('data-id')
						index = index + 1;
					}
				})
				var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
				var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
				var name = $('#modal #skill_name').val();
				var classes = $('#modal #skill_max_weekly_classes').val();
				var exam = $('#modal #skill_no_exam').val();
				var code = $('#modal #skill_code').val();
				var is_exam = $('#modal #skill_no_exam').is(":checked");
				var is_common = $('#modal #skill_is_common').is(":checked");
				var common = ""
				if(is_common == true) {
					common = "true"
				} else {
					common = "false"
				}
				if(is_exam == true) {
					exam = "true"
				} else {
					exam = "false"
				}

				if(!name || name.length == 0 || !characterReg.test(name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill name', {
						type : 'warning'
					});
				} else if(!characterReg.test(code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill code', {
						type : 'warning'
					});
				} else if(!numericReg.test(classes)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill max classes', {
						type : 'warning'
					});
				} else {
					// Target url
					var target = '/skills'
					// Requ@elective_skillsest
					var data = {
						'skill[name]' : name,
						'skill[max_weekly_classes]' : classes,
						'skill[no_exam]' : exam,
						'skill[course_id]' : course,
						'skill[elective_skill_id]' : id,
						'skill[is_common]' : common,
						'skill[code]' : code,
						'skill[full_name]' : course_name + "-" + name,
						'course_id' : course,
						'students_ids' : students_ids
					}

					ajaxCreateelectiveSkillsSkillCreate(target, id, course, data, win, tab_id);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			},
			
		}
	});
});
function ajaxCreateelectiveSkillsSkillCreate(target, id, course, data, win, tab_id) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				win.closeModal();
				//individual domain need to implement this method
				//var data_course_value = data.course_value
				//alert(data_course_value)

				$.get('/skills/create_elective_skill', {
					id : id,
					course : course
				}, function(data) {
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs();
				});

				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});

			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			if (jqXHR.status === 403) {
		        window.location.href = "/signin"
		    }else{
				$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
					type : 'error'
				});	
			}	

		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}

//======================================================================================================
//--------------------------------------------edit --------------

$(document).on("click", ".update-skill-href", function(event) {
	//$(".elective-skill-secound").each(function() {
	$('#modal-box-skills-edit-elective #batch_ul_assign').empty()
	$('#modal-box-skills-edit-elective #batch_ul_unassign').empty()
	var aLink = $(this);
	var id = $(this).attr('data-id');
	var batch_id = $(this).attr('data-batch_id');
	var batch_name = $(this).attr('data-batch_name');
	var arr = batch_id.split(',')
	var arr1 = batch_name.split(',')

	var slr = 1
	var index = 0
	var assign_batch = ""
	$.getJSON('/skills/assigned/' + id, function(data) {
		assign_batch = data.batchid
		arr2 = assign_batch.split(',')
		
		jQuery.each(arr, function(i, item) {
			var values = ""
			jQuery.each(arr2, function(j, item1) {

				if(item == item1) {
					values = "yes"

				}
			})
			if(values == "yes") {
				$('#modal-box-skills-edit-elective #batch_ul_assign').append('<li style = "width:300px">' + slr + '  <input type="checkbox" name="batch" id ="subject_batch_select_' + this + '" data-id ="' + this + '" class = "select_student_alla"> <ul class="tags float-right"><li> <b>' + arr1[index] + '</b></li></ul></li>');
			} else if(values == "") {
				$('#modal-box-skills-edit-elective #batch_ul_unassign').append('<li style = "width:300px">' + slr + '  <input type="checkbox" name="batch" id ="subject_batch_select_' + this + '" data-id ="' + this + '" class = "select_student_allu"> <ul class="tags float-right"><li> <b>' + arr1[index] + '</b></li></ul></li>');
			}
			slr = (slr + 1);
			index = index + 1;

		})
	}).error(function(jqXHR, textStatus, errorThrown) { 
		       window.location.href = "/signin"
		});
	var course = $(this).attr('data-course');
	var elective_id = $(this).attr('data-elective');
	var tab_id = "#tab-elective_skills-tab_" + course + '_' + elective_id
	var table = aLink.parents('table');
	var row = aLink.parents('tr');
	var object_id = aLink.siblings('input').val();
	$('#modal-box-skills-edit-elective #skill_name').val($('#elective_skill_name_' + object_id).html());
	$('#modal-box-skills-edit-elective #skill_max_weekly_classes').val($('#elective_skill_max_no_of_clases_' + object_id).html());
	$('#modal-box-skills-edit-elective #skill_code').val($('#elective_skill_code_' + object_id).html());

	if($('#elective_skill_skill_exam_' + object_id).html() == "No Exam") {
		$('#modal-box-skills-edit-elective #skill_no_exam').attr('checked', true);
	} else if($('#elective_skill_skill_exam_' + object_id).html() == "Exam") {
		$('#modal-box-skills-edit-elective #skill_no_exam').attr('checked', false);
	}
	if($('#elective_skill_skill_common_' + object_id).html() == "Common") {
		$('#modal-box-skills-edit-elective #skill_is_common').attr('checked', true);
	} else if($('#elective_skill_skill_common_' + object_id).html() == "Not in Common") {
		$('#modal-box-skills-edit-elective #skill_is_common').attr('checked', false);
	}
	if($('#elective_skill_active_' + object_id).html() == "Active") {
		$('#modal-box-skills-edit-elective #skill_is_active').attr('checked', true);
	} else if($('#elective_skill_active_' + object_id).html() == "Inactive") {
		$('#modal-box-skills-edit-elective #skill_is_active').attr('checked', false);
	}
	// $('#current_object_id').val(object_id);

	// Prevent link opening
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-skills-edit-elective');

	$.modal({
		content : contents,
		title : 'Skill Updation',
		width : 700,
		height : 350,
		buttons : {

			'Update' : function(win) {

				
				
					
				var name = $('#modal #skill_name').val();
				var classes = $('#modal #skill_max_weekly_classes').val();
				var exam = $('#modal #skill_no_exam').val();
				var code = $('#modal #skill_code').val();
				var is_exam = $('#modal #skill_no_exam').is(":checked");
				var is_common = $('#modal #skill_is_common').is(":checked");
				var is_active = $('#modal #skill_is_active').is(":checked");
				if(is_active == true) {
					active = "true"
				} else {
					active = "false"
				}

				var common = ""
				if(is_common == true) {
					common = "true"
				} else {
					common = "false"
				}

				if(is_exam == true) {
					exam = "true"
				} else {
					exam = "false"
				}
				var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
				var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
				if(!name || name.length == 0 || !characterReg.test(name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill name', {
						type : 'warning'
					});
				} else if(!characterReg.test(code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill code', {
						type : 'warning'
					});
				} else if(!numericReg.test(classes)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill max classes', {
						type : 'warning'
					});
				} else {
					// Target url
					var target = '/skills/' + id
					// Requ@elective_skillsest
					var data = {
						'skill[name]' : name,
						'skill[max_weekly_classes]' : classes,
						'skill[no_exam]' : exam,
						'skill[is_common]' : common,
						'skill[is_active]' : active,
						'skill[code]' : code,
						'_method' : 'put',
						

					}

					ajaxCreateelectiveSkillsSkillUpdate(target, elective_id, course, data, win, tab_id,arr,arr1,id);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
});
function ajaxCreateelectiveSkillsSkillUpdate(target, elective_id, course, data, win, tab_id,arr,arr1,id) {
	$.ajax({
		url : target,
		type : 'post',
		dataType : 'json',
		data : data, // it should have '_method' : 'put'
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				
				//individual domain need to implement this method
				//var data_course_value = data.course_value
				//alert(data_course_value)
				
				$.get('/skills/create_elective_skill', {
					id : elective_id,
					course : course
				}, function(data) {
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs();
				}).error(function(jqXHR, textStatus, errorThrown) { 
		       		window.location.href = "/signin"
				});
				
				var index1 = 0
				var index2 = 0
				var index3 = 0
								var arr3; 
				$.getJSON('/skills/assigned/' + id, function(data) {
					var assign_values = []
					var deassign_values = []
					var  assign_batch1 = ""

					assign_batch1 = data.batchid
					arr3 = assign_batch1.split(',')
					
					jQuery.each(arr, function(k, item2) {
						var values1 = ""
						jQuery.each(arr3, function(l, item3) {

							if(item2 == item3) {
								values1 = "yes"

							}
						})
						if(values1 == "yes") {
							
							var is_select = $("#modal #subject_batch_select_"+arr[index3]).is(":checked")
							if(is_select) {
								deassign_values[index1] = $("#modal #subject_batch_select_"+arr[index3]).attr('data-id')
						     	index1 = index1 + 1;
						     	
						       }
						} if(values1 == "") {
							var is_select = $("#modal #subject_batch_select_"+arr[index3]).is(":checked")
							if(is_select) {
								assign_values[index2] = $("#modal #subject_batch_select_"+arr[index3]).attr('data-id')
						     	index2 = index2 + 1;
						     	
						       }
						}
					
						
					index3= index3 + 1;
					})

					$.getJSON('/skills/remove_batch',{id: id ,assign_values: assign_values ,deassign_values: deassign_values }, function(data) {
						win.closeModal();
					}).error(function(jqXHR, textStatus, errorThrown) { 
		       			window.location.href = "/signin"
					});
				}).error(function(jqXHR, textStatus, errorThrown) { 
		      		 window.location.href = "/signin"
				});
		
				


				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});

			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
				type : 'error'
			});

		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}

//================================mandatory
$(document).on("click", ".update-mandatory-skill-href", function(event) {
	//$(".elective-skill-secound").each(function() {
	var aLink = $(this);
	var id = $(this).attr('data-id');
	var course = $(this).attr('data-course');
	var tab_id = "#tab-mandatory_skills-tab_" + course
	var object_id = aLink.siblings('input').val();
	scholastic = document.getElementById('is_scholastic_' + object_id).value
	$('#modal-box-skills-edit #skill_name').val($('#mandatory_skill_name_' + object_id).html());
	$('#modal-box-skills-edit #skill_max_weekly_classes').val($('#mandatory_max_no_of_clases_' + object_id).html());
	$('#modal-box-skills-edit #skill_code').val($('#mandatory_skill_code_' + object_id).html());
	var value = $('#mandatory_skill_exam_' + object_id).html()
	if($('#mandatory_skill_exam_' + object_id).html() == "No Exam") {
		$('#modal-box-skills-edit #skill_no_exam').attr('checked', true);
	} else if($('#mandatory_skill_exam_' + object_id).html() == "Exam") {
		$('#modal-box-skills-edit #skill_no_exam').attr('checked', false);
	}
	// Prevent link opening
	var value_com = $('#mandatory_skill_common_' + object_id).html()
	if($('#mandatory_skill_common_' + object_id).html() == "Common") {
		$('#modal-box-skills-edit #skill_is_common').attr('checked', true);
	} else if($('#mandatory_skill_common_' + object_id).html() == "Not in Common") {
		$('#modal-box-skills-edit #skill_is_common').attr('checked', false);
	}
	if($('#mandatory_skill_active_' + object_id).html() == "Active") {
		$('#modal-box-skills-edit #skill_is_active').attr('checked', true);
	} else if($('#mandatory_skill_active_' + object_id).html() == "Inactive") {
		$('#modal-box-skills-edit #skill_is_active').attr('checked', false);
	}
	
	if(scholastic == "true") {
		$('#modal-box-skills-edit #skill_is_scholastic').attr('checked', true);
	} else  {
		$('#modal-box-skills-edit #skill_is_scholastic').attr('checked', false);
	}
	event.preventDefault();
	// Open modal
	var contents = $('#modal-box-skills-edit');
	$.modal({
		content : contents,
		title : 'Skills Updation',
		width : 700,
		height : 350,
		buttons : {

			'Update' : function(win) {

				var name = $('#modal #skill_name').val();
				var classes = $('#modal #skill_max_weekly_classes').val();
				var exam = $('#modal #skill_no_exam').val();
				var code = $('#modal #skill_code').val();
				var is_exam = $('#modal #skill_no_exam').is(":checked");
				var is_common = $('#modal #skill_is_common').is(":checked");
				var is_active = $('#modal #skill_is_active').is(":checked");
				var is_scholastic = $('#modal #skill_is_scholastic').is(":checked");
				var common = ""
				if(is_active == true) {
					active = "true"
				} else {
					active = "false"
				}
				if(is_common == true) {
					common = "true"
				} else {
					common = "false"
				}

				if(is_exam == true) {
					exam = "true"
				} else {
					exam = "false"
				}
				var course_id = course;
				var notnumericcharacterReg = /^\s*[a-zA-Z,_,\-,\.,\s]+\s*$/;
				var characterReg = /^\s*[a-zA-Z0-9,_,\-,\.,\s]+\s*$/;
				var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
				if(!name || name.length == 0 ) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill name', {
						type : 'warning'
					});
				} else if(!notnumericcharacterReg.test(name)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('please enter only character for name', {
						type : 'warning'
					});
				} else if(name.length > 25) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('please enter maximum 25 character for name', {
						type : 'warning'
					});
				} else if(!code || code.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill code', {
						type : 'warning'
					});
				} else if(code.length > 25) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter maximum 25 character for code', {
						type : 'warning'
					});
				} else if(!characterReg.test(code)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('special characters are not allowed in code', {
						type : 'warning'
					});
				} else if(!numericReg.test(classes)) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('PLEASE ENTER A NUMERIC VALUE IN MAXIMUM CLASES', {
						type : 'warning'
					});
				} else if(classes.length > 2) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('please enter maximum 2 digit for maximum classes per week', {
						type : 'warning'
					});
				} else if(!classes || classes.length == 0) {
					$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Skill max classes', {
						type : 'warning'
					});
				} else {
					// Target url
					var target = '/skills/' + id
					// Requ@elective_skillsest
					var data = {
						'skill[name]' : name,
						'skill[max_weekly_classes]' : classes,
						'skill[no_exam]' : exam,
						'skill[code]' : code,
						'skill[is_active]' : active,
						'skill[is_common]' : common,
						'skill[is_scholastic]' : is_scholastic,
						'course_id' : course_id,
						'_method' : 'put'
					}

					ajaxUpdateMandatorySkillUpdate(target, data, course_id, win, tab_id);
				}
				//var element = $(context, '#course_course_name');

				//win.closeModal();
			},
			'Close' : function(win) {
				win.closeModal();
			}
		}
	});
});
function ajaxUpdateMandatorySkillUpdate(target, data, course_id, win, tab_id) {
	$.ajax({
		url : target,
		dataType : 'json',
		type : 'post',
		data : data,
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				win.closeModal();
				//individual domain need to implement this method
				//var data_course_value = data.course_value
				//alert(data_course_value)

				// $.get('/courses/view_skill/' + course_id, function(data) {
					// $(tab_id).empty();
					// $(tab_id).html(data);
					// $('.tabs').updateTabs();
				// });
				window.parent.location.reload()
				$('#modal #outer_block').removeBlockMessages().blockMessage(data.notice, {
					type : 'success'
				});

			} else {
				// Message
				var errorText = getErrorText(data.errors);
				$('#modal #outer_block').removeBlockMessages().blockMessage(errorText || 'An unexpected error occured, please try again', {
					type : 'error'
				});

			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			// Message
			$('#modal #outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
				type : 'error'
			});

		}
	});

	// Message
	$('#modal #outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});

}

//===================delete elective

$(document).on("click", ".delete-elective-skill-href", function(event) {

	var aLink = $(this);
	var object_id = aLink.siblings('input').val();
	var course = $(this).attr('data-course');
	var elective_id = $(this).attr('data-elective');
	var tab_id = "#tab-elective_skills-tab_" + course + '_' + elective_id
	var remoteUrl = "/skills" + "/" + object_id;
	confirmDeleteElective(remoteUrl, elective_id, course, tab_id);
	return false;
});
function confirmDeleteElective(remoteUrl, elective_id, course, tab_id) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteElectiveSkill(remoteUrl, elective_id, course, tab_id);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteElectiveSkill(remoteUrl, elective_id, course, tab_id) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$.get('/skills/create_elective_skill', {
					id : elective_id,
					course : course
				}, function(data) {
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs();
				});

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
			$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
				type : 'error'
			});
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}

//===================delete mandatory

$(document).on("click", ".delete-mandatory-skill-href", function(event) {

	var aLink = $(this);
	var object_id = aLink.siblings('input').val();
	var course = $(this).attr('data-course');
	var tab_id = "#tab-mandatory_skills-tab_" + course
	var remoteUrl = "/skills" + "/" + object_id;
	confirmDeleteMandatory(remoteUrl, course, tab_id);
	return false;
});
function confirmDeleteMandatory(remoteUrl, course, tab_id) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteMandatorySkill(remoteUrl, course, tab_id);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteMandatorySkill(remoteUrl, course, tab_id) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$.get('/courses/view_skill/' + course, function(data) {
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs();
				});
				window.parent.location.reload()
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
			$('#outer_block').removeBlockMessages().blockMessage('Error while contacting server, please try again', {
				type : 'error'
			});
		}
	});

	// Message
	$('#outer_block').removeBlockMessages().blockMessage('Please wait, connecting to backend...', {
		type : 'loading'
	});
}