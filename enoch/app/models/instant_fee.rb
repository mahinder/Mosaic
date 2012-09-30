class InstantFee < ActiveRecord::Base
  validates :name,:school_session_id,:presence => true
  validates :description,:presence => true
  has_many   :instant_fee_particular, :class_name => "InstantFeeParticular", :dependent => :destroy
  validates_uniqueness_of :name, :scope=>[:school_session_id]
  
  def has_collected_fee(instant_fee)
    amount_taken = InstantFeeCollection.find_all_by_instant_fee_id(instant_fee.id)
    if amount_taken.count == 0
      return false
    else
      return true
    end
  end
  
end
