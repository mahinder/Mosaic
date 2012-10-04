class CreateGradingLevelDetails < ActiveRecord::Migration
  def self.up
    create_table :grading_level_details do |t|
      t.string :grading_level_detail_name
      t.references :grading_level_group
      t.float   :min_score
      t.timestamps
    end
  end
  
  def self.down
    drop_table :grading_level_details
  end
 
end
