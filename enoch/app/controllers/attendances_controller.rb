class AttendancesController < ApplicationController
  filter_access_to :all
  before_filter :login_required
  # before_filter :only_assigned_employee_allowed
  include SmsManagerHelper
  include AttendancesHelper
   
  def index
    @user = current_user
    if @user.admin == true
    @batches = []
    elsif @user.employee == true
    @employee = @user.employee_record
    @batches = employee_batches(@employee)
    end
  end
  

  def subject_wise_attendance
    @batches = []
    @subjects = []
  end

  def list_subject
    @batch = Batch.find(params[:batch_id])
    @subjects = Subject.where("elective_group_id IS NOT NULL").find_all_by_batch_id(@batch.id)
    render :partial=> 'subjects'
    # if @current_user.employee? and @allow_access ==true and !@current_user.privileges.map{|m| m.id}.include?(16)
      # @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
    # end
    # render(:update) do |page|
      # page.replace_html 'subjects', :partial=> 'subjects'
    # end
  end
  
  def attendance_change_batch  
   @batches = Batch.find(:all, :conditions => {:course_id => params[:q], :is_active => true ,:is_deleted => false})
   render :partial => 'batch_attendance'
  end
  
  def attendance_subject_wise_change_batch  
   @batches = Batch.find(:all, :conditions => {:course_id => params[:q], :is_active => true,:is_deleted => false})
   render :partial => 'subject_wise_batch'
  end
  
  
  def show
    @absents = []
    # @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')  
      unless params[:period_entry_date].nil?
        @today = params[:period_entry_date].to_date
      else
        @today = Date.today
      end
      start_date = @today.beginning_of_month
      end_date = @today.end_of_month
    if params[:subject_id] == nil
      @batch = Batch.find(params[:batch_id])
      @students = Student.find_all_by_batch_id(@batch.id)
      @dates = PeriodEntry.find_all_by_batch_id(@batch.id, :conditions =>{:month_date => start_date..end_date}, :order=>'month_date asc')
    else
      @sub =Subject.find params[:subject_id]
      @batch = @sub.batch_id
      @students = Student.find_all_by_batch_id(@batch)
      @dates = PeriodEntry.find_all_by_batch_id_and_subject_id(@batch,@sub.id,  :conditions =>{:month_date => start_date..end_date},:order=>'month_date ASC')    
    end
    period_entry_date = (params[:period_entry_date].to_date).strftime('%Y''-''%m''-''%d')

    period_id = PeriodEntry.find_by_month_date_and_batch_id(period_entry_date, @batch) 
    
    unless period_id.nil?
    @students.each do |stu|
       @absents << Attendance.find_by_student_id_and_period_table_entry_id(stu.id, period_id.id)
    end
    absentS_id = []
   @absents.each do |ab|
     if ab!= nil
      absentS_id << ab.student_id
     end
   end
    respond_to do |format|
      student = []
      studentId = []
      student_id = []
      admissionNo = []
      rollNo = []
      lastName = []
      dates = []
      datesId = []
      absentee = []
      @dates.each do |d|
        dates << (d.month_date).strftime('%d''-''%m''-''%Y')
        datesId << d.id
      end
     @students.each do |s|
       student << s.full_name
       studentId << s.id
       admissionNo << s.admission_no
       lastName << s.last_name
     end
      @students.each do |a|
        rollNo << a.class_roll_no
        @dates.each do |b|
          @absentee = Attendance.find_all_by_student_id_and_period_table_entry_id(a.id, b.id)
          @absentee.each do |u|
                @periodss = PeriodEntry.find_all_by_id(u.period_table_entry_id)   
                  @periodss.each do |v|
                  absentee << (v.month_date).strftime('%d''-''%m''-''%Y')
                  end
                @studentsp = Student.find_all_by_id(u.student_id)
                  @studentsp.each do |w|
                        student_id << w.id    
                  end
          end
        end
      end
        format.json { render :json => {:valid => false,:today =>@today.strftime('%d''-''%m''-''%Y'),:absentS_id => absentS_id,:rollNo => rollNo, :absentee => absentee, :student => student,:studentId => studentId,:student_id => student_id, :admission_no => admissionNo ,:last_name => lastName,:dates => dates,:datesId => datesId}}
    end
    else
       respond_to do |format|    
          format.json { render :json => {:valid => true, :notice => "Period entry not found."}}
       end
    end
  end

  def new
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    @absentee = Attendance.new
    @student = Student.find(params[:id2])
    @period_entry_id = params[:id]
    respond_to do |format|
      format.js { render :action => 'new' }
    end
  end

  def create
    recipients = nil
    sms_setting = SmsSetting.new()
   
    unless params[:attendance][:student_id] == nil
      
    @student = []
    @deletedId_are = []
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    params[:attendance][:student_id].each do |s|
        if s!=nil
        @student << Student.find(s)
        end
    end
    period_entry = (params[:attendance]['period_table_entry_id'].to_date).strftime('%Y''-''%m''-''%d')
     @student.each do |de|
       @deletedId_are << de.id
     end
    @period_ettntry = PeriodEntry.find_by_month_date_and_batch_id(period_entry, params[:batch_id],:order=>'month_date asc')
    @teams = Attendance.where("student_id NOT IN (?)", @deletedId_are).find(:all , :conditions => {:period_table_entry_id => @period_ettntry})
    @all_student = Student.find_all_by_batch_id(params[:batch_id])

        if !@teams.nil?
         @teams.each do |as|
             @all_student.each do |sd|
                if sd == as.student   
                 student_attendance = Attendance.find_by_student_id_and_period_table_entry_id(sd.id,@period_ettntry)
                 student_attendance.destroy 
                end
            end
          end
        end
      @student.each do |a|
          params[:attendance]['student_id'] = a.id
          params[:attendance]['period_table_entry_id'] = period_entry
          @period_entry = PeriodEntry.find_by_month_date_and_batch_id(params[:attendance][:period_table_entry_id],params[:batch_id],:order=>'month_date asc')
         if @period_entry!=nil
          params[:attendance]['period_table_entry_id'] = @period_entry.id
          @absentee = Attendance.new(params[:attendance])
          
            if @absentee.save
                if sms_setting.application_sms_active and a.is_sms_enabled and sms_setting.attendance_sms_active
                     unless a.immediate_contact.nil? || a.immediate_contact.mobile_phone.nil?
                        recipients =  sms_setting.create_recipient(a.immediate_contact.mobile_phone,recipients)
                     else
                          unless a.phone2.nil?
                            recipients =  sms_setting.create_recipient(a.phone2,recipients)
                          end
                      end
                end  
                    @students = Student.find_all_by_batch_id(params[:batch_id])
                        unless params[:next].nil?
                          @today = params[:next].to_date
                        else
                          @today = Date.today
                        end
                        start_date = @today.beginning_of_month
                        end_date = @today.end_of_month
                        @dates = PeriodEntry.find_all_by_batch_id(params[:batch_id], :conditions =>{:month_date => start_date..end_date},:order=>'month_date ASC')
                        
           
           else
                flash[:notice] = "Attendance can not be marked."      
           end
           end
     end
      message = "Dear Parent, Your ward was absent in the class on #{@period_entry.month_date}. Regards MCSCHD"
     response = sms_setting.send_sms(message,recipients)
     if response == "something went worng"
       respond_to do |format|    
          format.json { render :json => {:valid => true, :notice => "Attendance Marked sucessfully. But sms can't be send due some error in sms service" }}
       end
     else
      respond_to do |format|    
          format.json { render :json => {:valid => true, :notice => "Attendance Marked sucessfully."}}
       end
     end  
    else
      @delete_absent = []
      period_entry = (params[:attendance]['period_table_entry_id'].to_date).strftime('%Y''-''%m''-''%d')
      period_entry_id = PeriodEntry.find_by_month_date_and_batch_id(period_entry,params[:batch_id])
      @students = Student.find_all_by_batch_id(params[:batch_id])
      @students.each do |des|
        if des != nil
         @delete_absent << Attendance.find_by_period_table_entry_id_and_student_id(period_entry_id,des)
       end
      end
      @delete_absent.each do |delete_attendance|
        if delete_attendance != nil
          delete_attendance.destroy
        end
      end
      
      
      
      respond_to do |format| 
          format.json { render :json => {:valid => true, :notice => "Attendance Marked Successfully."}}
      end
    end
