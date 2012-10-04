class GradingLevelDetail < ActiveRecord::Base
   belongs_to :grading_level_group
   validates :grading_level_detail_name, :min_score, :presence => true
   validates :grading_level_detail_name,:min_score,:uniqueness =>{:scope => [:grading_level_group_id],:case_sensitive => false }
    def inactivate
    update_attribute :is_deleted, true
  end

  # def to_s
    # name
  # end

 def self.exists_for_batch?(batch_id)
   # batch_grades = GradingLevel.find_all_by_batch_id(batch_id, :conditions=> 'is_deleted = false')
    #enoch -change in :conditions=> { :is_deleted => false}
    batch_grades = GradingLevel.find_all_by_batch_id(batch_id, :conditions=> { :is_deleted => false})
    default_grade = GradingLevel.default
    if batch_grades.blank? and default_grade.blank?
      return false
    else
      return true
    end
  end
  
  class << self
    def percentage_to_grade(percent_score, grading_level_group_id)
     
        # GradingLevelDetail.find_by_grading_level_group_id(grading_level_group_id,:conditions => [ "min_score <= ?", percent_score.round ], :order => 'min_score desc')
      GradingLevelDetail.find_by_grading_level_group_id(grading_level_group_id,:conditions => [ "min_score <= ?", percent_score], :order => 'min_score desc')
      end
  end
end

