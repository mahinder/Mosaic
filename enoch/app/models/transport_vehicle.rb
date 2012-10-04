class TransportVehicle < ActiveRecord::Base
  belongs_to :provider
  validates :registration_no,:uniqueness=>true,:length=>{:maximum=>20}
end
