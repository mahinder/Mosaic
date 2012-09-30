# == Schema Information
#
# Table name: finance_transaction_triggers
#
#  id                  :integer         not null, primary key
#  finance_category_id :integer
#  percentage          :decimal(8, 2)
#  title               :string(255)
#  description         :string(255)
#

require 'spec_helper'

describe FinanceTransactionTrigger do 
  
  before(:each) do
    @attr = {:percentage => 5}
  end

  it "should create a new finance transaction trigger" do
    FinanceTransactionTrigger.create(@attr)
  end
  
  it "should respond to finance_category" do
   @finance_transaction_trigger = FinanceTransactionTrigger.create(@attr)
   @finance_transaction_trigger.should respond_to(:finance_category)
  end
  
  it "should valid the numericality of percentage" do
   @finance_transaction_trigger = FinanceTransactionTrigger.new(@attr.merge(:percentage => "percentage"))
   @finance_transaction_trigger.should_not be_valid
  end
  
  it "should valid the association of finance category" do
   @finance_transaction_trigger = FinanceTransactionCategory.create(:name => "months")
   @finance_transaction_trigger = FinanceTransactionTrigger.new(@attr.merge(:percentage => "5", :finance_category => @finance_transaction_trigger))
   @finance_transaction_trigger.should be_valid 
  end
end
