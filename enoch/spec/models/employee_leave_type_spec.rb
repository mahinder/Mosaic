# == Schema Information
#
# Table name: employee_leave_types
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  code            :string(255)
#  status          :boolean
#  max_leave_count :string(255)
#  carry_forward   :boolean         default(FALSE), not null
#

require 'spec_helper'



describe EmployeeLeaveType do
  before (:each) do
    @employee_leave_type = {
      :name => "sick",
      :code => "Sick",
      :max_leave_count => 2
    }
  end
  describe "validates" do
    it "should exist" do
      employee_leave_type = EmployeeLeaveType.new(@employee_leave_type)
      employee_leave_type.should be_valid
    end
    it "should present name" do
      employee_leave_type = EmployeeLeaveType.new(@employee_leave_type.merge(:name => ""))
      employee_leave_type.should_not be_valid
    end
    it "should present code" do
      employee_leave_type = EmployeeLeaveType.new(@employee_leave_type.merge(:code => ""))
      employee_leave_type.should_not be_valid
    end
    it "should reject duplicate value for name" do
      employee_leave_type = EmployeeLeaveType.create!(@employee_leave_type)
      employee_leave_type_with_duplicate_name = EmployeeLeaveType.new(@employee_leave_type.merge(:code => "code"))
      employee_leave_type_with_duplicate_name.should_not be_valid
    end
    it "should reject duplicate value for code" do
      employee_leave_type = EmployeeLeaveType.create!(@employee_leave_type)
      employee_leave_type_with_duplicate_code = EmployeeLeaveType.new(@employee_leave_type.merge(:name => "name"))
      employee_leave_type_with_duplicate_code.should_not be_valid
    end
    it "should check format for max_leave_count" do
    employee_leave_type = EmployeeLeaveType.new(@employee_leave_type.merge(:max_leave_count => "invalid"))
    employee_leave_type.should_not be_valid
    end
 #enoch - leaves convert into leaf    
    # it "should has many employee leave" do
      # emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    # emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    # emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    # emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    # @attr = { :employee_number => 'EMP1',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      # :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      # :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    # }
    # employee = Employee.create!(@attr)
     # employee_leave_type = EmployeeLeaveType.create!(@employee_leave_type)
     # employee_leave = EmployeeLeave.new(:employee_id => employee, :employee_leave_type => employee_leave_type,:leave_count => 5,:leave_taken => 2)
    # employee_leave_type.employee_leaves = [employee_leave]
    # end
  it "should has many employee attendance" do
  emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @attr = { :employee_number => 'EMPLOYEE',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    employee = Employee.create!(@attr)
     employee_leave_type = EmployeeLeaveType.create!(@employee_leave_type)
     employee_attendance = EmployeeAttendance.new(:employee_id => employee, :employee_leave_type => employee_leave_type,:reason => "sick",:attendance_date => Date.today-1)
    employee_leave_type.employee_attendances = [employee_attendance]
  end
  end
end
