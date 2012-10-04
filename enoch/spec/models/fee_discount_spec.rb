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

describe FeeDiscount do
  before(:each) do
    @batch = Batch.create!(:name => "Class1", :start_date => 1.year.ago, :end_date => 1.month.ago)
    @finance_fee_category = FinanceFeeCategory.create!(:name => "monthly" ,:batch => @batch)
    @batch_fee_discount= BatchFeeDiscount.create!(:name => "primary discount", :receiver_id => @batch,:discount =>10 ,:finance_fee_category => @finance_fee_category)
    @student_category = StudentCategory.create!( :name => "General",:is_deleted => "false")
    @student =Student.create!(:admission_no => "78954",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.day.ago,
    :gender => "M")
  end
  after(:each) do
    Batch.delete_all
    BatchFeeDiscount.delete_all
    FinanceFeeCategory.delete_all
    StudentCategory.delete_all
  end
  it "should create a new fee discount" do
    batch_fee_discount = BatchFeeDiscount.create!(:name => "primary discount for student", :receiver_id => @batch,:discount =>10)
    student_category_discount = StudentCategoryFeeDiscount.create!(:name => "primary discount for student", :receiver_id => @student_category,:discount =>10)
    student_fee_discount = StudentFeeDiscount.create!(:name => "primary discount for student", :receiver_id => @student,:discount =>10) 
    batch_fee_discount.should be_valid 
    student_category_discount.should be_valid
    student_fee_discount.should be_valid 
  end
  
  it "should respond to attribute" do 
    batch_fee_discount= BatchFeeDiscount.create!(:name => "primary discount for student", :receiver_id => @batch,:discount =>10)
    batch_fee_discount.should respond_to(:finance_fee_category)
    batch_fee_discount.should respond_to(:name)
    batch_fee_discount.should respond_to(:discount)
    batch_fee_discount.should respond_to(:category_name)
    batch_fee_discount.should respond_to(:student_name)
  end
  
  it "should not valid the numericality of discount" do
     student_category_discount = StudentCategoryFeeDiscount.new(:name => "primary discount for student", :receiver_id => @student_category,:discount => "discount")
     student_category_discount.should_not be_valid
  end
   
  it "should not valid the maximum numericalty of discount" do 
     student_category_discount = StudentCategoryFeeDiscount.new(:name => "primary discount for student", :receiver_id => @student_category,:discount => 200)
     student_category_discount.should_not be_valid
  end
  
  it "should not valid the minimum numericalty of discount" do
     student_category_discount = StudentCategoryFeeDiscount.new(:name => "primary discount for student", :receiver_id => @student_category,:discount => 0)
     student_category_discount.should_not be_valid
  end
  
  it "should valid the category_name" do
    # student_category_discount = StudentCategoryFeeDiscount.create!(:name => "primary discount for student", :receiver_id => @student_category,:discount =>10)
    # student_category_discount
  end
  
end 
