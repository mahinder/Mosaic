class StudentController < ApplicationController
  include StudentHelper
  
  before_filter :login_required
  layout :choose_layout
  before_filter :protect_other_student_data, :except =>[:show]   
  before_filter :find_student, :only => [
    :academic_report, :academic_report_all, :admission3, :change_to_former,
    :delete, :edit, :add_guardian, :email, :remove, :reports, :my_profile,
    :guardians, :academic_pdf,:show_previous_details,:fees,:fee_details
  ]
     filter_access_to :all
        @@stud_admission_no = Rails.application.config.student_admission_no.upcase
   def choose_layout
    if action_name == 'student_wizard_first_step' || action_name == 'student_wizard_next_step' || action_name == 'student_wizard_previous_step'
      return 'student'
    else
      return 'application'
    end
  end

  def admission_no
    logger.info "In student controller & action admission_no ,the params are #{params}"
    @admission = User.find_by_username(params[:id]) || ArchivedStudent.find_by_admission_no(params[:id])
      respond_to do |format|
        if @admission.nil?
           format.json { render :json => {:valid => false, :admission => @admission}}
        else
           format.json { render :json => {:valid => true, :admission => @admission,:notice => t(:admission_number_taken)}}
        end
    end
  end
  
  
  
  
  
  def upload
    
    session[:return_to]= request.referer
    if params[:upload].include? "datafile1"  
       post = Student.save(params[:upload],current_user)
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
     if File.exist?("#{Rails.root}/public/system/attachment/student/#{params[:student]}/#{params[:dir]}/#{params[:file]}")  
          send_file  "#{Rails.root}/public/system/attachment/student/#{params[:student]}/#{params[:dir]}/#{params[:file]}", :file_name => params[:file]
     else
          flash[:warning] = "File does not exist in specified folder"
          redirect_to session[:return_to]
     end  
    
    else
      if File.exist?("#{Rails.root}/public/system/attachment/student/#{params[:student]}/#{params[:dir]}/#{params[:file]}")  
          File.delete("#{Rails.root}/public/system/attachment/student/#{params[:student]}/#{params[:dir]}/#{params[:file]}")
          Attachment.find_by_file_name(params[:file]).update_attributes(:deleted_by_id => current_user.id)
          flash[:notice] = "File is remove from specified folder"
          redirect_to session[:return_to]
      else
          flash[:notice] = "File does not exist in specified folder"
          redirect_to session[:return_to]
       end 
       
    end 
     
  end
  def attachments
  
   @student_id = params[:id]
   @addmition_no = params[:q]
   
  end
  
 def email_validation
   logger.info "In student controller & action email_validation ,the params are #{params}"
   @email =  User.find_by_email(params[:id])
   respond_to do |format|
        if @email.nil?
           format.json { render :json => {:valid => false, :admission => @email}}
        else
           format.json { render :json => {:valid => true, :errors => @email,:notice => t(:email_taken)}}
        end
    end
 end
  
  def student_wizard_first_step
    logger.info "In student controller & action student_wizard_first_step ,the params are #{params}"
    session[:student_params] = {}
    session[:student_step] = nil;
    @student = Student.new( session[:student_params])
    @last_admitted_student = Student.find_by_admission_no(Student.maximum("admission_no"))
    @config = SchoolConfiguration.find_by_config_key('AdmissionNumberAutoIncrement')
    @batches = []
  end
  
  def student_wizard_next_step
     recipients = nil
     responsevalue = ""
    sms_setting = SmsSetting.new()
    logger.info "In student controller & action student_wizard_next_step ,the params are #{params}"
    session[:parent_params] = {}
    session[:student_params].deep_merge!(params[:student]) if params[:student]
    @student = Student.new session[:student_params]
    @student.current_step =  session[:student_step]
   unless @student.current_step == 'image_crop'
    if @student.valid? 
      if @student.current_step == 'image'  
        student_admission_no = session[:student_params]['admission_no'].upcase
        student_first_name = session[:student_params]['first_name'].capitalize
        student_last_name = session[:student_params]['last_name'].capitalize
        unless session[:student_params]['middle_name'].nil?
        student_middle_name = session[:student_params]['middle_name'].capitalize
        end
        session[:student_params]['admission_no'] = student_admission_no
        session[:student_params]['first_name'] = student_first_name
        session[:student_params]['last_name'] = student_last_name
        unless session[:student_params]['middle_name'].nil?
        session[:student_params]['middle_name'] = student_middle_name
        end
        roll = Student.find_last_by_batch_id(session[:student_params]['batch_id'])
         if roll != nil
         session[:student_params]['class_roll_no'] = roll.class_roll_no.next
         else
           session[:student_params]['class_roll_no'] = 1
         end
          @student = Student.new session[:student_params] 
            student_param = session[:student_params] 
             if student_param.include?("student_photo")
               
                      @student.save 
                         user = @student.user
                          unless user.nil?
                                 chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
                                  newpass = ""
                                  1.upto(20) { |i| newpass << chars[rand(chars.size-1)] }
                                  @subject = "Admission"
                                  @body = "Congratulations for admission . Your username is "+user.username+". Your password is " + newpass
                                  UserMailer.registration_confirmation(user,@subject,@body).deliver
                              unless @student.phone2.nil? || @student.phone2 == ""
                                  if sms_setting.application_sms_active and @student.is_sms_enabled and sms_setting.admission_sms_active
                                          recipients =  sms_setting.create_recipient(@student.phone2,recipients)
                                  end
                              end
                              message = "Dear Parent, Congratulations! Your ward is admitted to Class #{@student.batch.full_name}. The username and password has been mailed to you. Regards MCSCHD"
                            response =   sms_setting.send_sms(message,recipients)
                          if response == "something went worng"
                            responsevalue = "But sms can't be send due some error in sms service"
                          end
                        
                          end
                          
                      flash[:success] = t(:sent_email_to_old_student) + responsevalue
                      session[:student_params] = {}
                      @student.current_step = session[:student_step]                   
             else
                      if @student.valid? 
                          @student.save 
                          user = @student.user
                         unless user.nil?
                                 chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
                                  newpass = ""
                                  1.upto(20) { |i| newpass << chars[rand(chars.size-1)] }
                                  @subject = "Admission"
                                  @body = "Congratulations for admission . Your username is "+user.username+". Your password is " + newpass
                                  UserMailer.registration_confirmation(user,@subject,@body).deliver
                                   unless @student.phone2.nil? || @student.phone2 == ""
                                      if sms_setting.application_sms_active and @student.is_sms_enabled and sms_setting.admission_sms_active
                                              recipients =  sms_setting.create_recipient(@student.phone2,recipients)
                                      end
                                  end
                                  message = "Dear Parent, Congratulations! Your ward is admitted to Class  #{@student.batch.full_name}. The username and password has been mailed to you. Regards MCSCHD"
                             response =  sms_setting.send_sms(message,recipients)
                             if response == "something went worng"
                                responsevalue = "But sms can't be send due some error in sms service"
                            end
                         end
                          flash[:success] = t(:sent_email_to_new_student) + responsevalue
                          session[:student_params] = {}
                          @student.current_step = session[:student_step]
                          @student.next_step  
                      end 
             end
      end               
      @student.next_step 
      session[:student_step] = @student.current_step
     end
     else
       @student = Student.find(:last)
       @student.current_step = session[:student_step]
       @student.next_step
       session[:student_step]=@student.current_step
       session[:parent_params]= @student
     end
  end  
  
  def student_wizard_previous_step
    logger.info "In student controller & action student_wizard_previous_step ,the params are #{params}"
    session[:student_params].deep_merge!(session[:student_params]) if session[:student_params]
