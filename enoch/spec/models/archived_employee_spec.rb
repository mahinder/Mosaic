# == Schema Information
#
# Table name: archived_employees
#
#  id                     :integer         not null, primary key
#  employee_category_id   :integer
#  employee_number        :string(255)
#  joining_date           :date
#  first_name             :string(255)
#  middle_name            :string(255)
#  last_name              :string(255)
#  gender                 :boolean
#  job_title              :string(255)
#  employee_position_id   :integer
#  employee_department_id :integer
#  reporting_manager_id   :integer
#  employee_grade_id      :integer
#  qualification          :string(255)
#  experience_detail      :text
#  experience_year        :integer
#  experience_month       :integer
#  status                 :boolean
#  status_description     :string(255)
#  date_of_birth          :date
#  marital_status         :string(255)
#  children_count         :integer
#  father_name            :string(255)
#  mother_name            :string(255)
#  husband_name           :string(255)
#  blood_group            :string(255)
#  nationality_id         :integer
#  home_address_line1     :string(255)
#  home_address_line2     :string(255)
#  home_city              :string(255)
#  home_state             :string(255)
#  home_country_id        :integer
#  home_pin_code          :string(255)
#  office_address_line1   :string(255)
#  office_address_line2   :string(255)
#  office_city            :string(255)
#  office_state           :string(255)
#  office_country_id      :integer
#  office_pin_code        :string(255)
#  office_phone1          :string(255)
#  office_phone2          :string(255)
#  mobile_phone           :string(255)
#  home_phone             :string(255)
#  email                  :string(255)
#  fax                    :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_data             :binary(5242880)
#  created_at             :datetime
#  updated_at             :datetime
#  photo_file_size        :integer
#  former_id              :string(255)
#

require 'spec_helper'



describe ArchivedEmployee do
  before (:each) do
    emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @archived_employee_attr = { :employee_number => 'Archived_employee',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
  end
  describe "validation" do
    it "should exist" do
      archived_employee = ArchivedEmployee.new(@archived_employee_attr)
      archived_employee.should be_valid
    end
    it " should respond to attribures" do
      archived_employee = ArchivedEmployee.new(@archived_employee_attr)
      archived_employee.should respond_to(:employee_category_id)
      archived_employee.should respond_to(:employee_position_id)
      archived_employee.should respond_to(:employee_department_id)
      archived_employee.should respond_to(:employee_grade_id)
      

    end
    it "should has many archived employee bank details" do
      @bank_field_attr = {
      :name => "name",
      :status => true
    }
     bank_field = BankField.create!(@bank_field_attr)
      # employee = Employee.create!(@archived_employee_attr)
     # archived_employee = employee.archive_employee("retire")
     # archived_employee_id = archived_employee.id
     # create an employee
     # archive him
     #get that it
     # create the archived eployee bank detail using this id and also using archived employee id
     # and then check
     
     archived_employee = ArchivedEmployee.create!(@archived_employee_attr)
     archive_emp_bank_detail = ArchivedEmployeeBankDetail.create!(:archived_employee => archived_employee, :bank_field => bank_field)
     #archived_employee.archived_employee_bank_details.should include(archive_emp_bank_detail)
    end
        it "should has many archived_employee_additional_details" do
       @additional_field_attr = {
      :name => "additional field",
      :status => true
    }
     additional_field = AdditionalField.create!(@additional_field_attr)
     archived_employee = ArchivedEmployee.create!(@archived_employee_attr)
      archive_employee_additional_detail = ArchivedEmployeeAdditionalDetail.new(:archived_employee => archived_employee,  :additional_field => additional_field)
    # archived_employee.archived_employee_additional_details =[archive_employee_additional_detail]
    end
  end
  describe "full_name" do
    it "should return full name of archived employee" do
      archived_employee = ArchivedEmployee.new(@archived_employee_attr)
      archived_employee.full_name.should eql("Admin  Employee")
    end
  end
end
