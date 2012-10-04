class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string     :file_name
      t.references  :student
      t.references  :created_by
      t.references  :deleted_by
      t.string     :dir_name
      t.timestamps
    end
  end
end
