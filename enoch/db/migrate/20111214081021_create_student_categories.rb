class CreateStudentCategories < ActiveRecord::Migration    
  def self.up
    create_table :student_categories do |t|
      t.string :name
      t.boolean :is_deleted, :default=> false
    end
  end

  def self.down
    drop_table :student_categories
  end
end
