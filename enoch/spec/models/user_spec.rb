# == Schema Information
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  username                  :string(255)
#  first_name                :string(255)
#  last_name                 :string(255)
#  email                     :string(255)
#  admin                     :boolean
#  student                   :boolean
#  employee                  :boolean
#  hashed_password           :string(255)
#  salt                      :string(255)
#  reset_password_code       :string(255)
#  reset_password_code_until :datetime
#  created_at                :datetime
#  updated_at                :datetime
#

require 'spec_helper'
include ApplicationHelper

describe User do

  before(:each) do
    @attr = {
      :username =>"mahinder1",
      :first_name =>"mahinder",
      :last_name=> "kumar",
      :email=> "mahi1@yahoo.com",
      :role => "Admin",
      :password =>"mahinder",
      :confirm_password => "mahinder"
    }
   
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require a username" do
    no_name_user = User.new(@attr.merge(:username => ""))
    no_name_user.should_not be_valid
  end

  it "should require a role" do
    no_name_user = User.new(@attr.merge(:role => ""))
    no_name_user.should_not be_valid
  end

  it "should require a valideadminrole" do
    no_name_user = User.new(@attr.merge(:role => "admin"))
    (no_name_user.role).should eql("admin")
  end

  it "should require a validestudentrole" do
    no_name_user = User.new(@attr.merge(:role => "student"))
    (no_name_user.role).should eql("student")
  end

  it "should require a valideemployeerole" do
    no_name_user = User.new(@attr.merge(:role => "employee"))
    (no_name_user.role).should eql("employee")
  end

  it "should require a formated username" do
    no_name_user = User.new(@attr.merge(:username => ">>>"))
    no_name_user.should_not be_valid
  end

  it "should require a unique_username" do
    first =User.create!(@attr.merge(:username => "mahin", :email=> "mahin@yahoo.com"))
    second = User.new(@attr.merge(:username => "mahin", :email=> "mahind@yahoo.com"))
    first.should_not eql(second)
  end

  it "should reject names that are too long" do
    long_name = "a" * 21
    long_name_user = User.new(@attr.merge(:username => long_name))
    long_name_user.should_not be_valid
  end

  it "should require a formated email" do
    no_name_user = User.new(@attr.merge(:email => "mah@"))
    no_name_user.should_not be_valid
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should require a password filed not blank" do
      password_user = User.new(@attr.merge(:password => ""))
      password_user.should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 3
      hash = @attr.merge(:password => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a salt" do
      @user.should respond_to(:salt)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:create_user)
    end

    it "should set the hased password attribute" do
      @user.hashed_password.should_not be_blank
    end

    it "should have a hashed_password" do
      @user.should respond_to(:hashed_password)
    end

    it "should have a self.authenticate?" do
      User.should respond_to(:authenticate?)
    end

    it "should return true if username and password both right" do
     returnvalue = User.authenticate?("mahinder1","mahinder")
     returnvalue.should be_true
    end

    it "should return false if username and password both wrong" do
     returnvalue = User.authenticate?("mahin","mahind")
     returnvalue.should be_false 
    end

    it "should return false if username and password both empty " do
     returnvalue = User.authenticate?("","")
     returnvalue.should be_false
    end

    it "should return false if username is wrong and password is right " do
     returnvalue = User.authenticate?("","mahinder")
     returnvalue.should be_false
    end
    
    it "should return false if username is right and password is wrong " do
     returnvalue = User.authenticate?("mahinder1","mah")
     returnvalue.should be_false
    end
    
    it "should return false if username is empty" do
     returnvalue = User.authenticate?("","mahinder")
     returnvalue.should be_false
    end
    
    it "should return false if password is empty" do
     returnvalue = User.authenticate?("mahinder1","")
     returnvalue.should be_false
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
  end

  describe "student attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to student" do
      @user.should respond_to(:student)
    end
  end

  describe "employee attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to employee" do
      @user.should respond_to(:employee)
    end
  end
  
  describe "functions" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a fullname" do
      @user.should respond_to(:full_name)
    end
    
    it "should require working of fullname" do
        
    (@user.full_name).should eql("mahinder kumar")
    end
    
    it "should have a check_reminders" do
      @user.should respond_to(:check_reminders)
    end
    
    it "should return 0 reminder when no reminders are added" do
    # dont add any reminder
      count = @user.check_reminders
      count.should eql(0) 
    end
    
    it "should return 2 reminder when no2 reminders are added" do
    # add 2 reminder
    @user1 = User.create!(@attr.merge(:username => "mahin",:email=>"mahi@yahoo.com"))
    Reminder.create!(:sender => @user1.id,:recipient => @user.id,:subject =>"dfgdfgdf",:body =>"fswafsdfsdf")
    Reminder.create!(:sender => @user1.id,:recipient => @user.id,:subject =>"dfgdfgdf",:body =>"fswafsdfsdf")
      count = @user.check_reminders   
      count.should eql(2) 
    end
    
    specify "should have a random_string" do
      @user.should respond_to(:random_string)
    end
    
   
    it "random_string should return random value with 10 char if length is 10" do
     randumstring = @user.random_string(10) 
     randumstring.size().should eql(10)
     end
    
    specify "should have a role_name" do
      @user.should respond_to(:role_name)
    end
    
    specify "should have a role_symbols" do
      @user.should respond_to(:role_symbols)
    end
    
    specify "should have a role_symbols" do
      @user.should respond_to(:role_symbols)
    end
  end 
  
  describe "relations" do
     
     before(:each) do
           @user = User.create!(@attr)
    end 
        
    it "should have a privileges attribute" do
      @user.should respond_to(:privileges)
    end
  
    it "should have a student_record attribute" do
      @user.should respond_to(:student_record)
    end
    
    it "should have a employee_record attribute" do
      @user.should respond_to(:employee_record)
    end
    
    it "user should have a have correct previlages" do
     @prv1 = Privilege.create!(:name=>"exam")
     @prv2 = Privilege.create!(:name =>"EnterResults")  
     @user.privileges = [@prv1]
     @user.privileges = [@prv2]
     @user.save!   
     end
    
    # it "user should have studentrecord" do
#      
     # @stud = Student.new(:first_name => "mahinder kumar",:last_name =>"kumar",:admission_no=>1,:class_roll_no =>101)
     # @newstud = User.create(:username =>"mahinder",:password => "mahinder",:email =>"dhjasd@jdhdhd.com",:role =>"Employee")
     # @newstud.student_record = @stud
     # @newstud.save!   
     # end
    
    
   end 
end
