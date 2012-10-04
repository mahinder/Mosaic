require 'spec_helper'


describe StudentCategoriesController do
   before(:each) do
      @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena',:last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
       session[:user_id] = @current_user.id
   end
  render_views

  describe "GET 'all'" do 
     before(:each) do
       first = Factory(:student_category)
       second = Factory(:student_category, :name => 'Category2')
       third = Factory(:student_category, :name => 'Category3', :is_deleted => false)
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
        response.should have_selector 'input[type="hidden"][value="/student_categories"]'
     end
  end 
    
  describe "JSON POST 'create'" do

    describe "failure" do
      
      before(:each) do
        first = Factory(:student_category)
        @attribute = { :name => 'Category1', :is_deleted => false }
      end
     
      it "should be respond with error for same name" do
          post :create, :student_category => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attribute = { :name => 'Category1', :is_deleted => false }
      end
      
      it "should successfully add add record" do
        lambda do
          post :create, :student_category => @attribute, :format => :json
        end.should change(StudentCategory, :count).by(1)
      end
      
      it "should have right message" do
        post :create, :student_category => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Student Category is successfully created./
      end
    end
    
     describe "Update" do
       
      before(:each) do
        @first = Factory(:student_category)
        @attribute = {  :name => 'Category1', :is_deleted => false }
      end
      
      it "should update the category" do
       put :update, :id => @first,:student_category => @attribute, :format => :json
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Student Category is successfully updated./
      end
         
     end
     
     describe "Destroy" do 
       
      before(:each) do
        @first = Factory(:student_category)
        @second = Factory(:student_category,:name => 'Category22' , :is_deleted => false )
        @students = Factory(:student, :student_category_id => @first)
        @attribute = { :name => 'Category1' , :is_deleted => false}
      end
      
      it "should not Delete the category" do      
          delete :destroy, :id => @first, :employee_position => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['dependency'][0].should =~ /Employee Category can not be deleted/
      end
      
       it "should Delete the category" do 
          delete :destroy, :id => @second,:student_category => @second, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['notice'].should =~ /Employee Category is deleted successfully./      
       end        
     end         
  end
end
