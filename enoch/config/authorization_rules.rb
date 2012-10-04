authorization do

  role :manage_users do
    has_permission_on [:users],  :to => [
        :find,
        :reset,
        :reset_password_of_any_user,
        :reset_password
        ]
  end

  role :assign_privilege do
    has_permission_on [:users],  :to => [:privileges_of_any_user,:find_employee]
    has_permission_on [:employees],  :to => [:edit_privilege,:profile]  end

  role :ptm_management do
    has_permission_on [:ptm_admin],  :to => [
     :index,
     :update,
     :show,
     :ptm,
     :edit
      ]
  end
  role :examination_control do
    has_permission_on [:exams],
      :to => [
      :index,
      :edit_grouping,
      :secondry_standard_report,
      :co_scholastic_assessment_index,
      :co_scholastic_area_assessment_report,
      :co_scholastic_activity_assessment_report,
      :generated_report5_pdf,
      :grouping_assessment_type,
      :graph_for_generated_report3,
      :student_generated_report5,
      :second_graph_for_generated_repport,
      :grouping_assessment_mode,
      :new_grouping_assessment,
      :create_exam,
      :update_batch,
      :view_exam_score_updation,
      :normal_academic_report,
      :create_examtype,
      :create,
      :edit,
      :publish,
      :grouping,
      :update_exam_form,
      :list_exam_types,
      :list_subjects,
      :destroy_grouped_exam,
      :destroy_exam,
      :update_exam,
      :view_grouping,
      :delete_view_grouping
    ]
    has_permission_on [:exam_groups],
      :to => [
      :delete_exam_group,
      :subject_validations,
      :scholastic_area_assessment,
      :changeExam,
      :index,
      :exam_group_index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :initial_queries

    ]

    has_permission_on [:additional_exam],
      :to => [
      :index,
      :edit,
      :update_additional_exam,
      :destroy_additional_exam,
      :create_index,
      :update_exam_form,
      :publish,
      :create_additional_exam,
      :update_batch
    ]

    has_permission_on [:additional_exam_groups],
      :to => [
      :index,
      :scholastic_area_assessment,
      :new,
      :show,
      :create,
      :index1,
      :additional_exam_group_index,
      :get_max_min_marks,
      :create_index,
      :edit,
      :update,
      :destroy,
      :initial_queries,
      :delete_additional_exam_group

    ]

    has_permission_on [:grading_level_details],
      :to => [
      :add_grading_detail,
      :create_grade,
      :view_grading_detail,
      :edit_grading_detail

    ]
    has_permission_on [:grading_level_groups],
      :to => [
      :all_record,
      :index,
      :update,
      :create,
      :destroy

    ]
  end

role :employee_wise_timetable  do
    has_permission_on [:timetable],
      :to => [
       :admin_wise_employee_page,
      :find,:employee_full_view,
      :today_timetable_substitution
    ]
  end

