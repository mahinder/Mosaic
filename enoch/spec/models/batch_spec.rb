require 'spec_helper'

describe Batch do

  before(:each) do
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 2
    }

    @batch_attr = {
      :name => "A",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }
    @subject_attr = {
      :name => "General Health",
      :code => "General Health",
      :no_exams => true ,
      :max_weekly_classes => 2
    }
    @batch = Batch.new @batch_attr
    @course = Course.new @course_attr
    @subject = Subject.new @subject_attr
  end

  it "should return Timetable entry" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    @subject.batch = batch
    @subject.save!
    @class_timing = ClassTiming.create!(:name => "1" ,:start_time => "04:00 AM", :end_time => "05:00 AM")
    @timetable_entry = TimetableEntry.create!(:batch_id => batch.id , :class_timing_id => @class_timing.id,:weekday_id => 1,:subject_id => @subject.id )
    @batch = batch
    (@batch.time_entry(@subject).should include(@timetable_entry))
  end
  
  
  
  it "should have a instance of Course before new instance of batch" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
  end

  it "should have a batch name attribute" do
    @batch.should respond_to(:name)
  end

  it "should have a course attribute" do
    @batch.should respond_to(:course)
  end

  it "should have a start_date attribute" do
    @batch.should respond_to(:start_date)
  end

  it "should have a end_date attribute" do
    @batch.should respond_to(:end_date)
  end

  it "batch should be created and able to access method of courses and itself" do
    batch1 = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    batch2 = Batch.new :name => 'A', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch1]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    @course.batches = [batch2]
    @course.save!
    (batch2.course_name).should eql("Grade 9")
    (batch2.section_name).should eql("A")
    (batch2.code).should eql("9th")
    (batch2.full_name).should eql("9th - A")
    batch2.inactivate
    (batch2.is_deleted).should be_true
  end

  it "should have validate" do
    @batch.should respond_to(:validate)
  end

  it "should have full_name method" do
    @batch.should respond_to(:full_name)
  end

  it "should have course_section_name" do
    @batch.should respond_to(:course_section_name)
  end

  it "should have inactivate" do
    @batch.should respond_to(:inactivate)
  end

  it "should have grading_level_list" do
    @batch.should respond_to(:grading_level_list)
  end

  it "should have fee_collection_dates" do
    @batch.should respond_to(:fee_collection_dates)
  end

  it "should have all_students" do
    @batch.should respond_to(:all_students)
  end

  it "should have normal_batch_subject" do
    @batch.should respond_to(:normal_batch_subject)
  end

  it "should have elective_batch_subject" do
    @batch.should respond_to(:elective_batch_subject)
  end

  it "should have time_entry" do
    @batch.should respond_to(:time_entry)
  end
  it "should have grading_level_list" do
    @batch.should respond_to(:grading_levels)
  end

  it "should generate error when start_date is less then end_date" do
    batch = Batch.new :name => 'Maths', :start_date => 1.month.ago , :end_date => 2.month.ago
    @course.batches = [batch]
    expect {@course.save!}.should raise_exception (ActiveRecord::RecordInvalid )
  end

  it "should return default grading if batch is not contain any gradinglevel" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    grading = GradingLevel.create!(:name =>"D",:min_score => 10)
    gardinglevels =  batch.grading_level_list
    gardinglevels.should include(grading)
  end

  it "should return its own grading if batch is  containing any gradinglevel" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    grading = GradingLevel.create!(:name =>"E",:batch_id => batch.id ,:min_score => 10)
    gardinglevels =  batch.grading_level_list
    gardinglevels.should include(grading)

  end
  it "should be empty if it has no any graging level and default level" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    gardinglevels =  batch.grading_level_list
    gardinglevels.should be_empty
  end

  it "should be empty if it has no any student" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    students =  batch.all_students
    students.should be_empty
  end

  it "should return students with valid batch id  if it has  any student" do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    newstud = User.new(:username =>"mahinddfgdfdferrtr",:password => "mahinder",:email =>"dhjfgdfdfgatttrsd@jdhdhd.com",:role =>"Student")
    stud = Student.new(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no => 1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "e1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago)
    stud.user = newstud
    stud.save!
    students =  batch.all_students
    students.should include(stud)
    Student.delete_all
  end

  it "should be empty if it has no any subjects" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    subjects =  batch.normal_batch_subject
    subjects.should be_empty
  end

  it "should return subjects with valid batch_id" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    subject = Subject.create!(:name => "match",:code =>"101",:batch_id => b,:max_weekly_classes => 5)
    subjects =  batch.normal_batch_subject
    subjects.should include(subject)
  end

  it "should return subjects with valid batch_id and elective group_id" do
    Batch.delete_all
    User.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    elective_group = ElectiveGroup.create(:name => "abc",:batch_id => b)

    subject = Subject.create!(:name => "match",:code =>"101",:batch_id => b,:max_weekly_classes => 5,:elective_group_id => elective_group.id)
    subjects =  batch.elective_batch_subject(elective_group)
    subjects.should include(subject)
  end

  it "should create fee category with valid batch_id" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    fee_cat = FinanceFeeCategory.new(:name => "lab")
    str = batch.fee_category = [fee_cat]
    str.should include(fee_cat)
  end

  it "should create archived student with valid batch_id" do
    batch = Batch.new :name => 'Science', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    stud = ArchivedStudent.new(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "e2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago)
    str = batch.archived_students = [stud]
    str.should include(stud)
    ArchivedStudent.delete_all

  end
  it "should create finance transation  through student" do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    stud = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "e3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago)
    category = FinanceTransactionCategory.create!(:name => "abcd")
    finance = FinanceTransaction.create!(:title => "abc", :amount => 500, :student_id => stud.id, :category_id => category.id,:transaction_date => 1.day.ago )
    stud.finance_transactions = [finance]
    batch.students = [stud]
    batch.finance_transactions.should include(finance)
    Student.delete_all
  end

  it "should create subjects with valid batch_id" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    subject = Subject.new(:name => "match",:code =>"101",:max_weekly_classes => 5)
    subjects = batch.subjects = [subject]
    subjects.should include(subject)
  end

  it "should create its own grading " do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    grading = GradingLevel.new(:name =>"E",:min_score => 10)
    gardinglevels =  batch.grading_levels = [grading]
    gardinglevels.should include(grading)

  end

  it "should create exam group " do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    exam = ExamGroup.new(:name =>"Math",:exam_type => "Marks" ,:exam_date =>-2.day.ago)
    exams =  batch.exam_groups = [exam]
    exams.should include(exam)
  end

  it "should create elective_groups " do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    elective = ElectiveGroup.new(:name =>"Math")
    electives =  batch.elective_groups = [elective]
    electives.should include(elective)
  end

  it "should create additional_exam_groups " do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    newstud = User.new(:username =>"mahinddfgdfdfer",:password => "mahinder",:email =>"dhjfgdfdfgattt@jdhdhd.com",:role =>"Student")
    stud = Student.new(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "e4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago)
    stud.user = newstud
    stud.save!
    c = stud.id
    additional_exam_group = AdditionalExamGroup.new(:name =>"Math",:exam_type => "Marks", :exam_date => -2.day.ago, :students_list => c)
    additional_exam_groups  = batch.additional_exam_groups = [additional_exam_group]
    additional_exam_groups.should include(additional_exam_group )
    Student.delete_all
  end

  it "should pass for scope test for active" do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago, :is_deleted => false, :is_active => true
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    active_batch = Batch.active
    active_batch.should include(batch)
  end

  it "should pass for scope test delete" do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago, :is_deleted => true, :is_active => true
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    Batch.deleted
    active_batch = Batch.active
    active_batch.should_not include(batch)

  end

  it "should has an many :graduated_students" do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    newstud = User.new(:username =>"mahinddfgdfdferrtr",:password => "mahinder",:email =>"dhjfgdfdfgatttrsd@jdhdhd.com",:role =>"Student")
    stud = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "e5@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:user => newstud)
    batch.graduated_students  = [stud]
    Student.delete_all
  end
end
