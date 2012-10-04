require 'spec_helper'

describe AdditionalField do
  before(:each) do
    @attr = {
    :name => "name"
  }
  end
  it "should exist" do
  additional_field = AdditionalField.new(@attr)  
 end
 it "should presence" do
additional_field = AdditionalField.new(@attr.merge(:name => ""))
additional_field.should_not be_valid
end
it "should not have duplicate name" do
additional_field = AdditionalField.create!(@attr)
additional_field1 = AdditionalField.new(@attr)
additional_field1.should_not be_valid
end
  
end