end

  def create_subject_wise_attendance
    unless params[:attendance][:student_id] == nil
    @student = []
    @deletedId_are = []
    @period_ettntry = []
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    params[:attendance][:student_id].each do |s|
        if s != nil
        @student << Student.find(s)
        end
    end
    period_entry = (params[:attendance]['period_table_entry_subject_wise_id'].to_date).strftime('%Y''-''%m''-''%d')
    
     @student.each do |de|
       @deletedId_are << de.id
     end
     
    params[:batch_id].each do |bi|
    @period_ettntry << PeriodEntrySubjectWise.find_by_month_date_and_subject_id(period_entry, params[:subject_id],:order=>'month_date asc')
       @period_ettntry.each do |pei|
          @teams = AttendanceSubjectWise.where("student_id NOT IN (?)", @deletedId_are).find(:all , :conditions => {:period_table_entry_subject_wise_id => pei})
          @all_student = Student.find_all_by_batch_id(bi)
            if !@teams.nil?
             @teams.each do |as|
                 @all_student.each do |sd|        
                    if sd == as.student               
                     @ss = AttendanceSubjectWise.find_by_student_id_and_period_table_entry_subject_wise_id(sd.id,pei)
                     @ss.destroy 
                    end
                 end
             end
           end
       end
      @student.each do |a|
          params[:attendance]['student_id'] = a.id
          params[:attendance]['period_table_entry_subject_wise_id'] = period_entry
          @period_entry = PeriodEntrySubjectWise.find_by_month_date_and_subject_id(params[:attendance][:period_table_entry_subject_wise_id],params[:subject_id],:order=>'month_date asc')
         if @period_entry!=nil
          params[:attendance]['period_table_entry_subject_wise_id'] = @period_entry.id
            params[:attendance]['batch_id'] = a.batch_id
          @absentee = AttendanceSubjectWise.new(params[:attendance])
          
            if @absentee.save
              @students = Student.find_all_by_batch_id(bi)
                    unless params[:next].nil?
                      @today = params[:next].to_date
                    else
                      @today = Date.today
                    end
                    start_date = @today.beginning_of_month
                    end_date = @today.end_of_month
                    @dates = PeriodEntrySubjectWise.find_all_by_batch_id(bi, :conditions =>{:month_date => start_date..end_date},:order=>'month_date ASC')
           else
                flash[:notice] = "Attendance can not be marked."      
           end
           end
     end
 end
      respond_to do |format|    
          format.json { render :json => {:valid => true, :notice => "Attendance Marked Sucessfully."}}
       end
    else
      @delete_absent = []
      @students = []
      period_entry = (params[:attendance]['period_table_entry_subject_wise_id'].to_date).strftime('%Y''-''%m''-''%d')
      period_entry_id = PeriodEntrySubjectWise.find_by_month_date(period_entry)
      params[:batch_id].each do |bi|
      @students = Student.find_all_by_batch_id(bi)
      @students.each do |des|
        if des != nil
         @delete_absent << AttendanceSubjectWise.find_by_period_table_entry_subject_wise_id_and_student_id(period_entry_id,des.id)
       end
      end
      @delete_absent.each do |delete_attendance|
        if delete_attendance != nil
        delete_attendance.destroy
        end
      end
      end
      respond_to do |format| 
          format.json { render :json => {:valid => true, :notice => "Attendance Marked Successfully."}}
      end
    end
