# == Schema Information
#
# Table name: finance_transaction_categories
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  is_income   :boolean
#  deleted     :boolean         default(FALSE), not null
#

require 'spec_helper'

describe FinanceTransactionCategory do 

before(:each) do
  @attr = {:name => "Weekly"}
end

it "should create Finance Transaction Category" do
  FinanceTransactionCategory.create!(@attr) 
end

it "should not create Finance Transaction Category" do
  @finance_transaction_category = FinanceTransactionCategory.new(@attr.merge(:name => ""))
  @finance_transaction_category.should_not be_valid  
end

it "should have association " do
 @finance_transaction_category = FinanceTransactionCategory.new(@attr.merge(:name => "Test Category"))
 @finance_transaction_category.should respond_to(:finance_transactions)
end

end
