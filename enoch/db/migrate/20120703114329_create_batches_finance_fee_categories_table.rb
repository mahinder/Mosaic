class CreateBatchesFinanceFeeCategoriesTable < ActiveRecord::Migration
  def up
    create_table :batches_finance_fee_categories , :id => false do |t|
      t.references  :batch
      t.references  :finance_fee_category
    end
  end

  def down
    drop_table :batches_finance_fee_categories
  end
end
