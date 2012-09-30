class FinanceTransactionCategoriesController < ApplicationController
  # before_filter :login_required
 # filter_access_to :all
  
  # GET /finance_transaction_categories
  # GET /finance_transaction_categories.json
 
 def all_record
   @finance_transaction_categories = FinanceTransactionCategory.find(:all,:order => "name asc", :conditions => {:deleted => false})
   @finance_transaction_category = FinanceTransactionCategory.new
   @record_count = FinanceTransactionCategory.count(:all)
    
   response = { :finance_transaction_categories => @finance_transaction_categories, :finance_transaction_category => @finance_transaction_category, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
 
 
 
  def index
  @finance_transaction_categories = FinanceTransactionCategory.find(:all,:order => "name asc", :conditions => {:deleted => false})

    respond_to do |format|
      format.html{ render :layout => false } # index.html.erb
      format.json { render json: @finance_transaction_categories }
    end
  end

  # GET /finance_transaction_categories/1
  # GET /finance_transaction_categories/1.json
  def show
    @finance_transaction_category = FinanceTransactionCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @finance_transaction_category }
    end
  end

  # GET /finance_transaction_categories/new
  # GET /finance_transaction_categories/new.json
  def new
    @finance_transaction_category = FinanceTransactionCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @finance_transaction_category }
    end
  end

  # GET /finance_transaction_categories/1/edit
  def edit
    @finance_transaction_category = FinanceTransactionCategory.find(params[:id])
  end

  # POST /finance_transaction_categories
  # POST /finance_transaction_categories.json
  def create
      
    @finance_transaction_category = FinanceTransactionCategory.new(params[:finance_transaction_category])

    respond_to do |format|
      if @finance_transaction_category.save
        @record_count = FinanceTransactionCategory.count(:all)
        format.html { redirect_to @finance_transaction_category, notice: 'Finance transaction category was successfully created.' }
        format.json { render :json => {:valid => true, :finance_transaction_category => @finance_transaction_category, :notice => "Finance transaction category was successfully created."}}
      else
        format.html { render action: "new" }
        format.json {  render :json => {:valid => false, :errors => @finance_transaction_category.errors}}
      end
    end
  end

  # PUT /finance_transaction_categories/1
  # PUT /finance_transaction_categories/1.json
  def update
    @finance_transaction_category = FinanceTransactionCategory.find(params[:id])

    respond_to do |format|
      if @finance_transaction_category.update_attributes(params[:finance_transaction_category])
        format.html { redirect_to @finance_transaction_category, notice: 'Finance transaction category was successfully updated.' }
        format.json {render :json => {:valid => true, :finance_transaction_category => @finance_transaction_category, :notice => "Finance transaction category was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json {  render :json => {:valid => false, :errors => @finance_transaction_category.errors}}
      end
    end
  end

  # DELETE /finance_transaction_categories/1
  # DELETE /finance_transaction_categories/1.json
  def destroy
    @finance_transaction_category = FinanceTransactionCategory.find(params[:id])
    financetransaction = FinanceTransaction.find(:all, :conditions=>"category_id = #{params[:id]}")
    if financetransaction.empty? 
      @finance_transaction_category.update_attributes(:deleted => true)
      respond_to do |format|
      format.html { redirect_to finance_transaction_categories_url }
      format.json {  render :json => {:valid => true,  :notice => "Finance transaction category was deleted successfully."}}
    end
    else  
     respond_to do |format|
        format.html { redirect_to finance_transaction_categories_url }
        str = "Category cannot be deleted"
        dependencyerrors = { :dependecies => [*str]}
        format.json { render :json => {:valid => false,  :errors => dependencyerrors}}
    end
   end 
    
  end
end
