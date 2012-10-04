class AddColumnsToEmployee < ActiveRecord::Migration
    def self.up
        add_column    :archived_employees, :employee_photo_file_size, :integer
        rename_column :archived_employees, :employee_photo_filename, :employee_photo_file_name
        add_column    :employees, :employee_photo_file_size, :integer
        add_column    :employees, :is_transport_enabled, :boolean
        rename_column :employees, :employee_photo_filename, :employee_photo_file_name

    end

    def self.down
        remove_column :archived_employees, :employee_photo_file_size
        rename_column :archived_employees, :employee_photo_file_name, :employee_photo_filename
        remove_column :employees, :employee_photo_file_size
        remove_column    :employees, :is_transport_enabled
        rename_column :employees, :employee_photo_file_name, :employee_photo_filename
    end
end
