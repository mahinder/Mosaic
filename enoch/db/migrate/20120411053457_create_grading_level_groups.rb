class CreateGradingLevelGroups < ActiveRecord::Migration
  def self.up
    create_table :grading_level_groups do |t|
      t.string :grading_level_group_name
      t.boolean :is_active

      t.timestamps
    end
  end
  
  # 
  
 
  def self.down
    drop_table :grading_level_groups
  end
end
