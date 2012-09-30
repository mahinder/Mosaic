# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120831080622) do

  create_table "additional_exam_groups", :force => true do |t|
    t.string  "name"
    t.integer "batch_id"
    t.integer "exam_group_id"
    t.string  "exam_type"
    t.string  "reasion"
    t.boolean "is_published",     :default => false
    t.boolean "result_published", :default => false
    t.string  "students_list"
    t.date    "exam_date"
  end

  create_table "additional_exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "additional_exam_id"
    t.decimal  "marks",                   :precision => 7, :scale => 2
    t.integer  "grading_level_detail_id"
    t.string   "remarks"
    t.string   "custom"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_exams", :force => true do |t|
    t.integer  "additional_exam_group_id"
    t.integer  "subject_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "maximum_marks"
    t.integer  "minimum_marks"
    t.integer  "grading_level_id"
    t.integer  "weightage",                :default => 0
    t.integer  "topic_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_fields", :force => true do |t|
    t.string  "name"
    t.boolean "status"
  end

  create_table "apply_leaves", :force => true do |t|
    t.integer "employee_id"
    t.integer "employee_leave_types_id"
    t.boolean "is_half_day"
    t.date    "start_date"
    t.date    "end_date"
    t.string  "reason"
    t.boolean "approved",                :default => false
    t.boolean "viewed_by_manager",       :default => false
    t.string  "manager_remark"
  end

  create_table "archived_additional_exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "additional_exam_id"
    t.decimal  "marks",              :precision => 7, :scale => 2
    t.integer  "grading_level_id"
    t.string   "remarks"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_employee_additional_details", :force => true do |t|
    t.integer "employee_id"
    t.integer "additional_field_id"
    t.string  "additional_info"
  end

  create_table "archived_employee_bank_details", :force => true do |t|
    t.integer "employee_id"
    t.integer "bank_field_id"
    t.string  "bank_info"
  end

  create_table "archived_employee_salary_structures", :force => true do |t|
    t.integer "employee_id"
    t.integer "payroll_category_id"
    t.string  "amount"
  end

  create_table "archived_employees", :force => true do |t|
    t.integer  "employee_category_id"
    t.string   "employee_number"
    t.date     "joining_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_title"
    t.integer  "employee_position_id"
    t.integer  "employee_department_id"
    t.integer  "reporting_manager_id"
    t.integer  "employee_grade_id"
    t.string   "qualification"
    t.text     "experience_detail"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.boolean  "status"
    t.boolean  "is_teacher"
    t.string   "status_description"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.integer  "children_count"
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "husband_name"
    t.string   "blood_group"
    t.integer  "nationality_id"
    t.string   "home_address_line1"
    t.string   "home_address_line2"
    t.string   "home_city"
    t.string   "home_state"
    t.integer  "home_country_id"
    t.string   "home_pin_code"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "office_city"
    t.string   "office_state"
    t.integer  "office_country_id"
    t.string   "office_pin_code"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "email"
    t.string   "fax"
    t.time     "shift_start_time"
    t.time     "shift_end_time"
    t.string   "employee_photo_file_name"
    t.string   "employee_photo_content_type"
    t.binary   "employee_photo_data",         :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_photo_file_size"
    t.string   "former_id"
  end

  create_table "archived_exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.decimal  "marks",            :precision => 7, :scale => 2
    t.integer  "grading_level_id"
    t.string   "remarks"
    t.string   "custom"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archived_exam_scores", ["student_id", "exam_id"], :name => "index_archived_exam_scores_on_student_id_and_exam_id"

  create_table "archived_guardians", :force => true do |t|
    t.integer  "ward_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relation"
    t.string   "email"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.date     "dob"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_student_awards", :force => true do |t|
    t.integer  "batch_id"
    t.string   "title"
    t.string   "description"
    t.date     "award_date"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_students", :force => true do |t|
    t.string   "admission_no"
    t.string   "class_roll_no"
    t.date     "admission_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "batch_id"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.integer  "nationality_id"
    t.string   "language"
    t.string   "religion"
    t.integer  "student_category_id"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "pin_code"
    t.integer  "country_id"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.string   "student_photo_file_name"
    t.string   "student_photo_content_type"
    t.binary   "student_photo_data",         :limit => 16777215
    t.string   "status_description"
    t.boolean  "is_active",                                      :default => true
    t.boolean  "is_deleted",                                     :default => false
    t.integer  "immediate_contact_id"
    t.boolean  "is_sms_enabled",                                 :default => true
    t.string   "former_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_photo_file_size"
  end

  create_table "assessment_indicators", :force => true do |t|
    t.string   "indicator_value"
    t.string   "indicator_description"
    t.integer  "co_scholastic_sub_skill_area_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessment_names", :force => true do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "amount"
    t.boolean  "is_inactive", :default => false
    t.boolean  "is_deleted",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.string   "question"
    t.string   "hint"
    t.string   "student_id"
    t.integer  "batch_id"
    t.integer  "subject_id"
    t.date     "to_be_completed"
    t.boolean  "is_active",               :default => true
    t.string   "attachment_filename"
    t.string   "attachment_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", :force => true do |t|
    t.string   "file_name"
    t.integer  "student_id"
    t.integer  "created_by_id"
    t.integer  "deleted_by_id"
    t.string   "dir_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendance_subject_wises", :force => true do |t|
    t.integer "student_id"
    t.integer "period_table_entry_subject_wise_id"
    t.integer "batch_id"
    t.string  "reason"
  end

  create_table "attendances", :force => true do |t|
    t.integer "student_id"
    t.integer "period_table_entry_id"
    t.boolean "forenoon",              :default => false
    t.boolean "afternoon",             :default => false
    t.string  "reason"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "bank_fields", :force => true do |t|
    t.string  "name"
    t.boolean "status"
  end

  create_table "batch_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_events", ["batch_id"], :name => "index_batch_events_on_batch_id"

  create_table "batch_students", :id => false, :force => true do |t|
    t.integer "student_id"
    t.integer "batch_id"
  end

  add_index "batch_students", ["batch_id", "student_id"], :name => "index_batch_students_on_batch_id_and_student_id"

  create_table "batches", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "school_session_id"
    t.integer  "room_id"
    t.integer  "class_teacher_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_active",            :default => true
    t.boolean  "is_deleted",           :default => false
    t.boolean  "is_timetable_created", :default => false
    t.string   "employee_id"
  end

  add_index "batches", ["course_id"], :name => "index_batches_on_course_id"
  add_index "batches", ["is_deleted", "is_active"], :name => "index_batches_on_is_deleted_and_is_active"

  create_table "batches_finance_fee_categories", :id => false, :force => true do |t|
    t.integer "batch_id"
    t.integer "finance_fee_category_id"
  end

  create_table "calendars", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_timings", :force => true do |t|
    t.integer "batch_id"
    t.string  "name"
    t.time    "start_time"
    t.time    "end_time"
    t.boolean "is_break"
  end

  add_index "class_timings", ["batch_id", "start_time", "end_time"], :name => "index_class_timings_on_batch_id_and_start_time_and_end_time"

  create_table "co_scholastic_activities", :force => true do |t|
    t.string   "co_scholastic_activity_name"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "co_scholastic_activities_courses", :force => true do |t|
    t.integer  "course_id"
    t.integer  "co_scholastic_activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "co_scholastic_activity_assessment_indicators", :force => true do |t|
    t.string   "indicator_value"
    t.string   "indicator_description"
    t.integer  "co_scholastic_sub_skill_activity_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "co_scholastic_areas", :force => true do |t|
    t.string   "co_scholastic_area_name"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "co_scholastic_areas_courses", :force => true do |t|
    t.integer  "course_id"
    t.integer  "co_scholastic_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "co_scholastic_sub_skill_activities", :force => true do |t|
    t.integer  "co_scholastic_activity_id"
    t.string   "co_scholastic_sub_skill_name"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "co_scholastic_sub_skill_areas", :force => true do |t|
    t.integer  "co_scholastic_area_id"
    t.string   "co_scholastic_sub_skill_name"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connect_exams", :force => true do |t|
    t.integer "exam_group_id"
    t.integer "grouped_exam_id"
    t.float   "weightage"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "courses", :force => true do |t|
    t.string   "course_name"
    t.string   "code"
    t.string   "section_name"
    t.boolean  "is_deleted",   :default => false
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elective_groups", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elective_skills", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "electives", :force => true do |t|
    t.integer  "elective_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_additional_details", :force => true do |t|
    t.integer "employee_id"
    t.integer "additional_field_id"
    t.string  "additional_info"
  end

  create_table "employee_attachments", :force => true do |t|
    t.string   "file_name"
    t.integer  "employee_id"
    t.integer  "created_by_id"
    t.integer  "deleted_by_id"
    t.string   "dir_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_attendances", :force => true do |t|
    t.date    "attendance_date"
    t.integer "employee_id"
    t.integer "employee_leave_type_id"
    t.string  "reason"
    t.boolean "is_half_day"
  end

  create_table "employee_bank_details", :force => true do |t|
    t.integer "employee_id"
    t.integer "bank_field_id"
    t.string  "bank_info"
  end

  create_table "employee_categories", :force => true do |t|
    t.string  "name"
    t.string  "prefix"
    t.boolean "status"
  end

  create_table "employee_constraints", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "class_timing_id"
    t.integer  "weekday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_department_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "employee_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_departments", :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.boolean "status"
  end

  create_table "employee_grades", :force => true do |t|
    t.string  "name"
    t.integer "priority"
    t.boolean "status"
    t.integer "max_hours_day"
    t.integer "max_hours_week"
  end

  create_table "employee_leave_types", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.boolean "status"
    t.string  "max_leave_count"
    t.boolean "carry_forward",   :default => false, :null => false
  end

  create_table "employee_leaves", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "employee_leave_type_id"
    t.decimal  "leave_count",            :precision => 5, :scale => 1, :default => 0.0
    t.decimal  "leave_taken",            :precision => 5, :scale => 1, :default => 0.0
    t.date     "reset_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_positions", :force => true do |t|
    t.string  "name"
    t.integer "employee_category_id"
    t.boolean "status"
  end

  create_table "employee_salary_structures", :force => true do |t|
    t.integer "employee_id"
    t.integer "payroll_category_id"
    t.string  "amount"
  end

  create_table "employees", :force => true do |t|
    t.integer  "employee_category_id"
    t.string   "employee_number"
    t.date     "joining_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_title"
    t.integer  "employee_position_id"
    t.integer  "employee_department_id"
    t.integer  "reporting_manager_id"
    t.integer  "employee_grade_id"
    t.string   "qualification"
    t.text     "experience_detail"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.boolean  "status"
    t.boolean  "is_teacher"
    t.string   "status_description"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.integer  "children_count"
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "husband_name"
    t.string   "blood_group"
    t.integer  "nationality_id"
    t.string   "home_address_line1"
    t.string   "home_address_line2"
    t.string   "home_city"
    t.string   "home_state"
    t.integer  "home_country_id"
    t.string   "home_pin_code"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "office_city"
    t.string   "office_state"
    t.integer  "office_country_id"
    t.string   "office_pin_code"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "email"
    t.string   "fax"
    t.time     "shift_start_time"
    t.time     "shift_end_time"
    t.string   "employee_photo_file_name"
    t.string   "employee_photo_content_type"
    t.binary   "employee_photo_data",         :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_photo_file_size"
    t.boolean  "is_transport_enabled"
    t.integer  "user_id"
  end

  add_index "employees", ["employee_department_id"], :name => "index_employees_on_employee_department_id"
  add_index "employees", ["employee_number"], :name => "index_employees_on_employee_number"

  create_table "employees_skills", :id => false, :force => true do |t|
    t.integer "employee_id"
    t.integer "skill_id"
  end

  create_table "employees_subjects", :force => true do |t|
    t.integer "employee_id"
    t.integer "subject_id"
  end

  add_index "employees_subjects", ["subject_id"], :name => "index_employees_subjects_on_subject_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_common",   :default => false
    t.boolean  "is_holiday",  :default => false
    t.boolean  "is_exam",     :default => false
    t.boolean  "is_due",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "origin_id"
    t.string   "origin_type"
  end

  add_index "events", ["is_common", "is_holiday", "is_exam"], :name => "index_events_on_is_common_and_is_holiday_and_is_exam"

  create_table "exam_groups", :force => true do |t|
    t.string  "name"
    t.integer "batch_id"
    t.integer "grading_level_group_id"
    t.string  "exam_type"
    t.boolean "is_published",           :default => false
    t.boolean "result_published",       :default => false
    t.date    "exam_date"
    t.integer "assessment_name_id"
    t.integer "term_master_id"
  end

  create_table "exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.decimal  "marks",                   :precision => 7, :scale => 2
    t.integer  "grading_level_detail_id"
    t.string   "remarks"
    t.string   "custom"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exam_scores", ["student_id", "exam_id"], :name => "index_exam_scores_on_student_id_and_exam_id"

  create_table "exams", :force => true do |t|
    t.integer  "exam_group_id"
    t.integer  "subject_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "maximum_marks",    :precision => 10, :scale => 2
    t.decimal  "minimum_marks",    :precision => 10, :scale => 2
    t.integer  "grading_level_id"
    t.integer  "weightage",                                       :default => 0
    t.integer  "topic_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exams", ["exam_group_id", "subject_id"], :name => "index_exams_on_exam_group_id_and_subject_id"

  create_table "fee_collection_discounts", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "receiver_id"
    t.integer  "finance_fee_collection_id"
    t.decimal  "discount",                  :precision => 15, :scale => 2
    t.boolean  "is_amount",                                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_collection_particulars", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount",                    :precision => 12, :scale => 2
    t.integer  "finance_fee_collection_id"
    t.integer  "student_category_id"
    t.string   "admission_no"
    t.integer  "student_id"
    t.boolean  "is_deleted",                                               :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_discounts", :force => true do |t|
    t.string  "type"
    t.string  "name"
    t.integer "receiver_id"
    t.integer "batch_id"
    t.integer "finance_fee_category_id"
    t.decimal "discount",                :precision => 15, :scale => 2
    t.boolean "is_amount",                                              :default => false
  end

  create_table "finance_donations", :force => true do |t|
    t.string   "donor"
    t.string   "description"
    t.decimal  "amount",           :precision => 15, :scale => 2
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "transaction_date"
  end

  create_table "finance_fee_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "school_session_id"
    t.boolean  "is_deleted",        :default => false, :null => false
    t.boolean  "is_master",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finance_fee_collections", :force => true do |t|
    t.string  "name"
    t.date    "start_date"
    t.date    "end_date"
    t.date    "due_date"
    t.integer "fee_category_id"
    t.integer "batch_id"
    t.boolean "is_deleted",      :default => false, :null => false
  end

  add_index "finance_fee_collections", ["fee_category_id"], :name => "index_finance_fee_collections_on_fee_category_id"

  create_table "finance_fee_particulars", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount",                  :precision => 15, :scale => 2
    t.integer  "finance_fee_category_id"
    t.integer  "student_category_id"
    t.string   "admission_no"
    t.integer  "student_id"
    t.boolean  "is_deleted",                                             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finance_fee_particulars_students", :id => false, :force => true do |t|
    t.integer "student_id"
    t.integer "finance_fee_particulars_id"
  end

  create_table "finance_fee_structure_elements", :force => true do |t|
    t.decimal "amount",              :precision => 15, :scale => 2
    t.string  "label"
    t.integer "batch_id"
    t.integer "student_category_id"
    t.integer "student_id"
    t.integer "parent_id"
    t.integer "fee_collection_id"
    t.boolean "deleted",                                            :default => false
  end

  create_table "finance_fees", :force => true do |t|
    t.integer "fee_collection_id"
    t.string  "transaction_id"
    t.integer "student_id"
    t.boolean "is_paid",           :default => false
  end

  add_index "finance_fees", ["fee_collection_id", "student_id"], :name => "index_finance_fees_on_fee_collection_id_and_student_id"

  create_table "finance_transaction_categories", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.boolean "is_income"
    t.boolean "deleted",     :default => false, :null => false
  end

  create_table "finance_transaction_triggers", :force => true do |t|
    t.integer "finance_category_id"
    t.decimal "percentage",          :precision => 8, :scale => 2
    t.string  "title"
    t.string  "description"
  end

  create_table "finance_transactions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "amount",                :precision => 15, :scale => 2
    t.boolean  "fine_included",                                        :default => false
    t.integer  "category_id"
    t.integer  "student_id"
    t.integer  "finance_fees_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "transaction_date"
    t.decimal  "fine_amount",           :precision => 10, :scale => 2, :default => 0.0
    t.integer  "master_transaction_id",                                :default => 0
    t.integer  "user_id"
    t.integer  "finance_id"
    t.string   "finance_type"
    t.integer  "payee_id"
    t.string   "payee_type"
    t.string   "receipt_no"
    t.string   "voucher_no"
  end

  create_table "financial_assets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "amount"
    t.boolean  "is_inactive", :default => false
    t.boolean  "is_deleted",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grading_level_details", :force => true do |t|
    t.string   "grading_level_detail_name"
    t.integer  "grading_level_group_id"
    t.float    "min_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grading_level_groups", :force => true do |t|
    t.string   "grading_level_group_name"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grading_levels", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.integer  "min_score"
    t.integer  "order"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grading_levels", ["batch_id", "is_deleted"], :name => "index_grading_levels_on_batch_id_and_is_deleted"

  create_table "grouped_exams", :force => true do |t|
    t.string  "grouped_exam_name"
    t.integer "batch_id"
    t.integer "grading_level_group_id_id"
    t.integer "grading_level_group_id"
  end

  add_index "grouped_exams", ["batch_id"], :name => "index_grouped_exams_on_batch_id"

  create_table "guardians", :force => true do |t|
    t.integer  "ward_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relation"
    t.string   "email"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.date     "dob"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hostel_details", :force => true do |t|
    t.string   "hostel_name"
    t.string   "hostel_type"
    t.string   "other_information"
    t.boolean  "is_deleted",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "individual_payslip_categories", :force => true do |t|
    t.integer "employee_id"
    t.date    "salary_date"
    t.string  "name"
    t.string  "amount"
    t.boolean "is_deduction"
    t.boolean "include_every_month"
  end

  create_table "instant_fee_collection_details", :force => true do |t|
    t.integer  "instant_fee_collection_id"
    t.integer  "instant_fee_particular_id"
    t.float    "particular_amount_provided"
    t.float    "discount"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instant_fee_collections", :force => true do |t|
    t.integer  "instant_fee_id"
    t.integer  "student_id"
    t.integer  "employee_id"
    t.string   "name"
    t.float    "discount"
    t.float    "amount"
    t.boolean  "is_guest",        :default => false
    t.date     "collection_date"
    t.string   "receipt_no"
    t.string   "voucher_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instant_fee_particulars", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount",         :precision => 12, :scale => 2
    t.integer  "instant_fee_id"
    t.boolean  "is_deleted",                                    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instant_fees", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "school_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "liabilities", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "amount"
    t.boolean  "is_solved",   :default => false
    t.boolean  "is_deleted",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_books", :force => true do |t|
    t.string   "name"
    t.integer  "library_author_id"
    t.integer  "library_tag_id"
    t.string   "title"
    t.integer  "no_of_copies"
    t.integer  "available_no_of_copies"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_issue_book_records", :force => true do |t|
    t.integer  "library_book_id"
    t.integer  "user_id"
    t.integer  "batch_id"
    t.boolean  "is_return",          :default => false
    t.date     "issue_date"
    t.date     "due_date"
    t.date     "actual_return_date"
    t.integer  "total_fine"
    t.integer  "actual_fine_paid"
    t.boolean  "is_fine_paid",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_settings", :force => true do |t|
    t.integer  "default_no_of_days_for_issue"
    t.integer  "renew_period"
    t.string   "category"
    t.integer  "no_of_books_to_be_issued"
    t.integer  "fine_charged_per_day_after_due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monthly_payslips", :force => true do |t|
    t.date    "salary_date"
    t.integer "employee_id"
    t.integer "payroll_category_id"
    t.string  "amount"
    t.boolean "is_approved",         :default => false, :null => false
    t.integer "approver_id"
    t.boolean "is_rejected",         :default => false, :null => false
    t.integer "rejector_id"
    t.string  "reason"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_comments", :force => true do |t|
    t.text     "content"
    t.integer  "news_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passenger_board_transport_details", :force => true do |t|
    t.integer "transport_detail_id"
    t.integer "transport_board_id"
    t.integer "passenger_id"
    t.string  "passenger_type"
  end

  create_table "passengers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payroll_categories", :force => true do |t|
    t.string  "name"
    t.float   "percentage"
    t.integer "payroll_category_id"
    t.boolean "is_deduction"
    t.boolean "status"
  end

  create_table "period_entries", :force => true do |t|
    t.date    "month_date"
    t.integer "batch_id"
    t.integer "subject_id"
    t.integer "class_timing_id"
    t.integer "employee_id"
  end

  add_index "period_entries", ["month_date", "batch_id"], :name => "index_period_entries_on_month_date_and_batch_id"

  create_table "period_entry_subject_wises", :force => true do |t|
    t.date    "month_date"
    t.integer "batch_id"
    t.integer "subject_id"
    t.integer "class_timing_id"
    t.integer "employee_id"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "privilege_id"
  end

  add_index "privileges_users", ["user_id"], :name => "index_privileges_users_on_user_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.decimal  "price",       :precision => 10, :scale => 0
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.integer  "mobile"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ptm_details", :force => true do |t|
    t.integer  "student_id"
    t.string   "parent_feedback"
    t.integer  "ptm_master_id"
    t.integer  "employee_id"
    t.string   "teacher_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ptm_masters", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "batch_id"
    t.integer  "event_id"
    t.date     "ptm_start_date"
    t.date     "ptm_end_date"
    t.boolean  "is_active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminder_recipients", :force => true do |t|
    t.integer  "reminder_id"
    t.integer  "recipient"
    t.boolean  "is_read",                 :default => false
    t.boolean  "is_deleted_by_recipient", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminders", :force => true do |t|
    t.integer  "sender"
    t.string   "sent_to"
    t.string   "subject"
    t.text     "body"
    t.boolean  "is_deleted_by_sender", :default => false
    t.boolean  "is_replied",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_constraints", :force => true do |t|
    t.integer  "room_id"
    t.integer  "class_timing_id"
    t.integer  "weekday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.string   "roomtype"
    t.boolean  "status"
    t.integer  "batch_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms_skills", :id => false, :force => true do |t|
    t.integer "room_id"
    t.integer "skill_id"
  end

  create_table "rooms_subjects", :force => true do |t|
    t.integer "room_id"
    t.integer "subject_id"
  end

  create_table "school_configurations", :force => true do |t|
    t.string "config_key"
    t.string "config_value"
  end

  create_table "school_sessions", :force => true do |t|
    t.string   "name"
    t.boolean  "current_session"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "elective_skill_id"
    t.integer  "max_weekly_classes"
    t.boolean  "no_exam"
    t.string   "full_name"
    t.boolean  "is_scholastic",      :default => true
    t.boolean  "is_active",          :default => true
    t.boolean  "is_common",          :default => false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_settings", :force => true do |t|
    t.string  "settings_key"
    t.boolean "is_enabled",   :default => false
  end

  create_table "sms_templates", :force => true do |t|
    t.string   "template_code"
    t.string   "text"
    t.boolean  "is_inactive",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_additional_details", :force => true do |t|
    t.integer "student_id"
    t.integer "additional_field_id"
    t.string  "additional_info"
  end

  create_table "student_additional_fields", :force => true do |t|
    t.string  "name"
    t.boolean "status"
  end

  create_table "student_awards", :force => true do |t|
    t.integer  "batch_id"
    t.string   "title"
    t.string   "description"
    t.date     "award_date"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_categories", :force => true do |t|
    t.string  "name"
    t.boolean "is_deleted", :default => false
  end

  create_table "student_co_scholastic_activity_assessment_details", :force => true do |t|
    t.integer  "student_co_scholastic_assessment_id"
    t.integer  "student_id"
    t.integer  "co_scholastic_sub_skill_activity_id"
    t.integer  "co_scholastic_activity_assessment_indicator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_co_scholastic_area_assessment_details", :force => true do |t|
    t.integer  "student_co_scholastic_assessment_id"
    t.integer  "student_id"
    t.integer  "co_scholastic_sub_skill_area_id"
    t.integer  "assessment_indicator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_co_scholastic_assessments", :force => true do |t|
    t.string   "student_co_scholastic_assessment_name"
    t.integer  "school_session_id"
    t.integer  "batch_id"
    t.integer  "term_master_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_previous_data", :force => true do |t|
    t.integer "student_id"
    t.string  "institution"
    t.string  "year"
    t.string  "course"
    t.string  "total_mark"
  end

  create_table "student_previous_subject_marks", :force => true do |t|
    t.integer "student_id"
    t.string  "subject"
    t.string  "mark"
  end

  create_table "student_term_remarks", :force => true do |t|
    t.integer  "term_master_id"
    t.integer  "student_id"
    t.integer  "batch_id"
    t.integer  "school_session_id"
    t.string   "remarks"
    t.string   "remarks_type",      :default => "None"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "admission_no"
    t.string   "class_roll_no"
    t.date     "admission_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "batch_id"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.integer  "nationality_id"
    t.string   "language"
    t.string   "religion"
    t.integer  "student_category_id"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "pin_code"
    t.integer  "country_id"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.integer  "immediate_contact_id"
    t.boolean  "is_sms_enabled",                                 :default => true
    t.string   "student_photo_file_name"
    t.string   "student_photo_content_type"
    t.binary   "student_photo_data",         :limit => 16777215
    t.string   "status_description"
    t.boolean  "is_active",                                      :default => true
    t.boolean  "is_deleted",                                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_paid_fees",                                  :default => false
    t.integer  "student_photo_file_size"
    t.integer  "user_id"
    t.boolean  "is_transport_enabled",                           :default => false
  end

  add_index "students", ["admission_no"], :name => "index_students_on_admission_no"
  add_index "students", ["batch_id", "date_of_birth"], :name => "index_students_on_batch_id_and_date_of_birth"
  add_index "students", ["batch_id"], :name => "index_students_on_batch_id"
  add_index "students", ["first_name", "middle_name", "last_name"], :name => "index_students_on_first_name_and_middle_name_and_last_name"

  create_table "students_subjects", :force => true do |t|
    t.integer "student_id"
    t.integer "subject_id"
    t.integer "batch_id"
  end

  add_index "students_subjects", ["student_id", "subject_id"], :name => "index_students_subjects_on_student_id_and_subject_id"

  create_table "sub_skills", :force => true do |t|
    t.string   "name"
    t.integer  "skill_id"
    t.boolean  "is_active",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "batch_id"
    t.integer  "class_timing_id"
    t.boolean  "no_exams",           :default => false
    t.integer  "max_weekly_classes"
    t.integer  "elective_group_id"
    t.boolean  "is_deleted",         :default => false
    t.integer  "skill_id"
    t.boolean  "is_common",          :default => false
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["batch_id", "elective_group_id", "is_deleted"], :name => "index_subjects_on_batch_id_and_elective_group_id_and_is_deleted"

  create_table "teacher_diaries", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "school_session_id"
    t.string   "timing"
    t.string   "description",       :limit => 5000
    t.date     "text_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "term_masters", :force => true do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetable_entries", :force => true do |t|
    t.integer "batch_id"
    t.integer "weekday_id"
    t.integer "class_timing_id"
    t.integer "subject_id"
    t.integer "room_id"
    t.integer "employee_id"
  end

  add_index "timetable_entries", ["weekday_id", "batch_id", "class_timing_id"], :name => "by_timetable"

  create_table "timetable_substitutions", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "subject_id"
    t.integer  "employee_id"
    t.integer  "teacher_substitude_with_id"
    t.integer  "class_timing_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetable_users", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.integer  "subject_id"
    t.boolean  "is_active",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transport_boards", :force => true do |t|
    t.integer  "transport_route_id"
    t.string   "name"
    t.time     "picktime"
    t.time     "droptime"
    t.integer  "no_of_passenger"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transport_details", :force => true do |t|
    t.integer "transport_route_id"
    t.integer "transport_vehicle_id"
    t.integer "transport_driver_id"
    t.time    "intime"
    t.time    "outtime"
    t.boolean "status"
  end

  create_table "transport_drivers", :force => true do |t|
    t.integer "provider_id"
    t.string  "name"
    t.string  "address"
    t.integer "mobile"
    t.date    "dl_valid_upto"
    t.string  "licence_no"
    t.boolean "status"
  end

  create_table "transport_fee_categories", :force => true do |t|
    t.string   "passenger_type"
    t.string   "name"
    t.float    "monthly_fee"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transport_fee_collections", :force => true do |t|
    t.integer  "passenger_id"
    t.string   "passenger_type"
    t.integer  "transport_fee_category_id"
    t.integer  "amount"
    t.integer  "discount"
    t.date     "transport_fee_collection_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transport_routes", :force => true do |t|
    t.string   "name"
    t.string   "start_place"
    t.string   "end_place"
    t.string   "distance"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transport_vehicles", :force => true do |t|
    t.string  "vehicle_type"
    t.string  "registration_no"
    t.integer "capacity"
    t.integer "provider_id"
    t.date    "date_of_hire"
    t.date    "date_of_expiry"
    t.boolean "status"
  end

  create_table "user_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "admin"
    t.boolean  "student"
    t.boolean  "employee"
    t.boolean  "timetable"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "weekdays", :force => true do |t|
    t.integer "batch_id"
    t.string  "weekday"
  end

  add_index "weekdays", ["batch_id"], :name => "index_weekdays_on_batch_id"

  create_table "xmls", :force => true do |t|
    t.string   "finance_name"
    t.string   "ledger_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
