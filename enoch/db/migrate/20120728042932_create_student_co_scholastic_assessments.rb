class CreateStudentCoScholasticAssessments < ActiveRecord::Migration
  def change
    create_table :student_co_scholastic_assessments do |t|
      t.string :student_co_scholastic_assessment_name  
      t.references :school_session
      t.references :batch
      t.references :term_master
      t.timestamps
     end
  end
end
