require 'spec_helper'

describe AdditionalExamScore do
  before(:each) do
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 5
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
    @additional_examscore = AdditionalExamScore.new(:marks => 10)
    @grading = GradingLevel.create!(:name =>"A",:min_score => 90, :batch_id => nil, :is_deleted => false )
    @grading1 = GradingLevel.create!(:name =>"B",:min_score => 80, :batch_id => nil, :is_deleted => false)
    @grading2 = GradingLevel.create!(:name =>"C",:min_score => 70, :batch_id => nil, :is_deleted => false)
    @grading3 = GradingLevel.create!(:name =>"D",:min_score => 60, :batch_id => nil, :is_deleted => false)
    @grading4 = GradingLevel.create!(:name =>"E",:min_score => 50, :batch_id => nil, :is_deleted => false)
    @grading5 = GradingLevel.create!(:name =>"F",:min_score => 0, :batch_id => nil, :is_deleted => false)
  end

it "should have attribute" do
    @additional_examscore.should respond_to(:student)
    @additional_examscore.should respond_to(:additional_exam)
    @additional_examscore.should respond_to(:grading_level)
  end
  
  it "should call calculate_grade at save with marks" do
  # it return grading level  when exam type is marks and marks are not nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "g1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "g2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," <<  stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
     additional_examscore1 = AdditionalExamScore.new(:marks => 55, :student => stud1, :additional_exam =>  additional_exam)
    additional_examscore1.save!
    additional_examscore1.grading_level.should eql(@grading4)
  end

  it "should call calculate_grade at save without marks" do
  # it return grading level nill when exam type is marks and marks are  nil
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "g3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "g4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," <<  stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
     additional_examscore1 = AdditionalExamScore.new(:marks => "", :student => stud1, :additional_exam =>  additional_exam)
    additional_examscore1.save!
    additional_examscore1.grading_level.should eql(nil)

  end
end