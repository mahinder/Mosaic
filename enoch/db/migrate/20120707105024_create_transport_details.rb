class CreateTransportDetails < ActiveRecord::Migration
  def self.up
    create_table :transport_details do |t|
     t.references :transport_route
     t.references :transport_vehicle
     t.references :transport_driver
     t.time :intime
     t.time :outtime
     t.boolean :status
    end
  end
  def self.down
    drop_table :transport_details
  end
end
