require 'spec_helper'

describe BankField do
  before(:each) do
    @attr = {
    :name => "name"
  }
  end
  it "should exist" do
  bank_field = BankField.new(@attr)  
 end
 it "should presence" do
bank_field = BankField.new(@attr.merge(:name => ""))
bank_field.should_not be_valid
end
it "should not have duplicate name" do
bank_field = BankField.create!(@attr)
bank_field1 = BankField.new(@attr)
bank_field1.should_not be_valid
end
  
end