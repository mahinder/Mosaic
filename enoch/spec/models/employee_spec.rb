# == Schema Information
#
# Table name: employees
#
#  id                     :integer         not null, primary key
#  employee_category_id   :integer
#  employee_number        :string(255)
#  joining_date           :date
#  first_name             :string(255)
#  middle_name            :string(255)
#  last_name              :string(255)
#  gender                 :boolean
#  job_title              :string(255)
#  employee_position_id   :integer
#  employee_department_id :integer
#  reporting_manager_id   :integer
#  employee_grade_id      :integer
#  qualification          :string(255)
#  experience_detail      :text
#  experience_year        :integer
#  experience_month       :integer
#  status                 :boolean
#  status_description     :string(255)
#  date_of_birth          :date
#  marital_status         :string(255)
#  children_count         :integer
#  father_name            :string(255)
#  mother_name            :string(255)
#  husband_name           :string(255)
#  blood_group            :string(255)
#  nationality_id         :integer
#  home_address_line1     :string(255)
#  home_address_line2     :string(255)
#  home_city              :string(255)
#  home_state             :string(255)
#  home_country_id        :integer
#  home_pin_code          :string(255)
#  office_address_line1   :string(255)
#  office_address_line2   :string(255)
#  office_city            :string(255)
#  office_state           :string(255)
#  office_country_id      :integer
#  office_pin_code        :string(255)
#  office_phone1          :string(255)
#  office_phone2          :string(255)
#  mobile_phone           :string(255)
#  home_phone             :string(255)
#  email                  :string(255)
#  fax                    :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_data             :binary(5242880)
#  created_at             :datetime
#  updated_at             :datetime
#  photo_file_size        :integer
#  user_id                :integer
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
  end
  it "employee_category_id should be present" do
    employee = Employee.new(@attr.merge(:employee_category_id => ""))
    employee.current_step = 'personal'
    employee.should_not be_valid
    employee_number =Employee.new(@attr.merge(:employee_number => ""))
    employee_number.current_step = 'personal'
    employee_number.should_not be_valid
    employee_position = Employee.new(@attr.merge(:employee_position_id => ""))
    employee_position.current_step = 'personal'
    employee_position.should_not be_valid
    employee_department =Employee.new(@attr.merge(:employee_department_id => ""))
    employee_department.current_step = 'personal'
    employee_department.should_not be_valid
    employee_fname =Employee.new(@attr.merge(:first_name => ""))
    employee_fname.current_step = 'general'
    employee_fname.should_not be_valid
    date_of_birth =Employee.new(@attr.merge(:date_of_birth => ""))
    date_of_birth.current_step = 'general'
    date_of_birth.should_not be_valid
  #
  end
  it "should reject duplicate :employee_number " do
    employee = EmployeeCategory.create!(:name => 'Management',:prefix => 'MGMT',:status => true)
    cat2 = EmployeeCategory.create!(:name => 'Teaching',:prefix => 'TCR',:status => true)
    cat3 = EmployeeCategory.create!(:name => 'Non-Teaching',:prefix => 'NTCR',:status => true)
    employee_position1 = EmployeePosition.create!(:name => 'Principal',:employee_category_id => cat2,:status => true)
    employee_position2 = EmployeePosition.create!(:name => 'HR',:employee_category_id => cat2,:status => true)
    employee_position3 = EmployeePosition.create!(:name => 'Sr.Teacher',:employee_category_id => cat3,:status => true)
    emp_department1 = EmployeeDepartment.create!(:code => 'MAT',:name => 'Mathematics',:status => true)
    emp_department2 = EmployeeDepartment.create!(:code => 'OFC',:name => 'Office',:status => true)

    emp_grade2 = EmployeeGrade.create!(:name => 'B',:priority => 2 ,:status => true,:max_hours_day=>2,:max_hours_week=>5)
    emp_grade3 = EmployeeGrade.create!(:name => 'c',:priority => 3 ,:status => true,:max_hours_day=>3,:max_hours_week=>5)
    employee1 = Employee.create!(@attr)
    employee_number_with_duplicate_name = Employee.new(@attr)
    employee_number_with_duplicate_name.should_not be_valid
  end
  it "should not require an email address" do
    no_email_employee = Employee.new(@attr.merge(:email => ""))
    no_email_employee.should be_valid
  end
  it "should accept valid email addresses" do

    valid_email_user = Employee.new(@attr.merge(:email => "sunil@"))
    valid_email_user.should_not be_valid

  end
  describe "employee dependency" do
    before(:each) do
      @course_attr = {
        :course_name => "Grade 9",
        :code => "9th",
        :section_name => "A",
        :level => 0
      }

      @batch_attr = {
        :name => "A",
        :start_date => 1.year.ago,
        :end_date => 1.month.ago
      }

      course = Course.new(@course_attr)
      batch = Batch.new (@batch_attr)
      course.batches = [batch]
      course.presence_of_initial_batch
      course.save!

      @subject_attr = {
        :name => "hindi",
        :code => "Hind",
        :max_weekly_classes => 4,
        :no_exams => true,
        :batch_id => batch.id
      }
    end
    it "employee has many subject" do
      employee = Employee.new(@attr.merge(:employee_number => "sunilkumar"))
      subject = Subject.new(@subject_attr)
      employee.subjects = [subject]
      employee.save!
    end
    it "has many employee bank detail" do
      @bank_field_attr = {
        :name => "Account Number",
        :status => true
      }
      bank_field1 = BankField.create!(@bank_field_attr)
      bank_field2 = BankField.create!(@bank_field_attr.merge(:name => "anyfield"))
      employee_bank_field1 = EmployeeBankDetail.new(:bank_field_id => bank_field2)
      employee_bank_field2 = EmployeeBankDetail.new(:bank_field_id => bank_field1)
      employee = Employee.new(@attr.merge(:employee_number => "EMP"))
      employee.employee_bank_details = [employee_bank_field1,employee_bank_field2]
      employee.save!
    # employee.employee_bank_details = [employee_bank_field2]
    end
  end
  it "employee has many employee additional detail" do
    additional_field = AdditionalField.new(:name => "aditional field")
    emp_add_detail = EmployeeAdditionalDetail.new(:additional_field_id => additional_field )
    employee = Employee.new(@attr)
    employee.employee_additional_details = [emp_add_detail]
    employee.save!
  end
  it "employee has many apply_leaves" do
    employee_leave_types = EmployeeLeaveType.create!(:name => "casual", :code => "Cas", :max_leave_count => 3)
    employee1 = Employee.create!(@attr.merge(:employee_number => "EMP"))
    leaves = ApplyLeave.new(:employee_id => employee1, :employee_leave_types_id => employee_leave_types, :start_date => 5.days.ago, :end_date => 2.days.ago, :reason => "reason" )

  # employee1.apply_leaves = [leaves]
  # employee.save!
  # employee.apply_leaves = [leaves]
  end
  it "employee has many monthly payslip" do
    monthly_payslip = MonthlyPayslip.new(:salary_date => 5.days.ago)
    employee = Employee.new(@attr)
    employee.monthly_payslips = [monthly_payslip]
    employee.save!
  end
  it "employee has many salary structure" do
    payroll_category = PayrollCategory.create!(:name => "pcategory")
    employee1 = Employee.create!(@attr.merge(:employee_number => "Employee_number"))
    emp_salary_structure = EmployeeSalaryStructure.new(:employee_id => employee1, :payroll_category_id => payroll_category, :amount => 200)
    employee1.employee_salary_structures = [emp_salary_structure]
    employee1.save!
  end
  it "employee has many :finance_transactions" do
    finance_trans_category = FinanceTransactionCategory.create!(:name => "sunil")
    finance_transaction = FinanceTransaction.new(:title => "hindu",:amount => 200,:transaction_date => 1.month.ago, :category => finance_trans_category)
    employee = Employee.new(@attr)
    employee.finance_transactions = [finance_transaction]
    employee.save!
  end
  describe "create user and validate" do
    it "create user and validate should exist" do
      employee = Employee.new(@attr)
      employee.should respond_to(:create_user_and_validate)
    end
    it "should check new record? and return new record" do
      employee = Employee.new(@attr)
      emp = employee.create_user_and_validate
      emp.should be_true

    end
  end
  # # it "should update attribute" do
  # # employee = Employee.create!(@attr.merge(:employee_number => "EMP",:first_name => "sunil"))
  # # emp = employee.create_user_and_validate
  # # emp.should eql("sunil")
  # #
  # end
  describe "max_hours_per_day" do
    it "should return max_hours_per_day if grade is not blank" do
      employee = Employee.new(@attr)
      emp = employee.max_hours_per_day
      emp.should eql(1)
    end
  end
  describe "max_hours_per_week" do
    it "should return max_hours_per_week if employee_grade is not blank" do
      employee = Employee.new(@attr)
      emp =employee.max_hours_per_week
      emp.should eql(5)
    end

  end
  describe "next_employee" do
    it "should return next employee" do
      cat1 = EmployeeCategory.create!(:name => 'Management',:prefix => 'MGMT',:status => true)
      cat2 = EmployeeCategory.create!(:name => 'Teaching',:prefix => 'TCR',:status => true)
      cat3 = EmployeeCategory.create!(:name => 'Non-Teaching',:prefix => 'NTCR',:status => true)
      employee_position1 = EmployeePosition.create!(:name => 'Principal',:employee_category_id => cat1,:status => true)
      employee_position2 = EmployeePosition.create!(:name => 'HR',:employee_category_id => cat2,:status => true)
      employee_position3 = EmployeePosition.create!(:name => 'Sr.Teacher',:employee_category_id => cat3,:status => true)
      emp_department1 = EmployeeDepartment.create!(:code => 'MAT',:name => 'Mathematics',:status => true)
      emp_department2 = EmployeeDepartment.create!(:code => 'OFC',:name => 'Office',:status => true)

      emp_grade2 = EmployeeGrade.create!(:name => 'B',:priority => 2 ,:status => true,:max_hours_day=>2,:max_hours_week=>5)
      emp_grade3 = EmployeeGrade.create!(:name => 'c',:priority => 3 ,:status => true,:max_hours_day=>3,:max_hours_week=>5)
      employee1 = Employee.new(@attr)
      employee2 = Employee.create!(@attr.merge(:employee_number => "EMP2", :employee_category_id => cat1, :employee_position_id => employee_position1,:employee_department_id => emp_department1,:first_name => "employee"))
      employee2 = Employee.create!(@attr.merge(:employee_number => "EMP3", :employee_category_id => cat2, :employee_position_id => employee_position2,:employee_department_id => emp_department2,:first_name => "employee kumar"))
      employee3 = Employee.create!(@attr.merge(:employee_number => "EMP4", :employee_category_id => cat1, :employee_position_id => employee_position1,:employee_department_id => emp_department1,:first_name => "employee kum"))
    # employee1.previous_employee
    end
  end
  describe "full_name" do
    it "should return full name " do
      employee = Employee.new(@attr.merge(:first_name => "mohit",:last_name => "sharma"))
      employee_full_name = employee.full_name
      employee_full_name.should eql("mohit  sharma")
    end
  end
  describe "is_payslip_approved" do

    it "should return false" do
      employee = Employee.new(@attr)
      approve = employee.is_payslip_approved(1.days.ago)
      approve.should be_false
    end

    #
    it "should return true" do
      employee = Employee.create!(@attr)
      monthly_payslip = MonthlyPayslip.create!(:employee_id => employee.id, :salary_date => Date.today, :is_approved => 't')
      approve = employee.is_payslip_approved(Date.today)
      approve.should be_true

    end
  end
  describe "is_payslip_rejected" do
    it "should return false" do
      employee = Employee.new(@attr)
      approve = employee.is_payslip_rejected(1.days.ago)
      approve.should be_false
    end

    it "should return true" do
      employee = Employee.create!(@attr)
      monthly_payslip = MonthlyPayslip.create!(:employee_id => employee.id, :salary_date => Date.today, :is_rejected => true)
      approve = employee.is_payslip_rejected(Date.today)
      approve.should be_true

    end
  end
  describe "salary" do
    it "should return salary" do
      employee = Employee.create!(@attr)
      monthly_payslip = MonthlyPayslip.create!(:employee_id => employee.id, :salary_date => Date.today-3, :is_approved => 't')
      payslip_date=employee.salary(Date.today-2,Date.today-5)
      payslip_date.should eql(Date.today-3)
    end
  end
  describe "employee_salary" do
    it "should pass" do
      employee = Employee.create!(@attr)
      basichpayraollcategory = PayrollCategory.create!(:name=>"Basic",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>false,:status=>true)
      payroll_category =  PayrollCategory.create!(:name => "Medical Allowance",:percentage=>3.0, :payroll_category_id => basichpayraollcategory.id, :is_deduction=>false,:status=>true)
      payroll_category =  PayrollCategory.create!(:name => "PF",:percentage => 12.0, :payroll_category_id => basichpayraollcategory.id, :is_deduction => true, :status=>true)
      monthly_payslip = MonthlyPayslip.create!(:employee_id => employee.id, :salary_date => Date.today-3, :is_approved => 't', :payroll_category_id => basichpayraollcategory.id, :amount => 2000)
      IndividualPayslipCategory.create!(:employee_id => employee.id, :name => 'Test category', :salary_date => Date.today-2,:amount => 5000,:is_deduction => true)

      individual_category_nondeductionable = employee.employee_salary(Date.today-3)
    # individual_category_nondeductionable.should eql(5000.0)

    end
  end
  describe "archive_employee" do
    it "should exist" do
      employee = Employee.new(@attr)
      employee.should respond_to(:archive_employee)
    end
    it "should pass" do
      employee = Employee.create!(@attr)
      archive_emp = employee.archive_employee("very good")
      archive_user = ArchivedEmployee.find_by_employee_number(employee.employee_number)
      archive_emp.should eql(archive_emp)
    end
  end
  describe "all_salary" do
    it "should exist all_salary date" do
      employee = Employee.create!(@attr)
      basichpayraollcategory = PayrollCategory.create!(:name=>"Basic",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>false,:status=>true)
      monthly_payslip = MonthlyPayslip.create!(:employee_id => employee.id, :salary_date => Date.today-3, :is_approved => 't', :payroll_category_id => basichpayraollcategory.id, :amount => 2000)
      employee_monthly_payslip = employee.all_salaries(Date.today-4,Date.today-1)
      str1 = employee_monthly_payslip
    # str1.should include(/MonthlyPayslip salary_date: "2011-11-26"/)

    end
  end

  describe "find in active or archived" do
