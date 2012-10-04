class SchoolSession < ActiveRecord::Base
  
  validates :name,:start_date,:end_date,:presence => true
  validates_uniqueness_of :name, :scope => [:current_session], :if => 'current_session == true'
  validate :has_unique_session
  scope :in_active, :conditions => { :current_session => false }, :order => 'id asc'
  scope :active, :conditions => { :current_session => true }, :order => 'id asc'
  has_many :finance_fee_categories
  
  def has_unique_session
    errors.add(:end_date, "can't be less than start date.") \
         if self.start_date > self.end_date \
           unless self.start_date.nil?  
    self_check= self.new_record? ? "" : "id != #{self.id} and "
    start_overlap = !SchoolSession.find(:first, :conditions=>[self_check+"start_date < ? and end_date > ?", self.start_date,self.start_date]).nil?
    end_overlap = !SchoolSession.find(:first, :conditions=>[self_check+"start_date < ? and end_date > ?", self.end_date,self.end_date]).nil?
    between_overlap = !SchoolSession.find(:first, :conditions=>[self_check+"start_date < ? and end_date > ?",self.end_date, self.start_date]).nil?
    previous_date = !SchoolSession.find(:first, :conditions=>[self_check+"start_date > ? and end_date > ?",self.start_date, self.start_date]).nil? 
    empty_record = !SchoolSession.find(:first, :conditions => ["id = ? and current_session = ?",self.id, true]).nil? 
    errors.add(:start_date,"overlap existing school session.") if start_overlap
    errors.add(:end_date, "overlap existing school session.") if end_overlap
    errors.add(:school_session, "overlaps with existing school session.") if between_overlap
    errors.add(:start_date,"can not be same as end date") if self.start_date == self.end_date
    errors.add(:start_date, "can't be less than previous session end date.") if previous_date
    errors.add(:school_session, "can't be made inactive.") if empty_record
  end 

  
end
