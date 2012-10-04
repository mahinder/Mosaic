class CreateCoScholasticActivityAssessmentIndicators < ActiveRecord::Migration
  def change
    create_table :co_scholastic_activity_assessment_indicators do |t|
      t.string :indicator_value
      t.string :indicator_description
      t.references :co_scholastic_sub_skill_activity
      t.boolean :is_active
      t.timestamps
    end
  end
end
