require 'spec_helper'



describe AdditionalExamGroup do

  before(:each) do
    additional_exam_group_attr = {
      :name => "math",
      :exam_type => "marks",
      :exam_date => 'December 1, 2011'
    }
    @additional_examgroup = AdditionalExamGroup.new(additional_exam_group_attr)

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
    @additional_examgroup.should respond_to(:batch)
    @additional_examgroup.should respond_to(:maximum_marks)
    @additional_examgroup.should respond_to(:maximum_marks)
    @additional_examgroup.should respond_to(:minimum_marks)
    @additional_examgroup.should respond_to(:weightage)
  end

  it"has many additional_exams" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud )
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam1= AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam2= AdditionalExam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_examgroup.additional_exams = [additional_exam1,additional_exam2]
    additional_examgroup.save!
    additional_examgroup.additional_exams.should include(additional_exam1)
    additional_examgroup.additional_exams.should include(additional_exam2)
    additional_examgroup.destroy
    additional_examgroup.additional_exams.should_not include(additional_exam1)
    additional_examgroup.additional_exams.should_not include(additional_exam2)
  end

  it "should test nil  examdate before save " do

    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => '',:batch_id => b, :students_list => allstud )
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam1= AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam2= AdditionalExam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_examgroup.additional_exams = [additional_exam1,additional_exam2]
    additional_examgroup.save!
    (additional_examgroup.exam_date).should eql(Date.today)
  end

it "should test given  examdate before save " do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f5@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f6@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud )
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam1= AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam2= AdditionalExam.new(:start_time => 'December 2, 2011 09:00 AM',:end_time => 'December 2, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_examgroup.additional_exams = [additional_exam1,additional_exam2]
    additional_examgroup.save!
    (additional_examgroup.exam_date).should eql(('December 1, 2011').to_date)
  end

  it"should have name" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f7@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f8@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additionalexamgroup = AdditionalExamGroup.new(:name => "",:exam_type => "marks",:exam_date => nil,:batch_id => b, :students_list => allstud)
    (additionalexamgroup).should_not be_valid
  end

  it"should have students list" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f9@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f10@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    additionalexamgroup = AdditionalExamGroup.new(:name => "annual",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => "")
    (additionalexamgroup).should_not be_valid
  end

  it"should call students method" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f11@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f12@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additionalexamgroup = AdditionalExamGroup.new(:name => "annual",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    additionalexamgroup.save!
    (additionalexamgroup.students).should include(stud1,stud2)
  end

  it"should call removeable at destroy when AdditionalExamScore have marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f14@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f15@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," <<  stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
     additional_examscore1 = AdditionalExamScore.new(:marks => 55, :student => stud1, :additional_exam =>  additional_exam)
    additional_examscore1.save!
    additional_examgroup.removable?.should be_false

  end

 it"should call removeable at destroy when AdditionalExamScore have marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "f16@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "f17@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," <<  stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "MarksAndGrades",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
     additional_examscore1 = AdditionalExamScore.new(:marks => "", :student => stud1, :additional_exam =>  additional_exam)
    additional_examscore1.save!
    additional_examgroup.removable?.should be_true
 end
 
end


