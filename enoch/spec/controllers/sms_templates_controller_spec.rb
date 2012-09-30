require 'spec_helper'



describe SmsTemplatesController do
  before(:each) do
    @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena',:last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
    session[:user_id] = @current_user.id
  end
  render_views

  describe "GET 'all_record'" do
    before(:each) do
      sms_template_first = SmsTemplate.create!(:template_code => "A1" ,:text => "holiday",:is_inactive => false)
      sms_template_secound = SmsTemplate.create!(:template_code => "A2" ,:text => "holidays",:is_inactive => true)
    end
    it "should be successful" do
      get :all_record
      response.should be_success
    end
    it "should have bank fields in html table" do
      get :all_record
      response.should have_selector('a', :content => "Active")
      response.should have_selector('a', :content => "Inactive")
      response.should have_selector('td', :content => "A1")
      response.should have_selector('td', :content => "A2")
    end
  #

  end
  describe "GET index" do
it "assigns all sms_templates as @sms_templates" do
      sms_template = SmsTemplate.create! valid_attributes
      get :index
      assigns(:sms_templates).should eq([sms_template])
    end
  end
#
# describe "GET show" do
# it "assigns the requested sms_template as @sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# get :show, :id => sms_template.id
# assigns(:sms_template).should eq(sms_template)
# end
# end
#
# describe "GET new" do
# it "assigns a new sms_template as @sms_template" do
# get :new
# assigns(:sms_template).should be_a_new(SmsTemplate)
# end
# end
#
# describe "GET edit" do
# it "assigns the requested sms_template as @sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# get :edit, :id => sms_template.id
# assigns(:sms_template).should eq(sms_template)
# end
# end
#
# describe "POST create" do
# describe "with valid params" do
# it "creates a new SmsTemplate" do
# expect {
# post :create, :sms_template => valid_attributes
# }.to change(SmsTemplate, :count).by(1)
# end
#
# it "assigns a newly created sms_template as @sms_template" do
# post :create, :sms_template => valid_attributes
# assigns(:sms_template).should be_a(SmsTemplate)
# assigns(:sms_template).should be_persisted
# end
#
# it "redirects to the created sms_template" do
# post :create, :sms_template => valid_attributes
# response.should redirect_to(SmsTemplate.last)
# end
# end
#
# describe "with invalid params" do
# it "assigns a newly created but unsaved sms_template as @sms_template" do
# # Trigger the behavior that occurs when invalid params are submitted
# SmsTemplate.any_instance.stub(:save).and_return(false)
# post :create, :sms_template => {}
# assigns(:sms_template).should be_a_new(SmsTemplate)
# end
#
# it "re-renders the 'new' template" do
# # Trigger the behavior that occurs when invalid params are submitted
# SmsTemplate.any_instance.stub(:save).and_return(false)
# post :create, :sms_template => {}
# response.should render_template("new")
# end
# end
# end
#
# describe "PUT update" do
# describe "with valid params" do
# it "updates the requested sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# # Assuming there are no other sms_templates in the database, this
# # specifies that the SmsTemplate created on the previous line
# # receives the :update_attributes message with whatever params are
# # submitted in the request.
# SmsTemplate.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
# put :update, :id => sms_template.id, :sms_template => {'these' => 'params'}
# end
#
# it "assigns the requested sms_template as @sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# put :update, :id => sms_template.id, :sms_template => valid_attributes
# assigns(:sms_template).should eq(sms_template)
# end
#
# it "redirects to the sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# put :update, :id => sms_template.id, :sms_template => valid_attributes
# response.should redirect_to(sms_template)
# end
# end
#
# describe "with invalid params" do
# it "assigns the sms_template as @sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# # Trigger the behavior that occurs when invalid params are submitted
# SmsTemplate.any_instance.stub(:save).and_return(false)
# put :update, :id => sms_template.id, :sms_template => {}
# assigns(:sms_template).should eq(sms_template)
# end
#
# it "re-renders the 'edit' template" do
# sms_template = SmsTemplate.create! valid_attributes
# # Trigger the behavior that occurs when invalid params are submitted
# SmsTemplate.any_instance.stub(:save).and_return(false)
# put :update, :id => sms_template.id, :sms_template => {}
# response.should render_template("edit")
# end
# end
# end
#
# describe "DELETE destroy" do
# it "destroys the requested sms_template" do
# sms_template = SmsTemplate.create! valid_attributes
# expect {
# delete :destroy, :id => sms_template.id
# }.to change(SmsTemplate, :count).by(-1)
# end
#
# it "redirects to the sms_templates list" do
# sms_template = SmsTemplate.create! valid_attributes
# delete :destroy, :id => sms_template.id
# response.should redirect_to(sms_templates_url)
# end
# end

end