it "should exist this method" do
      employee = Employee.create!(@attr)
      Employee.find_in_active_or_archived(employee.id)
    end
    it "should return employee from employee table" do
      employee = Employee.create!(@attr)
      got_employee = Employee.find_in_active_or_archived(employee.id)
      got_employee.should eql(employee)
    end
    it "should return employee from archived_employee table" do
      employee = Employee.create!(@attr)
      archive_emp = employee.archive_employee("very good")
      archived_employee = ArchivedEmployee.find_by_former_id(employee.id)
      got_employee = Employee.find_in_active_or_archived(employee.id)
      got_employee.should eql(archived_employee)
    end
  end
  describe "calculate salary" do
    it "calculate salary method should exist" do
      employee = Employee.create!(@attr)
      basichpayraollcategory = PayrollCategory.create!(:name=>"Basic",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>false,:status=>true)
      monthlypayslip = MonthlyPayslip.create!(:employee_id => employee.id, :salary_date => Date.today-3, :is_approved => 't', :payroll_category_id => basichpayraollcategory.id, :amount => 6000)
      monthly_payslip = [monthlypayslip]
      individualPayslip1 = IndividualPayslipCategory.create!(:employee_id => employee.id, :name => 'Test category', :salary_date => Date.today-2,:amount => 2000,:is_deduction => true)
      individualPayslip2 = IndividualPayslipCategory.create!(:employee_id => employee.id, :name => 'Test category1', :salary_date => Date.today-2,:amount => 2000,:is_deduction => true)
      individualPayslip = [individualPayslip1,individualPayslip2]
      calculated_salary = Employee.calculate_salary(monthly_payslip,individualPayslip)
      expected_hash = Hash.new(:net_amount=>2000.0,:net_deductionable_amount => 4000.0,:net_non_deductionable_amount=>6000.0)
      calculated_salary.should eql(expected_hash[0])

    end
  end
end
