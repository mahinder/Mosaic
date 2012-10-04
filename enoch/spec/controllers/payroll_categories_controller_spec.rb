require 'spec_helper'


describe PayrollCategoriesController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views
  describe "GET 'all'" do
    before(:each) do
      first = Factory(:payroll_category)
      second = Factory(:payroll_category, :name => "HRA")
      third = Factory(:payroll_category, :name => "PF")
    end

    it "should successful" do
      get :all_record
      response.should be_success
    end

    it "should have payroll_category in html table" do
      get :all_record
      response.should have_selector('td', :content => "HRA")

    end
 end

describe "JSON POST 'create'" do
    describe "failure" do
          before(:each) do
       
           end
        it "should resopnd with error for empty  name" do
          @attribute = { :name => ''}
          post :create, :payroll_category => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /can't be blank/
        end
        
        it "should be resopnd with error for same name" do
          @attribute = { :name => 'abc'}
          post :create, :payroll_category => @attribute, :format => :json
          post :create, :payroll_category => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should == "has already been taken"
        end
        
     end
     
     describe "success" do
      
       before(:each) do
           @attribute = { :name => 'abc'}
       end
      
        it "should successfully  add record" do
             lambda do
               post :create, :payroll_category => @attribute, :format => :json
               end.should change(PayrollCategory, :count).by(1)
               end

        it "should have right message" do
              post :create, :payroll_category => @attribute, :format => :json
              parsed_body = JSON.parse(response.body)
              parsed_body['notice'].should =~ /Payroll Category was successfully created./
        end

        it "should be resopnd with error for same name" do
            post :create, :payroll_category => @attribute, :format => :json
            post :create, :payroll_category => @attribute, :format => :json
            parsed_body = JSON.parse(response.body)
            parsed_body['errors']['name'][0].should == "has already been taken"
        end
     end
    end

    describe "GET 'index'" do
       it "should be successful" do
          get :index
          response.should be_success
        end
    end

        describe "PUT 'update'" do
          before(:each) do
          @payrollcategory = Factory(:payroll_category)
          @attr = { :name => "HRA" }
          end
        
        it "should update attributes" do
            put :update, :id => @payrollcategory, :payroll_category => @attr, :format => :json
            @payrollcategory.reload
            @payrollcategory.name.should == @attr[:name]
            parsed_body = JSON.parse(response.body)
            parsed_body['notice'].should =~ /Payroll Category was updated successfully./
        end
      end

  describe "Delete 'Destroy'" do

      before(:each) do
        @payroll_category = Factory(:payroll_category)
         @attr = { :employee_number => 'EMP',:joining_date =>20.days.ago,:first_name => 'Mahinder',:last_name => 'Kumar',
      :employee_department_id => 1,:employee_grade_id =>1 ,:employee_position_id => 1,
      :employee_category_id => 1,:date_of_birth => Date.today-365
    }
    @employee = Employee.create!(@attr)
        @monthly_payslip = MonthlyPayslip.create!(:salary_date => Date.today-3, :employee => @employee, :payroll_category => @payroll_category, :amount => 5000)
        end
    
    
      it "should delete payroll_category" do
          delete :destroy, :id => @payroll_category, :format => :json
          parsed_body = JSON.parse(response.body)
       parsed_body['errors']['dependecies'][0].should == "Category cannot be deleted"
end
end

end

