class CreatePassengerBoardTransportDetails < ActiveRecord::Migration
  def self.up
    create_table :passenger_board_transport_details do |t|
     t.references :transport_detail
     t.references :transport_board
     t.references :passenger
     t.string :passenger_type
      
    end
  end
  def self.down
    drop_table :passenger_board_transport_details
  end
end
