class CreateInstantFeeParticulars < ActiveRecord::Migration
  def change
    create_table :instant_fee_particulars do |t|
      t.string      :name
      t.text        :description
      t.decimal     :amount, :precision => 12, :scale => 2
      t.references  :instant_fee
      t.boolean     :is_deleted, :null => false, :default => false
      t.timestamps
    end
  end
end
