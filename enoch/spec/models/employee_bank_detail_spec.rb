# == Schema Information
#
# Table name: employee_bank_details
#
#  id            :integer         not null, primary key
#  employee_id   :integer
#  bank_field_id :integer
#  bank_info     :string(255)
#

require 'spec_helper'



describe EmployeeBankDetail do
  before(:each) do
    emp_category = EmployeeCategory.create!(:name => 'Teacher',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @employee_attr = { :employee_number => 'EMPLOYEE',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    @employee = Employee.create!(@employee_attr)
    @bank_field_attr = {
      :name => "name",
      :status => true
    }
    bank_field = BankField.create!(@bank_field_attr)
    @employee_bank_detail_attr = {
      :employee => @employee,
      :bank_field => bank_field
    }
  end
 describe "validates" do
   it "should exist" do
   emp_bank_detail = EmployeeBankDetail.new(@employee_bank_detail_attr)
   emp_bank_detail.should be_valid
 end
 it "should respond to employee" do
  emp_bank_detail = EmployeeBankDetail.new(@employee_bank_detail_attr)
  emp_bank_detail.should respond_to(:employee)

 end
 it "should respond to employee" do
  emp_bank_detail = EmployeeBankDetail.new(@employee_bank_detail_attr)
  emp_bank_detail.should respond_to(:bank_field)

 end
 end
 describe "archive_employee_bank_detail" do
    it "should exist archive_employee_bank_detail" do
      employee_bank_detail = EmployeeBankDetail.new(@employee_bank_detail_attr)
      employee_bank_detail.should respond_to(:archive_employee_bank_detail)

    end
     it "should pass" do
       employee_bank_detail = EmployeeBankDetail.new(@employee_bank_detail_attr)
       archive_employee = @employee.archive_employee("test archive employee")
       employee_bank_detail.archive_employee_bank_detail(archive_employee)
       archived_employee_bank_detail = ArchivedEmployeeBankDetail.find_by_employee_id(@employee)
       archived_employee_bank_detail.attributes.should eql("id"=>1, "employee_id"=>1, "bank_field_id"=>1, "bank_info"=>nil)
    end
  end
end
