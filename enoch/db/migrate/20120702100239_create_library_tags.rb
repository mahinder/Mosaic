class CreateLibraryTags < ActiveRecord::Migration
  def change
    create_table :library_tags do |t|
      t.string :name
      t.timestamps
    end
  end
end
