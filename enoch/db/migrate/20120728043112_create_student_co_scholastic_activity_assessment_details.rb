class CreateStudentCoScholasticActivityAssessmentDetails < ActiveRecord::Migration
  def change
    create_table :student_co_scholastic_activity_assessment_details do |t|
      t.references :student_co_scholastic_assessment
      t.references :student
      t.references :co_scholastic_sub_skill_activity
      t.references :co_scholastic_activity_assessment_indicator
      t.timestamps
    end
  end
end
