

class AttendanceReportsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  # before_filter :only_assigned_employee_allowed

  def index
    @batches =  []
    @year = Date.today.year
    # @batches = Batch.active
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
  end

  def attendance_report_batch
   @batches = Batch.find(:all, :conditions => {:course_id => params[:q], :is_active => true})
   render :partial => 'batch_for_attendance_report'
  end
 
  def subject
    @batch = Batch.find params[:batch_id]

    if @current_user.employee? and @allow_access ==true
      @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
    else
      @subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>'is_deleted = false')
    end

    render :update do |page|
      page.replace_html 'subject', :partial => 'subject'
    end
  end

  def mode
    @batch = Batch.find params[:batch_id]
    unless params[:subject_id] == ''
      @subject = params[:subject_id]
    else
      @subject = 0
    end
    render :update do |page|
      page.replace_html 'mode', :partial => 'mode'
      page.replace_html 'month', :text => ''
    end
  end
  
  def show
    @batch = Batch.find params[:data][:advance_search][:batch_id]
    @mode = params[:data][:advance_search][:mode]
    
     @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
              if @mode == 'Overall'
                @start_date = @batch.start_date.to_date
                @end_date = Date.today.to_date
                @students = Student.find_all_by_batch_id(@batch.id)
                    unless params[:data][:advance_search][:subject_id] == '0'
                      @students = Student.find_all_by_batch_id(@batch.id)
                      @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
                    else
                      @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
                    end
                    
                     total =0 
                 @total_attendance = 0 
                 working_days = @report.size
                 @students.each do |student| 
                  leaves =0 
                    @report.each do |report|
                        @attendance = Attendance.find_by_student_id_and_period_table_entry_id(student.id, report.id) 
                          unless @attendance.nil?
                               leaves += 1
                               
                          end                     
                            total = (working_days - leaves).to_f 
                    end 
                 @total_attendance+=total
                 end   
          unless @total_attendance== 0   
                  @percentage_absent =   ((@total_attendance.to_f/(working_days.to_f*@students.size.to_f))*100).to_i
                  end 
                    render :partial => 'report'
              else
                @month = params[:data][:advance_search][:month]
                @year = params[:data][:advance_search][:year]
                @start_date = "01-#{@month}-#{@year}".to_date
                @today = Date.today
                @students = Student.find_all_by_batch_id(@batch.id)
                @end_date = @start_date.end_of_month
                if @end_date > Date.today
                  @end_date = Date.today
                end
                    unless params[:data][:advance_search][:subject_id].empty?
                      
                      @subject = Subject.find params[:data][:advance_search][:subject_id]
                      @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
                    else
                      @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
                    end  
          
                 total =0 
                 @total_attendance = 0 
                 working_days = @report.size
                 @students.each do |student| 
                  leaves =0 
                 
                  
                    @report.each do |report|
                        @attendance = Attendance.find_by_student_id_and_period_table_entry_id(student.id, report.id) 
                          unless @attendance.nil?
                               leaves += 1
                               
                          end                     
                            total = (working_days - leaves).to_f 
                    end 
                 @total_attendance+=total
                 end 
                unless @total_attendance== 0         
                  @percentage_absent =  ( (@total_attendance.to_f/(working_days.to_f*@students.size.to_f))*100).to_i
                end
                render :partial => 'report'
              end
                  

  end
  
  
  def year
    @batch = Batch.find params[:batch_id]
    @subject = params[:subject_id]
    if request.xhr?
      @year = Date.today.year
      @month = params[:month]
      render :update do |page|
        page.replace_html 'year', :partial => 'year'
      end
    end
  end

  def report
    @batch = Batch.find params[:batch_id]
    @month = params[:month]
    @year = params[:year]
    @students = Student.find_all_by_batch_id(@batch.id)
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    #    @date = "01-#{@month}-#{@year}"
    @date = '01-'+@month+'-'+@year
    @start_date = @date.to_date
    @today = Date.today
    unless @start_date > Date.today
      if @month == @today.month.to_s
        @end_date = Date.today
      else
        @end_date = @start_date.end_of_month
      end
      
      if @config.config_value == 'Daily'
        @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
      else
        unless params[:subject_id] == '0'
          @subject = Subject.find params[:subject_id]
          @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
        else
          @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
        end
      end
    else
      @report = ''
    end
    render :update do |page|
      page.replace_html 'report', :partial => 'report'
    end
  end

  def student_details
    @student = Student.find params[:id]
    @report = Attendance.find_all_by_student_id(@student.id)
  end

  def filter
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    @batch = Batch.find(params[:filter][:batch])
    @students = Student.find_all_by_batch_id(@batch.id)
    @start_date = (params[:filter][:start_date]).to_date
    @end_date = (params[:filter][:end_date]).to_date
    @range = (params[:filter][:range])
    @value = (params[:filter][:value])
    if request.post?
      unless @config.config_value == 'Daily'
        unless params[:filter][:subject] == '0'
          @subject = Subject.find params[:filter][:subject]
        end
        if params[:filter][:subject] == '0'
          @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
        else
          @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
        end
      else
        @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
      end
    end
  end

  def advance_search
    @batches = []
  end

  def report_pdf
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    @batch = Batch.find(params[:filter][:batch])
    @students = Student.find_all_by_batch_id(@batch.id)
    @start_date = (params[:filter][:start_date]).to_date
    @end_date = (params[:filter][:end_date]).to_date
    @range = (params[:filter][:range])
    @value = (params[:filter][:value])
    @students = Student.find_all_by_batch_id(@batch.id)
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    unless @start_date > Date.today
      if @config.config_value == 'Daily'
        @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
      else
        unless params[:filter][:subject] == '0'
          @subject = Subject.find params[:filter][:subject]
          @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
        else
          @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
        end
      end
    else
      @report = ''
    end
    render :pdf => 'report_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
             
#    render :layout=>'pdf'
#    respond_to do |format|
#      format.pdf { render :layout => false }
#    end
  end

  def filter_report_pdf
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    @batch = Batch.find(params[:filter][:batch])
    @students = Student.find_all_by_batch_id(@batch.id)
    @start_date = (params[:filter][:start_date]).to_date
    @end_date = (params[:filter][:end_date]).to_date
    @range = (params[:filter][:range])
    @value = (params[:filter][:value])
    if request.post?
      unless @config.config_value == 'Daily'
        unless params[:filter][:subject] == '0'
          @subject = Subject.find params[:filter][:subject]
        end
        if params[:filter][:subject] == '0'
          @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
        else
          @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
        end
      else
        @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
      end
    end
    render :pdf => 'filter_report_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
            


#    respond_to do |format|
#      format.pdf { render :layout => false }
#    end
  end
end