#    Below statement not working for student_controller_spec.rb it requires :batch_id instead of 'batch_id   
    @batch = session[:student_params]['batch_id']
    @batche = Batch.find_by_id(@batch)
    @student = Student.new session[:student_params]
    @admission_date = @student.admission_date
    @date_of_birth  = @student.date_of_birth
    @last_admitted_student = Student.find_by_admission_no(Student.maximum("admission_no"))
    @course = @batche.course
    if @student.valid?
      @batches = @course.batches.active
      @student = Student.new session[:student_params]
      @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")
      @config = SchoolConfiguration.find_by_config_key('AdmissionNumberAutoIncrement')  
      @student.current_step = session[:student_step] 
      @student.previous_step
      session[:student_step] = @student.current_step
    end
    if session[:student_step]!= "personal"
    render "student_wizard_next_step"
    else
    render "student_wizard_first_step"
    end
  end
  
  def assign_roll_no
    logger.info "In student controller & action assign_roll_no ,the params are #{params}"
    @user = current_user
    if params[:q]!=nil 
      unless @user.employee_record.is_teacher?
      @batches = Batch.find(:all, :conditions => {:course_id => params[:q], :is_active => true})
      render :partial => 'batch_student'
      end   
    end
     if @user.employee_record.is_teacher?
      @employee = @user.employee_record
      @batch = []
      @batches = employee_batches(@employee)
      if params[:id]!=nil            
        @batch = Batch.find params[:id], :include => [:students],:order => "students.class_roll_no ASC"
        @batches = Batch.active
        response = { :batch => @batch, :batches => @batches}
        respond_to do |format|
          format.html { render :partial => 'assign_roll_no_to_batch'} # index.html.erb
          format.json  { render :json => response }
        end
      end
    end
    unless @user.employee_record.is_teacher?
      if params[:id]==nil     
      @batches = []
      else    
        @batch = Batch.find params[:id], :include => [:students],:order => "students.class_roll_no ASC"
        @batches = Batch.active
        response = { :batch => @batch, :batches => @batches}
        respond_to do |format|
          format.html { render :partial => 'assign_roll_no_to_batch'} # index.html.erb
          format.json  { render :json => response }
        end
      end
    end
  end
  
  def change_student_image
    logger.info "In student controller & action change_student_image ,the params are #{params}"
    @student= Student.find_by_admission_no(params[:q])
    render :partial => "student_image"
  end
  
  def change_roll_number 
    logger.info "In student controller & action change_roll_number ,the params are #{params}"
    @sorted_roll_no = []
    @sorted_student = []
    if params[:query] == "assign_Name"
    @student = Student.find_all_by_batch_id(params[:batch_id] ,:order => "first_name ASC,last_name ASC,middle_name ASC")
    elsif params[:query] == "assign_Date_of_Birth"
    @student = Student.find_all_by_batch_id(params[:batch_id] ,:order => "date_of_birth ASC")
    else
    @student = Student.find_all_by_batch_id(params[:batch_id] ,:order => "admission_no ASC") 
    end
    
    @sorted_student = @student.sort{ |a,b| a.class_roll_no.downcase <=> b.class_roll_no.downcase }
    @sorted_student.each do |s|
      @sorted_roll_no << s.class_roll_no
    end
    @student.each_with_index do |f,i|
      # f.update_attribute('class_roll_no', @sorted_roll_no[i])
      f.update_attribute('class_roll_no', i+1)
    end
     @batch = Batch.find params[:batch_id], :include => [:students],:order => "students.first_name ASC ,students.last_name ASC, students.middle_name ASC"
     @batches = Batch.active
    response = { :batch => @batch, :batches => @batches}
    respond_to do |format|
      format.html { render :partial => 'assign_roll_no_to_batch'} 
      format.json  { render :json => response }
    end
  end
  
  def update
   logger.info "In student controller & action update ,the params are #{params}"
   unless params[:commit]== "Save"
   @student = Student.find(:last)  
    if @student.update_attributes(params[:student])
        if params[:student][:student_photo].blank?
          flash[:success] = t(:student_updated)
          redirect_to :action => 'student_wizard_next_step'
        else
          render :action => "student_wizard_next_step"
        end
    else
        render :action => 'student_wizard_next_step'
    end
    else
      @student = Student.find(:last)
      @guardian = Guardian.new(:first_name => params[:first_name],:last_name => params[:last_name],:relation => params[:relation],
      :dob => params[:dob], :education => params[:education],:occupation => params[:occupation],:income => params[:income],
      :office_phone1 => params[:office_phone1],:office_phone2 => params[:office_phone2],:mobile_phone => params[:mobile_phone],
      :office_address_line1 => params[:office_address_line1],:office_address_line2 => params[:office_address_line2],
      :city => params[:city],:state => params[:state],:email => params[:email], :country_id => params[:guardian][:country_id],:ward_id => @student.id)
          if @guardian.valid?
                if  @guardian.save 
                   Student.update(@student.id, :immediate_contact_id => @guardian.id)
                else
                    @error = true
                    @str = @guardian.errors.to_json
                end
          
          else
               @error = true
          end 
            respond_to do |format|
                 if @error.nil?
                   format.json { render :json => {:valid => true, :guardian => @guardian, :notice => "Guardian is successfully Created."}}
                 else
                    format.json { render :json => {:valid => false, :errors => @guardian.errors.full_messages}}
                 end    
              end  
    end
  end

  def get_guardian_id
    @student  = Student.find(params[:id])
    @parents = @student.guardians 
    render :partial => "immediate_contact" 
  end

  def update_immediate
    logger.info "In student controller & action update_immediate ,the params are #{params}"
    @student  = Student.find(params[:student_id])    
     respond_to do |format|
     if @student = Student.update(@student.id, :immediate_contact_id => params[:id])
         guardian = Guardian.find_by_id(@student.immediate_contact_id) unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
        format.json { render :json => {:valid => true, :guardian => guardian.full_name , :guardian_number => guardian.mobile_phone}}
      else
        @str = @student.errors.to_json
        format.json { render :json => {:valid => false, :errors => @student.errors}}
       end
      end
  end

  def my_profile 
   logger.info "In student controller & action my_profile ,the params are #{params}"
   @dir = []
   @user = current_user
   @student = Student.find_by_admission_no(params[:q])
   unless @student.nil?
     @attachements = Attachment.find_all_by_student_id(@student.id)
     unless @attachements.empty?
       @attachements.each do |at|
         @dir << at.dir_name unless @dir.include? at.dir_name
       end
       
     end
   @year = Date.today.year
   @batches = []
   @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
   @parents = @student.guardians
   @additional_fields = StudentAdditionalField.find(:all, :conditions=> {:status => true})
   @previous_data = StudentPreviousData.find_by_student_id(@student.id)
   @awardList = StudentAward.find_all_by_student_id(@student.id)
    # @student = Student.update(@student.id, :immediate_contact_id => params[:immediate_contact][:contact])
   @countries = Country.find(:all)
   @parent_info = Guardian.new(params[:parent_detail])
   @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")
   @immediate_contact = Guardian.find_by_id(@student.immediate_contact_id) unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
  else
    redirect_to :controller => 'sessions', :action => 'dashboard'
    flash[:notice] = t(:student_not_found)
  end
  end 
  
  
  
  def update_student_image
   logger.info "In student controller & action update_student_image ,the params are #{params}"
   @student = Student.find_by_admission_no(params[:q])
   @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")
   if @student.valid?
      respond_to do |format|
        if @student.update_attributes(params[:student]) 
           flash[:success] = t(:student_updated)
           format.html { redirect_to :action => 'image_crop', :q=> @student.admission_no}
           format.json { render :json => {:valid => true, :student => @student, :notice => t(:student_updated)}}
        else
            format.json { render :json => {:valid => false, :errors => @student.errors}}
        end
      end
    end    
  end
  
  def update_crop_image
    logger.info "In student controller & action update_crop_image ,the params are #{params}"
     @student = Student.find_by_admission_no(params[:q])
     respond_to do |format|
          if @student.update_attributes(params[:student])
            format.json {render :json => {:valid => true }}
            # flash[:notice] = t(:student_updated)
            # if params[:student][:student_photo].blank?
              # redirect_to @student
            # else
              # render :action => 'my_profile' ,:q => @student.admission_no
            # end
          else
            format.json {render :json => {:valid => false }}
            # render :action => 'my_profile',:q => @student.admission_no
          end
      end
  end
  
  def update_student
    logger.info "In student controller & action update_student ,the params are #{params}"
    unless params[:student]['first_name'].nil?
        student_first_name = params[:student]['first_name'].capitalize
        student_last_name = params[:student]['last_name'].capitalize  
        student_middle_name = params[:student]['middle_name'].capitalize 
        params[:student]['first_name'] = student_first_name
        params[:student]['last_name'] = student_last_name
        params[:student]['middle_name'] = student_middle_name
      end
    @student = Student.find_by_id(params[:id])
    @student_user = @student.user  
      if @student.valid?
              if @student.update_attributes(params[:student])  
                    if !@student_user.update_attributes(:email=> @student.email) 
                      @error = true 
                    end
              else
                @error = true 
              end
      else
        @error = true       
      end
    respond_to do |format|
      if @error.nil?
        format.json { render :json => {:valid => true, :student => @student.full_name, :notice => "#{@student.full_name} is sucessfully updated."}}
      else
        format.json { render :json => {:valid => false, :errors => @student.errors}}
      end
    end
  end
  
  def image_crop
    logger.info "In student controller & action image_crop ,the params are #{params}"
    @student = Student.find_by_admission_no(params[:q])
    render :partial => "student_image_crop"
  end
  
  def student_search  
   
    @query = "search"
   logger.info "In student controller & action student_search ,the params are #{params}"
   @batches = Batch.find(:all, :conditions => {:course_id => params[:q]})
   # render :layout => 'application'
   unless params[:query].nil?
  @query = params[:query]
  end
  end
  
  def change_batch 
   logger.info "In student controller & action change_batch ,the params are #{params}" 
   @course =Course.find(params[:q])
   @batches = @course.batches.active
   render :partial => 'batch'
  end

  def student_advanced_search
    logger.info "In student controller & action student_advanced_search ,the params are #{params}"
    if params.include?('query')
     @students = Student.find(:all, :conditions => {:batch_id => params[:query]})
    render :layout => false
    else
     data = params[:w].split(',')
      @batch_id = Batch.find(:all, :conditions => {:course_id => data[1]})
      @students = []
      if data[0].length>= 2
        @batch_id.each do |s|
           @students = Student.find(:all,
          :conditions => "(first_name LIKE \"%#{data[0]}%\"
                       OR middle_name LIKE \"%#{data[0]}%\"
                       OR last_name LIKE \"%#{data[0]}%\") AND batch_id = #{params[:batch_id]} ") unless data[0] == ''
        end
      end
      render :layout => false
    end
    
  end
  
  def update_guardian
    logger.info "In student controller & action update_guardian ,the params are #{params}"
    @student = Student.find params[:guardian][:ward_id], :include => [:guardians]
    @guardian = Guardian.find(params[:parent_id])
     respond_to do |format|
       if @guardian.update_attributes(params[:guardian])
         format.html { redirect_to @guardian, notice: t(:guardian_updated) }
         format.json { render :json => {:valid => true, :guardian => @guardian.id, :notice => t(:guardian_updated)}}
       else
        @str = @guardian.errors.to_json
        format.html { render action: "my_profile" }
        format.json { render :json => {:valid => false, :errors => @guardian.errors}}
      end
      end
  end
  
  def academic_report_all
    @user = current_user
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @course = @student.course
    @examtypes = ExaminationType.find( ( @course.examinations.collect { |x| x.examination_type_id } ).uniq )
    
    @graph = open_flash_chart_object(965, 350, "/student/graph_for_academic_report?course=#{@course.id}&student=#{@student.id}")
    @graph2 = open_flash_chart_object(965, 350, "/student/graph_for_annual_academic_report?course=#{@course.id}&student=#{@student.id}")
  end

  def admission1
    @student = Student.new(params[:student])
    @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")
    @last_admitted_student = Student.find(:last)
    @config = SchoolConfiguration.find_by_config_key('AdmissionNumberAutoIncrement')
    if request.post?
      if @config.config_value.to_i == 1
        @exist = Student.find_by_admission_no(params[:student][:admission_no])
        if @exist.nil?
          @status = @student.save
        else
          @last_admitted_student = Student.find(:last)
          @student.admission_no = @last_admitted_student.admission_no.next
          @status = @student.save
        end
      else
        @status = @student.save
      end
      if @status
        sms_setting = SmsSetting.new()
        if sms_setting.application_sms_active and @student.is_sms_enabled
          recipients = []
          message = "Student admission done. username is #{@student.admission_no} and password is #{@student.admission_no}123"
          if sms_setting.student_sms_active
            recipients.push @student.phone2 unless @student.phone2.blank?
          end
          unless recipients.empty?
            sms = SmsManager.new(message,recipients)
            sms.send_sms
          end
        end
        flash[:notice] = "Student Record Saved Successfully. Please fill the Parent Details."
        redirect_to :controller => "student", :action => "admission2", :id => @student.id
      end
    end
  end

  def admission2
    @student = Student.find params[:id], :include => [:guardians]
    @guardian = Guardian.new params[:guardian]
    if request.post? and @guardian.save
      redirect_to :controller => "student", :action => "admission2", :id => @student.id
    end
  end

  def admission3
    @student = Student.find(params[:id])
    @parents = @student.guardians
    if @parents.empty?
      redirect_to :controller => "student", :action => "previous_data", :id => @student.id
    end
    return if params[:immediate_contact].nil?
    if request.post?
      sms_setting = SmsSetting.new()
      @student = Student.update(@student.id, :immediate_contact_id => params[:immediate_contact][:contact])
      if sms_setting.application_sms_active and @student.is_sms_enabled
        recipients = []
        message = "Student admission done. username is #{@student.admission_no} and password is #{@student.admission_no}123"
        if sms_setting.parent_sms_active
          guardian = Guardian.find(@student.immediate_contact_id)
          recipients.push guardian.mobile_phone unless guardian.mobile_phone.nil?
        end
        unless recipients.empty?
          sms = SmsManager.new(message,recipients)
          sms.send_sms
        end
      end
      redirect_to :action => "previous_data", :id => @student.id
    end
  end

  def admission3_1
    @student = Student.find(params[:id])
    @parents = @student.guardians
    if @parents.empty?
      redirect_to :controller => "student", :action => "admission4", :id => @student.id
    end
    return if params[:immediate_contact].nil?
    if request.post?
      sms_setting = SmsSetting.new()
      @student = Student.update(@student.id, :immediate_contact_id => params[:immediate_contact][:contact])
      if sms_setting.application_sms_active and @student.is_sms_enabled
        recipients = []
        message = "Student admission done. username is #{@student.admission_no} and password is #{@student.admission_no}123"
        if sms_setting.parent_sms_active
          guardian = Guardian.find(@student.immediate_contact_id)
          recipients.push guardian.mobile_phone unless guardian.mobile_phone.nil?
        end
        unless recipients.empty?
          sms = SmsManager.new(message,recipients)
          sms.send_sms
        end
      end
      redirect_to :action => "profile", :id => @student.id
    end
  end

  def previous_data
    logger.info "In student controller & action previous_data ,the params are #{params}"
    @student = Student.find(params[:id])
    @previous_data = StudentPreviousData.new params[:student_previous_data]
    @previous_subject = StudentPreviousSubjectMark.find_all_by_student_id(@student)
    @previous_data_detail = StudentPreviousData.find_by_student_id(@student)
    if @previous_data_detail.nil?
    respond_to do |format|
          if @previous_data.save
             format.json { render :json => {:valid => true, :previous_data => @previous_data, :notice => t(:student_prev_data_updated)}}
          else  
            # format.html { render action: "save" }
            format.json { render :json => {:valid => false, :errors => @previous_data.errors}}
          end
     end
     else
       respond_to do |format|
          if @previous_data_detail.update_attributes(params[:student_previous_data])
             format.json { render :json => {:valid => true, :previous_data => @previous_data, :notice => t(:student_prev_data_updated)}}
          else   
            # format.html { render action: "save" }
            format.json { render :json => {:valid => false, :errors => @previous_data_detail.errors}}
          end
       end
     end
  end

  def previous_data_edit
    @student = Student.find(params[:id])
    @previous_data = StudentPreviousData.find_by_student_id(params[:id])
    @previous_subject = StudentPreviousSubjectMark.find_all_by_student_id(@student)
    if request.post?
      @previous_data.update_attributes(params[:previous_data])
      redirect_to :action => "show_previous_details", :id => @student.id
    end
  end

  def previous_subject
    @student = Student.find(params[:id])
    render(:update) do |page|
      page.replace_html 'subject', :partial=>"previous_subject"
    end
  end

  def save_previous_subject
    @previous_subject = StudentPreviousSubjectMark.new params[:student_previous_subject_details]
    @previous_subject.save
    #@all_previous_subject = StudentPreviousSubjectMark.find(:all,:conditions=>"student_id = #{@previous_subject.student_id}")
  end

  def delete_previous_subject
    @previous_subject = StudentPreviousSubjectMark.find(params[:id])
    @student =Student.find(@previous_subject.student_id)
    if@previous_subject.delete
      @previous_subject=StudentPreviousSubjectMark.find_all_by_student_id(@student.id)
    end
    #@all_previous_subject = StudentPreviousSubjectMark.find(:all,:conditions=>"student_id = #{@previous_subject.student_id}")
  end

  def admission4
    logger.info "In student controller & action admission4 ,the params are #{params}"
    @student = Student.find(params[:id]) 
    @additional_fields = StudentAdditionalField.find(:all, :conditions=> {:status => true})
    params[:student_additional_details].each_pair do |k, v|
      @stud_addi_det = StudentAdditionalDetails.find(:all , :conditions => {:student_id => @student.id, :additional_field_id => k})
    end     
    
    if @stud_addi_det.empty?
      StudentAdditionalDetails.destroy_all(:student_id => @student.id)
           params[:student_additional_details].each_pair do |k, v|
              StudentAdditionalDetails.create(:student_id => params[:id],
                :additional_field_id => k,:additional_info => v['additional_info'])
            end
            flash[:notice] = "Student records saved for #{@student.first_name} #{@student.last_name}."
    else
             params[:student_additional_details].each_pair do |k, v|    
                 @stud_addi_detail = StudentAdditionalDetails.find(:all , :conditions => {:additional_field_id => k , :student_id => @student.id})
                   @stud_addi_detail.each do |h|
                       h.update_attributes(:student_id => params[:id],
                          :additional_field_id => k,:additional_info => v['additional_info'])
                   end
             end
            flash[:notice] = "Student records updated for #{@student.first_name} #{@student.last_name}."
    end
  end

  def edit_admission4
    @student = Student.find(params[:id])
    @additional_fields = StudentAdditionalField.find(:all, :conditions=> "status = true")
    @additional_details = StudentAdditionalDetails.find_all_by_student_id(@student)
    
    if @additional_details.empty?
      redirect_to :controller => "student",:action => "admission4" , :id => @student.id
    end
    if request.post?
   
      params[:student_additional_details].each_pair do |k, v|
        row_id=StudentAdditionalDetails.find_by_student_id_and_additional_field_id(@student.id,k)
        unless row_id.nil?
          additional_detail = StudentAdditionalDetails.find_by_student_id_and_additional_field_id(@student.id,k)
          StudentAdditionalDetails.update(additional_detail.id,:additional_info => v['additional_info'])
        else
          StudentAdditionalDetails.create(:student_id=>@student.id,:additional_field_id=>k,:additional_info=>v['additional_info'])
        end
      end
      flash[:notice] = "Student #{@student.first_name} additional details updated"
      redirect_to :action => "profile", :id => @student.id
    end
  end
  def add_additional_details
    @additional_details = StudentAdditionalField.find(:all)
    @additional_field = StudentAdditionalField.new(params[:additional_field])
    if request.post? and @additional_field.save
      flash[:notice] = "Additional field created"
      redirect_to :controller => "student", :action => "add_additional_details"
    end
  end

  def edit_additional_details
    @additional_details = StudentAdditionalField.find(params[:id])
    if request.post? and @additional_details.update_attributes(params[:additional_details])
      flash[:notice] = "Additional details updated"
      redirect_to :action => "add_additional_details"
    end
  end

  def delete_additional_details
    students = StudentAdditionalDetails.find(:all ,:conditions=>"additional_field_id = #{params[:id]}")
    if students.blank?
      StudentAdditionalField.find(params[:id]).destroy
      @additional_details = StudentAdditionalField.find(:all)
      flash[:notice]="Successfully deleted!"
      redirect_to :action => "add_additional_details"
    else
      flash[:notice]="Sorry! Unable to delete when entries exists under the selected detail"
      redirect_to :action => "add_additional_details"
    end
  end

  def change_to_former
    if request.post?
      @student.archive_student(params[:remove][:status_description])
      render :update do |page|
        page.replace_html 'remove-student', :partial => 'student_tc_generate'
      end
    end
  end

  def generate_tc_pdf
    @student = ArchivedStudent.find_by_admission_no(params[:id])
    @father = ArchivedGuardian.find_by_ward_id(@student.id, :conditions=>"relation = 'father'")
    @mother = ArchivedGuardian.find_by_ward_id(@student.id, :conditions=>"relation = 'mother'")
    @immediate_contact = ArchivedGuardian.find_by_ward_id(@student.immediate_contact_id) \
      unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
    render :pdf=>'generate_tc_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
    #        respond_to do |format|
    #            format.pdf { render :layout => false }
    #        end
  end

  def generate_all_tc_pdf
    @ids = params[:stud]
    @students = @ids.map { |st_id| ArchivedStudent.find(st_id) }
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def destroy
    student = Student.find(params[:id])
    #user = User.destroy_all(:username => student.admission_no) unless user.nil?
    unless student.check_dependency
    student.user.destroy unless student.user.nil?
    Student.destroy(params[:id])
    flash[:notice] = "All records have been deleted for student with admission no. #{student.admission_no}."
    redirect_to :controller => 'user', :action => 'dashboard'
    else
    flash[:warn_notice] = "Sorry ! Could not delete student when dependent record exists."
      redirect_to  :action => 'remove', :id=>student.id
    end
  end

  def edit
    @student = Student.find(params[:id])
    @student_user = @student.user
    @student_categories = StudentCategory.active
    @batches = Batch.active
    @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")

    if request.post?
      unless params[:student][:image_file].blank?
        unless params[:student][:image_file].size.to_f > 280000
          if @student.update_attributes(params[:student])
            unless @student.changed.include?('admission_no')
              @student_user.update_attributes(:username=> @student.admission_no,:password => "#{@student.admission_no.to_s}123",:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
            else
              @student_user.update_attributes(:username=> @student.admission_no,:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
            end
            flash[:notice] = "Student's Record updated successfully!"
            redirect_to :controller => "student", :action => "profile", :id => @student.id
          end
        else
          flash[:notice] = "Image file size too large. Please upload an image with size less than 250KB."
          redirect_to :controller => "student", :action => "edit", :id => @student.id
        end
      else
        if @student.update_attributes(params[:student])
          unless @student.changed.include?('admission_no')
            @student_user.update_attributes(:username=> @student.admission_no,:password => "#{@student.admission_no.to_s}123",:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
          else
            @student_user.update_attributes(:username=> @student.admission_no,:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
          end
          flash[:notice] = "Student's Record updated successfully!"
          redirect_to :controller => "student", :action => "profile", :id => @student.id
        end
      end
    end
  end


  def edit_guardian
    @parent = Guardian.find(params[:id])
    @student = Student.find(@parent.ward_id)
    @countries = Country.all
    if request.post? and @parent.update_attributes(params[:parent_detail])
      flash[:notice] = "Parent Record updated!"
      redirect_to :controller => "student", :action => "guardians", :id => @student.id
    end
  end

  def email
    sender = current_user.email
    if request.post?
      recipient_list = []
      case params['email']['recipients']
      when 'Student'
        recipient_list << @student.email
      when 'Guardian'
        recipient_list << @student.immediate_contact.email unless @student.immediate_contact.nil?
      when 'Student & guardian'
        recipient_list << @student.email
        recipient_list << @student.immediate_contact.email unless @student.immediate_contact.nil?
      end
      recipients = recipient_list.join(', ')
      FedenaMailer::deliver_email(sender,recipients, params['email']['subject'], params['email']['message'])
      flash[:notice] = "Mail sent to #{recipients}"
      redirect_to :controller => 'student', :action => 'profile', :id => @student.id
    end
  end

  def exam_report
    @user = current_user
    @examtype = ExaminationType.find(params[:exam])
    @course = Course.find(params[:course])
    @student = Student.find(params[:student]) if params[:student]
    @student ||= @course.students.first
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @subjects = @course.subjects_with_exams
    @results = {}
    @subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, @examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, @student)
      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
    end
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_exam_report?course=#{@course.id}&examtype=#{@examtype.id}&student=#{@student.id}")
  end

  def update_student_result_for_examtype
    @student = Student.find(params[:student])
    @examtype = ExaminationType.find(params[:examtype])
    @course = @student.course
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @subjects = @course.subjects_with_exams
    @results = {}
    @subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, @examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, @student)
      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
    end
    @graph = open_flash_chart_object(770, 350, "/exam/graph_for_student_exam_result?course=#{@course.id}&examtype=#{@examtype.id}&student=#{@student.id}")
    render(:update) { |page| page.replace_html 'exam-results', :partial => 'student_result_for_examtype' }
  end

  def previous_years_marks_overview
    @student = Student.find(params[:student])
    @all_courses = @student.all_courses
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_previous_years_marks_overview?student=#{params[:student]}&graphtype=#{params[:graphtype]}")
  end

  def reports
    @highligh = params[:query]   
   logger.info "The params in student controller in action reports are #{params}"
   unless @student.nil?
    @batch = @student.batch
    @co_scholastic_assessments=StudentCoScholasticAssessment.find_all_by_batch_id(@batch.id)
    @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
    @aeg = AdditionalExamGroup.find_all_by_batch_id(@batch.id)
   @additional_exam = []
   unless @aeg.empty?
    @aeg.each do |a|
       if a.students_list.split(',').include?(@student.id.to_s)
    @additional_exam.push a
    end
    end
    end
    
    @normal_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>"no_exams = false AND elective_group_id IS NULL AND is_deleted = false")
    @student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id=>@batch.id})
    @elective_subjects = []
    @student_electives.each do |e|
      @elective_subjects.push Subject.find(e.subject_id)
    end
    @subjects = @normal_subjects+@elective_subjects
    @exam_groups = @batch.exam_groups
    @old_batches = @student.graduated_batches
   else
    redirect_to :controller => "sessions", :action => "dashboard"  
    flash[:notice] = t(:student_not_found)
   end
   
  end
   
  def search_ajax
    logger.info "The params in student controller in action search_ajax are #{params}"
    data = params[:query].split(',')
    if params[:query].include?("active")
      if data[0].length>= 2
        @students = Student.find(:all,
          :conditions => "(first_name LIKE \"%#{data[0]}%\"
                       OR middle_name LIKE \"%#{data[0]}%\"
                       OR last_name LIKE \"%#{data[0]}%\"
                       OR (concat(first_name, \" \", middle_name) LIKE \"#{data[0]}%\")
                       OR (concat(first_name, \" \", last_name) LIKE \"#{data[0]}%\")
                       OR (concat(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{data[0]}%\")
                       OR admission_no = '%#{data[0]}')",
          :order => "batch_id asc,first_name asc") unless data[0] == ''
      # else
        # @students = Student.find(:all,
          # :conditions => "(admission_no = '#{data[0]}')",
          # :order => "batch_id asc,first_name asc") unless data[0] == ''
      end
      render :partial=> "student_search"
    else
      if data[0].length>= 2
        @archived_students = ArchivedStudent.find(:all,
          :conditions => "(first_name LIKE \"%#{data[0]}%\"
                       OR middle_name LIKE \"%#{data[0]}%\"
                       OR last_name LIKE \"%#{data[0]}%\"
                       OR (concat(first_name, \" \", middle_name) LIKE \"#{data[0]}%\")
                       OR (concat(first_name, \" \", last_name) LIKE \"#{data[0]}%\")
                       OR (concat(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{data[0]}%\")
                       OR admission_no = '%#{data[0]}')",
          :order => "batch_id asc,first_name asc") unless data[0] == ''
      # else
        # @archived_students = ArchivedStudent.find(:all,
          # :conditions => "(admission_no = '#{data[0]}')",
          # :order => "batch_id asc,first_name asc") unless data[0] == ''
      end
      render :partial => "search_ajax"
    end
  end

  def student_annual_overview
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_student_annual_overview?student=#{params[:student]}&year=#{params[:year]}")
  end

  def subject_wise_report
    @student = Student.find(params[:student])
    @subject = Subject.find(params[:subject])
    @examtypes = @subject.examination_types
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_subject_wise_report_for_one_subject?student=#{params[:student]}&subject=#{params[:subject]}")
  end

  def add_guardian
    @parent_info = Guardian.new(params[:guardian])
    @countries = Country.all
     respond_to do |format|
                if  @parent_info.save
                   # format.html { redirect_to :action => 'my_profile', notice: 'Guardian is successfully Created.' }
                   flash[:notice] = 'Guardian is successfully Created.'
                   format.json { render :json => {:valid => true, :guardian => @parent_info, :notice => t(:guardian_created)}}
                else
                    @str = @parent_info.errors.to_json
                    format.html { render action: "my_profile" }
                    format.json { render :json => {:valid => false, :errors => @parent_info.errors}}
                end
     end 
  end

  def list_students_by_course
    @students = Student.find_all_by_batch_id(params[:batch_id], :order => 'first_name ASC')
    render(:update) { |page| page.replace_html 'students', :partial => 'students_by_course' }
  end

  def profile
    @current_user = current_user
    @address = @student.address_line1.to_s + ' ' + @student.address_line2.to_s
    @additional_fields = StudentAdditionalField.all(:conditions=>"status = true")
    @sms_module = SchoolConfiguration.available_modules
    @sms_setting = SmsSetting.new
    @previous_data = StudentPreviousData.find_by_student_id(@student.id)
    @immediate_contact = Guardian.find(@student.immediate_contact_id) \
      unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
  end
  
  def profile_pdf
    logger.info "The params in student controller in action profile_pdf are #{params}"
    @current_user = current_user
    @student = Student.find_by_id(params[:id])
    unless @student.nil?
    @address = @student.address_line1.to_s + ' ' + @student.address_line2.to_s
    @additional_fields = StudentAdditionalField.all(:conditions=>"status = true")
    @sms_module = SchoolConfiguration.available_modules
    @sms_setting = SmsSetting.new
    @previous_data = StudentPreviousData.find_by_student_id(@student.id)
    @immediate_contact = Guardian.find(@student.immediate_contact_id) \
      unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
        
    render :pdf=>'profile_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
    else
    redirect_to :controller => "sessions", :action => "dashboard"  
    flash[:notice] = t(:student_not_found)
    end
  end

  def show_previous_details
    @previous_data = StudentPreviousData.find_by_student_id(@student.id)
    @previous_subjects = StudentPreviousSubjectMark.find_all_by_student_id(@student.id)
  end
  
  # def show
    # @student = Student.find_by_admission_no(params[:id])
    # send_data(@student.student_photo_data,
      # :type => @student.student_photo_content_type,
      # :filename => @student.student_photo_filename,
      # :disposition => 'inline')
  # end

  def guardians
    @parents = @student.guardians
  end

  def del_guardian
    logger.info "The params in student controller in action del_guardian are #{params}"
    @guardian = Guardian.find(params[:id])
    @student = @guardian.ward
    if @guardian.is_immediate_contact?
      respond_to do |format| 
        format.json { render :json => {:valid => false, :notice => t(:guardian_not_deleted)}}
        flash[:notice] = t(:guardian_not_deleted)
        # redirect_to :controller => 'student', :action => 'save', :id => @student.id
      end
    else
     respond_to do |format|
      if @guardian.destroy
        format.json { render :json => {:valid => true,  :notice => t(:guardian_deleted)}}
        flash[:notice] = t(:guardian_deleted)
        # redirect_to :controller => 'student', :action => 'save', :id => @student.id
      end
      end
    end
  end

  def academic_pdf
    @course = @student.old_courses.find_by_academic_year_id(params[:year]) if params[:year]
    @course ||= @student.course
    @subjects = Subject.find_all_by_course_id(@course, :conditions => "no_exams = false")
    @examtypes = ExaminationType.find( ( @course.examinations.collect { |x| x.examination_type_id } ).uniq )

    @arr_total_wt = {}
    @arr_score_wt = {}

    @subjects.each do |s|
      @arr_total_wt[s.name] = 0
      @arr_score_wt[s.name] = 0
    end

    @course.examinations.each do |x|
      @arr_total_wt[x.subject.name] += x.weightage
      ex_score = ExaminationResult.find_by_examination_id_and_student_id(x.id, @student.id)
      @arr_score_wt[x.subject.name] += ex_score.marks * x.weightage / x.max_marks unless ex_score.nil?
    end

    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def categories
    @student_categories = StudentCategory.active
    @student_category = StudentCategory.new(params[:student_category])
    if request.post? and @student_category.save
      flash[:notice] = "Student category has been saved."
      redirect_to :action => 'categories'
    end
  end

  def category_delete
      if Student.find_all_by_student_category_id(params[:id]).blank?
          StudentCategory.update(params[:id], :is_deleted=>true)
          @student_categories = StudentCategory.find(:all,:active,:conditions => { :is_deleted => false})
      else
          redirect_to :action=>'notdelete'
      end
      @student_categories = StudentCategory.active
  end

  def category_edit
    @student_category = StudentCategory.find(params[:id])
  end

  def category_update
    @student_category = StudentCategory.find(params[:id])
    @student_category.update_attribute(:name, params[:name])
    @student_categories = StudentCategory.active
  end

  def view_all
    @batches = Batch.active
  end

  def advanced_search
    @batches = Batch.all
    @search = Student.search(params[:search])
    if params[:search]
      unless params[:advv_search][:course_id].empty?
        if params[:search][:batch_id_equals].empty?
          batches = Batch.find_all_by_course_id(params[:advv_search][:course_id]).collect{|b|b.id}
        end
      end
      if batches.is_a?(Array)

        @students = []
        batches.each do |b|
          params[:search][:batch_id_equals] = b
          if params[:search][:is_active_equals]=="true"
            @search = Student.search(params[:search])
            @students+=@search.all
          elsif params[:search][:is_active_equals]=="false"
            @search = ArchivedStudent.search(params[:search])
            @students+=@search.all
          else
            @search1 = Student.search(params[:search]).all
            @search2 = ArchivedStudent.search(params[:search]).all
            @students+=@search1+@search2
          end
        end
        params[:search][:batch_id_equals] = nil
      else
        if params[:search][:is_active_equals]=="true"
          @search = Student.search(params[:search])
          @students = @search.all
        elsif params[:search][:is_active_equals]=="false"
          @search = ArchivedStudent.search(params[:search])
          @students = @search.all
        else
          @search1 = Student.search(params[:search]).all
          @search2 = ArchivedStudent.search(params[:search]).all
          @students = @search1+@search2
        end
      end
    end
  end

  def advanced_search_pdf
    @student_ids = params[:result]
    @status = params[:status]
    @searched_for = params[:for]
    @students = []
    if params[:status]=="true"
      @search = Student.search(params[:search])
      @students = @search.all
    elsif params[:status]=="false"
      @search = ArchivedStudent.search(params[:search])
      @students = @search.all
    else
      @search1 = Student.search(params[:search]).all
      @search2 = ArchivedStudent.search(params[:search]).all
      @students = @search1+@search2
    end
    render :pdf=>'generate_tc_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
         
  end

  #  def new_adv
  #    if params[:adv][:option] == "present"
  #      @search = Student.search(params[:search])
  #      @students = @search.all
  #    end
  #  end

  def electives
    @batch = Batch.find(params[:id])
    @elective_subject = Subject.find(params[:id2])
    @students = @batch.students
    @elective_group = ElectiveGroup.find(@elective_subject.elective_group_id)
  end

  def assign_students
    @student = Student.find(params[:id])
    StudentsSubject.create(:student_id=>params[:id],:subject_id=>params[:id2],:batch_id=>@student.batch_id)
    @student = Student.find(params[:id])
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html "stud_#{params[:id]}", :partial=> 'unassign_students'
    end
  end

  def assign_all_students
    @batch = Batch.find(params[:id])
    @students = @batch.students
    @students.each do |s|
      @assigned = StudentsSubject.find_by_student_id_and_subject_id(s.id,params[:id2])
      StudentsSubject.create(:student_id=>s.id,:subject_id=>params[:id2],:batch_id=>@batch.id) if @assigned.nil?
    end
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html 'category-list', :partial=>"all_assign"
    end
  end

  def unassign_students
    StudentsSubject.find_by_student_id_and_subject_id(params[:id],params[:id2]).delete
    @student = Student.find(params[:id])
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html "stud_#{params[:id]}", :partial=> 'assign_students'
    end
  end

  def unassign_all_students
    @batch = Batch.find(params[:id])
    @students = @batch.students
    @students.each do |s|
      @assigned = StudentsSubject.find_by_student_id_and_subject_id(s.id,params[:id2])
      @assigned.delete unless @assigned.nil?
    end
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html 'category-list', :partial=>"all_assign"
    end
  end

  def fees

    @student = Student.find_by_id(params[:id])
    @dates = FinanceFeeCollection.find_all_by_batch_id(@student.batch_id ,:joins=>'INNER JOIN finance_fees ON finance_fee_collections.id = finance_fees.fee_collection_id',:conditions=>"finance_fees.student_id = #{@student.id} and finance_fee_collections.is_deleted = 0")
    if request.post?
      @student.update_attributes(:has_paid_fees=>params[:fee][:has_paid_fees]) unless params[:fee].nil?
      @student.has_paid_fees = params[:fee][:has_paid_fees]
    end
  end

  def fee_details
    @student = Student.find_by_id(params[:id])
    @date  = FinanceFeeCollection.find(params[:id2])
    @financefee = @student.finance_fee_by_date @date
    @fee_collection = FinanceFeeCollection.find(params[:id2])
    @due_date = @fee_collection.due_date

    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end

    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted = false"])
    @fee_particulars = @fee_collection.fees_particulars(@student)
    @currency_type = nil

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


  
  #  # Graphs
  #
  #  def graph_for_previous_years_marks_overview
  #    student = Student.find(params[:student])
  #
  #    x_labels = []
  #    data = []
  #
  #    student.all_courses.each do |c|
  #      x_labels << c.name
  #      data << student.annual_weighted_marks(c.academic_year_id)
  #    end
  #
  #    if params[:graphtype] == 'Line'
  #      line = Line.new
  #    else
  #      line = BarFilled.new
  #    end
  #
  #    line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    title = Title.new(student.full_name)
  #
  #    x_legend = XLegend.new("Academic year")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Total marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #
  #    chart.add_element(line)
  #
  #    render :text => chart.to_s
  #  end
  #
  #  def graph_for_student_annual_overview
  #    student = Student.find(params[:student])
  #    course = Course.find_by_academic_year_id(params[:year]) if params[:year]
  #    course ||= student.course
  #    subs = course.subjects
  #    exams = Examination.find_all_by_subject_id(subs, :select => "DISTINCT examination_type_id")
  #    etype_ids = exams.collect { |x| x.examination_type_id }
  #    examtypes = ExaminationType.find(etype_ids)
  #
  #    x_labels = []
  #    data = []
  #
  #    examtypes.each do |et|
  #      x_labels << et.name
  #      data << student.examtype_average_marks(et, course)
  #    end
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    line = BarFilled.new
  #
  #    line.width = 1
  #    line.colour = '#5E4725'
  #    line.dot_size = 5
  #    line.values = data
  #
  #    y = YAxis.new
  #    y.set_range(0,100,20)
  #
  #    title = Title.new('Title')
  #
  #    x_legend = XLegend.new("Examination name")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Average marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.set_x_legend(x_legend)
  #    chart.set_y_legend(y_legend)
  #    chart.y_axis = y
  #    chart.x_axis = x_axis
  #
  #    chart.add_element(line)
  #
  #    render :text => chart.to_s
  #  end
  #
  #  def graph_for_subject_wise_report_for_one_subject
  #    student = Student.find params[:student]
  #    subject = Subject.find params[:subject]
  #    exams = Examination.find_all_by_subject_id(subject.id, :order => 'date asc')
  #
  #    data = []
  #    x_labels = []
  #
  #    exams.each do |e|
  #      exam_result = ExaminationResult.find_by_examination_id_and_student_id(e, student.id)
  #      unless exam_result.nil?
  #        data << exam_result.percentage_marks
  #        x_labels << XAxisLabel.new(exam_result.examination.examination_type.name, '#000000', 10, 0)
  #      end
  #    end
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    line = BarFilled.new
  #
  #    line.width = 1
  #    line.colour = '#5E4725'
  #    line.dot_size = 5
  #    line.values = data
  #
  #    y = YAxis.new
  #    y.set_range(0,100,20)
  #
  #    title = Title.new(subject.name)
  #
  #    x_legend = XLegend.new("Examination name")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.set_x_legend(x_legend)
  #    chart.set_y_legend(y_legend)
  #    chart.y_axis = y
  #    chart.x_axis = x_axis
  #
  #    chart.add_element(line)
  #
  #    render :text => chart.to_s
  #  end
  #
  #  def graph_for_exam_report
  #    student = Student.find(params[:student])
  #    examtype = ExaminationType.find(params[:examtype])
  #    course = student.course
  #    subjects = course.subjects_with_exams
  #
  #    x_labels = []
  #    data = []
  #    data2 = []
  #
  #    subjects.each do |s|
  #      exam = Examination.find_by_subject_id_and_examination_type_id(s, examtype)
  #      res = ExaminationResult.find_by_examination_id_and_student_id(exam, student)
  #      unless res.nil?
  #        x_labels << s.name
  #        data << res.percentage_marks
  #        data2 << exam.average_marks * 100 / exam.max_marks
  #      end
  #    end
  #
  #    bargraph = BarFilled.new()
  #    bargraph.width = 1;
  #    bargraph.colour = '#bb0000';
  #    bargraph.dot_size = 5;
  #    bargraph.text = "Student's marks"
  #    bargraph.values = data
  #
  #    bargraph2 = BarFilled.new
  #    bargraph2.width = 1;
  #    bargraph2.colour = '#5E4725';
  #    bargraph2.dot_size = 5;
  #    bargraph2.text = "Class average"
  #    bargraph2.values = data2
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    title = Title.new(student.full_name)
  #
  #    x_legend = XLegend.new("Academic year")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Total marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #    chart.y_legend = y_legend
  #    chart.x_legend = x_legend
  #
  #    chart.add_element(bargraph)
  #    chart.add_element(bargraph2)
  #
  #    render :text => chart.render
  #  end
  #
  #  def graph_for_academic_report
  #    student = Student.find(params[:student])
  #    course = student.course
  #    examtypes = ExaminationType.find( ( course.examinations.collect { |x| x.examination_type_id } ).uniq )
  #    x_labels = []
  #    data = []
  #    data2 = []
  #
  #    examtypes.each do |e_type|
  #      total = 0
  #      max_total = 0
  #      exam = Examination.find_all_by_examination_type_id(e_type.id)
  #      exam.each do |t|
  #        res = ExaminationResult.find_by_examination_id_and_student_id(t.id, student.id)
  #        total += res.marks
  #        max_total += res.maximum_marks
  #      end
  #      class_max =0
  #      class_total = 0
  #      exam.each do |t|
  #        res = ExaminationResult.find_all_by_examination_id(t.id)
  #        res.each do |res|
  #          class_max += res.maximum_marks
  #          class_total += res.marks
  #        end
  #      end
  #      class_avg = (class_total*100/class_max).to_f
  #      percentage = ((total*100)/max_total).to_f
  #      x_labels << e_type.name
  #      data << percentage
  #      data2 << class_avg
  #    end
  #
  #    bargraph = BarFilled.new()
  #    bargraph.width = 1;
  #    bargraph.colour = '#bb0000';
  #    bargraph.dot_size = 5;
  #    bargraph.text = "Student's average"
  #    bargraph.values = data
  #
  #    bargraph2 = BarFilled.new
  #    bargraph2.width = 1;
  #    bargraph2.colour = '#5E4725';
  #    bargraph2.dot_size = 5;
  #    bargraph2.text = "Class average"
  #    bargraph2.values = data2
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    x_legend = XLegend.new("Examinations")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Percentage")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #    chart.y_legend = y_legend
  #    chart.x_legend = x_legend
  #
  #    chart.add_element(bargraph)
  #    chart.add_element(bargraph2)
  #
  #    render :text => chart.render
  #  end
  #
  #  def graph_for_annual_academic_report
  #    student = Student.find(params[:student])
  #    student_all = Student.find_all_by_course_id(params[:course])
  #    total = 0
  #    sum = student_all.size
  #    student_all.each { |s| total += s.annual_weighted_marks(s.course.academic_year_id) }
  #    t = (total/sum).to_f
  #
  #    x_labels = []
  #    data = []
  #    data2 = []
  #
  #    x_labels << "Annual report".to_s
  #    data << student.annual_weighted_marks(student.course.academic_year_id)
  #    data2 << t
  #
  #    bargraph = BarFilled.new()
  #    bargraph.width = 1;
  #    bargraph.colour = '#bb0000';
  #    bargraph.dot_size = 5;
  #    bargraph.text = "Student's average"
  #    bargraph.values = data
  #
  #    bargraph2 = BarFilled.new
  #    bargraph2.width = 1;
  #    bargraph2.colour = '#5E4725';
  #    bargraph2.dot_size = 5;
  #    bargraph2.text = "Class average"
  #    bargraph2.values = data2
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    x_legend = XLegend.new("Examinations")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Weightage")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #    chart.y_legend = y_legend
  #    chart.x_legend = x_legend
  #
  #    chart.add_element(bargraph)
  #    chart.add_element(bargraph2)
  #
  #    render :text => chart.render
  #
  #  end
 
 def subject_list
   @subjects = Subject.find_all_by_batch_id(params[:batch_id],:conditions=>{:is_deleted =>false})
 end
 
 def my_pals
   @students = Student.find_all_by_batch_id(params[:batch_id],:conditions=>{:is_deleted =>false})
 end 
 
 def send_email
   FedenaMailer::deliver_email('puja@ezzie.in','puja@ezzie.in','hi','hello')
   flash[:notice] = "Mail sent!"
   redirect_to :controller => 'student', :action => 'my_profile', :id => '1'
 end
 
 def my_meetings
   @student = Student.find_by_admission_no(params[:q])
   @batch=Batch.find params[:batch_id]
   @old_batches = @student.graduated_batches
   @recent_meetings = PtmMaster.find_all_by_batch_id(params[:batch_id])
 end
 
 def student_meeting_details
   @student = Student.find_by_id(params[:student])
   ptm_master= params[:ptm_master]
   @ptm_detail= PtmDetail.find_all_by_student_id_and_ptm_master_id(@student.id,ptm_master)
   render :partial => 'student_meeting_details'
 end
 
 def report_index
  
 end
 def view_report_index
   @type = params[:type]
   render :partial=>'view_report_index'
  
 end
 def view_report
  type=params[:type]
  query=params[:query]
  if type=='gender' && query=="all"
    render :partial=>'gender_all'
  else if type=='gender' && query=="course"
    render :partial=>'gender_course'
     else if type=='gender' && query=="Batch"
       @batches=[]
     render :partial=>'gender_batch'
     else if type=='religion' && query=="all"
       render :partial=>'religion_all'
       else if type=='religion' && query=="course"
       render :partial=>'religion_course'
       else if type=='religion' && query=="Batch"
         @batches=[]
       render :partial=>'religion_batch'
       else if type=='category' && query=="all"
         @student_categories=StudentCategory.find(:all,:conditions=>{:is_deleted=>false})
       render :partial=>'category_all'
       else if type=='category' && query=="course"
          @student_categories=StudentCategory.find(:all,:conditions=>{:is_deleted=>false})
       render :partial=>'category_course'
       else if type=='category' && query=="Batch"
         @batches=[]
          @student_categories=StudentCategory.find(:all,:conditions=>{:is_deleted=>false})
       render :partial=>'category_batch'
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
 
 def get_all_gender_report
   @criteria=params[:query]
   @table_type='gender'
   @students= Student.find_all_by_gender(params[:query])
  render :partial=>'get_all_gender_report'
 end
 def get_all_religion_report
     @criteria=params[:query]
  
   @table_type='religion'
    @students= Student.find_all_by_religion(params[:query])
  render :partial=>'get_all_gender_report'
 end
 
 def get_all_category_report
     @criteria=params[:query]
   
 @table_type='category'
   @students= Student.find_all_by_student_category_id(params[:query])
  render :partial=>'get_all_gender_report'
 end
 def get_gender_course_report
   @gender=params[:gender]
   @course=params[:course]
  @table_type='gender'
  @students=""
   batches=Batch.find(:all,:conditions=>{:course_id=>params[:course]})
   unless batches.empty?
    students=[]
  
   batches.each_with_index do |batch|
      student=Student.find_all_by_batch_id_and_gender(batch.id,params[:gender])
    students= students + student
   end
   end
   @students=students
   render :partial=>'get_all_gender_report'
 end
 
 def get_religion_course_report
   
    @gender=params[:religion]
    @course=params[:course]
   @table_type='religion'
   @students=""
   batches=Batch.find(:all,:conditions=>{:course_id=>params[:course]})
   unless batches.empty?
    students=[]
   batches.each_with_index do |batch|
     student=Student.find_all_by_batch_id_and_religion(batch.id,params[:religion])
    students= students + student
   end
   end
    @students=students
   render :partial=>'get_all_gender_report'
 end
 
  def get_category_course_report
    @gender=params[:category]
    @course=params[:course]
    @table_type='category'
   @students=""
   batches=Batch.find(:all,:conditions=>{:course_id=>params[:course]})
   unless batches.empty?
    students=[]
   batches.each_with_index do |batch|
    student=Student.find_all_by_batch_id_and_student_category_id(batch.id,params[:category])
    students= students + student
   end
   end
     @students=students
   render :partial=>'get_all_gender_report'
 end

def get_religion_batch_report
  @batch=params[:batch]
  @gender=params[:religion]
   @table_type='religion'
   @students=Student.find_all_by_batch_id_and_religion(params[:batch],params[:religion])
  render :partial=>'get_all_gender_report'
end
def get_gender_batch_report
  @batch=params[:batch]
  @gender=params[:gender]
  @table_type='gender'
  @students=Student.find_all_by_batch_id_and_gender(params[:batch],params[:gender])
  render :partial=>'get_all_gender_report'
 end
 def get_category_batch_report
  @batch=params[:batch]
  @gender=params[:category]
   @table_type='category'
  @students=Student.find_all_by_batch_id_and_student_category_id(params[:batch],params[:category])
  render :partial=>'get_all_gender_report'
 end
 
 def change_student_batch
   @batches=Batch.find_all_by_course_id(params[:course])
   render :partial=>'change_student_batch'
 end
 
 def change_student_course_batch
   @batches=Batch.find_all_by_course_id(params[:course])
    render :partial=>'change_student_course_batch'
 end
 
  def change_student_category_batch
   @batches=Batch.find_all_by_course_id(params[:course])
    render :partial=>'change_student_category_batch'
  end
 
 def pdf_report
   @table_type=params[:filter]
   if @table_type =='gender'
     gender=""
     if params[:query]=='M' || params[:gender]=='M'
      gender='Male'
      else if   params[:query]=='F' || params[:gender]=='F'
        gender='Female'
      end
      end
    if params[:course].nil? && params[:batch].nil?
       @title = "Students List:- Gender wise/all/#{gender}"
     @students= Student.find_all_by_gender(params[:query])
    else if params[:course].nil?
      batch=Batch.find_by_id(params[:batch])
      @title = "Students List:- Gender wise/#{batch.full_name unless batch.nil?}/#{gender}"
      @students=Student.find_all_by_batch_id_and_gender(params[:batch],params[:gender])
       else
         course=Course.find_by_id(params[:course])
          @title = "Students List:- Gender wise/#{course.course_name unless course.nil?}/#{gender}"
      @students=""
     batches=Batch.find(:all,:conditions=>{:course_id=>params[:course]})
     unless batches.empty?
      students=[]
     batches.each_with_index do |batch|
       student=Student.find_all_by_batch_id_and_gender(batch.id,params[:gender])
      students= students + student
     end
     end
      @students=students
      end
     end
else if @table_type=='religion'
     if params[:course].nil? && params[:batch].nil?
        @title = "Student List:- Religion wise/all/#{params[:query]}"
     @students= Student.find_all_by_religion(params[:query])
     else if params[:course].nil?
       batch=Batch.find_by_id(params[:batch])
      @title = "Student List:- Religion wise/#{batch.full_name unless batch.nil?}/#{params[:gender]}"
      @students=Student.find_all_by_batch_id_and_religion(params[:batch],params[:gender])
      else
        course=Course.find_by_id(params[:course])
          @title = "Student List:- Religion wise/#{course.course_name unless course.nil?}/#{params[:gender]}"
      @students=""
     batches=Batch.find(:all,:conditions=>{:course_id=>params[:course]})
     unless batches.empty?
      students=[]
     batches.each_with_index do |batch|
       student=Student.find_all_by_batch_id_and_religion(batch.id,params[:gender])
      students= students + student
     end
     end
      @students=students
     end
     end
else if @table_type=='category'
   if params[:course].nil? && params[:batch].nil?
      @title = "Student List:- Category wise/all/#{params[:query]}"
     @students= Student.find_all_by_student_category_id(params[:query])
     else if params[:course].nil?
       batch=Batch.find_by_id(params[:batch])
       s_category=StudentCategory.find_by_id(params[:gender])
      @title = "Student List:- Category wise/#{batch.full_name unless batch.nil?}/#{s_category.name unless s_category.nil?}"
      @students=Student.find_all_by_batch_id_and_student_category_id(params[:batch],params[:gender])
     else
       course=Course.find_by_id(params[:course])
       s_category=StudentCategory.find_by_id(params[:gender])
          @title = "Student List:- Category wise/#{course.course_name unless course.nil?}/#{s_category.name unless s_category.nil?}"
      @students=""
     batches=Batch.find(:all,:conditions=>{:course_id=>params[:course]})
     unless batches.empty?
      students=[]
     batches.each_with_index do |batch|
       student=Student.find_all_by_batch_id_and_student_category_id(batch.id,params[:gender])
      students= students + student
     end
     end
      @students=students
     end
     end
end
end
end


     render :pdf => 'pdf_report',:page_size=> 'A4',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:background=> true
 end
 
 def employee_report_center
   @department=params[:id]
   @employees=Employee.find_all_by_employee_department_id(params[:id])
   render :partial=>'get_employee_report'
 end
 
 def employee_pdf_report
   @title=EmployeeDepartment.find_by_id(params[:department]).name
   @employees=Employee.find_all_by_employee_department_id(params[:department])
   render :pdf => 'employee_pdf_report',:page_size=> 'A4',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 35,
                    :bottom => 20,
                    :left=> 20,
                    :right => 20},:disposition  => "attachment"
 end
 
 def system_reports

 end
 
 def student_pdf
   @courses = Course.active
   all_batches = Batch.active
   @batches = all_batches.reject!{|x| x.students.blank?}
   @students_list = []
   @batch_array = ""
   @all_student = Student.all
   if request.post?
       @students_list = []
       unless params[:batch_ids].nil?
           params[:batch_ids].each do |i|
             if @batch_array == ""
               @batch_array = @batch_array + i.to_s
             else
               @batch_array = @batch_array + "," + i.to_s
             end
           @students_list << Student.find_all_by_batch_id(i)
           end
       else
       @batch_array = ""
       @students_list = []  
       end 
       render :partial => 'student_details'
   end
 end
 
  def print_student_pdf_details
  @batch_array=  params[:batch_ids].split(',')
   @students = []
   unless params[:batch_ids].nil?
       @batch_array.each do |i|
       @students << Student.find_all_by_batch_id(i)
       end
   else
        @students = []  
   end
    respond_to do |format|
      if params[:type] == "pdf"
         format.html {render :pdf => 'print_student_pdf_details',:page_size=> 'A4',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 35,
                        :bottom => 20,
                        :left=> 20,
                        :right => 20},:disposition  => "attachment"}
      else
         format.xls
      end
    end
 end
 
 def report_card_index
   @course=Course.find(:all,:conditions=>{:is_deleted=>false})
   @batches=[]
 end
 
 def update_batch
   
    @batches = Batch.find_all_by_course_id(params[:id], :conditions => { :is_deleted => false, :is_active => true })

    render :partial=>'update_batch'
 end
 def report_card
   
 end
 def particular_student
   @students=Student.find_all_by_batch_id(params[:batch])
   render :partial=>'particular_student'
   
 end
 
 def print_id_card
   @student = Student.find_by_id(params[:id])
   puts @student.student_photo.url(:large)
   respond_to do |format|
         format.html {render :pdf => 'print_id_card',:page_size=> 'A4',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 35,
                        :bottom => 20,
                        :left=> 20,
                        :right => 20}}
      end
 end
 
  private
  def find_student
    @student = Student.find_by_admission_no(params[:q])
  end
end
