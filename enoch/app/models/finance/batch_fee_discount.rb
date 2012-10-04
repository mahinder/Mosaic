
class BatchFeeDiscount < FeeDiscount

  belongs_to :receiver ,:class_name=>'Batch'
  #validates  :receiver_id , :message => "Batch cant be blank"
  #enoch - presence_of syntax changed
  validates :receiver_id ,:presence => {:message => "Batch cant be blank"}
  validates :finance_fee_category_id,:presence => true
  validates_uniqueness_of :name, :scope=>[:receiver_id, :type]

#  validates_uniqueness_of :receiver_id, :scope=>[:type,:finance_fee_category_id],:message=>'Discount already exists for batch'
end
