class StudentCoScholasticAssessment < ActiveRecord::Base
 
  validates :student_co_scholastic_assessment_name,:uniqueness=>{:scope=>:batch_id},:length=>{:maximum=>50}
  has_many :student_co_scholastic_area_assessment_details
  has_many :student_co_scholastic_activity_assessment_details
  belongs_to :school_session
  belongs_to :term_master
  belongs_to :batch
  
  # def removable?
    # puts "i am in removable with params#{}"
    # self.student_co_scholastic_area_assessment_details.reject{|e| e.removable?}.empty?
  # end
end
