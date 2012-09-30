class TransportBoard < ActiveRecord::Base
    validates :picktime, :droptime ,:no_of_passenger , :presence => true
    belongs_to :transport_route
    validate :validate
    validates :name,:uniqueness=>{:scope=>:transport_route_id},:length=>{:maximum=>50}
     def validate
      unless self.picktime.nil? or self.droptime.nil?
        errors.add(:droptime,"can not be before the pick time")if self.droptime < self.picktime
        errors.add(:droptime,"can not be equal to the pick time")if self.droptime == self.picktime
      end
     end
end
