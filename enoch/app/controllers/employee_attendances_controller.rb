
class EmployeeAttendancesController < ApplicationController
  
  before_filter :login_required,:configuration_settings_for_hr
  filter_access_to :all
  include EmployeeAttendancesHelper
  def index
    @user = current_user
    @departments = EmployeeDepartment.find(:all, :conditions=>"status = true", :order=> "name ASC")
    @dept = []
    unless params[:next].nil?
      @today = params[:next].to_date
    else
      @today = Date.today
    end
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
    unless params[:id2].nil?
    @employee = Employee.find(params[:id2])
    @date = params[:id]
    @leave_types = EmployeeLeaveType.find(:all, :conditions=>"status = true", :order=>"name ASC")
    render :partial => 'new'
    end
  end

  def show
    if params[:dept_id] != 'true'
    @dept = EmployeeDepartment.find(params[:dept_id])
    @employees = Employee.find_all_by_employee_department_id(@dept.id)
    else
    @employees = Employee.find(:all)
    end
    @attendances = EmployeeAttendance.find(:all)
    unless params[:next].nil?
      @today = params[:next].to_date
    else
      @today = Date.today
    end
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
    date_array = []
    date_style = []
    holiday_date = []
    common_holiday = []
    department_holiday = [] 
    department_holiday_date = []
       (@start_date..@end_date).each do |se|
         date_array << se.strftime('%Y-%m-%d')
         date_style << se.strftime('%a %d')     
         @event_holiday = Event.find_by_start_date_and_is_holiday(Time.zone.parse(se.to_s).utc,true)
         unless @event_holiday.nil?
          if !@event_holiday.is_common?
          employee_holiday = EmployeeDepartmentEvent.find_all_by_event_id(@event_holiday.id)
          holiday_date << @event_holiday.start_date.to_date unless @event_holiday.nil?
          unless employee_holiday.empty?
            employee_holiday.each do |s|
             department_holiday <<  s.employee_department_id
             department_holiday_date << s.event.start_date.strftime("%Y-%m-%d")
            end
          end
          else
          holiday_date << @event_holiday.start_date.to_date unless @event_holiday.nil?
          (@event_holiday.start_date.to_date..@event_holiday.end_date.to_date ).each do |eve_hol|
            common_holiday << eve_hol unless eve_hol.nil?
          end
          # common_holiday << @event_holiday.start_date.to_date unless @event_holiday.nil?
          end
         end
       end 
    employee_attendance_id =[]
    attendance_id =[]
    employee_attendance_date =[]
    @attendances.each do |att|
      employee_attendance_id << att.employee_id  
      employee_attendance_date << att.attendance_date
      attendance_id << att.id
     end 
    employee_id = []
    employee_name = []
    employee_department = []
     @employees.each do |emp|
      employee_id << emp.id 
      employee_name << emp.full_name
      employee_department << emp.employee_department.id
     end   
    respond_to do |format|
      format.json { render :json => {:valid => true, :start_date => @start_date, :end_date => @end_date, :employees => @employees,:today => @today,:employee_id =>employee_id,:employee_name => employee_name,:date_array => date_array,
        :employee_attendance_id =>employee_attendance_id, :employee_attendance_date => employee_attendance_date,:attendance_id => attendance_id,:date_style =>date_style,:holiday_date => holiday_date,
        :employee_department => employee_department,:department_holiday => department_holiday,:common_holiday => common_holiday,:department_holiday_date => department_holiday_date}}
    end
    
  end

  def new
    @attendance = EmployeeAttendance.new
    @employee = Employee.find(params[:id2])
    @date = params[:id]
    @leave_types = EmployeeLeaveType.find(:all, :conditions=>"status = true", :order=>"name ASC")

    respond_to do |format|
      format.js {render :action => 'new'}
    end
  end

  def create
    @date = []
    @employee = Employee.find(params[:employee_attendance][:employee_id])
      params[:employee_attendance][:attendance_date].each do |ed|
        @date << ed
      end
    @date.each do |d|
        @attendance = EmployeeAttendance.new(:employee_id => params[:employee_attendance][:employee_id],
                                             :employee_leave_type_id => params[:employee_attendance][:employee_leave_type_id],
                                             :attendance_date => d, :reason => params[:employee_attendance][:reason],:is_half_day => params[:employee_attendance][:is_half_day])
        @reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
        @event_holiday = Event.find_by_start_date_and_is_holiday(Time.zone.parse(d).utc,true)
        unless @event_holiday.nil?
        if !@event_holiday.is_common?
        employee_holiday = EmployeeDepartmentEvent.find_by_event_id_and_employee_department_id(@event_holiday.id,params[:employee_department])
        else     
        employee_holiday = @event_holiday 
        end
        end
     if d.to_date.strftime('%a') != "Sun" && employee_holiday.nil?
        @attendance.save
          leaves_taken = @reset_count.leave_taken
              if @attendance.is_half_day
                leave = leaves_taken.to_f+(0.5)
                @reset_count.update_attributes(:leave_taken => leave)
              else
                leave = leaves_taken.to_f+(1)
                @reset_count.update_attributes(:leave_taken => leave)
              end
      end
   end
      respond_to do |format|
          format.json { render :json => {:valid => true,:notice => t(:attendance_marked)}}
      end
  end

  def edit
    @attendance = EmployeeAttendance.find_by_employee_id_and_attendance_date(params[:id2],params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @leave_types = EmployeeLeaveType.find(:all, :conditions=>"status = true", :order=>"name ASC")
    respond_to do |format|
      format.html { render :partial => 'edit' }
      # format.js {render :action => 'edit'}
    end
  end
  
  def date_attandance_array
  @multi_date = []
    ((params[:start_date].to_date)..(params[:end_date].to_date)).each do |f|
          @multi_date << f.strftime("%Y-%m-%d")
    end
    respond_to do |format|
      format.json { render :json => {:multi_date => @multi_date}}
    end
  end
  

  def update
    @dates = []
    if !params[:employee_attendance][:attendance_date].nil?
    params[:employee_attendance][:attendance_date].each do |ed|
      @dates << ed
    end
    @dates.each do |d|
      @attendance = EmployeeAttendance.find_by_employee_id_and_attendance_date(params[:employee_attendance][:employee_id],d)
        if @attendance!=nil
        @reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
        leaves_taken = @reset_count.leave_taken
        day_status = @attendance.is_half_day
        leave_type = EmployeeLeaveType.find_by_id(@attendance.employee_leave_type_id)
            if @attendance.is_half_day
              half_day = true
            else
              half_day = false
            end
        
      if @attendance.update_attributes(:employee_id => params[:employee_attendance][:employee_id],
                                             :employee_leave_type_id => params[:employee_attendance][:employee_leave_type_id],
                                             :attendance_date => d, :reason => params[:employee_attendance][:reason] ,:is_half_day => params[:employee_attendance][:is_half_day] )
        if @attendance.employee_leave_type_id == leave_type.id
        
          unless day_status == @attendance.is_half_day
            if half_day
              leave = leaves_taken.to_f+(0.5)
            else
              leave = leaves_taken.to_f-(0.5)
            end
            @reset_count.update_attributes(:leave_taken => leave)
          end
        else
          if half_day
            leave = leaves_taken.to_f-(0.5)
          else
            leave = leaves_taken.to_f-(1.0)
          end
          @reset_count.update_attributes(:leave_taken => leave)
          @new_reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
          leaves_taken = @new_reset_count.leave_taken
          if @attendance.is_half_day
            leave = leaves_taken.to_f+(0.5)
            @new_reset_count.update_attributes(:leave_taken => leave)
          else
            leave = leaves_taken.to_f+(1)
            @new_reset_count.update_attributes(:leave_taken => leave)
          end
        end
      end
    end
   end
     respond_to do |format|
      format.json { render :json => {:valid => true,:notice => t(:attendance_updated)}}
    end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false,:notice => t(:attendance_not_updated)}}
      end
    end
  end

  def destroy
    @dates = []
    if !params[:employee_attendance][:attendance_date].nil?
    params[:employee_attendance][:attendance_date].each do |ed|
      @dates << ed
    end
    @dates.each do |d|
    @attendance = EmployeeAttendance.find_by_employee_id_and_attendance_date(params[:employee_attendance][:employee_id],d)
    if @attendance!= nil
    @reset_count = EmployeeLeave.find_by_employee_id(params[:employee_attendance][:employee_id], :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type.id}'")
    leaves_taken = @reset_count.leave_taken
    if @attendance.is_half_day
      leave = leaves_taken.to_f-(0.5)
    else
      leave = leaves_taken.to_f-(1)
    end
    @attendance.delete
    @reset_count.update_attributes(:leave_taken => leave)
    end
    end
    respond_to do |format|
        format.json { render :json => {:valid => true,:notice => t(:attendance_deleted)}}
     end
     else
       respond_to do |format|
        format.json { render :json => {:valid => false,:notice => t(:attendance_not_deleted)}}
     end
     end
  end
  
end
