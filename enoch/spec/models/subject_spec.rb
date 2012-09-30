# == Schema Information
#
# Table name: subjects
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  code               :string(255)
#  batch_id           :integer
#  no_exams           :boolean         default(FALSE)
#  max_weekly_classes :integer
#  elective_group_id  :integer
#  is_deleted         :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

#Author : Puja
#Date : Nov 29th 2011
describe Subject do
  
  before(:each) do
    @course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => -3
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
  # :name, :max_weekly_classes, :code, :batch_id,
  
  it "should have a batch attribute" do
    @subject.should respond_to(:batch)
  end
  
   it "should have a elective_group attribute" do
    @subject.should respond_to(:elective_group)
  end

  it "should have a name for subject" do
    no_name_subject = Subject.new(@subject_attr.merge(:name =>""))
    no_name_subject.should_not be_valid
  end
  
  it "should have a batch for subject" do
    no_batch_subject = Subject.new(@subject_attr.merge(:name =>"Test Name", :batch => nil))
    no_batch_subject.should_not be_valid
  end
 
  it "should have a code for subject" do
    no_code_subject = Subject.new(@subject_attr.merge(:name =>"Test Name", :code => ""))
    no_code_subject.should_not be_valid
  end
  
  it "should have max_no_of_classes for subject" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    no_no_of_classes_subject = Subject.new(@subject_attr.merge(:name =>"Test Name", :code => "Test", :max_weekly_classes => nil, :batch => batch))
    no_no_of_classes_subject.should_not be_valid
  end
  
  it "should have a valid number for max_no_of_classes for subject - positive" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    valid_no_of_classes_subject = Subject.new(@subject_attr.merge(:name =>"Test Name", :code => "Test", :max_weekly_classes => 10, :batch => batch))
    valid_no_of_classes_subject.should be_valid
  end
  
  it "should have a valid number for max_no_of_classes for subject - negative" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    not_valid_no_of_classes_subject = Subject.new(@subject_attr.merge(:name =>"Test Name", :code => "Test", :max_weekly_classes => "wrong input", :batch => batch))
    not_valid_no_of_classes_subject.should_not be_valid
  end
  
  it "should have a unique code - negative" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    subject = Subject.create!(@subject_attr.merge(:name =>"Mathematics", :code => "Maths", :max_weekly_classes => 10, :batch => batch))
    subject1 = Subject.new(@subject_attr.merge(:name =>"Mathematics", :code => "Maths", :max_weekly_classes => 10, :batch => batch))
    subject1.should_not be_valid
  end
  
  it "should have a unique code - positive" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    subject = Subject.create!(@subject_attr.merge(:name =>"Mathematics", :code => "Maths", :max_weekly_classes => 10, :batch => batch))
    subject1 = Subject.new(@subject_attr.merge(:name =>"Mathematics", :code => "Math", :max_weekly_classes => 10, :batch => batch))
    subject1.should be_valid
  end
  
  it "allow same subject code but for unique batches - positive" do
    batch = Batch.new :name => 'A', :start_date => 1.year.ago , :end_date => 1.month.ago
    batch2 = Batch.new :name => 'B', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.errors.messages.size.should eql(0)
    @course.save!
    subject = Subject.create!(@subject_attr.merge(:name =>"Mathematics", :code => "Maths", :max_weekly_classes => 10, :batch => batch))
    @course.batches = [batch2]
    @course.save!
    subject1 = Subject.new(@subject_attr.merge(:name =>"Mathematics", :code => "Maths", :max_weekly_classes => 10, :batch => batch2))
    subject1.should be_valid
  end
 
   it "should return all the subjects with no exams" do
    batch = Batch.new :name => 'C', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    subject1 = Subject.create!(@subject_attr.merge(:name =>"Mathematics", :code => "Maths", :max_weekly_classes => 10, :batch => batch, :no_exams => false))
    subject2 = Subject.create!(@subject_attr.merge(:name =>"Physics", :code => "Phy", :max_weekly_classes => 10, :batch => batch, :no_exams => false))
    subject3 = Subject.create!(@subject_attr.merge(:name =>"SST", :code => "SST", :max_weekly_classes => 10, :batch => batch, :no_exams => true))
    subjects = Subject.without_exams
    subjects.size.should eql (2)
  end
  
  it "for_batch method" do
    batch = Batch.new :name => 'D', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    subject1 = Subject.create!(@subject_attr.merge(:name =>"Chemistry", :code => "Chem", :max_weekly_classes => 10, :batch => batch, :no_exams => true))
    subject2 = Subject.create!(@subject_attr.merge(:name =>"Biology", :code => "Bio", :max_weekly_classes => 10, :batch => batch, :no_exams => true))
    subjects = Subject.for_batch b
    subjects.size.should eql (2)
  end
  
end
