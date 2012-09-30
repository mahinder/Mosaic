class GradingLevelGroup < ActiveRecord::Base
  has_many :grading_level_details,:dependent => :destroy
   validates :grading_level_group_name, :presence => true
    validates :grading_level_group_name,:uniqueness => true
    accepts_nested_attributes_for :grading_level_details
  validates_associated :grading_level_details
end
