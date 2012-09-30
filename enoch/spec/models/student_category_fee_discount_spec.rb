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

describe StudentCategoryFeeDiscount do
  
  before(:each) do
    @batch = Batch.create!(:name => "Class1", :start_date => 1.year.ago, :end_date => 1.month.ago)
    @student_category = StudentCategory.create!( :name => "General",:is_deleted => "false")
    @finance_fee_category = FinanceFeeCategory.create!(:name => "monthly" ,:batch => @batch)
    @attr = {:name => "primary discount for student", :receiver => @student_category,:discount =>10 ,:finance_fee_category_id => @finance_fee_category.id}
  end
  
  after(:each) do
    Batch.delete_all
    StudentCategory.delete_all
    FinanceFeeCategory.delete_all
  end
  
  it "should create a new Student category Fee Discount" do
     category_fee_discount = StudentCategoryFeeDiscount.create!(@attr)
     category_fee_discount.should be_valid
  end
  
  it "should respond to attributes" do
    category_fee_discount = StudentCategoryFeeDiscount.create!(@attr)
    category_fee_discount.should respond_to(:receiver)
    category_fee_discount.should respond_to(:receiver_id)
    category_fee_discount.should respond_to(:name)
  end
  
  it "should validate the uniqueness of name" do
    StudentCategoryFeeDiscount.create!(@attr)
    duplicate = StudentCategoryFeeDiscount.new(@attr)
    duplicate.should_not be_valid
  end
  
  it "should validate the association of student category" do
    student_category = StudentCategory.create!( :name => "testcategory",:is_deleted => "false")
    category_fee_discount = StudentCategoryFeeDiscount.create!(@attr.merge(:receiver => student_category))
    category_fee_discount.should be_valid
  end
  
  it "should validate the presence of receiver_id" do
    category_fee_discount = StudentCategoryFeeDiscount.new(@attr.merge(:receiver_id => nil))
    category_fee_discount.should_not be_valid
  end
  
end
