class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.references :course
      t.references :elective_skill
      t.integer     :max_weekly_classes
      t.boolean    :no_exam
      t.string      :full_name
      t.boolean    :is_scholastic, :default => true
      t.boolean    :is_active, :default => true
      t.boolean    :is_common, :default => false
      t.string     :code
      t.timestamps
    end
  end
end
