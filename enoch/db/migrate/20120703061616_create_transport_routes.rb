class CreateTransportRoutes < ActiveRecord::Migration
  def self.up
    create_table :transport_routes do |t|
      t.string :name
      t.string :start_place
      t.string :end_place
      t.string :distance
      t.boolean :status

      t.timestamps
    end
  end
  def self.down
     drop_table :transport_routes
  end
end
