class CreateTransportFeeCategories < ActiveRecord::Migration
  def self.up
    create_table :transport_fee_categories do |t|
      t.string :passenger_type
      t.string :name
      t.float :monthly_fee
      t.boolean :status
      t.timestamps
    end
  end
  def self.down
    drop_table :transport_fee_categories
  end
end
