class CreateFinanceFeeCategories < ActiveRecord::Migration
  def self.up
    create_table  :finance_fee_categories do |t|
      t.string      :name
      t.text        :description
      t.references  :school_session
      t.boolean     :is_deleted , :null => false ,:default => false
      t.boolean     :is_master, :null => false ,:default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :finance_fee_categories
  end
end
