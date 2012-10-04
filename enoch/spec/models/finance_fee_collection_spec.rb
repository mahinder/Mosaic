# == Schema Information
#
# Table name: finance_fee_collections
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  start_date      :date
#  end_date        :date
#  due_date        :date
#  fee_category_id :integer
#  batch_id        :integer
#  is_deleted      :boolean         default(FALSE), not null
#

require 'spec_helper'


describe FinanceFeeCollection do
  before(:each) do
    @batch = Batch.create!(:name => "Class4", :start_date => 1.year.ago, :end_date => 1.month.ago ,:is_active => 't')
    @finance_fee_category = FinanceFeeCategory.create!(:name => "monthly" ,:batch => @batch) 
    @attr = {:name => "Student Fee",
      :start_date => 1.month.ago ,
      :fee_category_id => @finance_fee_category.id,
      :end_date => 2.day.ago,
      :due_date => 1.day.ago,
      :batch => @batch }
    @student =Student.create!(:admission_no => "78194",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.day.ago,
    :gender => "M")
  end

  it "should create Finance fee Collection" do
    finance_fee_collection=FinanceFeeCollection.create!(@attr)
    finance_fee_collection.should be_valid
  end

  it "should respond to attribute" do
    finance_fee_collection=FinanceFeeCollection.create!(@attr)
    finance_fee_collection.should respond_to(:name)
    finance_fee_collection.should respond_to(:start_date)
    finance_fee_collection.should respond_to(:fee_category)
    finance_fee_collection.should respond_to(:end_date)
    finance_fee_collection.should respond_to(:due_date)
    finance_fee_collection.should respond_to(:batch)
    finance_fee_collection.should respond_to(:students)
    finance_fee_collection.should respond_to(:fee_category)
    finance_fee_collection.should respond_to(:fee_collection_particulars)
    finance_fee_collection.should respond_to(:fee_collection_discounts)
    finance_fee_collection.should respond_to(:finance_fees)
  end

  it "should belong to batch" do
    finance_fee_collection=FinanceFeeCollection.new(@attr.merge(:batch => @batch))
    finance_fee_collection.save!
    finance_fee_collection.should be_valid
  end

  it "should belong to finance fee particulars" do
    student_category= StudentCategory.create!( :name => "General",:is_deleted => "false")
    finance_fee_collection=FinanceFeeCollection.create!(@attr)
    fee_particular1 = FeeCollectionParticular.create!(:name => "fee particular",:amount => 100, :student_category =>student_category,:finance_fee_collection => finance_fee_collection)
    fee_particular2 = FeeCollectionParticular.create!(:name => "fee particulars",:amount => 200, :student_category =>student_category,:finance_fee_collection => finance_fee_collection)
    finance_fee_collection.fee_collection_particulars.should == [fee_particular1, fee_particular2]
  end

  it "should have many students" do
    finance_fee_collection = FinanceFeeCollection.create!(@attr)
    @student1 = Student.create!(:admission_no => "5",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.day.ago,
    :gender => "M")
    @student2 = Student.create!(:admission_no => "6",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.day.ago,
    :gender => "M")
    finance_fee_collection.students = [@student1,@student2]
    finance_fee_collection.students.should == [@student1, @student2]
  end

  it "should have many finance transaction" do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]
    @onemore.finance_transactions.should == [@finance_transaction1, @finance_transaction2]
    # @financeFeeId = FinanceFee.find_by_fee_collection_id(@onemore.id)
    # @financeFeeId.transaction_id= @finance_transaction1
    # @financeFeeId.save!
  end
  
  it "should belong fee category" do
    fee_category = FinanceFeeCategory.create!(:name => "testCategory" , :batch => @batch)
    fee_collection = FinanceFeeCollection.create!(@attr.merge(:fee_category_id => fee_category))
    fee_collection.should be_valid
  end
  
  it "should respond to create associates" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:create_associates)
  end
  
  it "should respond to full_name" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:full_name)
  end
  
  it "should respond to fee_transactions" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:fee_transactions)
  end
  
  it "should respond to check_transaction" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:check_transaction)
  end
  
  it "should respond to check_fee_category" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:check_fee_category)
  end
  
  it "should respond to no_transaction_present" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:no_transaction_present)
  end
  
  it "should respond to transaction_total" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:transaction_total)
  end
  
  it "should respond to fees_particulars" do
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should respond_to(:fees_particulars)
  end
  
  it "should validate the filter create_associates" do
     @batch_fee_discount= BatchFeeDiscount.create!(:name => "discount for students", :receiver_id => @batch,:discount =>10 ,:finance_fee_category_id => @finance_fee_category.id )
     @student_category_fee_discount= StudentCategoryFeeDiscount.create!(:name => "discount for studentss", :receiver_id => @batch,:discount =>10 ,:finance_fee_category_id => @finance_fee_category.id )
     @student__fee_discount= StudentFeeDiscount.create!(:name => "discount for studentss", :receiver_id => @batch,:discount =>10 ,:finance_fee_category_id => @finance_fee_category.id )
     @finance__fee_particular= FinanceFeeParticulars.create!(:name => "discount for studentss", :amount =>10 ,:finance_fee_category_id => @finance_fee_category.id )
     finance_fee_collection = FinanceFeeCollection.create!(@attr)
     finance_fee_collection.should be_valid
  end
  
  it "should validate the method fees_particulars" do
    finance_fee_particular= FinanceFeeParticulars.create!(:name => "discount for studentss", :amount =>10 ,:finance_fee_category_id => @finance_fee_category.id ,:student_id => @student )
    finance_fee_collection = FinanceFeeCollection.create!(@attr)
    fee_collection_particular= FeeCollectionParticular.find_by_finance_fee_collection_id(finance_fee_collection)
    fee_collection_obj = finance_fee_collection.fees_particulars(@student)
    fee_collection_obj.should include(fee_collection_particular)
  end
  
  it "should validate the method transaction_total" do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]  
    fee_collection_obj = @onemore.transaction_total(2.year.ago , 1.second.ago)
    fee_collection_obj.to_s.should eql("200.0") 
  end
  
  it "should validate the no_transaction_present" do
    @onemore = FinanceFeeCollection.create!(@attr)
    no_transaction = @onemore.no_transaction_present
    no_transaction.should be_true
  end
  
  it "should not validate the method no_transaction_present" do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]
    @onemore.finance_transactions.should == [@finance_transaction1, @finance_transaction2]
    @financeFeeId = FinanceFee.find_by_fee_collection_id(@onemore.id)
    @financeFeeId.transaction_id= @finance_transaction1
    @financeFeeId.save!
    no_transaction = @onemore.no_transaction_present
    no_transaction.should be_false
  end
  
  it "should validate the method check_fee_category" do
    @onemore = FinanceFeeCollection.create!(@attr)
    check_fee_obj = @onemore.check_fee_category
    check_fee_obj.should be_true
  end
  
  it "should validate the output of check_fee_category method" do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]
    @onemore.finance_transactions.should == [@finance_transaction1, @finance_transaction2]
    @financeFeeId = FinanceFee.find_by_fee_collection_id(@onemore.id)
    @financeFeeId.transaction_id= @finance_transaction1
    @financeFeeId.save!
    check_fee_obj = @onemore.check_fee_category
    check_fee_obj.should be_false
  end
  
  it "should validate method full_name" do
     @onemore = FinanceFeeCollection.create!(@attr)
     full_name_obj = @onemore.full_name
     full_name_obj.should eql("Student Fee - #{1.month.ago}")
  end 
  
  it "should validate the method fee_transactions" do
     @onemore = FinanceFeeCollection.create!(@attr)
     fee_transaction_obj = @onemore.fee_transactions(@student)
     fee_transaction_obj.should be_nil
  end
  
  it "should validate the fee_transaction method output" do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]
    @onemore.finance_transactions.should == [@finance_transaction1, @finance_transaction2]
    @financeFeeId = FinanceFee.find_by_fee_collection_id(@onemore.id)
    @financeFeeId.transaction_id= @finance_transaction1
    @financeFeeId.save!
    fee_transaction_obj = @onemore.fee_transactions(@student)
    fee_transaction_obj.should eql(@financeFeeId)
  end
  
  it "should validate the check transaction method " do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => @finance_fee_category.id) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]
    @onemore.finance_transactions.should == [@finance_transaction1, @finance_transaction2]
    @financeFeeId = FinanceFee.find_by_fee_collection_id(@onemore.id)
    @financeFeeId.transaction_id= @finance_transaction1
    @financeFeeId.save!
    check_transaction_obj = @onemore.check_transaction(@finance_transaction1)
    check_transaction_obj.should be_true
  end
  
  it "should validate the check transaction method output " do
    @finance_transaction_category = FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    @onemore = FinanceFeeCollection.create!(@attr)
    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @onemore.id)
    @finance_transaction1 = FinanceTransaction.create!(:title => "Monghthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => nil) 
     @finance_transaction2 = FinanceTransaction.create!(:title => "Monghbthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category,
    :student => @student,
    :finance =>@finance_fee,
    :finance_fees_id => nil) 
    @onemore.finance_transactions = [@finance_transaction1,@finance_transaction2]
    @onemore.finance_transactions.should == [@finance_transaction1, @finance_transaction2]
    @financeFeeId = FinanceFee.find_by_fee_collection_id(@onemore.id)
    @financeFeeId.transaction_id= @finance_transaction1
    @financeFeeId.save!
    check_transaction_obj = @onemore.check_transaction(@finance_transaction1)
    check_transaction_obj.should be_false 
  end
  
  it "should validate the shorten_string if part" do
    @onemore = FinanceFeeCollection.create!(@attr)
    shorten_string_obj = FinanceFeeCollection.shorten_string("String" , 6)
    shorten_string_obj.should eql(" ...")   
  end
  
  it "should validate the shorten_string else part" do
    @onemore = FinanceFeeCollection.create!(@attr)
    shorten_string_obj = FinanceFeeCollection.shorten_string("String" , 8)
    shorten_string_obj.should eql("String")   
  end
  
  it "should valid the validate method" do
    @onemore = FinanceFeeCollection.new(:name => "Student Fee",
      :start_date => 1.day.ago ,
      :fee_category_id => @finance_fee_category.id,
      :end_date => 2.day.ago,
      :due_date => 1.day.ago, 
      :batch => @batch) 
      @onemore.validate
      @onemore.errors.messages[:base1].should eql(["start date cant be after end date"]) 
  end
  
  it "should valid the validate method" do
    @onemore = FinanceFeeCollection.new(:name => "Student Fee",
      :start_date => 3.day.ago ,
      :fee_category_id => @finance_fee_category.id,
      :end_date => 2.day.ago,
      :due_date => 4.day.ago,  
      :batch => @batch) 
      @onemore.validate     
      @onemore.errors.messages[:base2].should eql(["start date cant be after due date"]) 
  end
   
  it "should valid the validate method" do
    @onemore = FinanceFeeCollection.new(:name => "Student Fee",
      :start_date => 5.day.ago ,
      :fee_category_id => @finance_fee_category.id,
      :end_date => 3.day.ago,
      :due_date => 4.day.ago, 
      :batch => @batch) 
      @onemore.validate
      @onemore.errors.messages[:base3].should eql(["end date cant be after due date"]) 
  end
 end
