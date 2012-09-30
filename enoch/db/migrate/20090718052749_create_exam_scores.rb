class CreateExamScores < ActiveRecord::Migration
  def self.up
    create_table :exam_scores do |t|
      t.references :student
      t.references :exam
      t.decimal    :marks, :precision => 7, :scale => 2
      t.references :grading_level_detail
      t.string     :remarks
      t.string     :custom
      t.boolean    :is_failed
      t.timestamps
    end
  end

  def self.down
    drop_table :exam_scores
  end
end
