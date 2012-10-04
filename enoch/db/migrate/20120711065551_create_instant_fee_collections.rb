class CreateInstantFeeCollections < ActiveRecord::Migration
  def change
    create_table :instant_fee_collections do |t|
      t.references :instant_fee
      t.references :student, :null=>true
      t.references :employee, :null=>true
      t.string  :name
      t.float  :discount
      t.float  :amount
      t.boolean :is_guest, :default => false
      t.date :collection_date
      t.string  :receipt_no
      t.string  :voucher_no
      t.timestamps
    end
  end
end
