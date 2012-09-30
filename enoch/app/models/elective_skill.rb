class ElectiveSkill < ActiveRecord::Base
  belongs_to :course
  has_many :skills
  validates :name ,:presence => true
end
