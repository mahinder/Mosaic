class TransportFeeCategory < ActiveRecord::Base
  validates :name,:uniqueness=>true,:length=>{:maximum=>50}
end
