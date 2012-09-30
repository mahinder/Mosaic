class StudentCoScholasticActivityAssessmentDetail < ActiveRecord::Base
  belongs_to :student_co_scholastic_assessment
  belongs_to :co_scholastic_sub_skill_activity
  belongs_to :co_scholastic_activity_assessment_indicator
 
  def create_or_update_activity_detail(student,sub_skill_id,student_co_scholastic_assessment,indicator)
   success=""
   status=""
   activity_assessment_detail=StudentCoScholasticActivityAssessmentDetail.find_by_student_id_and_co_scholastic_sub_skill_activity_id_and_student_co_scholastic_assessment_id(student.id,sub_skill_id,student_co_scholastic_assessment)
   if activity_assessment_detail.nil?
    if self.save!
     success="Assessment Detail Created successfuly"
     status=true
     else
        status=false
       success=self.errors
     end
   else
     if activity_assessment_detail.update_attributes(:co_scholastic_activity_assessment_indicator_id=>self.co_scholastic_activity_assessment_indicator_id)
   success="Assessment Detail updated successfuly"
   status=true
   else
      status=false
     success=activity_assessment_detail.errors
   end
   end
   return [status,success]
  end
end
