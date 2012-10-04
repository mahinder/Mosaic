# == Schema Information
#
# Table name: finance_transactions
#
#  id                    :integer         not null, primary key
#  title                 :string(255)
#  description           :string(255)
#  amount                :decimal(, )
#  fine_included         :boolean         default(FALSE)
#  category_id           :integer
#  student_id            :integer
#  finance_fees_id       :integer
#  created_at            :datetime
#  updated_at            :datetime
#  transaction_date      :date
#  fine_amount           :decimal(, )     default(0.0)
#  master_transaction_id :integer         default(0)
#  user_id               :integer
#  finance_id            :integer
#  finance_type          :string(255)
#  payee_id              :integer
#  payee_type            :string(255)
#  receipt_no            :string(255)
#  voucher_no            :string(255)
#

require 'spec_helper'


describe FinanceTransaction do

  before(:each) do
    FinanceTransactionCategory.delete_all
    ftc1=FinanceTransactionCategory.create!(:name =>"Salary" , :is_income => 'f')
    ftc2=FinanceTransactionCategory.create!(:name =>"Fee" , :is_income => 't')
    ftc3=FinanceTransactionCategory.create!(:name =>"Donation" , :is_income => 't')

    @ftc_attr = {:name =>"year" , :is_income => 'f'}
    @finance_transaction_category = FinanceTransactionCategory.create!(@ftc_attr)
    @finance_transaction_trigger = FinanceTransactionTrigger.create!(:percentage => 2, :finance_category => @finance_transaction_category)
    @attr = {:title => "Monthly",
      :amount => 100,
      :transaction_date => 1.year.ago,
      :category => @finance_transaction_category}
  end

  after(:each) do
    FinanceTransactionCategory.delete_all
  end

  it "should create a new finance transaction" do
    ftc_attr = {:name =>"years" , :is_income => 'f'}
    finance_transaction_category = FinanceTransactionCategory.create!(ftc_attr)
    @finance_transaction = FinanceTransaction.create!(:title => "Monthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category)
    @finance_transaction.should be_valid
  end

  it "should validate the presence of title" do
    @finance_transaction = FinanceTransaction.new(@attr.merge(:title => nil,
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category))
    @finance_transaction.should_not be_valid
  end

  it "should validate the presence of amount" do
    @finance_transaction = FinanceTransaction.new(@attr.merge(:title => "yearly",
    :amount => "",
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category))
    @finance_transaction.should_not be_valid
  end

  it "should validate the presence of transaction date" do
    @finance_transaction = FinanceTransaction.new(@attr.merge(:title => "yearly",
    :amount => 100,
    :transaction_date => "" ,
    :category => @finance_transaction_category))
    @finance_transaction.should_not be_valid
  end

  it "should validate the presence of category" do
    @finance_transaction = FinanceTransaction.new(@attr.merge(:title => "yearly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => nil))
    @finance_transaction.should_not be_valid
  end

  it "should validate the numericality of amount" do
    @finance_transaction = FinanceTransaction.new(@attr.merge(:title => "yearly",
    :amount => "hundred",
    :transaction_date => 1.year.ago,
    :category => @finance_transaction_category))
    @finance_transaction.should_not be_valid
  end

  it "should respond to field" do
    @finance_transaction = FinanceTransaction.create!(@attr)
    @finance_transaction.should respond_to(:amount)
    @finance_transaction.should respond_to(:category)
    @finance_transaction.should respond_to(:transaction_date)
    @finance_transaction.should respond_to(:student)
    @finance_transaction.should respond_to(:finance)
    @finance_transaction.should respond_to(:payee)
  end

  it "should respond to create_auto_transaction" do
    finance_transaction = FinanceTransaction.create!(@attr)
    finance_transaction_obj = FinanceTransaction.find_by_title_and_category_id("Monthly - ", @finance_transaction_category)
    finance_transaction_obj.master_transaction_id.should eql(finance_transaction.id)
    finance_transaction_obj.should be_valid
  end

  it "should respond to update_auto_transaction" do
    finance_transaction = FinanceTransaction.create!(@attr)
    finance_transaction_obj = FinanceTransaction.find_by_master_transaction_id(finance_transaction.id)
    finance_transaction_obj.title = "title"
    finance_transaction_obj.save!
    finance_transaction_new_obj = FinanceTransaction.find_by_master_transaction_id(finance_transaction.id)
    finance_transaction_new_obj.title.should eql("title")
    finance_transaction_new_obj.should be_valid

  end

  it "should respond to delete_auto_transaction" do
    finance_transaction = FinanceTransaction.create!(@attr)
    finance_transaction_obj = FinanceTransaction.find_by_master_transaction_id(finance_transaction.id)
    finance_transaction_obj.destroy.should be_true
    finance_transaction_obj.destroy.should be_valid
  end

  it "should respond to student_payee" do
    finance_transaction = FinanceTransaction.create!(@attr)
  # finance_transaction.student_payee
  end

  # it "should valid the self expenses" do
    # finance_transaction = FinanceTransaction.create!(@attr)
    # finance_expenses= FinanceTransaction.expenses(2.year.ago,1.second.ago)
    # finance_expenses.should include(finance_transaction) 
    # finance_expenses.should be_true
  # end
  
  # it "should valid the self incomes" do
    # finance_transaction_category = FinanceTransactionCategory.new(@ftc_attr.merge(:name => "dsfd",:is_income => 't'))
    # finance_transaction_category.save!
    # finance_transaction = FinanceTransaction.create!(:title => "Monthly",
    # :amount => 100,
    # :transaction_date => 1.year.ago,
    # :category => finance_transaction_category) 
    # finance_expenses= FinanceTransaction.incomes(2.year.ago,1.second.ago)
    # finance_expenses.should include(finance_transaction) 
    # finance_expenses.should be_true 
  # end
#   

  it "should valid the self total_fees" do
    finance_transaction_category = FinanceTransactionCategory.find_by_name("Fee")
    finance_transaction_trigger = FinanceTransactionTrigger.create!(:percentage => 2, :finance_category => finance_transaction_category)
    FinanceTransaction.create!(:title => "Monthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category)
    finance_total_fee =  FinanceTransaction.total_fees(2.year.ago,1.second.ago)
    finance_total_fee.to_s.should eql("102.0")
  end

  it "should valid the self grand_total" do
    finance_transaction_category = FinanceTransactionCategory.find_by_name("Fee")
    finance_transaction_category_donation = FinanceTransactionCategory.find_by_name("Donation")
    finance_transaction_trigger1 = FinanceTransactionTrigger.create!(:percentage => 2, :finance_category => finance_transaction_category)
    finance_transaction_trigger2 = FinanceTransactionTrigger.create!(:percentage => 2, :finance_category => finance_transaction_category_donation)
    finance_transaction1=FinanceTransaction.create!(:title => "Monthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category)
    finance_transaction2=FinanceTransaction.create!(:title => "Monthly",
    :amount => 50,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category_donation)
    finance_transaction_grand_total = FinanceTransaction.grand_total(2.year.ago,1.second.ago)
    finance_transaction_grand_total.to_s.should eql("151.0")
  end

  it "should valid the self total_other_trans" do

    finance_transaction_category_fee = FinanceTransactionCategory.create!(:name => "Lib",:is_income => 't')
    finance_transaction_category_fee1 = FinanceTransactionCategory.create!(:name => "Libs",:is_income => 't')

    FinanceTransaction.create!(:title => "Monthly",
    :amount => 200,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category_fee)

    FinanceTransaction.create!(:title => "Monthly",
    :amount => 100,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category_fee1)

    finance_transaction_total = FinanceTransaction.total_other_trans(2.year.ago,1.second.ago)
    finance_transaction_total.to_s.should eql("[0, 0]")
  end

  it "should valid the self report" do
    cat_names = ['Fee','Salary','Donation','Library','Hostel','Transport']
    finance_transaction_category_fee = FinanceTransactionCategory.create!(:name => "Liby", :is_income => 't')
    finance_transaction_category_fee1 = FinanceTransactionCategory.find_by_name(cat_names[0])
    finance_transaction1=FinanceTransaction.create!(:title => "Monthly",
    :amount => 200,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category_fee)
    finance_transaction2=FinanceTransaction.create!(:title => "Monthly",
    :amount => 200,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category_fee1)
    finance_transaction_report = FinanceTransaction.report(2.year.ago, 1.second.ago,1)
    finance_transaction_report.should include(finance_transaction1)
    finance_transaction_report.should_not include(finance_transaction2)
  end

  it "should valid the self donations_triggers" do
    finance_transaction_category = FinanceTransactionCategory.find_by_name("Donation")
    finance_transaction_trigger1 = FinanceTransactionTrigger.create!(:percentage => 2, :finance_category => finance_transaction_category)
    finance_transaction1=FinanceTransaction.create!(:title => "Monthly",
    :amount => 10,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category)
    finance_transaction2=FinanceTransaction.create!(:title => "Monthly",
    :amount => 50,
    :transaction_date => 1.year.ago,
    :category => finance_transaction_category)
    finance_transaction = FinanceTransaction.donations_triggers(2.year.ago, 1.second.ago)
    finance_transaction.to_s.should eql("58.8")
  end

end 
