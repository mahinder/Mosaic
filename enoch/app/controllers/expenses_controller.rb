class ExpensesController < ApplicationController
  # before_filter :login_required
 # filter_access_to :all
  
  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expenses }
    end
  end

  # GET /expenses/1
  # GET /expenses/1.json
  

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @expense = Expense.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])
  end

  # POST /expenses
  # POST /expenses.json
  
  def all_record
    @finance_transaction = FinanceTransaction.new
    @categories = FinanceTransactionCategory.expense_categories
    response = { :expense => @expense}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  
  def create
    @finance_transaction = FinanceTransaction.new(params[:finance_transaction])
    @finance_transaction.user_id = @current_user
    respond_to do |format|
      if  @finance_transaction.save
        format.html { redirect_to @finance_transaction, notice: 'Expense was successfully created.' }
        format.json { render :json => {:valid => true, :finance_transaction => @finance_transaction, :notice => "Expense was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @finance_transaction.errors}}
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.json
  # def update
    # @expense = Expense.find(params[:id])
# 
    # respond_to do |format|
      # if @expense.update_attributes(params[:expense])
        # format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        # format.json { head :ok }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @expense.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
   def show
    @finance_transaction = FinanceTransaction.new
    @categories = FinanceTransactionCategory.expense_categories
  end
  
  def expense_list
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @expenses = FinanceTransaction.expenses(@start_date,@end_date)
    render '_expense_list',:layout => false
  end 
  
  # DELETE /incomes/1
  def destroy
    @transaction = FinanceTransaction.find_by_id(params[:id])
      auto_transactions = FinanceTransaction.find_all_by_master_transaction_id(params[:id])
      auto_transactions.each { |a| a.destroy } unless auto_transactions.nil?
      @transaction.destroy
       respond_to do |format|
          format.html { redirect_to Expenses_url }
          format.json { render :json => {:valid => true,  :notice => "Expense was deleted successfully."}}
        end
  end      
end
