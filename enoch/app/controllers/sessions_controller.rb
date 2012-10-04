class SessionsController < ApplicationController
  filter_access_to :dashboard_settings
  
  before_filter :login_required, :only => [:show, :dashboard,:dashboard_settings]
  
  def new
    render :layout => false
  end

  def create
    user_name = params[:session][:username]
    password = params[:session][:password]
    remember_me = params[:session][:remember]
    user = User.authenticate? user_name, password
    if user.nil?
      render :json => {:valid => false, :error => "Invalid username or password combination"}
    elsif user.timetable?
      if !params[:session][:query].nil? && params[:session][:query] == "outside"
        sign_in user
        flash[:success] = "Welcome, #{user.first_name} #{user.last_name}!"
        redirect_back_or_home user
      else
        render :json => {:valid => false, :error => "You are not Allowed to login"}
      end
    else
      sign_in user
      flash[:success] = "Welcome, #{user.first_name} #{user.last_name}!"
      redirect_back_or_home user
    #render :json => {:valid => true, :redirect => dashboard_path(@user)}
    end
  end

  # def show
  # @user = current_user
  # @school = SchoolConfiguration.available_modules
  # logger.info "user role name is #{@user.role_name.downcase}"
  # @employee = @user.employee_record if ['employee','admin'].include?(@user.role_name.downcase)
  # logger.debug "employeename is #{@employee}"
  # @student = @user.student_record  if @user.role_name.downcase == 'student'
  # logger.debug "ustudent name is #{@ustudent}"
  # @dash_news = News.find(:all, :limisessions/hr_settingst => 5)
  # end

  def destroy
    session[:user_id] = nil
    session[:employee_params] = nil;
    session[:employee_step] = nil;
    flash[:notice] = 'Logged out Successfully'
    redirect_to signin_path
  end

  def get_my_batch_birth_day_list
        @user = current_user
        @student_with_dob = Student.find_all_by_batch_id(params[:id], :conditions => ["Dayofmonth(date_of_birth) = Dayofmonth(curdate()) and month(date_of_birth) = month(curdate())"])
    respond_to do |format|
        format.html { render :layout => false }
       format.json { render :json => {:valid => true, :admission => "true"}}
    end
  end

  def dashboard
    @user_privileges =[]
    @my_teachers = []
    @user = current_user
    unless @user.nil?
      if @user.student
        @std = @user.student_record
        unless @std.nil?
          @subjects = Subject.find_all_by_batch_id(@std.batch_id,:conditions=>{:is_deleted =>false})
          unless @subjects.nil?
            @subjects.each do |sub|
              @my_teachers_entry = TimetableEntry.find_all_by_batch_id_and_subject_id(@std.batch_id,sub.id)
                 unless @my_teachers_entry.nil?
                    @my_teachers_entry.each do |emp|
                      unless emp.employee.nil?
                        unless emp.employee.skills.empty?
                          @my_teachers << emp.employee unless @my_teachers.include? emp.employee
                        end
                      end
                    end
                 end
            end
          end
        end
      end
    end
    if @user.employee
      @batch_with_student_dob = batch_with_student_dob_today
    end
    @school = SchoolConfiguration.available_modules
    logger.info "user role name is #{@user.role_name.downcase}"
    @employee = @user.employee_record if ['employee','admin'].include?(@user.role_name.downcase)
    logger.debug "employeename is #{@employee}"
    @student = @user.student_record  if @user.role_name.downcase == 'student'
    logger.debug "student name is #{@student}"
    @dash_news = News.find(:all, :limit => 5)
    @config = SchoolConfiguration.find_by_config_key("SmsEnabled")
    if @config.nil? || @config.config_value == "0"
    @sms_enabled = false
    else
    @sms_enabled = true
    end
    @privileges = @user.privileges
    unless @privileges.empty?
      @privileges.each do |prev|
        @user_privileges << prev.id
      end
    end
  end

  def batch_with_student_dob_today
    @user = current_user
    @student_details = []
    hashMap = Hash.new
    @employee = @user.employee_record if ['employee','admin'].include?(@user.role_name.downcase)
    if @user.employee_record.is_teacher?
    @batches = employee_batches(@employee)
     @batches.each do|batch|
        @student_with_dob = Student.find_all_by_batch_id(batch, :conditions => ["Dayofmonth(date_of_birth) = Dayofmonth(curdate()) and month(date_of_birth) = month(curdate())"])
        if !@student_with_dob.empty?
        hashMap = {batch => @student_with_dob}
        @student_details << hashMap
        end
      end
    end
    return @student_details
  end
  
  
  def dashboard_settings
    @user_privileges =[]
    @user = current_user
    @school = SchoolConfiguration.available_modules
    logger.info "user role name is #{@user.role_name.downcase}"
    @employee = @user.employee_record if ['employee','admin'].include?(@user.role_name.downcase)
    logger.debug "employeename is #{@employee}"
    @student = @user.student_record  if @user.role_name.downcase == 'student'
    logger.debug "ustudent name is #{@ustudent}"
    @dash_news = News.find(:all, :limit => 5)
    @config = SchoolConfiguration.find_by_config_key("SmsEnabled")
    if @config.nil? || @config.config_value == "0"
    @sms_enabled = false
    else
    @sms_enabled = true
    end
    @privileges = @user.privileges
    unless @privileges.empty?
      @privileges.each do |prev|
        @user_privileges << prev.id
      end
    end
  end

  def demo_student

  end

  def demo_teacher
  end

  def demo_attendance

  end

  def demo_timetable

  end

  def demo_timetable_day

  end

  def demo_form

  end

  def demo_calendar

  end

  def hr_settings
    @user = current_user
  end

  def configurations
    @user = current_user
  end
end
