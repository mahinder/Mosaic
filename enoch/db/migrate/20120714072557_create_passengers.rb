class CreatePassengers < ActiveRecord::Migration
  def change
    create_table :passengers do |t|

      t.timestamps
    end
  end
end
