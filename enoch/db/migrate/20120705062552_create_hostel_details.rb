class CreateHostelDetails < ActiveRecord::Migration
  def change
    create_table :hostel_details do |t|
        t.string  :hostel_name
        t.string  :hostel_type
        t.string  :other_information
        t.boolean :is_deleted, :default => false
        t.timestamps
    end
  end
end
