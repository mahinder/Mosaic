require 'spec_helper'



describe EmployeesSubject do
  before(:each) do
  emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @employee_attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
  @course_attr = {
        :course_name => "Grade 9",
        :code => "9th",
        :section_name => "A",
        :level =>7
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
      subject = Subject.create!(@subject_attr)
      employee = Employee.create!(@employee_attr)
      @employee_subject_attr = {
        :employee_id => employee.id,
        :subject_id => subject.id
      }
  end
  it "should have employee id" do
    employee_subject = EmployeesSubject.new(@employee_subject_attr)
    employee_subject.should respond_to(:employee)
  end
  it "should have subject id" do
    employee_subject = EmployeesSubject.new(@employee_subject_attr)
    employee_subject.should respond_to(:subject)
  end
  it "should belongs_to employee_id" do
  employee_subject = EmployeesSubject.new(@employee_subject_attr.merge(:employee_id => ""))
  employee_subject.should_not be_valid
  end
  it "should belongs_to subject" do
  employee_subject = EmployeesSubject.new(@employee_subject_attr.merge(:subject_id => "" ))
  employee_subject.should_not be_valid
  end
  
end
