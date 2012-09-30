Enoch::Application.routes.draw do

resources :library_books do
    collection do
      get :library_select_update
    end
  end
  resources :library_authors
  resources :library_issue_book_records do
    collection do
      get :find_book,:find_student_employee,:book_info,:person_info,:issue,:return,:issued_book_info,:find_issue_book,:person_issued_info,:fineinfo,:show_transaction,:library,:monthly_report,:show_transaction_report\
      ,:bookwisereport
    end
  end
  resources :library_settings
  resources :library_tags
  resources :teacher_diaries do
    collection do 
      get :view_diary,:view_pdf,:view_my_diary_details
    end
  end

  resources :student_co_scholastic_activity_assessment_details

  resources :student_co_scholastic_area_assessment_details

  resources :student_co_scholastic_assessments do
    collection do
      get :update_batch
    end
  end

  resources :student_assessment_details

  resources :student_assessments

  resources :co_scholastic_activity_assessment_indicators do
    collection do 
      get :all_record
    end
  end

  resources :co_scholastic_sub_skill_activities do
    collection do
      get :add_scholastic_activity_subskill,:view_scholastic_activity_subskill
    end
  end

  resources :co_scholastic_sub_skill_areas  do
    collection do
      get :add_scholastic_area_subskill,:view_scholastic_area_subskill
    end
  end

  resources :co_scholastic_activities do
    collection do
      get :all_record
    end
  end

  resources :co_scholastic_areas do
    collection do
      get :all_record,:add_scholastic_area_subskill
    end
  end

  resources :transport_fee_collections do
    collection do
      get :transport_fee_collection_pdf,:transport_fee_report,:monthly_transport_fee_report
    end
  end

  resources :transport_fee_categories do
    collection do
      get :all_record
    end
  end

  resources :student_term_remarks do
    collection do 
      get :change_student_term_batch
    end
  end

  resources :assessment_names do
    collection do 
      get :all_record
    end
  end

  resources :transport_fees do
    collection do
      get :all_record
    end
  end

  resources :assessment_indicators do
    collection do 
      get :all_record
    end
  end

  resources :passengers

  resources :passenger_board_transport_details

  resources :transport_details do
    collection do
      get :all_record,:add_passenger,:change_batch,:get_student,:save_passanger_detail,:view_passanger,:add_passenger_index,:passanger_department,
      :delete_passenger,:edit_passenger,:update_passenger,:passengers_pdf,:transport_report,:transport_report_index,:get_transport_report,:transport_fee_collection,
      :collection_index,:collection_batch,:get_transport_fee_collection,:create_transport_fee_collections,:get_route_board,:get_transport_report_pdf,
      :get_fee_collection_filter,:view_transport_fee_collection_report
    end
  end

  resources :transport_drivers do
    collection do
      get :all_record
    end
  end

  resources :term_masters do
    collection do 
      get :all_record
    end
  end

  resources :instant_fee_collection_details

  resources :instant_fee_collections do
    collection do 
      get :get_student_or_employee_data,:get_partial_for_instant_fee_collection,:get_instant_fee_collection_table,:instant_fee_collection_receipt
    end
  end

  resources :instant_fee_particulars

  resources :instant_fees do
    collection do 
      get :all_record
    end
  end

  resources :transport_vehicles do
    collection do
      get :all_record
    end
  end
  
  resources :school_sessions do
    collection do 
      get :all_record
    end
  end

  resources :providers do
    collection do
      get :all_record
    end
  end

  resources :transport_boards do
    collection do
      get :all_record
    end
  end

  resources :transport_routes do
    collection do
      get :all_record,:transport_dashboard
    end
  end

  resources :hostel_details


  resources :topics

  resources :sub_skills do
    collection do 
      get :subskill_find,:subject_subskill
    end
  end

  resources :timetable_users do
    collection do
      get :courses,:skills,:rooms,:teachers,:batches,:subjects,:weekdays,:timeslots,:teacher_constraints,:room_constraints
    end
  end

  resources :assignments do
    collection do
      get :student_assigned,:view,:view_student_assigned,:uploadAssignment,:download_attachment,:show_batch
    end
  end

  resources :grading_level_details do
    collection do
      get :add_grading_detail,:create_grade,:view_grading_detail,:edit_grading_detail
    end
  end

  resources :grading_level_groups do
    collection do
      get :all_record
    end
  end

  get "ptm_admin/index"
  get "ptm_admin/update"
  get "ptm_admin/show"
  get "ptm_admin/ptm"
  get "ptm_admin/edit"

 resources :ptm_details do
  collection do
      get :update_parent_feedback
    end
  end

 resources :ptm_masters do
  collection do
      get :ptm_student
    end
  end

  resources :room_constraints

  resources :employee_constraints

