require 'spec_helper'

describe AdditionalFieldsController do
   before(:each) do
      @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena',:last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
       session[:user_id] = @current_user.id
   end
 render_views
 
 describe "GET 'all'" do
     before(:each) do
       first = AdditionalField.create!(:name => "name")
       second = AdditionalField.create!(:name => "name3")
       third = AdditionalField.create!(:name => "name2", :status => false)
       third = AdditionalField.create!(:name => "name4", :status => false)
     end
     
     it "should be successful" do
        get :all_record
        response.should be_success
     end
     it "should have bank fields in html table" do
        get :all_record
         response.should have_selector('td', :content => "name")
         response.should have_selector('td', :content => "name4")
        response.should have_selector('td', :content => "name2")
      end
#         
         
   end
describe "GET 'index'" do
     it "should be successful for index action" do
        get :index
        response.should be_success
     end
  end   
   describe "JSON POST 'create'" do
   describe "failure" do
     before(:each) do
       first = AdditionalField.create!(:name => "field")
        @attribute = { :name => 'field', :status => true }
     end
     it "should be resopnd with error for same name" do
          post :create, :additional_field => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
       end
        it "should be resopnd with error for name presence" do
           @attribute = { :name => "", :status => true }
          post :create, :additional_field => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /can't be blank/
        end
        end
    end
   describe "success" do
#       
      before(:each) do
        @attribute = { :name => 'additional_field', :status => true }
      end
#       
      it "should successfully add record" do
        lambda do
          post :create, :additional_field => @attribute, :format => :json
        end.should change(AdditionalField, :count).by(1)
      end
#        
      it "should have right message" do
        post :create, :additional_field => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /additional field was successfully created./
      end
     end
  describe "PUT 'update'" do
     
#       
      before(:each) do
        @additional_field = Factory(:additional_field)
        @attr = { :name => "field_name", :status => true }
      end
       it "should update attributes" do
        put :update, :id => @additional_field, :additional_field => @attr, :format => :json
        parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Additional Field was updated successfully./
      end
     
    end
      describe "Delete 'Destroy'" do
     
          before(:each) do
         @additional_field = Factory(:additional_field)
         @employee_attr = { :employee_number => 'EMPLO',:joining_date =>20.days.ago,:first_name => 'Anuj',:last_name => 'Kumar',
       :employee_department_id => 1,:employee_grade_id =>1 ,:employee_position_id => 1,
       :employee_category_id => 1,:date_of_birth => Date.today-365
     }
         @employee = Employee.create!(@employee_attr)
        @employee_additional_detail = EmployeeAdditionalDetail.create!(:employee_id => @employee, :additional_field_id => @additional_field)
         end
        
        it "should not delete additional field" do
       delete :destroy, :id => @additional_field, :format => :json
       parsed_body = JSON.parse(response.body)
       parsed_body['errors']['dependecies'][0].should == "Additional field cannot be delete"
       end
       end

end