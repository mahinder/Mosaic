class SmsController < ApplicationController
  filter_access_to :all
  before_filter :login_required,:sms_security
  include SmsManagerHelper
  def index
    @config = SchoolConfiguration.find_by_config_key("SmsEnabled")
    puts @config
    if @config.nil? || @config.config_value == "0"
      redirect_to :controller=>"sessions" , :action=>"dashboard"
    else
      @sms_setting = SmsSetting.new()
    end
  end

  def settings
    @config = SchoolConfiguration.find_by_config_key("SmsEnabled")
    puts @config
    if @config.nil? || @config.config_value == "0"
      redirect_to :controller=>"sessions" , :action=>"dashboard"
    else
      @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")
      @student_admission_sms_enabled = SmsSetting.find_by_settings_key("StudentAdmissionEnabled")
      @exam_schedule_result_sms_enabled = SmsSetting.find_by_settings_key("ExamScheduleResultEnabled")
      @additionalexam_schedule_result_sms_enabled = SmsSetting.find_by_settings_key("AdditionalExamScheduleResultEnabled")
      @student_attendance_sms_enabled = SmsSetting.find_by_settings_key("AttendanceEnabled")
      @news_events_sms_enabled = SmsSetting.find_by_settings_key("NewsEventsEnabled")
      # @result_publish_sms_enabled = SmsSetting.find_by_settings_key("ResultPublishEnabled")
      # @parents_sms_enabled = SmsSetting.find_by_settings_key("ParentSmsEnabled")
      # @students_sms_enabled = SmsSetting.find_by_settings_key("StudentSmsEnabled")
      @employees_sms_enabled = SmsSetting.find_by_settings_key("EmployeeSmsEnabled")
      @ptm_sms_enabled = SmsSetting.find_by_settings_key("PtmEnabled")

    end
  end

  def  update_application_sms_settings
    @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")
    if SmsSetting.update(@application_sms_enabled.id,:is_enabled=>params[:sms_settings][:application_enabled])
      @student_admission_sms_enabled = SmsSetting.find_by_settings_key("StudentAdmissionEnabled")
      @exam_schedule_result_sms_enabled = SmsSetting.find_by_settings_key("ExamScheduleResultEnabled")
      @result_publish_sms_enabled = SmsSetting.find_by_settings_key("ResultPublishEnabled")
      @student_attendance_sms_enabled = SmsSetting.find_by_settings_key("AttendanceEnabled")
      @additionalexam_schedule_result_sms_enabled = SmsSetting.find_by_settings_key("AdditionalExamScheduleResultEnabled")
      @news_events_sms_enabled = SmsSetting.find_by_settings_key("NewsEventsEnabled")
      @parents_sms_enabled = SmsSetting.find_by_settings_key("ParentSmsEnabled")
      @students_sms_enabled = SmsSetting.find_by_settings_key("StudentSmsEnabled")
      @employees_sms_enabled = SmsSetting.find_by_settings_key("EmployeeSmsEnabled")
      @ptm_sms_enabled = SmsSetting.find_by_settings_key("PtmEnabled")
      SmsSetting.update(@student_admission_sms_enabled.id,:is_enabled=>false)
      SmsSetting.update(@ptm_sms_enabled.id,:is_enabled=>false)
      SmsSetting.update(@exam_schedule_result_sms_enabled.id,:is_enabled=>false)
      SmsSetting.update(@student_attendance_sms_enabled.id,:is_enabled=>false)
      SmsSetting.update(@additionalexam_schedule_result_sms_enabled.id,:is_enabled=>false)
      # SmsSetting.update(@result_publish_sms_enabled.id,:is_enabled=>params[:general_settings][:result_publish_enabled])
      SmsSetting.update(@news_events_sms_enabled.id,:is_enabled=>false)
      # SmsSetting.update(@parents_sms_enabled.id,:is_enabled=>params[:general_settings][:sms_parents_enabled])
      # SmsSetting.update(@students_sms_enabled.id,:is_enabled=>params[:general_settings][:sms_students_enabled])
      SmsSetting.update(@employees_sms_enabled.id,:is_enabled=>false)
      respond_to do |format|
        format.html # all.html.erb
        format.json  { render :json => {:valid => true,:is_enabled=>params[:sms_settings][:application_enabled]} }
      end
    end
  end

  def update_general_sms_settings
    @additionalexam_schedule_result_sms_enabled = SmsSetting.find_by_settings_key("AdditionalExamScheduleResultEnabled")
    @student_admission_sms_enabled = SmsSetting.find_by_settings_key("StudentAdmissionEnabled")
    @exam_schedule_result_sms_enabled = SmsSetting.find_by_settings_key("ExamScheduleResultEnabled")
    @result_publish_sms_enabled = SmsSetting.find_by_settings_key("ResultPublishEnabled")
    @student_attendance_sms_enabled = SmsSetting.find_by_settings_key("AttendanceEnabled")
    @news_events_sms_enabled = SmsSetting.find_by_settings_key("NewsEventsEnabled")
    @parents_sms_enabled = SmsSetting.find_by_settings_key("ParentSmsEnabled")
    @students_sms_enabled = SmsSetting.find_by_settings_key("StudentSmsEnabled")
    @ptm_sms_enabled = SmsSetting.find_by_settings_key("PtmEnabled")
    @employees_sms_enabled = SmsSetting.find_by_settings_key("EmployeeSmsEnabled")
    SmsSetting.update(@additionalexam_schedule_result_sms_enabled.id,:is_enabled=>params[:general_settings][:additinal_exam_schedule_result_enabled])
    SmsSetting.update(@student_admission_sms_enabled.id,:is_enabled=>params[:general_settings][:student_admission_enabled])
    SmsSetting.update(@exam_schedule_result_sms_enabled.id,:is_enabled=>params[:general_settings][:exam_schedule_result_enabled])
    SmsSetting.update(@student_attendance_sms_enabled.id,:is_enabled=>params[:general_settings][:student_attendance_enabled])
    # SmsSetting.update(@result_publish_sms_enabled.id,:is_enabled=>params[:general_settings][:result_publish_enabled])
    SmsSetting.update(@ptm_sms_enabled.id,:is_enabled=>params[:general_settings][:ptm_enabled])
    SmsSetting.update(@news_events_sms_enabled.id,:is_enabled=>params[:general_settings][:news_events_enabled])
    # SmsSetting.update(@parents_sms_enabled.id,:is_enabled=>params[:general_settings][:sms_parents_enabled])
    # SmsSetting.update(@students_sms_enabled.id,:is_enabled=>params[:general_settings][:sms_students_enabled])
    SmsSetting.update(@employees_sms_enabled.id,:is_enabled=>params[:general_settings][:sms_employees_enabled])
    flash[:notice] = 'Sms settings has been saved'
    redirect_to :action=>"settings"
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
    puts response
    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    respond_to do |format|
      format.json { render :json => response}
    end

  end

  def template_find

    @template = SmsTemplate.find_by_id(params[:id])
    unless @template.nil?
    message = @template.text
    end
    respond_to do |format|
      format.json { render :json => {:message =>  message}}
    end

  end

  def sms_emp_send
    sms_setting = SmsSetting.new()
    @recipients = nil
    @courses_count = (Course.active.count unless Course.active.empty?)|| 0
    @user = current_user
    respond_to do |format|
      unless params[:template].nil?
        message = params[:template]
        unless params[:courses].nil? || params[:courses].empty?
          params[:courses].each do |course|
            @course = Course.find(course)
            @batches = @course.batches
            unless @batches.empty?
              @batches.each do |batch|
                @students = batch.students
                unless @students.empty?
                  @students.each do |student|
                    guardian = student.immediate_contact
                    unless student.nil?
                      if sms_setting.application_sms_active and student.is_sms_enabled
                        unless guardian.nil? || guardian.mobile_phone.nil?
                          if @recipients.nil?
                          @recipients = guardian.mobile_phone
                          else
                            @recipients = @recipients + ","+ guardian.mobile_phone
                          end
                        else
                          unless student.phone2.nil?
                            if @recipients.nil?
                            @recipients = student.phone2
                            else
                              @recipients = @recipients + ","+ student.phone2
                            end
                          end
                        end

                      # @recipients = student.phone1
                      end
                    end
                  end

                end
              end
            end

          end
        end
        unless params[:send_to_id].nil? || params[:send_to_id].empty?
          params[:send_to_id].each do |sen|
            @reciver = User.find_by_id(sen)
            if @reciver.student
              @rec =  @reciver. student_record
              unless @rec.nil?
                guardian = @rec.immediate_contact
                # @recipients = @rec.phone1
               
                if sms_setting.application_sms_active and @rec.is_sms_enabled
                  unless guardian.nil? || guardian.mobile_phone.nil?
                    if @recipients.nil?
                    @recipients = @rec.guardian.mobile_phone
                    else
                      @recipients = @recipients + ","+ @rec.guardian.mobile_phone
                    end
                  else
                    unless @rec.phone2.nil?
                      if @recipients.nil?
                      @recipients = @rec.phone2
                      else
                        @recipients = @recipients + ","+ @rec.phone2
                      end
                    end
                  end
                end
              # sms = SmsManager.new(message,@recipients)
              # response =  sms.send_sms
              #
              # if response.body.match(/error/)
              # flash[:notice_error] = response.body
              # format.json { render :json => {:valid => false, :notice => response.body}}
              # end
              end
            else
              @rec =  @reciver.employee_record
              unless @rec.nil? || @rec.mobile_phone.nil?
                # @recipients = @rec.office_phone1
                # sms = SmsManager.new(message,@recipients)
                # response =  sms.send_sms
                # puts response
                # if response.body.match(/error/)
                # flash[:notice_error] = response.body
                # format.json { render :json => {:valid => false, :notice => response.body}}
                # end
                if sms_setting.application_sms_active
                  if @recipients.nil?
                  @recipients = @rec.mobile_phone
                  else
                    @recipients = @recipients + ","+ @rec.mobile_phone
                  end
                end
              end
            end

          end
        end

      end
      unless @recipients.nil?
        puts @recipients
        sms = SmsManager.new(message,@recipients)
        begin
          response =  sms. send_sms
          if response.body.match(/error/)
            flash[:notice_error] = response.body
            format.json { render :json => {:valid => false , :notice => response.body}}
          end
        rescue Exception => exc
          flash[:notice_error] = exc.message
          format.json { render :json => {:valid => false , :notice => "sms can't be send due some error in sms service"}}
        end
      end
      format.json { render :json => {:valid => true}}
    end

  end

  def std_send
    @recipients=[]
    @message = SmsTemplate.find_by_template_code("TFRMD")
    unless @message.nil?
      message = @message.text
      unless message.nil?
        @recipients.push ""
        # sms = SmsManager.new(message,@recipients)
        sms = SmsManager.new(message,@recipients)
        response =  sms.send_sms

        if response.body.match(/error/)
          flash[:notice_error] = response.body
        end
      end
    end
  end

  def students
    @user = current_user
    @role = @user.role_name
    puts @role
    @sms = SmsTemplate.new
    @sms_template = SmsTemplate.find(:all,:order => "template_code asc",:conditions=>{:is_inactive => false})
  # if request.post?
  # unless params[:send_sms][:student_ids].nil?
  # student_ids = params[:send_sms][:student_ids]
  # sms_setting = SmsSetting.new()
  # student_ids.each do |s_id|
  # @recipients=[]
  # student = Student.find(s_id)
  # guardian = student.immediate_contact
  # if student.is_sms_enabled
  # if sms_setting.student_sms_active
  # @recipients.push student.phone2 unless (student.phone2.nil? or student.phone2 == "")
  # end
  # if sms_setting.parent_sms_active
  # unless guardian.nil?
  # @recipients.push guardian.mobile_phone unless (guardian.mobile_phone.nil? or guardian.mobile_phone == "")
  # end
  # end
  # end
  # unless @recipients.empty?
  # message = params[:send_sms][:message]
  # sms = SmsManager.new(message,@recipients)
  # sms.send_sms
  # end
  # end
  # end
  # render(:update) do |page|
  # page.replace_html 'status-message',:text=>"<p class=\"flash-msg\"> SMS sent successfully selected students and their guardians</p>"
  # page.visual_effect(:highlight, 'status-message')
  # end
  # end

  end

  def list_students
    batch = Batch.find(params[:batch_id])
    @students = Student.find_all_by_batch_id(batch.id,:conditions=>'is_sms_enabled=true')
  end

  def batches
    @batches = Batch.active
    if request.post?
      unless params[:send_sms][:batch_ids].nil?
        batch_ids = params[:send_sms][:batch_ids]
        sms_setting = SmsSetting.new()
        batch_ids.each do |b_id|
          @recipients = []
          batch = Batch.find(b_id)
          batch_students = batch.students
          batch_students.each do |student|
            if student.is_sms_enabled
              if sms_setting.student_sms_active
                @recipients.push student.phone2 unless (student.phone2.nil? or student.phone2 == "")
              end
              if sms_setting.parent_sms_active
                guardian = student.immediate_contact
                unless guardian.nil?
                  @recipients.push guardian.mobile_phone unless (guardian.mobile_phone.nil? or guardian.mobile_phone == "")
                end
              end
            end
          end
          unless @recipients.empty?
            message = params[:send_sms][:message]
            sms = SmsManager.new(message,@recipients)
          # sms.send_sms
          end
        end
      end
      render(:update) do |page|
        page.replace_html 'status-message',:text=>"<p class=\"flash-msg\">SMS sent successfully to students(guardians) of selected course</p>"
        page.visual_effect(:highlight, 'status-message')
      end
    end
  end

  def sms_all
    batches = Batch.active
    sms_setting = SmsSetting.new()
    batches.each do |batch|
      @recipients = []
      batch_students = batch.students
      batch_students.each do |student|
        if student.is_sms_enabled
          if sms_setting.student_sms_active
            @recipients.push student.phone2 unless (student.phone2.nil? or student.phone2 == "")
          end
          if sms_setting.parent_sms_active
            guardian = student.immediate_contact
            unless guardian.nil?
              @recipients.push guardian.mobile_phone unless (guardian.mobile_phone.nil? or guardian.mobile_phone == "")
            end
          end
        end
      end
      unless @recipients.empty?
        message = params[:send_sms][:message]
        sms = SmsManager.new(message,@recipients)
        response =  sms.send_sms

        if response.body.match(/error/)
          flash[:notice_error] = response.body
        end
      end
    end
    emp_departments = EmployeeDepartment.find(:all)
    emp_departments.each do |dept|
      @recipients = []
      dept_employees = dept.employees
      dept_employees.each do |employee|
        if sms_setting.employee_sms_active
          @recipients.push employee.mobile_phone unless (employee.mobile_phone.nil? or employee.mobile_phone == "")
        end
      end
      unless @recipients.empty?
        message = params[:send_sms][:message]
        sms = SmsManager.new(message,@recipients)
        response =  sms.send_sms

        if response.body.match(/error/)
          flash[:notice_error] = response.body
        end
      end
    end
  end

  def employees
    if request.post?
      unless params[:send_sms][:employee_ids].nil?
        employee_ids = params[:send_sms][:employee_ids]
        sms_setting = SmsSetting.new()
        employee_ids.each do |e_id|
          @recipients=[]
          employee = Employee.find(e_id)
          if sms_setting.employee_sms_active
            @recipients.push employee.mobile_phone unless (employee.mobile_phone.nil? or employee.mobile_phone == "")
          end
          unless @recipients.empty?
            message = params[:send_sms][:message]
            sms = SmsManager.new(message,@recipients)
            response =  sms.send_sms

            if response.body.match(/error/)
              flash[:notice_error] = response.body
            end
          end
        end
      end
      render(:update) do |page|
        page.replace_html 'status-message',:text=>"<p class=\"flash-msg\">SMS sent successfully to selected employees</p>"
        page.visual_effect(:highlight, 'status-message')
      end
    end
  end

  def list_employees
    dept = EmployeeDepartment.find(params[:dept_id])
    @employees = dept.employees
  end

  def departments
    @departments = EmployeeDepartment.find(:all)
    if request.post?
      unless params[:send_sms][:dept_ids].nil?
        dept_ids = params[:send_sms][:dept_ids]
        sms_setting = SmsSetting.new()
        dept_ids.each do |d_id|
          @recipients = []
          department = EmployeeDepartment.find(d_id)
          department_employees = department.employees
          department_employees.each do |employee|
            if sms_setting.employee_sms_active
              @recipients.push employee.mobile_phone unless (employee.mobile_phone.nil? or employee.mobile_phone == "")
            end
          end
          unless @recipients.empty?
            message = params[:send_sms][:message]
            sms = SmsManager.new(message,@recipients)
            response =  sms.send_sms

            if response.body.match(/error/)
              flash[:notice_error] = response.body
            end
          end
        end
      end
      render(:update) do |page|
        page.replace_html 'status-message',:text=>"<p class=\"flash-msg\">SMS sent successfully to employees of selected department</p>"
        page.visual_effect(:highlight, 'status-message')
      end
    end
  end

end
