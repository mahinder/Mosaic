class CreateInstantFeeCollectionDetails < ActiveRecord::Migration
  def change
    create_table :instant_fee_collection_details do |t|
      t.references :instant_fee_collection
      t.references :instant_fee_particular
      t.float :particular_amount_provided
      t.float :discount
      t.integer :quantity
      t.timestamps
    end
  end
end
