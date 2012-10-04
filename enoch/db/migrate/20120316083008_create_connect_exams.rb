class CreateConnectExams < ActiveRecord::Migration
  def self.up
    create_table :connect_exams do |t|
      t.references :exam_group
      t.references :grouped_exam
      t.float  :weightage
    end
  end

  def self.down
    drop_table :connect_exams
  end
end
