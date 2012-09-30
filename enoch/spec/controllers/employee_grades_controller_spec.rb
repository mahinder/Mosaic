require 'spec_helper'


describe EmployeeGradesController do
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  render_views

  describe "GET 'all'" do
     before(:each) do
       first = Factory(:employee_grade)
       second = Factory(:employee_grade, :name => 'Grade2', :priority => 101)
       third = Factory(:employee_grade, :name => 'Grade3', :priority => 102, :status => false)
     end
     
     it "should be successful" do
        get :all_record
        response.should be_success
     end
    
     it "should have grades in html table" do
        get :all_record
        response.should have_selector('td', :content => "Grade1")
        response.should have_selector('td', :content => "Grade2")
        response.should have_selector('td', :content => "Grade3")
     end    
     
  end 
  
  describe "GET 'index'" do
     it "should be successful" do
        get :index
        response.should be_success
     end
  end   
  
  describe "JSON POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        first = Factory(:employee_grade)
        @attribute = { :name => 'Grade1', :priority => 101 }
      end
     
      it "should be resopnd with error for same name" do
          post :create, :employee_grade => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /has already been taken/
       end
       
       it "should be resopnd with error for same priority" do
          post :create, :employee_grade => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should == "has already been taken"
       end
    end
    
    describe "success" do
      
      before(:each) do
        @attribute = { :name => 'Grade10', :priority => 110 }
      end
      
      it "should successfully add add record" do
        lambda do
          post :create, :employee_grade => @attribute, :format => :json
        end.should change(EmployeeGrade, :count).by(1)
      end
       
      it "should have right message" do
        post :create, :employee_grade => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /successfully created/
      end
      
      it "should have the right title" do
        
      end
    end
  end   

end
