
class CalendarsController < ApplicationController
include CalendarsHelper

  before_filter :login_required
  # filter_access_to :event_delete
  
   def index
     @calendar = Calendar.new
    @user = current_user
    if params[:new_month].nil?
      @show_month = Date.today
    else
      d = params[:new_month].to_i
      passed_date = (params[:passed_date]).to_date
      if params[:new_month].to_i > passed_date.month
        @show_month  = passed_date+1.month
      else
        @show_month = passed_date-1.month
      end      
    end
    first_day = @show_month.beginning_of_month
    last_day =  @show_month.end_of_month 
    calendar_variable(@show_month,first_day,last_day)
    event_distinguisher(@user,first_day,last_day)
    load_notifications
    @event =Event.find_all_by_is_common(true,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day] )
    exam_event(@user)    
    @exam_event_date = @exam_event_date.uniq
    @display_day = DisplayDay.new(@start_date,@events)
    @display_week = DisplayWeek.new(@start_date,@events,Date.today)
    @obj = DisplayCalendar.new
    @obj.number_of_week_to_display(@show_month)
    @no_of_rows =  @obj.number_of_week_to_display(@show_month)
  end 
  
  def calendar_variable(show_month,first_day,last_day)   
    @show_month = show_month
    @start_date = @show_month.beginning_of_month
    @start_date_day = @start_date.wday
    @last_day = @show_month.end_of_month
    @notifications = Hash.new{|h,k| h[k]=Array.new}
    @my_event = Hash.new{|h,k| h[k]=Array.new}
    @previous_month = @show_month.beginning_of_month-@start_date_day
    @end_date_day= @last_day.wday
    @next_month = Date.today + 1.month
    @next_month_start_date=@next_month.beginning_of_month 
    @next_month_start_date_day=@next_month_start_date.wday
    @events = Event.find_all_by_is_common(true,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day] )
    @is_due_event = Event.find_all_by_is_due(true,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day] )
  end
  
  def event_distinguisher(user,first_day,last_day)
      @eventss =Event.find_all_by_is_common_and_is_exam_and_is_due(false,false,false,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
  end
  
  def exam_event(user)
    @user = user
    @exam_event = []
    @exam_event_date = []
    if @user.student == true
      @st = Student.find_by_admission_no(@user.username)
      @exam_g = ExamGroup.find_all_by_batch_id(@st.batch_id)
    else
      @exam_g = ExamGroup.find(:all)
    end
     @exam_g.each do |eg|
       eg.exams.each do |exa|
          unless exa.event.nil?
          @exam_event<< exa.event
          @exam_event_date << exa.event.start_date.to_date.strftime('%Y-%m-%d')
          end
       end
     end   
  end
  
  def event_view
    @user = current_user
    @date = params[:id].to_date
    first_day = @date.beginning_of_month.to_time
    last_day = @date.end_of_month.to_time

    common_event = Event.find_all_by_is_common_and_is_holiday(true,false, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    non_common_events = Event.find_all_by_is_common_and_is_holiday_and_is_exam(false,false,false, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    common_event_holiday = Event.find_all_by_is_holiday_and_is_common(true,true, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    not_common_events = Event.find_all_by_is_common_and_is_exam_and_is_due(false,false,false, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    common_events_for_all = Event.find_all_by_is_common(true, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    exam_event_list = Event.find_all_by_is_exam(true, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    fees_due_event_list = Event.find_all_by_is_due(true, :conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day])
    @exam_event = []
    @exam_eventBatch = []
    if @user.student == true
      @st = Student.find_by_admission_no(@user.username)
      @exam_g = ExamGroup.find_all_by_batch_id(@st.batch_id)
    else
      @exam_g = ExamGroup.find(:all)
    end

     @exam_g.each do |eg|
       eg.exams.each do |exa|
         unless exa.event.nil?
         if exa.event.start_date.to_date.strftime('%Y-%m-%d')==params[:id]
           @exam_event<< exa.event
         end
         end 
       end
       @exam_eventBatch << eg.batch
     end
  
    @common_event_array = []
    common_event.each do |h|
      if h.start_date.to_date == h.end_date.to_date
        @common_event_array.push h if h.start_date.to_date == @date
      else
        (h.start_date.to_date..h.end_date.to_date).each do |d|
          @common_event_array.push h if d == @date
        end
      end
    end
    
    
    if @user.student == true
      user_student = @user.student_record
      batch = user_student.batch
     
     @not_commom_event_holiday = []
     @self_event = []
     not_common_events.each do |k|
        not_batch_event = BatchEvent.find(:all, :conditions=>{:event_id =>k.id})
        myEvent = k.is_user_event
        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @not_commom_event_holiday.push(k) unless (not_batch_event.nil? || myEvent)
            @self_event.push(k) if k.is_student_event(@user.student_record)
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @not_commom_event_holiday.push(k) unless (not_batch_event.nil? || myEvent)
              @self_event.push(k) if k.is_student_event(@user.student_record)
            end
          end
        end
      end
      
     @fees_due_event = []
     fees_due_event_list.reject!{|x| !x.is_active_event }
     fees_due_event_list.each do |k|
       finance_fee_collection = FinanceFeeCollection.find_by_id(k.origin_id)
        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            if user_student.batch_id == finance_fee_collection.batch_id
              @fees_due_event.push(k)
            end
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              if user_student.batch_id == finance_fee_collection.batch_id
                @fees_due_event.push(k)
              end
            end
          end
        end
      end 
      
      @commom_event_holiday = []      
      common_event_holiday.each do |k|
        @batch_event = BatchEvent.find(:all, :conditions=>{:event_id =>k.id})

        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @commom_event_holiday.push(k) unless  @batch_event.nil?
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @commom_event_holiday.push(k) unless  @batch_event.nil?
            end
          end
        end
        
      end 

      @student_batch_not_common_event_array = []
      non_common_events.each do |h|
        student_batch_event = BatchEvent.find_by_batch_id(batch.id, :conditions=>"event_id = #{h.id}")
        if h.start_date.to_date == "#{h.end_date.year}-#{h.end_date.month}-#{h.end_date.day}".to_date
          if "#{h.start_date.year}-#{h.start_date.month}-#{h.start_date.day}".to_date == @date
            @student_batch_not_common_event_array.push(h) unless student_batch_event.nil?
          end
        else
          (h.start_date.to_date..h.end_date.to_date).each do |d|
            if d == @date
              @student_batch_not_common_event_array.push(h) unless student_batch_event.nil?
            end
          end
        end
      end
      @events = @common_event_array + @student_batch_not_common_event_array
      @events_co = @common_event_array
      @not_comm_event = @not_commom_event_holiday
      @event_holiday = @commom_event_holiday
      @fees_event = @fees_due_event
      
    elsif @user.employee == true
      user_employee = @user.employee_record 
      department = user_employee.employee_department
      @employee_dept_not_common_event_array = []
       non_common_events.each do |h|
        employee_dept_event = EmployeeDepartmentEvent.find_by_employee_department_id(department.id, :conditions=>"event_id = #{h.id}")
        if h.start_date.to_date == h.end_date.to_date
          if h.start_date.to_date == @date
            @employee_dept_not_common_event_array.push(h) unless employee_dept_event.nil?
          end
        else
          (h.start_date.to_date..h.end_date.to_date).each do |d|
            if d == @date
              @employee_dept_not_common_event_array.push(h) unless employee_dept_event.nil?
            end
          end
        end
      end
      @not_commom_event_holiday = []
      @self_event = []
      not_common_events.each do |k|
        not_department_event = EmployeeDepartmentEvent.find(:all, :conditions=>{:event_id =>k.id})
         myEvent = k.is_user_event
        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @not_commom_event_holiday.push(k) unless (not_department_event.nil? || myEvent)
            @self_event.push(k) if k.is_employee_event(@user.employee_record)
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @not_commom_event_holiday.push(k) unless (not_department_event.nil? || myEvent)
              @self_event.push(k) if k.is_employee_event(@user.employee_record)
            end
          end
        end  
      end
      @commom_event_holiday = []      
      common_event_holiday.each do |k|
        @department_event = EmployeeDepartmentEvent.find(:all, :conditions=>{:event_id =>k.id})

        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @commom_event_holiday.push(k) unless  @department_event.nil?
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @commom_event_holiday.push(k) unless  @department_event.nil?
            end
          end
        end
        
      end 
      
      
      @events = @common_event_array + @employee_dept_not_common_event_array
      @events_co = @common_event_array
      @not_comm_event = @not_commom_event_holiday
      @event_holiday = @commom_event_holiday
      @fees_event = []
    elsif @user.admin == true
     
      @commom_event_holiday = []      
      common_event_holiday.each do |k|
        @employee_dept_event = EmployeeDepartmentEvent.find(:all, :conditions=>{:event_id =>k.id})

        @batch_event = BatchEvent.find(:all, :conditions=>{:event_id =>k.id})

        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @commom_event_holiday.push(k) unless (@employee_dept_event.nil? || @batch_event.nil?) 
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @commom_event_holiday.push(k) unless (@employee_dept_event.nil? || @batch_event.nil?) 
            end
          end
        end
        
      end
     @fees_due_event = []
     fees_due_event_list.reject!{|x| !x.is_active_event }
     fees_due_event_list.each do |k|
        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @fees_due_event.push(k) 
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @fees_due_event.push(k)
            end
          end
        end
      end 
     
     @not_commom_event_holiday = []
     @self_event = []
     not_common_events.each do |k|
        not_employee_dept_event = EmployeeDepartmentEvent.find(:all, :conditions=>{:event_id =>k.id})
        not_batch_event = BatchEvent.find(:all, :conditions=>{:event_id =>k.id})
        myEvent = k.is_user_event
        if k.start_date.to_date == k.end_date.to_date
          if k.start_date.to_date == @date
            @not_commom_event_holiday.push(k) unless (not_employee_dept_event.nil? || not_batch_event.nil? || myEvent) 
            @self_event.push(k) if k.is_employee_event(@user.employee_record)
          end
        else
          (k.start_date.to_date..k.end_date.to_date).each do |d|
            if d == @date
              @not_commom_event_holiday.push(k) unless (not_employee_dept_event.nil? || not_batch_event.nil? || myEvent) 
              @self_event.push(k) if k.is_employee_event(@user.employee_record)
            end
          end
        end
        
      end

      @employee_dept_not_common_event_array = []
      non_common_events.each do |h|
        employee_dept_event = EmployeeDepartmentEvent.find(:all, :conditions=>"event_id = #{h.id}")
        if h.start_date.to_date == h.end_date.to_date
          if h.start_date.to_date == @date
            @employee_dept_not_common_event_array.push(h) unless employee_dept_event.nil?
          end
        else
          (h.start_date.to_date..h.end_date.to_date).each do |d|
            if d == @date
              @employee_dept_not_common_event_array.push(h) unless employee_dept_event.nil?
            end
          end
        end
      end
      @events = @common_event_array + @employee_dept_not_common_event_array
      @events_co = @common_event_array
      @event_holiday = @commom_event_holiday
      @not_comm_event = @not_commom_event_holiday
      @fees_event = @fees_due_event
    end
    render :partial => 'event_view'
  end
  
  
 def event_delete
    @event = Event.find_by_id(params[:id])
    unless @event.nil?
      ptm_master = PtmMaster.find_all_by_event_id(@event.id)
      unless ptm_master.nil?
        ptm_master.each do |ptm|
          ptm.update_attributes(:event_id => "")
        end
      end
      @event.destroy
    end
    redirect_to :controller=>"calendars"
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @calendar }
    end
  end

  def new
    @calendar = Calendar.new
    @user = current_user
    if params[:new_month].nil?
      @show_month = Date.today
    else
      d = params[:new_month].to_i
      passed_date = (params[:passed_date]).to_date
      if params[:new_month].to_i > passed_date.month
        @show_month  = passed_date+1.month
      else
        @show_month = passed_date-1.month
      end      
    end
    first_day = @show_month.beginning_of_month
    last_day =  @show_month.end_of_month 
    calendar_variable(@show_month,first_day,last_day)
    event_distinguisher(@user,first_day,last_day)
    load_notifications
    @event =Event.find_all_by_is_common(true,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day] )
    exam_event(@user)    
    @exam_event_date = @exam_event_date.uniq
    @display_day = DisplayDay.new(@start_date,@events)
    @display_week = DisplayWeek.new(@start_date,@events,Date.today)
    @obj = DisplayCalendar.new
    @obj.number_of_week_to_display(@show_month)
    @no_of_rows =  @obj.number_of_week_to_display(@show_month)
  end
  
  
  def monthsname
    @calendar = Calendar.new
    @user = current_user
    if params[:new_month].nil?
      @show_month = Date.today
    else
      d = params[:new_month].to_i
      passed_date = (params[:passed_date]).to_date
      if params[:new_month].to_i > passed_date.month
        @show_month  = passed_date+1.month
      else
        @show_month = passed_date-1.month
      end      
    end
    first_day = @show_month.beginning_of_month
    last_day =  @show_month.end_of_month 
    calendar_variable(@show_month,first_day,last_day)
    event_distinguisher(@user,first_day,last_day)
    load_notifications
    @event =Event.find_all_by_is_common(true,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day] )
    exam_event(@user)     
    @exam_event_date = @exam_event_date.uniq
    @display_day = DisplayDay.new(@start_date,@events)
    @display_week = DisplayWeek.new(@start_date,@events,Date.today)
    @obj = DisplayCalendar.new
    @obj.number_of_week_to_display(@show_month)
    @no_of_rows =  @obj.number_of_week_to_display(@show_month)
  end
  
  def myEventView
    @calendar = Calendar.new
    @user = current_user
    if params[:new_month].nil?
      @show_month = Date.today
    else
      d = params[:new_month].to_i
      passed_date = (params[:passed_date]).to_date
      if params[:new_month].to_i > passed_date.month
        @show_month  = passed_date+1.month
      else
        @show_month = passed_date-1.month
      end      
    end
    first_day = @show_month.beginning_of_month
    last_day =  @show_month.end_of_month 
    calendar_variable(@show_month,first_day,last_day)
    event_distinguisher(@user,first_day,last_day)
    load_notifications
    @event =Event.find_all_by_is_common(true,:conditions => ["(start_date >= ? and end_date <= ?) or (start_date <= ? and end_date <= ?)  or (start_date>=? and end_date>=?) or (start_date<=? and end_date>=?) ", first_day, last_day, first_day,last_day, first_day,last_day,first_day,last_day] )
    exam_event(@user)     
    @exam_event_date = @exam_event_date.uniq
    @display_day = DisplayDay.new(@start_date,@events)
    @display_week = DisplayWeek.new(@start_date,@events,Date.today)
    @obj = DisplayCalendar.new
    @obj.number_of_week_to_display(@show_month)
    @no_of_rows =  @obj.number_of_week_to_display(@show_month)
    render :partial => "month"
  end
 
  # GET /calendars/1/edit
  def edit
    @event = Event.find_by_id(params[:id])
    render :partial => 'edit'
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(params[:calendar])

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render json: @calendar, status: :created, location: @calendar }
      else
        format.html { render action: "new" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to calendars_url }
      format.json { head :ok }
    end
  end
  
  
  def load_notifications
    @user = current_user
    @is_due_event.each do |e|
       if e.is_due == true
        if e.is_active_event
          if @user.admin?
            build_common_events_hash(e,'finance_due',@show_month)
          elsif @user.student?
            student= @user.student_record
            if e.is_student_event(student)
              build_student_is_due_events_hash(e,'finance_due',student.batch_id,@show_month)
            end
          elsif @user.employee?
            if e.is_employee_event(@user)
              build_common_events_hash(e,'finance_due',@show_month)
            end
          end
        end
      end
    end 
    @eventss.each do |e|
        if @user.admin?
          build_common_events_hash(e,'uncommon_event',@show_month)
          build_common_events_hash(e,'my_event',@show_month)
        elsif @user.student?
          student= @user.student_record
            build_student_events_hash(e,'uncommon_event',student.batch_id,@show_month)
            build_student_events_hash(e,'my_event',student.batch_id,@show_month)
        elsif @user.employee?
            build_employee_events_hash(e,'uncommon_event',@user.employee_record.employee_department_id,@show_month)
            build_employee_events_hash(e,'my_event',@user.employee_record.employee_department_id,@show_month)
        end
    end
    @events.each do |e|
      if e.is_common ==true
        if e.is_holiday == true
          build_common_events_hash(e,'common_holidays',@show_month)
        else
          build_common_events_hash(e,'common_events',@show_month)
        end
      end
      if e.is_due == true
        build_common_events_hash(e,'finance_due',@show_month)
      end

      if e.is_common ==false and e.is_holiday==false and e.is_exam==false   #not_common_event
        build_student_events_hash(e,'student_batch_not_common',@user.student_record.batch_id,@show_month) if @user.student?
        build_employee_events_hash(e,'employee_dept_not_common',@user.employee_record.employee_department_id,@show_month) if @user.employee?
      end

      if e.is_common ==false and e.is_holiday==true     # not_common_holiday_event
        build_student_events_hash(e,'student_batch_not_common_holiday',@user.student_record.batch_id,@show_month) if @user.student?
        build_employee_events_hash(e,'employee_dept_not_common_holiday',@user.employee_record.employee_department_id,@show_month) if @user.employee?
        if @user.admin?
          employee_dept_holiday_event = EmployeeDepartmentEvent.find(:all, :conditions=>"event_id = #{e.id}")
          if e.start_date.to_date == e.end_date.to_date
            @notifications['employee_dept_not_common_holiday'].push e.start_date.to_date unless  employee_dept_holiday_event.nil?
          else
            (e.start_date.to_date..e.end_date.to_date).each do |d|
              @notifications['employee_dept_not_common_holiday'].push d.to_date  unless employee_dept_holiday_event.nil?
            end
          end
        end
      end

      if e.is_common ==false and e.is_holiday==false and e.is_exam ==true  # not_common_exam_event
        build_student_events_hash(e,'student_batch_exam',@user.student_record.batch_id,@show_month) if @user.student?
        if @user.employee?
          build_common_events_hash(e,'student_batch_exam',@show_month)
        end
        if @user.admin?
          student_batch_exam_event = BatchEvent.find(:all, :conditions=>"event_id = #{e.id}")
          if  e.start_date.to_date == e.end_date.to_date
            @notifications['student_batch_exam'] << e.start_date.to_date  unless student_batch_exam_event.nil?
          else
            (e.start_date.to_date..e.end_date.to_date).each do |d|
              @notifications['student_batch_exam'] << d.to_date unless student_batch_exam_event.nil?
            end
          end
        end
      end

      if e.is_common ==false and e.is_holiday==false and e.is_due==false and e.is_exam ==false and @user.admin?  # not_common_exam_due_event
        build_common_events_hash(e,'employee_dept_not_common',@show_month)
      end
    end
    if @user.student?
      @events = @notifications['common_events'] + @notifications['student_batch_not_common']+@notifications['common_holidays']
      @holiday_event =  @notifications['common_holidays']+ @notifications['student_batch_not_common_holiday']
      @is_due_event = @notifications['finance_due']
      @not_common = @notifications['uncommon_event']
      @my_event = @my_event['my_event']
    elsif @user.employee?
      @events = @notifications['common_events'] + @notifications['common_holidays']
      @holiday_event =  @notifications['common_holidays']+ @notifications['employee_dept_not_common_holiday']
      @is_due_event = []
      @not_common = @notifications['uncommon_event']
      @my_event = @my_event['my_event']
    elsif @user.admin?  
      # @events = @notifications['common_events'] + @notifications['employee_dept_not_common']
      @events = @notifications['common_holidays']+@notifications['common_events']
      @holiday_event =  @notifications['common_holidays']+ @notifications['employee_dept_not_common_holiday']  
      @is_due_event = @notifications['finance_due']
      @not_common = @notifications['uncommon_event']
      @my_event = @my_event['my_event']
    end
  end

  
  
    def build_common_events_hash(e,key,today)
    if e.start_date.to_date == e.end_date.to_date
      @my_event["#{key}"]  << e.start_date.to_date if e.is_employee_event(@user.employee_record)
      @notifications["#{key}"] << e.start_date.to_date unless e.is_user_event
    else
      (e.start_date.to_date..e.end_date.to_date).each do |d|
        @my_event["#{key}"]  << e.start_date.to_date if e.is_employee_event(@user.employee_record)
        @notifications["#{key}"] << d.to_date unless e.is_user_event
      end
    end
  end


  def build_student_events_hash(h,key,batch_id,today)
    if h.start_date.to_date == h.end_date.to_date
      @my_event["#{key}"]  << h.start_date.to_date if h.is_student_event(@user.student_record)
      student_batch_event = BatchEvent.find_by_batch_id(batch_id, :conditions=>"event_id = #{h.id}")
      @notifications["#{key}"]  << h.start_date.to_date unless student_batch_event.nil?
    else
      (h.start_date.to_date..h.end_date.to_date).each do |d|
        @my_event["#{key}"]  << h.start_date.to_date if h.is_student_event(@user.student_record)
        student_batch_event = BatchEvent.find_by_batch_id(batch_id, :conditions=>"event_id = #{h.id}")
        @notifications["#{key}"]  << d.to_date unless student_batch_event.nil?
      end
    end
  end
  
    def build_student_is_due_events_hash(h,key,batch_id,today)
    if h.start_date.to_date == h.end_date.to_date
      @notifications["#{key}"]  << h.start_date.to_date 
    else
      (h.start_date.to_date..h.end_date.to_date).each do |d|
        @notifications["#{key}"]  << d.to_date 
      end
    end
  end

  def build_employee_events_hash(h,key,department_id,today)
    if h.start_date.to_date == h.end_date.to_date
      @my_event["#{key}"]  << h.start_date.to_date if h.is_employee_event(@user.employee_record)
      employee_dept_event = EmployeeDepartmentEvent.find_by_employee_department_id(department_id, :conditions=>"event_id = #{h.id}") unless department_id.nil?
      @notifications["#{key}"]  << h.start_date.to_date unless employee_dept_event.nil?
    else
      employee_dept_event = EmployeeDepartmentEvent.find_by_employee_department_id(department_id, :conditions=>"event_id = #{h.id}")
      (h.start_date.to_date..h.end_date.to_date).each do |d|
        @my_event["#{key}"]  << h.start_date.to_date if h.is_employee_event(@user.employee_record)
        @notifications["#{key}"]  << d.to_date unless employee_dept_event.nil?
      end
    end
  end



  def generate_calendar_pdf
    @start_date = params[:month].to_date.beginning_of_month
    @end_date = params[:month].to_date.end_of_month
    first_day = @start_date
    last_day =  @end_date
    @events = Event.find(:all,:conditions => ["(start_date >= ? and end_date <= ?)", first_day, last_day] )
    @event = []
    @events.each do |d| 
     @event << d unless d.is_user_event
    end
    render :pdf => 'generate_calendar_pdf',
            :orientation => 'Landscape' ,:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end


end
