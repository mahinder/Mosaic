class CreateAssessmentIndicators < ActiveRecord::Migration
  def change
    create_table :assessment_indicators do |t|
      t.string :indicator_value
      t.string :indicator_description
      t.references :co_scholastic_sub_skill_area
      t.boolean :is_active
      t.timestamps
    end
  end
end
