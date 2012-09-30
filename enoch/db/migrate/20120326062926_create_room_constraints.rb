class CreateRoomConstraints < ActiveRecord::Migration
  def change
    create_table :room_constraints do |t|
      t.references :room
      t.references :class_timing
      t.references :weekday
      t.timestamps
    end
  end
end
