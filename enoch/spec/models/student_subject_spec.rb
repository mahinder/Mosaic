require 'spec_helper'



describe StudentsSubject do
  before(:each) do
    @student_attr = {
      :first_name => "Puja",
      :last_name => "Punchouty",
      :admission_date => Date.today,
      :admission_no => "1234",
      :batch_id => "1",
      :date_of_birth => Date.today - 2190,
      :gender => "F",
      :email => "puja@ezzie.in"
    }
    @student = Student.create! (@student_attr)
    @subject_attr = {
      :name => "General Health",
      :code => "General Health",
      :no_exams => true ,
      :max_weekly_classes => 2,
      :batch_id => "1"
    }
    @subject = Subject.create! @subject_attr
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 4
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
    @student_subject_attr = {
      :student => @student,
      :subject => @subject,

    }
  end
  describe "validation" do
    it "student subject association should exist" do
      student_subject = StudentsSubject.new(@student_subject_attr)
      student_subject.should be_valid
    end
    it "should respond to student" do
      student_subject = StudentsSubject.new(@student_subject_attr)
      student_subject.should respond_to(:student)
    end
    it "should respond to subject" do
      student_subject = StudentsSubject.new(@student_subject_attr)
      student_subject.should respond_to(:subject)
    end
    it "should respond to batch_id" do
      student_subject = StudentsSubject.new(@student_subject_attr)
    end
  end
  describe "student assigned" do
    it "should respond to student assigned method" do
      student_subject = StudentsSubject.new(@student_subject_attr)
      student_subject.should respond_to(:student_assigned)
    end
    it "student assigned method should pass" do
      student_subject = StudentsSubject.create!(@student_subject_attr)
      expected_result =  StudentsSubject.find_by_student_id_and_subject_id(@student,@subject)
      result = student_subject.student_assigned(@student,@subject)
      result.should eql(expected_result)
    end
  end
end