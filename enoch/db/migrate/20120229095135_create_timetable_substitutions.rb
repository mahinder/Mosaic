class CreateTimetableSubstitutions < ActiveRecord::Migration
  def change
    create_table :timetable_substitutions do |t|
      t.references :batch
      t.references :subject
      t.references :employee
      t.references :teacher_substitude_with
      t.references :class_timing
      t.date   :date
     
      t.timestamps
    end
  end
end
