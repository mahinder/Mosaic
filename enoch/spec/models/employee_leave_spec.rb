# == Schema Information
#
# Table name: employee_leaves
#
#  id                     :integer         not null, primary key
#  employee_id            :integer
#  employee_leave_type_id :integer
#  leave_count            :decimal(5, 1)   default(0.0)
#  leave_taken            :decimal(5, 1)   default(0.0)
#  reset_date             :date
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'


describe EmployeeLeave do
  before (:each) do
    emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @attr = { :employee_number => 'EMP1',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    @employee_leave_type = {
      :name => "sick",
      :code => "Sick",
      :max_leave_count => 2
    }
    employee_leave_type = EmployeeLeaveType.create!(@employee_leave_type)
    employee = Employee.create!(@attr)
    @employee_leave_attr = {
      :employee_id => employee,
      :employee_leave_type => employee_leave_type,
      :leave_count => 5,
      :leave_taken => 2
    }
  end
  it "should exist" do
    employee_leave = EmployeeLeave.new(@employee_leave_attr)
    employee_leave.should be_valid

  end
  it "should belongs to employee" do
    employee_leave = EmployeeLeave.new(@employee_leave_attr)
    employee_leave.should respond_to(:employee_id)
  end
  it "should respond to employee leave type" do
    employee_leave = EmployeeLeave.new(@employee_leave_attr)
    employee_leave.should respond_to(:employee_leave_type)
  end
  it "should respond to leave count" do
    employee_leave = EmployeeLeave.new(@employee_leave_attr)
    employee_leave.should respond_to(:leave_count)
  end
  it "should respond to leave taken" do
    employee_leave = EmployeeLeave.new(@employee_leave_attr)
    employee_leave.should respond_to(:leave_taken)
  end
end
