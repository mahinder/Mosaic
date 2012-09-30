require 'spec_helper'

describe EventController do

 before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'password',:first_name => 'Enoch', :last_name => 'Administrator',:email=> 'enoch@ezzie.in',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end

  def valid_attributes
    {:title => 'Meeting', :description => 'Meeting of All Student', :start_date => Date.today+1.day,:end_date => Date.today+1.day}
  end

  describe "GET index" do
    it "create new Event" do
      post :index ,:events => valid_attributes
      response.should redirect_to(:action => 'show',:id => Event.last )
    end
    
    it "Increases Event count by one" do
        expect {
          post :index, :events => valid_attributes
        }.to change(Event, :count).by(1)
     end
  end
  
  describe "GET course_event" do
    
    it "create Batch Event" do
      expect {
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:batch_id =>[1,2]}
      }.to change(BatchEvent, :count).by(2)
    end
    
    it "create Department Event" do
      expect {
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:department_id =>[1,2]}
      }.to change(EmployeeDepartmentEvent, :count).by(2)
    end    
    
    it "should create valid Notice for Department" do
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:department_id =>[1,2]}, :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body['notice'].should =~ /Sucessfully added Department/     
    end
  
    it "should create valid Notice for Batch" do
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:batch_id =>[1,2]}, :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body['notice'].should =~ /Sucessfully added Batch/     
    end    

    it "should create valid Notice for Batch And Department" do
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:batch_id =>[1,2],:department_id =>[1,2]}, :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body['notice'].should == "Sucessfully added Batch and department"    
    end      
  end

 describe "GET remove_batch" do
   
    it "should remove the Batch Event" do
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:batch_id =>[1,2]}, :format => :json
      lambda do
      get :remove_batch ,:event_id => event.id ,:batch_id => 2
      end.should change(BatchEvent, :count).by(-1)     
    end
    
    it "should remove the Department Event" do
      event = Event.create valid_attributes
      get :course_event ,:id => event.id ,:select_options => {:department_id =>[1,2]}, :format => :json
      lambda do
      get :remove_department ,:event_id => event.id ,:employee_department_id => 2
      end.should change(EmployeeDepartmentEvent, :count).by(-1)     
    end      
 end
  describe "GET show" do
    it "should get show" do
      event = Event.create valid_attributes
      get :show, :id => event.id
      assigns(:event).should eq(event)
    end
  end 

  describe "GET Confirm Event" do
    it "should confirm the event for ALL" do
      event = Event.create!(:title => 'Meeting111', :description => 'Meeting of All Student',:is_common => true, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
      lambda do
        get :confirm_event, :id => event.id
      end.should change(Reminder, :count).by(1)
    end

    it "should confirm the event for ALL" do
     batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
     department= Factory(:employee_department)
     position = Factory(:employee_position)
     student = Factory(:student, :batch_id => batch)
     employee =  Employee.create(:employee_department_id => department, :employee_position => position,:employee_number => 'EMPP1',:first_name => "Shakti",:date_of_birth => Date.today-25.year)
     event = Event.create(:title => 'Meeting', :description => 'Meeting of All Student',:is_common => true, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
      lambda do
        get :confirm_event, :id => event.id
      end.should change(ReminderRecipient, :count).by(2)
    end
    
    it "should send Reminder Receipient to only Batch" do
     batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
     course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
     course.batches =[batch]
     course.save
     department= Factory(:employee_department)
     position = Factory(:employee_position)
     student = Factory(:student, :batch_id => batch.id)
     employee =  Employee.create(:employee_department_id => department, :employee_position => position,:employee_number => 'EMPP1',:first_name => "Shakti",:date_of_birth => Date.today-25.year)
     event = Event.create(:title => 'Meeting', :description => 'Meeting of All Student',:is_common => false, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
      get :course_event ,:id => event.id ,:select_options => {:batch_id =>[batch.id]}
    lambda do
        get :confirm_event, :id => event.id
      end.should change(ReminderRecipient, :count).by(1)
    end  
    
    it "should increase Reminder Recipient count" do
      event = Event.create(:title => 'Meeting', :description => 'Meeting of All Student',:is_common => true, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
        get :confirm_event, :id => event.id
      response.should redirect_to(:controller => 'calendars', :action => 'index') 
    end    
    
  end
  
  describe "GET Cancel Event" do
    
    it "should cancel the event" do
      event = Event.create(:title => 'Meeting', :description => 'Meeting of All Student',:is_common => true, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
        get :cancel_event, :id => event.id 
      response.should redirect_to( :action => 'index')
    end
    
    it "should cancel the event and delete Event" do
      event = Event.create(:title => 'Meeting', :description => 'Meeting of All Student',:is_common => true, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
      lambda do
        get :cancel_event, :id => event.id
      end.should change(Event, :count).by(-1)
    end     
  end  

 describe "GET Edit Event" do
    it "should edit the event" do
      event = Event.create(:title => 'Meeting', :description => 'Meeting of All Student',:is_common => true, :start_date => Date.today+1.day,:end_date => Date.today+1.day)
        post :edit_event, :id => event.id
      response.should redirect_to( :action => 'show', :id => event.id ,:cmd => 'edit')
    end   
  end  
end
