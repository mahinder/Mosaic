class ReminderController < ApplicationController
  require 'net/http'
  require 'uri'
  before_filter :login_required
  before_filter :protect_view_reminders, :only=>[:view_reminder,:mark_unread,:delete_reminder_by_recipient]
  before_filter :protect_sent_reminders, :only=>[:view_sent_reminder,:delete_reminder_by_sender]

  def index
    @user = current_user
    @reminders = ReminderRecipient.find_all_by_recipient(@user.id, :conditions => "is_deleted_by_recipient = 'f'", :order=>"created_at DESC")
    @read_reminders = ReminderRecipient.find_all_by_recipient(@user.id, :conditions=>"is_read = 't' and is_deleted_by_recipient = 'f'", :order=>"created_at DESC")
    @new_reminder_count = ReminderRecipient.find_all_by_recipient(@user.id, :conditions=>"is_read = 'f' and is_deleted_by_recipient = 'f'")
  end

  def sms
    url = URI.parse("http://www.smsgatewaycenter.com/library/send_sms_2.php")
    req = Net::HTTP::Get.new(url.path)
    req.set_form_data({'UserName'=>'ezzie', 'Password'=>'09890989','Type'=>'Individual', 'To'=>'9050736988', 'Mask'=>'DEMOSGC', 'Message'=>'Message'}, ';')
    res = Net::HTTP.new(url.host, url.port).start do |http|
      http.request(req)
    end

  end

  def empsending

    @subject = params[:subject]
    @body = params[:body]
    str = ""
    @courses_count = (Course.active.count unless Course.active.empty?)|| 0
    @user = current_user

    unless params[:courses].nil? || params[:courses].empty?

      if @courses_count > 0 && @courses_count == params[:courses].count
        if str == ""
          str = str + "All Courses"
        else
          str = str+","+ "All Courses"
        end
      else
        params[:courses].each do |course|
          @course = Course.find(course)
          if str == ""
          str = str +  @course.course_name
          else
            str = str+","+ @course.course_name
          end
        end
      end

    end

    unless params[:send_to].nil? || params[:send_to].empty?
      params[:send_to].each do |send|
        if str == ""
        str = str+send
        else
          str = str+","+ send
        end
      end
    end
    
     unless params[:students].nil? || params[:students].empty?
      params[:students].each do |std|
        student = Student.find_by_id(std)
        unless student.nil?
          if str == ""
          str = str+student.full_name
          else
            str = str+","+ student.full_name
          end
        end
      end
    end
    puts str
    @reminder = Reminder.new(:sender => @user.id,:sent_to => str,:body => @body,:subject => @subject)
    if @reminder.save

      unless params[:courses].nil? || params[:courses].empty?
        params[:courses].each do |course|
          @course = Course.find(course)
          @batches = @course.batches
          unless @batches.empty?
            @batches.each do |batch|
              @students = batch.students
              unless @students.empty?
                @students.each do |student|
                  @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => student.user.id)
                  if @reminder_receive.save && params[:send_email] == "true"
                    UserMailer.registration_confirmation(student.user,@subject,@body).deliver
                  end
                end
              end
            end
          end

        end
      end
      unless params[:send_to_id].nil? || params[:send_to_id].empty?
        params[:send_to_id].each do |sen|
          @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => sen)
          if @reminder_receive.save && params[:send_email] == "true"
            @reciver = User.find_by_id(sen)
            UserMailer.registration_confirmation(@reciver,@subject,@body).deliver
          end
        end
      end
      
      
      unless params[:students].nil? || params[:students].empty?
        params[:students].each do |stdn|
          student = Student.find_by_id(stdn)

          unless stdn.nil?
            @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => student.user.id)
            if @reminder_receive.save && params[:send_email] == "true"

              UserMailer.registration_confirmation(student.user,@subject,@body).deliver
            # UserMailer.registration_confirmation("puja@ezzie.in", "test subject", "test body").deliver
            end
          end
        end
      end
      
      
      respond_to do |format|
        format.json { render :json => {:valid => true,:notice => "message sent successfully to "+str}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false, :errors => @reminder.errors}}
      end
    end

  end

  def adminsending
    puts params
    @subject = params[:subject]
    @body = params[:body]
    str = ""
    @departments_count = (EmployeeDepartment.active.count unless EmployeeDepartment.active.empty?)|| 0
    @courses_count = (Course.active.count unless Course.active.empty?)|| 0
    @user = current_user
    unless params[:departments].nil? || params[:departments].empty?
      if @departments_count > 0 && @departments_count == params[:departments].count
        if str == ""
          str = str + "All Department"
        else
          str = str+","+ "All Department"
        end
      else
        params[:departments].each do |dep|
          @department = EmployeeDepartment.find(dep)
          if str == ""
          str = str +  @department.name
          else
            str = str+","+ @department.name
          end
        end
      end
    end
    unless params[:courses].nil? || params[:courses].empty?

      if @courses_count > 0 && @courses_count == params[:courses].count
        if str == ""
          str = str + "All Courses"
        else
          str = str+","+ "All Courses"
        end
      else
        params[:courses].each do |course|
          @course = Course.find(course)
          if str == ""
          str = str +  @course.course_name
          else
            str = str+","+ @course.course_name
          end
        end
      end

    end

    unless params[:send_to].nil? || params[:send_to].empty?
      params[:send_to].each do |send|
        if str == ""
        str = str+send
        else
          str = str+","+ send
        end
      end
    end

    unless params[:students].nil? || params[:students].empty?
      params[:students].each do |std|
        student = Student.find_by_id(std)
        unless student.nil?
          if str == ""
          str = str+student.full_name
          else
            str = str+","+ student.full_name
          end
        end
      end
    end

    puts str
    @reminder = Reminder.new(:sender => @user.id,:sent_to => str,:body => @body,:subject => @subject)
    if @reminder.save
      unless params[:departments].nil? || params[:departments].empty?
        params[:departments].each do |dep|
          @department = EmployeeDepartment.find(dep)
          @employee = @department.employees
          unless @employee.empty?
            @employee.each do |emp|
              @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => emp.user.id)
              if @reminder_receive.save && params[:send_email] == "true"
                UserMailer.registration_confirmation(emp.user,@subject,@body).deliver
              # UserMailer.registration_confirmation("puja@ezzie.in", "test subject", "test body").deliver
              end
            end
          end
        end
      end
      unless params[:courses].nil? || params[:courses].empty?
        params[:courses].each do |course|
          @course = Course.find(course)
          @batches = @course.batches
          unless @batches.empty?
            @batches.each do |batch|
              @students = batch.students
              unless @students.empty?
                @students.each do |student|

                  @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => student.user.id)
                  if @reminder_receive.save && params[:send_email] == "true"
                    UserMailer.registration_confirmation(student.user,@subject,@body).deliver
                  # UserMailer.registration_confirmation("puja@ezzie.in", "test subject", "test body").deliver
                  end
                end
              end
            end
          end

        end
      end
      unless params[:send_to_id].nil? || params[:send_to_id].empty?
        params[:send_to_id].each do |sen|
          @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => sen)
          if @reminder_receive.save && params[:send_email] == "true"
            @reciver = User.find_by_id(sen)
            UserMailer.registration_confirmation(@reciver,@subject,@body).deliver
          # UserMailer.registration_confirmation("puja@ezzie.in", "test subject", "test body").deliver
          end
        end
      end

      unless params[:students].nil? || params[:students].empty?
        params[:students].each do |stdn|
          student = Student.find_by_id(stdn)

          unless stdn.nil?
            @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => student.user.id)
            if @reminder_receive.save && params[:send_email] == "true"

              UserMailer.registration_confirmation(student.user,@subject,@body).deliver
            # UserMailer.registration_confirmation("puja@ezzie.in", "test subject", "test body").deliver
            end
          end
        end
      end

      respond_to do |format|
        format.json { render :json => {:valid => true,:notice => "message sent successfully to "+str}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false, :errors => @reminder.errors}}
      end
    end

  end

  def sending
    str = ""
    @user = current_user
    @send_to =  params[:send_to]
    @subject = params[:subject]
    @body = params[:body]
    unless @send_to.empty?
      @send_to.each do |send|
        if str == ""
        str = str+send
        else
          str = str+","+ send
        end
      end

    end
    @reminder = Reminder.new(:sender => @user.id,:sent_to => str,:body => @body,:subject => @subject)
    if @reminder.save
      unless params[:send_to_id].empty?
        params[:send_to_id].each do |sen|
          @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => sen)
          if @reminder_receive.save && params[:send_email] == "true"
            @reciver = User.find_by_id(sen)
            UserMailer.registration_confirmation(@reciver,@subject,@body).deliver
          end
        end
      end
      respond_to do |format|
        format.json { render :json => {:valid => true,:notice => "message sent successfully to "+str}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false, :errors => @reminder.errors}}
      end
    end

  end

  def find
    puts params
    @user = User.all

    responses = ""

    unless @user.empty?
      @user.each do |user|
        str = '{"key": "'+user.id.to_s+'", "value": "'+user.first_name+' '+user.last_name+','+ user.username+'"}'
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'
    puts response
    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    respond_to do |format|
      format.json { render :json => response}
    end

  end

  def create_reminder
    @user = current_user
    @role = @user.role_name
    puts @role
    @reminder = Reminder.new
  # @departments = EmployeeDepartment.find(:all)
  # @new_reminder_count = ReminderRecipient.find_all_by_recipient(@user.id, :conditions=>"is_read = 'f'")
  #

  # unless params[:send_to].nil?
  # recipients_array = params[:send_to].split(",").collect{ |s| s.to_i }
  # @recipients = User.find(recipients_array)
  # end
  # if request.post?
  # unless params[:reminder][:body] == "" or params[:recipients] == ""
  # recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
  # recipients_array.each do |r|
  # user = User.find(r)
  # Reminder.create(:sender => @user.id, :recipient => user.id, :subject=>params[:reminder][:subject],
  # :body=>params[:reminder][:body], :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
  # end
  # flash[:notice] = "Message sent successfully"
  # redirect_to :controller=>"reminder", :action=>"create_reminder"
  # else
  # flash[:notice]="<b>ERROR:</b>Please fill the required fields to create this message"
  # redirect_to :controller=>"reminder", :action=>"create_reminder"
  # end
  # end
  end

  def select_employee_department
    @user = current_user
    @departments = EmployeeDepartment.find(:all, :conditions=>"status = true")
    render :partial=>"select_employee_department"
  end

  def select_users
    @user = current_user
    users = User.find(:all, :conditions=>"student = false")
    @to_users = users.map { |s| s.id unless s.nil? }
    render :partial=>"to_users", :object => @to_users
  end

  def select_student_course
    @user = current_user
    @batches = Batch.active
    render :partial=> "select_student_course"
  end

  def to_employees
    if params[:dept_id] == ""
      render :update do |page|
        page.replace_html "to_employees", :text => ""
      end
    return
    end
    department = EmployeeDepartment.find(params[:dept_id])
    employees = department.employees
    @to_users = employees.map { |s| s.user.id unless s.user.nil? }
    @to_users.delete nil
    render :update do |page|
      page.replace_html 'to_users', :partial => 'to_users', :object => @to_users
    end
  end

  def to_students
    if params[:batch_id] == ""
      render :update do |page|
        page.replace_html "to_user", :text => ""
      end
    return
    end

    batch = Batch.find(params[:batch_id])
    students = batch.students
    @to_users = students.map { |s| s.user.id unless s.user.nil? }
    @to_users.delete nil
    render :update do |page|
      page.replace_html 'to_users2', :partial => 'to_users', :object => @to_users
    end
  end

  def update_recipient_list
    if params[:recipients]
      recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
      @recipients = User.find(recipients_array)
      render :update do |page|
        page.replace_html 'recipient-list', :partial => 'recipient_list'
      end
    else
      redirect_to :controller=>:user,:action=>:dashboard
    end
  end

  def sent_reminder
    @user = current_user
    @sent_reminders = Reminder.find_all_by_sender(@user.id, :conditions => "is_deleted_by_sender = 'f'", :order => "created_at DESC")
    @new_reminder_count = ReminderRecipient.find_all_by_recipient(@user.id, :conditions=>"is_read = 'f'")
  end

  def view_sent_reminder
    @sent_reminder = Reminder.find(params[:id2])
  end

  def delete_reminder_by_sender
    @sent_reminder = Reminder.find(params[:id2])
    Reminder.update(@sent_reminder.id, :is_deleted_by_sender => true)
    flash[:notice] = "Reminder deleted."
    redirect_to :action =>"sent_reminder"
  end

  def delete_reminder_by_recipient
    user = current_user
    employee = user.employee_record
    @reminder = ReminderRecipient.find(params[:reminder_id ])
    ReminderRecipient.update(@reminder.id, :is_deleted_by_recipient => true)
    flash[:notice] = "Reminder deleted."
    redirect_to :action =>"index"
  end

  def view_reminder
    user = current_user
    @new_reminder = Reminder.find(params[:id2])
    @markread_reminder = ReminderRecipient.find(params[:reminder_id ])
    ReminderRecipient.update(@markread_reminder.id, :is_read => true)
    @sender = @new_reminder.user
  # if request.post?
  # unless params[:reminder][:body] == "" or params[:recipients] == ""
  # Reminder.create(:sender=>user.id, :recipient=>@sender.id, :subject=>params[:reminder][:subject],
  # :body=>params[:reminder][:body], :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
  # flash[:notice]="Your reply has been sent"
  # redirect_to :controller=>"reminder", :action=>"view_reminder", :id2=>params[:id2]
  # else
  # flash[:notice]="<b>ERROR:</b>Please enter both subject and body"
  # redirect_to :controller=>"reminder", :action=>"view_reminder",:id2=>params[:id2]
  # end
  # end
  end

  def mark_unread

    markread_reminder = ReminderRecipient.find(params[:reminder_id ])
    ReminderRecipient.update(markread_reminder.id, :is_read => false)
    flash[:notice] = "Reminder marked unread."
    redirect_to :controller=>"reminder", :action=>"index"

  end

  def pull_reminder_form
    @employee = Employee.find(params[:id])
    @manager = Employee.find(@employee.reporting_manager_id).user
    render :partial => "send_reminder"
  end

  def send_reminder
    if params[:create_reminder]
      unless params[:create_reminder][:message] == "" or params[:create_reminder][:to] == ""
        Reminder.create(:sender=>params[:create_reminder][:from], :recipient=>params[:create_reminder][:to], :subject=>params[:create_reminder][:subject],
        :body=>params[:create_reminder][:message] , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
        render(:update) do |page|
          page.replace_html 'error-msg', :text=> '<p class="flash-msg">Your message has been sent</p>'
        end
      else
        render(:update) do |page|
          page.replace_html 'error-msg', :text=> '<p class="flash-msg">Please enter message and subject.</p>'
        end
      end
    else
      redirect_to :controller=>:reminder
    end
  end
end
