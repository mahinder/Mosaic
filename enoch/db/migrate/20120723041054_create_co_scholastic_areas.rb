class CreateCoScholasticAreas < ActiveRecord::Migration
  def self.up
    create_table :co_scholastic_areas do |t|
     t.string :co_scholastic_area_name
     t.boolean :status
      t.timestamps
    end
  end
  def self.down
    drop_table :co_scholastic_areas
  end
end