resources :sms_templates do
    collection do
      get :all_record
    end
  end

  resources :archived_student_awards

  resources :connect_exams

  resources :student_awards


  resources :exam_groups do
    collection do
      get :delete_exam_group,:changeExam,:exam_group_index,:index,:time_validation,:scholastic_area_assessment
    end
  end

  resources :exams do
    collection do
      get :index,:create_exam,:update_batch,:update_exam_form,:edit,:publish,:update_exam,:previous_years_marks_overview_pdf,
      :save_scores,:destroy_exam,:grouping,:exam_wise_report,:list_exam_types,:generated_report,:graph_for_generated_report,
      :view,:pie_chart,:generated_report_pdf,:subject_wise_report,:list_subjects,:generated_report2,:consolidated_exam_report,:consolidated_exam_report_pdf,
      :generated_report2_pdf,:grouped_exam_report,:grouped_update_batch,:final_report_type,:generated_report4,:generated_report4_pdf,:index_pdf,:exam_wise_batch_report,
      :subject_wise_batch_report,:generated_report3,:graph_for_generated_report3,:graph_for_generated_report,:previous_years_marks_overview,:graph_for_previous_years_marks_overview,
      :connect_exam_report,:academic_report,:generated_report5,:view_grouping,:normal_academic_report,:previous_years_marks_overviews,:view_exam_score_updation,:destroy_grouped_exam,
      :delete_view_grouping,:generated_student_report4,:generated_student_report4_pdf,:edit_grouping,:co_scholastic_assessment_index,:grouping_assessment_type,
      :grouping_assessment_mode,:new_grouping_assessment,:second_graph_for_generated_repport,:student_generated_report5,:xls_demo,
      :co_scholastic_area_assessment_report,:co_scholastic_activity_assessment_report,:generated_report5_pdf,:secondry_standard_report
    end
  end
   

  resources :skills do
    collection do
      get :create_elective_skill,:assigned,:remove_batch
    end
  end
  resources :class_timings do
      collection do
        get :batch,:time,:del_class_time,:find_class_timing
      end
    end
    
 
  
    resources :weekdays do
      collection do
        get :week,:batch,:weekdays_modal
      end
    end


  resources :elective_skills

  resources :mandatory_skills

  resources :batches do
    collection do
      get :all_record,:subject_students,:update_batch_subject,:select_batch,:room,:teacher,:assign_home_teacher_and_room,:assign_student_to_sub,:assign_student_to_sub1,:remove_student_to_sub1,:show1,:subject_batch_student,:assign_skill_to_batch,:find_batch_subjects, \
      :create_elective_group,:batch_history,:history_select_course,:history_select_batch,:batch_students_pdf
    end
  end

  resources :courses do
    collection do
      get :viewall, :all_record,:skills,:elective_skill,:view_skill,:full_form,:all
    end
  end

  resources :rooms do
    collection do
      get :all_record,:change_room_batch,:find_room_constraints,:find_room_skill,:room_skill_assign
    end
  end

  resources :users do
    collection do
      get :all_record, :upload_excel,:upload_excelsheet,:edit_privilege, :change_password, :reset_password_of_any_user,:find,:report,:reset,:privileges_of_any_user,:find_employee,
      :user_mobile_no,:example_report,:download_help
    end
  end

  resources :calendars do
    collection do
      get :monthsname ,:event_view,:add_event,:event_delete,:select_course_batch,:generate_calendar_pdf,:myEventView
    end
  end
  
  
  resources :finance_donations do
    collection do
      get :all_record, :all_refresh,:donation_list
    end
  end

  resources :categories

  resources :products

resources :financial_assets do
    collection do
      get :all_record
    end
  end

  resources :liabilities do
    collection do
      get :all_record
    end
  end

  resources :expenses do
    collection do
      get :all_record, :all_refresh,:expense_list
    end
  end

  resources :student_additional_fields do
    collection do
      get :all_record, :all_refresh
    end
  end
  resources :incomes do
    collection do
      get :all_record, :all_refresh,:income_list
    end
  end

  resources :additional_fields do
    collection do
      get :all_record
    end
  end

  resources :bank_fields do
    collection do
      get :all_record
    end
  end

  resources :employee_departments do
    collection do
      get :all_record
    end
  end

  resources :employee_positions do
    collection do
      get :all_record, :all_refresh
    end
  end

resources :finance_transaction_categories do
    collection do
      get :all_record, :all_refresh
    end
  end
  resources :payroll_categories do
    collection do
      get :all_record, :all_refresh
    end
  end

  resources :employee_categories do
    collection do
      get :all_record, :all_refresh
    end
  end

  resources :student_categories do
    collection do
      get :all_record,:all_refresh
    end
  end

