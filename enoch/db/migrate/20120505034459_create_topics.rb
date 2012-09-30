class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.references :subject
      t.boolean    :is_active, :default => true
      t.timestamps
    end
  end
end
