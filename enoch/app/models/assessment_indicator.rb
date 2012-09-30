class AssessmentIndicator < ActiveRecord::Base
  validates :indicator_value ,:presence => true
  belongs_to :co_scholastic_sub_skill_area
  validates :indicator_value,:uniqueness => {:scope => [:co_scholastic_sub_skill_area_id]}
end
