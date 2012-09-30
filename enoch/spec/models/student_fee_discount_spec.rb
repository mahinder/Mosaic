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

describe StudentFeeDiscount do
  
  before(:each) do
    @batch = Batch.create!(:name => "Class1", :start_date => 1.year.ago, :end_date => 1.month.ago)
    @finance_fee_category = FinanceFeeCategory.create!(:name => "monthly" ,:batch => @batch)
    @student =Student.create!(:admission_no => "78954",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.day.ago,
    :gender => "M")
    @attr = {:name => "primary discount for student", :receiver => @student,:discount =>10 ,:finance_fee_category_id => @finance_fee_category.id}
  end
  
  after(:each) do
    Batch.delete_all
    Student.delete_all
    FinanceFeeCategory.delete_all
  end
  
  it "should create a new Student category Fee Discount" do
     student_fee_discount = StudentFeeDiscount.create!(@attr)
     student_fee_discount.should be_valid
  end
  
  it "should respond to attributes" do
    student_fee_discount = StudentFeeDiscount.create!(@attr)
    student_fee_discount.should respond_to(:receiver)
    student_fee_discount.should respond_to(:receiver_id)
    student_fee_discount.should respond_to(:name)
  end
  
  it "should validate the uniqueness of name" do
    StudentFeeDiscount.create!(@attr)
    duplicate = StudentFeeDiscount.new(@attr)
    duplicate.should_not be_valid
  end
  
  it "should validate the association of student category" do
    student_category = Student.create!(:admission_no => "789454",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.day.ago,
    :gender => "M")
    student_fee_discount = StudentFeeDiscount.create!(@attr.merge(:receiver => student_category))
    student_fee_discount.should be_valid
  end
  
  it "should validate the presence of receiver_id" do
    category_fee_discount = StudentFeeDiscount.new(@attr.merge(:receiver_id => nil))
    category_fee_discount.should_not be_valid
  end
  
end
