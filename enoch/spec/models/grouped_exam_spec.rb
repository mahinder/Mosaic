# == Schema Information
#
# Table name: grouped_exams
#
#  id            :integer         not null, primary key
#  exam_group_id :integer
#  batch_id      :integer
#

require 'spec_helper'



describe GroupedExam do

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

  end

  it "should have many exam group" do
    # batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    # @course.batches = [batch]
    # @course.presence_of_initial_batch
    # @course.errors.messages.size.should eql(0)
    # @course.save!
    # b = batch.id
    # examgroup = ExamGroup.create!(:name => "math",:exam_type => "marks",:exam_date => 'December 1, 2011',:batch_id => b)
    # examgroup2 = ExamGroup.create!(:name => "science",:exam_type => "marks",:exam_date => 'December 2, 2011',:batch_id => b)
    # groupexam = GroupedExam.new(:batch_id => b,)
    # groupexam.save!
    # grouped = GroupedExam.find_by_exam_grouped_id(examgroup.id)
    
    
  end

end 
