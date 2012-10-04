class CreateAssessmentNames < ActiveRecord::Migration
  def change
    create_table :assessment_names do |t|
      t.string :name
      t.boolean :is_active
      t.timestamps
    end
  end
end
