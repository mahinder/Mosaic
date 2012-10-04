class EmployeesController < ApplicationController
   
   before_filter :login_required,:configuration_settings_for_hr
   filter_access_to :all
   
   layout :choose_layout
   before_filter :protect_other_employee_data, :only => [:individual_payslip_pdf,:timetable,:timetable_pdf,:profile_payroll_details,\
      :view_attendance,:view_payslip, :profile ]
  before_filter :protect_edit_employee, :only=>[:edit_employee]
    
   def choose_layout
    if action_name == 'wizard_first_step' || action_name == 'wizard_next_step' || action_name == 'wizard_previous_step'
      return 'employees'
    else
      return 'application'
    end
  end
  # GET /employees
  # GET /employees.json
  
  def employee_all_skills
    @user = current_user
    unless @user.nil?
      @employee = @user.employee_record
    end
   
  end
  

  
  def index
  
   if params[:search].length>= 3
      @employees = Employee.find(:all,
                    :conditions => "(first_name LIKE \"%#{params[:search]}%\")") unless params[:search] == ''

  respond_to do |format|
   format.html # index.html.erb
   format.xml  { render :xml => @employees }
   format.js  
   end
   end
  end

  # GET /employees/1grade
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end
  
  def wizard_first_step 
    session[:employee_params] = {}
    session[:employee_step] = nil;
    @last_admitted_employee = Employee.maximum('employee_number')
    @config = SchoolConfiguration.find_by_config_key('EmployeeNumberAutoIncrement')
    @employee = Employee.new
    @dob = 'nil'
    @doj = 'nil'
    render 'wizard'
    # @start_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftStartTime'})[0].config_value.to_time
    # @end_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftEndTime'})[0].config_value.to_time
    # @employee = Employee.new( session[:employee_params])
    # @departments = EmployeeDepartment.find(:all,:conditions => {:status => true})
    # @grades = EmployeeGrade.find(:all,:conditions => {:status => true})
    # @categories = EmployeeCategory.find(:all,:conditions => {:status => true})
    # @positions = EmployeePosition.find(:all,:conditions => {:status => true })
    # @nationality = Country.find(:all)
  end
  
  def my_batches
    @user = current_user
     @role = @user.role_name
      if @role == "Employee" || @role == "Admin"
        @employee = @user.employee_record
        @batch = employee_batches(@employee)
       end
  end
  
  def search_batch_student
   @batch = Batch.find(params[:id])
    render "/batches/_students",:layout => false
  end
  def wizard_next_step 
    recipients = nil
    sms_setting = SmsSetting.new()
    responsevalue = ""
     message = 'Dear Staff, Congratulations! on joining Mount Carmel School, Your username and password has been mailed to you. Regards MCSCHD'
    @pos = session[:employee_params]['employee_position_id']
    @cat = session[:employee_params]['employee_category_id']
    @rpmid = session[:employee_params]['reporting_manager_id']
      session[:employee_params].deep_merge!(params[:employee]) if params[:employee]
   
     @start_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftStartTime'})[0].config_value
       session[:employee_params][:shift_start_time] = @start_time
        @end_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftEndTime'})[0].config_value
       session[:employee_params][:shift_end_time] = @end_time
    @employee = Employee.new session[:employee_params]
       
      @departments = EmployeeDepartment.find(:all,:conditions => {:status => true})
      @grades = EmployeeGrade.find(:all,:conditions => {:status => true})
      @categories = EmployeeCategory.find(:all,:conditions => {:status => true})
      unless @pos.nil?
        @positions = EmployeePosition.find_all_by_employee_category_id(@cat,:conditions=> {:status => true})
        
      else
        @positions = []
      end
      
      @nationality = Country.find(:all)
       
      @employee.current_step = session[:employee_step] 
     
      if @employee.current_step == "photo" && @employee.valid? 
        emp_number = session[:employee_params]['employee_number']
        session[:employee_params]['employee_number'] = emp_number.upcase
       if !session[:employee_params]['is_teacher']
     session[:employee_params]['is_teacher'] = false
   end
        @employee = Employee.new session[:employee_params] 
           if  @employee.save
             add_default_leave(@employee)
             user = @employee.user
            unless user.nil?
               chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
                newpass = ""
                1.upto(20) { |i| newpass << chars[rand(chars.size-1)] }
                @subject = "Appointment"
                @body = "Congratulations for joining . Your username is "+user.username+". Your password is " + newpass
                
                UserMailer.registration_confirmation(user,@subject,@body).deliver
             unless  @employee.mobile_phone.nil?
              if sms_setting.application_sms_active and sms_setting.employee_sms_active
                  recipients =  sms_setting.create_recipient(@employee.mobile_phone,recipients)
              end
              response =  sms_setting.send_sms(message,recipients)
              if response == "something went worng"
                 responsevalue = "But sms can't be send due some error in sms service"
              end
            end
             
             
             end
               if @employee.is_teacher?
               @user  = @employee.user
               @privileges = Privilege.find_by_name("Teacher")
               @user.privileges = [@privileges]
             end 
           flash[:notice] = "Employee created #{@employee.first_name}. Please check mail." + responsevalue 
           session[:employee_params]= nil
           @employee.next_step  
           @employee.current_step = session[:employee_step]
            
        end
      end
        session[:employee_step] = @employee.current_step
   
     @employee.next_step
     session[:employee_step] = @employee.current_step

    render 'wizard'
  end
  
  def wizard_previous_step  
   @pos = session[:employee_params]['employee_position_id']
   
 @cat = session[:employee_params]['employee_category_id']
 @rpmid = session[:employee_params]['reporting_manager_id']
 
    session[:employee_params].deep_merge!(params[:employee]) if params[:employee]  
 
    @config = SchoolConfiguration.find_by_config_key('EmployeeNumberAutoIncrement')
    @employee = Employee.new session[:employee_params]
   @dob = @employee.date_of_birth
   @doj = @employee.joining_date
    if @employee.valid?
      # @start_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftStartTime'})[0].config_value.to_time
      # @end_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftEndTime'})[0].config_value.to_time
      @departments = EmployeeDepartment.find(:all,:conditions => {:status => true})
      @grades = EmployeeGrade.find(:all,:conditions => {:status => true})
      @categories = EmployeeCategory.find(:all,:conditions => {:status => true})
      unless @pos.nil?
        @positions = EmployeePosition.find_all_by_employee_category_id(@cat,:conditions=> {:status => true})
        
      else
        @positions = []
      end
     
      @nationality = Country.find(:all)
      
      @employee.current_step = session[:employee_step] 
      @employee.previous_step
      session[:employee_step] = @employee.current_step
    end
    render "wizard"
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    session[:employee_params] ||= {} #initialisation assignment to empty array
    @employee = Employee.new( session[:employee_params])
    @employee.current_step = session[:employee_step]
    @departments = EmployeeDepartment.find(:all,:conditions => {:status => true})
    @grades = EmployeeGrade.find(:all,:conditions => {:status => true})
    @categories = EmployeeCategory.find(:all,:conditions => {:status => true})
    @positions = EmployeePosition.find(:all,:conditions => {:status => true })
    @nationality = Country.find(:all)  
  end
  def upload
    
    session[:return_to]= request.referer
    if params[:upload].include? "datafile1"  
       post = Employee.save(params[:upload],current_user)
       if post == true
          flash[:notice] = "file Uploaded" 
        else
           flash[:warning] = "Can't be upload file due to some problem in file" 
       end
      else
       flash[:warning] = "Please Select file to Upload" 
    end
    redirect_to session[:return_to]
  end
  
  
  def show_file_directory
     
    session[:return_to] = request.referer
    if params[:value] == "open"
     if File.exist?("#{Rails.root}/public/system/attachment/employee/#{params[:student]}/#{params[:dir]}/#{params[:file]}")  
          send_file  "#{Rails.root}/public/system/attachment/employee/#{params[:student]}/#{params[:dir]}/#{params[:file]}", :file_name => params[:file]
     else
          flash[:warning] = "File does not exist in specified folder"
          redirect_to session[:return_to]
     end  
    
    else
      if File.exist?("#{Rails.root}/public/system/attachment/employee/#{params[:student]}/#{params[:dir]}/#{params[:file]}")  
          File.delete("#{Rails.root}/public/system/attachment/employee/#{params[:student]}/#{params[:dir]}/#{params[:file]}")
          EmployeeAttachment.find_by_file_name(params[:file]).update_attributes(:deleted_by_id => current_user.id)
          flash[:notice] = "File is remove from specified folder"
          redirect_to session[:return_to]
      else
          flash[:notice] = "File does not exist in specified folder"
          redirect_to session[:return_to]
       end 
       
    end 
     
  end
  def attachments
  
   @employee_id = params[:id]
   @employee_number = params[:q]
   
  end
 
  # POST /employees
  # POST /employees.json
 
  def save
    recipients = nil
    sms_setting = SmsSetting.new()
     message = 'Dear Staff, Congratulations! on joining Mount Carmel School, Your username and password has been mailed to you. Regards MCSCHD'
   emp_number = session[:employee_params]['employee_number']
   session[:employee_params]['employee_number'] = emp_number.upcase
   if !session[:employee_params]['is_teacher']
     session[:employee_params]['is_teacher'] = false
   end
   @employee = Employee.new session[:employee_params] 
    respond_to do |format|
      if @employee.valid? 
        @employee.save 
        add_default_leave(@employee)
        user = @employee.user
        unless user.nil?
               chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
                newpass = ""
                1.upto(20) { |i| newpass << chars[rand(chars.size-1)] }
                @subject = "Appointment"
                @body = "Congratulations for joining . Your username is "+user.username+". Your password is " + newpass
                UserMailer.registration_confirmation(user,@subject,@body).deliver

            unless  @employee.mobile_phone.nil?
              if sms_setting.application_sms_active and sms_setting.employee_sms_active
                  recipients =  sms_setting.create_recipient(@employee.mobile_phone,recipients)
              end
               sms_setting.send_sms(message,recipients)
            end
            
             end
         if @employee.is_teacher?
               @user  = @employee.user
               @privileges = Privilege.find_by_name("Teacher")
               @user.privileges = [@privileges]
             end 
        flash[:notice] = "employee created #{@employee.first_name}. please check mail."       
        format.json { render :json => {:valid => true, :employee_id => @employee.id}}       
      else       
       format.html { render action: "new" }
       format.json { render :json => {:valid => false, :errors => @employee.errors}}
      end
     end
  end
  
  #this action is used for employee default leave
  def add_default_leave(employee)
    @leave_types = EmployeeLeaveType.find(:all, :order => "name ASC",:conditions=>{:status => 1})
      @leave_types.each do |leave_type|
       EmployeeLeave.create( :employee_id => employee.id, :employee_leave_type_id => leave_type.id, :leave_count => leave_type.max_leave_count)
      end
    
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(:last)
    if @employee.update_attributes(params[:employee])
      format.json { render :json => {:valid => true, :employee_id => @employee.id}}  
    else
    end
  end
  
   def demo
    @employee = Employee.find(:last)
  respond_to do |format|
 if @employee.update_attributes(params[:employee])
    format.json { render :json => {:valid => true, :employee_id => @employee.id}}  
  else
   format.json { render :json => {:valid => false, :employee_id => @employee.id}}  
  end
  end
  end
  
  
  def profile
   
    @employee = Employee.find_by_id(params[:id])
     @dir = []
    unless  @employee.nil?
      @emp_skill = @employee.skills
        @attachements = EmployeeAttachment.find_all_by_employee_id(@employee.id)
     unless @attachements.empty?
       @attachements.each do |at|
         @dir << at.dir_name unless @dir.include? at.dir_name
       end
       
     end
      user = User.find_by_username(@employee.employee_number)
      @privileges =user.privileges
       emp_privilege = current_user.privileges.map{|p| p.id}
       basic_search= Privilege.find_by_name('EmployeeBasicSearch')
      @view_basic = emp_privilege.include?(basic_search.id)
      @assign_pri=emp_privilege.include?(Privilege.find_by_name('AssignPrivilege').id)
      @additional_fields = AdditionalField.find(:all, :conditions=>{:status => true})
      @bank_fields = BankField.find(:all, :conditions=>{:status => true})
      @employee_salary_structure = @employee.employee_salary_structures
      @reporting_manager = Employee.find(@employee.reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
    exp_years = @employee.experience_year
    exp_months = @employee.experience_month
    date = Date.today
    total_current_exp_days = (date-@employee.joining_date).to_i
    current_years = (total_current_exp_days/365)
    rem = total_current_exp_days%365
    current_months = rem/30
    total_month = (exp_months || 0)+current_months
    year = total_month/12
    month = total_month%12
    @total_years = (exp_years || 0)+current_years+year
    @total_months = month
    else
      flash[:notice] = "Sorry, Employee record not found."
        redirect_to :controller =>'sessions', :action =>'dashboard'
    end

  end

  
  def profile_pdf
    @employee = Employee.find(params[:id])
    @gender = @employee.gender
    @status = "Active"
    @status = "Inactive" if @employee.status == false
    @reporting_manager = Employee.find(@employee.reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
    exp_years = @employee.experience_year
    exp_months = @employee.experience_month
    date = Date.today
    total_current_exp_days = (date-@employee.joining_date).to_i
    current_years = total_current_exp_days/365
    rem = total_current_exp_days%365
    current_months = rem/30
    total_month = current_months if exp_months.nil?
    total_month = exp_months+current_months unless exp_months.nil?
    year = total_month/12
    month = total_month%12
    @total_years = current_years+year if exp_years.nil?
    @total_years = exp_years+current_years+year unless exp_years.nil?
    @total_months = month
    @home_country = Country.find(@employee.home_country_id).name unless @employee.home_country_id.nil?
    @office_country = Country.find(@employee.office_country_id).name unless @employee.office_country_id.nil?
    render :pdf => 'profile_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
        end

  def hr
    user = current_user
   @employee = user.employee_record
  
  end

  def admission3
    @employee = Employee.find_by_id(params[:id])
    unless @employee.nil?
    @bank_fields = BankField.find(:all, :conditions=>{:status => true})
    params[:employee_bank_details].each_pair do |k, v|
      @emp_bank_det = EmployeeBankDetail.find(:all , :conditions => {:employee_id => @employee.id, :bank_field_id => k})
    end 
    if @emp_bank_det.empty?
      EmployeeBankDetail.destroy_all(:employee_id => @employee.id)
       params[:employee_bank_details].each_pair do |k, v|
              EmployeeBankDetail.create(:employee_id => params[:id],
                :bank_field_id => k,:bank_info => v['bank_info'])
            end
      flash[:notice] = "Employee records saved for #{@employee.first_name} #{@employee.last_name}."
    redirect_to :controller => "employees", :action=> "edit_employee", :q => @employee.id
  else
     params[:employee_bank_details].each_pair do |k, v|    
                 @emp_bank_det = EmployeeBankDetail.find(:all , :conditions => {:bank_field_id => k , :employee_id => @employee.id})
                   @emp_bank_det.each do |h|
                       h.update_attributes(:employee_id => params[:id],
                          :bank_field_id => k,:bank_info => v['bank_info'])
                   end
             end
            flash[:notice] = "Employee records saved for #{@employee.first_name} #{@employee.last_name}."
    redirect_to :controller => "employees", :action=> "edit_employee", :q => @employee.id
    end
    else
       flash[:notice] = "Employee record not found"
       redirect_to :controller => "sessions", :action=> "dashboard"
    end
end
  def edit3
    @employee = Employee.find_by_id(params[:id])
    unless @employee.nil?
    @bank_fields = BankField.find(:all, :conditions=>{:status => true})
    if @bank_fields.empty?
      flash[:notice] = "No bank fields available"
      redirect_to :action => "profile", :id => @employee.id
    end
    if request.post?
      params[:employee_bank_details].each_pair do |k, v|
        row_id= EmployeeBankDetail.find_by_employee_id_and_bank_field_id(@employee.id,k)
        unless row_id.nil?
          bank_detail = EmployeeBankDetail.find_by_employee_id_and_bank_field_id(@employee.id,k)
          EmployeeBankDetail.update(bank_detail.id,:bank_info => v['bank_info'])
        else
          EmployeeBankDetail.create(:employee_id=>@employee.id,:bank_field_id=>k,:bank_info=>v['bank_info'])
        end
      end
      flash[:notice] = "Employee #{@employee.first_name} bank details updated"
      redirect_to :action => "profile", :id => @employee.id
    end
    else
       flash[:notice] = "Employee record not found"
       redirect_to :controller => "sessions", :action=> "dashboard"
    end
  end

  def admission3_1
    @employee = Employee.find_by_id(params[:id])
    unless @employee.nil?
    @additional_fields = AdditionalField.find(:all, :conditions=>{:status => true})
     params[:employee_additional_details].each_pair do |k, v|
      @emp_additional_det = EmployeeAdditionalDetail.find(:all , :conditions => {:employee_id => @employee.id, :additional_field_id => k})
    end 
    if @emp_additional_det.empty?
       EmployeeAdditionalDetail.destroy_all(:employee_id => @employee.id)
        params[:employee_additional_details].each_pair do |k, v|
              EmployeeAdditionalDetail.create(:employee_id => params[:id],
                :additional_field_id => k,:additional_info => v['additional_info'])
            end
            redirect_to :controller => "employees", :action=> "edit_employee", :q => @employee.id 
      flash[:notice] = "Employee records saved for #{@employee.first_name} #{@employee.last_name}."
 else
    params[:employee_additional_details].each_pair do |k, v|    
                 @emp_additional_det = EmployeeAdditionalDetail.find(:all , :conditions => {:additional_field_id => k , :employee_id => @employee.id})
                   @emp_additional_det.each do |h|
                       h.update_attributes(:employee_id => params[:id],
                          :additional_field_id => k,:additional_info => v['additional_info'])
                   end
             end
            flash[:notice] = "Employee records saved for #{@employee.first_name} #{@employee.last_name}."
   redirect_to :controller => "employees", :action=> "edit_employee", :q => @employee.id
 end
 else
   flash[:notice] = "Employee record not found"
       redirect_to :controller => "sessions", :action=> "dashboard"
 end
    end
   def edit_privilege
   
    @privileges = Privilege.find(:all)
    teacher_privileges = Privilege.find_by_name('Teacher')
    @user = User.find_by_username(params[:id])
    unless @user.nil?
      @employee = @user.employee_record
    unless @employee.nil?
      if request.post?
       if params[:user][:privilege_ids]
        new_privileges = params[:user][:privilege_ids]
        new_privileges ||= []
          unless params[:user][:privilege_ids].include?(teacher_privileges.id.to_s)
          @employee.update_attributes(:is_teacher=>false)
          else
             @employee.update_attributes(:is_teacher=>true)
            end
        @user.privileges = Privilege.find_all_by_id(new_privileges)
        flash[:notice] = "Employee privileges updated succesfully"
        redirect_to :action => "profile", :id => @employee.id
        else
           new_privileges = []
          
           @user.privileges = Privilege.find_all_by_id(new_privileges)
            @employee.update_attributes(:is_teacher=>false)
            flash[:notice] = "Employee privileges updated succesfully"
        redirect_to :action => "profile", :id => @employee.id
      end
      end
    else
      flash[:notice] = "Employee record not found"
      redirect_to :controller => "sessions", :action=> "dashboard"
    end
    else
      flash[:notice] = "Employee record not found"
      redirect_to :controller => "sessions", :action=> "dashboard"
    
    end
    end 

  def edit3_1
    @employee = Employee.find(params[:id])
    @additional_fields = AdditionalField.find(:all, :conditions=>{:status => true})
    if @additional_fields.empty?
      flash[:notice] = "No additional details available"
      redirect_to :action => "profile", :id => @employee.id
    end
    if request.post?
      params[:employee_additional_details].each_pair do |k, v|
        row_id= EmployeeAdditionalDetail.find_by_employee_id_and_additional_field_id(@employee.id,k)
        unless row_id.nil?
          additional_detail = EmployeeAdditionalDetail.find_by_employee_id_and_additional_field_id(@employee.id,k)
          EmployeeAdditionalDetail.update(additional_detail.id,:additional_info => v['additional_info'])
        else
          EmployeeAdditionalDetail.create(:employee_id=>@employee.id,:additional_field_id=>k,:additional_info=>v['additional_info'])
        end
      end
      flash[:notice] = "Employee #{@employee.first_name} additional details updated"
      redirect_to :action => "profile", :id => @employee.id
    end
  end

  
 

 

  

  def search
     @employees = Employee.find(:all,:order => "first_name asc")
    render :layout => 'application'
  end

  def search_ajax
  
     query = params[:q]
     if query.length>= 3
       @employee = Employee.find(:all,
                    :conditions => "(first_name LIKE \"%#{params[:q]}%\" OR middle_name LIKE \"%#{params[:q]}%\" OR last_name LIKE \"%#{params[:q]}%\")",
                     :order => "first_name asc") unless params[:q] == ''
    end
    response = { :employee => @employee}
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  def select_reporting_manager
    
    query = params[:q]
   
       @employee = Employee.find(:all,
                    :conditions => "(first_name LIKE \"%#{params[:q]}%\" OR middle_name LIKE \"%#{params[:q]}%\" OR last_name LIKE \"%#{params[:q]}%\")",
                     :order => "first_name asc") unless params[:q] == ''
      render :partial=>'select_reporting_manager'
  end
  #HR Management special methods...

  def hr
    user = current_user
    @employee = user.employee_record
  end
  def leave_management
    user = current_user
    @employee = user.employee_record
    @all_employee = Employee.find(:all)
    @reporting_employees = Employee.find_all_by_reporting_manager_id(@employee.id)
    @leave_types = EmployeeLeaveType.find(:all)
    @total_leave_count = 0
    @reporting_employees.each do |e|
      @app_leaves = ApplyLeave.count(:conditions=>["employee_id =? AND viewed_by_manager =?", e.id, false])
      @total_leave_count = @total_leave_count + @app_leaves
    end
    @all_employee_total_leave_count = 0
    @all_employee.each do |a|
      @all_emp_app_leaves = ApplyLeave.count(:conditions=>["employee_id =? AND viewed_by_manager =?" , a.id, false])
      @all_employee_total_leave_count = @all_employee_total_leave_count + @all_emp_app_leaves
    end

    @leave_apply = ApplyLeave.new(params[:leave_apply])
    if request.post? and @leave_apply.save
      ApplyLeave.update(@leave_apply, :approved=> false, :viewed_by_manager=> false)
      if params[:is_half_day]
        ApplyLeave.update(@leave_apply, :is_half_day=> true)
      else
        ApplyLeave.update(@leave_apply, :is_half_day=> false)
      end
      flash[:notice]="Leave application created"
      redirect_to :controller => "employee", :action=> "leave_management", :id=>@employee.id
    end
  end

  def all_employee_leave_applications

    @employee = Employee.find(params[:id])
    @departments = EmployeeDepartment.find(:all, :order=>"name ASC")
    @employees = []
    render :partial=> "all_employee_leave_applications"
  end

  
  
 

  #PDF methods

 
 
 
  def advanced_search
    @search = Employee.search(params[:search])
   if params[:search]
      if params[:search][:status_equals]=="true"
        @search = Employee.search(params[:search])
        @employees1 = @search.all
        @employees2 = []
      elsif params[:search][:status_equals]=="false"
        @search = ArchivedEmployee.search(params[:search])
        @employees1 = @search.all
        @employees2 = []
      else
        @search1 = Employee.search(params[:search]).all
        @search2 = ArchivedEmployee.search(params[:search]).all
        @employees1 = @search1
        @employees2 = @search2
      end
    end
  end

 
  

  

  

  def change_to_former
    @employee = Employee.find(params[:id])
    if request.post?
      flash[:success]="Successfully deleted employee!"
      EmployeesSubject.destroy_all(:employee_id=>@employee.id)
      @employee.archive_employee(params[:remove][:status_description])
      FileUtils.rm_rf("#{Rails.root}/public/system/employee_photos/#{@employee.id}")  
      redirect_to :controller => "sessions",:action => "dashboard"
    end
  end

  def delete
    employee = Employee.find(params[:id])
    employee_subject=EmployeesSubject.destroy_all(:employee_id=>employee.id)
    employee.destroy
    flash[:success] = "All records have been deleted for employee with employee no. #{employee.employee_number}."
    redirect_to :controller => 'user', :action => 'dashboard'
  end

  def advanced_search_pdf
    @employee_ids2 = params[:result2]
    @employee_ids = params[:result]
    @searched_for = params[:for]
    @status = params[:status]
    @employees1 = []
    @employees2 = []
    if params[:status] == 'true'
      @employee_ids.each do |s|
        employee = Employee.find(s)
        @employees1.push employee
      end
    elsif params[:status] == 'false'
      @employee_ids.each do |s|
        employee = ArchivedEmployee.find(s)
        @employees1.push employee
      end
    else
      @employee_ids.each do |s|
        employee = Employee.find(s)
        @employees1.push employee
      end
      unless @employee_ids2.nil?
        @employee_ids2.each do |s|
          employee = ArchivedEmployee.find(s)
          @employees2.push employee
        end
      end
    end
    render :pdf => 'advanced_search_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end


  def payslip_approve
    @salary_dates = MonthlyPayslip.find(:all, :select => "distinct salary_date")
  end

  def one_click_approve
    @dates = MonthlyPayslip.find_all_by_salary_date(params[:salary_date],:conditions => ["is_approved = false"])
    @salary_date = params[:salary_date]
    render :update do |page|
      page.replace_html "approve",:partial=> "one_click_approve"
    end
  end

  def one_click_approve_submit
    dates = MonthlyPayslip.find_all_by_salary_date(Date.parse(params[:date]))

    dates.each do |d|
      d.approve(current_user.id)
    end
    flash[:notice] = 'Payslip has been approved'
    redirect_to :action => "hr"

  end
  def payslip
    
  end

def leave_management
    user = current_user
    @employee = user.employee_record
    @all_employee = Employee.find(:all)
    @reporting_employees = Employee.find_all_by_reporting_manager_id(@employee.id)
    @leave_types = EmployeeLeaveType.find(:all)
    @total_leave_count = 0
    @reporting_employees.each do |e|
      @app_leaves = ApplyLeave.count(:conditions=>["employee_id =? AND viewed_by_manager =?", e.id, false])
      @total_leave_count = @total_leave_count + @app_leaves
    end
    @all_employee_total_leave_count = 0
    @all_employee.each do |a|
      @all_emp_app_leaves = ApplyLeave.count(:conditions=>["employee_id =? AND viewed_by_manager =?" , a.id, false])
      @all_employee_total_leave_count = @all_employee_total_leave_count + @all_emp_app_leaves
    end

    @leave_apply = ApplyLeave.new(params[:leave_apply])
    if request.post? and @leave_apply.save
      ApplyLeave.update(@leave_apply, :approved=> false, :viewed_by_manager=> false)
      if params[:is_half_day]
        ApplyLeave.update(@leave_apply, :is_half_day=> true)
      else
        ApplyLeave.update(@leave_apply, :is_half_day=> false)
      end
      flash[:notice]="Leave application created"
      redirect_to :controller => "employee", :action=> "leave_management", :id=>@employee.id
    end
  end

  def employee_leave_count_edit
   
    @leave_count = EmployeeLeave.find_by_id(params[:id])
    @leave_type = EmployeeLeaveType.find_by_id(params[:leave_type])
     render :partial => 'edit_leave_count'
  end

  def employee_leave_count_update
    available_leave = params[:leave_count]
    leave = EmployeeLeave.find_by_id(params[:id])
    leave.update_attributes(:leave_count => available_leave.to_f)
    @employee = Employee.find(leave.employee_id)
    @attendance_report = EmployeeAttendance.find_all_by_employee_id(@employee.id)
    @leave_types = EmployeeLeaveType.find(:all, :conditions => "status = true")
    @leave_count = EmployeeLeave.find_all_by_employee_id(@employee)
    @total_leaves = 0
    @leave_types.each do |lt|
      leave_count = EmployeeAttendance.find_all_by_employee_id_and_employee_leave_type_id(@employee.id,lt.id).size
      @total_leaves = @total_leaves + leave_count
    end
    render :nothing => true
  end 
  
  
  def update_positions
  category_id = params[:category_id]
    @positions = EmployeePosition.find_all_by_employee_category_id(category_id,:conditions=> {:status => true})
    render :partial => "emp_positions"
  end
  
  def employee_attendance
    
  end
 def search_skill
  
   @employee = Employee.new session[:employee_params]
   query = params[:q]
      if query.length>= 3
        @skills = Skill.find(:all,
                     :conditions => "(name LIKE \"%#{query}%\")") unless query == ''
     end
    response = { :skills => @skills}
   respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end
  
  def change_image
       @employee = Employee.find(params[:id])
       @employee.current_step = 'photo'
  end
  def image_store
     @employee=Employee.find(params[:id])
    render :partial=> 'image'
end
def employee_search
     status = params[:status]
     query = params[:q]
       if query.length>= 2
       if status == 'checked'
       @employee = Employee.find(:all,
                  :conditions => "(employee_number LIKE \"#{query}%\"
                       OR first_name LIKE \"%#{query}%\"
                       OR middle_name LIKE \"%#{query}%\"
                       OR last_name LIKE \"%#{query}%\"
                       OR (CONCAT(first_name, \" \", middle_name) LIKE \"#{query}%\")
                       OR (CONCAT(first_name, \" \", last_name) LIKE \"#{query}%\")
                       OR CONCAT(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{query}%\")") unless query == ''
                     else
             @employee = ArchivedEmployee.find(:all,
                  :conditions => "(employee_number LIKE \"#{query}%\"
                       OR first_name LIKE \"%#{query}%\"
                       OR middle_name LIKE \"%#{query}%\"
                       OR last_name LIKE \"%#{query}%\"
                       OR (CONCAT(first_name, \" \", middle_name) LIKE \"#{query}%\")
                       OR (CONCAT(first_name, \" \", last_name) LIKE \"#{query}%\")
                       OR CONCAT(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{query}%\")") unless query == ''
                     end
     else
       # if status == 'checked'
      # @employee = Employee.find(:all,
        # :conditions => "(employee_number LIKE \"#{query}%\" )" + other_conditions,
        # :order => "employee_department_id asc,first_name asc") unless query == ''
        # else
       # @employee = ArchivedEmployee.find(:all,
        # :conditions => "(employee_number LIKE \"#{query}%\" )" + other_conditions,
        # :order => "employee_department_id asc,first_name asc") unless query == ''
        # end
    end
    
    response = { :employee => @employee}

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
   end
  
  def crop_employee_image
    @employee = Employee.find_by_id(params[:q])
    unless @employee.nil?
          respond_to do |format|
             if  @employee.update_attributes(params[:employee])
                format.json  { render :json => {:valid => true} }
             else
                format.json  { render :json => {:valid => false} }
             end

          end
    else
      flash[:notice] = "Sorry, Employee record not found."
      redirect_to :controller =>'sessions', :action =>'dashboard'
    end      
  end  
  
  def edit_employee
         query = params[:q]
         @year = []
         @year1 = ""
         @year << 'Year'
         50.times do |i|
           @year1  = i.to_s
           @year << @year1
         end
            @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            @class_timings =  ClassTiming.find(:all,:conditions => {:batch_id => nil})
            @weekdays =  Weekday.find(:all,:conditions => {:batch_id => nil})
            @additional_fields = AdditionalField.find(:all, :conditions=>{:status => true})
            @bank_fields = BankField.find(:all, :conditions=>{:status => true})
            @nationality = Country.find(:all)
            @categories = EmployeeCategory.find(:all,:order => "name asc", :conditions => {:status => true})
            @positions = EmployeePosition.find(:all)
            @grades = EmployeeGrade.find(:all,:order => "name asc", :conditions => {:status => true})
            @departments = EmployeeDepartment.find(:all,:order => "name asc", :conditions => {:status => true})
            @employee = Employee.find_by_id(query)

      unless @employee.nil?
          @start_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftStartTime'})[0].config_value
          @end_time = SchoolConfiguration.find(:all, :conditions => {:config_key => 'ShiftEndTime'})[0].config_value
          @courses = Course.active
          @emp_skill = @employee.skills
          @reporting_manager = Employee.find(@employee.reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
          @employee_user = @employee.user
          @attendance_report = EmployeeAttendance.find_all_by_employee_id(@employee.id)
          @leave_types = EmployeeLeaveType.find(:all, :conditions => "status = true")
          @leave_count = EmployeeLeave.find_all_by_employee_id(@employee,:joins=>:employee_leave_type,:conditions=>"status = true")
          @total_leaves = 0
          @leave_types.each do |lt|
          leave_count = EmployeeAttendance.find_all_by_employee_id_and_employee_leave_type_id(@employee.id,lt.id).size
          @total_leaves = @total_leaves + leave_count
           end
              if request.post?  
              role = @employee_user.role_name
                 if  @employee.update_attributes(params[:employee]) && @employee_user.update_attributes(:email=> @employee.email,:role=>role)  
                   @reporting_manager = Employee.find(@employee.reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
                   flash[:notice] = "Employee updated successfully"
                 else
                  flash[:notice] = nil
                  unless @employee_user.errors.full_messages.empty?
                     @errors = @employee_user.errors.full_messages 
                     @err_count = @employee_user.errors.count
                  else
                     @errors = @employee.errors.full_messages
                     @err_count=@employee.errors.count
                  end
              end
            end
            render :layout => 'application'
      else
         flash[:notice] = "Sorry, Employee record not found."
        redirect_to :controller =>'sessions', :action =>'dashboard'
    end
  end
  
  def update_skills
    params[:employee][:skill_ids] ||= []
    @employee = Employee.find(params[:id])
    
     if @employee.update_attributes(params[:employee])
       flash[:notice] = "Skills were updated successfully."
        redirect_to :action =>'edit_employee',:q=>@employee.id
      end
  end

def photo_crop
 
  query = params[:q]
     @employee = Employee.find(query)
    if @employee.update_attributes(params[:employee])
        redirect_to :controller => 'employees', :action => 'employee_photo_crop', :q => @employee.id
      end
   end
   
   def employee_photo_crop
      @employee = Employee.find(params[:q])
     render :partial => 'employee_photo_crops'
   end
   def employee_no
   
    @employee = Employee.find_by_employee_number(params[:employee_number]) ||  ArchivedEmployee.find_by_employee_number(params[:employee_number])
    respond_to do |format|
        if @employee.nil?
           format.json { render :json => {:valid => false, :employee => @employee}}
        else
           format.json { render :json => {:valid => true, :errors => @employee,:notice => "employee number has already been taken"}}
        end
    end
  end
  def employee_mail
    params[:employee_email]
    @employee = User.find_by_email(params[:employee_email])
    respond_to do |format|
        if @employee.nil?
           format.json { render :json => {:valid => false, :employee => @employee}}
        else
           format.json { render :json => {:valid => true, :errors => @employee,:notice => "employee email has already been taken"}}
        end
    end
  end
  
  def search_all_skill
   render :layout =>'skills'
  end
  

  def advance_search_pdf
    
            @employee = Employee.find(:all)
        
      render :pdf =>'advance_search_pdf'
  end
  
  def employee_finance_setting
    
  end
  def select_department_employee
    @departments= EmployeeDepartment.find(:all,:conditions=>{:status=>true})
  end
   def rejected_payslip
    @departments= EmployeeDepartment.find(:all,:conditions=>{:status=>true})
  end
  def payroll_department
 @employees = Employee.find(:all,:conditions=>{:employee_department_id=>params[:department_id]})
    render :partial=>'department_employee'
  end
  def create_monthly_payslip
    @date = Date.today
    @new_payslip_category == []
    @salary_date = ''
    @employee = Employee.find(params[:id])
    @independent_categories = PayrollCategory.find_all_by_payroll_category_id_and_status(nil, true)
    @dependent_categories = PayrollCategory.find_all_by_status(true, :conditions=>"payroll_category_id != \'\'")
    @employee_additional_categories = IndividualPayslipCategory.find_all_by_employee_id(@employee.id, :conditions=>"include_every_month = true")
    @new_payslip_category = IndividualPayslipCategory.find_all_by_employee_id_and_salary_date(@employee.id,nil)
    @individual = IndividualPayslipCategory.find_all_by_employee_id_and_salary_date(@employee.id,Date.today)
    @user = current_user
    privilege = Privilege.find(14)
    finance_manager = privilege.users
    subject = " Payslip generated"
    body = "Payslip has been generated for "+@employee.first_name+" "+@employee.last_name+". Kindly approve this request"
    finance_manager.each do |f|
      Reminder.create(:sender=>@user.id, :recipient=>f.id, :subject=> subject,
        :body => body, :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
    end

    if request.post?
    
      salary_date = Date.parse(params[:salary_date])
      
      start_date = salary_date - ((salary_date.day - 1).days)
      end_date = start_date + 1.month
      payslip_exists = MonthlyPayslip.find_all_by_employee_id(@employee.id,
        :conditions => ["salary_date >= ? and salary_date < ?", start_date, end_date])
      if payslip_exists == []
        params[:manage_payroll].each_pair do |k, v|
          row_id = EmployeeSalaryStructure.find_by_employee_id_and_payroll_category_id(@employee, k)
          category_name = PayrollCategory.find(k).name
          unless row_id.nil?
            MonthlyPayslip.create(:salary_date=>start_date,:employee_id => params[:id],
              :payroll_category_id => k,:amount => v['amount'])
          else
            MonthlyPayslip.create(:salary_date=>start_date,:employee_id => params[:id],
              :payroll_category_id => k,:amount => v['amount'])
          end
        end
        individual_payslip_category = IndividualPayslipCategory.find_all_by_employee_id_and_salary_date(@employee.id,nil)
        individual_payslip_category.each do |c|
          IndividualPayslipCategory.update(c.id, :salary_date=>start_date)
        end
        flash[:notice] = "#{@employee.first_name} salary slip generated for #{params[:salary_date]}"
        redirect_to :controller => "employees", :action => "profile", :id=> @employee.id
      else #else for if payslip_exists == []
        individual_payslips_generated = IndividualPayslipCategory.find_all_by_employee_id_and_salary_date(@employee.id,nil)
        unless individual_payslips_generated.nil?
          individual_payslips_generated.each do|i|
            i.delete
          end
        end
        flash[:notice] = "<b>ERROR:</b>#{@employee.first_name} salary slip  already generated for #{params[:salary_date]}"
        redirect_to :controller => "employees", :action => "profile", :id=> @employee.id
      end
    end
    
  end
  
  
  def update_rejected_employee_list
    department_id = params[:department_id]
    #@employees = Employee.find_all_by_employee_department_id(department_id)
    @employees = MonthlyPayslip.find(:all, :conditions =>"is_rejected is true", :group=>'employee_id', :joins=>"INNER JOIN employees on monthly_payslips.employee_id = employees.id")
    @employees.reject!{|x| x.employee.employee_department_id != department_id.to_i}
     render  :partial => 'rejected_employee_select_list'
  end
  
  def payslip_date_select
    render :partial=>"one_click_payslip_date"
  end
  
  
  def one_click_payslip_generation

    @user = current_user
    finance_manager = find_finance_managers
    finance = SchoolConfiguration.find_by_config_value("Finance")
    subject = " Payslip generated"
    body = "Payslip has been generated for the particular month. Kindly approve this request"
    salary_date = Date.parse(params[:salary_date])
    start_date = salary_date - ((salary_date.day - 1).days)
    end_date = start_date + 1.month
    employees = Employee.find(:all)
    unless(finance_manager.nil? and finance.nil?)
      finance_manager.each do |f|
        Reminder.create(:sender=>@user.id, :recipient=>f.id, :subject=> subject,
          :body => body, :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
      end
      employees.each do|e|
        payslip_exists = MonthlyPayslip.find_all_by_employee_id(e.id,
          :conditions => ["salary_date >= ? and salary_date < ?", start_date, end_date])
        if payslip_exists == []
          salary_structure = EmployeeSalaryStructure.find_all_by_employee_id(e.id)
          unless salary_structure == []
            salary_structure.each do |ss|
              MonthlyPayslip.create(:salary_date=>start_date,
                :employee_id=>e.id,
                :payroll_category_id=>ss.payroll_category_id,
                :amount=>ss.amount,:is_approved => false,:approver => nil)
            end
          end
        end
      end
    else
      employees.each do|e|
        payslip_exists = MonthlyPayslip.find_all_by_employee_id(e.id,
          :conditions => ["salary_date >= ? and salary_date < ?", start_date, end_date])
        if payslip_exists == []
          salary_structure = EmployeeSalaryStructure.find_all_by_employee_id(e.id)
          unless salary_structure == []
            salary_structure.each do |ss|
              MonthlyPayslip.create(:salary_date=>start_date,
                :employee_id=>e.id,
                :payroll_category_id=>ss.payroll_category_id,
                :amount=>ss.amount,:is_approved => true,:approver => @user.id)
            end
          end
        end
      end
    end
    render :text => "<p>Salary slip generated for the month: #{salary_date.strftime("%B")}.<br/><b>NOTE:</b> Employees whose salary was generated manually, their salary slip was not generated by this process.</p>"
  end

  def payslip_revert_date_select
    @salary_dates = MonthlyPayslip.find(:all, :select => "distinct salary_date")
    render :partial=>"one_click_payslip_revert_date"
  end

  def one_click_payslip_revert
    unless params[:one_click_payslip][:salary_date] == ""
      salary_date = Date.parse(params[:one_click_payslip][:salary_date])
      start_date = salary_date - ((salary_date.day - 1).days)
      end_date = start_date + 1.month
      employees = Employee.find(:all)
      employees.each do|e|
        payslip_record = MonthlyPayslip.find_all_by_employee_id(e.id,
          :conditions => ["salary_date >= ? and salary_date < ?", start_date, end_date])
        payslip_record.each do |pr|
          pr.destroy
        end
        individual_payslip_record = IndividualPayslipCategory.find_all_by_employee_id(e.id,
          :conditions => ["salary_date >= ? and salary_date < ?", start_date, end_date])
        unless individual_payslip_record.nil?
          individual_payslip_record.each do|ipr|
            ipr.destroy
          end
        end
      end
      render :text=> "<p>Salary slip reverted for the month: #{salary_date.strftime("%B")}.</p>"
    else
      render :text=>"<p>Please select a month...</p>"
    end
  end

  def department_payslip
    @departments = EmployeeDepartment.find(:all, :conditions=>{:status => true}, :order=> "name ASC")
    @salary_dates = MonthlyPayslip.find(:all,:select => "distinct salary_date")
    if request.post?
      post_data = params[:payslip]
      unless post_data.blank?
        if post_data[:salary_date].present? and post_data[:department_id].present?
          @payslips = MonthlyPayslip.find_and_filter_by_department(post_data[:salary_date],post_data[:department_id])
        else
          flash[:warn_notice] = "Select Salary Date"
          redirect_to :action=>"department_payslip"
        end
      end
    end
  end
  
   def view_employee_payslip
    @monthly_payslips = MonthlyPayslip.find(:all,:conditions=>["employee_id=? AND salary_date = ?",params[:id],params[:salary_date]],:include=>:payroll_category)
    @individual_payslips =  IndividualPayslipCategory.find(:all,:conditions=>["employee_id=? AND salary_date = ?",params[:id],params[:salary_date]])
    @salary  = Employee.calculate_salary(@monthly_payslips, @individual_payslips)
  end
   def employee_individual_payslip_pdf
    @employee = Employee.find(params[:id])
    @department = EmployeeDepartment.find(@employee.employee_department_id).name
    @currency_type = SchoolConfiguration.find_by_config_key("CurrencyType").config_value
    @category = EmployeeCategory.find(@employee.employee_category_id).name
    @grade = EmployeeGrade.find(@employee.employee_grade_id).name
    @position = EmployeePosition.find(@employee.employee_position_id).name
    @salary_date = Date.parse(params[:id2])
    @monthly_payslips = MonthlyPayslip.find_all_by_salary_date(@salary_date,
      :conditions=> "employee_id =#{@employee.id}",
      :order=> "payroll_category_id ASC")

    @individual_payslip_category = IndividualPayslipCategory.find_all_by_salary_date(@salary_date,
      :conditions=>"employee_id =#{@employee.id}",
      :order=>"id ASC")
    @individual_category_non_deductionable = 0
    @individual_category_deductionable = 0
    @individual_payslip_category.each do |pc|
      unless pc.is_deduction == true
        @individual_category_non_deductionable = @individual_category_non_deductionable + pc.amount.to_i
      end
    end

    @individual_payslip_category.each do |pc|
      unless pc.is_deduction == false
        @individual_category_deductionable = @individual_category_deductionable + pc.amount.to_i
      end
    end

    @non_deductionable_amount = 0
    @deductionable_amount = 0
    @monthly_payslips.each do |mp|
      category1 = PayrollCategory.find(mp.payroll_category_id)
      unless category1.is_deduction == true
        @non_deductionable_amount = @non_deductionable_amount + mp.amount.to_i
      end
    end

    @monthly_payslips.each do |mp|
      category2 = PayrollCategory.find(mp.payroll_category_id)
      unless category2.is_deduction == false
        @deductionable_amount = @deductionable_amount + mp.amount.to_i
      end
    end

    @net_non_deductionable_amount = @individual_category_non_deductionable + @non_deductionable_amount
    @net_deductionable_amount = @individual_category_deductionable + @deductionable_amount

    @net_amount = @net_non_deductionable_amount - @net_deductionable_amount
    
    render :pdf => 'individual_payslip_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
    #    respond_to do |format|
    #      format.pdf { render :layout => false }
    #    end
  end
  
  
  def archived_employee
    @employee_department = EmployeeDepartment.find(:all)
   @employees = ArchivedEmployee.find(:all)
  end
  def archived_employee_list
    @employees =  ArchivedEmployee.find(:all,:conditions=>{:employee_department_id=>params[:department_id]})
   render :partial=>'archived_employee_list'
  end
  def archived_employee_profile
  
    @employee = ArchivedEmployee.find_by_id(params[:id])
    unless  @employee.nil?
    
      @additional_fields = AdditionalField.find(:all, :conditions=>{:status => true})
      @bank_fields = BankField.find(:all, :conditions=>{:status => true})
       @employee_salary_structure = ArchivedEmployeeSalaryStructure.find_all_by_employee_id(@employee.id)
      @reporting_manager = Employee.find(@employee.reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
    
    else
      flash[:notice] = "Sorry, Employee record not found."
        redirect_to :controller =>'sessions', :action =>'dashboard'
    end

  end


end