role :assign_rollno do
    has_permission_on [:student],
  :to => [
    :assign_roll_no,
    :change_roll_number
  ]
  end
  role :course_creation  do
    has_permission_on [:courses],
      :to => [
      :index,
      :manage_course,
      :manage_batches,
      :new,
      :create,
      :update_batch,
      :edit,
      :update,
      :destroy,
      :show,
      :find_course,
      :viewall,
      :view_skill,
      :manage_course,
      :find_course,
      :all_record,
      :elective_skill
    ]
    has_permission_on [:batches],
      :to => [
      :index,
      :all_record,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :init_data,
      :assign_tutor,
      :update_employees,
      :assign_employee,
      :remove_employee,
      :all_record,
      :room,
      :teacher,
      :select_batch,
      :update_batch_subject,
      :assign_student_to_sub,
      :assign_home_teacher_and_room,
      :subject_students,
      :assign_student_to_sub1,
      :remove_student_to_sub1,
      :show1,
      :subject_batch_student,
      :assign_skill_to_batch,
      :find_batch_subjects,
      :create_elective_group,
      :batch_history,
      :history_select_course,
      :history_select_batch,
      :batch_students_pdf

    ]
    has_permission_on [:elective_skills],
      :to => [
      :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show

    ]
    has_permission_on [:skills],
      :to => [
      :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :create_elective_skill,
      :assigned,
      :remove_batch
    ]
    has_permission_on [:sub_skills],
      :to => [
        :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :subskill_find,
      :subject_subskill
     
      ]
    
    
    
  end
  
  
  
  
  role :sms_template_creation  do
    has_permission_on [:sms_templates],
      :to => [
      :all_record,
      :index,:create,:update,:destroy
    ]
  end
  role :sms_settings  do
    has_permission_on [:sms],
      :to => [
      :settings,
      :update_application_sms_settings,
      :update_general_sms_settings
    ]
  end

  role :student_report  do
    
    has_permission_on [:student],
      :to => [
      :reports,
      :student_search,
      :report_card_index,
      :report_card,
      :search_ajax,
      :change_batch,
      :student_advanced_search,
      :exam_report
    ]
    has_permission_on [:archived_student],
      :to => [
      :award_report,

    ]
    has_permission_on [:student_attendance], :to => [:index, :student, :month,:student_attendanceReports]
    has_permission_on [:exams], :to => [:generated_report4,:previous_years_marks_overviews,:generated_report3,:generated_report4_pdf,:previous_years_marks_overview,:previous_years_marks_overview_pdf,:generated_report,:graph_for_generated_report3]
    has_permission_on [:additional_exam], :to => [:generated_report]
  end

  role :student_profile  do
    has_permission_on [:student],
      :to => [
      :student_search,
      :search_ajax,
      :my_profile,
      :change_batch,
      :student_advanced_search
    ]
    has_permission_on [:archived_student],
      :to => [
      :profile,
    ]
    has_permission_on [:student_attendance],
      :to => [
      :student,
    ]
  end
  role :sending_sms  do
    has_permission_on [:sms],
      :to => [
      :students,
      :template_find,
      :find,
      :sms_emp_send
    ]
  end
  role :enter_results  do
    has_permission_on [:exams],
      :to => [
      :grouping_assessment_type,
      :second_graph_for_generated_repport,
      :student_generated_report5,
      :generated_report5_pdf,
      :secondry_standard_report,
      :grouping_assessment_mode,
      :new_grouping_assessment,
      :save_scores,
      :co_scholastic_assessment_index,
      :create_exam,
      :update_batch,
      :edit_grouping,
      :show,
      :publish
      
    ]
    has_permission_on [:additional_exam_groups],
      :to =>[
      :index1,
      :show,
      :additional_exam_group_index
    ]
    has_permission_on [:additional_exam],
      :to =>[
      :save_additional_scores,
      :create_additional_exam,
      :update_batch,
      :show
    ]
    has_permission_on [:exam_groups],
      :to =>[
      :exam_group_index,
      :show,
      :index
    ]
  end

  role :view_results  do
    has_permission_on [:exams], :to => [:index,
     :generated_report,
     :grouping_assessment_type,
     :second_graph_for_generated_repport,
     :co_scholastic_area_assessment_report,
     :co_scholastic_activity_assessment_report,
     :generated_report5_pdf,
     :grouping_assessment_mode,
     :student_generated_report5,
     :new_grouping_assessment,
     :list_exam_types,
     :graph_for_generated_report,
     :edit_grouping,
     :co_scholastic_assessment_index,
     :view,
     :pie_chart,
     :generated_report_pdf,
     :subject_wise_report,
     :list_subjects,
     :generated_report2,
     :consolidated_exam_report,
     :consolidated_exam_report_pdf,
     :generated_report2_pdf,
     :grouped_exam_report,
     :grouped_update_batch,
     :final_report_type,
     :generated_report4,
     :generated_report4_pdf,
     :index_pdf,
     :exam_wise_report,
     :subject_wise_batch_report,
     :generated_report3,
     :graph_for_generated_report3,
     :graph_for_generated_report,
     :previous_years_marks_overview,
     :graph_for_previous_years_marks_overview,
     :connect_exam_report,
     :academic_report,
     :generated_report5,
     :normal_academic_report,
     :previous_years_marks_overviews,
     :view_exam_score_updation,
     :exam_wise_batch_report
    ]
    
   
    
    has_permission_on [:additional_exam], :to => [:additional_exam_report,
   :update_additional_exam_batch,
   :get_additional_exam,
   :view_additional_exam_group_report,
    :view_additional_exam_group_report]
  end

  role :admission do

    has_permission_on [:student],
      :to => [
     :admission_no,
     :email_validation,
     :student_wizard_first_step,
     :student_wizard_next_step,
     :student_wizard_previous_step,
     :update,
     :update_student,
     :change_batch,
     :my_profile,
     :update_guardian,
     :add_guardian,
     :previous_data,
     :admission4,
     :change_student_image,
     :update_immediate,
     :update_student_image,
     :image_crop,
     :update_crop_image,
     :get_guardian_id,
     :profile_pdf

    ]
    has_permission_on [:student_attendance],
  :to =>[
  :student,
  :month,
  :student
  ]
  end

  role :students_control do
    has_permission_on [:users],
    :to => [
      :change_password
    ]
    has_permission_on [:student_awards],
      :to => [
        :index,
        :show,
        :edit,
        :update,
        :destroy,
        :new,
        :create
      ]
    has_permission_on [:archived_student_awards],
      :to => [
        :index,
        :show,
        :edit,
        :update,
        :destroy,
        :new,
        :create
      ]
    has_permission_on [:student],
      :to => [
        :student_wizard_first_step,
        :student_wizard_next_step,
        :student_wizard_previous_step,
        :my_profile,
        :report_card_index,
        :report_card,
        :subject_list,
        :update_student,
        :change_student_image,
        :update_student_image,
        :photo,:student_search,
        :search_ajax,
        :profile_pdf,
        :my_pals,
        :update_guardian,
        :add_guardian,
        :change_batch,
        :student_advanced_search,
        :update_immediate,
        :student_wizard_previous_step,
        :generate_all_tc_pdf,
        :generate_tc_pdf,
        :previous_data,
        :image_crop,
        :update_crop_image,
        :admission_no,
        :email_validation,
        :del_guardian,
        :my_meetings,
        :student_meeting_details,
        :reports,
        :get_guardian_id,
        :exam_report,
        
    ]

    has_permission_on [:batch_transfers],
     :to => [
       :index,
       :show,
       :find_batch,
       :transfer,
       :graduation,
       :change_batch
     ]

    has_permission_on [:archived_student],
      :to => [
      :profile,
      :show,
      :award_report,
      :generated_report5,
      :grouped_academic_report,
      :reports,
      :archived_additional_exam,
      :archived_additional_exam_pdf,
      :guardians,
      :delete,
      :destroy,
      :generate_tc_pdf,
      :consolidated_exam_report,
      :consolidated_exam_report_pdf,
      :academic_report,
      :student_report,
      :generated_report,
      :generated_report_pdf,
      :generated_report3,
      :previous_years_marks_overview,
      :previous_years_marks_overview_pdf,
      :generated_report4,
      :generated_report4_pdf,
      :graph_for_generated_report,
      :graph_for_generated_report3,
      :graph_for_previous_years_marks_overview
    ]
  has_permission_on [:exams],
  :to =>[
    :generated_report
  # :generated_report_pdf,
  # :consolidated_exam_report,
  # :consolidated_exam_report_pdf,
  # :generated_report3,
  # :generated_report3_pdf,
  # :generated_report4,
  # :generated_report4_pdf,
  # :graph_for_generated_report,
  # :graph_for_generated_report3,
  # :previous_years_marks_overview,
  # :previous_years_marks_overview_pdf,
  # :academic_report,
  # :graph_for_previous_years_marks_overview
  ]
  has_permission_on [:student_attendance],
  :to =>[
  :student,
  :month
  ]
  end

  role :manage_news do
    has_permission_on [:news],
      :to => [
      :index,
      :add,
      :add_comment,
      :all,
      :delete,
      :delete_comment,
      :edit,
      :search_news_ajax,
      :view ]
  end

  # role :manage_timetable do
  #
  # has_permission_on [:class_timings], :to => [:index, :edit, :destroy, :show, :new, :create, :update]
  # has_permission_on [:weekday], :to => [:index, :week, :create]
  # has_permission_on [:timetable],
  # :to => [
  # :index,
  # :edit,
  # :delete_subject,
  # :select_class,
  # :tt_entry_update,
  # :tt_entry_noupdate,
  # :update_multiple_timetable_entries,
  # :update_timetable_view,
  # :generate,
  # :extra_class,
  # :extra_class_edit,
  # :list_employee_by_subject,
  # :save_extra_class,
  # :timetable,
  # :weekdays,
  # :view,
  # :select_class2,
  # :edit2,
  # :update_employees,
  # :update_multiple_timetable_entries2,
  # :delete_employee2,
  # :tt_entry_update2,
  # :tt_entry_noupdate2,
  # :timetable_pdf
  # ]
  # end

  role :today_timetable do
    has_permission_on [:timetable], :to => [:today_timetable,:today_timetable_substitution]
    
  end

  role :student_attendance_view do
  # has_permission_on [:attendance], :to => [:index,:report,:student_report]
    has_permission_on [:attendance_reports], :to => [:index,:attendance_report_batch, :subject, :mode, :show, :year, :report, :filter, :student_details,:report_pdf,:filter_report_pdf]
    has_permission_on [:student_attendance], :to => [:index, :student,:student_attendanceReports,:student_report]
  end

  role :student_attendance_register do
  # has_permission_on [:attendance], :to => [:index,:register,:register_attendance]
    has_permission_on [:attendances], :to => [:index,:subject_wise_attendance, :list_subject,:attendance_change_batch,:attendance_subject_wise_change_batch ,:show_subject_wise,:show, :new, :create,:create_subject_wise_attendance, :edit,:update, :destroy]
    has_permission_on [:student_attendance], :to => [:index, :student,:student_attendanceReports,:student_report]
    has_permission_on [:attendance_reports], :to => [:index,:attendance_report_batch, :subject, :mode, :show, :year, :report, :filter, :student_details,:report_pdf,:filter_report_pdf]
  end

  # role :add_new_batch do
  # has_permission_on [:configuration], :to => [:index]
  # has_permission_on [:courses], :to => [:index,:manage_course, :manage_batches,:find_course, :new, :create,:destroy,:edit,:update, :show, :update_batch]
  # has_permission_on [:batches], :to => [:index, :new, :create,:destroy,:edit,:update, :show, :init_data,:all_record]
  # has_permission_on [:subjects], :to => [:index, :new, :create,:destroy,:edit,:update, :show]
  # has_permission_on [:student], :to => [:electives, :assign_students, :unassign_students, :assign_all_students, :unassign_all_students, :my_profile, :guardians, :show_previous_details]
  # has_permission_on [:batch_transfers],
  # :to => [
  # :index,
  # :show,
  # :transfer,
  # :graduation,
  # :subject_transfer,
  # :get_previous_batch_subjects,
  # :update_batch,
  # :assign_previous_batch_subject,
  # :assign_all_previous_batch_subjects,
  # :new_subject,
  # :create_subject
  # ]
  # end
  #
  # role :subject_master do
  # has_permission_on [:configuration], :to => [:index]
  # has_permission_on [:student], :to => [:electives, :assign_students, :unassign_students, :assign_all_students, :unassign_all_students]
  # has_permission_on [:subjects],        :to => [:index,:new,:create,:destroy,:edit, :update,:show]
  # end
  #
  # role :academic_year do
  # has_permission_on [:configuration], :to => [:index]
  # has_permission_on [:academic_year],
  # :to => [
  # :index,
  # :add_course,
  # :migrate_classes,
  # :migrate_students,
  # :list_students,
  # :update_courses,
  # :upcoming_exams ]
  # end
  # role :sms_management do
  # has_permission_on [:configuration], :to => [:index]
  # has_permission_on [:sms], :to => [:index, :settings, :students, :batches, :employees, :departments,:all, :update_general_sms_settings, :list_students, :sms_all, :list_employees]
  # end
  role :event_management do
    has_permission_on [:event], :to =>
    [:index,
     :show,
     :confirm_event,
     :cancel_event,
     :select_course,
     :event_group,
     :course_event,
     :remove_batch,
     :select_employee_department,
     :department_event,
     :remove_department,
     :edit_event]
    has_permission_on [:calendars], :to => [:event_delete,:generate_calendar_pdf]
  end

  # role :general_settings do
  # has_permission_on [:configuration], :to => [:index,:settings,:permissions]
  # has_permission_on [:student], :to => [:add_additional_details, :delete_additional_details, :edit_additional_details, :categories ]
  # end

  role :school_settings do
    has_permission_on [:sessions], :to => [
      :dashboard_settings
      ]
    has_permission_on [:school_configurations], :to => [
      :settings
      ]
    has_permission_on [:class_timings], :to => [
      :index,
      :new,
      :batch,
      :time,
      :create,
      :edit,
      :update,
      :show,
      :del_class_time,
      :destroy,
      :find_class_timing
      ]
    has_permission_on [:rooms], :to => [
      :index,
      :new,
      :change_room_batch,
      :create,
      :edit,
      :update,
      :show,
      :find_room_skill,
      :destroy,
      :all_record,
      :room_skill_assign,
      :find_room_constraints,

      ]

    has_permission_on [:weekdays], :to => [
      :index,
      :new,
      :week,
      :create,
      :edit,
      :update,
      :show,
      :weekdays_modal,
      :destroy,
      :batch,

      ]
   has_permission_on [:employee_categories],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:employee_grades],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:employee_positions],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]

    has_permission_on [:employee_departments],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]

    has_permission_on [:bank_fields],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:additional_fields],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:student_additional_fields],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:student_categories],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]

    has_permission_on [:payroll_categories],
      :to => [
      :index,
      :update,
      :destroy,
      :new,
      :show,
      :all_record,
      :create,
      :edit
       ]
  end

  role :finance_control do
    has_permission_on [:finance],
      :to => [
      :index,
      :automatic_transactions,
      :categories,
      :donation,
      :donation_receipt,
      :expense_create,
      :expense_edit,
      :fee_collection,
      :fee_submission,
      :fees_received,
      :fee_structure,
      :fees_student_specific,
      :income_create,
      :income_edit,
      :transactions,
      :category_create,
      :category_delete,
      :category_edit,
      :category_update,
      :get_child_fee_element_form,
      :get_new_fee_element_form,
      :create_child_fee_element,
      :create_new_fee_element,
      :reset_fee_element,
      :fee_collection_create,
      :fee_collection_delete,
      :fee_collection_edit,
      :fee_collection_update,
      :fee_structure_create,
      :fee_structure_delete,
      :fee_structure_edit,
      :fee_structure_update,
      :transaction_trigger_create,
      :transaction_trigger_edit,
      :transaction_trigger_update,
      :transaction_trigger_delete,
      :fees_student_search,
      :search_logic,
      :fees_received,
      :fees_defaulters,
      :fees_submission_index,
      :fees_submission_batch,
      :update_fees_collection_dates,
      :load_fees_submission_batch,
      :update_ajax,
      :update_fees_collection_dates_defaulters,
      :fees_defaulters_students,
      :monthly_report,
      :update_monthly_report,
      :year_report,
      :update_year_report,
      :approve_monthly_payslip,
      :one_click_approve_submit,
      :one_click_approve,
      :employee_payslip_approve,
      :employee_payslip_reject,
      :employee_payslip_reject_form,
      :payslip_index,
      :view_monthly_payslip,
      :view_monthly_payslip_search,
      :update_monthly_payslip,:search_ajax,
      :view_payslip_dept,
      :update_dates,
      :update_monthly_payslip_all,
      :fee_structure_select_batch,
      :fees_student_dates,
      :fee_structure_batch,
      :fees_structure_student_search,
      :search_fees_structure,
      :fees_structure_dates,
      :fees_structure_result,
      :salary_department,
      :salary_employee,
      :employee_payslip_monthly_report,
      :direct_expenses,
      :direct_income,
      :donations_report,
      :fees_report,
      :batch_fees_report,
      :salary_department_year,
      :salary_employee_year,
      :direct_expenses_year,
      :direct_income_year,
      :donations_report_year,
      :fees_report_year,
      :asset_liability,
      :liability,
      :create_liability,
      :view_liability,
      :each_liability_view,
      :asset,
      :create_asset,
      :view_asset,
      :each_asset_view,
      :edit_liability,
      :update_liability,
      :delete_liability,
      :edit_asset,
      :update_asset,
      :delete_asset,
      :fee_collection_view,
      :fee_collection_dates_batch,
      :pay_fees_defaulters,
      :fee_structure_fee_collection_date,
      :fees_student_specific_dates,
      :update_fees_specific,
      :fees_index,
      #new_fee-----------
      :fees_create,
      :master_fees,
      :show_master_categories_list,
      :show_additional_fees_list,
      :fees_particulars,
      :additional_fees,
      :additional_fees_create_form,
      :additional_fees_create,
      :additional_fees_view,
      :add_particulars,
      :fee_collection_batch_update,
      :fees_submission_student,
      :fees_submission_save,
      :fee_particulars_update,
      :student_or_student_category,
      :fees_student_structure_search,
      :fees_student_structure_search_logic,
      :fee_structure_dates,
      :fees_structure_for_student,
      :master_fees_index,
      :master_category_create,
      :master_category_new,
      :fees_particulars_new,
      :fees_particulars_create,
      :add_particulars_new,
      :add_particulars_create,
      :fee_collection_new,
      :fee_collection_create,
      :categories_new,
      :categories_create,
      :fee_discounts,
      :fee_discount_new,
      :load_discount_create_form,
      :load_discount_batch,
      :load_batch_fee_category,
      :batch_wise_discount_create,
      :category_wise_fee_discount_create,
      :student_wise_fee_discount_create,
      :update_master_fee_category_list,
      :show_fee_discounts,
      :edit_fee_discount,
      :update_fee_discount,
      :delete_fee_discount,
      :collection_details_view,
      :master_category_edit,
      :master_category_update,
      :master_category_delete,
      :master_category_particulars,
      :master_category_particulars_edit,
      :master_category_particulars_update,
      :master_category_particulars_delete,
      :additional_fees_list,
      :additional_particulars,
      :add_particulars_edit,
      :add_particulars_update,
      :add_particulars_delete,
      :additional_fees_edit,
      :additional_fees_update,
      :additional_fees_delete,
      :month_date,
      :compare_report,
      :report_compare,
      :graph_for_compare_monthly_report,
      :update_fine_ajax,
      :student_fee_receipt_pdf,
      :update_student_fine_ajax,
      :transaction_pdf,
      :update_defaulters_fine_ajax,
      :fee_defaulters_pdf,
      :donation_receipt_pdf,
      :donors,
      :expense_list,
      :expense_list_update,
      :income_list,
      :income_list_update,
      :delete_transaction,
      :partial_payment,
      :donation_edit,
      :donation_delete,
      #pdf-------------
      :pdf_fee_structure,

      #graph-------------
      :graph_for_update_monthly_report,

      :view_employee_payslip
    ]
    has_permission_on [:xml],
      :to => [
      :create_xml,
      :index,
      :settings,
      :download
    ]
    has_permission_on [:payroll],
      :to => [
      :index,
      :add_category,
      :edit_category,
      :delete_category,
      :activate_category,
      :inactivate_category,
      :manage_payroll,
      :update_dependent_fields,
      :edit_payroll_details ]
  end

  role :hr_basics do
    has_permission_on [:employees],  :to => [
      :employee_no,
      :update,
      :archived_employee_profile,
      :employee_finance_setting,
      :select_reporting_manager,
      :update_skills,
      :search_all_skill,
      :demo,
      :update_positions,
      :payroll_department,
      :image_store,
      :employee_photo_crop,
      :search,
      :search_skill,
      :save,
      :admission3,
      :admission3_1,
      :photo_crop,
      :change_image,
      :wizard_first_step,
      :wizard_next_step,
      :wizard_previous_step,
      :profile,
      :edit_employee,
      :employee_search,
      :index,
      :change_reporting_manager,
      :reporting_manager_search,
      :add_payslip_category,
      :create_payslip_category,
      :remove_new_paylist_category,
      :create_monthly_payslip,
      :view_payslip,
      :update_monthly_payslip,
      :delete_payslip,
      :subject_assignment,
      :update_subjects,
      :select_department,
      :hr,
      :payslip,
      :select_department_employee,
      :rejected_payslip,
      :update_rejected_employee_list,
      :view_rejected_payslip,
      :edit_rejected_payslip,
      :update_rejected_payslip,
      :update_employee_select_list,
      :payslip_date_select,
      :one_click_payslip_generation,
      :payslip_revert_date_select,
      :one_click_payslip_revert,
      :leave_management,
      :all_employee_leave_applications,
      :update_employees_select,
      :leave_list,
      :reminder,
      :create_reminder,
      :mark_unread,
      :individual_payslip_pdf,
      :settings,
      :employee_management,
      :employee_attendance,
      :employees_list,
      :advanced_search,
      :remove,:change_to_former,
      :edit_privilege,
      :advanced_search_pdf,
      :profile_pdf,
      :department_payslip,
      :update_employee_payslip,
      :department_payslip_pdf,
      :view_rep_manager,
      :payslip_approve,
      :one_click_approve,
      :one_click_approve_submit,
      :employee_individual_payslip_pdf,
      :employee_leave_count_edit,
      :employee_leave_count_update,
      :view_employee_payslip,
      :employee_payslip,
      :employee_all_skills,
      :crop_employee_image

      ]
    # has_permission_on [:payroll] ,
      # :to => [
      # :add_category,
      # :edit_category,
      # :manage_payroll,
      # :activate_category,
      # :delete_category,
      # :inactivate_category ]
    has_permission_on [:employee_attendance],
      :to => [
      :add_leave_types,
      :ajax_add_leaves_types,
      :refresh_table,
      # :register,
      :leave_management,
      :edit_leave_types,
      :delete_leave_types,
      # :update_attendance_form,
      # :update_attendance_report,
      :individual_leave_application,
      :all_employee_new_leave_application,
      :all_employee_leave_application,
      # :update_employees_select,
      :leave_list,
      :leave_app,
      # :emp_attendance,
      # :employee_attendance_pdf,
      :manual_reset,
      :employee_leave_reset_all,
      :update_employee_leave_reset_all,
      :leave_reset_settings,
      :employee_leave_reset_by_department,
      :list_department_leave_reset,
      :update_department_leave_reset,
      :employee_leave_reset_by_employee,
      # :employee_search_ajax,
      # :employee_view_all,
      :employees_list,
      :employee_leave_details,
      :employee_wise_leave_reset,
      :leave_history,
      :update_leave_history
      ]
  end

  role :employee_attendance do
  # has_permission_on [:employees],
  # :to => [
  # :hr,
  # :employee_attendance,
  # :search,
  # :search_ajax,
  # :employee_leave_count_edit,
  # :employee_leave_count_update
  # ]
    has_permission_on [:employee_attendances],
      :to => [
      :index,
      :show,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :date_attandance_array
            ]
    has_permission_on [:employee_attendance],
      :to => [
      # :add_leave_types,
      # :register,
      :report,
      # :leave_management,
      # :edit_leave_types,
      # :delete_leave_types,
      # :update_attendance_form,
      # :update_attendance_report,
      # :individual_leave_application,
      # :all_employee_new_leave_application,
      # :all_employee_leave_application,
      # :update_employees_select,
      # :leave_list,
      # :leave_app,
      :emp_attendance,
      :update_attendance_report,
      :employee_attendance_pdf,
      # :manual_reset,
      # :employee_leave_reset_all,
      # :update_employee_leave_reset_all,
      # :leave_reset_settings,
      # :employee_leave_reset_by_department,
      # :list_department_leave_reset,
      # :update_department_leave_reset,
      # :employee_leave_reset_by_employee,
      # :employee_search_ajax,
      # :employee_view_all,
      # :employees_list,
      # :employee_leave_details,
      # :employee_wise_leave_reset,
      :leave_history,
      :update_leave_history
    ]
  end

  role :payslip_powers do
    has_permission_on [:employee],
      :to => [
      :hr,
      :payslip,
      :select_department_employee,
      :rejected_payslip,
      :update_rejected_employee_list,
      :view_rejected_payslip,
      :edit_rejected_payslip,
      :update_rejected_payslip,
      :update_employee_select_list,
      :payslip_date_select,
      :one_click_payslip_generation,
      :payslip_revert_date_select,
      :one_click_payslip_revert,
      :ceate_monthly_select_list,
      :add_payslip_category,
      :create_payslip_category,
      :remove_new_paylist_category,
      :delete_payslip,
      :view_payslip,
      :update_monthly_payslip,
      :invidual_payslip_pdf,
      :create_monthly_payslip,
      :payslip_approve,
      :one_click_approve,
      :one_click_approve_submit,
      :department_payslip,
      :update_employee_payslip,
      :department_payslip_pdf,
      :employee_individual_payslip_pdf,
      :view_employee_payslip
    ]
    has_permission_on [:payroll],
      :to => [
      :edit_payroll_details,
      :activate_category,
      :inactivate_category ]
  end

  role :employee_basic_search do
    has_permission_on [:employees],
      :to => [
      :profile,
      :employee_profile,
      :employee_search,
      :search,
      :archived_employee_profile
    ]
  end
  role :employee_profile do
    has_permission_on [:employees],
      :to => [
      :profile,
      :employee_profile,
      :employee_search,
      :search
    ]
  end
  role :employee_timetable_access do
    has_permission_on [:employee], :to => [:timetable,:timetable_pdf,:timetable_batch_selected_pdf]
  end

  role :timetable do
    has_permission_on [:timetable_interface], :to => [:courses,:skills,:rooms,:teachers]
  end

  # admin privileges
  role :admin do
     has_permission_on [:teacher_diaries],
    :to => [
      :create,
      :index,
      :update,
      :show,
      :destroy,
      :new,
      :edit,
      :view_diary,
      :view_pdf,
      :view_my_diary_details
    ]
    has_permission_on [:ptm_masters], :to => [:update]
    has_permission_on [:attendance_reports], :to => [:index, :subject, :mode, :show, :year, :report, :filter, :student_details,:report_pdf,:filter_report_pdf,:attendance_report_batch,:student]
    has_permission_on [:sessions], :to => [
      :dashboard_settings
      ]
    has_permission_on [:assignments], :to => [:index,:show, :new, :create, :edit,:update, :destroy,:student_assigned,:view_student_assigned,:uploadAssignment,:download_attachment,:view,:show_batch]
    has_permission_on [:users],  :to => [
      :edit_privilege,
      :download_help,
      :upload_excelsheet,
      :change_password,
      :example_report,
      :report,
      :find,
      :reset,
      :privileges_of_any_user,
      :find_employee,
      :user_mobile_no,
      :reset_password_of_any_user,
      :search_user_ajax,
      :set_new_password,
      :upload_excel,
      :reset_password]
    has_permission_on [:employee_departments],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    
    has_permission_on [:employee_constraints],
      :to => [:index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show]
    has_permission_on [:skills],
      :to => [
      :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :create_elective_skill,
      :assigned,
      :remove_batch
    ]
    has_permission_on [:ptm_admin],  :to => [
     :index,
      :update,
      :show,
      :ptm,
      :edit
      ]
    has_permission_on [:student_awards],  :to => [
      :create,
      :update,
      :destroy,
      :edit,
      :index,
      :new
    ]
    
     has_permission_on [:sub_skills],
      :to => [
        :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :subskill_find,
      :subject_subskill
     
      ]
    
    
    
    has_permission_on [:sms], :to => [
      :settings,
      :update_application_sms_settings,
      :update_general_sms_settings,
      :students,
      :index,
      :find,
      :template_find,
      :sms_emp_send,
      :std_send,
      :template_find

    ]
    has_permission_on [:timetable],
    :to => [
    :admin_wise_employee_page,
    :find,:employee_full_view,
    :today_timetable_substitution
    ]
    # has_permission_on [:sms],
    # :to => [
    #
    # ]
    has_permission_on [:courses],
      :to => [
      :all_record
    ]

    has_permission_on [:sms_templates],
      :to => [
      :all_record,
      :index,:create,:update,:destroy
    ]

    has_permission_on [:expenses],  :to => [
      :all_record,
      :index,
      :create,
      :edit,
      :show,
      :new,
      :update,
      :destroy
    ]

    has_permission_on [:finance_transaction_categories],  :to => [
      :all_record,
      :index,
      :create,
      :edit,
      :show,
      :new,
      :update,
      :destroy
    ]

    has_permission_on [:rooms],  :to => [
      :all_record,
      :change_room_batch,
      :index,
      :create,
      :edit,
      :show,
      :new,
      :update,
      :destroy,
      :find_room_constraints,
      :find_room_skill,
      :room_skill_assign
    ]

    has_permission_on [:financial_assets],  :to => [
      :all_record,
      :index,
      :create,
      :edit,
      :show,
      :new,
      :update,
      :destroy
    ]

    has_permission_on [:liabilities],  :to => [
      :all_record,
      :index,
      :create,
      :edit,
      :show,
      :new,
      :update,
      :destroy
    ]

    has_permission_on [:finance_donations],  :to => [
      :all_record,
      :index,
      :create,
      :edit,
      :show,
      :new,
      :update,
      :destroy
    ]

    has_permission_on [:employee_categories],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:employee_grades],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:employee_positions],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:bank_fields],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:additional_fields],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:student_additional_fields],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:student_categories],  :to => [
      :all_record,
      :index,
      :create,
      :update,
      :destroy
    ]
    has_permission_on [:school_configurations],  :to => [
      :edit,
      :index,
      :create,
      :update,
      :settings
    ]

    has_permission_on [:employees],  :to => [
      :employee_no,
      :update,
      :crop_employee_image,
      :employee_finance_setting,
      :employee_mail,
      :advance_search_pdf,
      :update_skills,
      :search_all_skill,
      :demo,
      :update_positions,
      :payroll_department,
      :image_store,
      :employee_photo_crop,
      :search,
      :search_skill,
      :save,
      :admission3,
      :admission3_1,
      :photo_crop,
      :change_image,
      :wizard_first_step,
      :wizard_next_step,
      :wizard_previous_step,
      :profile,
      :edit_employee,
      :employee_search,
      :employee_profile,
      :index,
      :archived_employee_profile,
      :change_reporting_manager,
      :reporting_manager_search,
      :update_reporting_manager_name,
      :select_reporting_manager,
      :profile_bank_details,
      :profile_payroll_details,
      :view_all,
      :show,:my_batches,:search_batch_student,
      :add_payslip_category,
      :create_payslip_category,
      :remove_new_paylist_category,
      :create_monthly_payslip,
      :view_payslip,
      :update_monthly_payslip,
      :delete_payslip,
      :view_attendance,
      :subject_assignment,
      :update_subjects,
      :select_department,
      :update_employees,
      :assign_employee,
      :remove_employee,
      :hr,
      :payslip,
      :select_department_employee,
      :rejected_payslip,
      :update_rejected_employee_list,
      :view_rejected_payslip,
      :edit_rejected_payslip,
      :update_rejected_payslip,
      :update_employee_select_list,
      :payslip_date_select,
      :one_click_payslip_generation,
      :payslip_revert_date_select,
      :one_click_payslip_revert,
      :leave_management,
      :all_employee_leave_applications,
      :update_employees_select,
      :leave_list,
      :reminder,
      :create_reminder,
      :to_employees,
      :update_recipient_list,
      :sent_reminder,
      :adminsending,
      :view_sent_reminder,
      :delete_reminder,
      :view_reminder,
      :mark_unread,
      :pull_reminder_form,
      :send_reminder,
      :individual_payslip_pdf,
      :settings,
      :employee_management,
      :employee_attendance,
      :employees_list,
      :add_bank_details,
      :edit_bank_details,
      :delete_bank_details,
      :add_additional_details,
      :edit_additional_details,
      :delete_additional_details,
      :profile_additional_details,
      :advanced_search,
      :list_doj_year,
      :doj_equal_to_update,
      :doj_less_than_update,
      :doj_greater_than_update,
      :list_dob_year,:dob_equal_to_update,:dob_less_than_update,:dob_greater_than_update,
      :remove,:change_to_former,:delete,:remove_subordinate_employee,
      :edit_privilege,
      :advanced_search_pdf,
      :profile_pdf,
      :department_payslip,
      :update_employee_payslip,
      :department_payslip_pdf,
      :view_rep_manager,
      :payslip_approve,
      :one_click_approve,
      :one_click_approve_submit,
      :employee_individual_payslip_pdf,
      :employee_leave_count_edit,
      :employee_leave_count_update,
      :view_employee_payslip,
      :employee_payslip,
      :employee_all_skills,
      :call_in_sheet,
      :archived_employee,
      :archived_employee_list,:upload,:show_file_directory,:attachments

      ]
    has_permission_on [:weekdays], :to => [:index, :week, :create,:weekdays_modal,:batch]
    has_permission_on [:event],
      :to => [
      :index,
      :event_group,
      :select_course,
      :course_event,
      :remove_batch,
      :select_employee_department,
      :department_event,
      :remove_department,
      :show,
      :confirm_event,
      :cancel_event,
      :edit_event
    ]
    has_permission_on [:academic_year],
      :to => [
      :index,
      :add_course,
      :migrate_classes,
      :migrate_students,
      :list_students,
      :update_courses,
      :upcoming_exams ]
    has_permission_on [:attendances],
      :to => [
      :index,
      :show,
      :new,
      :create,
      :subject_wise_attendance,
      :show_subject_wise,
      :attendance_subject_wise_change_batch,
      :create_subject_wise_attendance,
      :edit,
      :destroy,
      :attendance_change_batch,
      :list_subject,
      :update,
      :multiple_attendance,
      :multiple_attendance_save,
      :multiple_attendance_save_batch_wise
    ]
    has_permission_on [:sms],  :to => [:index, :settings, :update_general_sms_settings, :students, :list_students, :batches, :sms_all, :employees, :list_employees, :departments, :all]
    has_permission_on [:sms_settings],  :to => [:index, :update_general_sms_settings,:sms_file_create]
    has_permission_on [:class_timings],  :to => [:index, :edit, :destroy, :show, :new, :create, :update,:batch,:find_class_timing,:time,:del_class_time]
    has_permission_on [:attendance_reports], :to => [
      :index,
      :subject,
      :mode,
      :show,
      :year, :report, :filter, :student_details,:report_pdf,:filter_report_pdf,:attendance_report_batch]
    has_permission_on [:student_attendance], :to => [:index,
       :student, :month,:admission_no,:choose_layout,:admission_no,:email_validation,:student_attendanceReports,
       :student_wizard_first_step,:student_wizard_next_step,:student_wizard_previous_step,
        :month,:student_report
      ]
    has_permission_on [:configuration], :to => [:index,:settings,:permissions, :add_weekly_holidays, :delete]
    has_permission_on [:subjects], :to => [:index, :new, :create,:destroy,:edit,:update, :show]
    has_permission_on [:courses],
      :to => [
      :index,
      :manage_course,
      :manage_batches,
      :new,
      :create,
      :update_batch,
      :edit,
      :update,
      :destroy,
      :show,
      :find_course,
      :viewall,
      :view_skill,
      :manage_course,
      :find_course,
      :all_record,
      :elective_skill
    ]
    has_permission_on [:batches],
      :to => [
      :index,
      :all_record,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :init_data,
      :assign_tutor,
      :update_employees,
      :assign_employee,
      :remove_employee,
      :all_record,
      :room,
      :teacher,
      :select_batch,
      :update_batch_subject,
      :assign_student_to_sub,
      :assign_home_teacher_and_room,
      :subject_students,
      :assign_student_to_sub1,
      :remove_student_to_sub1,
      :show1,
      :subject_batch_student,
      :assign_skill_to_batch,
      :find_batch_subjects,
      :create_elective_group,
      :batch_history,
      :history_select_course,
      :history_select_batch,:batch_students_pdf

    ]
    has_permission_on [:elective_skills],
      :to => [
      :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show

    ]
    has_permission_on [:skills],
      :to => [
      :index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :create_elective_skill,
      :assigned,
      :remove_batch
    ]
    has_permission_on [:batch_transfers],
      :to => [
      :index,
      :show,
      :transfer,
      :graduation,
      :subject_transfer,
      :get_previous_batch_subjects,
      :update_batch,
      :assign_previous_batch_subject,
      :assign_all_previous_batch_subjects,
      :new_subject,
      :create_subject,
      :change_batch
    ]
    has_permission_on [:employee_attendance],
      :to => [
      :index,
      :ajax_add_leaves_types,
      :refresh_table,
      :add_leave_types,
      :add_leaves_types,
      :edit_leave_types,
      :delete_leave_types,
      :register,
      :update_attendance_form,
      :report,
      :update_attendance_report,
      :emp_attendance,
      :leaves,
      :leave_application,
      :leave_app,
      :approve_remarks,
      :deny_remarks,
      :approve_leave,
      :deny_leave,
      :cancel,
      :new_leave_applications,
      :all_employee_new_leave_applications,
      :all_leave_applications,
      :individual_leave_applications,
      :own_leave_application,
      :cancel_application,
      :employee_attendance_pdf,
      :update_all_application_view,
      :manual_reset,
      :employee_leave_reset_all,
      :leave_reset_settings,
      :update_employee_leave_reset_all,
      :employee_leave_reset_by_department,
      :list_department_leave_reset,
      :update_department_leave_reset,
      :employee_leave_reset_by_employee,
      :employee_search_ajax,
      :employee_view_all,
      :employees_list,
      :employee_leave_details,
      :employee_wise_leave_reset,
      :leave_history,
      :update_leave_history
    ]
    has_permission_on [:employee_attendances],
      :to => [
      :index,
      :show,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :date_attandance_array
    ]
    has_permission_on [:grading_levels],
      :to => [
      :index,
      :update_grade,
      :grade_update_batch,
      :create_grade,
      :show,
      :create_grading_level,
      :edit,
      :update,
      :new,
      :create,
      :destroy

    ]
    has_permission_on [:exams],
      :to => [
      :edit,
      :edit_grouping,
      :xls_demo,
      :co_scholastic_assessment_index,
      :secondry_standard_report,
      :student_generated_report5,
      :second_graph_for_generated_repport,
      :co_scholastic_area_assessment_report,
      :co_scholastic_activity_assessment_report,
      :generated_report5_pdf,
      :grouping_assessment_type,
      :new_grouping_assessment,
      :grouping_assessment_mode,
      :new_grouping_assessment,
      :destroy_grouped_exam,
      :generated_student_report4,
      :generated_student_report4_pdf,
      :delete_view_grouping,
      :generated_report5,
      :view_exam_score_updation,
      :previous_years_marks_overviews,
      :normal_academic_report,
      :view_grouping,
      :time_validation,
      :connect_exam_report,
      :exam_wise_batch_report,
      :subject_wise_batch_report,
      :index_pdf,
      :grouped_update_batch,
      :pie_chart,
      :view,
      :save_scores,
      :destroy_exam,
      :update_exam,
      :show,
      :index,
      :update_exam_form,
      :publish,
      :grouping,
      :exam_wise_report,
      :list_exam_types,
      :generated_report,
      :generated_report_pdf,
      :consolidated_exam_report,
      :consolidated_exam_report_pdf,
      :subject_wise_report,
      :list_subjects,
      :generated_report2,
      :generated_report2_pdf,
      :generated_report3,
      :final_report_type,
      :generated_report4,
      :generated_report4_pdf,
      :previous_years_marks_overview,
      :previous_years_marks_overview_pdf,
      :academic_report,
      :create_exam,
      :update_batch_ex_result,
      :update_batch,
      :graph_for_generated_report,
      :graph_for_generated_report3,
      :graph_for_previous_years_marks_overview,
      :grouped_exam_report
    ]
    has_permission_on [:exam_groups],
      :to => [
      :delete_exam_group,
      :scholastic_area_assessment,
      :changeExam,
      :index,
      :exam_group_index,
      :new,
      :create,
      :edit,
      :update,
      :destroy,
      :show,
      :initial_queries,
      :set_exam_minimum_marks,
      :set_exam_maximum_marks,
      :set_exam_weightage,
      :set_exam_group_name
    ]

    has_permission_on [:additional_exam],
      :to => [
      :index,
      :show,
      :additional_exam_report,
      :save_additional_scores,
      :edit,
      :view_additional_exam_group_report,
      :update_additional_exam,
      :update_additional_exam_batch,
      :get_additional_exam,
      :destroy_additional_exam,
      :create_index,
      :update_exam_form,
      :publish,
      :create_additional_exam,
      :update_batch,
      :additional_exam_report,
      :update_additional_exam_batch,
      :get_additional_exam
    ]

    has_permission_on [:additional_exam_groups],
      :to => [
      :index,
      :scholastic_area_assessment,
      :create_index,
      :get_max_min_marks,
      :new,
      :create,
      :delete_additional_exam_group,
      :additional_exam_group_index,
      :edit,
      :update,
      :destroy,
      :show,
      :initial_queries,
      :set_additional_exam_minimum_marks,
      :set_additional_exam_maximum_marks,
      :set_additional_exam_weightage,
      :set_additional_exam_group_name
    ]
    # has_permission_on [:additional_exams],
    # :to => [
    # :index,
    # :generated_report,
    # :show,
    # :new,
    # :create,
    # :edit,
    # :update,
    # :destroy,
    # :save_additional_scores,
    # :query_data
    # ]

    has_permission_on [:examination_result],
      :to => [
      :add,
      :add_results,
      :save,
      :update_subjects,
      :update_one_subject,
      :update_exams,
      :update_one_sub_exams,
      :load_results,
      :load_one_sub_result,
      :load_all_sub_result,
      :update_examtypes,
      :one_sub_pdf,
      :all_sub_pdf,
      :view_all_subs,
      :view_one_sub,
      :academic_report_course,
      :all_academic_report,
      :list_students_by_course,
      :exam_wise_report,
      :load_examtypes,
      :load_course_all_student,
      :exam_report
    ]
    has_permission_on [:finance],
      :to => [
      :index,
      :automatic_transactions,
      :categories,
      :donation,
      :donation_receipt,
      :expense_create,
      :expense_edit,
      :fee_collection,
      :fee_submission,
      :fees_received,
      :fee_structure,
      :fees_student_specific,
      :income_create,
      :income_edit,
      :transactions,
      :category_create,
      :category_delete,
      :category_edit,
      :category_update,
      :get_child_fee_element_form,
      :get_new_fee_element_form,
      :create_child_fee_element,
      :create_new_fee_element,
      :reset_fee_element,
      :fee_collection_create,
      :fee_collection_delete,
      :fee_collection_edit,
      :fee_collection_update,
      :fee_structure_create,
      :fee_structure_delete,
      :fee_structure_edit,
      :fee_structure_update,
      :transaction_trigger_create,
      :transaction_trigger_edit,
      :transaction_trigger_update,
      :transaction_trigger_delete,
      :fees_student_search,
      :search_logic,
      :fees_received,
      :fees_defaulters,
      :fees_submission_index,
      :fees_submission_batch,
      :update_fees_collection_dates,
      :load_fees_submission_batch,
      :update_ajax,
      :update_fees_collection_dates_defaulters,
      :fees_defaulters_students,
      :monthly_report,
      :update_monthly_report,
      :year_report,
      :update_year_report,
      :approve_monthly_payslip,
      :one_click_approve_submit,
      :one_click_approve,
      :employee_payslip_approve,
      :employee_payslip_reject,
      :employee_payslip_reject_form,
      :payslip_index,
      :view_monthly_payslip,
      :view_monthly_payslip_search,
      :update_monthly_payslip,:search_ajax,
      :view_payslip_dept,
      :update_dates,
      :update_monthly_payslip_all,
      :fee_structure_select_batch,
      :fees_student_dates,
      :fee_structure_batch,
      :fees_structure_student_search,
      :search_fees_structure,
      :fees_structure_dates,
      :fees_structure_result,
      :salary_department,
      :salary_employee,
      :employee_payslip_monthly_report,
      :direct_expenses,
      :direct_income,
      :donations_report,
      :fees_report,
      :batch_fees_report,
      :salary_department_year,
      :salary_employee_year,
      :direct_expenses_year,
      :direct_income_year,
      :donations_report_year,
      :fees_report_year,
      :asset_liability,
      :liability,
      :create_liability,
      :view_liability,
      :each_liability_view,
      :asset,
      :create_asset,
      :view_asset,
      :each_asset_view,
      :edit_liability,
      :update_liability,
      :delete_liability,
      :edit_asset,
      :update_asset,
      :delete_asset,
      :fee_collection_view,
      :fee_collection_dates_batch,
      :pay_fees_defaulters,
      :fee_structure_fee_collection_date,
      :fees_student_specific_dates,
      :update_fees_specific,
      :fees_index,
      #new_fee-----------
      :fees_create,
      :master_fees,
      :show_master_categories_list,
      :show_additional_fees_list,
      :fees_particulars,
      :validate_student_batch,
      :additional_fees,
      :additional_fees_create_form,
      :additional_fees_create,
      :additional_fees_view,
      :add_particulars,
      :fee_collection_batch_update,
      :fees_submission_student,
      :fees_submission_save,
      :fee_particulars_update,
      :student_or_student_category,
      :fees_student_structure_search,
      :fees_student_structure_search_logic,
      :fee_structure_dates,
      :fees_structure_for_student,
      :master_fees_index,
      :master_category_create,
      :master_category_new,
      :fees_particulars_new,
      :fees_particulars_create,
      :add_particulars_new,
      :add_particulars_create,
      :fee_discounts,
      :fee_discount_new,
      :load_discount_create_form,
      :load_discount_batch,
      :load_batch_fee_category,
      :batch_wise_discount_create,
      :category_wise_fee_discount_create,
      :student_wise_fee_discount_create,
      :update_master_fee_category_list,
      :show_fee_discounts,
      :edit_fee_discount,
      :update_fee_discount,
      :delete_fee_discount,
      :fee_collection_new,
      :collection_details_view,
      :fee_collection_create,
      :categories_new,
      :categories_create,
      :master_category_edit,
      :master_category_update,
      :master_category_delete,
      :master_category_particulars,
      :master_category_particulars_edit,
      :master_category_particulars_update,
      :master_category_particulars_delete,
      :additional_fees_list,
      :additional_particulars,
      :add_particulars_edit,
      :add_particulars_update,
      :add_particulars_delete,
      :additional_fees_edit,
      :additional_fees_update,
      :additional_fees_delete,
      :month_date,
      :compare_report,
      :report_compare,
      :graph_for_compare_monthly_report,
      :update_fine_ajax,
      :student_fee_receipt_pdf,
      :update_student_fine_ajax,
      :transaction_pdf,
      :update_defaulters_fine_ajax,
      :fee_defaulters_pdf,
      :donation_receipt_pdf,
      :donors,
      :expense_list,
      :expense_list_update,
      :income_list,
      :income_list_update,
      :delete_transaction,
      :partial_payment,
      :donation_edit,
      :donation_delete,
      #pdf-------------
      :pdf_fee_structure,

      #graph-------------
      :graph_for_update_monthly_report,

      :view_employee_payslip

    ]

    has_permission_on [:xml], :to =>
      [
      :create_xml,
      :index,
      :settings,
      :download
    ]

    has_permission_on [:holiday], :to => [:index,:edit,:delete]
    has_permission_on [:news],
      :to => [
      :index,
      :add,
      :add_comment,
      :all,
      :delete,
      :delete_comment,
      :edit,
      :search_news_ajax,
      :view ]
    has_permission_on [:payroll],
      :to => [
      :index,
      :add_category,
      :edit_category,
      :delete_category,
      :activate_category,
      :inactivate_category,
      :manage_payroll,
      :update_dependent_fields,
      :edit_payroll_details ]
    has_permission_on [:student],
      :to => [
      :del_guardian,
      :system_reports,
      :student_pdf,
      :print_student_pdf_details,
      :print_id_card,
      :subject_list,
      :report_card_index,
      :report_card,
      :update_batch,
      :particular_student,
      :report_index,
      :view_report,
      :view_report_index,
      :employee_pdf_report,
      :report_center,
      :employee_report_center,
      :employee_pdf_report,
      :get_all_gender_report,
      :get_gender_batch_report,
      :get_all_religion_report,
      :get_religion_course_report,
      :get_religion_batch_report,
      :get_all_category_report,
      :get_category_course_report,
      :get_category_batch_report,
      :pdf_report,
      :change_student_course_batch,
      :change_student_category_batch,
      :student_wizard_first_step,
      :student_wizard_next_step,
      :assign_roll_no,
      :change_roll_number,
      :student_wizard_previous_step,
      :change_student_image,
      :get_gender_course_report,
      :change_student_batch,
      :update,
      :get_guardian_id,
      :admission_no,
      :email_validation,
      :update_crop_image,
      :update_immediate,
      :my_profile,
      :update_student_image,
      :update_student,
      :image_crop,
      :student_search,
      :change_batch,
      :student_advanced_search,
      :update_guardian,
      :academic_pdf,
      :profile,
      :admission1,
      :admission2,
      :admission3,
      :add_guardian,
      :edit,
      :edit_guardian,
      :guardians,
      :del_guardian,
      :list_students_by_course,
      :show,
      :view_all,
      :index,
      :academic_report,
      :academic_report_all,
      :change_to_former,
      :delete,
      :destroy,
      :email,
      :exam_report,
      :update_student_result_for_examtype,
      :previous_years_marks_overview,
      :previous_years_marks_overview_pdf,
      :remove,
      :reports,
      :search_ajax,
      :student_annual_overview,
      :subject_wise_report,
      :graph_for_previous_years_marks_overview,
      :graph_for_academic_report,
      :graph_for_annual_academic_report,
      :graph_for_student_annual_overview,
      :graph_for_subject_wise_report_for_one_subject,
      :graph_for_exam_report,
      :category_update,
      :category_edit,
      :category_delete,
      :categories,
      :add_additional_details,
      :edit_additional_details,
      :delete_additional_details,
      :admission4,
      :advanced_search,
      :list_batches,
      :electives,
      :assign_students,
      :unassign_students,
      :list_doa_year,
      :doa_equal_to_update,
      :doa_less_than_update,
      :doa_greater_than_update,
      :list_dob_year,:dob_equal_to_update,:dob_less_than_update,:dob_greater_than_update,
      :advanced_search_pdf,
      :previous_data,
      :previous_subject,
      :previous_data_edit,
      :save_previous_subject,
      :delete_previous_subject,
      :profile_pdf,
      :generate_tc_pdf,
      :generate_all_tc_pdf,
      :assign_all_students,
      :unassign_all_students,
      :edit_admission4,
      :admission3_1,
      :show_previous_details,
      :fees,
      :fee_details,
      :attachments,
      :upload,
      :show_file_directory
      
    ]
    has_permission_on [:archived_student],
      :to => [
      :profile,
      :generated_report5,
      :grouped_academic_report,
      :reports,
      :guardians,
      :delete,
      :destroy,
      :generate_tc_pdf,
      :consolidated_exam_report,
      :consolidated_exam_report_pdf,
      :academic_report,
      :student_report,
      :generated_report,
      :generated_report_pdf,
      :generated_report3,
      :previous_years_marks_overview,
      :previous_years_marks_overview_pdf,
      :generated_report4,
      :generated_report4_pdf,
      :graph_for_generated_report,
      :graph_for_generated_report3,
      :graph_for_previous_years_marks_overview,
      :award_report
    ]
    has_permission_on [:subject],
      :to => [
      :index,
      :create,
      :delete,
      :edit,
      :list_subjects ]
    has_permission_on [:incomes],
      :to => [
      :index,
      :all_record,
      :create
       ]
    has_permission_on [:payroll_categories],
      :to => [
      :index,
      :update,
      :destroy,
      :new,
      :show,
      :all_record,
      :create,
      :edit
       ]
    has_permission_on [:timetable],
      :to => [
      :index,
      :edit,
      :delete_subject,
      :select_class,
      :tt_entry_update,
      :tt_entry_noupdate,
      :update_multiple_timetable_entries,
      :view,
      :update_timetable_view,
      :tt_entry_noupdate2,
      :select_class2,
      :edit2,
      :update_employees,
      :update_multiple_timetable_entries2,
      :delete_employee2,
      :tt_entry_update2,
      :generate,
      :weekdays,
      :extra_class,
      :extra_class_edit,
      :list_employee_by_subject,
      :save_extra_class,
      :timetable,
      :timetable_pdf,
      :timetable_batch_selected_pdf,
      :find,
      :today_timetable,
      :timetable_step1,
      :assign_substitute,
      :free_teacher,:timetable_substitution,:add_entry,:remove_entry,:batch,:full_data,:timetable_setting,:set_timetable,:emp_max_find,
      :create,:find_max_class,:show,:generate_subject_wise,:generate,:list_employee_by_subject,:student_view,:teacher_change,:employee_full_view,
      :update_timetable_view,:employee_info,
      :today_timetable_substitution,
      :timetable_substitude_reassign,:reassign_substitute,:employeetimetable_pdf,:substitution_report_center,:timetable_substitution_monthly_report,:timetable_substitution_daily_report,:monthlytimetable_pdf,:dailytimetable_pdf
      
    ]
    has_permission_on [:weekdays],
      :to => [
      :index,
      :new
    ]
    has_permission_on [:calendars], :to => [:event_delete,:generate_calendar_pdf]

  end

  # student- privileges
  role :student do
    has_permission_on [:users],
    :to => [
      :change_password,
      :user_mobile_no
    ]
    # has_permission_on [:student_attendance], :to => [:index,
    # :student, :month,:admission_no,:choose_layout,:admission_no,:email_validation,:student_attendanceReports,
    # :student_wizard_first_step,:student_wizard_next_step,:student_wizard_previous_step,
    # :month,:student_report
    # ]
    has_permission_on [:attendance_reports], :to => [:index, :subject, :mode, :show, :year, :report, :filter, :student_details,:report_pdf,:filter_report_pdf,:attendance_report_batch,:student]
    has_permission_on [:course], :to => [:view]
    has_permission_on [:exams],
      :to => [
      :generated_report5,
      :grouping_assessment_type,
      :grouping_assessment_mode,
      :student_generated_report5,
      :second_graph_for_generated_repport,
      :co_scholastic_area_assessment_report,
      :co_scholastic_activity_assessment_report,
      :generated_report5_pdf,
      :new_grouping_assessment,
      :new_grouping_assessment,
      :generated_student_report4,
      :generated_student_report4_pdf,
      :view_exam_score_updation,
      :previous_years_marks_overviews,
      :normal_academic_report,
      :view_grouping,
      :connect_exam_report,
      :exam_wise_batch_report,
      :subject_wise_batch_report,
      :exam_wise_report,
      :generated_report,
      :generated_report_pdf,
      :consolidated_exam_report,
      :consolidated_exam_report_pdf,
      :subject_wise_report,
      :generated_report2,
      :generated_report2_pdf,
      :generated_report3,
      :final_report_type,
      :generated_report4,
      :generated_report4_pdf,
      :previous_years_marks_overview,
      :previous_years_marks_overview_pdf,
      :academic_report,
      :graph_for_generated_report,
      :graph_for_generated_report3,
      :graph_for_previous_years_marks_overview,
      :grouped_exam_report
    ]
    has_permission_on [:assignments], :to => [:show,:download_attachment,:view,:edit]
    has_permission_on [:examination_result],
      :to => [
      :load_results,
      :load_one_sub_result,
      :one_sub_pdf,
      :view_one_sub ]
    has_permission_on [:student],
      :to => [
      :exam_report,
      :profile_pdf,
      :my_meetings,
      :reports,
      :student_meeting_details,
      :show,
      :academic_pdf,
      :my_profile,
      :subject_list,
      :my_pals,
      :guardians,
      :list_students_by_course,
      :academic_report,
      :previous_years_marks_overview,
      :previous_years_marks_overview_pdf,
      :reports,
      :student_annual_overview,
      :subject_wise_report,
      :graph_for_previous_years_marks_overview,
      :graph_for_student_annual_overview,
      :graph_for_subject_wise_report_for_one_subject,
      :graph_for_exam_report,
      :graph_for_academic_report,
      :show_previous_details,
      :fees,
      :fee_details,
      :change_student_image,
      :update_student_image,
      :image_crop,
      :update_crop_image,
      :add_guardian,
      :update_guardian,
      :del_guardian]
      
    has_permission_on [:news],
      :to => [
      :index,
      :all,
      :search_news_ajax,
      :view,
      :add_comment]

    has_permission_on [:subject], :to => [:index,:list_subjects]
    has_permission_on [:timetable], :to => [:student_view,:update_timetable_view,:timetable_pdf,:timetable_batch_selected_pdf]
    has_permission_on [:attendance], :to => [:student_report]
    has_permission_on [:student_attendance], :to => [:index, :student, :month,:student_attendanceReports]
    has_permission_on [:finance], :to => [:student_fees_structure]
    has_permission_on [:archived_student], :to => [:award_report]
    has_permission_on [:ptm_details], :to => [:update_parent_feedback]
  end

  # employee -privileges
  role :employee do
    has_permission_on [:teacher_diaries],
    :to => [
      :create,
      :index,
      :update,
      :show,
      :destroy,
      :new,
      :edit,
      :view_my_diary_details,
      :view_pdf
    ]
    has_permission_on [:users],
    :to => [
      :change_password,
      :user_mobile_no,
      :admission3,
      :admission3_1
    ]
     has_permission_on [:employee_attendance],
    :to => [
      :emp_attendance,
      :leave_history,
      :update_leave_history,
      :employee_attendance_pdf
    ]
    # has_permission_on [:exams],
    # :to => [
    # :edit,
    # :generated_report5,
    # :generated_student_report4,
    # :view_exam_score_updation,
    # :previous_years_marks_overviews,
    # :normal_academic_report,
    # :view_grouping,
    # :time_validation,
    # :connect_exam_report,
    # :exam_wise_batch_report,
    # :subject_wise_batch_report,
    # :index_pdf,
    # :grouped_update_batch,
    # :pie_chart,
    # :view,
    # :save_scores,
    # :destroy_exam,
    # :update_exam,
    # :show,
    # :index,
    # :update_exam_form,
    # :publish,
    # :grouping,
    # :exam_wise_report,
    # :list_exam_types,
    # :generated_report,
    # :generated_report_pdf,
    # :consolidated_exam_report,
    # :consolidated_exam_report_pdf,
    # :subject_wise_report,
    # :list_subjects,
    # :generated_report2,
    # :generated_report2_pdf,
    # :generated_report3,
    # :final_report_type,
    # :generated_report4,
    # :generated_report4_pdf,
    # :previous_years_marks_overview,
    # :previous_years_marks_overview_pdf,
    # :academic_report,
    # :create_exam,
    # :update_batch_ex_result,
    # :update_batch,
    # :graph_for_generated_report,
    # :graph_for_generated_report3,
    # :graph_for_previous_years_marks_overview,
    # :grouped_exam_report
    # ]
    # has_permission_on [:ptm_masters],  :to => [
    # :create,
    # :update,
    # :destroy,
    # :edit,
    # :index,
    # :new,
    # :ptm_student
    # ]
    # has_permission_on [:attendances],
    # :to => [
    # :index,
    # :show,
    # :new,
    # :create,
    # :subject_wise_attendance,
    # :show_subject_wise,
    # :attendance_subject_wise_change_batch,
    # :create_subject_wise_attendance,
    # :edit,
    # :destroy,
    # :attendance_change_batch,
    # :list_subject,
    # :update
    # ]
    # has_permission_on [:employees],
    # :to => [
    # :image_store,
    # :profile,
    # :employee_profile,
    # :employee_search,
    # :admission3,
    # # :my_batches,
    # :search_batch_student,
    # :employee_payslip,
    # :employee_all_skills,
    #
    # ]

    has_permission_on [:reminder],
      :to => [
      :reminder,
      :create_reminder,
      :select_employee_department,
      :select_student_course,
      :to_employees,
      :to_students,
      :update_recipient_list,
      :sent_reminder,
      :view_sent_reminder,
      :delete_reminder_by_sender,
      :delete_reminder_by_recipient,
      :view_reminder,
      :mark_unread,
      :find,
      :sending,
      :redirect,
      :adminsending
       ]
    has_permission_on [:employees],
      :to => [
      :profile,
      :admission3,
      :admission3_1,
      :edit_employee,
      :update_positions,
      :select_reporting_manager,
      :profile_pdf

    ]
      has_permission_on [:employee_constraints],
      :to => [
           :create
            ]
    # has_permission_on [:student],
      # :to => [
      # :my_profile,
      # :profile_pdf
