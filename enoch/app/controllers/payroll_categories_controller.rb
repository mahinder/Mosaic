class PayrollCategoriesController < ApplicationController
  
 before_filter :login_required
 filter_access_to :all
  
  # GET /payroll_categories
  # GET /payroll_categories.json
  def index
    @payroll_categories = PayrollCategory.all
     @all_active_categories = PayrollCategory.find_all_by_status(true, :order => "name ASC")
    @all_inactive_categories = PayrollCategory.find_all_by_status(false, :order => "name ASC")
    @earning_categories = PayrollCategory.find_all_by_is_deduction(false, :order=> "name ASC")
    @deductionable_categories = PayrollCategory.find_all_by_is_deduction(true, :order=> "name ASC")
      respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render :json => @payroll_categories }
    end
  end

  def all_record
    @payroll_category = PayrollCategory.new
    @all_active_categories = PayrollCategory.find_all_by_status(true, :order => "name ASC")
    @all_inactive_categories = PayrollCategory.find_all_by_status(false, :order => "name ASC")
    @earning_categories = PayrollCategory.find_all_by_is_deduction(false, :order=> "name ASC")
    @deductionable_categories = PayrollCategory.find_all_by_is_deduction(true, :order=> "name ASC")
    @record_count = PayrollCategory.count(:all)
    response = {:categories => @earning_categories, :deductionable_categories => @deductionable_categories, :record_count => @record_count }

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /payroll_categories/1
  # GET /payroll_categories/1.json
  def show
    @payroll_category = PayrollCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payroll_category }
    end
  end

  # GET /payroll_categories/new
  # GET /payroll_categories/new.json
  def new
    @payroll_category = PayrollCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payroll_category }
    end
  end

  # GET /payroll_categories/1/edit
  def edit
    @payroll_category = PayrollCategory.find(params[:id])
  end

  # POST /payroll_categories
  # POST /payroll_categories.json
  def create
    @payroll_category = PayrollCategory.new(params[:payroll_category])

    respond_to do |format|
      if @payroll_category.save
        @record_count = PayrollCategory.count(:all)
        format.html { redirect_to @payroll_category, notice: 'Payroll category was successfully created.' }
        format.json { render :json => {:valid => true, :payroll_category => @payroll_category, :notice => "Payroll Category was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @payroll_category.errors}}
      end
    end
  end

  # PUT /payroll_categories/1
  # PUT /payroll_categories/1.json
  def update
    @payroll_category = PayrollCategory.find(params[:id])

    respond_to do |format|
      if @payroll_category.update_attributes(params[:payroll_category])
        format.html { redirect_to @payroll_category, notice: 'Payroll category was successfully updated.' }
         format.json { render :json => {:valid => true, :payroll_category => @payroll_category, :notice => "Payroll Category was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :payroll_category.errors => @payroll_category.errors}}
      end
    end
  end

  # DELETE /payroll_categories/1
  # DELETE /payroll_categories/1.json
  def destroy
    @payroll_category = PayrollCategory.find(params[:id])
    monthlypayslip = MonthlyPayslip.find(:all, :conditions=>"payroll_category_id = #{params[:id]}")
    employee_salary = EmployeeSalaryStructure.find(:all, :conditions=>"payroll_category_id = #{params[:id]}")
    if monthlypayslip.empty? && employee_salary.empty?
      @payroll_category.destroy
      respond_to do |format|
      format.html { redirect_to payroll_categories_url }
      format.json { render :json => {:valid => true,  :notice => "Payroll was deleted successfully."} }
    end
    else  
     respond_to do |format|
        format.html { redirect_to employee_categories_url }
        str = "Category cannot be deleted"
        dependencyerrors = { :dependecies => [*str]}
        format.json { render :json => {:valid => false,  :errors => dependencyerrors}}
      end 
      
    end
   end
end