end



 def show_subject_wise
    @absents = []
    @student_subjet_wise = []
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')  
      unless params[:period_entry_date].nil?
        @today = params[:period_entry_date].to_date
      else
        @today = Date.today
      end
      start_date = @today.beginning_of_month
      end_date = @today.end_of_month
      @sub =Subject.find params[:subject_id]
      @batch = @sub.batch_id
      @students = StudentsSubject.find_all_by_subject_id(@sub)
      @dates = PeriodEntrySubjectWise.find_all_by_batch_id_and_subject_id(@batch,@sub.id,  :conditions =>{:month_date => start_date..end_date},:order=>'month_date ASC')    
      period_entry_date = (params[:period_entry_date].to_date).strftime('%Y''-''%m''-''%d')
      period_id = PeriodEntrySubjectWise.find_by_month_date_and_batch_id(period_entry_date, @batch) 
    
    @students.each do |sb|
      @student_subjet_wise << Student.find_by_id(sb.student_id)
    end
 
    @student_subjet_wise.each do |stu|
       @absents << AttendanceSubjectWise.find_by_student_id_and_period_table_entry_subject_wise_id(stu, period_id)
    end

    absentS_id = []
    absents_batch_id = []
       @absents.each do |ab|
             if ab!= nil
             absentS_id << ab.student_id
             absents_batch_id << ab.batch_id
             end
       end
    respond_to do |format|
      student = []
      studentId = []
      admissionNo = []
      rollNo = []
      batchName = []
      batchId = []
      dates = []
      datesId = []
      absentee = []
      @dates.each do |d|
        dates << (d.month_date).strftime('%d''-''%m''-''%Y')
        datesId << d.id
      end
             @student_subjet_wise.each do |s|
               student << s.full_name
               studentId << s.id
               admissionNo << s.admission_no
               rollNo << s.class_roll_no
               batchName << s.batch.name
               batchId << s.batch_id
             end  
             format.json { render :json => {:valid => false,:today =>@today.strftime('%d''-''%m''-''%Y'),:student => student, :admission_no => admissionNo,
               :rollNo => rollNo,:studentId => studentId,:batchName => batchName,:batchId => batchId,:absentS_id => absentS_id,:absents_batch_id => absents_batch_id,:period_id =>period_id}}
     end

  end





