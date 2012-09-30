# == Schema Information
#
# Table name: archived_employee_salary_structures
#
#  id                  :integer         not null, primary key
#  employee_id         :integer
#  payroll_category_id :integer
#  amount              :string(255)
#

require 'spec_helper'



describe ArchivedEmployeeSalaryStructure do
  before(:each) do
    emp_category = EmployeeCategory.create!(:name => 'Teacher',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @archived_employee_attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    @archived_employee = ArchivedEmployee.create!(@archived_employee_attr)
    @archived_employee_salary_structure_attr = {
      :employee_id => @archived_employee,
      :amount => 2000,
      :payroll_category_id => nil
    }
  end
  describe "validation" do
    it "should exist payroll_categories" do
      archived_employee_salary_structure = ArchivedEmployeeSalaryStructure.create!(@archived_employee_salary_structure_attr)
      archived_employee_salary_structure.should respond_to(:payroll_categories)

    end

  end
end
