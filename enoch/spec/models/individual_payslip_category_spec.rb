# == Schema Information
#
# Table name: individual_payslip_categories
#
#  id                  :integer         not null, primary key
#  employee_id         :integer
#  salary_date         :date
#  name                :string(255)
#  amount              :string(255)
#  is_deduction        :boolean
#  include_every_month :boolean
#

require 'spec_helper'



describe Employee do

  before (:each) do
    emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    employee = Employee.create!(@attr)
    @individual_payslip_category_attr = { :employee_id => employee.id,
      :name => 'Test category',
      :salary_date => Date.today-2,
      :amount => 2000,
      :is_deduction => true
    }
  end
  describe "validates" do
    it "should exist" do
      individual_payslip1 = IndividualPayslipCategory.new(@individual_payslip_category_attr)
      individual_payslip1.should be_valid
    end
    it "should validate amount for nil validation" do
      individual_payslip1 = IndividualPayslipCategory.new(@individual_payslip_category_attr.merge(:amount => nil ))
      individual_payslip1.should be_valid
    end
    it "should validate amount for numericality validation" do
      individual_payslip1 = IndividualPayslipCategory.new(@individual_payslip_category_attr.merge(:amount => "invalid" ))
      individual_payslip1.should_not be_valid
    end
  end
end
