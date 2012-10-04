# == Schema Information
#
# Table name: exam_scores
#
#  id               :integer         not null, primary key
#  student_id       :integer
#  exam_id          :integer
#  marks            :decimal(7, 2)
#  grading_level_id :integer
#  remarks          :string(255)
#  is_failed        :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe ExamScore do
  before(:each) do
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
    @grading = GradingLevel.create!(:name =>"A",:min_score => 90, :batch_id => nil, :is_deleted => false )
    @grading1 = GradingLevel.create!(:name =>"B",:min_score => 80, :batch_id => nil, :is_deleted => false)
    @grading2 = GradingLevel.create!(:name =>"C",:min_score => 70, :batch_id => nil, :is_deleted => false)
    @grading3 = GradingLevel.create!(:name =>"D",:min_score => 60, :batch_id => nil, :is_deleted => false)
    @grading4 = GradingLevel.create!(:name =>"E",:min_score => 50, :batch_id => nil, :is_deleted => false)
    @grading5 = GradingLevel.create!(:name =>"F",:min_score => 0, :batch_id => nil, :is_deleted => false)
  end

  it "should have attribute" do
    @examscore.should respond_to(:student)
    @examscore.should respond_to(:exam)
    @examscore.should respond_to(:grading_level)
  end
  
  it "should call calculate_grade at save with marks" do 
    # it return grading level  when exam type is marks and marks are not nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    ExamGroup.delete_all
    Exam.delete_all
    Student.delete_all
    User.delete_all
    
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "b11@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "b12@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 45, :student => stud1, :exam =>  exam)
    examscore1.save!
    examscore1.grading_level.should eql(@grading5)
    
  end
   
  it "should call calculate_grade at save without marks" do 
    # it return grading level nill when exam type is marks and marks are  nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    ExamGroup.delete_all
    Exam.delete_all
    Student.delete_all
    User.delete_all
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "b1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "b2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => nil, :student => stud1, :exam =>  exam)
    examscore1.save!
    examscore1.grading_level.should eql(nil)
    
  end
  
  it "should call calculate_percentage" do 
    # it return grading level nill when exam type is marks and marks are  nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    ExamGroup.delete_all
    Exam.delete_all
    Student.delete_all
    User.delete_all
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "b3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "b4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 10, :student => stud1, :exam =>  exam)
    examscore1.save!
    (examscore1.calculate_percentage).should eql(10.0)
    
  end
  
  it "should call batch_wise_aggregate" do 
    # it return grading level nill when exam type is marks and marks are  nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    ExamGroup.delete_all
    Exam.delete_all
    Student.delete_all
    User.delete_all
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "b5@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "b6@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 10, :student => stud1, :exam =>  exam)
    examscore1.save!
    (examscore1.batch_wise_aggregate(stud1,batch)).should eql(10.0)
    
       
  end

it "should call grouped_exam_subject_total with exam type" do 
    # it return grading level nill when exam type is marks and marks are  nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    ExamGroup.delete_all
    Exam.delete_all
    Student.delete_all
    User.delete_all
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "b7@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "b8@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 20, :student => stud1, :exam =>  exam)
    examscore1.save!
    (examscore1.grouped_exam_subject_total(subject,stud1,"marks")).should eql(20.0)
 end
 
it "should call grouped_exam_subject_total with grouped type" do 
    # it return grading level nill when exam type is marks and marks are  nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    ExamGroup.delete_all
    Exam.delete_all
    Student.delete_all
    User.delete_all
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    exam.exam_group = examgroup
    exam.save!
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "b9@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "b10@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 20, :student => stud1, :exam =>  exam)
    examscore1.save!
    GroupedExam.create!(:batch_id => b ,:exam_group_id =>  examgroup.id)
    (examscore1.grouped_exam_subject_total(subject,stud1,"grouped")).should eql(20.0)
 end


end
