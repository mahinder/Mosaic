require 'spec_helper'

describe FinanceTransactionCategoriesController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views
  describe "GET 'all'" do
    before(:each) do
        first = Factory(:finance_transaction_category)
    end
   
   it "should successful" do
        get :all_record
        response.should be_success
     end
  
   it "should have category in html table" do
        get :all_record
        response.should have_selector('td', :content => "abc")
        
     end    
  
     end 
  
  describe "JSON POST 'create'" do
    describe "failure" do
          before(:each) do
       @attribute = { :name => 'abc'}
           end
        it "should resopnd with error for empty  name" do
          @attribute = { :name => ''}
          post :create, :finance_transaction_category => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /can't be blank/
        end
        it "should be resopnd with error for same name" do
         post :create, :finance_transaction_category => @attribute, :format => :json
         post :create, :finance_transaction_category => @attribute, :format => :json
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
          post :create, :finance_transaction_category => @attribute, :format => :json
          end.should change(FinanceTransactionCategory, :count).by(1)
      end
   
      it "should have right message" do
        post :create, :finance_transaction_category => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Finance transaction category was successfully created./
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
       @finance_transaction_category = Factory(:finance_transaction_category)
        @attr = { :name => "department" }
      end
       it "should update attributes" do
        put :update, :id => @finance_transaction_category, :finance_transaction_category => @attr, :format => :json
       @finance_transaction_category.reload
       @finance_transaction_category.name.should == @attr[:name]
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should =~ /Finance transaction category was updated successfully./
      end
      end
  
  describe "Delete 'Destroy'" do
       
        before(:each) do
        @finance_transaction_category = Factory(:finance_transaction_category)
       @attr = { :deleted => false }
        end
      
      it "should delete finance_transaction_category" do
          @finance_transaction = FinanceTransaction.create!(:title => "car washing ",:amount => 101,:transaction_date  => '2011-12-12',:description => "company car",:category_id  =>  @finance_transaction_category.id)
          delete :destroy, :id => @finance_transaction_category, :finance_transaction_category => @attr, :format => :json
          @finance_transaction_category.reload
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['dependecies'][0].should == "Category cannot be deleted"
      end
      
       it "should delete finance_transaction_category" do
           @finance_transaction_category = Factory(:finance_transaction_category, :name => "DA")
           delete :destroy, :id => @finance_transaction_category, :finance_transaction_category => @attr, :format => :json
           @finance_transaction_category.reload
            parsed_body = JSON.parse(response.body)
            parsed_body['notice'].should =~ /finance_transaction_category was deleted successfully./
      end
      
      
      
      end
      
   
  
end


    
      
