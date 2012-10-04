class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :capacity
      t.string :roomtype
      t.boolean :status
      t.references :batch
      t.references :employee
     
      t.timestamps
    end
  end
end
