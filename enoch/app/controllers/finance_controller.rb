
class FinanceController < ApplicationController
  before_filter :login_required,:configuration_settings_for_finance
  # filter_access_to :all
  
  def index
    @hr = SchoolConfiguration.find_by_config_value("HR")
  end
  
  def automatic_transactions
    @triggers = FinanceTransactionTrigger.all
    @categories = FinanceTransactionCategory.find(:all ,:conditions => ["name NOT IN ('Fee','Salary','Transport','Library','Hostel') and is_income=1 and deleted=0 "])
  end
  
  def donation
    @donation = FinanceDonation.new(params[:donation])
    if request.post? and @donation.save
      flash[:notice] = 'Donation accepted.'
      redirect_to :action => 'donation_receipt', :id => @donation.id
    end
  end

  def donation_receipt
    @donation = FinanceDonation.find(params[:id])
  end

  def donation_edit
    @donation = FinanceDonation.find(params[:id])
    @transaction = FinanceTransaction.find(@donation.transaction_id)
    if request.post? and @donation.update_attributes(params[:donation])
      donor = "Donation from #{params[:donation][:donor]}"
      FinanceTransaction.update(@transaction.id, :description => params[:donation][:description], :title=>donor, :amount=>params[:donation][:amount], :transaction_date=>@donation.transaction_date)
      redirect_to :action => 'donors'
      flash[:notice] = "Donation edited successfully."
    end
  end
  
  def donation_delete
    @donation = FinanceDonation.find(params[:id])
    @transaction = FinanceTransaction.find(@donation.transaction_id)
    if  @donation.destroy
      @transaction.destroy
      redirect_to :action => 'donors'
    end
  end

  def donation_receipt_pdf
    @donation = FinanceDonation.find(params[:id])
    @currency_type = Configuration.find_by_config_key("CurrencyType").config_value
    render :pdf => 'donation_receipt_pdf'
          
  end

  def donors
    @donations = FinanceDonation.find(:all, :order => 'transaction_date desc')
  end

  def expense_create
    flash[:notice]=nil
    @expense = FinanceTransaction.new(params[:transaction])
    @expense.user_id = @current_user.id
    @categories = FinanceTransactionCategory.expense_categories
    if @categories.empty?
      flash[:notice] = "Please create category for expense!"
    end
    if request.post? and @expense.save
      flash[:notice] = "Expense has been added to the accounts."
    end
  end

  def expense_edit
    @transaction = FinanceTransaction.find(params[:id])
    @transaction.user_id = @current_user.id
    @categories = FinanceTransactionCategory.all(:conditions =>"name != 'Salary' and is_income = false" )
    if request.post? and @transaction.update_attributes(params[:transaction])
      flash[:notice] = "Expense edited successfully."
    end
  end

  def expense_list
  end

  def expense_list_update
    if params[:start_date].to_date > params[:end_date].to_date
      flash[:warn_notice] = "End Date must be later than Start Date!"
      redirect_to :action => 'expense_list'
    end
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @expenses = FinanceTransaction.expenses(@start_date,@end_date)
  end
  
  def income_create
    flash[:notice]=nil
    @income = FinanceTransaction.new(params[:transaction])
    @income.user_id = @current_user.id
    @categories = FinanceTransactionCategory.income_categories
    if @categories.empty?
      flash[:notice] = "Please create category for income!"
    end
    if request.post? and @income.save
      flash[:notice] = "Income has been added to the accounts."
    end
  end

  def monthly_income
      
  end

  def income_edit
    @transaction = FinanceTransaction.find(params[:id])
    @transaction.user_id = @current_user.id
    @categories = FinanceTransactionCategory.all(:conditions => "is_income=true and name NOT IN ('Fee','Salary','Donation','Library','Hostel','Transport')")
    if request.post? and @transaction.update_attributes(params[:transaction])
      flash[:notice] = "Income edited successfully."
      redirect_to :action=> 'income_list'
    end
  end

  def income_list
  
  end

  def delete_transaction
    @transaction = FinanceTransaction.find_by_id(params[:id])
    income = @transaction.category.is_income?
    if income
      auto_transactions = FinanceTransaction.find_all_by_master_transaction_id(params[:id])
      auto_transactions.each { |a| a.destroy } unless auto_transactions.nil?
    end
    @transaction.destroy
    flash[:notice]="Finance Transaction Successfully Deleted"
    if income
      redirect_to :action=>'income_list'
    else
      redirect_to :action=>'expense_list'
    end


  end

  def income_list_update
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @incomes = FinanceTransaction.incomes(@start_date,@end_date)
  end

  def categories
    @categories = FinanceTransactionCategory.all(:conditions => {:deleted => false},:order=>'name asc')
  end

  def category_new
    @finance_transaction_category = FinanceTransactionCategory.new
  end
  
  def category_create
    @finance_category = FinanceTransactionCategory.new(params[:finance_category])
    render :update do |page|
      if @finance_category.save
        @categories = FinanceTransactionCategory.all(:conditions => {:deleted => false})
        page.replace_html 'form-errors', :text => ''
        page << "Modalbox.hide();"
        page.replace_html 'category-list', :partial => 'category_list'
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @finance_category
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

  def category_delete
    @finance_category = FinanceTransactionCategory.find(params[:id])
    @finance_category.update_attributes(:deleted => true)
    @categories = FinanceTransactionCategory.all(:conditions => {:deleted => false})
  end

  def category_edit
    @finance_category = FinanceTransactionCategory.find(params[:id])
    @categories = FinanceTransactionCategory.all(:conditions => {:deleted => false})
  end

  def category_update
    @finance_category = FinanceTransactionCategory.find(params[:id])
    @finance_category.update_attributes(params[:finance_category])
    @categories = FinanceTransactionCategory.all(:conditions => {:deleted => false})
  end

  def transaction_trigger_create
    @trigger = FinanceTransactionTrigger.new(params[:transaction_trigger])
    @triggers = FinanceTransactionTrigger.all
    render :update do |page|
      if @trigger.save
        page.replace_html 'transaction-triggers-list', :partial => 'transaction_triggers_list'
        page.replace_html 'form-errors', :text => ''
        page << "Modalbox.hide();"
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @trigger
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

                
            

  def transaction_trigger_edit
    @transaction_trigger = FinanceTransactionTrigger.find(params[:id])
    @categories = FinanceTransactionCategory.find(:all ,:conditions => "name NOT IN ('Salary','Fee','Transport','Library','Hostel')")
  end

  def transaction_trigger_update
    @transaction_trigger = FinanceTransactionTrigger.find(params[:id])
    @transaction_trigger.update_attributes(params[:transaction_trigger])
    
    @triggers = FinanceTransactionTrigger.all
    render :update do |page|
      page.replace_html 'transaction-triggers-list', :partial => 'transaction_triggers_list'
    end
  end

  def transaction_trigger_delete
    @trigger = FinanceTransactionTrigger.find(params[:id])
    @trigger.destroy
    @triggers = FinanceTransactionTrigger.all
    render :update do |page|
      page.replace_html 'transaction-triggers-list', :partial => 'transaction_triggers_list'
    end
  end

  #transaction-----------------------

  
  def update_monthly_report
    fixed_category_name
    @hr = SchoolConfiguration.find_by_config_value("HR")
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @transactions = FinanceTransaction.find(:all,
      :order => 'transaction_date desc', :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'"])
    #@other_transactions = FinanceTransaction.report(@start_date,@end_date,params[:page])
    @other_transactions = FinanceTransaction.find(:all,params[:page], :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'and category_id NOT IN (#{@fixed_cat_ids.join(",")})"],
      :order => 'transaction_date')
    @transactions_fees = FinanceTransaction.total_fees(@start_date,@end_date)
    @salary = MonthlyPayslip.total_employees_salary(@start_date, @end_date)#Employee.total_employees_salary(employees, @start_date, @end_date)
    @donations_total = FinanceTransaction.donations_triggers(@start_date,@end_date)
    @instant_fee_total = FinanceTransaction.instant_fees_total(@start_date,@end_date)
    @transport_fees_total = FinanceTransaction.transport_fees_total(@start_date,@end_date)
    @grand_total = FinanceTransaction.grand_total(@start_date,@end_date)
     @library_fees_total = FinanceTransaction.library_fees_total(@start_date,@end_date)
    @graph = open_flash_chart_object(900, 500, "graph_for_update_monthly_report?start_date=#{@start_date}&end_date=#{@end_date}")
    render :partial => 'update_monthly_report'
  end
  
  def transaction_pdf
    fixed_category_name
    @currency_type = ""
    @hr = SchoolConfiguration.find_by_config_value("HR")
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @transactions = FinanceTransaction.find(:all,
      :order => 'transaction_date desc', :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'"])
    @other_transactions = FinanceTransaction.find(:all,params[:page], :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'and category_id NOT IN (#{@fixed_cat_ids.join(",")})"],
      :order => 'transaction_date')
    @transactions_fees = FinanceTransaction.total_fees(@start_date,@end_date)
    employees = Employee.find(:all)
    @salary = Employee.total_employees_salary(employees, @start_date, @end_date)
    @donations_total = FinanceTransaction.donations_triggers(@start_date,@end_date)
    @instant_fee_total = FinanceTransaction.instant_fees_total(@start_date,@end_date)
    @transport_fees_total = FinanceTransaction.transport_fees_total(@start_date,@end_date)
    @grand_total = FinanceTransaction.grand_total(@start_date,@end_date)
    render :pdf => 'transaction_pdf'        
  end

  def salary_department
    month_date
    @departments = EmployeeDepartment.find(:all)
  end

  def salary_employee
    month_date
    @department = EmployeeDepartment.find(params[:id])
    @employees = @department.employees
    @payslips =  MonthlyPayslip.total_employees_salary(@start_date, @end_date, params[:id])
  end

  def employee_payslip_monthly_report
    
    @salary_date = params[:id2]
    @employee = Employee.find_in_active_or_archived(params[:id])
    @currency_type = Configuration.find_by_config_key("CurrencyType").config_value
    
    if params[:salary_date] == ""
      render :update do |page|
        page.replace_html "payslip_view", :text => ""
      end
      return
    end
    @monthly_payslips = MonthlyPayslip.find(:all,:conditions=>["employee_id=? AND salary_date = ?",params[:id],@salary_date],:include=>:payroll_category)
    @individual_payslips =  IndividualPayslipCategory.find(:all,:conditions=>["employee_id=? AND salary_date = ?",params[:id],@salary_date])
    @salary  = Employee.calculate_salary(@monthly_payslips, @individual_payslips)
   
  end

  def donations_report
    month_date
    @donations = FinanceTransaction.find(:all,:order => 'transaction_date desc', :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'and category_name ='Donation'"])
    
  end

  def fees_report
    month_date
    fees_id = FinanceTransactionCategory.find_by_name('Fee').id
    @fee_collection = FinanceFeeCollection.find(:all,:joins=>"INNER JOIN finance_fees ON finance_fees.fee_collection_id = finance_fee_collections.id INNER JOIN finance_transactions ON finance_transactions.finance_id = finance_fees.id and finance_transactions.transaction_date >= '#{@start_date}' AND finance_transactions.transaction_date <= '#{@end_date}'and finance_transactions.category_id ='#{fees_id}'",:group=>"finance_fee_collections.id")
    
  end
  
  def instant_fees_report
    month_date
    @instant_fee_collection = InstantFeeCollection.find(:all,:conditions => ["collection_date >= '#{@start_date}' and collection_date <= '#{@end_date}'"])  
  end

  def batch_fees_report
    month_date
    @fee_collection = FinanceFeeCollection.find(params[:id])
    @batch = @fee_collection.batch
    @transaction = @fee_collection.finance_transactions(:conditions=>"transaction_date >= '#{@start_date}' AND transaction_date <= '#{@end_date}'")
  end

  def student_fees_structure
    
    month_date
    @student = Student.find(params[:id])
    @components = @student.get_fee_strucure_elements
    
  end

  # approve montly payslip ----------------------

  def approve_monthly_payslip
    @salary_dates = MonthlyPayslip.find(:all, :select => "distinct salary_date")
    
  end

  def one_click_approve
    @dates = MonthlyPayslip.find_all_by_salary_date(params[:salary_date])
    @salary_date = params[:salary_date]
    render :partial=> "one_click_approve"
    
  end

  def one_click_approve_submit
    dates = MonthlyPayslip.find_all_by_salary_date(Date.parse(params[:date]), :conditions=>["is_rejected is false"])

    dates.each do |d|
      d.approve(current_user.id)
    end
    flash[:notice] = 'Payslip has been approved'
    redirect_to :controller=>'employees',:action => "employee_finance_setting"
    
  end

  def employee_payslip_approve
    dates = MonthlyPayslip.find_all_by_salary_date_and_employee_id(Date.parse(params[:id2]),params[:id])

    dates.each do |d|
      d.approve(current_user.id)
    end
    flash[:notice] = 'Payslip has been approved'
    redirect_to :action => "view_employee_payslip",:id=>params[:id],:salary_date=>params[:id2]
  end
  def employee_payslip_reject
    dates = MonthlyPayslip.find_all_by_salary_date_and_employee_id(Date.parse(params[:id2]),params[:id])
    employee = Employee.find(params[:id])

    dates.each do |d|
      d.reject(current_user.id, params[:payslip_reject][:reason])
    end
    privilege = Privilege.find(18)
    hr = privilege.users
    subject = " Payslip Rejected"
    body = "Payslip has been rejected for "+ employee.first_name+" "+ employee.last_name+ "(Employee number : #{employee.employee_number})" +" for the month #{params[:id2].to_date.strftime("%B %Y")}"
    hr.each do |f|
      Reminder.create(:sender=>current_user.id, :recipient=>f.id, :subject=> subject,
        :body => body, :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
    end
    render :update do |page|
      page.reload
    end
  end

  def employee_payslip_reject_form
    @id1 = params[:id]
    @id2 = params[:id2]
    respond_to do |format|
      format.js { render :action => 'reject' }
    end
  end

  #view monthly payslip -------------------------------
  def view_monthly_payslip
    
    @departments = EmployeeDepartment.find(:all, :conditions=>"status = true", :order=> "name ASC")
    @salary_dates = MonthlyPayslip.find(:all,:select => "distinct salary_date")
    if request.post?
      post_data = params[:payslip]
      unless post_data.blank?
        if post_data[:salary_date].present? and post_data[:department_id].present?
          @payslips = MonthlyPayslip.find_and_filter_by_department(post_data[:salary_date],post_data[:department_id])
        else
          flash[:notice] = "Select Salary Date"
          redirect_to :action=>"view_monthly_payslip"
        end
      end
    end
  end


  def view_employee_payslip
    @monthly_payslips = MonthlyPayslip.find(:all,:conditions=>["employee_id=? AND salary_date = ?",params[:id],params[:salary_date]],:include=>:payroll_category)
    @individual_payslips =  IndividualPayslipCategory.find(:all,:conditions=>["employee_id=? AND salary_date = ?",params[:id],params[:salary_date]])
    @salary  = Employee.calculate_salary(@monthly_payslips, @individual_payslips)
  end
 
  
  def search_ajax
    other_conditions = ""
    other_conditions += " AND employee_department_id = '#{params[:employee_department_id]}'" unless params[:employee_department_id] == ""
    other_conditions += " AND employee_category_id = '#{params[:employee_category_id]}'" unless params[:employee_category_id] == ""
    other_conditions += " AND employee_position_id = '#{params[:employee_position_id]}'" unless params[:employee_position_id] == ""
    other_conditions += " AND employee_grade_id = '#{params[:employee_grade_id]}'" unless params[:employee_grade_id] == ""
    if params[:query].length>= 3
      @employee = Employee.find(:all,
        :conditions => "(first_name LIKE \"#{params[:query]}%\"
                       OR middle_name LIKE \"#{params[:query]}%\"
                       OR last_name LIKE \"#{params[:query]}%\"
                       OR employee_number LIKE \"#{params[:query]}%\"
                       OR (concat(first_name, \" \", last_name) LIKE \"#{params[:query]}%\"))" + other_conditions,

        :order => "first_name asc") unless params[:query] == ''
    else
      @employee = Employee.find(:all,
        :conditions => "(employee_number LIKE \"#{params[:query]}%\")" + other_conditions,:order => "first_name asc") unless params[:query] == ''
    end
    render :layout => false
  end

  #asset-liability-----------

  def create_liability
    @liability = Liability.new(params[:liability])
    render :update do |page|
      if @liability.save
        page.replace_html 'form-errors', :text => ''
        page << "Modalbox.hide();"
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @liability
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

  def edit_liability
    @liability = Liability.find(params[:id])
  end

  def update_liability
    @liability = Liability.find(params[:id])
    
    render :update do |page|
      if @liability.update_attributes(params[:liability])
        @liabilities = Liability.find(:all,:conditions => 'is_deleted = 0')
        page.replace_html "liability_list", :partial => "liability_list"
        page << "Modalbox.hide();"
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @liability
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

  def view_liability
    @liabilities = Liability.find(:all,:conditions => 'is_deleted = 0')
  end
  
  def delete_liability
    @liability = Liability.find(params[:id])
    @liability.update_attributes(:is_deleted => true)
    @liabilities = Liability.find(:all ,:conditions => 'is_deleted = 0')
    render :update do |page|
      page.replace_html "liability_list", :partial => "liability_list"
    end
  end

  def each_liability_view
    @liability = Liability.find(params[:id])
    @currency_type = Configuration.find_by_config_key("CurrencyType").config_value
  end

  def create_asset
    @asset = Asset.new(params[:asset])
    render :update do |page|
      if @asset.save
        page.replace_html 'form-errors', :text => ''
        page << "Modalbox.hide();"
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @asset
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

  def view_asset
    @assets = Asset.find(:all,:conditions => 'is_deleted = 0')
  end

  def edit_asset
    @asset = Asset.find(params[:id])
  end

  def update_asset
    @asset = Asset.find(params[:id])
    
    render :update do |page|
      if @asset.update_attributes(params[:asset])
        @assets = Asset.find(:all,:conditions => 'is_deleted = 0')
        page.replace_html "asset_list", :partial => "asset_list"
        page << "Modalbox.hide();"
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @asset
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

  def delete_asset
    @asset = Asset.find(params[:id])
    @asset.update_attributes(:is_deleted => true)
    @assets = Asset.all(:conditions => 'is_deleted = 0')
    render :update do |page|
      page.replace_html "asset_list", :partial => "asset_list"
    end
  end

  def each_asset_view
    @asset = Asset.find(params[:id])
    @currency_type = Configuration.find_by_config_key("CurrencyType").config_value
  end
  #fees ----------------

  def master_fees
    @finance_fee_category = FinanceFeeCategory.new
    @finance_fee_particular = FinanceFeeParticulars.new
    @batchs = Batch.active
    @master_categories = FinanceFeeCategory.paginate(:page => params[:page],:conditions=> ["is_deleted = '#{false}' and is_master = 1"])
    @student_categories = StudentCategory.active
  end
  
  def master_category_new
    @finance_fee_category = FinanceFeeCategory.new
    @batches = Batch.active
    respond_to do |format|
      format.js { render :action => 'master_category_new' }
    end
  end

  def master_category_create
    @batches = Batch.active
    @master_categories = FinanceFeeCategory.find(:all,:conditions=> ["is_deleted = '#{false}' and is_master = 1 and school_session_id = #{current_session.id}"])
    unless current_session.nil?
    if request.post?
      @batches = params[:batch_fee_master][:id]['0']
      unless @batches.nil?
            unless @batches == "null"
                      @finance_fee_category = FinanceFeeCategory.new()
                      @finance_fee_category.name = params[:finance_fee_category][:name]
                      @finance_fee_category.description = params[:finance_fee_category][:description]
                      @finance_fee_category.school_session_id = current_session.id
                      @finance_fee_category.is_master = true
                      unless @finance_fee_category.save
                        @error = true
                      else
                        @batches.each do |batch|
                          @finance_fee_category.batches << Batch.find_by_id(batch)
                        end
                      end
            end
      else
        @finance_fee_category = FinanceFeeCategory.new(params[:finance_fee_category])
        @finance_fee_category.valid?
        @error = true
      end
      @master_categories = FinanceFeeCategory.find(:all,:conditions=> ["is_deleted = '#{false}' and is_master = 1 and school_session_id = #{current_session.id}"])
        # respond_to do |format|
          if @error.nil?
            render :partial => "master_category_list" 
          else
            respond_to do |format|
                 format.json { render :json => {:valid => false, :errors => @finance_fee_category.errors || "Master category can not be created."}}
            end
          end
    end
    else
      flash[:notice] = "Please enter school sesion detail"
       redirect_to(:controller => 'sessions',:action => "dashboard" )
    end
  end
 
  def master_category_edit
    @finance_fee_category = FinanceFeeCategory.find(params[:id])
    respond_to do |format|
      format.js { render :action => 'master_category_edit' }
    end
  end

  def master_category_update
    @finance_fee_category = FinanceFeeCategory.find(params[:id])
    # render :update do |page|
      if @finance_fee_category.update_attributes(params[:finance_fee_category])
        @master_categories = FinanceFeeCategory.find(:all, :conditions =>["is_deleted = '#{false}' and is_master = 1"])
      else
        # page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @finance_fee_category
        # page.visual_effect(:highlight, 'form-errors')
      end
      render :partial => "master_category_list"
    # end
    
  end

  def master_category_particulars
    if params[:id] != ""
    @finance_fee_category = FinanceFeeCategory.find_by_id(params[:id])
    @particulars = FinanceFeeParticulars.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_category_id = '#{@finance_fee_category.id}' "])
    else
    @finance_fee_category = []
    @particulars = []
    end
    render :partial => 'master_particulars_list'
    #    respond_to do |format|
    #      format.js { render :action => 'master_category_particulars' }
    #    end
  end
  def master_category_particulars_edit
    @finance_fee_particulars= FinanceFeeParticulars.find(params[:id])
    respond_to do |format|
      format.js { render :action => 'master_category_particulars_edit' }
    end
  end

  def master_category_particulars_update
    @feeparticulars = FinanceFeeParticulars.find( params[:id])
    @fee_category = FinanceFeeCategory.find(@feeparticulars.finance_fee_category_id)
    
    # render :update do |page|
                      # unless params[:finance_fee_particulars][:admission_no].blank? || params[:finance_fee_particulars][:admission_no].nil?
                        # posted_params = params[:finance_fee_particulars]
                        # admission_no = posted_params[:admission_no].split(",")
                        # posted_params.delete "admission_no"
                            # admission_no.each do |a|
                              # s = Student.find_by_admission_no(a)
                              # unless s.nil?
                                # unless (@fee_category.batches.include?(s.batch))
                                  # @error = true
                                  # @feeparticulars.errors.add_to_base("#{a} does not belong to Batch for which fees is being created.")
                                # end
                              # else
                                # @error = true
                                # @feeparticulars.errors.add_to_base("#{a} does not exist")
                              # end
                            # end
                            # unless @error
                              # admission_no.each do |a|
                                # s = Student.find_by_admission_no(a)
                                # @feeparticulars.students << s unless @feeparticulars.students.include?(s)
                                # # @error = true unless @finance_fee_particulars.save
                              # end
                            # end
                      # end
      unless @error  
       (params[:finance_fee_particulars].delete :admission_no) unless   params[:finance_fee_particulars].include?('admission_no')     
       @feeparticulars.update_attributes(params[:finance_fee_particulars])
      end
        @finance_fee_category = FinanceFeeCategory.find(@feeparticulars.finance_fee_category_id)
        @particulars = FinanceFeeParticulars.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_category_id = '#{@finance_fee_category.id}' "])
    # end
    render :partial => "master_particulars_list"
    #    respond_to do |format|
    #      format.js { render :action => 'master_category_particulars' }
    #    end
  end
  def master_category_particulars_delete
    @feeparticulars = FinanceFeeParticulars.find( params[:id])
    @feeparticulars.update_attributes(:is_deleted => true )
    @finance_fee_category = FinanceFeeCategory.find(@feeparticulars.finance_fee_category_id)
    @particulars = FinanceFeeParticulars.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_category_id = '#{@finance_fee_category.id}' "])
    render :partial => "master_particulars_list"
    # respond_to do |format|
      # format.js { render :action => 'master_category_particulars' }
    # end
  end
  def master_category_delete
    @finance_fee_category = FinanceFeeCategory.find(params[:id])
    unless @finance_fee_category.has_published_collection_date(@finance_fee_category)
    @finance_fee_category.update_attributes(:is_deleted => true)
    @finance_fee_category.delete_particulars
    else
      @error = true
    end
    @master_categories = FinanceFeeCategory.find(:all, :conditions =>["is_deleted = '#{false}' and is_master = 1"])
    respond_to do |format|
      if @error.nil?
        format.html {render :partial => 'master_category_list'}
        format.json { render :json => {:valid => true,  :notice => "Fee Category deleted successfully." }}
      else
        str = "Fee Category can not be deleted"
        dependency_errors = {:dependency => [*str]}
        format.json { render :json => {:valid => false, :errors => dependency_errors}}
      end
    end
  end

  def show_master_categories_list
    unless params[:id].nil?
      @fee_category = FinanceFeeParticulars.find_all_by_finance_fee_category_id(params[:id] ,:conditions => ["is_deleted = '#{false}'"])
      render  :partial => 'show_previous_master_category'
    end
  end


  def fees_particulars_new
    @fees_categories = FinanceFeeCategory.find_by_id(params[:id] ,:conditions=> ["is_deleted = '#{false}' and is_master = 1 and school_session_id = #{current_session.id}"])
    @all_fee_category = []
    @student_categories = StudentCategory.active
    @finance_fee_particulars = FinanceFeeParticulars.new
    @particulars = []
    @school_session = SchoolSession.find(:all, :conditions => ["current_session =  ?" ,false])
    render :partial => 'fees_particulars_new'
  end
  
  def get_previous_master_category
    @all_fee_category =[]
    unless params[:id].nil? || params[:id]=="" 
    @all_fee_category = FinanceFeeCategory.find_all_by_school_session_id(params[:id])
    end
    render :partial => 'get_previous_master_category'
  end

 def validate_student_batch
   @fee_category = FinanceFeeCategory.find(params[:student][:master_category_id])
   admission_no = params[:student][:admissionNo].split(",")
   admission_no.each do |a|
      s = Student.find_by_admission_no(a)
        unless s.nil?
          unless @fee_category.batches.include?(s.batch)
            @error = true
          end
        else
           @error = true
           @fee_category.errors.add(:student ,"#{a} does not exist")
        end
   end
      respond_to do |format|
        if @error.nil?
           format.json { render :json => {:valid => true, :notice => "Student does not belong to this Batch"}}
        else
           format.json { render :json => {:valid => false, :notice => "Student does not exist"}}
        end
      end
 end


  def fees_particulars_create
    unless params.include?('copy_data')
    @error = false
    @finance_fee_particular = FinanceFeeParticulars.new(params[:finance_fee_particulars])
    unless (params[:finance_fee_particulars][:finance_fee_category_id]).blank?
      @fee_category = FinanceFeeCategory.find(@finance_fee_particular.finance_fee_category_id)
      if params[:particulars][:select].to_s == 'student'
        unless params[:finance_fee_particulars][:admission_no].blank?
          posted_params = params[:finance_fee_particulars]
          admission_no = posted_params[:admission_no].split(",")
          posted_params.delete "admission_no"
          admission_no.each do |a|
            s = Student.find_by_admission_no(a)
            unless s.nil?
               unless (@fee_category.batches.include?(s.batch))
                  @error = true
                  @finance_fee_particular.errors.add(:student , "#{a} does not belong to Batch for which fees is being created.")
               end
            else
              @error = true
              @finance_fee_particular.errors.add(:student , "#{a} does not exist")
            end
          end
          unless @error
            admission_no.each do |a|
              s = Student.find_by_admission_no(a)
              @finance_fee_particular.students << s unless @finance_fee_particular.students.include?(s)
            end
            @finance_fee_particular.save
          end
        else
          @error = true
          @finance_fee_particular.errors.add(:admission_no," is blank")
        end
      else
        @error = true unless @finance_fee_particular.save
      end
    end
    else
    @error = false
    previous_particulars = params[:finance_fee_particulars][:previous_particulars]["0"]
    previous_particulars.each do |b|
      @finance_fee_particular = FinanceFeeParticulars.new()
      @prev = FinanceFeeParticulars.find_by_id(b)
      @finance_fee_particular.name = @prev.name
      @finance_fee_particular.description = @prev.description
      @finance_fee_particular.amount = @prev.amount
      @finance_fee_particular.student_category_id = params[:finance_fee_particulars][:student_category_id] unless params[:finance_fee_particulars][:student_category_id].nil?
      @finance_fee_particular.finance_fee_category_id = params[:finance_fee_particulars][:finance_fee_category_id]
      @fee_category = FinanceFeeCategory.find(@finance_fee_particular.finance_fee_category_id)
          if params[:particulars][:select].to_s == 'student'
                      unless params[:finance_fee_particulars][:admission_no].blank?
                        posted_params = params[:finance_fee_particulars]
                        admission_no = posted_params[:admission_no].split(",")
                        posted_params.delete "admission_no"
                            admission_no.each do |a|
                              s = Student.find_by_admission_no(a)
                              unless s.nil?
                                unless (@fee_category.batches.include?(s.batch))
                                  @error = true
                                  @finance_fee_particular.errors.add(:student , "#{a} does not belong to Batch for which fees is being created.")
                                end
                              else
                                @error = true
                                @finance_fee_particular.errors.add(:student , "#{a} does not exist")
                              end
                            end
                            unless @error
                              admission_no.each do |a|
                                s = Student.find_by_admission_no(a)
                                @finance_fee_particular.students << s  unless @finance_fee_particular.students.include?(s)
                              end
                              @finance_fee_particular.save
                            end
                      else
                        @error = true
                        @finance_fee_particular.errors.add(:admission_no," is blank")
                      end
            else       
                 @error = true unless @finance_fee_particular.save     
            end
      end
    end
    respond_to do |format|
      if @error == false
        @finance_fee_category = FinanceFeeCategory.find(params[:finance_fee_particulars][:finance_fee_category_id])
        @particulars = FinanceFeeParticulars.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_category_id = '#{@finance_fee_category.id}' "])
        format.json  { render :json => {:html => render_to_string(:partial => 'master_particulars_list.html.erb'), :valid => true ,:notice => "Successfully Created Particulars"}}
      else
        @finance_fee_category = FinanceFeeCategory.find(params[:finance_fee_particulars][:finance_fee_category_id])
        @particulars = FinanceFeeParticulars.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_category_id = '#{@finance_fee_category.id}' "])
        format.json  { render :json => {:html => render_to_string(:partial => 'master_particulars_list.html.erb'), :valid => false ,:errors => @finance_fee_particular.errors}}
      end 
    end
  end

  def additional_fees_create_form
    @batches = Batch.active
    @student_categories = StudentCategory.active
  end
  
  def additional_fees_create

    batch = params[:additional_fees][:batch_id] unless params[:additional_fees][:batch_id].nil?
    # batch ||=[]
    @batches = Batch.active
    @user = current_user
    @students = Student.find_all_by_batch_id(batch) unless batch.nil?
    @additional_category = FinanceFeeCategory.new(
      :name => params[:additional_fees][:name],
      :description => params[:additional_fees][:description],
      :batch_id => params[:additional_fees][:batch_id]
    )
    if params[:additional_fees][:due_date] >= params[:additional_fees][:end_date]
      if @additional_category.save && params[:additional_fees][:start_date].strip.length!=0 && params[:additional_fees][:due_date].strip.length!=0 && params[:additional_fees][:end_date].strip.length!=0
        @collection_date = FinanceFeeCollection.create(
          :name => @additional_category.name,
          :start_date => params[:additional_fees][:start_date],
          :end_date => params[:additional_fees][:end_date],
          :due_date => params[:additional_fees][:due_date],
          :batch_id => params[:additional_fees][:batch_id],
          :fee_category_id => @additional_category.id
        )
        body = "<p>Fee submission date for "+@additional_category.name+" has been published <br />
                               Fees submitting date starts on<br />
                               Start date :"+@collection_date.start_date.to_s+"<br />"+
          "End date :"+@collection_date.end_date.to_s+"<br />"+
          "Due date :"+@collection_date.due_date.to_s
        subject = "Fees submission date"
        @due_date = @collection_date.due_date.strftime("%Y-%b-%d") +  " 00:00:00"
        unless batch.empty?
          @students.each do |s|
            FinanceFee.create(:student_id => s.id,:fee_collection_id => @collection_date.id)
            Reminder.create(:sender=>@user.id, :recipient=>s.id, :subject=> subject,
              :body => body, :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
          end
          Event.create(:title=> "Fees Due", :description =>@additional_category.name, :start_date => @due_date, :end_date => @due_date, :is_due => true)
        else
          @batches.each do |b|
            @students = Student.find_all_by_batch_id(b.id)
            @students.each do |s|
              FinanceFee.create(:student_id => s.id,:fee_collection_id => @collection_date.id)
              Reminder.create(:sender=>@user.id, :recipient=>s.user.id, :subject=> subject,
                :body => body, :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
            end
          end
          Event.create(:title=> "Fees Due", :description =>@additional_category.name, :start_date => @due_date, :end_date => @due_date, :is_due => true)
        end
        flash[:notice] = "Category created, please add Particulars for the category"
        redirect_to(:action => "add_particulars" ,:id => @collection_date.id)
      else
        flash[:notice] = 'Fields with * cannot be empty'
        redirect_to :action => "additional_fees_create_form"
      end
    else
      flash[:notice] = 'Due date should be after End date'
      redirect_to :action => "additional_fees_create_form"
    end
  end

  def additional_fees_edit
    @finance_fee_category = FinanceFeeCategory.find(params[:id])
    @collection_date = FinanceFeeCollection.find_by_fee_category_id(@finance_fee_category.id)
    respond_to do |format|
      format.js { render :action => 'additional_fees_edit' }
    end
  end

  def additional_fees_update
    @finance_fee_category = FinanceFeeCategory.find(params[:id])
    @collection_date = FinanceFeeCollection.find_by_fee_category_id(@finance_fee_category.id)
    #    render :update do |page|

    if @finance_fee_category.update_attributes(:name =>params[:finance_fee_category][:name], :description =>params[:finance_fee_category][:description])
      if @collection_date.update_attributes(:start_date=>params[:additional_fees][:start_date], :end_date=>params[:additional_fees][:end_date],:due_date=>params[:additional_fees][:due_date])
        @additional_categories = FinanceFeeCategory.find(:all, :conditions =>["is_deleted = '#{false}' and is_master = '#{false}' and batch_id = '#{@finance_fee_category.batch_id}'"])
        #        page.replace_html 'form-errors', :text => ''
        #        page << "Modalbox.hide();"
        #        page.replace_html 'particulars', :partial => 'additional_fees_list'
        #        end
      else
        @error = true
      end
    else
      #        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @finance_fee_category
      #        page.visual_effect(:highlight, 'form-errors')
      @error = true
    end
    #    end
  end

  def additional_fees_delete
    @finance_fee_category = FinanceFeeCategory.find(params[:id])
    @finance_fee_category.update_attributes(:is_deleted => true)
    @finance_fee_collection = FinanceFeeCollection.find_by_fee_category_id(params[:id])
    @finance_fee_collection.update_attributes(:is_deleted => true)
    @finance_fee_category.delete_particulars
    # redirect_to :action => "additional_fees_list"
    @additional_categories = FinanceFeeCategory.find(:all, :conditions =>["is_deleted = '#{false}' and is_master = '#{false}' and batch_id = '#{@finance_fee_category.batch_id}'"])
    respond_to do |format|
      format.js { render :action => 'additional_fees_delete' }
    end
  end

  def add_particulars
    @collection_date = FinanceFeeCollection.find(params[:id])
    @additional_category = FinanceFeeCategory.find(@collection_date.fee_category_id)
    @student_categories = StudentCategory.active
    @finance_fee_particulars = FeeCollectionParticular.new
    @finance_fee_particulars_list = FeeCollectionParticular.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_collection_id = '#{@collection_date.id}'"])
  end

  def add_particulars_new
    @collection_date = FinanceFeeCollection.find(params[:id])
    @additional_category = FinanceFeeCategory.find(@collection_date.fee_category_id)
    @student_categories = StudentCategory.active
    @finance_fee_particulars = FeeCollectionParticular.new
  end

  def add_particulars_create
    @collection_date = FinanceFeeCollection.find(params[:id])
    @additional_category = FinanceFeeCategory.find(@collection_date.fee_category_id)
    @error = false
    unless params[:finance_fee_particulars][:admission_no].nil?
      unless params[:finance_fee_particulars][:admission_no].empty?
        posted_params = params[:finance_fee_particulars]
        admission_no = posted_params[:admission_no].split(",")
        posted_params.delete "admission_no"
        err = ""
        admission_no.each do |a|
          posted_params["admission_no"] = a.to_s
          @finance_fee_particulars = FeeCollectionParticular.new(posted_params)
          @finance_fee_particulars.finance_fee_collection_id = @collection_date.id
          s = Student.find_by_admission_no(a)
          unless s.nil?
            if (s.batch_id == @collection_date.batch_id) or (@collection_date.batch_id.nil?)
              unless @finance_fee_particulars.save
                @error = true
              end
            else
              @error = true
              err = err + "#{a} does not belong to Batch #{@collection_date.batch.full_name}. <br />"
            end
          else
            @error = true
            err = err + "#{a} does not exist. <br />"
          end
        end
        @finance_fee_particulars.errors.add(:admission_no," invalid : <br />" + err) if @error==true
        @finance_fee_particulars_list = FeeCollectionParticular.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_collection_id = '#{@collection_date.id}'"])  unless @error== true
      else
        @error = true
        @finance_fee_particulars = FeeCollectionParticular.new(params[:finance_fee_particulars])
        @finance_fee_particulars.valid?
        @finance_fee_particulars.errors.add(:admission_no," is blank")
      end
    else
      @finance_fee_particulars = FeeCollectionParticular.new(params[:finance_fee_particulars])
      @finance_fee_particulars.finance_fee_collection_id = @collection_date.id
      unless @finance_fee_particulars.save
        @error = true
      else
        @finance_fee_particulars_list = FeeCollectionParticular.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_collection_id = '#{@collection_date.id}'"])
      end

    end
  end

  def student_or_student_category
    @student_categories = StudentCategory.active
    select_value = params[:select_value]
    if select_value == "category"
      render :partial => "student_category_particulars"
    end
    if select_value == "student"
      render :partial => "student_admission_particulars"
    end
    if select_value == "all"
      render :text => ""
    end 
  end

  def additional_fees_list
    @batchs=Batch.active
    #@additional_categories = FinanceFeeCategory.paginate(:page => params[:page],:conditions => ["is_deleted = '#{false}' and is_master = '#{false}'"])
  end

  def show_additional_fees_list
    @additional_categories = FinanceFeeCategory.find(:all,:conditions => ["is_deleted = '#{false}' and is_master = '#{false}' and batch_id=?",params[:id]])
    render :update do |page|
      page.replace_html 'particulars', :partial =>'additional_fees_list'
    end
  end

  def additional_particulars
    @additional_category = FinanceFeeCategory.find(params[:id])
    @collection_date = FinanceFeeCollection.find_by_fee_category_id(@additional_category.id)
    @particulars = FeeCollectionParticular.find(:all,:conditions => ["is_deleted = '#{false}' and finance_fee_collection_id = '#{@collection_date.id}' "])
  end

  def add_particulars_edit
    @finance_fee_particulars = FeeCollectionParticular.find(params[:id])
  end
  
  def add_particulars_update
    @finance_fee_particulars = FeeCollectionParticular.find(params[:id])
    render :update do |page|
      if @finance_fee_particulars.update_attributes(params[:finance_fee_particulars])
        @collection_date = @finance_fee_particulars.finance_fee_collection
        @additional_category =@collection_date.fee_category
        @particulars = FeeCollectionParticular.paginate(:page => params[:page],:conditions => ["is_deleted = '#{false}' and finance_fee_collection_id = '#{@collection_date.id}' "])
        page.replace_html 'form-errors', :text => ''
        page << "Modalbox.hide();"
        page.replace_html 'particulars', :partial => 'additional_particulars_list'
      else
        page.replace_html 'form-errors', :partial => 'class_timings/errors', :object => @finance_fee_particulars
        page.visual_effect(:highlight, 'form-errors')
      end
    end
  end

  def add_particulars_delete
    @finance_fee_particulars = FeeCollectionParticular.find(params[:id])
    @finance_fee_particulars.update_attributes(:is_deleted => true)
    @collection_date = @finance_fee_particulars.finance_fee_collection
    @additional_category =@collection_date.fee_category
    @particulars = FeeCollectionParticular.paginate(:page => params[:page],:conditions => ["is_deleted = '#{false}' and finance_fee_collection_id = '#{@collection_date.id}' "])
    render :update do |page|
      page.replace_html 'particulars', :partial => 'additional_particulars_list'
    end
  end

  def fee_collection_batch_update
    @fee_category = FinanceFeeCategory.find_by_name(params[:id], :conditions=>["is_deleted = '#{false}' and school_session_id = '#{current_session.id}' "])
    @fee_category.batches.reject!{|x| x.students.blank? or x.is_deleted?}
    render :partial => "fee_collection_batchs"
  end

  def fee_collection_new
    @fee_categories = FinanceFeeCategory.find(:all , :conditions => ["is_master = '#{1}' and is_deleted = '#{false}' and school_session_id = '#{current_session.id}'"], :group => :name)
    @finance_fee_collection = FinanceFeeCollection.new
  end

  def fee_collection_create
    @user = current_user
    fee_category_name = params[:finance_fee_collection][:fee_category_id]
    fee_category = FinanceFeeCategory.find_by_name_and_school_session_id(fee_category_name ,current_session.id)
    category =[]
    unless params[:fee_collection].nil?
      batches = params[:fee_collection][:category_ids]['0']
      subject = "Fees submission date"

      batches.each do |c|
        b = Batch.find_by_id(c)
        @finance_fee_collection = FinanceFeeCollection.new(
          :name => params[:finance_fee_collection][:name],
          :start_date => params[:finance_fee_collection][:start_date],
          :end_date => params[:finance_fee_collection][:end_date],
          :due_date => params[:finance_fee_collection][:due_date],
          :fee_category_id => fee_category.id,
          :batch_id => b.id
        )
        if @finance_fee_collection.save
          @students = Student.find_all_by_batch_id(b.id)
          @students.each do |s|
                reminder = Reminder.create(:sender=> current_user.id,:sent_to => b.full_name,  
                :subject=>"Fees Due",
                :body=>"<p><b>Fee submission date for <i>"+fee_category_name+"</i> has been published</b><br /><br/>
                                Start date :"+@finance_fee_collection.start_date.to_s+"<br />"+
                " End date :"+@finance_fee_collection.end_date.to_s+"<br />"+
                " Due date :"+@finance_fee_collection.due_date.to_s+"<br /><br /><br />"+
                " check your  <a href='../../finance/student_fees_structure/#{s.id}?id2=#{@finance_fee_collection.id}'>Fee structure</a> <br/><br/><br/>
                               Regards,<br/>"+@user.full_name.capitalize)
                student_user = s.user
                ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
             unless s.has_paid_fees == 1
              FinanceFee.create(:student_id => s.id,:fee_collection_id => @finance_fee_collection.id)
             end
          end
          new_event =  Event.create(:title=> "Fees Due", :description => fee_category_name, :start_date => @finance_fee_collection.due_date.to_datetime, :end_date => @finance_fee_collection.due_date.to_datetime, :is_due => true , :origin=>@finance_fee_collection)
          BatchEvent.create(:event_id => new_event.id, :batch_id => b.id )
        else
          @error = true
        end
      end
    else
      @error = true
      @finance_fee_collection = FinanceFeeCollection.new()
      @finance_fee_collection.errors.add(:batch ," cant be blank")
    end
    respond_to do |format|
      if @error.nil?
       format.json { render :json => {:valid => true, :notice => "Fee Collection successfully created"}}
      else
       format.json { render :json => {:valid => false, :errors => @finance_fee_collection.errors.full_messages}}
      end
    end
    
  end


  def fee_collection_view
    if params.include?('id')
      @batchs = Batch.find_all_by_course_id(params[:id],:conditions=>{:is_active=>true ,:is_deleted => false})
      render :partial=>'fee_collection_batch'
    else
      @batchs = []
      render :partial=>'fee_collection_view'
    end
  end

  def fee_collection_dates_batch
   if params.include?('id')
    @batch= Batch.find_by_id(params[:id])
    unless @batch.nil?
      @finance_fee_collections = @batch.fee_collection_dates
    else
      @finance_fee_collections = []
    end
   else
     @batch = []
     @finance_fee_collections = []
   end
    render :partial => 'fee_collection_dates_batch'
  end

  def fee_collection_edit
    @finance_fee_collection = FinanceFeeCollection.find params[:id]
    render :partial => "fee_collection_edit"
  end

  
  def fee_collection_update
    @user = current_user
    @finance_fee_collection = FinanceFeeCollection.find params[:id]
    events = @finance_fee_collection.event
      if params[:finance_fee_collection][:due_date].to_date >= params[:finance_fee_collection][:end_date].to_date
        if @finance_fee_collection.update_attributes(params[:finance_fee_collection])
          events.update_attributes(:start_date=> @finance_fee_collection.due_date.to_datetime, :end_date=> @finance_fee_collection.due_date.to_datetime, :description=>params[:finance_fee_collection][:name]) unless events.blank?
          @finance_fee_collections = FinanceFeeCollection.all(:conditions => ["is_deleted = '#{false}' and batch_id = '#{@finance_fee_collection.batch_id}'"])
          fee_category_name = @finance_fee_collection.fee_category.name
          subject = "Fees Submission Date"
          @students = Student.find_all_by_batch_id(@finance_fee_collection.batch_id)
          @students.each do |s|
             batch = Batch.find_by_id(s.batch_id)
             reminder = Reminder.create(:sender=> current_user.id,:sent_to => batch.full_name,  
             :subject=> subject,
             :body=> "<p><b>Fees Submission Date For <i>"+fee_category_name+"</i> has been updated</b> <br /><br/>
                                Start Date : "+@finance_fee_collection.start_date.to_s+"<br />"+
              " End Date : "+@finance_fee_collection.end_date.to_s+" <br />"+
              " Due Date: "+@finance_fee_collection.due_date.to_s+" <br /><br /><br />"+
              " Check Your  <a href='../../finance/student_fees_structure/#{s.id}?id2=#{@finance_fee_collection.id}''>Fee Structure</a> <br/><br/><br/>
                               Regards, <br/>"+@user.full_name.capitalize)
                student_user = s.user
                ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
              end
        else
           @error = true
        end
      else
        @error = true
      end
    @finance_fee_collections = FinanceFeeCollection.all(:conditions => ["is_deleted = '#{false}' and batch_id = '#{@finance_fee_collection.batch_id}'"])
  
      if @error.nil? 
       render :partial => 'fee_collection_dates_batch'
      else
        respond_to do |format|
          format.json { render :json => {:valid => false, :errors => @finance_fee_collection.errors}}
        end
     end
  end

  def fee_collection_delete
    @finance_fee_collection = FinanceFeeCollection.find params[:id]
    @finance_fee_collection.update_attributes(:is_deleted => true)
    @finance_fee_collections = FinanceFeeCollection.all(:conditions => ["is_deleted = '#{false}' and batch_id = '#{@finance_fee_collection.batch_id}'"])
    render :partial => 'fee_collection_dates_batch'
  end

  #fees_submission-----------------------------------

  def fees_submission_batch

    @batches = []
    @dates = []
    render :partial => "fees_submission_batch"
  end
    
  def assign_batch
   @course =Course.find_by_id(params[:id])
   unless @course.nil?
     @batches = @course.batches.active
   else
     @batches = [] 
   end
   render :partial => 'fees_batch'
  end  
    
  def update_fees_collection_dates
    
    @batch = Batch.find_by_id(params[:batch_id])
    unless @batch.nil?
    @dates = @batch.fee_collection_dates
    else
     @dates =[] 
    end
    render :partial => "fees_collection_dates"
  end

  def load_fees_submission_batch
    @batch   = Batch.find_by_id(params[:batch_id])
    @dates   = FinanceFeeCollection.find(:all)
    @date    =  @fee_collection = FinanceFeeCollection.find_by_id(params[:date])
    @student = Student.find(params[:student]) if params[:student]
    @fee = FinanceFee.first(:conditions=>"fee_collection_id = #{@date.id}" ,:joins=>'INNER JOIN students ON finance_fees.student_id = students.id')
    @student ||= @fee.student
    @prev_student = @student.previous_fee_student(@date.id)
    @next_student = @student.next_fee_student(@date.id)
    @financefee = @student.finance_fee_by_date @date
    @due_date = @fee_collection.due_date
    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted = false"])
    @fee_particulars = @date.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@date.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@date.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@date.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
      render :partial => "student_fees_submission"
  end

  def update_ajax
    @batch   = Batch.find(params[:batch_id])
    @dates = FinanceFeeCollection.find(:all)
    @date = @fee_collection = FinanceFeeCollection.find(params[:date])
    @student = Student.find(params[:student]) if params[:student]
    @student ||= FinanceFee.first(:conditions=>"fee_collection_id = #{@date.id}",:joins=>'INNER JOIN students ON finance_fees.student_id = students.id').student
    @prev_student = @student.previous_fee_student(@date.id)
    @next_student = @student.next_fee_student(@date.id)
    @due_date = @fee_collection.due_date
    total_fees =0

    @financefee = @student.finance_fee_by_date @date
   
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    
    @fee_particulars.each do |p|
      total_fees += p.amount
    end
    unless params[:fine].nil?
      total_fees += params[:fine].to_f
    end
    unless params[:fees][:fees_paid].to_f < 0
      unless params[:fees][:fees_paid].to_f > params[:total_fees].to_f
        transaction = FinanceTransaction.new
        (total_fees > params[:fees][:fees_paid].to_f ) ? transaction.title = "Receipt No. (partial) F#{@financefee.id}" :  transaction.title = "Receipt No. F#{@financefee.id}"
        transaction.category = FinanceTransactionCategory.find_by_name("Fee")
        transaction.payee = @student
        transaction.amount = params[:fees][:fees_paid].to_f
        transaction.fine_amount = params[:fine].to_f
        transaction.fine_included = true  unless params[:fine].nil?
        transaction.finance = @financefee
        transaction.transaction_date = Date.today
        transaction.save
        unless @financefee.transaction_id.nil?
          tid =   @financefee.transaction_id + ",#{transaction.id}"
        else
          tid=transaction.id
        end
        is_paid = (params[:fees][:fees_paid].to_f == params[:total_fees].to_f) ? true : false
         @financefee.update_attributes(:transaction_id=>tid, :is_paid=>is_paid)
    
        @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{tid}\")")
      else
        @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
        @error = true
        @financefee.errors.add(:fees ,"Cannot pay amount greater than total fee")
        # @financefee.errors.add_to_base("Cannot pay amount greater than total fee")
      end
    else
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
      @error = true
      @financefee.errors.add(:fees ,"Amount to be paid should not be negative")
      # @financefee.errors.add_to_base("Amount to be paid should not be negative")
    end
    if @error.nil?
    render :partial => "student_fees_submission"
    else
        render :json => {:valid => false,:errors => @financefee.errors}
    end
  end

  def student_fee_receipt_pdf
    @date = @fee_collection = FinanceFeeCollection.find(params[:id2])
    @student = Student.find(params[:id])
    @financefee = @student.finance_fee_by_date @date
    @due_date = @fee_collection.due_date
    
    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted = false"])
    @fee_particulars = @date.fees_particulars(@student)
    @currency_type = ""
    # @currency_type = SchoolConfiguration.find_by_config_key("CurrencyType").config_value

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    
    render :pdf => 'fee_receipt_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
           
    #        respond_to do |format|
    #            format.pdf { render :layout => false }
    #        end

  end

  def update_fine_ajax
    if request.post?
      @batch   = Batch.find(params[:fine][:batch_id])
      @dates = FinanceFeeCollection.find(:all)
      @date = @fee_collection = FinanceFeeCollection.find(params[:fine][:date])
      @student = Student.find(params[:fine][:student]) if params[:fine][:student]
      @student ||= FinanceFee.first(:conditions=>"fee_collection_id = #{@date.id}",:joins=>'INNER JOIN students ON finance_fees.student_id = students.id').student
      @prev_student = @student.previous_fee_student(@date.id)
      @next_student = @student.next_fee_student(@date.id)
      
      @financefee = @student.finance_fee_by_date @date
      unless params[:fine][:fee].to_f < 0
        @fine = (params[:fine][:fee])
      else
        @financefee.errors.(:fine_amonunt , "Fine amount should not be negative")
      end
      @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted IS NOT NULL"])
      @fee_particulars = @date.fees_particulars(@student)
      @due_date = @fee_collection.due_date

      @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
      @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
      @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
      @total_discount = 0
      @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
      @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
      @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
      if @total_discount > 100
        @total_discount = 100
      end
      render :partial => "student_fees_submission"
    end
  end

  def search_logic                 #student search (fees submission)
    query = params[:query]
    if query.length>= 3
      @students_result = Student.find(:all,
        :conditions => "(first_name LIKE \"#{query}%\"
                       OR middle_name LIKE \"#{query}%\"
                       OR last_name LIKE \"#{query}%\"
                       OR (concat(first_name, \" \", middle_name) LIKE \"#{query}%\")
                       OR (concat(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{query}%\")
                       OR admission_no = '#{query}'
                       OR (concat(first_name, \" \", last_name) LIKE \"#{query}%\"))",
        :order => "batch_id asc,first_name asc") unless query == ''
    else
      @students_result = Student.find(:all,
        :conditions => "( admission_no = '#{query}')",
        :order => "batch_id asc,first_name asc") unless query == ''
    end
    render :layout => false
  end

  def fees_student_dates
    @student = Student.find(params[:id])
    @dates = @student.batch.fee_collection_dates
    @dates.reject!{|x|!FinanceFee.exists?(:fee_collection_id=>x.id, :student_id=>@student.id)}
    render :partial => "fees_student_dates"
  end

  def fees_submission_student
    
    @student = Student.find(params[:id])
    @date = @fee_collection = FinanceFeeCollection.find(params[:date])
    @financefee = @student.finance_fee_by_date(@date)
    
    @due_date = @fee_collection.due_date
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)
    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    
    render :partial => "fees_submission_form"
  end

  def update_student_fine_ajax

    @student = Student.find(params[:fine][:student])
    @date = @fee_collection = FinanceFeeCollection.find(params[:fine][:date])
    @financefee = @student.finance_fee_by_date(@date)
    unless params[:fine][:fee].to_f < 0
      @fine = (params[:fine][:fee])
      flash[:notice] = nil
    else
      flash[:notice] = "Fine amount should not be negative"
    end

    @due_date = @fee_collection.due_date
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    render  :partial => "fees_submission_form"
  end

  def fees_submission_save

    @student = Student.find(params[:student])
    @date = @fee_collection = FinanceFeeCollection.find(params[:date])
    @financefee = @date.fee_transactions(@student.id)
    
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)
    total_fees = 0
    @fee_particulars.each do |p|
      total_fees += p.amount
    end
    unless params[:fine].nil?
      total_fees += params[:fine].to_f
    end
  
    if request.post?
      unless params[:fees][:fees_paid].to_f < 0
        unless params[:fees][:fees_paid].to_f> params[:total_fees].to_f
          transaction = FinanceTransaction.new
          transaction.title = "Receipt No. F#{@financefee.id}"
          transaction.category = FinanceTransactionCategory.find_by_name("Fee")
          transaction.payee = @student
          transaction.finance = @financefee
          transaction.fine_included = true  unless params[:fine].nil?
          transaction.amount = params[:fees][:fees_paid].to_f
          transaction.user_id = @current_user.id
          transaction.fine_amount = params[:fine].to_f
          transaction.transaction_date = Date.today
          if transaction.save
              unless @financefee.transaction_id.nil?
                tid =   @financefee.transaction_id.to_s + ",#{transaction.id}"
              else
                tid=transaction.id
              end
              is_paid = (params[:fees][:fees_paid].to_f == params[:total_fees].to_f) ? true : false
              @financefee.update_attributes(:transaction_id=>tid, :is_paid=>is_paid)
              flash[:notice] = 'Fees paid'
          else
            @error = true
            @error_message = transaction.errors.to_json
            dependency_errors = {:error => [*@error_message]}
          end
        else
          @error = true
          flash[:notice] = 'Cannot pay amount greater than total fee'
          @error_message = 'Cannot pay amount greater than total fee'
          dependency_errors = {:error => [*@error_message]}
        end
      else
        @error = true
        flash[:notice] = 'Amount to be paid should not be negative'
        @error_message = 'Amount to be paid should not be negative'
        dependency_errors = {:error => [*@error_message]}
      end
    end
     respond_to do |format|
          if @error.nil?
             format.json { render :json => {:valid => true, :notice => "Fees Submitted Succesfully"}} 
          else
             format.json { render :json => {:valid => false, :errors => dependency_errors}}
          end
      end
    # redirect_to  :action => "fees_student_search"
  end

  #fees structure ----------------------
  
  def fees_student_structure_search_logic # student search fees structure
    query = params[:query]
    unless query.length < 3
      @students_result = Student.find(:all,
        :conditions => ["first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                         OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
          "#{query}%","#{query}%","#{query}%","#{query}", "#{query}" ],
        :order => "batch_id asc,first_name asc") unless query == ''
    else
      @students_result = Student.find(:all,
        :conditions => ["admission_no = ? " , query],
        :order => "batch_id asc,first_name asc") unless query == ''
    end
    render :layout => false
  end

  def fees_structure_dates
    @student = Student.find_by_id(params[:id])
    unless @student.nil?
    #@dates = @student.batch.fee_collection_dates
    @student_fees = FinanceFee.find_all_by_student_id(@student.id,:select=>'fee_collection_id')
    @student_dates = ""
    @student_fees.map{|s| @student_dates += s.fee_collection_id.to_s + ","}
    @dates = FinanceFeeCollection.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@student_dates}\")")
    else
    redirect_to :controller => 'sessions', :action => 'dashboard'
    flash[:notice] = t(:student_not_found)
    end
  end

  def fees_structure_for_student
    @student = Student.find_by_id(params[:id])
    @fee_collection = FinanceFeeCollection.find_by_id(params[:date])
    unless @fee_collection.nil?
    @fee_category = FinanceFeeCategory.find_by_id_and_school_session_id(@fee_collection.fee_category_id, current_session.id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @fee_collection.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    end
    render :partial => "fees_structure"
  end

  def student_fees_structure
    @student = Student.find_by_id(params[:id])
    unless @student.nil?
    @fee_collection = FinanceFeeCollection.find_by_id(params[:id2])
    unless @fee_collection.nil?
    @fee_category = FinanceFeeCategory.find_by_id_and_school_session_id(@fee_collection.fee_category_id, current_session.id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @fee_collection.fees_particulars(@student)
    else
      redirect_to :controller => 'sessions', :action => 'dashboard'
      flash[:notice] = t(:student_not_found)
    end
    else
      redirect_to :controller => 'sessions', :action => 'dashboard'
      flash[:notice] = t(:student_not_found)
    end
  end
  

  #fees defaulters-----------------------

  def fees_defaulters
    @batchs = []
    @dates = []
  end
  
  def update_fees_collection_batch_defaulters
    course  = Course.find_by_id(params[:id])
    unless course.nil?
    @batchs = course.batches.active
    else
    @batchs = []
    @dates = []
    end
    render :partial => "fee_defaulter_batch"
  end
  
  def update_fees_collection_dates_defaulters
    @batch  = Batch.find_by_id(params[:batch_id])
    unless @batch.nil?
    @dates = @batch.fee_collection_dates
    else
    @dates = [] 
    end
    render  :partial => "fees_collection_dates_defaulters"
  end

  def fees_defaulters_students
    @batch   = Batch.find_by_id(params[:batch_id])
    @date = FinanceFeeCollection.find_by_id(params[:date])
    if !@date.nil? && !(@date.due_date > Date.today)
    @fee = FinanceFee.find_all_by_fee_collection_id(@date.id, :conditions => {:is_paid => false})
    @fee.reject!{|s| s.student.batch_id != @batch.id}
    @students = @fee.map{|x| Student.find(x.student_id)}
    @defaulters = @students.reject{|s| s.check_fees_paid(@date)==true}
    else
      @fee = []
      @defaulters = []
    end
    render  :partial => "student_defaulters"
  end

  def fee_defaulters_pdf
    @batch   = Batch.find_by_id(params[:batch_id])
    @date = FinanceFeeCollection.find_by_id(params[:date])
    if !@date.nil? && !(@date.due_date > Date.today)
    @students = @date.students.reject{|s| s.batch_id != @batch.id}
    else
     @students = []
    end
    @currency_type = SchoolConfiguration.find_by_config_key("CurrencyType")
    @current_session = current_session.id      
    render :pdf => 'fee_defaulters_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
           
    ##        respond_to do |format|
    ##            format.pdf { render :layout => false }
    ##        end
  end

  def fee_defaulters_batch_pdf_details
    @batch_array=  params[:batch_ids].split(',')
    @student_list = []
    @date_list = []
    unless @batch_array.empty?
        @batch_array.each do |bh|
           batch   = Batch.find_by_id(bh)
           date = FinanceFeeCollection.find_all_by_batch_id(batch.id)
           unless date.empty?
            @date_list << date unless @date_list.include?(date)
           end
           @currency_type = SchoolConfiguration.find_by_config_key("CurrencyType")
           @current_session = current_session.id
        end
    end 
    respond_to do |format| 
       if params[:type] == "pdf"
              format.html {render :pdf => 'fee_defaulters_batch_pdf_details',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                              :bottom => 20,
                              :left=> 30,
                              :right => 30},:disposition  => "attachment"}
                    
      else
         format.xls
      end        
   end
 end


  def pay_fees_defaulters
    @fine = params[:fine].to_f unless params[:fine].nil?
    @student = Student.find(params[:id])
    @date = @fee_collection = FinanceFeeCollection.find(params[:date])
    @financefee = @date.fee_transactions(@student.id)
    @current_session = current_session.id
    @fee_category = FinanceFeeCategory.find_by_id_and_school_session_id(@fee_collection.fee_category_id, current_session.id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    
    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end
  end

def pay_fees_defaulters_after_adding_fine
    @fine = params[:fine].to_f unless params[:fine].nil?
    @student = Student.find(params[:id])
    @date = @fee_collection = FinanceFeeCollection.find(params[:date])
    @financefee = @date.fee_transactions(@student.id)
    @current_session = current_session.id
    @fee_category = FinanceFeeCategory.find_by_id_and_school_session_id(@fee_collection.fee_category_id, current_session.id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    
    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end
    render :template => '/finance/pay_fees_defaulters',:layout => false
  end

def pay_fees_defaulters_fine
    # @fine = params[:fine].to_f unless params[:fine].nil?
    @student = Student.find(params[:id])
    @date = @fee_collection = FinanceFeeCollection.find(params[:date])
    @financefee = @date.fee_transactions(@student.id)
    @current_session = current_session.id
    @fee_category = FinanceFeeCategory.find_by_id_and_school_session_id(@fee_collection.fee_category_id, current_session.id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    
    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end
    total_fees = 0
    @fee_particulars.each do |p|
      total_fees += p.amount
    end
    total_fees += params[:fine].to_f unless params[:fine].nil?

    if request.post?
      unless params[:fees][:fees_paid].to_f < 0
        unless params[:fees][:fees_paid].to_f> params[:total_fees].to_f
          transaction = FinanceTransaction.new
          transaction.title = "Receipt No. F#{@financefee.id}"
          transaction.category = FinanceTransactionCategory.find_by_name("Fee")
          transaction.payee = @student
          transaction.finance = @financefee
          transaction.amount = params[:fees][:fees_paid].to_f
          transaction.fine_included = true  unless params[:fine].nil?
          transaction.fine_amount = params[:fine].to_f
          transaction.transaction_date = Date.today
          transaction.save

          unless @financefee.transaction_id.nil?
            tid =   @financefee.transaction_id.to_s + ",#{transaction.id}"
          else
            tid=transaction.id
          end
          is_paid = (params[:fees][:fees_paid].to_f == params[:total_fees].to_f) ? true : false
          @financefee.update_attributes(:transaction_id=>tid, :is_paid=>is_paid)

          @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{tid}\")")
          flash[:notice] = "Fees Paid"
          # redirect_to  :action => "fees_defaulters"
        else
          flash[:notice] = 'Cannot pay amount greater than total fee'
        end
      else
        flash[:notice] = 'Amount to be paid should not be negative'
      end
    
    end
    render :template => '/finance/pay_fees_defaulters',:layout => false
  end


  def update_defaulters_fine_ajax
    @student = Student.find(params[:fine][:student])
    @date = FinanceFeeCollection.find(params[:fine][:date])
    @financefee = @date.fee_transactions(@student.id)
    @fee_collection = FinanceFeeCollection.find(params[:fine][:date])
    @fee_category = FinanceFeeCategory.find_by_id_and_school_session_id(@fee_collection.fee_category_id, current_session.id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @date.fees_particulars(@student)
    unless params[:fine][:fee].to_f < 0
      @fine = params[:fine][:fee].to_f

      total_fees = 0
      @fee_particulars.each do |p|
        total_fees += p.amount
      end
      total_fees += @fine unless @fine.nil?
    else
      @error = true
      @date.errors.add(:fine ,"Fine amount should not be negative")
      flash[:notice] = 'Fine amount should not be negative'
    end
     respond_to do |format|
          if @error.nil?
             format.json { render :json => {:valid => true,:id=> @student.id, :date=> @date.id, :fine => @fine}} 
          else
             format.json { render :json => {:valid => false, :errors => @date.errors}}
          end
      end
    # redirect_to  :action => "pay_fees_defaulters", :id=> @student.id, :date=> @date.id, :fine => @fine
  end

  def compare_report
    
  end

  def report_compare
    fixed_category_name
    @hr = Configuration.find_by_config_value("HR")
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date + 1
    @start_date2 = (params[:start_date2]).to_date
    @end_date2 = (params[:end_date2]).to_date + 1
    @transactions = FinanceTransaction.find(:all,
      :order => 'transaction_date desc', :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'"])
    @transactions2 = FinanceTransaction.find(:all,
      :order => 'transaction_date desc', :conditions => ["transaction_date >= '#{@start_date2}' and transaction_date <= '#{@end_date2}'"])
    @other_transactions = FinanceTransaction.find(:all,params[:page], :conditions => ["transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'and category_id NOT IN (#{@fixed_cat_ids.join(",")})"],
      :order => 'transaction_date')
    #    @other_transactions = FinanceTransaction.report(@start_date,@end_date,params[:page])
    @other_transactions2 = FinanceTransaction.find(:all,params[:page], :conditions => ["transaction_date >= '#{@start_date2}' and transaction_date <= '#{@end_date2}'and category_id NOT IN (#{@fixed_cat_ids.join(",")})"],
      :order => 'transaction_date')
    #    @transactions_fees = FinanceTransaction.total_fees(@start_date,@end_date)
    @transactions_fees2 = FinanceTransaction.total_fees(@start_date2,@end_date2)
    employees = Employee.find(:all)
    @salary = Employee.total_employees_salary(employees, @start_date, @end_date)
    @salary2 = Employee.total_employees_salary(employees, @start_date2, @end_date2)
    @donations_total = FinanceTransaction.donations_triggers(@start_date,@end_date)
    @donations_total2 = FinanceTransaction.donations_triggers(@start_date2,@end_date2)
    @transactions_fees = FinanceTransaction.total_fees(@start_date,@end_date)
    @transactions_fees2 = FinanceTransaction.total_fees(@start_date2,@end_date2)
    @batchs = Batch.find(:all)
    @grand_total = FinanceTransaction.grand_total(@start_date,@end_date)
    @grand_total2 = FinanceTransaction.grand_total(@start_date2,@end_date2)
    @graph = open_flash_chart_object(960, 500, "graph_for_compare_monthly_report?start_date=#{@start_date}&end_date=#{@end_date}&start_date2=#{@start_date2}&end_date2=#{@end_date2}")
  end
 
  def month_date
    @start_date = params[:start]
    @end_date  = params[:end]
  end

  def partial_payment
    render :update do |page|
      page.replace_html "partial_payment", :partial => "partial_payment"
    end
  end


  #reports pdf---------------------------

  def pdf_fee_structure
    @student = Student.find(params[:id])
    @institution_name = SchoolConfiguration.find_by_config_key("InstitutionName")
    @institution_address = SchoolConfiguration.find_by_config_key("InstitutionAddress")
    @institution_phone_no = SchoolConfiguration.find_by_config_key("InstitutionPhoneNo")
    @currency_type = SchoolConfiguration.find_by_config_key("CurrencyType")
    @fee_collection = FinanceFeeCollection.find params[:id2]
    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted IS NOT NULL"])
    @fee_particulars = @fee_collection.fees_particulars(@student)
    @total = @student.total_fees(@fee_particulars)
    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
    render :pdf => 'pdf_fee_structure',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
           
    #        respond_to do |format|
    #            format.pdf { render :layout => false }
    #        end
  end

  #graph------------------------------------
 

  def graph_for_update_monthly_report
    
    start_date = (params[:start_date]).to_date
    end_date = (params[:end_date]).to_date
    employees = Employee.find(:all)
    
    hr = SchoolConfiguration.find_by_config_value("HR")
    donations_total = FinanceTransaction.donations_triggers(start_date,end_date)
    fees = FinanceTransaction.total_fees(start_date,end_date)
    income = FinanceTransaction.total_other_trans(start_date,end_date)[0]
    instant_fees = FinanceTransaction.total_other_trans(start_date,end_date)[2]
    transport_fees = FinanceTransaction.total_other_trans(start_date,end_date)[3]
    expense = FinanceTransaction.total_other_trans(start_date,end_date)[1]
    #    other_transactions = FinanceTransaction.find(:all,
    #      :conditions => ["transaction_date >= '#{start_date}' and transaction_date <= '#{end_date}'and category_id !='#{3}' and category_id !='#{2}'and category_id !='#{1}'"])

    x_labels = []
    data = []
    largest_value =0
    
    unless hr.nil?
      salary = Employee.total_employees_salary(employees,start_date,end_date)
      unless salary <= 0
        x_labels << "Salary"
        data << (salary-(salary*2)).to_f
        largest_value = salary if largest_value < salary
      end
    end
    unless donations_total <= 0
      x_labels << "Donations"
      data << donations_total.to_f
      largest_value = donations_total if largest_value < donations_total
    end

    unless fees <= 0
      x_labels << "Fees"
      data << fees.to_f
      largest_value = fees if largest_value < fees
    end
 
    unless instant_fees <= 0
      x_labels << "Instant Fees"
      data << instant_fees.to_f
      largest_value = instant_fees if largest_value < instant_fees
    end
 
    unless transport_fees <= 0
      x_labels << "Transport Fees"
      data << transport_fees.to_f
      largest_value = transport_fees if largest_value < transport_fees
    end
    
    unless income <= 0
      x_labels << "Other Income"
      data << income.to_f
      largest_value = income if largest_value < income
    end
    unless expense <= 0
      x_labels << "expense"
      data << expense.to_f
      largest_value = expense if largest_value < expense
    end


    #    other_transactions.each do |trans|
    #      x_labels << trans.title
    #      if trans.category.is_income? and trans.master_transaction_id == 0
    #        data << trans.amount
    #      else
    #        data << ("-"+trans.amount.to_s).to_i
    #      end
    #      largest_value = trans.amount if largest_value < trans.amount
    #    end

    largest_value += 500

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 3;
    bargraph.text = "Amount"
    bargraph.values = data

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(largest_value-(largest_value*2),largest_value,largest_value/5)

    title = Title.new("Finance Transaction")

    x_legend = XLegend.new("Examination name")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend = x_legend
    chart.set_y_legend = y_legend
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(bargraph)


    render :text => chart.render
 
  end
  def graph_for_compare_monthly_report

    start_date = (params[:start_date]).to_date
    end_date = (params[:end_date]).to_date
    start_date2 = (params[:start_date2]).to_date
    end_date2 = (params[:end_date2]).to_date
    employees = Employee.find(:all)

    hr = SchoolConfiguration.find_by_config_value("HR")
    donations_total = FinanceTransaction.donations_triggers(start_date,end_date)
    donations_total2 = FinanceTransaction.donations_triggers(start_date2,end_date2)
    fees = FinanceTransaction.total_fees(start_date,end_date)
    fees2 = FinanceTransaction.total_fees(start_date2,end_date2)
    income = FinanceTransaction.total_other_trans(start_date,end_date)[0]
    income2 = FinanceTransaction.total_other_trans(start_date2,end_date2)[0]
    expense = FinanceTransaction.total_other_trans(start_date,end_date)[1]
    expense2 = FinanceTransaction.total_other_trans(start_date2,end_date2)[1]

    #    other_transactions = FinanceTransaction.find(:all,
    #      :conditions => ["transaction_date >= '#{start_date}' and transaction_date <= '#{end_date}'and category_id !='#{3}' and category_id !='#{2}'and category_id !='#{1}'"])
    #    other_transactions2 = FinanceTransaction.find(:all,
    #      :conditions => ["transaction_date >= '#{start_date2}' and transaction_date <= '#{end_date2}'and category_id !='#{3}' and category_id !='#{2}'and category_id !='#{1}'"])


    x_labels = []
    data = []
    data2 = []
    largest_value =0

    unless hr.nil?
      salary = Employee.total_employees_salary(employees,start_date,end_date)
      salary2 = Employee.total_employees_salary(employees,start_date2,end_date2)
      unless salary <= 0 and salary2 <= 0
        x_labels << "Salary"
        data << salary-(salary*2)
        data2 << salary2-(salary2*2)
        largest_value = salary if largest_value < salary
        largest_value = salary2 if largest_value < salary2
      end
    end
    unless donations_total <= 0 and donations_total2 <= 0
      x_labels << "Donations"
      data << donations_total
      data2 << donations_total2
      largest_value = donations_total if largest_value < donations_total
      largest_value = donations_total2 if largest_value < donations_total2
    end

    unless fees <= 0 and fees2 <= 0
      x_labels << "Fees"
      data << fees
      data2 << fees2
      largest_value = fees if largest_value < fees
      largest_value = fees2 if largest_value < fees2
    end
       
   

    unless income <= 0 and income2 <= 0
      x_labels << "Other Income"
      data << income
      data2 << income2
      largest_value = income if largest_value < income
      largest_value = income2 if largest_value < income2
    end

    unless expense <= 0 and expense2 <= 0
      x_labels << "Other Expense"
      data << expense-(expense*2)
      data2 << expense2-(expense2*2)
      largest_value = expense if largest_value < expense
      largest_value = expense2 if largest_value < expense2
    end

    #       other = 0
    #    other_transactions.each do |trans|
    #
    #      if trans.category.is_income? and trans.master_transaction_id == 0
    #        other += trans.amount
    #      else
    #        other -= trans.amount
    #      end
    #    end
    #    x_labels << "other"
    #    data << other
    #    largest_value = other if largest_value < other
    #    other2 = 0
    #    other_transactions2.each do |trans2|
    #      if trans2.category.is_income?
    #        other2 += trans2.amount
    #      else
    #        other2 -= trans2.amount
    #      end
    #    end
    #    data2 << other2
    #    largest_value = other2 if largest_value < other2

    largest_value += 500

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 3;
    bargraph.text = "For the period #{start_date}-#{end_date}"
    bargraph.values = data
    bargraph2 = BarFilled.new()
    bargraph2.width = 1;
    bargraph2.colour = '#000000';
    bargraph2.dot_size = 3;
    bargraph2.text = "For the period #{start_date2}-#{end_date2}"
    bargraph2.values = data2

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(largest_value-(largest_value*2),largest_value,largest_value/5)

    title = Title.new("Finance Transaction")

    x_legend = XLegend.new("Examination name")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend = x_legend
    chart.set_y_legend = y_legend
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(bargraph)
    chart.add_element(bargraph2)


    render :text => chart.render

  end
  
  #ddnt complete this graph!

  def graph_for_transaction_comparison

    start_date = (params[:start_date]).to_date
    end_date = (params[:end_date]).to_date
    employees = Employee.find(:all)

    hr = Configuration.find_by_config_value("HR")
    donations_total = FinanceTransaction.donations_triggers(start_date,end_date)
    fees = FinanceTransaction.total_fees(start_date,end_date)
    income = FinanceTransaction.total_other_trans(start_date,end_date)[0]
    expense = FinanceTransaction.total_other_trans(start_date,end_date)[1]
    #    other_transactions = FinanceTransaction.find(:all,
    #      :conditions => ["transaction_date >= '#{start_date}' and transaction_date <= '#{end_date}'and category_id !='#{3}' and category_id !='#{2}'and category_id !='#{1}'"])


    x_labels = []
    data1 = []
    data2 = []
    
    largest_value =0

    unless hr.nil?
      salary = Employee.total_employees_salary(employees,start_date,end_date)
    end
    unless salary <= 0
      x_labels << "Salary"
      data << salary-(salary*2)
      largest_value = salary if largest_value < salary
    end
    unless donations_total <= 0
      x_labels << "Donations"
      data << donations_total
      largest_value = donations_total if largest_value < donations_total
    end

    unless fees <= 0
      x_labels << "Fees"
      data << fees
      largest_value = fees if largest_value < fees
    end

    unless income <= 0
      x_labels << "Other Income"
      data << income
      largest_value = income if largest_value < income
    end
        
    unless expense <= 0
      x_labels << "expense"
      data << expense
      largest_value = expense if largest_value < expense
    end
    
    #    other_transactions.each do |trans|
    #      x_labels << trans.title
    #      if trans.category.is_income? and trans.master_transaction_id == 0
    #        data << trans.amount
    #      else
    #        data << ("-"+trans.amount.to_s).to_i
    #      end
    #      largest_value = trans.amount if largest_value < trans.amount
    #    end

    largest_value += 500

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 3;
    bargraph.text = "Amount"
    bargraph.values = data

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(largest_value-(largest_value*2),largest_value,largest_value/5)

    title = Title.new("Finance Transaction")

    x_legend = XLegend.new("Examination name")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend = x_legend
    chart.set_y_legend = y_legend
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(bargraph)


    render :text => chart.render
 
   
  end
  #fee Discount
  def fee_discounts   
    @batches = []
    @fee_categories = []
  end

  def fee_discount_new
    @batches = Batch.active
    render :partial => 'fee_discount_new'
  end

  def load_discount_create_form
    if params[:type]== "batch_wise"
      @batchId = params[:batch_id]
      @categoryId = params[:category_id]
      # @fee_categories = FinanceFeeCategory.find(:all , :conditions => ["is_master = '#{1}' and is_deleted = '#{false}'"], :group => :name)
      @fee_discount = BatchFeeDiscount.new
      render  :partial => "batch_wise_discount_form"
    elsif params[:type]== "category_wise"
      @batchId = params[:batch_id]
      @categoryId = params[:category_id]
      # @fee_categories = FinanceFeeCategory.find(:all , :conditions => ["is_master = '#{1}' and is_deleted = '#{false}'"], :group => :name)
      @student_categories = StudentCategory.active
      render :partial => "category_wise_discount_form"
    elsif params[:type] == "student_wise"
      @courses = Course.active
      @batchId = params[:batch_id]
      @categoryId = params[:category_id]
      render :partial => "student_wise_discount_form"
    end
  end

  def load_discount_batch
    course  = Course.find_by_id(params[:id])
    unless course.nil?
    @batches = course.batches.active
    else
    @batches = [] 
    end
    render :partial => 'fee_discount_batch'
    
    # @course = Course.find(params[:id])
    # @batches = @course.batches(:conditions=>"is_deleted = 0")
    # render :update do |page|
      # page.replace_html "batch-box", :partial => "fee_discount_batch_list"
    # end
  end

  def load_batch_fee_category
    @fees_categories = FinanceFeeCategory.find_all_by_batch_id((params[:batch]),:conditions=>"is_deleted = 0 and is_master = 1")
    render :update do |page|
      page.replace_html "fee-category-box", :partial => "fee_discount_category_list"
    end
  end

  def batch_wise_discount_create
    @fee_category = FinanceFeeCategory.find_by_id(params[:master_category_id])
    @fee_discount = BatchFeeDiscount.new(params[:fee_discount])
    @fee_discount.finance_fee_category_id = params[:master_category_id]
    @fee_discount.receiver_id =  params[:batch_id]
    @fee_discount.batch_id =  params[:batch_id]
    # unless params[:fee_collection].blank?
      # params[:fee_collection][:category_ids].each do |c|
        # @fee_category = FinanceFeeCategory.find(c)
        # @fee_discount = BatchFeeDiscount.new(params[:fee_discount])
        # @fee_discount.finance_fee_category_id = c
        # @fee_discount.receiver_id =  @fee_category.batch_id
        unless @fee_discount.save
          @error = true
        end
      # end
    # else
      # @fee_discount = BatchFeeDiscount.new(params[:fee_discount])
      # @fee_discount.errors.add(:category , "Fee Category cant be blank")
      # @error = true
    # end
    respond_to do |format|
      if @error.nil?
         format.json { render :json => {:valid => true, :fee_discount => @fee_discount, :notice => "Fees Discount is successfully created."}}
      else
        format.json { render :json => {:valid => false, :errors => @fee_discount.errors}}
      end
    end
  end

  def category_wise_fee_discount_create
      @fee_category = FinanceFeeCategory.find_by_id(params[:master_category_id])
      @fee_discount = StudentCategoryFeeDiscount.new(params[:fee_discount])
      @fee_discount.finance_fee_category_id = params[:master_category_id]
      @fee_discount.batch_id =  params[:batch_id]
    # unless params[:fee_collection].blank?
      # params[:fee_collection][:category_ids].each do |c|
        # @fee_category = FinanceFeeCategory.find(c)
        # @fee_discount = StudentCategoryFeeDiscount.new(params[:fee_discount])
        # @fee_discount.finance_fee_category_id = c
        unless @fee_discount.save
          @error = true
        end
      # end
    # else
      # @fee_discount = StudentCategoryFeeDiscount.new(params[:fee_discount])
      # @fee_discount.errors.add(:batch , "cant be blank")
      # @error = true
    # end
     respond_to do |format|
      if @error.nil?
         format.json { render :json => {:valid => true, :fee_discount => @fee_discount, :notice => "Fees Discount is successfully created."}}
      else
        format.json { render :json => {:valid => false, :errors => @fee_discount.errors}}
      end
    end
  end

  def student_wise_fee_discount_create
    @fee_discount = StudentFeeDiscount.new(params[:fee_discount])
    batch = Batch.find_by_id(params[:batch_id])
    unless (params[:fee_discount][:finance_fee_category_id]).blank?
      @fee_category = FinanceFeeCategory.find(@fee_discount.finance_fee_category_id)
      unless (params[:students]).blank?
        admission_no = (params[:students]).split(",")
        admission_no.each do |a|
          s = Student.find_by_admission_no(a)
          unless s.nil?
            if FeeDiscount.find_by_type_and_receiver_id('StudentFeeDiscount',s.id,:conditions=>"finance_fee_category_id = #{@fee_category.id}").present?
              @error = true
              @fee_discount.errors.add(:discount , "already exists for admission number - #{a}")
            end
            # unless (@fee_category.batches.include?(batch))
            unless (s.batch_id.to_s == batch.id.to_s)
              @error = true
              @fee_discount.errors.add(:adimssion_no , "#{a} does not belong to Batch #{batch.full_name}")
            end
          else
            @error = true
            @fee_discount.errors.add(:adimssion_no, "#{a} is invalid admission number")
          end
        end
        unless @error
          admission_no.each do |a|
            s = Student.find_by_admission_no(a)
            @fee_discount = StudentFeeDiscount.new(params[:fee_discount])
            @fee_discount.receiver_id = s.id
            @fee_discount.batch_id = s.batch_id
            unless @fee_discount.save
              @error = true
            end
          end
        end
      else
        @error = true
        @fee_discount.errors.add(:adimssion_no, "can't be blank")
      end
    else
      @error = true
      @fee_discount.errors.add(:fees_category, "can't be blank")
    end
    respond_to do |format|
      if @error.nil?
         format.json { render :json => {:valid => true, :fee_discount => @fee_discount, :notice => "Fees Discount is successfully created."}}
      else
        format.json { render :json => {:valid => false, :errors => @fee_discount.errors}}
      end
    end
  end
  

  def update_master_fee_category_list
    @batch = Batch.find_by_id(params[:id])
    unless @batch.nil?
    @fee_categories = @batch.fee_category
    else
    @fee_categories = []  
    end
    # @fee_categories = FinanceFeeCategory.find_all_by_batch_id(@batch.id, :conditions=>"is_master=1 and is_deleted= 0 and school_session_id=#{current_session.id}" )
    render  :partial => "update_master_fee_category_list"
  end

  def show_fee_discounts
    @fee_category = FinanceFeeCategory.find_by_id(params[:id])
    batch = Batch.find_by_id(params[:batch_id])
    unless @fee_category.nil?
    @discounts = FeeDiscount.find_all_by_finance_fee_category_id_and_batch_id(@fee_category.id, batch.id)
    @fee_category.is_collection_open ? @discount_edit = false : @discount_edit = true
    else
    @discounts = []
    end
    render :partial => "show_fee_discounts"
  end

  def edit_fee_discount
    @fee_discount = FeeDiscount.find_by_id(params[:id])
    render :partial => 'fee_discount_edit_form'
  end

  def update_fee_discount
    @fee_discount = FeeDiscount.find_by_id(params[:id])
    unless @fee_discount.update_attributes(params[:fee_discount])
      @error = true
    # else
      # @discounts = FinanceFeeCategory.find(@fee_discount.finance_fee_category_id).fee_discounts
    end
    respond_to do |format|
      if @error.nil?
         format.json { render :json => {:valid => true, :fee_discount => @fee_discount, :notice => "Fees Discount is successfully Updated."}}
      else
        format.json { render :json => {:valid => false, :errors => @fee_discount.errors}}
      end
    end
  end

  def delete_fee_discount
    @fee_discount = FeeDiscount.find_by_id(params[:id])
    # @fee_category = FinanceFeeCategory.find(@fee_discount.finance_fee_category_id)
    @error = true  unless @fee_discount.destroy
    # unless @fee_category.nil?
      # @discounts = @fee_category.fee_discounts
      # @fee_category.is_collection_open ? @discount_edit = false : @discount_edit = true
    # end
   respond_to do |format|
      if @error.nil?
         format.json { render :json => {:valid => true, :fee_discount => @fee_discount, :notice => "Fees Discount is successfully Deleted."}}
      else
        format.json { render :json => {:valid => false, :errors => @fee_discount.errors}}
      end
    end
  end

  def collection_details_view
    @fee_collection = FinanceFeeCollection.find(params[:id])
    @particulars = @fee_collection.fee_collection_particulars
    @discounts = @fee_collection.fee_collection_discounts
  end

  def fixed_category_name
    @cat_names = ['Fee','Salary','Donation','Library','Hostel','Transport']
    @fixed_cat_ids = FinanceTransactionCategory.find(:all,:conditions=>{:name=>@cat_names}).collect(&:id)
  end
  
  def fees_student_search
   render :layout => false
  end

end
