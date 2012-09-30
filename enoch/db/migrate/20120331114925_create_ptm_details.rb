class CreatePtmDetails < ActiveRecord::Migration
  def change
    create_table :ptm_details do |t|
      t.references :student
      t.string     :parent_feedback
      t.references :ptm_master
      t.references :employee
      t.string     :teacher_notes     
      t.timestamps
    end
  end
end
