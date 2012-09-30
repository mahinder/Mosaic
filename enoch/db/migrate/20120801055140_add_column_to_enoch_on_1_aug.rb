class AddColumnToEnochOn1Aug < ActiveRecord::Migration
  def change
    add_column    :exam_groups, :assessment_name_id, :integer
    add_column    :exam_groups, :term_master_id, :integer
   
  end
end
