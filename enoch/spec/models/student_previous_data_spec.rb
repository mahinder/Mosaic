# == Schema Information
#
# Table name: student_previous_data
#
#  id          :integer         not null, primary key
#  student_id  :integer
#  institution :string(255)
#  year        :string(255)
#  course      :string(255)
#  total_mark  :string(255)
#

require 'spec_helper'

describe StudentPreviousData do 
  
  before(:each) do
    @attr = { :institution => "Pratap Public School"}
  end
   
  it "should create student previous Data" do
    StudentPreviousData.create!(@attr) 
  end
  
  it "should respond to" do
    @st_pr_da=StudentPreviousData.create!(@attr) 
    @st_pr_da.should respond_to(:institution)
    @st_pr_da.should respond_to(:student)
  end
  
  it "should belong to student" do  
    @batch = Batch.create!(:name => "Class1", :start_date => 1.year.ago, :end_date => 1.month.ago)
    @student =Student.create!(:admission_no => "26",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.year.ago,
    :gender => "M")
    @st_pr_da=StudentPreviousData.create!(:institution => "Pratap Public School", :student => @student)
    @st_pr_da.should be_valid
  end
end
