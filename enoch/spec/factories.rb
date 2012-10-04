Factory.define :employee_grade do |employee_grade|
  employee_grade.name  'Grade1'
  employee_grade.priority  '100'
  employee_grade.status  true
  employee_grade.max_hours_day  6
  employee_grade.max_hours_week 36
end
Factory.define :financial_asset do |financial_asset|
  financial_asset.title 'asset'
  financial_asset.amount 2000
  financial_asset.is_deleted false
  financial_asset.is_inactive false
  financial_asset.description 'asset description'
end
Factory.define :liability do |liability|
  liability.title 'liability'
  liability.amount 2000
  liability.is_deleted false
  liability.is_solved false
  liability.description 'liability description'
end

Factory.define :bank_field do |bank_field|
  bank_field.name "account"
  bank_field.status true
end

Factory.define :additional_field do |additional_field|
  additional_field.name "additional"
  additional_field.status true
end

Factory.define :student do |student|
  student.first_name             "Rahul"
  student.last_name              "Bajaj"
  student.admission_no           "1"
  student.date_of_birth          Date.today-1200
  student.admission_date         Date.today
  student.batch_id               "1"
  student.gender                 "M"
  student.association        :user
  student.association        :student_category      
end

Factory.define :student_category do |student_category|
  student_category.name "Category1"
  student_category.is_deleted  false
end

Factory.define :user do |user|
  user.role "Student1"
  user.email "user@gmail.com"
  user.password "password"
  user.confirm_password "password"
  user.hashed_password   "password"
  user.username "shakti"
end


Factory.define :finance_donation do |finance_donation|
  finance_donation.donor "mahinder"
  finance_donation.amount 101
  finance_donation.transaction_date '2011-12-12'
  finance_donation.description "this is mahinder"
end

Factory.define :finance_transaction_category do |finance_transaction_category|
  finance_transaction_category.name "abc"
  finance_transaction_category.description "category"
  finance_transaction_category.is_income false
  finance_transaction_category.deleted  false
end


Factory.define :category do |transaction_category|
  transaction_category.name "abc"
  transaction_category.description "category"
  transaction_category.is_income false
  transaction_category.deleted  false
end

Factory.define :finance_transaction do |finance_transaction|
  finance_transaction.title "car washing "
  finance_transaction.amount 101
  finance_transaction.transaction_date '2011-12-12'
  finance_transaction.description "company car"
  finance_transaction.association  :category
end

Factory.define :payroll_category do |payroll_category|
  payroll_category.name "Basic"
  payroll_category.is_deduction false
  payroll_category.status true
end


Factory.define :employee_category do |employee_category|
  employee_category.name  'Category1'
  employee_category.prefix  'E1'
  employee_category.status  true
end

Factory.define :employee_position do |employee_position|
  employee_position.name  'Position1'
  employee_position.association :employee_category
  employee_position.status  true
end

Factory.define :employee_department do |employee_department|
  employee_department.name  'Department1'
  employee_department.code  'E1'
  employee_department.status  true
end

Factory.define :student_additional_field do |student_additional_field|
  student_additional_field.name  'Passport'
  student_additional_field.status  true  
end

Factory.define :student_additional_details do |student_additional_details|
  student_additional_details.association :student
  student_additional_details.association :student_additional_field
end

Factory.define :employee do |employee|
  employee.association :employee_category
  employee.employee_number 'emp1'
  employee.first_name 'Aman'
  employee.association :employee_position
  employee.association :employee_department
  employee.date_of_birth Date.today
end




