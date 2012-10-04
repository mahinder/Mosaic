class InstantFeeParticular < ActiveRecord::Base
  belongs_to :instant_fee
  validates :name ,:description ,:presence => true
  validates :name , :uniqueness => {:scope => [:instant_fee_id]}
  
  def has_collected_fee(instant_fee_particular)
    amount_taken = InstantFeeCollectionDetail.find_all_by_instant_fee_particular_id(instant_fee_particular.id)
    if amount_taken.count == 0
      return false
    else
      return true
    end
  end
  
end
