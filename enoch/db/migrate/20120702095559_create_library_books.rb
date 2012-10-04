class CreateLibraryBooks < ActiveRecord::Migration
  def change
    create_table :library_books do |t|
      t.string :name
      t.references :library_author
      t.references :library_tag
      t.string :title
      t.integer :no_of_copies
      t.integer :available_no_of_copies
      t.boolean :status
      t.timestamps
    end
  end
end
