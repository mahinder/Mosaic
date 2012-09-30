require 'spec_helper'

describe EmployeePositionsController do
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
 render_views
  
  
  describe "GET 'all'" do
    
     before(:each) do
        @category = Factory(:employee_category, :name => "SomeCategory" , :prefix => 'SC')
        first = Factory(:employee_position, :name => 'Position1', :employee_category_id => @category)
        second = Factory(:employee_position,:name => 'Position2', :employee_category_id => @category)
        third = Factory(:employee_position, :name => 'Position3', :employee_category_id => @category, :status => false)
      end
     
     it "should be successful" do
        get :all_record
        response.should be_success
     end
    
     it "should have positions in html table" do
        get :all_record
        response.should have_selector('td', :content => "Position1")
        response.should have_selector('td', :content => "Position2")
        response.should have_selector('td', :content => "Position3")
     end  
     
  end 
  
   describe "GET 'index'" do
     it "should be successful" do
        get :index
        response.should be_success
        response.should have_selector 'input[name="url_prefix"]'
        response.should have_selector 'input[type="hidden"][value="/employee_positions"]'
     end
  end 
  describe "JSON POST 'create'" do

    describe "failure" do
      
      before(:each) do
        @employee_category = Factory(:employee_category, :name => 'SunilCategory', :prefix => 'sunil')
        first = Factory(:employee_position)
        @attribute = { :name => 'Position1',:employee_category_id => @employee_category }
      end
      
      it "create a record" do
        post :create, :employee_position => {:name => 'PositionCreated',:employee_category_id => @employee_category }, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /successfully created/
      end
     
      it "should be resopnd with error for Same Name" do    
          post :create, :employee_position => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
      end 
      end     
    end
  describe "success" do
      
      before(:each) do
        @employee_another_category = Factory(:employee_category, :name => 'BrahamCategory', :prefix => 'braham')
        @first = Factory(:employee_position)
        @attribute = { :name => 'Position6', :employee_category_id => @employee_another_category }
      end
      
      it "should successfully add add record" do
        lambda do
          post :create, :employee_position => @attribute, :format => :json
        end.should change(EmployeePosition, :count).by(1)
      end
      
      it "should update the category" do
       put :update, :id => @first,:employee_position => @attribute, :format => :json
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Employee Position was updated successfully./
      end
    end
    
     describe "Destroy" do 
       
      before(:each) do
        @employee_another_category1 = Factory(:employee_category, :name => 'MahinderCategory', :prefix => 'mahinder')
        @department = Factory(:employee_department)
        @first = Factory(:employee_position )
        @first_employee = Factory(:employee,:employee_position => @first, :employee_number => 'emp2', :employee_department_id => @department, :employee_category_id => @employee_another_category1,:first_name => 'Karan' ,:date_of_birth => Date.today)
        @attribute = { :name => 'TGT', :employee_category_id => @employee_another_category1 }
      end
      
      it "should not Delete the position" do
          delete :destroy, :id => @first, :employee_position => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['dependency'][0].should =~ /Employee Position can not be deleted/
      end
     end    
end
