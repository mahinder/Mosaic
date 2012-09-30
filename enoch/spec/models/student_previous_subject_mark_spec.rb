# == Schema Information
#
# Table name: student_previous_subject_marks
#
#  id         :integer         not null, primary key
#  student_id :integer
#  subject    :string(255)
#  mark       :string(255)
#

require 'spec_helper'

#Author : Puja
#Date : Nov 30th 2011

describe StudentPreviousSubjectMark do
  
  it "should respond to batch" do
    student_previous_subject_mark = StudentPreviousSubjectMark.create!(:student_id => "1")
    student_previous_subject_mark.should respond_to(:student)
  end
end
