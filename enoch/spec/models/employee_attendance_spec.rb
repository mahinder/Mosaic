# == Schema Information
#
# Table name: employee_attendances
#
#  id                     :integer         not null, primary key
#  attendance_date        :date
#  employee_id            :integer
#  employee_leave_type_id :integer
#  reason                 :string(255)
#  is_half_day            :boolean
#

require 'spec_helper'



describe EmployeeAttendance do
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
    @employee_leave_type = {
      :name => "sick",
      :code => "Sick",
      :max_leave_count => 2
    }
    employee_leave_type = EmployeeLeaveType.create!(@employee_leave_type)
    @employee_attendance_attr = {
      :employee_id => @employee,
      :employee_leave_type => employee_leave_type,
      :reason => "valid",
      :attendance_date => Date.today-22
    }
  end
  describe "validates" do
    it "should exist" do
      employee_attendance = EmployeeAttendance.new(@employee_attendance_attr)
      employee_attendance.should be_valid
    end
    it "should pass to employee with blank validation" do
      employee_attendance = EmployeeAttendance.new(@employee_attendance_attr.merge(:employee_id => ""))
      employee_attendance.should be_valid
    end
    it "should fail due to employee_leave_type presence validation" do
      employee_attendance = EmployeeAttendance.new(@employee_attendance_attr.merge(:employee_leave_type_id => ""))
      employee_attendance.should_not be_valid
    end
    it "should fail due to reason presence validation" do
      employee_attendance = EmployeeAttendance.new(@employee_attendance_attr.merge(:reason => ""))
      employee_attendance.should_not be_valid
    end
    it "should success for employee uniqueness" do
      employee_attendance = EmployeeAttendance.create!(@employee_attendance_attr)
      employee_attendance1 = EmployeeAttendance.new(@employee_attendance_attr.merge(:employee_id => 1,:employee_leave_type_id => 3, :reason => "dfj"))
      employee_attendance1.should_not be_valid
    end
    it "should exist validate" do
      employee_attendance = EmployeeAttendance.new(@employee_attendance_attr)
      employee_attendance.should respond_to(:validate)
    end
    it "should raise an error" do
      @employee_attendance = EmployeeAttendance.create!(@employee_attendance_attr.merge(:attendance_date => Date.today-25))
      @employee_attendance.validate
      @employee_attendance.errors.messages[:employee_attendance].should include("Date marked is earlier than joining date ")
    #
    end
  end
end
