class AddColumnsToStudent < ActiveRecord::Migration
    def self.up
        add_column    :archived_students, :student_photo_file_size, :integer
        rename_column :archived_students, :student_photo_filename, :student_photo_file_name
        add_column    :students, :student_photo_file_size, :integer
        rename_column :students, :student_photo_filename, :student_photo_file_name

    end

    def self.down
        remove_column :students, :student_photo_file_size
        rename_column :students, :student_photo_file_name, :student_photo_filename
        remove_column :archived_students, :student_photo_file_size
        rename_column :archived_students, :student_photo_file_name, :student_photo_filename
    end
end
