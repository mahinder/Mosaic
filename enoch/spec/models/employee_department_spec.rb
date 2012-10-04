# == Schema Information
#
# Table name: employee_departments
#
#  id     :integer         not null, primary key
#  code   :string(255)
#  name   :string(255)
#  status :boolean
#

require 'spec_helper'



describe EmployeeDepartment do

  before (:each) do
    @attr = { :code => 'MGMT', 
      :name => 'Management',
      :status => true
    }
  end
   it "should have a name,code,status attributes" do
     employee_department = EmployeeDepartment.new(@attr)
     employee_department.should respond_to(:name,:code,:status)
   end
# 
  it "name should be present" do
    employee_department = EmployeeDepartment.new(@attr.merge(:name =>""))
    employee_department.should_not be_valid

  end
  
 
  it "should reject duplicate name " do
    employee_department = EmployeeDepartment.create!(@attr)
    employee_department_with_duplicate_name = EmployeeDepartment.new(:code => 'MAT',
      :name => 'Management',
      :status => true)
    employee_department_with_duplicate_name.should_not be_valid
  end
  it "should reject duplicate code " do
    employee_department = EmployeeDepartment.create!(@attr)
    employee_department_with_duplicate_name = EmployeeDepartment.new(:code => 'MGMT',
      :name => 'Math',
      :status => true)
    employee_department_with_duplicate_name.should_not be_valid
  end
# 
   it "should pass for scope test" do
    
    expected_object = EmployeeDepartment.create!(@attr)
    active_employee_department = EmployeeDepartment.active

    active_employee_department.should include(expected_object)
  end
  it "employee category has many :employees" do
    expected_object = EmployeeDepartment.new(@attr)

    expected_object.should respond_to(:employees)
  end
  describe "department_total_salary" do
   it "department_total_salary method should exist" do
    employee_depart = EmployeeDepartment.new(@attr)
    employee_depart.should respond_to(:department_total_salary)
   end
   # it "should return department_total_salary" do
     # employee_depart = EmployeeDepartment.create!(@attr)
     # employee = Employee.create!(:employee_number => 'sawan',:joining_date => Date.today,:first_name => 'Admin',:last_name => 'Employee',
    # :employee_department_id =>employee_depart.id ,:employee_grade_id => 1,:employee_position_id => 1,
   # :employee_category_id => 1,:date_of_birth => Date.today-365)
    # MonthlyPayslip.create!(:salary_date => 5.days.ago, :employee_id => employee.id,:payroll_category_id => 1,
    # :is_approved => true)
#     
    # employee_depart.department_total_salary(10.days.ago,1.day.ago)
   # end

 end
end
