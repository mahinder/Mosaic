# == Schema Information
#
# Table name: grading_levels
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  batch_id   :integer
#  min_score  :integer
#  order      :integer
#  is_deleted :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'


describe GradingLevel do

  before(:each) do
    @grading_attr ={
      :name =>"g",
      :min_score => 10
    }
  GradingLevel.delete_all
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 4
    }
    @course = Course.new @course_attr
    
    @grading = GradingLevel.create!(:name =>"A",:min_score => 90, :batch_id => nil, :is_deleted => false )
    
    @grading1 = GradingLevel.create!(:name =>"B",:min_score => 80, :batch_id => nil, :is_deleted => false)
    
    @grading2 = GradingLevel.create!(:name =>"C",:min_score => 70, :batch_id => nil, :is_deleted => false)
    
    @grading3 = GradingLevel.create!(:name =>"D",:min_score => 60, :batch_id => nil, :is_deleted => false)
    
    @grading4 = GradingLevel.create!(:name =>"E",:min_score => 50, :batch_id => nil, :is_deleted => false)
    
    @grading5 = GradingLevel.create!(:name =>"F",:min_score => 0, :batch_id => nil, :is_deleted => false)
    
  end

  it "should belongs to batch" do
    GradingLevel.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    grading = GradingLevel.new(@grading_attr)
    grading.batch = batch
    grading.save!
    grading.batch.should eql(batch)
  end

  it "should validate presence of name" do
    grading = GradingLevel.new(@grading_attr.merge(:name => ""))
    lambda{grading.save!}.should raise_error(ActiveRecord::RecordInvalid )
  end

  it "should validate presence of minscore" do
    grading = GradingLevel.new(@grading_attr.merge(:min_score => ""))
    lambda{grading.save!}.should raise_error(ActiveRecord::RecordInvalid )
  end

  it "should pass for scope test for :default" do
    grading = GradingLevel.create!(:name =>"h",:min_score => 10)
    gardinglevels =  GradingLevel.default
    gardinglevels.should include(grading)
  end

  it "should pass for scope test for for_batch" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    grading = GradingLevel.create!(:name =>"h",:min_score => 10,:batch => batch)
    gardinglevels =  GradingLevel.for_batch b
    gardinglevels.should include(grading)
  end

  it "should have inactivate method" do
    grading = GradingLevel.create!(:name =>"h",:min_score => 10)
    grading.should respond_to(:inactivate)
  end

  it "should perform inactivate method" do
    grading = GradingLevel.create!(:name =>"h",:min_score => 10)
    grading.is_deleted.should be_false
    grading.inactivate
    grading.is_deleted.should be_true
  end

  it "should have exists_for_batch? method" do
    GradingLevel.should respond_to(:exists_for_batch?)
  end

  it "should return false when grading level is empty" do
    GradingLevel.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    grading_levels = GradingLevel.exists_for_batch? b
    grading_levels.should be_false
  end

  it "should return true when  grading level  is there" do
    GradingLevel.delete_all
    grading = GradingLevel.create!(:name =>"h",:min_score => 10)
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    GradingLevel.delete_all
    grading = GradingLevel.create!(:name =>"h",:min_score => 10,:batch => batch)
    grading_levels = GradingLevel.exists_for_batch? b
    grading_levels.should be_true
  end

  it "should have exists_for_batch? method" do
    GradingLevel.should respond_to(:percentage_to_grade)
  end

  it "return default student for batch if grading table  has no gradinglevels for batch"  do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    newstud = User.new(:username =>"mahinddfgdfdferrtr",:password => "mahinder",:email =>"dhjfgdfdfgatttrsd@jdhdhd.com",:role =>"Student")
    stud = Student.create!(:first_name => "mahindercv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "mahindercv@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:user => newstud)
    
    grade = GradingLevel.percentage_to_grade 70, b
    
    grade.should eql(@grading2)

  end

  it "return  grading for student  if grading table  has gradinglevels for batch"  do
    Batch.delete_all
    User.delete_all
    Student.delete_all
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b = batch.id
    newstud = User.new(:username =>"mahinddfgdfdferrtr",:password => "mahinder",:email =>"dhjfgdfdfgatttrsd@jdhdhd.com",:role =>"Student")
    stud = Student.create!(:first_name => "mahinderbv kumar",:last_name =>"kumarcvb",:admission_no=>1,:class_roll_no =>101,:batch_id => b,:gender => "m",:email => "mahinderbv@ezzie.in",:admission_date => 1.month.ago,:date_of_birth => 5.year.ago,:user => newstud)
    grading = GradingLevel.create!(:name =>"h",:min_score => 70,:batch => batch)
    grade = GradingLevel.percentage_to_grade 70, b
    grade.should eql(grading)
 end

  it "should  return grading name by calling to_s " do
    name = @grading.to_s
    name.should eql(@grading.name)
  end
end
