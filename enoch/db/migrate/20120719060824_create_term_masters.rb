class CreateTermMasters < ActiveRecord::Migration
  def change
    create_table :term_masters do |t|
      t.string :name
      t.boolean :is_active
      t.timestamps
    end
  end
end
