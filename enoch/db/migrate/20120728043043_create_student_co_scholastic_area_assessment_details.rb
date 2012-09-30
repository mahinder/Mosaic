class CreateStudentCoScholasticAreaAssessmentDetails < ActiveRecord::Migration
  def change
    create_table :student_co_scholastic_area_assessment_details do |t|
      t.references :student_co_scholastic_assessment
      t.references :student
      t.references :co_scholastic_sub_skill_area
      t.references :assessment_indicator
      t.timestamps
    end
  end
end
