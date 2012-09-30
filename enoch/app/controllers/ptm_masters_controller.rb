class PtmMastersController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  def index
    @user = current_user
    @ptm_masters = PtmMaster.all
    if @user.employee == true
      @employee = @user.employee_record
      @batches = employee_batches(@employee)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ptm_masters }
    end
  end

  # GET /ptm_masters/1
  # GET /ptm_masters/1.json
  def show
    unless params.include?("history")
      @ptm_masters = PtmMaster.find_all_by_is_active(true,:conditions => {:batch_id => params[:id]})
      @batch = Batch.find_by_id(params[:id])
      render :partial => 'show'
    else
      @ptm_masters = PtmMaster.find_all_by_is_active(false,:conditions => {:batch_id => params[:id]})
      @batch = Batch.find_by_id(params[:id])
      render :partial => 'show'
    end
  end

  # GET /ptm_masters/new
  # GET /ptm_masters/new.json
  def new
    @ptm_master = PtmMaster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ptm_master }
    end
  end

  # GET /ptm_masters/1/edit
  def edit
    @ptm_master = PtmMaster.find(params[:id])
  end

  # POST /ptm_masters
  # POST /ptm_masters.json
  def create
    recipients = nil
    sms_setting = SmsSetting.new()
    @batch = Batch.find_by_id(params[:ptm_master][:batch_id])
    @students = []
    params[:student_id].each do |s|
      @students << Student.find_by_id(s)
    end
    @ptm_master = PtmMaster.new(params[:ptm_master])
    respond_to do |format|
      unless params.include?('create_event')
        if @ptm_master.save
          reminder = Reminder.create(:sender=> current_user.id,:sent_to => @batch.full_name,
          :subject=>"#{@ptm_master.title}",
          :body=>"#{@ptm_master.description} <br/><br/><br/> Start date : " + @ptm_master.ptm_start_date.strftime("%d/%m/%Y %I:%M %p") + " <br/><br/><br/> End date : " + @ptm_master.ptm_end_date.strftime("%d/%m/%Y %I:%M %p"))
          @students.each do |s|
            student_user = s.user
            unless student_user.nil?
              if sms_setting.application_sms_active and s.is_sms_enabled and sms_setting.ptm_sms_active and params[:sms_send] == "true"
                unless s.immediate_contact.nil? || s.immediate_contact.mobile_phone.nil?

                recipients =  sms_setting.create_recipient(s.immediate_contact.mobile_phone,recipients)
                else
                  unless s.phone2.nil?
                  recipients =  sms_setting.create_recipient(s.phone2,recipients)
                  end
                end
              end
              ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
            end
          end
          message = "Dear Parents, Parent Teacher Meeting is going to be held on #{@ptm_master.ptm_start_date} . Principal, MCSCHD"
          
          response =  sms_setting.send_sms(message,recipients)
          
           if response == "something went worng"
           
            format.json { render :json => {:valid => true, :notice =>  " #{t(:ptm_master_created)}But sms can't be send due some error in sms service" }}
          else
            format.json { render :json => {:valid => true, :notice => t(:ptm_master_created)}}
          end
         
        else
          format.json { render :json => {:valid => false, :errors => @ptm_master.errors}}
        end
      else
        if @ptm_master.save
          @event = Event.create(:title => @ptm_master.title,:description => @ptm_master.description,:start_date => @ptm_master.ptm_start_date, :end_date => @ptm_master.ptm_end_date)
          @batch_event = BatchEvent.create(:event_id => @event.id, :batch_id => params[:ptm_master][:batch_id])
          @student = Student.find_all_by_batch_id(params[:ptm_master][:batch_id])
          reminder = Reminder.create(:sender=> current_user.id,:sent_to => @batch.full_name,
          :subject=>"#{@ptm_master.title}",
          :body=>"#{@ptm_master.description} <br/><br/><br/> Start date : " + @ptm_master.ptm_start_date.strftime("%d/%m/%Y %I:%M %p") + " <br/><br/><br/> End date : " + @ptm_master.ptm_end_date.strftime("%d/%m/%Y %I:%M %p"))
          @student.each do |s|
            student_user = s.user
            unless student_user.nil?
              if sms_setting.application_sms_active and s.is_sms_enabled and sms_setting. ptm_sms_active and params[:sms_send] == "true"
                unless s.immediate_contact.nil? || s.immediate_contact.mobile_phone.nil?
                recipients =  sms_setting.create_recipient(s.immediate_contact.mobile_phone,recipients)
                else
                  unless s.phone2.nil?
                  recipients =  sms_setting.create_recipient(s.phone2,recipients)
                  end
                end
              end
              ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
            end
          end
          message = "Dear Parents, Parent Teacher Meeting is going to be held on #{@ptm_master.ptm_start_date} . Principal, MCSCHD"
          response = sms_setting.send_sms(message,recipients)
          
          if response == "something went worng"
            
            format.json { render :json => {:valid => true, :notice => t(:ptm_master_created) + " But sms can't be send due some error in sms service" }}
          else
            format.json { render :json => {:valid => true, :notice => t(:ptm_master_created)}}
          end
        else
          format.json { render :json => {:valid => false, :errors => @ptm_master.errors}}
        end
      end
    end
  end

  # PUT /ptm_masters/1
  # PUT /ptm_masters/1.json
  def update
    @user = current_user
    @ptm_master = PtmMaster.find(params[:id])
    @students = Student.find_all_by_batch_id(@ptm_master.batch_id)
    respond_to do |format|
      if params[:create_event] == "false"
        if @ptm_master.update_attributes(params[:ptm_master])
          @previous_event = Event.find_by_id(@ptm_master.event_id)
          unless @previous_event.nil?
            @batch_event =  BatchEvent.find_all_by_event_id(@previous_event.id)
            @batch_event.each do |batch_event|
              batch_event.delete
            end
            if @previous_event.delete
              @ptm_master.update_attributes(:event_id => "")
            end
          end
          reminder = Reminder.create(:sender=> current_user.id,:sent_to => @ptm_master.batch.full_name,
          :subject=>"#{@ptm_master.title}",
          :body=>"<p><b>Parent Teacher Meeting has been Updated</b><br /><br/>
                     <strong>PTM Description : </strong>#{@ptm_master.description}<br /><br/>
                                Start date :"+@ptm_master.ptm_start_date.strftime("%d/%m/%Y %I:%M %p")+"<br />"+
          " End date :"+@ptm_master.ptm_end_date.strftime("%d/%m/%Y %I:%M %p")+"<br />"+
          "<br /><br /><br />Regards,<br/>"+@user.full_name.capitalize)

          @students.each do |s|
            student_user = s.user
            ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
          end
          format.json { render :json => {:valid => true, :notice => "Ptm is Updated Successfully"}}
        else
          format.json { render :json => {:valid => false, :errors => @ptm_master.errors}}
        end
      else
        if @ptm_master.update_attributes(params[:ptm_master])
          @previous_event = Event.find_by_id(@ptm_master.event_id)
          if @previous_event.nil?
            event = Event.create(:title => @ptm_master.title,:description => @ptm_master.description,:start_date => @ptm_master.ptm_start_date, :end_date => @ptm_master.ptm_end_date)
            batch_event = BatchEvent.create(:event_id => event.id, :batch_id => @ptm_master.batch_id)
            @ptm_master.update_attributes(:event_id => event.id)
          else
            @previous_event.update_attributes(:title => @ptm_master.title,:description => @ptm_master.description,:start_date => @ptm_master.ptm_start_date, :end_date => @ptm_master.ptm_end_date)
          end
          reminder = Reminder.create(:sender=> current_user.id,:sent_to => @ptm_master.batch.full_name,
          :subject=>"#{@ptm_master.title}",
          :body=>"<p><b>Parent Teacher Meeting has been Updated</b><br /><br/>
                     <strong>PTM Description : </strong>#{@ptm_master.description}<br /><br/>
                                Start date :"+@ptm_master.ptm_start_date.strftime("%d/%m/%Y %I:%M %p")+"<br />"+
          " End date :"+@ptm_master.ptm_end_date.strftime("%d/%m/%Y %I:%M %p")+"<br />"+
          "<br /><br /><br />Regards,<br/>"+@user.full_name.capitalize)
          @students.each do |s|
            student_user = s.user
            ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
          end
          format.json { render :json => {:valid => true, :notice => "Ptm is Updated Successfully"}}
        else
          format.json { render :json => {:valid => false, :errors => @ptm_master.errors}}
        end
      end
    end
  end

  # DELETE /ptm_masters/1
  # DELETE /ptm_masters/1.json
  def destroy
    @ptm_master = PtmMaster.find(params[:id])
    @ptm_master.destroy

    respond_to do |format|
      format.html { redirect_to ptm_masters_url }
      format.json { head :ok }
    end
  end

  def ptm_student
    @ptm_master = PtmMaster.new
    begin
      @batch =Batch.find(params[:q])
    rescue Exception => e
      redirect_to :controller => 'sessions',:action => 'dashboard'
    end
    render :partial => 'ptm_students'
  end

end
