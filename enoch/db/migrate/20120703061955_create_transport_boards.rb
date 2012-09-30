class CreateTransportBoards < ActiveRecord::Migration
  def change
    create_table :transport_boards do |t|
      t.references :transport_route
      t.string :name
      t.time :picktime
      t.time :droptime
      t.integer :no_of_passenger
      t.boolean :status

      t.timestamps
    end
  end
end
