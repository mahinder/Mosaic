class CreateTransportDrivers < ActiveRecord::Migration
  def self.up
    create_table :transport_drivers do |t|
       t.references :provider
       t.string :name
       t.string :address
       t.integer :mobile
       t.date :dl_valid_upto
       t.string :licence_no
       t.boolean :status
    end
  end
  def self.down
    drop_table :transport_drivers
  end
end
