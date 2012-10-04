class CreateAttendanceSubjectWises < ActiveRecord::Migration
  
  def self.up
    create_table :attendance_subject_wises do |t|
      t.references :student
      t.references :period_table_entry_subject_wise
      t.references :batch
      t.string :reason
    end
  end

  def self.down
    drop_table :attendance_subject_wises
  end

end
