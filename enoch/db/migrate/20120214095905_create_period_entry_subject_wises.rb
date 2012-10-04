class CreatePeriodEntrySubjectWises < ActiveRecord::Migration
    def self.up
    create_table :period_entry_subject_wises do |t|
      t.date       :month_date
      t.references :batch
      t.references :subject
      t.references :class_timing
      t.references :employee
    end
  end

  def self.down
    drop_table :period_entry_subject_wises
  end
  
end
