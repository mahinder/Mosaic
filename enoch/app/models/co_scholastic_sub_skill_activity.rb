class CoScholasticSubSkillActivity < ActiveRecord::Base
  belongs_to :co_scholastic_activity
  validates :co_scholastic_sub_skill_name ,:presence => true
  validates :co_scholastic_sub_skill_name ,:uniqueness => {:scope => [:co_scholastic_activity_id]}
  has_many :co_scholastic_activity_assessment_indicators ,:dependent => :destroy  
end
