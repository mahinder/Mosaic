# == Schema Information
#
# Table name: elective_groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  batch_id   :integer
#  is_deleted :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'
#Author : Puja
#Date : Nov 29th 2011

describe ElectiveGroup do
  
  before(:each) do
    @course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 4
    }

    @batch_attr = {
      :name => "A",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }
    
    @elective_group_attr = {
      :name => "Physical Education"
    }
  
    @subject_attr = {
      :name => "General Health",
      :code => "General Health",
      :no_exams => true ,
      :max_weekly_classes => 2
      
    }  
    @batch = Batch.new @batch_attr
    @course = Course.new @course_attr
    @elective_group = ElectiveGroup.new @elective_group_attr
    @subject = Subject.new @subject_attr
    
  end
  
  after(:each) do
    
  end
  
  it "should have a batch attribute" do
    @elective_group.should respond_to(:batch)
  end

  it "should have a name for elective group" do
    no_name_elective_group = ElectiveGroup.new(@elective_group_attr.merge(:name =>""))
    no_name_elective_group.should_not be_valid
  end
  
  it "should have a batch for elective group" do
    no_batch_elective_group = ElectiveGroup.new(@elective_group_attr.merge(:name =>"Physical Education", :batch => nil))
    no_batch_elective_group.should_not be_valid
  end
  
  it "should have a instance of Batch before new instance of Elective Group - negative" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    expect {ElectiveGroup.create!(:name => "Physical Education")}.to raise_exception (ActiveRecord::RecordInvalid )
  end
     
  it "should have a instance of Batch before new instance of Elective Group - positive" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    expect {ElectiveGroup.create!(:name => "Physical Education", :batch => batch)}.not_to raise_exception (ActiveRecord::RecordInvalid )
  end
  
  it "should have no, one or many subjects" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    elective_group = ElectiveGroup.create!(:name => "Foriegn Language", :batch => batch)
    subject1 = Subject.create!(:name => "French", :code => "French", :max_weekly_classes => 2, :no_exams => true, :batch => batch) 
    subject2 = Subject.create!(:name => "Spanish", :code => "Spanish", :max_weekly_classes => 2, :no_exams => true, :batch => batch)
    elective_group.subjects = [subject1]
    elective_group.subjects = [subject2]
    elective_group.save!
  end
  
  it "inactivate method should mark the elective group as inactive (deleted true)" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    elective_group = ElectiveGroup.create!(:name => "Foriegn Languages", :batch => batch)
    elective_group.inactivate
    elective_group.is_deleted.should eql (true)
  end
  
  it "for_batch method" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    elective_group = ElectiveGroup.create!(:name => "Foreign Languages", :batch => batch)
    elective_groups = ElectiveGroup.for_batch b
    elective_groups.should include(elective_group)
  end
end
