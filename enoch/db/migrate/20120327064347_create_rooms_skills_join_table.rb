class CreateRoomsSkillsJoinTable < ActiveRecord::Migration
  def up
    create_table :rooms_skills, :id => false do |t|
      t.column "room_id", :integer
      t.column "skill_id", :integer
  end

  def down
    drop_table :rooms_skills
  end
  end
end