resources :timetable do
    collection do
      get :find_max_class,:timetable_step1,:batch,:set_timetable,:create_timetable,:timetable_setting,
          :list_employee_by_subject,:full_data,:add_entry,:remove_entry,:generate,:generate_subject_wise,
          :employee_view,:student_view,:employee_full_view,:timetable_pdf,:teacher_change,:timetable_batch_selected_pdf,
          :admin_wise_employee_page,:timetable_substitution,:free_teacher,:assign_substitute,:today_timetable,
          :emp_max_find,:find,:employee_info,:today_timetable_substitution,:timetable_substitude_reassign,:reassign_substitute,:employeetimetable_pdf,:substitution_report_center,:timetable_substitution_monthly_report,:timetable_substitution_daily_report,:monthlytimetable_pdf,:dailytimetable_pdf
    end
  end

  resources :sessions do
    collection do
      get :demo_form, :hr_settings, :configurations,:dashboard_settings,:destroy,:get_my_batch_birth_day_list
    end
  end

  resources :employee_grades do
    collection do
      get :all_record, :all_refresh
    end
  end

  match '/signin',    :to => 'sessions#new'
  match '/signout',   :to => 'sessions#destroy'
  match '/dashboard', :to => 'sessions#dashboard'
  match '/student', :to => 'sessions#demo_student'
  match '/teacher', :to => 'sessions#demo_teacher'
  match '/dashboard_settings', :to => 'sessions#dashboard_settings'
  match '/library_management', :to => 'sessions#library'
  #demo routes - to be removed
  match '/attendance', :to => 'sessions#demo_attendance'
  match '/timetables', :to => 'sessions#demo_timetable'
  match '/timetable_day', :to => 'sessions#demo_timetable_day'
  match '/search', :to => 'sessions#demo_search'
  match '/calendar', :to => 'sessions#demo_calendar'
  match '/form', :to => 'sessions#demo_form'
  #match '/school', :to => 'school_configurations#settings'
  match '/examination_settings', :to => 'sessions#examination_settings'

  
  resources :grading_levels do
    collection do
      get :create_grading_level,:grade_update_batch,:create_grade,:update_grade
    end
  end
  
  resources :courses
  # The priority is based upon order of creation:
  match '/simple', :to => 'sessions#demo_simple_form'
  resources :school_configurations do
    collection do
      get :settings
    end
  end

  # resources :schools

  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'sessions#dashboard'
  resources :subjects
  # resources :countries
  resources :elective_groups
  resources :reminders do
    collection do
      get :find,:sending,:redirect,:index,:sms
    end
  end
  resources :weekdays
  resources :calendar
  # resources :archived_guardian
  # resources :archived_student
  resources :batch_transfer do
    collection do
      get :find_batch,:change_batch
    end
  end
  resources :student do
     collection do
        get :student_wizard_first_step,:student_wizard_next_step,:student_wizard_previous_step,:my_profile,:assign_roll_no,:change_roll_number,:subject_list,
        :update_student, :change_student_image,:update_student_image,:photo,:student_search,:search_ajax,:profile_pdf,:my_pals,:fees,:print_student_pdf_details,:print_id_card,
        :update_guardian,:add_guardian,:change_batch,:student_advanced_search,:update_immediate,:student_wizard_previous_step,:student_pdf,
        :generate_all_tc_pdf,:generate_tc_pdf,:previous_data,:image_crop,:update_crop_image,:admission_no,:email_validation,:del_guardian,:my_meetings,:student_meeting_details,
        :reports,:get_guardian_id,:report_index,:view_report_index,:view_report,:get_all_gender_report,:get_gender_course_report,:change_student_batch,:get_gender_batch_report,:get_all_religion_report,
        :get_religion_course_report,:get_religion_batch_report,:get_all_category_report,:get_category_course_report,:get_category_batch_report,:pdf_report,:change_student_course_batch,
        :change_student_category_batch,:employee_report_center,:employee_pdf_report,:system_reports,:report_card_index,:report_card,:update_batch,:particular_student,:attachments,:upload,:show_file_directory
        
      end
  end

  resources :attendances do
    collection do
      get :attendance_change_batch,:subject_wise_attendance,:attendance_subject_wise_change_batch,:list_subject,:show_subject_wise,:create_subject_wise_attendance,
      :multiple_attendance,:multiple_attendance_save,:multiple_attendance_save_batch_wise
    end
  end
  
  resources :attendance_reports do
    collection do
      get :attendance_report_batch,:report
    end
  end
  #resources :logins



    resources :employees do
      collection do
        get :select_reporting_manager, :wizard_first_step, :wizard_next_step, :wizard_previous_step, :save, :some_step,
        :win, :test, :search_skill, :employee_profile, :change_image, :image_store, :search, 
        :employee_search, :change_to_former, :hr, :edit_employee,:profile,:advanced_search, :update_positions,
        :edit_privilege,:photo_crop,:admission3, :admission3_1, :employee_photo_crop, :demo,:employee_no,:search_all_skill,:update_skills,
        :employee_leave_count_edit,:employee_leave_count_update,:employee_mobile_no,:call_in_sheet,
        :employee_attendance,:advance_search_pdf,:my_batches,:search_batch_student,:employee_mail,:employee_all_skills,
        :employee_finance_setting,:payslip,:select_department_employee,:payroll_department,:create_monthly_payslip,:rejected_payslip,
        :update_rejected_employee_list,:payslip_date_select,:one_click_payslip_generation,:payslip_revert_date_select,
        :one_click_payslip_revert,:department_payslip,:view_employee_payslip,:employee_individual_payslip_pdf,:archived_employee,
        :archived_employee_list,:archived_employee_profile,:crop_employee_image,:profile_pdf,:upload,:show_file_directory,:attachments

      end
  end

  resources :payroll do
    collection do
      get :manage_payroll,:edit_payroll_details
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
