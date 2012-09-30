require 'spec_helper'

describe TimetableEntry do
  before(:each) do
    @batch_attr = {
      :name => "A",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }
    @batch = Batch.create!(@batch_attr)
    @Weekday5= Weekday.create!(:weekday =>"0", :batch_id => nil)
    @classtiming_attr = {
      :name => "classtiming",
      :start_time => "02:00 AM",
      :end_time => "03:00 AM",
      :batch_id => 1
    }
    @class_timing = ClassTiming.create(@classtiming_attr)
    @subject_attr = {
      :name => "General Health",
      :code => "General Health",
      :no_exams => true ,
      :max_weekly_classes => 2,
      :batch_id => @batch.id,
      :class_timing_id => @class_timing.id
    }
    @subject = Subject.create!(@subject_attr)
    emp_category = EmployeeCategory.create!(:name => 'Fedena Admin',:prefix => 'Admin',:status => true)
    emp_position = EmployeePosition.create!(:name => 'Fedena Admin',:employee_category_id => emp_category.id ,:status => true)
    emp_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management',:status => true)
    emp_grade = EmployeeGrade.create!(:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5)
    @attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Admin',:last_name => 'Employee',
      :employee_department_id => emp_department.id,:employee_grade_id =>emp_grade.id ,:employee_position_id => emp_position.id,
      :employee_category_id => emp_category.id,:date_of_birth => Date.today-365
    }
    @emp = Employee.create!(@attr)

  end

  it "should belongs to batch " do
    @timetable = TimetableEntry.new()
    @timetable.batch = @batch
    @timetable.save
  end

  it "should belongs to class_timing " do
    @timetable = TimetableEntry.new()
    @timetable.class_timing = @class_timing
    @timetable.save
  end

  it "should belongs to weekday " do
    @timetable = TimetableEntry.new()
    @timetable.weekday = @Weekday5
    @timetable.save
  end

  it "should belongs to subject and return subject class_timing" do
    @timetable = TimetableEntry.new()
    @timetable.subject = @subject
    @timetable.save
    TimetableEntry.time(@subject).should eql(@class_timing)
  end

  it "should belongs to employee and should return employees of subject and return free employees count" do
    @timetable = TimetableEntry.new()
    @timetable.employee = @emp
    @timetable.subject = @subject
    @timetable.weekday = @Weekday5
    @timetable.class_timing = @class_timing
    @timetable.save
    @employeesubject =  EmployeesSubject.create!(:employee_id => @emp.id,:subject_id => @subject.id)
    TimetableEntry.employee(@subject).should eql(@employeesubject)
    @Timetable_entry = TimetableEntry.find_all_by_employee_id(@emp.id)
    TimetableEntry.day_find(Date.today,@Timetable_entry).count.should eql(0)

  end

end