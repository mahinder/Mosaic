class CreateArchivedStudentAwards < ActiveRecord::Migration
  def change
    create_table :archived_student_awards do |t|
      t.references :batch
      t.string  :title
      t.string  :description
      t.date  :award_date
      t.references :student
      t.timestamps
    end
  end
end
