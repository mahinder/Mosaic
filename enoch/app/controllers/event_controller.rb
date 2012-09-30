class EventController < ApplicationController
  before_filter :login_required
  # filter_access_to :all
  def index
    if params[:id].nil?
      @date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    else
      date = params[:id].to_date
      @date = date.to_time.strftime("%Y-%m-%d %H:%M:%S")
    end
    if request.post?
      if params[:events][:is_holiday] == "1"
        @startDate = params[:events][:start_date].to_date.strftime('%d %b %Y 00:00:00')
        @endDate = params[:events][:end_date].to_date.strftime('%d %b %Y 00:00:00')
        @events = Event.new(:start_date => @startDate,
        :end_date => @endDate,
        :title => params[:events][:title],
        :description => params[:events][:description],
        :is_holiday => params[:events][:is_holiday],
        :is_common => params[:events][:is_common])
      else
        @startDate = Time.zone.parse(params[:events][:start_date]).utc
        @endDate = Time.zone.parse(params[:events][:end_date]).utc
        @events = Event.new(:start_date => @startDate,
        :end_date => @endDate,
        :title => params[:events][:title],
        :description => params[:events][:description],
        :is_holiday => params[:events][:is_holiday],
        :is_common => params[:events][:is_common])
      end

      if @events.valid?
        if @events.save
          #Event.update(@events.id,:start_date=>params[:start_date], :end_date=>params[:end_date])
          #      if params[:events][:is_common] == "0" and @events.save
          flash[:notice] = t(:event_created)
          redirect_to :action=>"show", :id=>@events.id
        #      else
        #        @users = User.find(:all)
        #        @users.each do |u|
        #          Reminder.create(:sender=> current_user.id,:recipient=>u.id,
        #            :subject=>"New Event : #{params[:events][:title]}",
        #            :body=>" New event description : #{params[:events][:description]} <br/> start date : #{params[:start_date]} <br/> end date : #{params[:end_date]}")
        #        end
        #        redirect_to :action=>"show", :id=>@events.id

        else
          flash[:notice] = t(:event_not_created)
        end
      else
        flash[:notice] = t(:event_cancel)
        redirect_to :action=>"index"
      end
    end
  end

  def user_event
    if params[:id].nil?
      @date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    else
      date = params[:id].to_date
      @start_date = params[:start_date].to_time.strftime("%Y-%m-%d %H:%M:%S")
      @end_date = params[:end_date].to_time.strftime("%Y-%m-%d %H:%M:%S")
    end
    @event = Event.new(:start_date => @start_date,
    :end_date => @end_date,
    :title => params[:title],
    :description => params[:description],
    :is_holiday => false,
    :is_common => false,
    :is_due => false)

    if @event.save
      UserEvent.create(:user_id => current_user.id, :event_id =>@event.id )
    else
    @error = true
    end
    respond_to do |format|
      if @error.nil?
        format.json { render :json => {:valid => true,:notice=> "User event created successfully"}}
      else
        format.json { render :json => {:valid => false,:errors => @event.errors}}
      end
    end
  end

  def update_user_event
    @event = Event.find(params[:id])
    unless @event.update_attributes(params[:event])
    @error = true
    end
    respond_to do |format|
      if @error.nil?
        format.json { render :json => {:valid => true,:notice=> "User event updates successfully"}}
      else
        format.json { render :json => {:valid => false,:errors => @event.errors}}
      end
    end
  end

  def view_my_event_form
    if params[:aTag].nil?
      @date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    else
      date = params[:aTag].to_date
      @date = date.to_time.strftime("%Y-%m-%d %H:%M:%S")
    end
    render :partial => '/calendars/add_my_event'
  end

  def event_group
    @event = Event.find(params[:id])
  end

  def select_course
    @event_id = params[:id]
    @batches = Batch.active
    render :update do |page|
      page.replace_html 'select-option', :partial => 'select_course'
    end
  end

  def course_event
    event = Event.find(params[:id])
    batch_id_list = params[:select_options][:batch_id] unless params[:select_options].nil?
    unless batch_id_list.nil?
      batch_id_list.each do |c|
        batch_event_exists = BatchEvent.find_by_event_id_and_batch_id(event.id,c)
        if batch_event_exists.nil?
          BatchEvent.create(:event_id => event.id,:batch_id=>c)
        end
      end
    end

    department_id_list = params[:select_options][:department_id] unless params[:select_options].nil?
    unless department_id_list.nil?
      department_id_list.each do |c|
        department_event_exists = EmployeeDepartmentEvent.find_by_event_id_and_employee_department_id(event.id,c)
        if department_event_exists.nil?
          EmployeeDepartmentEvent.create(:event_id=>event.id,:employee_department_id=>c)
        end
      end
    end

    respond_to do |format|
      if batch_id_list.nil?
        format.json { render :json => {:valid => true, :notice=> t(:department_event)}}
      elsif department_id_list.nil?
        format.json { render :json => {:valid => true, :notice=> t(:batch_event)}}
      else
        format.json { render :json => {:valid => true, :notice=> t(:department_and_batch_event)}}
      end
    end

  end

  def remove_batch
    @batch_event = BatchEvent.find_by_event_id_and_batch_id(params[:event_id], params[:batch_id])
    @event = @batch_event.event
    @batch_events = BatchEvent.find(:all, :conditions=>"event_id = #{@event.id}")
    @courses = Course.find(:all, :conditions => {:is_deleted => false})
    @batch_event.delete
    respond_to do |format|
      format.json { render :json => {:valid => true,:notice=> t(:batch_event_deleted)}}
    end
  end

  def select_employee_department
    @event_id = params[:id]
    @employee_department = EmployeeDepartment.find(:all, :conditions=>{:status => true})
    render :update do |page|
      page.replace_html 'select-options', :partial => 'select_employee_department'
    end
  end

  def department_event
    event = Event.find(params[:id])
    department_id_list = params[:select_options][:department_id] unless params[:select_options].nil?
    unless department_id_list.nil?
      department_id_list.each do |c|
        department_event_exists = EmployeeDepartmentEvent.find_by_event_id_and_employee_department_id(event.id,c)
        if department_event_exists.nil?
          EmployeeDepartmentEvent.create(:event_id=>event.id,:employee_department_id=>c)
        #        @dept_emp = Employee.find(:all, :conditions=>"employee_department_id = #{c}")
        #        @dept_emp.each do |e|
        #          emp_user = User.find_by_username(e.employee_number)
        #          Reminder.create(:sender => current_user.id,:recipient=>emp_user.id,
        #            :subject=>"New Event : #{event.title}",
        #            :body=>" New event description : #{event.description} <br/> start date : #{event.start_date} <br/> end date : #{event.end_date}")
        #        end
        end
      end
    end
    flash[:notice] = t(:department_event)
    redirect_to :action=>"show", :id=>event.id
  end

  def remove_department
    @department_event = EmployeeDepartmentEvent.find_by_event_id_and_employee_department_id(params[:event_id],params[:employee_department_id])
    @event = @department_event.event_id
    @department_event.delete
    respond_to do |format|
      format.json { render :json => {:valid => true,:notice=> t(:dapartment_event_deleted)}}
    end
  end

  def show
    @courses = Course.find(:all, :conditions => {:is_deleted => 'false'})
    @event = Event.find(params[:id])
    @employee_department = EmployeeDepartment.find(:all, :conditions=>{:status => true})
    @command = params[:cmd]
    event_start_date = "#{@event.start_date.year}-#{@event.start_date.month}-#{@event.start_date.day}".to_date
    event_end_date = "#{@event.end_date.year}-#{@event.end_date.month}-#{@event.end_date.day}".to_date
    @other_events = Event.find(:all, :conditions=>"id != #{@event.id}")
    if @event.is_common ==false
      @batch_events = BatchEvent.find(:all, :conditions=>"event_id = #{@event.id}")
      @department_event = EmployeeDepartmentEvent.find(:all, :conditions=>"event_id = #{@event.id}")
    end
  end

  def confirm_event
    stud_recipients = nil
    emp_recipients = nil
    sms_setting = SmsSetting.new()

    event = Event.find_by_id(params[:id])

    if event.is_common == true
      if event.is_holiday == true
        @pe = PeriodEntry.find(:all, :conditions=>"month_date BETWEEN '" + event.start_date.strftime("%Y-%m-%d") + "' AND '" +  event.end_date.strftime("%Y-%m-%d") +"'")
        unless @pe.nil?
          @pe.each do |p|
            p.delete
          end
        end
      end
      if event.is_common == true
        reminder = Reminder.create(:sender=> current_user.id,:sent_to => "ALL",
        :subject=>"New Event : #{event.title}",
        :body=>" New event description : #{event.description} <br/> Start date : " + event.start_date.strftime("%d/%m/%Y %I:%M %p") + " <br/> End date : " + event.end_date.strftime("%d/%m/%Y %I:%M %p"))

        @batch_student = Student.find(:all)
        @batch_student.each do |s|
          student_user = s.user
          ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
        end
        @dept_emps = Employee.find(:all)
        @dept_emps.each do |e|
          emp_user = e.user
          ReminderRecipient.create(:recipient=>emp_user.id,:reminder_id => reminder.id)
        end
      end

    # sms_setting = SmsSetting.new()
    # if sms_setting.application_sms_active and sms_setting.event_news_sms_active
    # recipients = []
    # @users.each do |u|
    # if u.student == true
    # student = u.student_record
    # guardian = student.immediate_contact unless student.immediate_contact.nil?
    # if student.is_sms_enabled
    # if sms_setting.student_sms_active
    # recipients.push student.phone2 unless student.phone2.nil?
    # end
    # if sms_setting.parent_sms_active
    # unless guardian.nil?
    # recipients.push guardian.mobile_phone unless guardian.mobile_phone.nil?
    # end
    # end
    # end
    # else
    # employee = u.employee_record
    # if sms_setting.employee_sms_active
    # unless employee.nil?
    # recipients.push employee.mobile_phone unless employee.mobile_phone.nil?
    # end
    # end
    # end
    # end
    # unless recipients.empty?
    # message = "Event Notification: #{event.title}. From : #{event.start_date} to #{event.end_date}"
    # sms = SmsManager.new(message,recipients)
    # sms.send_sms
    # end
    # end
    else

      department_event = EmployeeDepartmentEvent.find_all_by_event_id(event.id)
      unless department_event.empty?
        @department_name = ""
        department_event.each do |b|
          if @department_name == ""
          @department_name = @department_name + b.employee_department.name
          else
            @department_name = @department_name+","+ b.employee_department.name
          end
        end
      end

      batch_event = BatchEvent.find_all_by_event_id(event.id)
      unless batch_event.empty?
        @batch_name = ""
        batch_event.each do |b|
          if @batch_name == ""
          @batch_name = @batch_name + b.batch.full_name
          else
            @batch_name = @batch_name+","+ b.batch.full_name
          end
        end
      end

      if !batch_event.empty? && department_event.empty?
        reminder = Reminder.create(:sender=> current_user.id,:sent_to => @batch_name.to_s,
        :subject=>"New Event : #{event.title}",
        :body=>" New event description : #{event.description} <br/> Start date : " + event.start_date.strftime("%d/%m/%Y %I:%M %p") + " <br/> End date : " + event.end_date.strftime("%d/%m/%Y %I:%M %p"))
      elsif !department_event.empty? && batch_event.empty?
        reminder = Reminder.create(:sender=> current_user.id,:sent_to =>  @department_name.to_s,
        :subject=>"New Event : #{event.title}",
        :body=>" New event description : #{event.description} <br/> Start date : " + event.start_date.strftime("%d/%m/%Y %I:%M %p") + " <br/> End date : " + event.end_date.strftime("%d/%m/%Y %I:%M %p"))
      elsif department_event.empty? && batch_event.empty?
      else
      reminder = Reminder.create(:sender=> current_user.id,:sent_to => @batch_name.to_s + ","+ @department_name.to_s,
      :subject=>"New Event : #{event.title}",
      :body=>" New event description : #{event.description} <br/> Start date : " + event.start_date.strftime("%d/%m/%Y %I:%M %p") + " <br/> End date : " + event.end_date.strftime("%d/%m/%Y %I:%M %p"))

      end

      unless batch_event.empty?
        batch_event.each do |b|
          if event.is_holiday == true
            @pe = PeriodEntry.find_all_by_batch_id(b.batch_id, :conditions=>"month_date BETWEEN '" + event.start_date.strftime("%Y-%m-%d") + "' AND '" +  event.end_date.strftime("%Y-%m-%d") +"'")
            unless @pe.nil?
              @pe.each do |p|
                p.delete
              end
            end
          end
          @batch_students = Student.find(:all, :conditions=>"batch_id = #{b.batch_id}")
          @batch_students.each do |s|

            student_user = s.user
            unless student_user.nil?
              if sms_setting.application_sms_active and s.is_sms_enabled and sms_setting.event_news_sms_active and params[:sms] == "true"
                unless s.immediate_contact.nil? || s.immediate_contact.mobile_phone.nil?
                stud_recipients =  sms_setting.create_recipient(s.immediate_contact.mobile_phone,stud_recipients)
                else
                  unless s.phone2.nil?
                  stud_recipients = sms_setting.create_recipient(s.phone2,stud_recipients)
                  end
                end
              end
              ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
            end
          end
        end
      end
      department_event = EmployeeDepartmentEvent.find_all_by_event_id(event.id)
      unless department_event.empty?
        department_event.each do |d|
          @dept_emp = Employee.find(:all, :conditions=>"employee_department_id = #{d.employee_department_id}")
          @dept_emp.each do |e|
            emp_user = e.user
            unless emp_user.nil?
              unless  e.mobile_phone.nil?
                if sms_setting.application_sms_active and sms_setting.event_news_sms_active and params[:sms] == "true"
                emp_recipients =  sms_setting.create_recipient(e.mobile_phone,emp_recipients)
                end
              end
              ReminderRecipient.create(:recipient=>emp_user.id,:reminder_id => reminder.id)

            end
          end
        end
      end
    end
    unless event.nil?
      student_message = "Dear Parents,  #{event.title} will be held on #{event.start_date.strftime('%d/%m/%Y %I:%M %p')}. Principal, MCSCHD"
      emp_message = "Dear Staff, #{event.title} will be held on #{event.start_date.strftime('%d/%m/%Y %I:%M %p')}. Principal, MCSCHD"
      response1 = sms_setting.send_sms(student_message,stud_recipients)
      response2 = sms_setting.send_sms(emp_message,emp_recipients)
      if response1 == "something went worng" || response2 == "something went worng"
        responsevalue = "Sms can't be send due some error in sms service"
         
      end
     
    end
  flash[:warnnotice] = responsevalue
    redirect_to :controller=>'calendars',:action=>'index'
  end

  def cancel_event
    event = Event.find_by_id(params[:id])
    unless event.nil?
      batch_event = BatchEvent.find(:all, :conditions=>"event_id = #{params[:id]}")
      dept_event = EmployeeDepartmentEvent.find(:all, :conditions=>"event_id = #{params[:id]}")
      event.destroy
      batch_event.each { |x| x.destroy } unless batch_event.nil?
      dept_event.each { |x| x.destroy } unless dept_event.nil?
      flash[:notice] = t(:event_cancel)
      redirect_to :action=>"index"
    else
      redirect_to :action=>"index"
    end
  end

  def edit_event
    @event = Event.find_by_id(params[:id])
    if request.post? and @event.update_attributes(params[:event])
      redirect_to :action=>"show", :id=>@event.id, :cmd=>'edit'
    end
  end

  def select_course_batch
    render :partial => 'select_course'
  end

end

