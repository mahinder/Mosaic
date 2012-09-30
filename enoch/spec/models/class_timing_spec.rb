# == Schema Information
#
# Table name: class_timings
#
#  id         :integer         not null, primary key
#  batch_id   :integer
#  name       :string(255)
#  start_time :time
#  end_time   :time
#  is_break   :boolean
#

require 'spec_helper'



describe ClassTiming do
  before(:each) do
    @course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 6
    }

    @batch_attr = {
      :name => "A",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }
    @classtiming_attr = {
      :name => "classtiming",
      :start_time => "02:00 AM",
      :end_time => "03:00 AM",
      :batch_id => 1
    }
    @course = Course.new(@course_attr)
  end
  describe "validation" do
    it "should exist class timing" do
      class_timing = ClassTiming.new(@classtiming_attr)
      class_timing.should be_valid
    end
    it "should respond to name" do
      class_timing = ClassTiming.new(@classtiming_attr)
      class_timing.should respond_to(:name)
    end
    it "should respond to start time" do
      class_timing = ClassTiming.new(@classtiming_attr)
      class_timing.should respond_to(:start_time)
    end
    it "should respond to end_time" do
      class_timing = ClassTiming.new(@classtiming_attr)
      class_timing.should respond_to(:end_time)
    end
    it "should respond to batch" do
      class_timing = ClassTiming.new(@classtiming_attr)
      class_timing.should respond_to(:batch)
    end
    it "should respond to timetable_entries" do
      class_timing = ClassTiming.new(@classtiming_attr)
      class_timing.should respond_to(:timetable_entries)
    end
    it "name should be present" do
      class_timing = ClassTiming.new(@classtiming_attr.merge(:name => ""))
      class_timing.should_not be_valid
    end
    it "name should be unique for batch scope" do
      class_timing = ClassTiming.create!(@classtiming_attr)
      duplicate_class_timing_name = ClassTiming.new(@classtiming_attr.merge(:start_time => "04:00 AM", :end_time => "05:00 AM"))
      duplicate_class_timing_name.should_not be_valid
    end
    it "name should_not be unique for out of batch scope" do
      class_timing = ClassTiming.create!(@classtiming_attr)
      duplicate_class_timing_name = ClassTiming.new(@classtiming_attr.merge(:batch_id => 2, :start_time => "04:00 AM", :end_time => "05:00 AM"))
      duplicate_class_timing_name.should be_valid
    end
    it "for_batch method" do

      batch = Batch.new @batch_attr
      @course.batches = [batch]
      @course.presence_of_initial_batch
      @course.save!
      b = batch.id
      class_timing1 = ClassTiming.create!(@classtiming_attr.merge(:batch_id => b))
      class_timing2 = ClassTiming.create!(@classtiming_attr.merge(:start_time => "04:00 AM",:end_time => "05:00 AM",:name => "demo_classtiming", :batch_id => b))
      class_timings = ClassTiming.for_batch b
      class_timings.size.should eql (2)
    end
    it "default method" do

      class_timing1 = ClassTiming.create!(@classtiming_attr.merge(:batch_id => "", :is_break => false))
      class_timing2 = ClassTiming.create!(@classtiming_attr.merge(:start_time => "04:00 AM",:end_time => "05:00 AM",:name => "demo_classtiming", :batch_id => ""))
      class_timings = ClassTiming.default
      class_timings.size.should eql (1)
    end
  end
  describe "valiadte method" do
    it "should raise error" do
      class_timing = ClassTiming.new(@classtiming_attr.merge(:start_time => "11:00 AM", :end_time => "10:00 AM"))
      class_timing.validate
      class_timing.errors.messages[:end_time].should include("should be later than start time")

    end
    it "should be success for overlap" do
      class_timing1 = ClassTiming.create!(@classtiming_attr.merge(:start_time => "9:00 AM", :end_time => "09:50 AM"))
      class_timing2 = ClassTiming.new(@classtiming_attr.merge(:start_time => "09:30 AM", :end_time => "10:30 AM"))
      class_timing2.validate
      class_timing2.errors.messages[:overlap].should include("Class timing overlaps with existing class timing.")
    end
    it "should  be success for start time if start_time == end_time" do
      class_timing = ClassTiming.new(@classtiming_attr.merge(:end_time => "2:00 AM",:batch_id => ""))
      class_timing.validate
      class_timing.errors.messages[:start_time].should include("is same as end time")
    end
    it "should be success if start time overlap" do
      class_timing1 = ClassTiming.create!(@classtiming_attr.merge(:start_time => "1:00 PM", :end_time => "2:00 PM"))
      class_timing2 = ClassTiming.new(@classtiming_attr.merge(:start_time => "1:30 PM",:end_time => "1:30"))
      class_timing2.validate
      class_timing2.errors.messages[:start_time].should include("overlaps existing class timing.")
    end
    it "should be success if end time overlap" do
      class_timing1 = ClassTiming.create!(@classtiming_attr.merge(:start_time => "9:00 AM", :end_time => "9:50 AM"))
      class_timing2 = ClassTiming.new(@classtiming_attr.merge(:start_time => "8:30 PM",:end_time => "9:30"))
      class_timing2.validate
      class_timing2.errors.messages[:end_time].should include("overlaps existing class timing.")
    end
  end 
end
