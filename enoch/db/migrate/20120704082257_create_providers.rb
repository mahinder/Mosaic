class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string :name
      t.string :address
      t.string :city
      t.integer :mobile
      t.boolean :status

      t.timestamps
    end
  end
  def self.down
    drop_table :providers
  end
end
