class InstantFeeCollection < ActiveRecord::Base
  has_many :instant_fee_particular ,:dependent=>:destroy
  belongs_to :instant_fee,:class_name => "InstantFee"
end
