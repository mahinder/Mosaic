class CoScholasticActivityAssessmentIndicator < ActiveRecord::Base
   validates :indicator_value ,:presence => true
   belongs_to :co_scholastic_sub_skill_activity
   validates :indicator_value,:uniqueness => {:scope => [:co_scholastic_sub_skill_activity_id]}
end
