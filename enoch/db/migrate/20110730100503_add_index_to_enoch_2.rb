class AddIndexToEnoch2 < ActiveRecord::Migration
  def self.up
    # add_index :reminders, [:recipient]
    add_index :students, [:admission_no],:limit => 10
    add_index :students, [:first_name,:middle_name,:last_name],:limit => 10
    add_index :employees,[:employee_number],:limit => 10
    add_index :privileges_users, :user_id
    # add_index :configurations,:config_value,:limit => 10
    add_index :batches,[:is_deleted,:is_active]
    add_index :batches, [:course_id]
    add_index :students, [:batch_id]
    add_index :employees, [:employee_department_id]
    add_index :students, [:batch_id, :date_of_birth]


  end

  def self.down
    # remove_index :reminders, [:recipient]
    remove_index :students, [:admission_no]
    remove_index :students, [:first_name,:middle_name,:last_name]
    remove_index :employees, [:employee_number]
    remove_index :privileges_users, [:user_id]
    remove_index :batches,[:is_deleted,:is_active]
    remove_index :batches, [:course_id]
    remove_index :students, [:batch_id]
    remove_index :employees, [:employee_department_id]    
    remove_index :students, [:batch_id, :date_of_birth]
    # remove_index :configurations,:config_value
    
  end
end
