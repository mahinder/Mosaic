# == Schema Information
#
# Table name: monthly_payslips
#
#  id                  :integer         not null, primary key
#  salary_date         :date
#  employee_id         :integer
#  payroll_category_id :integer
#  amount              :string(255)
#  is_approved         :boolean         default(FALSE), not null
#  approver_id         :integer
#  is_rejected         :boolean         default(FALSE), not null
#  rejector_id         :integer
#  reason              :string(255)
#

require 'spec_helper'


describe MonthlyPayslip do
  before (:each) do
    emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    @emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => @emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    @employee = Employee.create!(@attr)
    basicpayraollcategory = PayrollCategory.create!(:name=>"Basic",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>false,:status=>true)

    @monthly_payslip_attr = {
      :salary_date => Date.today-3,
      :employee => @employee,
      :payroll_category => basicpayraollcategory,
      :amount => 5000
    }
  end
  describe "validates" do
    it "should exist" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should be_valid
    end
    it "should response to salary date" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:salary_date)
    end
    it "should response to employee" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:employee)
    end
    it "should response to payrollcategory" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:payroll_category)
    end
    it "should response to approver" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:approver)
    end
    it "should response to rejector" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:rejector)
    end
    it "should pass for salary date presence" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr.merge(:salary_date => ""))
      monthly_payslip.should_not be_valid
    end
  end
  describe "is_approver" do
    it "should response to is approver" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:approve)
    end
    it "should pass for approve" do
      user = User.create!(:username => "sunil", :first_name => "sunil",:last_name => "kumar",:email => "sunil@ezzie.in", :role => "Employee", :password => "password")
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      got_obj = monthly_payslip.approve(user.id)
      got_obj.should be_true
    end
    it "should pass for reject" do
      user = User.create!(:username => "sunil", :first_name => "sunil",:last_name => "kumar",:email => "sunil@ezzie.in", :role => "Employee", :password => "password")
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      got_obj = monthly_payslip.reject(user.id,"invalid")
      # expected_object = MonthlyPayslip.find_by_reason("invalid")
      got_obj.should be_true
    # got_obj.should eql(expected_object)
    end
  end
  describe "find in active or archived" do
it "should exist this method" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      monthly_payslip.should respond_to(:active_or_archived_employee)
    end
    it "should return employee from employee table" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      got_employee = monthly_payslip.active_or_archived_employee
      got_employee.should eql(@employee)
    end
    it "should return employee from archived_employee table" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)

      archive_emp = @employee.archive_employee("retire")
      archived_employee = ArchivedEmployee.find_by_former_id(@employee.id)
      got_employee = monthly_payslip.active_or_archived_employee
      got_employee.should eql(archived_employee)
    end
  end
  describe "status as text" do
    it "should return status approved" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr.merge(:is_approved => true))
      monthly_payslip.status_as_text.should eql("Approved")

    end
    it "should return status rejected" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr.merge(:is_rejected => true))
      monthly_payslip.status_as_text.should eql("Rejected")

    end
    it "should return status rejected" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr.merge(:is_rejected => ""))
      monthly_payslip.status_as_text.should eql("Pending")

    end
  end
  describe " find_and_filter_by_department" do
    it "should respond to" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr.merge(:is_rejected => ""))
      MonthlyPayslip.should respond_to(:find_and_filter_by_department)

    end

    it "should return monthly payslip" do
      MonthlyPayslip.create!(@monthly_payslip_attr)
      monthly_payslip = MonthlyPayslip.find_and_filter_by_department(Date.today-3, @emp_department.id)
      expected = MonthlyPayslip.find_by_salary_date(Date.today-3)
      # monthly_payslip.should include(expected)
      arr = monthly_payslip[:monthly_payslips]
      arr.size.should eql(1)
      arr2 = arr[1]
      arr2.should include(expected)
    end
  end
  describe " total_employees_salary" do
    it "should respond to" do
      monthly_payslip = MonthlyPayslip.new(@monthly_payslip_attr)
      MonthlyPayslip.should respond_to(:total_employees_salary)

    end

    #it "should return total employee salary" do
      # MonthlyPayslip.create!(@monthly_payslip_attr.merge(:is_approved => true))
      # MonthlyPayslip.create!(@monthly_payslip_attr.merge(:is_approved => true,:amount => 10000))
      # individual_payslip_category = IndividualPayslipCategory.create!(:employee_id =>@employee ,:name => 'Test category',:salary_date => Date.today-3, :amount => 1000, :is_deduction => true)
      # monthly_payslip = MonthlyPayslip.total_employees_salary(Date.today-4,Date.today-1,@emp_department.id)
      # total_salary = monthly_payslip[:total_salary]
      # #total_salary.should eql(14000.0)
      # total_individual_payslip = monthly_payslip[:individual_categories]
      # total_individual_payslip.should include(individual_payslip_category)

    #end
  end
  
  pending "should return total employee salary"

end
