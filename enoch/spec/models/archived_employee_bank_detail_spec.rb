# == Schema Information
#
# Table name: archived_employee_bank_details
#
#  id            :integer         not null, primary key
#  employee_id   :integer
#  bank_field_id :integer
#  bank_info     :string(255)
#

require 'spec_helper'



describe ArchivedEmployeeBankDetail do
  before (:each) do
    emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @archive_employee_attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    archive_employee = ArchivedEmployee.create!(@archive_employee_attr)
    @bank_field_attr = {
      :name => "name",
      :status => true
    }
    bank_field = BankField.create!(@bank_field_attr)
    @archived_employee_bank_detail_attr = {
      :archived_employee => archive_employee,
      :bank_field => bank_field
    }
  end
  describe "validates" do
    it "should exist" do
      archive_emp_bank_detail = ArchivedEmployeeBankDetail.new(@archived_employee_bank_detail_attr)
      archive_emp_bank_detail.should be_valid
    end
    it "should respond to archived_employee" do
      archive_emp_bank_detail = ArchivedEmployeeBankDetail.new(@archived_employee_bank_detail_attr)
      archive_emp_bank_detail.should respond_to(:archived_employee)
    end
    it "should respond to bank_field" do
      archive_emp_bank_detail = ArchivedEmployeeBankDetail.new(@archived_employee_bank_detail_attr)
      archive_emp_bank_detail.should respond_to(:bank_field)

    end

  end
end
