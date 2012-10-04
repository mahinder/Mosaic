class AddRoomsSubjectsJoinTable < ActiveRecord::Migration
  def up
    create_table :rooms_subjects do |t|
      t.references :room
      t.references :subject
    end  
  end

  def down
  end
end