def edit
  @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
  @absentee = Attendance.find params[:id]
  @student = Student.find(@absentee.student_id)
  respond_to do |format|
    format.html { }
    format.js { render :action => 'edit' }
  end
end

def update
  @absentee = Attendance.find params[:id]
  @student = Student.find(@absentee.student_id)
  @period_entry = PeriodEntry.find @absentee.period_table_entry_id

    if @absentee.update_attributes(params[:attendance])
      @batch = @student.batch
      @students = Student.find_all_by_batch_id(@batch.id)
      unless params[:next].nil?
        @today = params[:next].to_date
      else
        @today = Date.today
      end
      start_date = @today.beginning_of_month
      end_date = @today.end_of_month
      @dates = PeriodEntry.find_all_by_batch_id(@batch.id, :conditions =>{:month_date => start_date..end_date},:order=>'month_date ASC')
    else
      @error = true
  end
  respond_to do |format|
      format.js { render :action => 'update' }
    end
end


def destroy
  @absentee = Attendance.find params[:id]
  @absentee.delete
  @student = Student.find(@absentee.student_id)
  @period_entry = PeriodEntry.find @absentee.period_table_entry_id
  respond_to do |format|
    @batch = @student.batch
    @students = Student.find_all_by_batch_id(@batch.id)
    unless params[:next].nil?
      @today = params[:next].to_date
    else
      @today = Date.today
    end
    start_date = @today.beginning_of_month
    end_date = @today.end_of_month
    @dates = PeriodEntry.find_all_by_batch_id(@batch.id, :conditions =>{:month_date => start_date..end_date},:order=>'month_date ASC')
    format.js { render :action => 'update' }
  end
