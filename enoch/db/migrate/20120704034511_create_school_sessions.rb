class CreateSchoolSessions < ActiveRecord::Migration
  def self.up
    create_table :school_sessions do |t|
      t.string :name
      t.boolean :current_session
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    create_default
  end
  
  def self.down
    drop_table :school_sessions
  end
  
  def self.create_default
    SchoolSession.create :name => "#{Date.today.year}-#{Date.today.year + 1}",:current_session => true,:start_date => '2012-04-01',:end_date => '2013-03-30'
  end
end
