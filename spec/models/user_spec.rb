require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => 'User Name',
      :password => 'password',
      :password_confirmation => 'password'
    }
  end
  it "should valid the user attribute" do
    user = User.new(@attr)
    user.should be_valid
  end

  it "should require a username" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require a unique_username" do
    first =User.create(@attr.merge(:name => "mahin"))
    second = User.new(@attr.merge(:name => "mahin"))
    first.should_not eql(second)
  end

  it "should reject names that are too long" do
    long_name = "a" * 21
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should respond to create user" do
    user = User.new(@attr)
    user.should respond_to(:create_user)
  end

  it "should return false if username and password both empty " do
    returnvalue = User.authenticate?("","")
    returnvalue.should be_false
  end
  
  it "should have many albums" do
    user = User.new(@attr)
    album1 = Album.create(:name => 'Album 1',:user_id => user.id)
    album2 = Album.create(:name => 'Album 2',:user_id => user.id)
    user.albums == [album1,album2]
  end
  
  it "should raise error for last user" do
    user = User.new(@attr)
    user.delete
    user.should raise_error
  end
end
