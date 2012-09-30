class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string     :question
      t.string     :hint
      t.string     :student_id
      t.references :batch
      t.references :subject
      t.date       :to_be_completed
      t.boolean    :is_active, :default => true
      t.string     :attachment_filename
      t.string     :attachment_content_type
      t.timestamps
    end
  end
end
