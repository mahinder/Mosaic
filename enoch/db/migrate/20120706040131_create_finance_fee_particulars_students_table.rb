class CreateFinanceFeeParticularsStudentsTable < ActiveRecord::Migration
  def up
    create_table :finance_fee_particulars_students , :id => false do |t|
      t.references  :student
      t.references  :finance_fee_particulars
    end
  end

  def down
    drop_table :finance_fee_particulars_students
  end
end
