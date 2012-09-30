class CreateLibraryAuthors < ActiveRecord::Migration
  def change
    create_table :library_authors do |t|
      t.string :name
      t.timestamps
    end
  end
end
