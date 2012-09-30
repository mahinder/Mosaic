require 'spec_helper'


describe EmployeeCategoriesController do
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  render_views
  
  
  describe "GET 'all'" do
     before(:each) do
       first = Factory(:employee_category)
       second = Factory(:employee_category, :name => 'Category2', :prefix => 'E2')
       third = Factory(:employee_category, :name => 'Category3', :prefix => 'E3', :status => false)
     end
     
     it "should be successful for index" do
        get :all_record
        response.should be_success
     end
    
     it "should have categories in html table" do
        get :all_record
        response.should have_selector('td', :content => "Category1")
        response.should have_selector('td', :content => "Category2")
        response.should have_selector('td', :content => "Category3")
     end    
  end 
  
  describe "GET 'index'" do
     it "should be successful" do
        get :index
        response.should be_success
        response.should have_selector 'input[name="url_prefix"]'
        response.should have_selector 'input[type="hidden"][value="/employee_categories"]'
     end
  end 
    
  describe "JSON POST 'create'" do

    describe "failure" do
      
      before(:each) do
        first = Factory(:employee_category)
        @attribute = { :name => 'Category1', :prefix => 'E1' }
      end
     
      it "should be respond with error for same name" do
          post :create, :employee_category => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
      end
      
      it "should be respond with error for same prefix" do
          post :create, :employee_category => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['prefix'][0].should == "has already been taken"
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attribute = { :name => 'Category1', :prefix => 'E1' }
      end
      
      it "should successfully add add record" do
        lambda do
          post :create, :employee_category => @attribute, :format => :json
        end.should change(EmployeeCategory, :count).by(1)
      end
      
      it "should have right message" do
        post :create, :employee_category => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Employee Category was successfully created/
      end
    end
    
     describe "Update" do
       
      before(:each) do
        @first = Factory(:employee_category)
        @attribute = { :name => 'Category7', :prefix => 'E1' }
      end
      
      it "should update the category" do
       put :update, :id => @first,:employee_category => @attribute, :format => :json
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Employee Category is updated successfully./
      end
      
     end
     
     describe "Destroy" do 
       
      before(:each) do
        @first = Factory(:employee_category)
        @attribute = { :name => 'Category1', :prefix => 'E1' }
      end
      
      it "should Delete the category" do
      lambda do
          delete :destroy, :id => @first,:employee_category => @attribute, :format => :json
        end.should change(EmployeeCategory, :count).by(-1)
      end
     end         
  end
end
