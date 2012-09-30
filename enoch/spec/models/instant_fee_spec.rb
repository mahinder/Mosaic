require 'spec_helper'

describe InstantFee do
  
before(:each) do
  @school_session = SchoolSession.create(:name => '2012-2013',:current_session => true, :start_date => Date.today-1.year ,:end_date =>Date.today)
  @attr = {
  :name => "New Instant Fees",
  :description => "New Instant Fees Description",
  :school_session_id => @school_session.id
  }
end
 it "should valid new Instant Fees" do
    instant_fee = InstantFee.new(@attr)
    instant_fee.should be_valid
 end
 
 it "should not valid without name" do
    instant_fee = InstantFee.create(@attr.merge(:name =>""))
    instant_fee.should_not be_valid
    instant_fee.errors[:name].should == ["can't be blank"]
 end
 
 it "should not valid without description" do
    instant_fee = InstantFee.create(@attr.merge(:description =>""))
    instant_fee.should_not be_valid
    instant_fee.errors[:description].should == ["can't be blank"]
 end
 
 it "should not valid without school session" do
    instant_fee = InstantFee.create(@attr.merge(:school_session_id =>""))
    instant_fee.should_not be_valid
    instant_fee.errors[:school_session_id].should == ["can't be blank"]
 end 
 
 it "should not valid because of uniqueness of name" do
    instant_fee1 = InstantFee.create(@attr)
    instant_fee2 = InstantFee.create(:name => "New Instant Fees",:description => "New Instant Fees Description", :school_session_id => @school_session.id)
    instant_fee2.should_not be_valid
    instant_fee2.errors[:name].should == ["has already been taken"]
 end  
 
 it "should valid has many fees particular" do
   
 end

end
