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


class ClassTiming < ActiveRecord::Base
  has_many :timetable_entries , :dependent => :destroy
  belongs_to :batch

  validates :name, :presence => true

  validates :name, :uniqueness =>{:scope => :batch_id}

  scope :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i },  :order =>'start_time ASC' } }
  scope :default, :conditions => { :batch_id => nil, :is_break => false }, :order =>'start_time ASC'
  validate :validate
  
  def validate
  errors.add(:end_time, "should be later than start time") \
      if self.start_time > self.end_time \
      unless self.start_time.nil? or self.end_time.nil?
    self_check= self.new_record? ? "" : "id != #{self.id} and "
    start_overlap = !ClassTiming.find(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}", self.start_time,self.start_time]).nil?
    end_overlap = !ClassTiming.find(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}", self.end_time,self.end_time]).nil?
    between_overlap = !ClassTiming.find(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}",self.end_time, self.start_time]).nil?
    errors.add(:start_time,"overlaps existing class timing.") if start_overlap
    errors.add(:end_time, "overlaps existing class timing.") if end_overlap
    errors.add(:overlap, "Class timing overlaps with existing class timing.") if between_overlap
    errors.add(:start_time,"is same as end time") if self.start_time == self.end_time
  
  end
end
