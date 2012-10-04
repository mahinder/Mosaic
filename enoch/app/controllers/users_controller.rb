require 'csv'
require 'spreadsheet'

class UsersController < ApplicationController
  require 'net/http'
  require 'uri'
  layout :choose_layout
  before_filter :login_required, :except => [:forgot_password, :login, :set_new_password, :reset_password]
  # before_filter :only_admin_allowed, :only => [:edit, :create, :index,  :user_change_password]
  before_filter :only_admin_allowed, :only => [:edit, :create, :index]
  before_filter :protect_user_data, :only => [:profile, :user_change_password]
  # filter_access_to :edit_privilege
   filter_access_to :all
  def choose_layout
    return 'login' if action_name == 'login' or action_name == 'set_new_password'
    return 'forgotpw' if action_name == 'forgot_password'
    return 'dashboard' if action_name == 'dashboard'
    'application'
  end

  def user_mobile_no
      @user = current_user
      @person = nil
       unless @user.nil?
            if @user.admin? || @user.employee?
              @person = @user.employee_record
              unless @person.nil?
                @first = @person.office_phone1
                @second = @person.office_phone2
                @third = @person.mobile_phone
                @fourth = @person.home_phone
                @employee = "yes"
              end
             elsif @user.student?
              @person = @user.student_record
               unless @person.nil?
                @first = @person.phone1
                @second = @person.phone2
              end
            end
        
         end
     render :partial => 'user_mobile_no'
  end
  




  def all_record
    @user = User.new
    @active_user = User.find(:all)
    @record_count = User.count(:all)
    
    response = { :active_user => @active_user, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
  end
  end

def privileges_of_any_user
  @user = current_user
end
def find_employee
   @user = Employee.all

    responses = ""

    unless @user.empty?
      @user.each do |user|
        str = '{"key": "'+user.id.to_s+'", "value": "'+user.full_name+','+ user.employee_number+'"}'
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'
   
    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    respond_to do |format|
      format.json { render :json => response}
    end

end

 def list_user
    if params[:user_type] == 'Admin'
      @users = User.find(:all, :conditions => {:admin => true}, :order => 'first_name ASC')
      render(:update) do |page|
        page.replace_html 'users', :partial=> 'users'
        page.replace_html 'employee_user', :text => ''
        page.replace_html 'student_user', :text => ''
      end
    elsif params[:user_type] == 'Employee'
      render(:update) do |page|
        hr = SchoolConfiguration.find_by_config_value("HR")
        unless hr.nil?
          page.replace_html 'employee_user', :partial=> 'employee_user'
          page.replace_html 'users', :text => ''
          page.replace_html 'student_user', :text => ''
        else
          @users = User.find_all_by_employee(1)
          page.replace_html 'users', :partial=> 'users'
          page.replace_html 'employee_user', :text => ''
          page.replace_html 'student_user', :text => ''
        end
      end
    elsif params[:user_type] == 'Student'
      render(:update) do |page|
        page.replace_html 'student_user', :partial=> 'student_user'
        page.replace_html 'users', :text => ''
        page.replace_html 'employee_user', :text => ''
      end
    elsif params[:user_type] == ''
      @users = ""
      render(:update) do |page|
        page.replace_html 'users', :partial=> 'users'
        page.replace_html 'employee_user', :text => ''
        page.replace_html 'student_user', :text => ''
      end
    end
  end

  def list_employee_user
    emp_dept = params[:dept_id]
    @employee = Employee.find_all_by_employee_department_id(emp_dept, :order =>'first_name ASC')
    @users = @employee.collect { |employee| employee.user}
    @users.delete(nil)
    render(:update) {|page| page.replace_html 'users', :partial=> 'users'}
  end

  def list_student_user
    batch = params[:batch_id]
    @student = Student.find_all_by_batch_id(batch, :conditions => { :is_active => true },:order =>'first_name ASC')
    @users = @student.collect { |student| student.user}
    @users.delete(nil)
    render(:update) {|page| page.replace_html 'users', :partial=> 'users'}
  end

  def change_password
    @user = current_user
   if request.post?
      @user = current_user
      if params[:oldpassword] == '' || params[:newpassword] =='' || params[:confirmpassword] ==''
        flash[:notice]= "Password fields cannot be blank!"
       elsif  params[:newpassword] !='' && ( params[:newpassword].gsub(/ /,'').length <=3 || params[:newpassword].gsub(/ /,'').length > 40)
        flash[:notice] = 'Password requires minimum of 4 and maximum of 40 characters.'
       else
      if User.authenticate?(@user.username, params[:oldpassword])
         if (params[:newpassword] == params[:confirmpassword])
            @user.password = params[:newpassword]
           @user.update_attributes(:password => @user.password,:role => @user.role_name)
              flash[:success] = 'Password changed successfully.'
              redirect_to :controller => 'sessions', :action => 'dashboard'
          else
            flash[:error] = 'Password confirmation failed. Please try again.'
          end
        else
          flash[:error] = 'The old password you entered is incorrect. Please enter valid password.'
        end
      end
     end 
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by_username(params[:id])
    @current_user = current_user
  # @current_user = User.find_by_username("Admin")
  end

  # POST /users
  # POST /users.json
  def create
    @school = SchoolConfiguration.available_modules
    @user = User.new(params[:user])
    if request.post?
      @school.include?('HR')
      @employee=Employee.new
      @employee.first_name = @user.first_name
      @employee.last_name = @user.last_name
      @employee.employee_number = @user.username
      @employee.email =@user.email
      @employee.employee_category_id = 1
      @employee.employee_position_id = 1
      @employee.employee_department_id = 1
      @employee.employee_grade_id = 1
      @employee.date_of_birth = Date.today - 20.year
      @employee.joining_date = Date.today - 5.year

      respond_to do |format|
        if @employee.save
          flash[:notice]= "user created successfully!"
          format.html {  redirect_to :controller=>'users', :action => 'edit', :id => @user.username, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        else
          flash[:warn_notice]= "user not created"
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        @current_user = current_user
        format.html {  redirect_to :controller=>'users', :action => 'profile', :id => @user.username, notice: 'User was successfully created.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def profile
    @school = SchoolConfiguration.available_modules
    @current_user =  current_user
    @username = @current_user.username
    
    @user = User.find_by_username(params[:id])
   
    unless @user.nil?
      @employee = Employee.find_by_employee_number(@user.username)
    #@student = Student.find_by_admission_no(@user.username)
    else
      flash[:notice] = 'User profile not found.'
      redirect_to :action => 'dashboard'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  def user_change_password
    user = User.find_by_username(params[:id])

    if request.post?
      if params[:user][:new_password]=='' and params[:user][:confirm_password]==''
        flash[:warn_notice]= "<p>Password fields cannot be blank!</p>"
      else
        if params[:user][:new_password] == params[:user][:confirm_password]
          user.password = params[:user][:new_password]
          user.update_attributes(:password => user.password,
          :role => user.role_name
          )
          flash[:notice]= "Password has been updated successfully!"
          redirect_to :action=>"edit", :id=>user.username
        else
          flash[:warn_notice] = 'Password confirmation failed. Please try again.'
        end
      end

    end
  end

  def dashboard
    @user = current_user
    @school = SchoolConfiguration.available_modules
    logger.debug "user role name is #{@user.role_name.downcase}"
    @employee = @user.employee_record if ['employee','admin'].include?(@user.role_name.downcase)
    logger.debug "employeename is #{@employee}"
    @student = @user.student_record  if @user.role_name.downcase == 'student'
    logger.debug "ustudent name is #{@ustudent}"
    @dash_news = News.find(:all, :limit => 5)
  end

  def login
   @institute = SchoolConfiguration.find_by_config_key("LogoName")
    if request.post? and params[:user]
      @user = User.new(params[:user])
      user = User.find_by_username @user.username
      if user and User.authenticate?(@user.username, @user.password)
        session[:user_id] = user.id
        flash[:notice] = "Welcome, #{user.first_name} #{user.last_name}!"
        render :json => {:valid => true, :redirect => "/users/dashboard/#{user.id}"}
        #redirect_to :controller => 'users', :action => 'dashboard', :id => user.id
      else
        render :json => {:valid => false, :error => "Invalid username or password combination"}
        #flash[:notice] = 'Invalid username or password combination'
      end
    else
      render :layout => false
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged out Successfully'
    redirect_to :controller => 'users', :action => 'login'
  end

  def forgot_password
    #    flash[:notice]="You do not have permission to access forgot password!"
    #    redirect_to :action=>"login"
    @network_state = SchoolConfiguration.find_by_config_key("NetworkState")
    if request.post? and params[:reset_password]
      if user = User.find_by_email(params[:reset_password][:email])
        user.reset_password_code = Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" )
        user.reset_password_code_until = 1.day.from_now
        user.role = user.role_name
        user.save(false)
        UserNotifier.deliver_forgot_password(user)
        flash[:notice] = "Reset Password link emailed to #{user.email}"
        redirect_to :action => "index"
      else
        flash[:notice] = "No user exists with email address #{params[:reset_password][:email]}"
      end
    end
  end

  def reset_password
    user = User.find_by_reset_password_code(params[:id])
    if user
      if user.reset_password_code_until > Time.now
        redirect_to :action => 'set_new_password', :id => user.reset_password_code
      else
        flash[:notice] = 'Reset time expired'
        redirect_to :action => 'index'
      end
    else
      flash[:notice]= 'Invalid reset link'
      redirect_to :action => 'index'
    end
  end

  def set_new_password
    if request.post?
      user = User.find_by_reset_password_code(params[:id])
      if user
        if params[:set_new_password][:new_password] === params[:set_new_password][:confirm_password]
          user.password = params[:set_new_password][:new_password]
          user.update_attributes(:password => user.password, :reset_password_code => nil, :reset_password_code_until => nil, :role => user.role_name)
          #User.update(user.id, :password => params[:set_new_password][:new_password],
          # :reset_password_code => nil, :reset_password_code_until => nil)
          flash[:notice] = 'Password succesfully reset. Use new password to log in.'
          redirect_to :action => 'index'
        else
          flash[:notice] = 'Password confirmation failed. Please enter password again.'
          redirect_to :action => 'set_new_password', :id => user.reset_password_code
        end
      else
        flash[:notice] = 'You have followed an invalid link. Please try again.'
        redirect_to :action => 'index'
      end
    end
  end

  def edit_privilege
    @privileges = Privilege.find(:all)
    @user = User.find_by_username(params[:id])
    if request.post?
      new_privileges = params[:user][:privilege_ids] if params[:user]
      new_privileges ||= []
      @user.privileges = Privilege.find_all_by_id(new_privileges)

      flash[:notice] = 'Role updated.'
      redirect_to :action => 'profile',:id => @user.username
    end
  end

  def search_user_ajax
    unless params[:query].nil? or params[:query].empty? or params[:query] == ' '
      if params[:query].length>= 3
       # @user = User.first_name_or_last_name_or_username_begins_with params[:query].split
              @user = User.find(:all,
                        :conditions => "(first_name LIKE \"#{params[:query]}%\"
                               OR username LIKE \"#{params[:query]}%\"
                               OR last_name LIKE \"#{params[:query]}%\"
                               OR (concat(first_name, \" \", last_name) LIKE \"#{params[:query]}%\"))",
                        :order => "first_name asc") unless params[:query] == ''
       # @user = @user.sort_by { |u1| [u1.role_name,u1.full_name] }
      end
    else
      @user = ''
    end
    render :layout => false
  end

def find
   @user = User.all

    responses = ""

    unless @user.empty?
      @user.each do |user|
        str = '{"key": "'+user.id.to_s+'", "value": "'+user.full_name+','+ user.username+'"}'
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'
   
    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    respond_to do |format|
      format.json { render :json => response}
    end

end

def reset
  @user = current_user
      if @user.admin?
         if params[:user].nil? 
            respond_to do |format|
              format.json { render :json => {:valid => false, :notice => "Please enter the correct user name!"}}
             end
          else
            user = User.find(params[:user])
            unless user.nil?
               chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
                newpass = ""
                1.upto(20) { |i| newpass << chars[rand(chars.size-1)] }
                
         
          @subject = "Reset password"
          @body = "Your new password is "+ newpass
             if user.update_attributes(:password => newpass, :role => user.role_name)
               UserMailer.registration_confirmation(user,@subject,@body).deliver
                respond_to do |format|
                  format.json { render :json => {:valid => true, :notice => "Password has been reset successfully. Please check mail for new password."}}
                 end
             end
              # flash[:notice] = 'Password has been reset successfully.'
              # redirect_to :controller => 'sessions', :action => 'dashboard'
            else
               respond_to do |format|
                 format.json { render :json => {:valid => false, :notice => "This User Name does not exist!"}}
                end
              # flash[:notice] = 'This User Name does not exist'
            end
          end
       
      else
         respond_to do |format|
              format.json { render :json => {:valid => false, :notice => "You are not authorized to view this page!"}}
         end
            # flash[:notice] = 'You are not authorized to view this page'
      end
    
  end
  
  

  def reset_password_of_any_user
    @user = current_user
   end
   def upload_excel
    
  
    if request.post?
      data = params[:user][:excel_file].read


    parsed_rows=CSV.parse(data)
       parsed_rows.each do |row|
         @product = Product.new
         @product.name = row[0]
         @product.price= row[1]
          if @product.save!
            flash[:notice]="Product Save Successfully"
          else
            flash[:warn_notice]=@product.errors.full_message
          end
       end
     end
end
def upload_excelsheet
  directory =  "#{Rails.root}/public/system/School_data"
   Dir.chdir(directory){|path|    
   Dir["**/*"].each do |file|
   file_path= path+'/'+file
   roll_no = 0
   Spreadsheet.client_encoding = 'UTF-8'
   book = Spreadsheet.open(file_path)
   sheet1 = book.worksheet 0
   sheet2 = book.worksheet 1
   sheet3 = book.worksheet 2
   sheet4 = book.worksheet 3
   sheet5 = book.worksheet 4
   sheet6 = book.worksheet 5
   sheet7 = book.worksheet 6
   sheet8 = book.worksheet 7
   sheet9 = book.worksheet 8
   sheet10 = book.worksheet 9
   sheet11 = book.worksheet 10
   sheet12 = book.worksheet 11
   sheet13 = book.worksheet 12
   sheet14 = book.worksheet 13
   
   
    if sheet2.name=='Employee_category'
      0.upto sheet2.last_row_index do |index|
      row = sheet2.row(index)
      if index==3 || index>3 && row[2] !=nil
       @employee_category=EmployeeCategory.new
       employee_category=EmployeeCategory.find_by_name(row[2])
       if employee_category.nil?
         @employee_category.name=row[1]
         @employee_category.prefix=row[2]
         @employee_category.status=true
               if @employee_category.save
                  flash[:success] = "Details has been imported Successfully"
                   position_save(@employee_category,row[3])
                     else
                         @errors = @employee_category.errors.full_messages 
                         @err_count = @employee_category.errors.count
                         end
       else
               position_save(employee_category,row[3])
                 
    end
      end
  end
    else if sheet2.name=='KG'
    import_skills(sheet2)
     else if sheet2.name=='topics'
       # create_topics(sheet2)
     else if sheet2.name=='employee_subject'
       # import_employee_subject(sheet2)
     end
     end
     end
     end
    #sheet 1 of spreadsheet
    if sheet1.name=='employee_list'
      0.upto sheet1.last_row_index do |index|
      row = sheet1.row(index)
        if index==3 || index>3 && row[2] !=nil
         @employee= Employee.new
         employee_category=EmployeeCategory.find_by_name(row[11])
         employee_position=EmployeePosition.find_by_name(row[12])
         @employee.employee_number=row[1]
         @employee.first_name=row[2]
         @employee.middle_name=row[3]
         @employee.last_name=row[4]
         @employee.employee_department_id=2
         @employee.employee_category_id=employee_category.id
         @employee.employee_position_id=employee_position.id
         @employee.home_address_line1=row[8]
         @employee.gender=row[5]
         @employee.joining_date=row[7]
         @employee.date_of_birth=row[6]
         @employee.nationality_id=76
         @employee.mobile_phone=row[9]
         @employee.is_teacher=false
           if @employee.save
             if employee_category.name == "Teacher"
                teacher_privilege = Privilege.find_by_name('Teacher')
                student_profile= Privilege.find_by_name('StudentProfile')
                student_attendance= Privilege.find_by_name('StudentAttendanceView')
                student_attendance_register= Privilege.find_by_name('StudentAttendanceRegister')
                @user = User.find_by_username(@employee.employee_number)
                @user.privileges << teacher_privilege
                @user.privileges << student_profile
                @user.privileges << student_attendance
                @user.privileges << student_attendance_register
                @employee.update_attributes(:is_teacher=>true)
             end
             flash[:success] = "Details has been imported Successfully"
           else
                 @errors = @employee_category.errors.full_messages 
                           @err_count = @employee_category.errors.count
           end
        end
      end
     else if sheet1.name=='Nursery'
         import_skills(sheet1)
         else if sheet1.name=='weekday'
          import_weekday(sheet1)
         else if sheet1.name=='subject_batch'
          import_subject_batch(sheet1)
         else if sheet1.name=='timetable_entries'
          import_timetable(sheet1)
         else if sheet1.name=='class_timing'
           import_class_timing(sheet1) 
           else if sheet1.name=='events'
           import_events(sheet1) 
            else if sheet1.name=='batch_events'
           import_batch_events(sheet1) 

    else
      0.upto sheet1.last_row_index do |index|
      row = sheet1.row(index)
   if index==3 || index>3 && row[2] !=nil
          @student = Student.new
          @student.admission_no=row[1]
           @student.first_name=row[2]
          @student.middle_name=row[3]
          @student.last_name=row[4]
          @student.gender=row[5]
          @student.date_of_birth=row[7]
          @student.batch_id=row[6]
          @student.address_line1=row[10]
          @student.city=row[11]
          @student.phone1=row[12]
          @student.phone2=row[13]
          @student.admission_date=row[14]
          @student.nationality_id=76
           last_student = Student.find(:last,:conditions=>{:batch_id=>row[6]})
           if last_student.nil?
           roll_no = 1
         else
           roll_no =last_student.class_roll_no.next
         end
          @student.class_roll_no = roll_no
              if @student.save
                flash[:success] = "Details has been imported Successfully"
                else
                  @errors = @student.errors.full_messages
                  @err_count = @student.errors.count
                 end
             end 
           end
         end
        end
      end
      end
      end
    end
    end
 end
     if sheet3.name=='First'
               import_skills(sheet3)
          else if sheet3.name=='employee_skills'
            import_employee_skills(sheet3)
          end
     end
     if sheet4.name=='Second'
                     import_skills(sheet4)
     end
     if sheet5.name=='Third'
                import_skills(sheet5)
     end
     if sheet6.name=='Fourth'
            import_skills(sheet6)
     end
    if sheet7.name=='Fifth'     
           import_skills(sheet7)   
    end
    if sheet8.name=='Sixth'
        import_skills(sheet8)
    end
    if sheet9.name=='Seventh'
       import_skills(sheet9)        
    end
    if sheet10.name=='Eighth'
      import_skills(sheet10)
    end
    if sheet11.name=='Nineth'
      import_skills(sheet11)
    end
    if sheet12.name=='Tenth'
      import_skills(sheet12)
    end
    if sheet13.name=='Eleventh'
      import_skills(sheet13)
    end
    if sheet14.name=='Twelth'
      import_skills(sheet14)
    end
     end
    }
  end
  def import_skills(sheet)
       0.upto sheet.last_row_index do |index|
              row = sheet.row(index)
              if index==3 || index>3 && row[2] !=nil
                 course=Course.find_by_course_name(row[4])
                @skill=Skill.new
               skill=Skill.find_by_name_and_course_id(row[1],course.id)
              
               if skill.nil?
                 @skill.name=row[1]
                  @skill.full_name="#{row[4]}-#{row[1]}"
                 @skill.max_weekly_classes=5
                 @skill.code=row[3]
                 @skill.no_exam=row[5]
                unless course.nil?
                 @skill.course_id=course.id
               end
                         if @skill.save
                          flash[:success] = "Details has been imported Successfully"
                           subskill_save(@skill,row[2])
                             else
                                 @errors = @skill.errors.full_messages 
                                 @err_count = @skill.errors.count
                                 end
               else
                        subskill_save(skill,row[2])
                         
            end
              end
          end
  end
  
  def position_save(employee_category,name)
    @employee_position=EmployeePosition.new
                 @employee_position.name=name
                 @employee_position.employee_category_id=employee_category.id
                 @employee_position.status=true
                   if @employee_position.save
                flash[:notice] = "Details has been imported Successfully"
               else
                   @errors = @employee_position.errors.full_messages 
         @err_count = @employee_position.errors.count
               end
  end
  
    def subskill_save(skill,subskill)
    @subskill=SubSkill.new
                 @subskill.name=subskill
                 @subskill.skill_id=skill.id
                 if @subskill.save
                flash[:notice] = "Details has been imported Successfully"
               else
                   @errors = @subskill.errors.full_messages 
                   @err_count = @subskill.errors.count
                   @ba=@subskill.skill_id,@subskill.name
               end
  end
  
  
  
  def import_class_timing(sheet)
            0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
               @class_timing=ClassTiming.new
               @class_timing.batch_id=row[1]
               @class_timing.name=row[2]
               @class_timing.start_time=row[3]
               @class_timing.end_time=row[4]
               @class_timing.is_break=row[5]
                       if @class_timing.save
                        flash[:success] = "Details has been imported Successfully"
                           else
                               @errors = @class_timing.errors.full_messages 
                               @err_count = @class_timing.errors.count
                                                           end
                        end
                    end
     end
     
     
     def import_employee_skills(sheet)
     0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
             @employee=Employee.find_by_id(row[1])
              @skill=Skill.find_by_id(row[2])
                 unless @employee.nil? ||  @skill.nil?
                   @employee.skills << @skill
                end
              end
       end
       
     end
     def import_weekday(sheet)
       0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
              @weekday=Weekday.new
              @weekday.batch_id=row[1]
              @weekday.weekday=row[2]
                    if @weekday.save
                        flash[:success] = "Details has been imported Successfully"
                         else
                         @errors = @weekday.errors.full_messages 
                         @err_count = @weekday.errors.count
                      end
            
              end
       end
       
     end
     
     def import_subject_batch(sheet)
       0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
              @subject=Subject.new
              @subject.name=row[1]
              @subject.code=row[2]
              @subject.batch_id=row[3]
              @subject.no_exams=row[4]
              @subject.max_weekly_classes=row[5]
              @subject.is_deleted=row[7]
              @subject.skill_id=row[8]
              @subject.is_common=row[9]
              if @subject.save
                create_topics(@subject,row[8])
               flash[:success] = "Details has been imported Successfully"  
              else
                  @errors = @subject.errors.full_messages 
                  @err_count = @subject.errors.count
              end
            end
       end
     end
     
     
     def create_topics(subject,skill)
       @skill=Skill.find_by_id(skill)
       unless @skill.nil?
         subskill=SubSkill.find_all_by_skill_id(@skill.id)
         unless subskill.empty?
           subskill.each do |subskill|
             @topic=Topic.new
             @topic.name=subskill.name
             @topic.subject_id=subject.id
             @topic.is_active=true
             if @topic.save
               flash[:success] = "Details has been imported Successfully"  
             else
                @errors = @topic.errors.full_messages 
                  @err_count = @topic.errors.count
             end
           end
         end
         
       end
     end
      def import_timetable(sheet)
             0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
             @timetable=TimetableEntry.new
             @timetable.batch_id=row[1]
             @timetable.weekday_id=row[2]
             @timetable.class_timing_id=row[3]
              @timetable.employee_id=row[5]
               @timetable.subject_id=row[4]
              if @timetable.save
                flash[:success] = "Details has been imported Successfully"
              @batch = Batch.find_by_id(row[1])
              unless @batch.nil?
                @batch.update_attributes(:is_timetable_created=>true)
              end
                 
              else
                  @errors = @timetable.errors.full_messages 
                  @err_count = @timetable.errors.count
              end
            end
       end
     end
     
     
     def import_employee_subject(sheet)
     0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
             @employee=Employee.find_by_id(row[1])
             @subject=Subject.find_by_id(row[2])
             unless @employee.nil? 
             @employee.subjects<<@subject
             end
            end
       end
     end
     def import_events(sheet)
        0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
             @event=Event.new
             @event.title=row[1]
             @event.description=row[2]
             @event.start_date=row[3]
             @event.end_date=row[4]
             @event.is_common=row[5]
             @event.is_holiday=row[6]
             @event.is_exam=row[7]
             @event.is_due=row[8]
             if @event.save
                flash[:success] = "Details has been imported Successfully"
              else
                @errors = @event.errors.full_messages 
                  @err_count = @event.errors.count
             end
            end
       end
     end
     def import_batch_events(sheet)
        0.upto sheet.last_row_index do |index|
            row = sheet.row(index)
            if index==3 || index>3 && row[2] !=nil
            @batch_event=BatchEvent.new
            @batch_event.event_id=row[1]
            @batch_event.batch_id=row[2]
            
            if @batch_event.save
                flash[:success] = "Details has been imported Successfully"
              else
                @errors = @batch_event.errors.full_messages 
                  @err_count = @batch_event.errors.count
            end
            end
       end
       
     end
     

  
    def example_report
          book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    5.times {|j| 5.times {|i| sheet[j,i] = (i+1)*10**j}}
    
    # column
    sheet.column(2).hidden = true
    sheet.column(3).hidden = true
    sheet.column(2).outline_level = 1
    sheet.column(3).outline_level = 1
    
    # row
    sheet.row(2).hidden = true
    sheet.row(3).hidden = true
    sheet.row(2).outline_level = 1
    sheet.row(3).outline_level = 1
    puts "the book is#{book}"
    # save file
    book.write 'out.xls'
    
          
  end
   def download_help
        if File.exist?("#{Rails.root}/public/system/Enoch_Help/Documentation.doc")  
          send_file  "#{Rails.root}/public/system/Enoch_Help/Documentation.doc", :type => 'application/doc'
        else
          flash[:notice] = t(:file_not_exist)
          redirect_to :controller => "sessions", :action => "dashboard"  
        end
    end
end