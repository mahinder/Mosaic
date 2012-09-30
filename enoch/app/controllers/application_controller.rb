class ApplicationController < ActionController::Base
  include SessionsHelper
  include ExamsHelper
  helper :all
  protect_from_forgery # :secret => '434571160a81b5595319c859d32060c1'
  #filter_parameter_logging :password

  before_filter { |controller| Authorization.current_user = controller.current_user }
  before_filter :message_user
  #before_filter :set_user_language

 def sms_security
   @sms_enabled = SchoolConfiguration.find_by_config_key("SmsEnabled").config_value
   if @sms_enabled == "0"
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller => 'sessions', :action => 'dashboard'
   else
      @allow_access = true
   end
 end
 
 
  def redirect_to_back(default = root_url)
    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end

 
 
  def only_assigned_employee_allowed
    
    if @current_user.employee?
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.skill_id}
      privilege = @current_user.privileges.map{|p| p.id}
      if @employee_subjects.empty? and !privilege.include?(8) and !privilege.include?(16)
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller => 'sessions', :action => 'dashboard'
      else
      @allow_access = true
      end
    end
  end
 def protect_edit_employee
 
  
  if current_user.employee?
        employee = current_user.employee_record

           pri = Privilege.find(:all,:select => "privilege_id",:conditions=> 'privileges_users.user_id = ' + current_user.id.to_s, :joins =>'INNER JOIN `privileges_users` ON `privileges`.id = `privileges_users`.privilege_id' )
           privilege =[]
           pri.each do |p|
             privilege.push p.privilege_id
           end

         
        unless params[:q].to_i == employee.id || privilege.include?(Privilege.find_by_name('HrBasics').id)
          flash[:notice] = t(:notice_access_denied)
        redirect_to :controller=>"sessions", :action=>"dashboard"
        end
      end
 end