end

  def multiple_attendance
     @date = Date.today.strftime("%d-%m-%Y")
     @active_batches = []
     @month_name = {}
     ((current_session.start_date)..(current_session.end_date)).each do |s|
       @month_name["#{s.to_date.strftime("%B")} , #{s.to_date.strftime("%Y")} "] = "#{s.to_date.strftime("%Y-%m-01")}"
     end
     
     start_date = @date.to_date.beginning_of_month
     end_date = @date.to_date.end_of_month
     current_period_entry =  PeriodEntry.find(:all, :conditions => ["date(month_date) BETWEEN ? AND ? ", "#{start_date}","#{end_date}"],:order => 'month_date DESC' )
     current_period_entry.each do |cpe|
       @active_batches << cpe.batch unless @active_batches.include? cpe.batch
     end
     @period_entries = []
     @batches  = [] 
     if request.post?
        unless params.include?('batch')
          period_entry = PeriodEntry.find_all_by_month_date(params[:date].to_date)
            period_entry.each do |pe|
             @batches.push << pe.batch unless @batches.include? pe.batch
            end
          render :partial => 'multiple_attendance'
        else
            unless params[:month].blank?
              new_start_date = params[:month].to_date.beginning_of_month
              new_end_date = params[:month].to_date.end_of_month
              @period_entries =  PeriodEntry.find_all_by_batch_id(params[:batch], :conditions => ["date(month_date) BETWEEN ? AND ? ", "#{new_start_date}","#{new_end_date}"],:order => 'month_date ASC' )
              else
              @period_entries = []  
              end
            render :partial => 'multiple_batch_attendance'
        end
     else
        period_entry = PeriodEntry.find_all_by_month_date(Date.today)
            period_entry.each do |pe|
             @batches.push << pe.batch unless @batches.include? pe.batch
            end
     end
  end

  def multiple_attendance_save
    no_roll_no = []
    no_batch = []
    future_date = []
    arry = []
    all_attendances = Attendance.find(:all)
    unless params[:batches].nil?
     params[:batches].split(',').each_with_index do |f , i|
        f.each_with_index do |d,k|
         batch = Batch.find_by_id(d)
         period_entry = PeriodEntry.find_by_month_date_and_batch_id(params[:date].to_date, batch.id)
         arry << period_entry unless arry.include? period_entry
         roll_no = params[:roll_nos].split(',')[i][k].split(',')
         attendances = Attendance.find_all_by_period_table_entry_id period_entry.id
         @allP = PeriodEntry.find_all_by_month_date(params[:date].to_date)
         roll_no.each do |roll|
           unless roll.blank?
            student = Student.find_by_class_roll_no_and_batch_id(roll.gsub( /\W/, '' ),batch.id)
            unless student.nil?
                unless attendances.empty?
                      attendances.each do |a|
                            unless roll_no.include? a.student.class_roll_no.to_s 
                              a.delete unless a.nil?
                            end
                       end
                 end 
                 unless period_entry.month_date.to_date > Date.today  
                    @attendance = Attendance.new
                    @attendance.student_id = student.id
                    @attendance.period_table_entry_id = period_entry.id
                    @attendance.forenoon = false
                    @attendance.afternoon = false
                    @attendance.save
                 else
                    future_date << period_entry.month_date.to_date unless future_date.include?(period_entry.month_date.to_date)
                    str = " attendance cann't be marked for future date #{future_date}"
                    @not_found_error = { :student => [*str]}
                    @error = true 
                 end
                 
              else
                  @attendance = Attendance.new
                  no_roll_no << roll
                  no_batch << batch.full_name unless no_batch.include? batch.full_name
                  str = " not found with roll no #{no_roll_no} in batch #{no_batch}"
                  @not_found_error = { :student => [*str]}
                  @error = true 
              end
           end # unless attendances loop ended
         end # roll_no loop ended
          
       end
     end
     else
       allP = PeriodEntry.find_all_by_month_date(params[:date].to_date)
         allP.each do |d|
           all_attendances.each do |att|
             if att.period_table_entry_id == d.id
               att.delete
             end
           end
         end
     end
       (@allP - arry).each_with_index do |h, v|
              a_t = Attendance.find_all_by_period_table_entry_id(h.id)
              unless a_t.empty?
                a_t.each do |s|
                  s.delete unless s.nil?
                end
              end
      end
     respond_to do |format|
       if @error.nil?
        format.json { render :json => {:valid => true, :notice => "Attendance Marked Successfully"}}
       else
        format.json { render :json => {:valid => false, :errors => @not_found_error}}  
       end
     end
  end


  def multiple_attendance_save_batch_wise
    no_roll_no = []
    no_batch = []
    no_date = []
    future_date = []
    all_attendances = Attendance.find(:all)
    unless params[:period_entries].nil?
     params[:period_entries].split(',').each_with_index do |f , i|
        f.each_with_index do |d,k|
         period_entry = PeriodEntry.find_by_id(d)
         batch = Batch.find_by_id(period_entry.batch_id)
         roll_no = params[:roll_nos].split(',')[i][k].split(',')
         attendances = Attendance.find_all_by_period_table_entry_id period_entry.id
         roll_no.each do |roll|
           unless roll.blank?
            student = Student.find_by_class_roll_no_and_batch_id(roll.gsub( /\W/, '' ),batch.id)
            unless student.nil?
                unless attendances.empty?
                  attendances.each do |a|
                    unless roll_no.include? a.student.class_roll_no.to_s 
                      a.delete unless a.nil?
                    end
                    limP = PeriodEntry.find_all_by_batch_id(params[:batch], :conditions => ["date(month_date) BETWEEN ? AND ? ", "#{period_entry.month_date.to_date.beginning_of_month}","#{period_entry.month_date.to_date.end_of_month}"],:order => 'month_date ASC' )
                       limP.each do |p_e|
                         unless params[:period_entries].include?(p_e.id.to_s)
                          a_t = Attendance.find_all_by_period_table_entry_id(p_e.id)
                          unless a_t.empty?
                               a_t.each do |s|
                                  s.delete unless s.nil?
                               end
                             end
                         end
                       end
                  end
                end 
                unless period_entry.month_date.to_date > Date.today  
                  @attendance = Attendance.new
                  @attendance.student_id = student.id
                  @attendance.period_table_entry_id = period_entry.id
                  @attendance.forenoon = false
                  @attendance.afternoon = false
                  @attendance.save
                else
                  future_date << period_entry.month_date.to_date unless future_date.include?(period_entry.month_date.to_date)
                  str = " attendance cann't be marked for future date #{future_date}"
                  @not_found_error = { :student => [*str]}
                  @error = true 
                end
              else
                  @attendance = Attendance.new
                  no_roll_no << roll
                  no_batch << batch.full_name unless no_batch.include? batch.full_name
                  no_date << period_entry.month_date.strftime("%Y-%m-%d") unless no_date.include? period_entry.month_date.strftime("%Y-%m-%d")
                  str = " not found with roll no #{no_roll_no} in batch #{no_batch} on #{no_date}"
                  @not_found_error = { :student => [*str]}
                  @error = true 
              end
           end # unless attendances loop ended
         end # roll_no loop ended
       end
     end
     else
       allP = PeriodEntry.find_all_by_batch_id(params[:batch])
         allP.each do |d|
           all_attendances.each do |att|
             if att.period_table_entry_id == d.id
               att.delete
             end
           end
         end
     end
     respond_to do |format|
       if @error.nil?
        format.json { render :json => {:valid => true, :notice => "Attendance Marked Successfully"}}
       else
        format.json { render :json => {:valid => false, :errors => @not_found_error}}  
       end
     end
  end

end
