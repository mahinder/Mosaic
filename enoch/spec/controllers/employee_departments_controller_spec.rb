require 'spec_helper'


describe EmployeeDepartmentsController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  render_views

  describe "GET 'all'" do
     before(:each) do
       first = Factory(:employee_department)
       second = Factory(:employee_department, :name => 'Teacher', :code => "Teach")
       third = Factory(:employee_department, :name => 'NonTeacher', :code => "Nonteach", :status => false)
     end
     
     it "should be successful" do
        get :all_record
        response.should be_success
     end
    
     it "should have departments in html table" do
        get :all_record
        response.should have_selector('td', :content => "Department1")
        response.should have_selector('td', :content => "Teacher")
        response.should have_selector('td', :content => "NonTeacher")
     end    
     
  end 
  
  describe "GET 'index'" do
     it "should be successful" do
        get :index
        response.should be_success
     end
  end   
#   
  describe "JSON POST 'create'" do
#     
    describe "failure" do
#       
      before(:each) do
        first = Factory(:employee_department)
        @attribute = { :name => 'Department1', :code => "E1", :status => true }
      end
#      
      it "should be resopnd with error for same name" do
          post :create, :employee_department => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
       end
#        
       it "should be resopnd with error for same code" do
          post :create, :employee_department => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['code'][0].should == "has already been taken"
       end
    end
    
    describe "success" do
#       
      before(:each) do
        @attribute = { :name => 'unknown1', :code => "know1", :status => true }
      end
#       
      it "should successfully add record" do
        lambda do
          post :create, :employee_department => @attribute, :format => :json
        end.should change(EmployeeDepartment, :count).by(1)
      end
#        
      it "should have right message" do
        post :create, :employee_department => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /successfully created/
      end
    end
  end  
   describe "PUT 'update'" do
    
      
      before(:each) do
       @employee_department = Factory(:employee_department)
        @attr = { :name => "department", :code => "code", :status => true }
      end
       it "should update attributes" do
        put :update, :id => @employee_department, :employee_department => @attr, :format => :json
       @employee_department.reload
       @employee_department.name.should == @attr[:name]
       @employee_department.status.should == @attr[:status]
       @employee_department.code.should == @attr[:code]
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Department was updated successfully./
      end
      end
    
 describe "Delete 'Destroy'" do
       
         before(:each) do
        @employee_department = Factory(:employee_department)
        @employee_attr = { :employee_number => 'EMPLO',:joining_date =>20.days.ago,:first_name => 'Anuj',:last_name => 'Kumar',
      :employee_department_id => @employee_department,:employee_grade_id =>1 ,:employee_position_id => 1,
      :employee_category_id => 1,:date_of_birth => Date.today-365
    }
    @employee = Employee.create!(@employee_attr)
        end
        it "should delete employee department" do
       
         delete :destroy, :id => @employee_department, :format => :json
          
       
       parsed_body = JSON.parse(response.body)
       parsed_body['errors']['dependecies'][0].should == "Employee Department cannot be delete"
      end
      
     end
end
