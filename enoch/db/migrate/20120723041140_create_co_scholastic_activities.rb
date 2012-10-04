class CreateCoScholasticActivities < ActiveRecord::Migration
 
   def self.up
     create_table :co_scholastic_activities do |t|
     t.string :co_scholastic_activity_name
     t.boolean :status
      t.timestamps
    end
  end
  def self.down
    drop_table :co_scholastic_activities
  end
  
end
