# == Schema Information
#
# Table name: privileges
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'



describe Privilege do
  before(:each) do
    @privilege = Privilege.create!(:name => "Attendance")
  end

  it "should have grading_level_list" do
    @privilege.should respond_to(:users)
  end

it "should has an many :graduated_students" do
    newuser = User.create!(:username  => "mahinddfg",:password  => "mahinder", :email => "dhjfgdfdfgat@jdhdhd.com",:role =>"Employee")
    newuser1 = User.create!(:username  => "mahinddfgdfdferrtr",:password  => "mahinder", :email => "dhjfgdfdfgatttrsd@jdhdhd.com",:role =>"Employee")
    @privilege.users = [newuser,newuser1]
    @privilege.save!
    #this line is used to check hassmany relation
    newuser.privileges.should include(@privilege)
  end
end
