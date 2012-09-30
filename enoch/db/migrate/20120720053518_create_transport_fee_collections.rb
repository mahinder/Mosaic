class CreateTransportFeeCollections < ActiveRecord::Migration
  def self.up
    create_table :transport_fee_collections do |t|
      t.integer :passenger_id
      t.string :passenger_type
      t.references :transport_fee_category
      t.integer :amount
      t.integer :discount
      t.date :transport_fee_collection_date
      t.timestamps
    end
  end
  def self.down
    drop_table :transport_fee_collections
  end
end
