# == Schema Information
#
# Table name: school_configurations
#
#  id           :integer         not null, primary key
#  config_key   :string(255)
#  config_value :string(255)
#

require 'spec_helper'


describe SchoolConfiguration do

  before (:each) do
    @attr = { :config_key => "StudentAttendanceType",
      :config_value => "Daily"
    }

    SchoolConfiguration.create!(@attr)

  end

  describe "validate" do

    before(:each) do
      @config = SchoolConfiguration.new(@attr)
    end

    it "should have a config_key attribute" do
      @config.should respond_to(:config_key)
    end

    it "should have a config_value attribute" do
      @config.should respond_to(:config_value)
    end

  end

  describe "validate method failure for StudentAttendanceType" do

    before(:each) do
      @config = SchoolConfiguration.new(@attr.merge(:config_key => 'StudentAttendanceType', :config_value => "invalid value"))
    end

    it "should exist" do
      @config.should respond_to(:validate)
    end

    it "should return true if the config_key match" do
      @config.validate
      @config.errors.messages[:config_key].should eql(["Student Attendance Type should be any one of [\"Daily\", \"SubjectWise\"]"])
      @config.errors.messages.size.should eql(1)
    end

  end

  describe "validate method success for StudentAttendanceType" do
    before(:each) do
      @config = SchoolConfiguration.new(@attr.merge(:config_key => 'StudentAttendanceType', :config_value => "Daily"))
    end

    it "should return true if the config_key match" do
      @config.validate
      @config.errors.messages[:config_key].should_not eql(["Student Attendance Type should be any one of [\"Daily\", \"SubjectWise\"]"])
      @config.errors.messages.size.should eql(0)
    end
  end
  describe "validate method sucess for NetworkState" do
  #
    it "should return true if the config_key match" do
      @config = SchoolConfiguration.new(@attr.merge(:config_key => 'NetworkState', :config_value => "Online"))
      @config.validate
      @config.errors.messages[:config_keys].should_not eql(["Network State should be any one of [\"Online\", \"Offline\"]"])
      @config.errors.messages.size.should eql(0)
    end
    it "should return false if the config_key does not match" do
      @config = SchoolConfiguration.new(@attr.merge(:config_key => 'NetworkState', :config_value => "online"))
      @config.validate
      @config.errors.messages[:config_keys].should eql(["Network State should be any one of [\"Online\", \"Offline\"]"])
      @config.errors.messages.size.should eql(1)
    end
  end
  #
  describe "get_config_value" do
  #
    it "get_config_value should exist" do
      SchoolConfiguration.should respond_to(:get_config_value)
    end
    it "should return nul if config_value does not found" do
      keys = SchoolConfiguration.get_config_value('invalid value')
      keys.should eql(nil)
    end
    it "should return config_value if config_value found in database" do
    # @config = SchoolConfiguration.new(@attr.merge(:config_key => 'StudentAttendanceType', :config_value => "Daily"))
      keys = SchoolConfiguration.get_config_value('StudentAttendanceType')
      keys.should eql("Daily")
    end
  end
  # # # describe "save_institution_logo" do
  # # # before(:each) do
  # # # @config = SchoolConfiguration.new(@attr)
  # # # end
  # # # it "save_institution_logo should exist" do
  # # # SchoolConfiguration.should respond_to(:save_institution_logo)
  # # # end
  # # # it "write file" do
  # # # SchoolConfiguration.save_institution_logo("/home/sunil/ezzie/enoch/app/assets/images/rails.png")
  # # # end
  # # #
  # # # end
  describe "available_modules" do
    before(:each) do
      @config = SchoolConfiguration.new(@attr.merge(:config_key => 'AvailableModules', :config_value => "HR"))
      @config.save!
    end

    it "get_config_value method should exist" do
      SchoolConfiguration.should respond_to(:available_modules)
    end
    it "available_module should pass" do
      schoolconfiguration = SchoolConfiguration.available_modules
      schoolconfiguration.should eql(['HR'])
    end
  end

  describe "set_values" do
    it "check existance of set_value method" do
      SchoolConfiguration.should respond_to(:set_value)
    end

    it " should create config_key if config_key does not found in database" do
      @config = SchoolConfiguration.new(:config_key => 'configkeys', :config_value => 'AvailableModules')
      another = SchoolConfiguration.set_value('configkeys', 'AvailableModules')
      another.attributes.except('id').should eql(@config.attributes.except('id'))
    end
    it " should update key_value if config_key found" do
      @config = SchoolConfiguration.new(:config_key => 'configkeys', :config_value => 'AvailableModule')

      another = SchoolConfiguration.set_value('configkeys', 'AvailableModule')
      another.attributes.except('id').should eql(@config.attributes.except('id'))
    end
  end

  describe "get_multiple_configs_as_hash" do
    before(:each) do
      @config = SchoolConfiguration.new(@attr.merge(:config_key => 'AvailableModules', :config_value => "HR"))
      @config.save!

      @config1 = SchoolConfiguration.new(@attr.merge(:config_key => 'StudentAttendanceType', :config_value => "Daily"))
      @config1.save!

    end

    it "get_multiple_configs_as_hash must exist" do

      SchoolConfiguration.should respond_to(:get_multiple_configs_as_hash)

    end

    it "should pass get_multiple_configs_as_hash method " do
      @config_keys = Array.new ["AvailableModules", "StudentAttendanceType"]
      as_hash = SchoolConfiguration.get_multiple_configs_as_hash(@config_keys)
      as_hash.should eql({:available_modules=>"HR", :student_attendance_type=>"Daily"})

    end

  end
end
