class CreateTransportVehicles < ActiveRecord::Migration
  def self.up
    create_table :transport_vehicles do |t|
     t.string :vehicle_type
     t.string :registration_no
     t.integer :capacity
     t.references :provider
     t.date :date_of_hire
     t.date :date_of_expiry
     t.boolean :status
     
    end
  end
  def self.down
    drop_table :transport_vehicles
  end
end
