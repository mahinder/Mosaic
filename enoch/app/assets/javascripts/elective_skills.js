$(document).on("click", ".elective-skill-secound", function(event) {
	//$(".elective-skill-secound").each(function() {
		var course = $(this).attr('data-course');
		var course_for = $(this).attr('data-course-for');
		var tab_id = "#tab_" + course
				// Prevent link opening
			event.preventDefault();
			// Open modal
			var contents = $('#modal-box-elective');
			$.modal({
				content : contents,
				title : 'Elective Skill Creation',
				width : 700,
				height : 200,
				buttons : {
					
					'Create' : function(win) {
						var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
						var name = $('#modal #elective_skill_name').val();
						var course_id = course;
						if(!name || name.length == 0 || !characterReg.test(name)) {
							$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Elective Skill name', {
								type : 'warning'
							});
						}  else {
							// Target url
							var target = '/elective_skills'
					// Requ@elective_skillsest
							var data = {
								'elective_skill[name]' : name,
								'elective_skill[course_id]' : course_id,
								'course_for': course_for,
								'course_id' : course_id
							}

							ajaxCreateElective(target, data,course_for,course_id, win,tab_id);
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

$(document).on("click", ".elective_skills_skills_edit", function(event) {
	//$(".elective-skill-secound").each(function() {
		var aLink = $(this);
				var course_id = $(this).attr('data-course');
				var elective_id = $(this).attr('data-elective');
				$('#modal-box-elective-edit #elective_skill_name').val($('#elective_name_'+course_id+'_'+elective_id).html());
			
				// Prevent link opening
			event.preventDefault();
			// Open modal
			var contents = $('#modal-box-elective-edit');
			$.modal({
				content : contents,
				title : 'Elective Skill Updation',
				width : 700,
				height : 200,
				buttons : {
					
					'Update' : function(win) {
						var characterReg = /^\s*[a-zA-Z0-9,_,\-,\s]+\s*$/;
						var name = $('#modal #elective_skill_name').val();
						
						if(!name || name.length == 0 || !characterReg.test(name)) {
							$('#modal #outer_block').removeBlockMessages().blockMessage('Please enter Elective Skill name', {
								type : 'warning'
							});
						}  else {
							// Target url
							var target = '/elective_skills/'+elective_id
					// Requ@elective_skillsest
							var data = {
								'elective_skill[name]' : name,
								'_method' : 'put'
							}
									$.ajax({
											url : target,
											dataType : 'json',
											type : 'post',
											data : data,
											success : function(data, textStatus, jqXHR) {
												if(data.valid) {
													win.closeModal();
													
													$('#elective_name_'+course_id+'_'+elective_id).html(name)
														$('#warning').removeBlockMessages().blockMessage(data.notice, {
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




function ajaxCreateElective(target, data,course_for,course_id, win,tab_id) {
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
					
				$.get('/courses/elective_skill',{course_for: course_for,course_id: course_id}, function(data) {
					$(tab_id).empty();
					$(tab_id).html(data);
					$('.tabs').updateTabs();
					$('.side-tabs').updateTabs();
					$('.tabs li').removeClass('current');
					$('#tab_ul_'+course_id+' li.icon-tab').prev().addClass('current');
					window.parent.location.reload()	
						
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


$(document).on("click", ".elective_skills_skills_delete", function(event) {
		
		var aLink = $(this);
		var course_id = $(this).attr('data-course');
		var elective_id = $(this).attr('data-elective');
		var remoteUrl = "/elective_skills/"+elective_id
		confirmDeleteelective(remoteUrl,course_id,elective_id);
		return false;
	});
function confirmDeleteelective(remoteUrl,course_id,elective_id) {
	$.modal({
		content : '<h3>Are you sure?</h3><br/><br/><p>You are about to delete a record...</p>',
		title : 'Warning',
		maxWidth : 500,
		buttons : {
			'OK' : function(win) {
				ajaxDeleteelective(remoteUrl,course_id,elective_id);
				win.closeModal();
			},
			'Cancel' : function(win) {
				win.closeModal();
			}
		}
	});
}

function ajaxDeleteelective(remoteUrl,course_id,elective_id) {
	$.ajax({
		url : remoteUrl,
		type : 'post',
		dataType : 'json',
		data : {
			'course_id' : course_id,
			'_method' : 'delete'
		},
		success : function(data, textStatus, jqXHR) {
			if(data.valid) {
				$('#elective_name_'+course_id+'_'+elective_id).removeClass("current")
				$('li #elective_name_'+course_id+'_'+elective_id).prev().addClass("current");
				$('#elective_name_'+course_id+'_'+elective_id).remove();
				$('#tab-elective_skills-tab_'+course_id+'_'+elective_id).remove();
				$('.tabs').updateTabs();
					$('#warning').removeBlockMessages().blockMessage(data.notice, {
						type : 'success'
					});
			} else {
				
				
						$('#warning').removeBlockMessages().blockMessage('elctive skill can not be deleted', {
							type : 'warning'
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


