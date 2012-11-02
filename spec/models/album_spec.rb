require 'spec_helper'

describe Album do
  before(:each) do
    user_attr = {
      :name => 'User Name',
      :password => 'password',
      :password_confirmation => 'password'
    }
    @user = User.create(user_attr)
    @attr = {
      :name => 'Album Name',
      :user_id => @user.id
    }
  end
  it "should valid the Album attribute" do
    album = Album.new(@attr)
    album.should be_valid
  end

  it "should require a name" do
    no_name_album = Album.new(@attr.merge(:name => ""))
    no_name_album.should_not be_valid
  end
  
  it "should require a unique_name" do
    first =Album.create(@attr.merge(:name => "mahin"))
    second = Album.new(@attr.merge(:name => "mahin"))
    first.should_not eql(second)
  end
end
