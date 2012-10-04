# == Schema Information
#
# Table name: finance_donations
#
#  id               :integer         not null, primary key
#  donor            :string(255)
#  description      :string(255)
#  amount           :decimal(, )
#  transaction_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  transaction_date :date
#

require 'spec_helper'

describe FinanceDonation do
  before(:each) do
    @attr = {
      :donor=> "Shakti",
      :amount => 100,
      :transaction_date => " January 1, 2011"
    }
    FinanceTransactionCategory.delete_all
    FinanceTransactionCategory.create!(:name => "Donation")
  end

  after(:each) do
    FinanceTransactionCategory.delete_all
  end

  it "should create a new Finance Donation" do
    FinanceDonation.create!(@attr)
  end

  it "should validate the numericality of amount" do
    FinanceDonation.create!(:donor => "Shakti" ,:amount => "200",:transaction_date => " January 1, 2011" )
  end

  it "should not validate the numericality of amount" do
    finance = FinanceDonation.new(:donor => "Shakti" ,:amount => "not valid number",:transaction_date => " January 1, 2011" )
    finance.should_not be_valid
  end
end 
