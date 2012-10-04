class CreateClassTimings < ActiveRecord::Migration
  def self.up
    create_table :class_timings do |t|
      t.references :batch
      t.string     :name
      t.time       :start_time
      t.time       :end_time
      t.boolean    :is_break
    end
    create_defaults
   end

  def self.down
    drop_table :class_timings
  end

  def self.create_defaults
    # ClassTiming.create(:name => "Zero", :start_time => "08:00 AM",:end_time => "08:45 AM", :is_break => false)
    # ClassTiming.create(:name => "1", :start_time => "08:45 AM",:end_time => "09:20 AM", :is_break => false)
    # ClassTiming.create(:name => "2", :start_time => "09:20 AM",:end_time => "09:55 AM",:is_break => false)
    # ClassTiming.create(:name => "3", :start_time => "09:55 AM",:end_time => "10:30 AM", :is_break => false)
    # ClassTiming.create(:name => "Break", :start_time => "10:30 AM",:end_time => "11:25 AM", :is_break => true)
    # ClassTiming.create(:name => "4", :start_time => "11:25 AM",:end_time => "12:00 PM", :is_break => false)
    # ClassTiming.create(:name => "5",  :start_time => "12:00 PM",:end_time => "12:30 PM", :is_break => false)
    # ClassTiming.create(:name => "6", :start_time => "12:30 PM",:end_time => "01:00 PM", :is_break => false)
    # ClassTiming.create(:name => "7",  :start_time => "01:00 PM",:end_time => "01:30 PM", :is_break => false)
    
    
    ClassTiming.create(:name => "Zero", :start_time => "08:00 AM",:end_time => "09:00 AM", :is_break => false)
    ClassTiming.create(:name => "1", :start_time => "09:00 AM",:end_time => "10:00 AM", :is_break => false)
    ClassTiming.create(:name => "2", :start_time => "10:00 AM",:end_time => "11:00 AM", :is_break => false)
    ClassTiming.create(:name => "3", :start_time => "11:00 AM",:end_time => "11:30 AM", :is_break => true)
    ClassTiming.create(:name => "4", :start_time => "11:30 AM",:end_time => "12:30 PM", :is_break => false)
    ClassTiming.create(:name => "5", :start_time => "12:30 PM",:end_time => "01:40 PM", :is_break => false)
    
  end
end
