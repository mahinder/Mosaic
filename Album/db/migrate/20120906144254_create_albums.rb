class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.references :user
      t.string :name
      t.timestamps
    end
  end
end
