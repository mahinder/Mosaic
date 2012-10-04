class CreateInstantFees < ActiveRecord::Migration
  def change
    create_table :instant_fees do |t|
      t.string :name
      t.string :description
      t.references :school_session
      t.timestamps
    end
  end
end
