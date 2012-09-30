# == Schema Information
#
# Table name: fee_discounts
#
#  id                      :integer         not null, primary key
#  type                    :string(255)
#  name                    :string(255)
#  receiver_id             :integer
#  finance_fee_category_id :integer
#  discount                :decimal(15, 2)
#  is_amount               :boolean         default(FALSE)
#

require 'spec_helper'

describe BatchFeeDiscount do
  
  before(:each) do
    @batch = Batch.create!(:name => "Class1", :start_date => 1.year.ago, :end_date => 1.month.ago)
    @finance_fee_category = FinanceFeeCategory.create!(:name => "monthly" ,:batch => @batch)
    @attr = {:name => "primary discount for student", :receiver => @batch,:discount =>10}
  end
  
  after(:each) do
    Batch.delete_all
    FinanceFeeCategory.delete_all
  end
  
  it "should create a new Fee Discount" do
     batch_fee_discount = BatchFeeDiscount.create!(@attr)
     batch_fee_discount.should be_valid
  end
  
  it "should respond to attributes" do
    batch_fee_discount = BatchFeeDiscount.create!(@attr)
    batch_fee_discount.should respond_to(:receiver)
    batch_fee_discount.should respond_to(:receiver_id)
    batch_fee_discount.should respond_to(:name)
  end
  
  it "should validate the uniqueness of name" do
    BatchFeeDiscount.create!(@attr)
    duplicate = BatchFeeDiscount.new(@attr)
    duplicate.should_not be_valid
  end
  
  it "should validate the association of batch" do
    batch = Batch.create!(:name => "Class9", :start_date => 1.year.ago, :end_date => 1.month.ago)
    batch_fee_discount = BatchFeeDiscount.create!(@attr.merge(:receiver => batch))
    batch_fee_discount.should be_valid
  end
  
  it "should validate the presence of receiver_id" do
    batch_fee_discount = BatchFeeDiscount.new(@attr.merge(:receiver_id => nil))
    batch_fee_discount.should_not be_valid
  end
  
end
