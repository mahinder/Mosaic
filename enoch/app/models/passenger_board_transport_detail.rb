class PassengerBoardTransportDetail < ActiveRecord::Base
  validates :passenger_type,:presence=>true
  belongs_to :transport_detail
  belongs_to :transport_board
  before_validation :board_com,:on => :create
  validate :validate
   
     def validate
       passenger_assigned = PassengerBoardTransportDetail.find_all_by_transport_board_id(self.transport_board_id).count
      passenger_initialize=TransportBoard.find_by_id(self.transport_board_id)
      errors.add(:no_of_passenger,"Sorry You have exceed the maximum passenger limit for #{passenger_initialize.name}")if passenger_assigned == passenger_initialize.no_of_passenger
     end
     def board_com
      passenger_detail= PassengerBoardTransportDetail.find_by_passenger_id_and_passenger_type(self.passenger_id,self.passenger_type)
     unless passenger_detail.nil?
       errors.add(:passenger,"Passenger has already been assigned to #{passenger_detail.transport_board.name}")
     end
     end
 end
