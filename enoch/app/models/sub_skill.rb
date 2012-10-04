class SubSkill < ActiveRecord::Base
  belongs_to :skill
  validates_uniqueness_of :name, :scope => :skill_id
  validates :name , :length =>{:maximum => 50}
end
