# == Schema Information
#
# Table name: employee_salary_structures
#
#  id                  :integer         not null, primary key
#  employee_id         :integer
#  payroll_category_id :integer
#  amount              :string(255)
#

require 'spec_helper'


describe EmployeeSalaryStructure do
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
    basichpayraollcategory = PayrollCategory.create!(:name=>"Basic",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>false,:status=>true)
    @employee_salary_structure_attr = {
      :employee_id => @employee,
      :payroll_category_id => basichpayraollcategory,
      :amount => 2000
    }
  end
  describe "validation" do
    it "should belongs to employee" do
      employee_salary_structure = EmployeeSalaryStructure.new(@employee_salary_structure_attr.merge(:employee_id => ""))
      employee_salary_structure.should_not be_valid

    end
    it "should belongs to employee" do
      employee_salary_structure = EmployeeSalaryStructure.new(@employee_salary_structure_attr.merge(:payroll_category_id => ""))
      employee_salary_structure.should be_valid

    end
  end
  describe "archive_employee_salary_structure" do
    it "should exist archive_employee_salary_structure" do
      employee_salary_structure = EmployeeSalaryStructure.new(@employee_salary_structure_attr)
      employee_salary_structure.should respond_to(:archive_employee_salary_structure)

    end
    it "should pass" do
      employee_salary_structure = EmployeeSalaryStructure.create!(@employee_salary_structure_attr)
      archive_employee = @employee.archive_employee("test archive employee")
      employee_salary_structure.archive_employee_salary_structure(archive_employee)
      archived_employee_salary_structure = ArchivedEmployeeSalaryStructure.find_by_employee_id(@employee)
      archived_employee_salary_structure.attributes.should eql("id"=>1, "employee_id"=>1, "payroll_category_id"=>1, "amount"=>"2000")
    end
  end
end
