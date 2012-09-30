class CreateSubSkills < ActiveRecord::Migration
  def change
    create_table :sub_skills do |t|
      t.string :name
      t.references :skill
      t.boolean    :is_active, :default => true
      t.timestamps
    end
  end
end
