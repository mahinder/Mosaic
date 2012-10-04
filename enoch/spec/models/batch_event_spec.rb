# == Schema Information
#
# Table name: batch_events
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  batch_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe BatchEvent do
  before(:each) do
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
    batch = Batch.new @batch_attr
    @course = Course.new @course_attr
     @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
     @event_attr = {
      :title => "Annual finction", 
      :description => "any ",
      :start_date => -15.day.ago, 
      :end_date => -20.day.ago
    }
    event = Event.create(@event_attr)
@batch_event_attr = {
  :batch => batch,
  :event => event
}
  end
  describe "validates" do
    it "should exist in database" do
      batch_event = BatchEvent.new(@batch_event_attr)
      batch_event.should be_valid
    end
    it "should respond to batch" do
      batch_event = BatchEvent.new(@batch_event_attr)
      batch_event.should respond_to(:batch)
    end
    it "should respond to event" do
      batch_event = BatchEvent.new(@batch_event_attr)
      batch_event.should respond_to(:event)
    end
  end
  
end
