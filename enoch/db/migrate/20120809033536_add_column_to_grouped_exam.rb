class AddColumnToGroupedExam < ActiveRecord::Migration
  def change
    add_column    :grouped_exams, :grading_level_group_id, :integer
  end
end
