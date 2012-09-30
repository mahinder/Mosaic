class PtmMaster < ActiveRecord::Base
  belongs_to :batch
  belongs_to :event
  validate :validate
  
  def validate
    errors.add(:ptm_start_date, "can't be a past date.") if self.ptm_start_date < Date.today \
      unless self.ptm_start_date.nil?
    errors.add(:ptm_end_date, "can't be a past date.") if self.ptm_end_date < Date.today \
      unless self.ptm_end_date.nil?
    errors.add(:ptm_start_date, "can't be less than ptm end date.") if self.ptm_start_date < self.ptm_end_date \
      unless self.ptm_start_date.nil?
    errors.add(:ptm_end_date, "can't be less than ptm start date.") if self.ptm_end_date < self.ptm_start_date \
      unless self.ptm_end_date.nil?
  end
  
  def self.update_master
   @ptm_history =  PtmMaster.find_all_by_is_active(true,:conditions => ["(ptm_start_date <= ?)  ", Date.today-7])
   unless @ptm_history.nil?
     @ptm_history.each do |his|
       his.update_attribute("is_active",false)
     end
   end
  end
 
end
