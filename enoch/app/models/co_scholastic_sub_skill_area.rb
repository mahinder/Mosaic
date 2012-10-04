class CoScholasticSubSkillArea < ActiveRecord::Base
  belongs_to :co_scholastic_area
  validates :co_scholastic_sub_skill_name ,:presence => true
  validates :co_scholastic_sub_skill_name ,:uniqueness => {:scope => [:co_scholastic_area_id]}
  has_many :assessment_indicators ,:dependent => :destroy  
end
