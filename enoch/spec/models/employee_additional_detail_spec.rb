# == Schema Information
#
# Table name: employee_additional_details
#
#  id                  :integer         not null, primary key
#  employee_id         :integer
#  additional_field_id :integer
#  additional_info     :string(255)
#

require 'spec_helper'



describe EmployeeAdditionalDetail do
  before(:each) do
    emp_category = EmployeeCategory.create!(:name => 'Teacher',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @employee_attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    @employee = Employee.create!(@employee_attr)
    additional_fields = AdditionalField.create!(:name => "name", :status => true)
    @employee_additional_detail_attr = {
      :employee => @employee,
      :additional_field => additional_fields
    }
  end
  describe "validates" do
    it "should exist" do
      employee_additional_detail_attr = EmployeeAdditionalDetail.new(@employee_additional_detail_attr)
      employee_additional_detail_attr.should be_valid
    end
    it "should respond to employee" do
      employee_additional_detail_attr = EmployeeAdditionalDetail.new(@employee_additional_detail_attr)
      employee_additional_detail_attr.should respond_to(:employee)
    end
    it "should respond to additional_field" do
      employee_additional_detail_attr = EmployeeAdditionalDetail.new(@employee_additional_detail_attr)
      employee_additional_detail_attr.should respond_to(:additional_field)
    end
  end
  describe "archive_employee_additional_detail" do
    it "archive_employee_additional_detail should exist" do
       employee_additional_detail_attr = EmployeeAdditionalDetail.new(@employee_additional_detail_attr)
       employee_additional_detail_attr.should respond_to(:archive_employee_additional_detail)
    end
    it "should pass and return archive_employee_additional_detail object" do
       employee_additional_detail_attr = EmployeeAdditionalDetail.create!(@employee_additional_detail_attr)
      #employee_salary_structure = EmployeeSalaryStructure.create!(@employee_salary_structure_attr)
      archive_employee = @employee.archive_employee("archive employee")
      employee_additional_detail_attr.archive_employee_additional_detail(archive_employee)
      archived_employee_additional_detail = ArchivedEmployeeAdditionalDetail.find_by_employee_id(@employee)
      archived_employee_additional_detail.attributes.should eql("id"=>1, "employee_id"=>1,  "additional_field_id"=>1, "additional_info"=>nil)
    end
  end

end
