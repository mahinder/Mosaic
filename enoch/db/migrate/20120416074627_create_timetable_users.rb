class CreateTimetableUsers < ActiveRecord::Migration
  def self.up
    create_table :timetable_users do |t|
      t.string     :first_name
      t.string     :middle_name
      t.string     :last_name
      
      t.timestamps
    end
    create_default
  end

  def self.create_default
    TimetableUser.create :first_name => 'Timetable',:last_name => 'Administrator'
    User.find(2).update_attributes(:role=>"Timetable")
  end
end