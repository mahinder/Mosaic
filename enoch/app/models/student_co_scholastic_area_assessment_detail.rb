class StudentCoScholasticAreaAssessmentDetail < ActiveRecord::Base
  belongs_to :student_co_scholastic_assessment
  belongs_to :co_scholastic_sub_skill_area
  belongs_to :assessment_indicator
  # def removable?
    # self.exam_scores.reject{|es| es.marks.nil? and es.grading_level_detail_id.nil?}.empty?
  # end
  
  def create_or_update_area_detail(student,sub_skill_id,student_co_scholastic_assessment,indicator)
   success=""
   status=""
   area_assessment_detail=StudentCoScholasticAreaAssessmentDetail.find_by_student_id_and_co_scholastic_sub_skill_area_id_and_student_co_scholastic_assessment_id(student.id,sub_skill_id,student_co_scholastic_assessment)
   if area_assessment_detail.nil?
    if self.save!
     success="save"
     status=true
     else
        status=false
       success=self.errors
     end
   else
     if area_assessment_detail.update_attributes(:assessment_indicator_id=>self.assessment_indicator_id)
   success="update"
   status=true
   else
      status=false
     success=area_assessment_detail.errors
   end
   end
   return [status,success]
  end
end