# 
    # ]
    # has_permission_on [:payroll],
      # :to => [
      # :edit_payroll_details
# 
    # ]

  end
  role :teacher do
    has_permission_on [:ptm_masters], :to => [:index,:show, :new, :create, :edit,:update, :destroy,:ptm_student]
    has_permission_on [:ptm_details], :to => [:index,:show, :new, :create, :edit,:update, :destroy,:update_parent_feedback]
    has_permission_on [:employees], :to => [:my_batches,:employee_all_skills,:search_batch_student]
    has_permission_on [:batches], :to => [:batch_students_pdf]
    has_permission_on [:timetable], :to => [:employee_full_view,:today_timetable,:student_view,:today_timetable_substitution,:employeetimetable_pdf,:substitution_report_center,:timetable_substitution_monthly_report,:timetable_substitution_daily_report,:monthlytimetable_pdf,:dailytimetable_pdf]
    has_permission_on [:assignments], :to => [:index,:show, :new, :create, :edit,:update, :destroy,:student_assigned,:view_student_assigned,:uploadAssignment,:download_attachment,:view,:show_batch]

  end
  
  role :timetable do
    has_permission_on [:timetable_interface], :to => [:courses,:skills, :rooms, :teachers, :batches,:subjects, :weekdays,:timeslots,:teacher_constraints,:room_constraints]
   end 
  
end
