require 'spec_helper'


describe LiabilitiesController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views

  describe "GET 'all'" do
     before(:each) do
        first = Factory(:liability)
       second = Factory(:liability, :title => 'title', :amount => 1000, :is_deleted => false, :is_solved => false)
       third = Factory(:liability, :title => 'title1', :amount => 2000, :is_deleted => true, :is_solved => false)
     end
     
     it "should be successful" do
        get :all_record
        response.should be_success
     end
    
     it "should have liabilities in html table" do
        get :all_record
        response.should have_selector('td', :content => "title")
        response.should have_selector('td', :content => "title1")
        # response.should have_selector('td', :content => "test")
     end    
#      
  end 
  
  describe "GET 'index'" do
     it "should be successful" do
        get :index
        response.should be_success
     end
  end   
#   
  describe "JSON POST 'create'" do
    
    
      
      before(:each) do
        first = Factory(:liability)
         @attribute4 = { :title => 'test4', :amount => "600", :is_solved => false, :is_deleted => false }
         @attribute2 = { :title => 'liability', :amount => "500", :is_solved => false, :is_deleted => false }
        @attribute = { :title => '', :amount => 100, :is_solved => false, :is_deleted => false }
      @attribute1 = { :title => 'test2', :amount => "", :is_solved => false, :is_deleted => false }
      @attribute3 = { :title => 'test3', :amount => "amount", :is_solved => false, :is_deleted => false }
      end
#      
      it "should be resopnd with error for blank title" do
          post :create, :liability => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['title'][0].should =~ /can't be blank/
       end
       it "should be resopnd with error for duplicate title" do
          post :create, :liability => @attribute2, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['title'][0].should =~ /has already been taken/
       end
       it "should be resopnd with error for blank amount" do
          post :create, :liability => @attribute1, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['amount'][0].should =~ /can't be blank/
       end
       it "should be resopnd with error for invalid amount" do
          post :create, :liability => @attribute3, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['amount'][0].should =~ /is not a number/
       end
       # 
#     
    
      it "should successfully add add record" do
        lambda do
          post :create, :liability => @attribute4, :format => :json
        end.should change(Liability, :count).by(1)
      end
#        
      it "should have right message" do
        post :create, :liability => @attribute4, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /successfully created/
      end
    
  end   
describe "PUT 'update'" do
    
      
      before(:each) do
       @liability = Factory(:liability)
         @attribute = { :title => 'Loan', :amount => "6000", :description => "description", :is_solved => false, :is_deleted => false }
      end
       it "should update attributes" do
        put :update, :id => @liability, :liability => @attribute, :format => :json
       # @liability.reload
       # @liability.title.should eql(@attribute[:title])
       # @liability.description.should eql(@attribute[:description])
       # @liability.amount.should eql(@attribute[:amount])
        # @liability.is_solved.should eql(@attribute[:is_solved])
         # @liability.is_deleted.should == @attribute[:is_deleted]
       parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Liability was updated successfully./
      end
      end
describe "Delete 'Destroy'" do
       
         before(:each) do
        @liability = Factory(:liability)
        end
        it "should delete liability" do
        lambda do
          delete :destroy, :id => @liability, :format => :json
          
        end.should change(Liability, :count).by(-1)
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Liability was deleted successfully./
      end
      
     end
end
