require 'spec_helper'

describe ExpensesController do
  
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views
 describe "GET 'all'" do
   
   it "should successful" do
        get :all_record
        response.should be_success
     end
  
     end 
  
  describe "JSON POST 'create'" do
     describe "failure" do
       before(:each) do
          @category = FinanceTransactionCategory.create!(:name => "abc", :description => "category" , :is_income => false, :deleted => false)  
          @user = Factory(:user)   
          controller.current_user = @user
           end
           
          it "should resopnd with error for empty title" do
           @attribute = { :title => '', :amount => 101,:transaction_date => '2011-12-12',:category_id => @category }
         
          post :create, :finance_transaction => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['title'][0].should =~ /can't be blank/
       end
     
     
     it "should resopnd with error for empty amount" do
         @attribute = { :title => 'sdfsdfsdf', :amount => nil,:transaction_date => '2011-12-12',:category_id => @category }
          post :create, :finance_transaction => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['amount'][0].should =~ /can't be blank/
       end
     
       it "should resopnd with error for non positive amount" do
        @attribute = {:title => ' qw  qw', :amount =>  -101,:transaction_date => '2011-12-12' ,:category_id => @category}
          post :create, :finance_transaction => @attribute, :format => :json
         parsed_body = JSON.parse(response.body)
          parsed_body['errors']['amount'][0].should == "must be positive"
       end
     
     it "should resopnd with error for empty category" do
          @attribute = {:title => ' qw  qw',:amount =>  101,:transaction_date => '2011-12-12' }
          post :create, :finance_transaction => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['category'][0].should == "can't be blank"
      end
      end
      
       describe "success" do
         before(:each) do
          @category = FinanceTransactionCategory.create!(:name => "abc", :description => "category" , :is_income => false, :deleted => false)  
          @user = Factory(:user)   
          controller.current_user = @user
          @attribute = { :title => 'ddddd', :amount => 101,:transaction_date => '2011-12-12',:category_id => @category }
          
       end
    it "should successfully  add record" do
        lambda do
          post :create, :finance_transaction => @attribute, :format => :json
        end.should change(FinanceTransaction, :count).by(1)
   end
   
    it "should have right message" do
      
        post :create, :finance_transaction => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Expense was successfully created./
      end
   end
      
   end   
    
    
  
  
  
end


    
