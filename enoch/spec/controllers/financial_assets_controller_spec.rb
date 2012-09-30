require 'spec_helper'


describe FinancialAssetsController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views

  describe "GET 'all'" do
     before(:each) do
        first = Factory(:financial_asset)
       second = Factory(:financial_asset, :title => 'title', :amount => 1000, :is_deleted => false, :is_inactive => false)
       third = Factory(:financial_asset, :title => 'title1', :amount => 2000, :is_deleted => false, :is_inactive => true)
     end
     
     it "should be successful" do
        get :all_record
        response.should be_success
     end
    
     it "should have assets in html table" do
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
    
#     
#       
      before(:each) do
        first = Factory(:financial_asset)
          @attribute4 = { :title => 'test4', :amount => 600, :is_deleted => false, :is_deleted => false }
          @attribute2 = { :title => 'asset', :amount => 500, :is_inactive => false, :is_deleted => false }
        @attribute = { :title => '', :amount => 100, :is_inactive => false, :is_deleted => false }
       @attribute1 = { :title => 'test2', :amount => "", :is_deleted => false, :is_deleted => false }
       @attribute3 = { :title => 'test3', :amount => "amount", :is_deleted => false, :is_deleted => false }
      end
# #      
      it "should be resopnd with error for blank title" do
          post :create, :financial_asset => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['title'][0].should =~ /can't be blank/
       end
       it "should be resopnd with error for duplicate title" do
          post :create, :financial_asset => @attribute2, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['title'][0].should =~ /has already been taken/
       end
       it "should be resopnd with error for blank amount" do
          post :create, :financial_asset => @attribute1, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['amount'][0].should =~ /can't be blank/
       end
       it "should be resopnd with error for invalid amount" do
          post :create, :financial_asset => @attribute3, :format => :json
          parsed_body = JSON.parse(response.body)
           parsed_body['errors']['amount'][0].should =~ /is not a number/
       end
       # # 
# #     
#     
      it "should successfully add add record" do
        lambda do
          post :create, :financial_asset => @attribute4, :format => :json
        end.should change(FinancialAsset, :count).by(1)
      end
# #        
      it "should have right message" do
        post :create, :financial_asset => @attribute4, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /successfully created/
      end
#     
   end   
describe "PUT 'update'" do
    
      
      before(:each) do
       @financial_asset = Factory(:financial_asset)
         @attribute = { :title => 'Loan', :amount => 6000, :description => "description", :is_inactive => false, :is_deleted => false }
      end
       it "should update attributes" do
        put :update, :id => @financial_asset, :financial_asset => @attribute, :format => :json
       
       parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Financial asset was updated successfully/
      end
      end
describe "Delete 'Destroy'" do
       
         before(:each) do
       @financial_asset = Factory(:financial_asset)
        end
        it "should delete financial asset" do
        lambda do
          delete :destroy, :id => @financial_asset, :format => :json
          
        end.should change(FinancialAsset, :count).by(-1)
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /financial asset was deleted successfully/
      end
      
     end
end
