require 'spec_helper'


describe SmsTemplate do
  before(:each) do
    @sms_temp_attr = {
      :template_code => "H1",
      :text => "Today is holiday"
    }
    @sms_template = SmsTemplate.new(@sms_temp_attr)
  end
  it "should have a  template_code attribute" do
    @sms_template.should respond_to(:template_code)
  end

  it "should have a text  attribute" do
    @sms_template.should respond_to(:text)
  end

  it "should have a active  attribute" do
    @sms_template.should respond_to(:is_inactive)
  end
  it "should require a  template_code" do
    no_template_code = SmsTemplate.new(@sms_temp_attr.merge(:template_code => ""))
    no_template_code.should_not be_valid
  end
  it "should require a  message" do
    no_message = SmsTemplate.new(@sms_temp_attr.merge(:text => ""))
    no_message.should_not be_valid
  end
  it "should require a unique template_code" do
    sms_template = SmsTemplate.create!(:template_code => "A1" ,:text => "holiday")
    secound_sms_template = SmsTemplate.new(:template_code => "A1" ,:text => "Tomorrow holiday")
    secound_sms_template.should_not be_valid
  end
  it "should require a unique message" do
    sms_template = SmsTemplate.create!(:template_code => "A1" ,:text => "holiday")
    secound_sms_template = SmsTemplate.new(:template_code => "A12" ,:text => "holiday")
    secound_sms_template.should_not be_valid
  end
  
end
