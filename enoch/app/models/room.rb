class Room < ActiveRecord::Base
  belongs_to :employee
  belongs_to :batch
  has_many :subjects
  has_and_belongs_to_many :skills
  validates_numericality_of :capacity, :message => 'must be a number'
end
