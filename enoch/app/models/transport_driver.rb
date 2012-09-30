class TransportDriver < ActiveRecord::Base
  validates :name,:presence=>true,:length=>{:maximum=>50}
  belongs_to :provider
end
