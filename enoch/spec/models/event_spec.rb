# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  start_date  :datetime
#  end_date    :datetime
#  is_common   :boolean         default(FALSE)
#  is_holiday  :boolean         default(FALSE)
#  is_exam     :boolean         default(FALSE)
#  is_due      :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Event do
  
  after (:each) do
    Event.delete_all
  end
  
  before(:each) do
    @event_attr = {
      :title => "Annual finction", 
      :description => "any ",
      :start_date => -15.day.ago, 
      :end_date => -20.day.ago
    }
    @course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level => 4
    }
    @course = Course.new(@course_attr)
     @event = Event.create(@event_attr)
     @event1 = Event.create( :title => "Annual finction",:description => "any ",:start_date => -15.day.ago, :end_date => -20.day.ago, :is_holiday => true, :is_exam => true) 
  
  end
  
  it "title should not be blank" do
    @event = Event.create(@event_attr.merge(:title => ""))
    @event.errors.messages[:title].should eql(["can't be blank"])
  end 

  it "description should not be blank" do
    @event = Event.create(@event_attr.merge(:description => ""))
    @event.errors.messages[:description].should eql(["can't be blank"])
  end 

  it "start_date should not be blank" do
    @event = Event.create(@event_attr.merge(:start_date => ""))
    @event.errors.messages[:start_date].should eql(["can't be blank"])
  end
  
  it "end_date should not be blank" do
    @event = Event.create(@event_attr.merge(:end_date => ""))
    @event.errors.messages[:end_date].should eql(["can't be blank"])
  end
  
  it "scope holidays" do
    event =  Event.holidays
    event.should include(@event1)
    
  end
  
  it "scope exams" do
    event =  Event.exams
    event.should include(@event1)
  end
  
  it "test  has many batch_events  :dependent => :destroy "  do
    batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
    batch1 = Batch.new :name => 'science', :start_date => 1.year.ago , :end_date => 1.month.ago
    @course.batches = [batch]
    @course.presence_of_initial_batch
    @course.save!
    @course.batches = [batch1]
    b =batch.id
    b1 =batch1.id
    batch_event = BatchEvent.new(:batch_id => b)
    batch_event1 = BatchEvent.new(:batch_id => b1)
    @event1.batch_events = [batch_event,batch_event1]
    @event1.batch_events.should include(batch_event, batch_event1)
    batch_event.event.should eql(@event1)
    batch_event1.event.should eql(@event1)
    # @event.destroy
    # batch_event.event.should_not eql(@event1)
    # batch_event1.event.should_not eql(@event1)
    
  end
  it "has_many :employee_department_events, :dependent => :destroy" do
    empdep = EmployeeDepartment.create!(:code => "math", :name => "abc")
    empdepeve = EmployeeDepartmentEvent.new(:employee_department => empdep)
    @event1.employee_department_events = [empdepeve]
    @event1.employee_department_events.should include(empdepeve)
    empdepeve.event.should eql(@event1)
    empdepeve.event.should eql(@event1)
     @event1.destroy
  end
  
  it "start_date should not be less then end date" do
    @event2 = Event.new( :title => "Annual finction",:description => "any ",:start_date => -15.day.ago, :end_date => -10.day.ago, :is_holiday => true, :is_exam => true) 
   @event2.validate
   @event2.errors.messages[:end_time].should eql(["can not be before the start time"])
  end
  
  it"day is_a_holiday?" do
    #return false if day is not holiday
    status =  Event.is_a_holiday?(-2.day.ago)
    status.should be_false
    @event2 = Event.create!(:title => "Annual finction",:description => "any ",:start_date => -15.day.ago, :end_date => -20.day.ago, :is_holiday => true, :is_exam => true)     
    status =  Event.is_a_holiday?(-15.day.ago)
    status.should be_true
  end
  
end
