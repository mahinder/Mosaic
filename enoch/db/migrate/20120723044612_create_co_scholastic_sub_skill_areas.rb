class CreateCoScholasticSubSkillAreas < ActiveRecord::Migration
  def self.up
    create_table :co_scholastic_sub_skill_areas do |t|
      t.references :co_scholastic_area
      t.string :co_scholastic_sub_skill_name
      t.boolean :is_active
      t.timestamps
    end
  end
  def self.down
    drop_table :co_scholastic_sub_skill_areas
  end
end
