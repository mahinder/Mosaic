class TransportRoute < ActiveRecord::Base
  validates :start_place, :end_place ,:distance ,:name, :presence => true
  validates :name, :uniqueness=>true,:length=>{:maximum=>50}
  has_many :transport_boards
  
  
  
end
