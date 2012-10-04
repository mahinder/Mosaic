class TermMaster < ActiveRecord::Base
  validates :name ,:presence => true, :uniqueness => true
  scope :active, :conditions => { :is_active => true }
end
