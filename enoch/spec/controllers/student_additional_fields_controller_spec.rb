require 'spec_helper'


describe StudentAdditionalFieldsController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views
  
  
  describe "GET 'all'" do
     before(:each) do
       first = Factory(:student_additional_field)
       second = Factory(:student_additional_field, :name => 'Passport1')
       third = Factory(:student_additional_field, :name => 'Passport2', :status => false)
     end
     
     it "should be successful for index" do
        get :all_record
        response.should be_success
     end
    
     it "should have categories in html table" do
        get :all_record
        response.should have_selector('td', :content => "Passport")
        response.should have_selector('td', :content => "Passport1")
        response.should have_selector('td', :content => "Passport2")
     end    
  end 
  
  describe "GET 'index'" do
     it "should be successful" do
        get :index
        response.should be_success
        response.should have_selector 'input[name="url_prefix"]'
        response.should have_selector 'input[type="hidden"][value="/student_additional_fields"]'
     end
  end 
    
  describe "JSON POST 'create'" do

    describe "failure" do
      
      before(:each) do
        first = Factory(:student_additional_field)
        @attribute = { :name => 'Passport', :status => true }
      end
     
      it "should be respond with error for same name" do
          post :create, :student_additional_field => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attribute = { :name => 'Passport', :status => true }
      end
      
      it "should successfully add new record" do
        lambda do
          post :create, :student_additional_field => @attribute, :format => :json
        end.should change(StudentAdditionalField, :count).by(1)
      end
      
      it "should have right message" do
        post :create, :student_additional_field => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Student Additional Field was successfully created./
      end
    end
    
     describe "Update" do
       
      before(:each) do
        @first = Factory(:student_additional_field)
        @attribute = {  :name => 'Passport', :status => true }
      end
      
      it "should update the category" do
       put :update, :id => @first,:student_additional_field => @attribute, :format => :json
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Student additional field was successfully updated./
      end
      
     end
     
     describe "Destroy" do 
       
      before(:each) do
        @first = Factory(:student_additional_field)
        @attribute = { :name => 'Passport' , :status => true}
      end
      
      it "should Delete the category" do
      lambda do
          delete :destroy, :id => @first,:student_additional_field => @attribute, :format => :json
        end.should change(StudentAdditionalField, :count).by(-1)
      end
     end
   describe "Association" do 
       
      before(:each) do
        @first = Factory(:student_additional_field, :name => 'RationCard' , :status => true)
        @second = Factory(:student_additional_field, :name => 'RationCards' , :status => true )
        @students = Factory(:student_additional_details, :additional_field_id => @first)
        @attribute = { :name => 'Passport' , :status => true}
      end
      
      it "should not Delete the category" do      
          delete :destroy, :id => @first, :student_additional_field => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['dependency'][0].should =~ /Additional Field can not be deleted/
      end
      
       it "should Delete the category" do 
          delete :destroy, :id => @second,:student_additional_field => @second, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['notice'].should =~ /Additional Field deleted successfully./      
       end        
     end                 
  end
end