def employee_batches(user)
    @batch = []
        @timetable_entry = TimetableEntry.find(:all , :conditions => {:employee_id => user.id} ,:order => 'batch_id asc')
        unless @timetable_entry.empty?
          @timetable_entry.each do |time|
            @batch << time.batch unless @batch.include? time.batch
          end
        end
       return @batch
  end


  def restrict_employees_from_exam
   
    if @current_user.employee?
      @employee_subjects = @current_user.employee_record.subjects.map { |n| n.skill_id}
      if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.id}.include?(Privilege.find_by_name('ExaminationControl').id) and !@current_user.privileges.map{|p| p.id}.include?(Privilege.find_by_name('EnterResults').id) and !@current_user.privileges.map{|p| p.id}.include?('ViewResults')
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller => 'sessions', :action => 'dashboard'
      else
      @allow_for_exams = true
      end
    end
  end

  def block_unauthorised_entry
    
    if @current_user.employee?
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.subject_id}
      if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.id}.include?(1)
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller => 'sessions', :action => 'dashboard'
      else
      @allow_for_exams = true
      end
    end
  end

  def message_user
    @current_user = current_user
  end

  def current_user
    
    User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def current_session
    
    SchoolSession.find_by_current_session(true)
  end


  def find_finance_managers
    Privilege.find_by_name('FinanceControl').users
  end

  def permission_denied
    puts "Permission Denied"

    flash[:notice] = t(:notice_access_denied)
    redirect_to :controller => 'sessions', :action => 'dashboard'
  end

  protected

    def login_required
      if request.xhr? == 0 
        begin
          raise ActionController::RoutingError.new('Forbidden') unless session[:user_id]
        rescue ActionController::RoutingError => e
          respond_to do |format| 
            format.js { render :text => e.message, :status => 403 }
          end
        end
      else
        redirect_to signin_path unless session[:user_id]
      end 
    end
  
    def configuration_settings_for_hr
      hr = SchoolConfiguration.find_by_config_value("HR")
      if hr.nil?
      redirect_to :controller => 'sessions', :action => 'dashboard'
      flash[:notice] = t(:notice_access_denied)
      end
    end
    def configuration_settings_for_finance
    finance = SchoolConfiguration.find_by_config_value("Finance")
    if finance.nil?
      redirect_to :controller => 'user', :action => 'dashboard'
      flash[:notice] = t(:notice_access_denied)
    end
  end
  
    def only_admin_allowed
      puts "Only Admin Allowed!!"
      redirect_to :controller => 'sessions', :action => 'dashboard' unless current_user.admin?
    end
   def protect_other_student_data
    if current_user.student?
      student = current_user.student_record
      unless params[:q].to_s == student.admission_no 
        flash[:notice] = t(:notice_access_denied)
        redirect_to :controller=>"sessions", :action=>"dashboard"
      end
    end
  end
   def protect_other_student_id
    if current_user.student?
      student = current_user.student_record
      unless params[:student_id].to_s == student.id.to_s 
        flash[:notice] = t(:notice_access_denied)
        redirect_to :controller=>"sessions", :action=>"dashboard"
      end
    end
  end
    def protect_user_data
      unless current_user.admin?
        unless params[:id].to_s == current_user.username
        flash[:notice] = t(:notice_access_denied)
        redirect_to :controller=>"sessions", :action=>"dashboard"
        end
      end
    end
  
    def protect_other_employee_data
     
      if current_user.employee?
        employee = current_user.employee_record
        
           pri = Privilege.find(:all,:select => "privilege_id",:conditions=> 'privileges_users.user_id = ' + current_user.id.to_s, :joins =>'INNER JOIN `privileges_users` ON `privileges`.id = `privileges_users`.privilege_id' )
           privilege =[]
           pri.each do |p|
             privilege.push p.privilege_id
           end
            
            
        unless params[:id].to_i == employee.id || privilege.include?(Privilege.find_by_name('SmsTemplateCreation').id) || privilege.include?(Privilege.find_by_name('EmployeeBasicSearch').id) || privilege.include?(Privilege.find_by_name('HrBasics').id) || privilege.include?(Privilege.find_by_name('EmployeeProfile').id) || privilege.include?(Privilege.find_by_name('AssignPrivilege').id)
  
        flash[:notice] = t(:notice_access_denied)
        redirect_to :controller=>"sessions", :action=>"dashboard"
        end
      end
    end
  
    def protect_leave_history
      if current_user.employee?
        employee = Employee.find(params[:id])
        employee_user = employee.user
        unless employee_user.id == current_user.id
          unless current_user.role_symbols.include?(:hr_basics) or current_user.role_symbols.include?(:employee_attendance)
          flash[:notice] = t(:notice_access_denied)
          redirect_to :controller=>"sessions", :action=>"dashboard"
          end
        end
      end
    end
    #  end
  
    #reminder filters
    def protect_view_reminders
      puts(params)
      # reminder = Reminder.find(params[:id2])
      reminder = ReminderRecipient.find(params[:reminder_id])
      unless reminder.recipient == current_user.id
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller=>"reminder", :action=>"index"
      end
    end
  
    def protect_sent_reminders
      reminder = Reminder.find(params[:id2])
      unless reminder.sender == current_user.id
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller=>"reminder", :action=>"index"
      end
    end
  
    def protect_leave_dashboard
      employee = Employee.find(params[:id])
      employee_user = employee.user
      #    unless permitted_to? :employee_attendance_pdf, :employee_attendance
      unless employee_user.id == current_user.id
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller=>"sessions", :action=>"dashboard"
      #    end
      end
    end
  
    def protect_applied_leave
      applied_leave = ApplyLeave.find(params[:id])
      applied_employee = applied_leave.employee
      applied_employee_user = applied_employee.user
      unless applied_employee_user.id == current_user.id
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller=>"sessions", :action=>"dashboard"
      end
    end
  
    def protect_manager_leave_application_view
      applied_leave = ApplyLeave.find(params[:id])
      applied_employee = applied_leave.employee
      applied_employees_manager = Employee.find(applied_employee.reporting_manager_id)
      applied_employees_manager_user = applied_employees_manager.user
      unless applied_employees_manager_user.id == current_user.id
      flash[:notice] = t(:notice_access_denied)
      redirect_to :controller=>"sessions", :action=>"dashboard"
      end
    end

#   private
#    def set_user_language
#      #I18n.locale = 'es'
#    end
end