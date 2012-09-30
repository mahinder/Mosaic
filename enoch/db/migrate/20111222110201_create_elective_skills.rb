class CreateElectiveSkills < ActiveRecord::Migration
  def change
    create_table :elective_skills do |t|
      t.string :name
      t.references :course
      t.timestamps
    end
  end
end
