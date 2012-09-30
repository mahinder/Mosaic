class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :album
      t.string   :album_photo_file_name
      t.string   :album_photo_content_type
      t.integer  :album_photo_file_size
      t.datetime :album_photo_updated_at
      t.timestamps
    end
  end
end
