# == Schema Information
#
# Table name: employee_grades
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  priority       :integer
#  status         :boolean
#  max_hours_day  :integer
#  max_hours_week :integer
#

require 'spec_helper'



describe EmployeeGrade do

  before (:each) do

    @attr = {:name => 'A',
      :priority => 1 ,
      :status => true,
      :max_hours_day=>1,
      :max_hours_week=>5
    }

  end
  it "should have a name,employee_category_id,status attributes" do
    employee_grade = EmployeeGrade.new(@attr)
    employee_grade.should respond_to(:name,:priority,:status,:max_hours_day,:max_hours_week)
  end

  it "name should be present" do
    employee_grade = EmployeeGrade.new(@attr.merge(:name =>""))
    employee_grade.should_not be_valid

  end
  # it "employee_category_id should be present" do
  # employee_position = EmployeePosition.new(@attr.merge(:employee_category_id =>""))
  # employee_position.should_not be_valid
  #
  # end
  it "should reject duplicate name " do
    employee_grade = EmployeeGrade.create!(@attr.merge(:name => 'A',
    :priority => 2 ,
    :status => true,
    :max_hours_day=>1,
    :max_hours_week=>5))
    employee_grade_with_duplicate_name = EmployeeGrade.new(@attr)
    employee_grade_with_duplicate_name.should_not be_valid
  end
  it "should reject duplicate priority " do
    employee_grade = EmployeeGrade.create!(@attr.merge(:name => 'A',
    :priority => 2 ,
    :status => true,
    :max_hours_day=>1,
    :max_hours_week=>5))
    employee_grade_with_duplicate_name = EmployeeGrade.new(:name => 'B',
    :priority => 2 ,
    :status => true,
    :max_hours_day=>1,
    :max_hours_week=>5)
    employee_grade_with_duplicate_name.should_not be_valid
  end
  it "should reject string value for priority name " do
    employee_grade = EmployeeGrade.new(@attr.merge(:name => 'A',
    :priority => "raise error",
    :status => true,
    :max_hours_day=>1,
    :max_hours_week=>5))

    lambda { employee_grade.save! }.should raise_error(ActiveRecord::RecordInvalid)
  

  end
  #
  it "should pass for scope test" do
  expected_employee_Grade = EmployeeGrade.create!(:name => 'C',
  :priority => 3 ,
  :status => true,
  :max_hours_day=>4,
  :max_hours_week=>20
  )
  
  active_employee_grade = EmployeeGrade.active
  
  active_employee_grade.should include(expected_employee_Grade)
  end
it "employee category has many :employees" do
    expected_object = EmployeeGrade.new(@attr)

    expected_object.should respond_to(:employee)
  end
#
 describe "validate_method" do
  
 it "validate method should exist" do 
   employee_Grade = EmployeeGrade.new(@attr)
   employee_Grade.should respond_to(:validate)
   end 
   it "should raise an error" do
     employee_Grade = EmployeeGrade.new(@attr.merge(:max_hours_day => 5, :max_hours_week => 4))
     #employeegrade = employee_Grade.validate
     employee_Grade.validate
     employee_Grade.errors.messages[:max_hours_week].should eql(["should be greater than Maximum periods per day."])
     # @config.errors.messages[:config_key].should eql(["Student Attendance Type should be any one of [\"Daily\", \"SubjectWise\"]"])
    #lambda { employee_Grade.save! }.should raise_error(ActiveRecord::RecordInvalid)
   end
 
 end

end
