# == Schema Information
#
# Table name: weekdays
#
#  id       :integer         not null, primary key
#  batch_id :integer
#  weekday  :string(255)
#

require 'spec_helper'


describe Weekday do

  before (:each) do
    @Weekday5= Weekday.create!(:weekday =>"5", :batch_id => nil)
    
    @Weekday3 = Weekday.create!(:weekday =>"3", :batch_id => nil)

    @Weekday4 = Weekday.create!(:weekday =>"4", :batch_id => nil)

    @Weekday2 = Weekday.create!(:weekday =>"2", :batch_id => nil)

    @Weekday1 = Weekday.create!(:weekday =>"1", :batch_id => nil)
    
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => -1
    }
    @course = Course.new(@course_attr)
  end
  
  after (:each) do
    Weekday.delete_all
  end

  
  it "scope test for_batch" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b =batch.id
    @Weekday7 = Weekday.create!(:weekday => "1",:batch => batch)
    weekday = Weekday.for_batch b
    weekday.should include @Weekday7
    weekday.should_not include @Weekday1
  end

  it "scope test for default and should return default weekdays" do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    b =batch.id
    @Weekday7 = Weekday.create!(:weekday => "1",:batch => batch)
    weekday = Weekday.default
    weekday.should include @Weekday1
    weekday.should_not include @Weekday7
  end

  it "default scope test" do
    defaultweekday = Weekday.default
    defaultweekday[0].should eql(@Weekday1)
    defaultweekday[4].should eql(@Weekday5)
    defaultweekday[4].should_not eql(@Weekday4)
  end
end
