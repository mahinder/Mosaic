require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe CalendarsController do

  # This should return the minimal set of attributes required to create a valid
  # Calendar. As you add validations to Calendar, be sure to
  # update the return value of this method accordingly.
  # def valid_attributes
    # {}
  # end
# 
  # describe "GET index" do
    # it "assigns all calendars as @calendars" do
      # calendar = Calendar.create! valid_attributes
      # get :index
      # assigns(:calendars).should eq([calendar])
    # end
  # end
# 
  # describe "GET show" do
    # it "assigns the requested calendar as @calendar" do
      # calendar = Calendar.create! valid_attributes
      # get :show, :id => calendar.id
      # assigns(:calendar).should eq(calendar)
    # end
  # end
# 
  # describe "GET new" do
    # it "assigns a new calendar as @calendar" do
      # get :new
      # assigns(:calendar).should be_a_new(Calendar)
    # end
  # end
# 
  # describe "GET edit" do
    # it "assigns the requested calendar as @calendar" do
      # calendar = Calendar.create! valid_attributes
      # get :edit, :id => calendar.id
      # assigns(:calendar).should eq(calendar)
    # end
  # end
# 
  # describe "POST create" do
    # describe "with valid params" do
      # it "creates a new Calendar" do
        # expect {
          # post :create, :calendar => valid_attributes
        # }.to change(Calendar, :count).by(1)
      # end
# 
      # it "assigns a newly created calendar as @calendar" do
        # post :create, :calendar => valid_attributes
        # assigns(:calendar).should be_a(Calendar)
        # assigns(:calendar).should be_persisted
      # end
# 
      # it "redirects to the created calendar" do
        # post :create, :calendar => valid_attributes
        # response.should redirect_to(Calendar.last)
      # end
    # end
# 
    # describe "with invalid params" do
      # it "assigns a newly created but unsaved calendar as @calendar" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # Calendar.any_instance.stub(:save).and_return(false)
        # post :create, :calendar => {}
        # assigns(:calendar).should be_a_new(Calendar)
      # end
# 
      # it "re-renders the 'new' template" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # Calendar.any_instance.stub(:save).and_return(false)
        # post :create, :calendar => {}
        # response.should render_template("new")
      # end
    # end
  # end
# 
  # describe "PUT update" do
    # describe "with valid params" do
      # it "updates the requested calendar" do
        # calendar = Calendar.create! valid_attributes
        # # Assuming there are no other calendars in the database, this
        # # specifies that the Calendar created on the previous line
        # # receives the :update_attributes message with whatever params are
        # # submitted in the request.
        # Calendar.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        # put :update, :id => calendar.id, :calendar => {'these' => 'params'}
      # end
# 
      # it "assigns the requested calendar as @calendar" do
        # calendar = Calendar.create! valid_attributes
        # put :update, :id => calendar.id, :calendar => valid_attributes
        # assigns(:calendar).should eq(calendar)
      # end
# 
      # it "redirects to the calendar" do
        # calendar = Calendar.create! valid_attributes
        # put :update, :id => calendar.id, :calendar => valid_attributes
        # response.should redirect_to(calendar)
      # end
    # end
# 
    # describe "with invalid params" do
      # it "assigns the calendar as @calendar" do
        # calendar = Calendar.create! valid_attributes
        # # Trigger the behavior that occurs when invalid params are submitted
        # Calendar.any_instance.stub(:save).and_return(false)
        # put :update, :id => calendar.id, :calendar => {}
        # assigns(:calendar).should eq(calendar)
      # end
# 
      # it "re-renders the 'edit' template" do
        # calendar = Calendar.create! valid_attributes
        # # Trigger the behavior that occurs when invalid params are submitted
        # Calendar.any_instance.stub(:save).and_return(false)
        # put :update, :id => calendar.id, :calendar => {}
        # response.should render_template("edit")
      # end
    # end
  # end
# 
  # describe "DELETE destroy" do
    # it "destroys the requested calendar" do
      # calendar = Calendar.create! valid_attributes
      # expect {
        # delete :destroy, :id => calendar.id
      # }.to change(Calendar, :count).by(-1)
    # end
# 
    # it "redirects to the calendars list" do
      # calendar = Calendar.create! valid_attributes
      # delete :destroy, :id => calendar.id
      # response.should redirect_to(calendars_url)
    # end
  # end

end
