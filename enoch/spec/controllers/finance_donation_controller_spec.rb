require 'spec_helper'

describe FinanceDonationsController do
  before(:each) do
       @current_user = User.create!(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end
  
  render_views

 describe "GET 'all'" do
   before(:each) do
     category = FinanceTransactionCategory.find_by_name('Donation')
     if category.nil?
    FinanceTransactionCategory.create!(:name => "Donation")      
     end
       first = Factory(:finance_donation)
       second = Factory(:finance_donation, :donor => 'mahi', :amount => 101)
       third = Factory(:finance_donation, :donor => 'mahin', :amount => 102)
     end
   
   it "should successful" do
        get :all_record
        response.should be_success
     end
  
     end 
  
  describe "JSON POST 'create'" do
    describe "failure" do
      before(:each) do
         category = FinanceTransactionCategory.find_by_name('Donation')
          if category.nil?
            FinanceTransactionCategory.create!(:name => "Donation")      
          end
           first = Factory(:finance_donation)
           end
      it "should resopnd with error for empty donor name" do
        @attribute = { :donor => '', :amount => 101,:transaction_date => '2011-12-12' }
          post :create, :finance_donation => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['donor'][0].should =~ /can't be blank/
       end
      it "should resopnd with error for empty amount" do
        @attribute = { :donor => 'mahi', :amount =>  nil,:transaction_date => '2011-12-12' }
          post :create, :finance_donation => @attribute, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['amount'][0].should =~ /can't be blank/
       end
       it "should resopnd with error for non positive amount" do
        @attribute = { :donor => 'mahi', :amount =>  -101,:transaction_date => '2011-12-12' }
          post :create, :finance_donation => @attribute, :format => :json
         parsed_body = JSON.parse(response.body)
          parsed_body['errors']['amount'][0].should == "must be positive"
       end
      
    end
    
    
    describe "success" do
    before(:each) do
         
        category = FinanceTransactionCategory.find_by_name('Donation')
          if category.nil?
            FinanceTransactionCategory.create!(:name => "Donation")      
          end
       end
    it "should successfully  add record" do
      
        @attribute = { :donor => 'mahi', :amount =>  101, :transaction_date => '2011-12-12' }
        lambda do
          post :create, :finance_donation => @attribute, :format => :json
        end.should change(FinanceDonation, :count).by(1)
   end
   
    it "should have right message" do
       @attribute = { :donor => 'mahi', :amount =>  101, :transaction_date => '2011-12-12' }
        post :create, :finance_donation => @attribute, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Donation accepted./
      end
   
   
   
   
   
   
    end
    
    
  end
  
  
  
end


    
      
