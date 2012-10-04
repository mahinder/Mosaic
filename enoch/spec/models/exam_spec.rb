# == Schema Information
#
# Table name: exams
#
#  id               :integer         not null, primary key
#  exam_group_id    :integer
#  subject_id       :integer
#  start_time       :datetime
#  end_time         :datetime
#  maximum_marks    :decimal(, )
#  minimum_marks    :decimal(, )
#  grading_level_id :integer
#  weightage        :integer         default(0)
#  event_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Exam do
  before(:each) do
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 4
    }
    Student.delete_all
    User.delete_all
    @batch_attr = {
      :name => "A",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }

    exam_attr = {
      :start_time => "December 1, 2011 09:00 AM",
      :end_time => "December 1, 2011 11:33 AM",
      :maximum_marks => 100,
      :minimum_marks => 33
    }

    exam_group_attr = {
      :name => "math",
      :exam_type => "marks",
      :exam_date => 'December 1, 2011'
    }
    @batch = Batch.new @batch_attr
    @course = Course.new @course_attr
    @exam = Exam.new(exam_attr)

    @grading = GradingLevel.create!(:name =>"A",:min_score => 90, :batch_id => nil, :is_deleted => false )

    @grading1 = GradingLevel.create!(:name =>"B",:min_score => 80, :batch_id => nil, :is_deleted => false)

    @grading2 = GradingLevel.create!(:name =>"C",:min_score => 70, :batch_id => nil, :is_deleted => false)

    @grading3 = GradingLevel.create!(:name =>"D",:min_score => 60, :batch_id => nil, :is_deleted => false)

    @grading4 = GradingLevel.create!(:name =>"E",:min_score => 50, :batch_id => nil, :is_deleted => false)

    @grading5 = GradingLevel.create!(:name =>"F",:min_score => 0, :batch_id => nil, :is_deleted => false)
  end

  it "should have many exam_group" do
    @exam.should respond_to(:exam_group)
  end

it "should pereform before_save :update_exam_group_date, :weight, :updateexam" do
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
    examobj = Exam.find_by_exam_group_id(examgroup.id)
    examobj.exam_group.should eql(examgroup)
    # self.weightage = 0 if self.weightage.nil? here weightage is nil then weightage should be 0
    exam.weightage.should eql(0)
    #if group.exam_date is not null  and start_time is less then group.exam_date then update_exam_group_date   method converts  exam_date string to date datatype
    (examgroup.exam_date).should eql(('December 1, 2011').to_date)
    # if event is nil then it create event and assign  to exam
    (exam.event).should_not be_nil

  end

  it "should have attribute" do
    @exam.should respond_to(:subject)
    @exam.should respond_to(:event)
    @exam.should respond_to(:exam_scores)
    @exam.should respond_to(:archived_exam_scores)
    @exam.should respond_to(:exam_group)
  end

  it"should have start_time,endtime, minimum_marks, maximum_marks" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33)
    exam.exam_group = examgroup
    exam.should be_valid
  end

  it"should not start_time greater then  endtime" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => 'December 1, 2011 11:33 AM',:end_time => 'December 1, 2011 09:00 AM', :maximum_marks => 120, :minimum_marks => 33)
    exam.exam_group = examgroup
    exam.should_not be_valid
  end

  it"should not minimum_marks greater then  maximum_marks" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 12, :minimum_marks => 33)
    exam.exam_group = examgroup
    exam.should_not be_valid
  end
  
  it"should not have  null start_time" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => '',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33)
    #exam.exam_group = examgroup
    exam.should_not be_valid

  end
  it"should not have  null endtime" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => '', :maximum_marks => 100, :minimum_marks => 33)
    exam.exam_group = examgroup
    exam.should_not be_valid
  end
  it"should not have  null minimum_marks" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => nil, :minimum_marks => 33)
    exam.exam_group = examgroup
    exam.should_not be_valid
  end
  it"should not have  null  maximum_marks" do
    examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011')
    exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => nil)
    exam.exam_group = examgroup
    exam.should_not be_valid
  end

  it "has_many examscore" do
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
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "c1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "c2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    examscore1 = ExamScore.new(:marks => 45)
    examscore1.student_id = stud1.id
    examscore1.exam =  exam
    examscore1.save!
    examscore2 = ExamScore.new(:marks => 50)
    examscore2.student_id = stud2.id
    examscore2.exam =  exam
    examscore2.save!
    exam.exam_scores.should include(examscore1,examscore2)
    (exam.score_for(stud1.id)).should eql(examscore1)
  end

  describe "class_average_marks" do

    before(:each) do

      batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
      @course.batches = [batch]
      @course.presence_of_initial_batch
      @course.errors.messages.size.should eql(0)
      @course.save!
      b = batch.id
      examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
      subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
      @exam = Exam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
      @exam.exam_group = examgroup
      @exam.save!
      @stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "c3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
      @stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "c4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)

    end

    it"should return score when score size is not zero " do
      examscore1 = ExamScore.new(:marks => 45)
      examscore1.student_id = @stud1.id
      examscore1.exam =  @exam
      examscore1.save!
      examscore2 = ExamScore.new(:marks => 50)
      examscore2.student_id = @stud2.id
      examscore2.exam =  @exam
      examscore2.save!
      (@exam.class_average_marks).should_not be_zero
    end

    it"should return zero when score size is  zero " do
      examscore1 = ExamScore.new(:marks => 0)
      examscore1.student_id = @stud1.id
      examscore1.exam =  @exam
      examscore1.save!
      examscore2 = ExamScore.new(:marks => 0)
      examscore2.student_id = @stud2.id
      examscore2.exam =  @exam
      examscore2.save!
      (@exam.class_average_marks).should be_zero
    end

    it"should return value when score size is not zero for negetive marks  " do
      examscore1 = ExamScore.new(:marks => -1)
      examscore1.student_id = @stud1.id
      examscore1.exam =  @exam
      examscore1.save!
      examscore2 = ExamScore.new(:marks => -6)
      examscore2.student_id = @stud2.id
      examscore2.exam =  @exam
      examscore2.save!
      (@exam.class_average_marks).should_not be_zero
    end

    it"return true when score marks is nil" do
      examscore2 = ExamScore.new(:marks => nil)
      examscore2.student_id = @stud2.id
      examscore2.exam =  @exam
      examscore2.save!
      (@exam.destroy).should be_true
    end
    
    it"return false when score marks is not nil" do
      examscore2 = ExamScore.new(:marks => 10)
      examscore2.student_id = @stud2.id
      examscore2.exam =  @exam
      examscore2.save!
      (@exam.destroy).should be_false
    end

    it"should has many archived_exam_scores" do
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
      stud1 = ArchivedStudent.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:gender => "m",:email => "c5@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
      stud2 = ArchivedStudent.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:gender => "m",:email => "c6@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
      examscore = ArchivedExamScore.new(:marks => 45)
      examscore.student_id = stud1.id
      examscore.exam =  exam
      examscore.save!
      examscore1 = ArchivedExamScore.new(:marks => 50)
      examscore1.student_id = stud2.id
      examscore1.exam =  exam
      examscore1.save!
      (exam.archived_exam_scores).should include(examscore)
      (exam.archived_exam_scores).should include(examscore1)
    end
  end
end
