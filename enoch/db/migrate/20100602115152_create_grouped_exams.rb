class CreateGroupedExams < ActiveRecord::Migration
  def self.up
    create_table :grouped_exams do |t|
      t.string :grouped_exam_name
      t.references :batch
      t.references :grading_level_group_id
    end
  end

  def self.down
    drop_table :grouped_exams
  end
end
