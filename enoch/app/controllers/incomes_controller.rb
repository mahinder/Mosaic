class IncomesController < ApplicationController
  # before_filter :login_required
 # filter_access_to :all
  
  # GET /incomes
  # GET /incomes.json
  
  def all_record
    @finance_transaction = FinanceTransaction.new
    @incomes = FinanceTransaction.incomes(Date.today,Date.today)
    @record_count = FinanceTransaction.incomes(Date.today,Date.today).count(:all)
    @categories = FinanceTransactionCategory.income_categories
    response = { :incomes => @incomes, :income => @income, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  
  def index
   
  end

  
  def create
   @finance_transaction = FinanceTransaction.new(params[:finance_transaction])
   @finance_transaction.user_id = @current_user
    respond_to do |format|
      if @finance_transaction.save
         @record_count = FinanceTransactionCategory.income_categories.count(:all)
        format.html { redirect_to @finance_transaction, notice: 'Income was successfully created.' }
        format.json { render :json => {:valid => true, :finance_transaction => @finance_transaction, :notice => "Income was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @finance_transaction.errors}}
      end
    end
  end

   def show
    @finance_transaction = FinanceTransaction.new
    @categories = FinanceTransactionCategory.income_categories
  end
  
  def income_list
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @incomes = FinanceTransaction.incomes(@start_date,@end_date)
    render '_income_list',:layout => false
  end 
  
  # DELETE /incomes/1
  def destroy
    @transaction = FinanceTransaction.find_by_id(params[:id])
      auto_transactions = FinanceTransaction.find_all_by_master_transaction_id(params[:id])
      auto_transactions.each { |a| a.destroy } unless auto_transactions.nil?
      @transaction.destroy
       respond_to do |format|
          format.html { redirect_to incomes_url }
          format.json { render :json => {:valid => true,  :notice => "Income was deleted successfully."}}
        end
  end      
end
