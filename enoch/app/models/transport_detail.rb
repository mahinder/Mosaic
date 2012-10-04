class TransportDetail < ActiveRecord::Base
  belongs_to :transport_route
  belongs_to :transport_vehicle
  belongs_to :transport_driver
   validate :validate
  
   def validate
      unless self.intime.nil? or self.outtime.nil?
        errors.add(:outtime,"can not be before the in time")if self.outtime < self.intime
        errors.add(:outtime,"can not be equal to the in time")if self.outtime == self.intime
      end
     end
end
