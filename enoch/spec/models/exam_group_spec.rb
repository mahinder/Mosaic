# == Schema Information
#
# Table name: exam_groups
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  batch_id         :integer
#  exam_type        :string(255)
#  is_published     :boolean         default(FALSE)
#  result_published :boolean         default(FALSE)
#  exam_date        :date
#

require 'spec_helper'

describe ExamGroup do

  before(:each) do
    exam_group_attr = {
      :name => "math",
      :exam_type => "marks",
      :exam_date => 'December 1, 2011'
    }
    @examgroup = ExamGroup.new(exam_group_attr)

    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 4
    }
    Student.delete_all
    User.delete_all

    exam_attr = {
      :start_time => "December 1, 2011 09:00 AM",
      :end_time => "December 1, 2011 11:33 AM",
      :maximum_marks => 100,
      :minimum_marks => 33
    }

    @course = Course.new @course_attr
    @exam = Exam.new(exam_attr)
    @examscore = ExamScore.new(:marks => 10)
  end

  it "should have attribute" do
    @examgroup.should respond_to(:batch)
    @examgroup.should respond_to(:maximum_marks)
    @examgroup.should respond_to(:maximum_marks)
    @examgroup.should respond_to(:minimum_marks)
    @examgroup.should respond_to(:weightage)
  end

  it"has many exams" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam1= Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam2= Exam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    examgroup.exams = [exam1,exam2]
    examgroup.save!
    examgroup.exams.should include(exam1)
    examgroup.exams.should include(exam2)
    examgroup.destroy
    examgroup.exams.should_not include(exam1)
    examgroup.exams.should_not include(exam2)
  end
  it "should test examdate before save " do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam1= Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam2= Exam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    examgroup.exams = [exam1,exam2]
    examgroup.save!
    (examgroup.exam_date).should eql(('December 1, 2011').to_date)
  end

  it "should test nil  examdate before save " do

    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => nil,:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam1= Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam2= Exam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    examgroup.exams = [exam1,exam2]
    examgroup.save!
    (examgroup.exam_date).should eql(Date.today)
  end

  it"should have name" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.new(:name => "",:exam_type => "marks",:exam_date => nil,:batch_id => b)
    (examgroup).should_not be_valid
  end

  it"should test total_marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "a7@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "a8@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 45)
    examscore1.student_id = stud1.id
    examscore1.exam =  exam
    examscore1.save!
    examm = examgroup.total_marks(stud1)
    examm[0].to_s.should eql("45.0")
    examm[1].to_s.should eql("100.0")
  end

  it"should test archived_total_marks return 0 when there is no archivied exam score" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahinderctv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "a5@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "a6@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 45)
    examscore1.student_id = stud1.id
    examscore1.exam =  exam
    examscore1.save!
    examm = examgroup.archived_total_marks(stud1)
    examm[0].to_s.should eql("0")
    examm[1].to_s.should eql("0")
  end

  it"should test :exam_groupsarchived_total_marks return 0 when there is archivied exam score" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 =  ArchivedStudent.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 =  ArchivedStudent.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ArchivedExamScore.new(:marks => 45)
    examscore1.student_id = stud1.id
    examscore1.exam =  exam
    examscore1.save!
    examm = examgroup.archived_total_marks(stud1)
    examm[0].to_s.should eql("45.0")
    examm[1].to_s.should eql("100.0")
  end

  it"should test batch_average_marks" do
    User.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam1= Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam2= Exam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    examgroup.exams = [exam1,exam2]
    examgroup.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:gender => "m",:email => "a1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:gender => "m",:email => "a2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore = ExamScore.new(:marks => 45)
    examscore.student_id = stud1.id
    examscore.exam =  exam1
    examscore.save!
    examscore = ExamScore.new(:marks => 50)
    examscore.student_id = stud2.id
    examscore.exam =  exam1
    examscore.save!
    examm = examgroup.batch_average_marks('marks')
    examm.should eql(47.5)
    

  end
  
  it "should create associated user along with the student and update user id in Student record" do
   batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam1= Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam2= Exam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    examgroup.exams = [exam1,exam2]
    examgroup.save!
    examgroup_for_exam = Exam.find_by_exam_group_id(examgroup.id)
    examgroup_for_exam.should_not be_blank
    examgroup_for_exam.id.should eql(examgroup.id)
    
   end
  
   it"should test subject_wise_batch_average_marks" do
    User.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam1= Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam2= Exam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    examgroup.exams = [exam1,exam2]
    examgroup.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:gender => "m",:email => "a3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:gender => "m",:email => "a4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    batch.students = [stud1,stud2]
    examscore = ExamScore.new(:marks => 45)
    examscore.student_id = stud1.id
    examscore.exam =  exam1
    examscore.save!
    examscore = ExamScore.new(:marks => 50)
    examscore.student_id = stud2.id
    examscore.exam =  exam1
    examscore.save!
    examm = examgroup.subject_wise_batch_average_marks(subject.id)
    examm.should eql(47.5)
   end
  
end
