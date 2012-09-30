class TransportFeeCollection < ActiveRecord::Base
  validates :amount,:passenger_id,:passenger_type,:transport_fee_category_id, :presence=>true
  belongs_to :transport_fee_category
end
