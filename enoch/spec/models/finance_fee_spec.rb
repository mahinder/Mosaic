# == Schema Information
#
# Table name: finance_fees
#
#  id                :integer         not null, primary key
#  fee_collection_id :integer
#  transaction_id    :string(255)
#  student_id        :integer
#

require 'spec_helper'


describe FinanceFee do

  before(:each) do
    @batch = Batch.create!(:name => "Class1", :start_date => 1.year.ago, :end_date => 1.month.ago)
    Student.delete_all
    @student =Student.create!(:admission_no => "25",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.year.ago,
    :gender => "M")
    student_id= @student.id
    @finance_fee_category = FinanceFeeCategory.create!(:name => "Monthly", :batch => @batch)

    @archived_student =ArchivedStudent.create!(:admission_no => "2",
    :admission_date => 1.year.ago,
    :first_name => "Shakti",
    :last_name => "Singh",
    :batch => @batch,
    :date_of_birth => 1.year.ago,
    :gender => "M",
    :former_id => student_id.to_s)

    @finance_fee_collection =FinanceFeeCollection.create!(:name => "Monthly",
    :start_date => 1.year.ago,
    :fee_category => @finance_fee_category,
    :end_date => 1.year.ago,
    :due_date => 1.month.ago)

    @finance_fee= FinanceFee.create!(:student => @student ,:fee_collection_id => @finance_fee_collection)

    @finance_transaction_category=FinanceTransactionCategory.create!(:name =>"Test Transaction Category")
    
  end

  after(:each) do
    FinanceFee.delete_all
    FinanceFeeCollection.delete_all
    FinanceFeeCategory.delete_all
    # FinanceTransactionCategroy.delete_all
    Student.delete_all
    ArchivedStudent.delete_all
  end

  it "should respond to its association" do
    @finance_fee.should respond_to(:finance_fee_collection)
    @finance_fee.should respond_to(:finance_transactions)
    @finance_fee.should respond_to(:components)
    @finance_fee.should respond_to(:student)
    @finance_fee.should respond_to(:fee_collection_id)
  end

  it "should respond to check_transaction_done" do
   @finance_fee.should respond_to(:check_transaction_done)
  end

  it "should respond to check_transaction_done for given transation id" do
    @finance_fee= FinanceFee.new(:student => @student, :fee_collection_id => @finance_fee_collection, :transaction_id => @finance_transaction_category)
    finance= @finance_fee.check_transaction_done
    finance.should eql(true)
  end

  it "should respond to check_transaction_done for transation id nil" do
    finance= @finance_fee.check_transaction_done
    finance.should eql(false)
  end

  it "should respond to former Student" do
    @finance_fee= FinanceFee.create(:student => @student, :fee_collection_id => @finance_fee_collection, :transaction_id => nil)
    @finance_fee.should respond_to(:former_student)
  end

  it "former student should return an object" do
    @finance_fee = FinanceFee.create!(:student => @student, :fee_collection_id => @finance_fee_collection,:transaction_id => nil)
    former_student_obj = @finance_fee.former_student
    former_student_obj.first_name.should eql("Shakti")
    former_student_obj.should eql(@archived_student)
    # former_student_obj.attributes.except('date_of_birth').should eql(@archived_student.attributes.except('date_of_birth'))
    former_student_obj.batch_id.should eql(@batch.id)
  end
end 
