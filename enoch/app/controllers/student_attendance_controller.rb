class StudentAttendanceController < ApplicationController
  before_filter :login_required
  # before_filter :only_assigned_employee_allowed
  before_filter :protect_other_student_data
  before_filter :protect_other_student_id, :only => [:student_attendanceReports]
  filter_access_to :all
 
  def index
    @user = current_user
  end

  def student_attendanceReports
    @year = Date.today.year
    @student= Student.find_by_id(params[:student_id])
  end

  def student

    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    @student = Student.find(params[:data][:id])
    @batch = Batch.find(@student.batch_id)
    @subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>{:is_deleted => false})
    
    # if request.post?
      @detail_report = []
      if params[:data][:advance_search][:mode]== 'Overall'
        @start_date = @batch.start_date.to_date
        @end_date = Date.today
        unless @config.config_value == 'Daily'
          unless params[:data][:advance_search][:subject_id].empty?
            @subject = Subject.find params[:advance_search][:subject_id]
            @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
          else
            @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
          end
        else
          @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
        end
      else
        @month = params[:data][:advance_search][:month]
        @year = params[:data][:advance_search][:year]
        @start_date = "01-#{@month}-#{@year}".to_date
        #        @start_date = @date
        @today = Date.today
        @end_date = @start_date.end_of_month
        if @end_date > Date.today
          @end_date = Date.today
        end
        unless @config.config_value == 'Daily'
          unless params[:data][:advance_search][:subject_id].empty?
            @subject = Subject.find params[:data][:advance_search][:subject_id]
            @report = PeriodEntry.find_all_by_subject_id(@subject.id,  :conditions =>{:month_date => @start_date..@end_date})
          else
            @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
          end
        else
          @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
        end
        
      end
      
        render :partial => "report" , :layout => false
  end

  def month
    if params[:mode] == 'Monthly'
      @year = Date.today.year
      render :update do |page|
        page.replace_html 'month', :partial => 'month'
      end
    else
      render :update do |page|
        page.replace_html 'month', :text =>''
      end
    end
  end

  def student_report
    @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
    @student = Student.find_by_id(params[:id])
    unless @student.nil?
      @batch = Batch.find_by_id(params[:year])
      @start_date = @batch.start_date.to_date
      @end_date =  @batch.end_date.to_date
      @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
    else
      redirect_to :controller => "sessions", :action => "dashboard"  
      flash[:notice] = t(:student_not_found)
    end
  end

end