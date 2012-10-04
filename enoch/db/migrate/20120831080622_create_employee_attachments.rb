class CreateEmployeeAttachments < ActiveRecord::Migration
  def change
    create_table :employee_attachments do |t|
      t.string     :file_name
      t.references  :employee
      t.references  :created_by
      t.references  :deleted_by
      t.string     :dir_name
      t.timestamps

    end
  end
end
