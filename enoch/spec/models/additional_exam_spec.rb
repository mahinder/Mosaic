require 'spec_helper'



describe AdditionalExam do
  before(:each) do
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 3
    }
    Student.delete_all
    User.delete_all
    @batch_attr = {
      :name => "A",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }

    additional_exam_attr = {
      :start_time => "December 1, 2011 09:00 AM",
      :end_time => "December 1, 2011 11:33 AM",
      :maximum_marks => 100,
      :minimum_marks => 33
    }

    additional_exam_group_attr = {
      :name => "math",
      :exam_type => "marks",
      :exam_date => 'December 1, 2011'
    }
    @batch = Batch.new @batch_attr
    @course = Course.new @course_attr
    @additional_exam = AdditionalExam.new(additional_exam_attr)
    @grading = GradingLevel.create!(:name =>"A",:min_score => 90, :batch_id => nil, :is_deleted => false )
    @grading1 = GradingLevel.create!(:name =>"B",:min_score => 80, :batch_id => nil, :is_deleted => false)
    @grading2 = GradingLevel.create!(:name =>"C",:min_score => 70, :batch_id => nil, :is_deleted => false)
    @grading3 = GradingLevel.create!(:name =>"D",:min_score => 60, :batch_id => nil, :is_deleted => false)
    @grading4 = GradingLevel.create!(:name =>"E",:min_score => 50, :batch_id => nil, :is_deleted => false)
    @grading5 = GradingLevel.create!(:name =>"F",:min_score => 0, :batch_id => nil, :is_deleted => false)
 end


it "should pereform before_save :weight, :updateexam" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d1@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d2@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.create!(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject, :additional_exam_group => additional_examgroup )
    examobj = AdditionalExam.find_by_additional_exam_group_id(additional_examgroup.id)
    examobj.additional_exam_group.should eql(additional_examgroup)
    # self.weightage = 0 if self.weightage.nil? here weightage is nil then weightage should be 0
    additional_exam.weightage.should eql(0)
    #if group.exam_date is not null  and start_time is less then group.exam_date then update_exam_group_date   method converts  exam_date string to date datatype
    (additional_examgroup.exam_date).should eql(('December 1, 2011').to_date)
    # if event is nil then it create event and assign  to exam
    (additional_exam.event).should_not be_nil

  end

  it "should have attribute" do
    @additional_exam.should respond_to(:subject)
    @additional_exam.should respond_to(:event)
    @additional_exam.should respond_to(:additional_exam_group)
    @additional_exam.should respond_to(:removable?)
  end

  it"should have start_time,endtime, minimum_marks, maximum_marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d3@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d4@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam =  AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33, :additional_exam_group => additional_examgroup)
    additional_exam.should be_valid
  end

  it"should not start_time greater then  endtime" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d5@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d6@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 11:33 AM',:end_time => 'December 1, 2011 09:00 AM', :maximum_marks => 120, :minimum_marks => 33, :additional_exam_group => additional_examgroup)
    additional_exam.should_not be_valid
  end

  it"should not minimum_marks greater then  maximum_marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d7@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d8@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 12, :minimum_marks => 33, :additional_exam_group => additional_examgroup)
    additional_exam.should_not be_valid
  end

  it"should not have  null start_time" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d9@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d10@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam = AdditionalExam.new(:start_time => '',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33, :additional_exam_group => additional_examgroup)
    additional_exam.should_not be_valid

  end
  it"should not have  null endtime" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d11@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d12@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
     allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => '', :maximum_marks => 100, :minimum_marks => 33, :additional_exam_group => additional_examgroup)
    additional_exam.should_not be_valid
  end
  it"should not have  null minimum_marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d13@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d14@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => nil, :minimum_marks => 33, :additional_exam_group => additional_examgroup)
    additional_exam.should_not be_valid
  end
  it"should not have  null  maximum_marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d15@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d16@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup =  AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011', :students_list => allstud)
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => nil, :additional_exam_group => additional_examgroup)
    additional_exam.should_not be_valid
  end

  it "has_many additional_exam_scores reject score for empty marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d17@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d18@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
    additional_examscore1 = AdditionalExamScore.new(:marks => 45)
    additional_examscore1.student_id = stud1.id
    additional_examscore1.additional_exam =  additional_exam
    additional_examscore1.save!
    additional_examscore2 = AdditionalExamScore.new(:marks => 50)
    additional_examscore2.student_id = stud2.id
    additional_examscore2.additional_exam =  additional_exam
    additional_examscore2.save!
    additional_exam.additional_exam_scores.should include(additional_examscore1)
    additional_exam.additional_exam_scores.should include(additional_examscore2)
    (additional_exam.score_for(stud1.id)).should eql(additional_examscore1)

  end
  
   it "reject score for empty marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d19@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d20@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
     allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
    additional_examscore1 = AdditionalExamScore.new(:marks => "")
    additional_examscore1.student_id = stud1.id
    additional_examscore1.additional_exam =  additional_exam
    additional_examscore1.save!
    additional_examscore2 = AdditionalExamScore.new(:marks => "")
    additional_examscore2.student_id = stud2.id
    additional_examscore2.additional_exam =  additional_exam
    additional_examscore2.save!
    additional_examscore1.should be_valid
   (additional_exam.destroy).should be_true
  end
  
   it "not reject score for  marks" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    b = batch.id
    stud1 = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "d21@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
    stud2 = Student.create!(:first_name => "mahindercvfff kumar",:last_name =>"kumarcvb",:admission_no=>2,:class_roll_no =>121,:batch_id => b,:gender => "m",:email => "d22@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:batch => batch)
     allstud = stud1.id.to_s << "," << stud2.id.to_s
    additional_examgroup = AdditionalExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b, :students_list => allstud)
    subject = Subject.create!(:name => "math", :code => "101", :batch => batch, :max_weekly_classes => 5 )
    additional_exam = AdditionalExam.new(:start_time => 'December 1, 2011 09:00 AM',:end_time => 'December 1, 2011 11:33 AM', :maximum_marks => 100, :minimum_marks => 33,:subject => subject )
    additional_exam.additional_exam_group = additional_examgroup
    additional_exam.save!
    additional_examscore1 = AdditionalExamScore.new(:marks => 50)
    additional_examscore1.student_id = stud1.id
    additional_examscore1.additional_exam =  additional_exam
    additional_examscore1.save!
    additional_examscore2 = AdditionalExamScore.new(:marks => 60)
    additional_examscore2.student_id = stud2.id
    additional_examscore2.additional_exam =  additional_exam
    additional_examscore2.save!
    additional_examscore1.should be_valid
   (additional_exam.destroy).should be_false
  end
end
