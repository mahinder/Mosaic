class TimetableController < ApplicationController
  before_filter :login_required
  # before_filter :protect_other_student_data
  filter_access_to :all
  def employee_info
    @class_timing_object = ClassTiming.default
    @weekday_object = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @day = Weekday.default
    @employee_objects  =  Employee.find(params[:id])
    unless @employee_objects.nil?
      @timetable_entries_object = TimetableEntry.find_all_by_employee_id(@employee_objects.id)
      @timetable_entries_object.sort! { |a,b| a.class_timing.start_time.to_time <=> b.class_timing.start_time.to_time  }
    end
    render "_employee_info" ,:layout => false
  end

  def find
    @user = Employee.all

    responses = ""

    unless @user.empty?
      @user.each do |user|
        str = '{"key": "'+user.id.to_s+'", "value": "'+user.full_name+' ,'+ user.user.username+'"}'
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'

    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    respond_to do |format|
      format.json { render :json => response}
    end

  end

  def today_timetable_substitution
    @Timetable_substitution_entry = TimetableSubstitution.find_all_by_date(Date.today)

  end

  def timetable_substitude_reassign
    @employee = Employee.find_by_id(params[:emp])
    @employee1 = Employee.find_by_id(params[:emp1])
    @teacher = []
    @emp = []
    @emp << "List of Teachers who do not match this skill"
    @classtime = params[:class_time]
    subject = Subject.find_by_id(params[:sub])
    skill = subject.skill
    @Timetable_entry = []
    @showclasstiming = ClassTiming.find_by_id(params[:class_time])
    @all_employee = Employee.all
    unless  @all_employee.empty?
      @all_employee.each do |all|
        if !all.nil? && all.is_teacher == true

          @Timetable_entry = []
          puts all.first_name
          @abc = EmployeeAttendance.find_by_employee_id_and_attendance_date(all.id,Date.today)
          if @abc.nil?
            # @Timetable_entry = TimetableEntry.find_all_by_employee_id_and_class_timing_id(all.id,@classtime)

            class_timming = ClassTiming.find_by_id(@classtime)
            unless class_timming.nil?
              @Timetable_entry_set = TimetableEntry.find_all_by_employee_id(all.id)

              unless  @Timetable_entry_set.empty?
                @Timetable_entry_set.each do |tm|

                  if tm.class_timing.start_time.to_time == class_timming.start_time.to_time
                  @Timetable_entry << tm
                  end
                end
              end
            end
            puts @Timetable_entry
            @assignteacher_entry = TimetableEntry.day_find(Date.today,@Timetable_entry)
            puts @assignteacher_entry

            puts all.first_name
            puts @assignteacher_entry
            if @assignteacher_entry.empty?
              @substitute_tableset = TimetableSubstitution.find_all_by_teacher_substitude_with_id_and_date(all.id,Date.today)
              @substitute_table = nil
              unless @substitute_tableset.empty?
                @substitute_tableset.each do |sub|

                  if sub.class_timing.start_time.to_time == class_timming.start_time.to_time
                  @substitute_table = sub
                  end
                end

              end

              if @substitute_table.nil?
                employee_skills = all.skills
                if employee_skills.include? skill
                @emp = [*all] + @emp if all.is_teacher == true
                else
                  @emp = @emp + [*all] if all.is_teacher == true
                end
              end
            end
          end
        end
      end
    end
    @emp = ["List of Teachers who has the similar skill"] + @emp
    @empcount = @emp.count
    render "_timetable_substitude_reassign",:layout => false
  end

  def today_timetable
    @class_timing = ClassTiming.find_all_by_batch_id(nil)
    @emparr = []
    @employee = []
    @timetable = []
    @timetable_entries = []
    # @class_timing = []
    @user = current_user
    @role = @user.role_name
    if @role == "Admin" || (permitted_to? :today_timetable,:timetable)
      @timetable = TimetableEntry.all
      # unless @employee_category.nil?
      unless @timetable.empty?
        @timetable.each do |time|
          if time.weekday.weekday.to_s == Date.today.wday.to_s
            unless (@emparr.include? time.employee_id) || (time.employee_id.nil?)
            @emparr << time.employee_id
            end
          end
        # @employee = Employee.find(:all,:conditions =>{:employee_category_id => @employee_category.id} )
        end
        @emparr.each do |emp|

          @employee << Employee.find_by_id(emp)

        end

      end
    # end
    elsif @role == "Employee"
    @employee << @user.employee_record
    end

  end

  def timetable_step1
    @courses = Course.active
    @batches = Batch.active
    @batch = Batch.new
    @class_per_week = 0

  end

  def assign_substitute
    @user = current_user
    @assign_substitute = TimetableSubstitution.create(:batch_id => params[:batch],:subject_id => params[:subject],:employee_id => params[:employee],:class_timing_id => params[:class_time],:teacher_substitude_with_id => params[:assign_emp],:date => params[:date])
    if @assign_substitute.save
      employee = Employee.find_by_id(params[:assign_emp])
      batch = Batch.find(params[:batch])
      classtiming = ClassTiming.find(params[:class_time])
      @reminder = Reminder.new(:sender => @user.id,:sent_to => employee.full_name ,:body => "You have been substituted for batch - " + batch.full_name + " and classtiming - " + classtiming.start_time.strftime("%I:%M %p") +"-" + classtiming.end_time.strftime("%I:%M %p") ,:subject => "Substitution")
      if @reminder.save
        @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => employee.user.id)
      @reminder_receive.save

      end
      respond_to do |format|
        format.json { render :json => {:valid => true}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false,:errors => @assign_substitute.error}}
      end
    end
  end

  def free_teacher
    # puts params
    # @employye =  Employee.find(:all,:conditions => ["id not in (select distinct t.employee_id from timetable_entries as t,  weekdays w, class_timings cl, employees e  where  e.id = t.employee_id and t.weekday_id = w.id and w.weekday = 4 and cl.start_time = '08:00:00' and e.is_teacher = #{true}) and is_teacher = #{true}"])
    # puts "Employee is #{@employye}"
    @teacher = []
    @emp = []
    @emp << "List of Teachers who do not match this skill"
    @classtime = params[:class_time]
    @Timetable_entry = []
    @showclasstiming = ClassTiming.find_by_id(params[:class_time])
    @showemployee = Employee.find_by_id(params[:emp])
    subject = Subject.find_by_id(params[:sub])
    skill = subject.skill
    # finding only teacher
    # @emplyee_category = EmployeeCategory.find_by_name("Teaching")
    # @all_employee = Employee.find_all_by_employee_category_id(@emplyee_category.id) unless @emplyee_category.nil?
    @all_employee = Employee.all
    unless  @all_employee.empty?

      @all_employee.each do |all|
        if !all.nil? && all.is_teacher == true

          @Timetable_entry = []
          puts all.first_name
          @abc = EmployeeAttendance.find_by_employee_id_and_attendance_date(all.id,Date.today)
          if @abc.nil?
            # @Timetable_entry = TimetableEntry.find_all_by_employee_id_and_class_timing_id(all.id,@classtime)

            class_timming = ClassTiming.find_by_id(@classtime)
            unless class_timming.nil?
              @Timetable_entry_set = TimetableEntry.find_all_by_employee_id(all.id)

              unless  @Timetable_entry_set.empty?
                @Timetable_entry_set.each do |tm|

                  if tm.class_timing.start_time.to_time == class_timming.start_time.to_time
                  @Timetable_entry << tm
                  end
                end
              end
            end

            @assignteacher_entry = TimetableEntry.day_find(Date.today,@Timetable_entry)
            if @assignteacher_entry.empty?
              @substitute_tableset = TimetableSubstitution.find_all_by_teacher_substitude_with_id_and_date(all.id,Date.today)
              @substitute_table = nil
              unless @substitute_tableset.empty?
                @substitute_tableset.each do |sub|
                  if sub.class_timing.start_time.to_time == class_timming.start_time.to_time
                  @substitute_table = sub
                  end
                end

              end

              if @substitute_table.nil?
                employee_skills = all.skills
                if employee_skills.include? skill
                @emp = [*all] + @emp if all.is_teacher == true
                else
                  @emp = @emp + [*all] if all.is_teacher == true
                end
              end
            end
          end
        end
      end
    end
    @emp = ["List of Teachers who has the similar skill"] + @emp
    @empcount = @emp.count
    render "_modal-box-emp_substitute",:layout => false

  end

  def reassign_substitute
    error = false
    @old_assign_substitute =  TimetableSubstitution.find(:first,:conditions => {:batch_id => params[:batch],:subject_id => params[:subject],:employee_id => params[:employee],:class_timing_id => params[:class_time],:teacher_substitude_with_id => params[:deassign],:date => params[:date]})
    @user = current_user
    unless @old_assign_substitute.nil?
      if @old_assign_substitute.destroy
        deasignemployee = Employee.find_by_id(params[:deassign])
        batch = Batch.find(params[:batch])
        classtiming = ClassTiming.find(params[:class_time])
        @reminder = Reminder.new(:sender => @user.id,:sent_to => deasignemployee.full_name ,:body => "You are no more assign for batch -" + batch.full_name + " and classtiming - " + classtiming.start_time.strftime("%I:%M %p") +"-" + classtiming.end_time.strftime("%I:%M %p") ,:subject => "Re-Substitution")
        if @reminder.save
          @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => deasignemployee.user.id)
        @reminder_receive.save
        end

      end
    end
    unless params[:assign_emp].nil?
      @assign_substitute = TimetableSubstitution.new(:batch_id => params[:batch],:subject_id => params[:subject],:employee_id => params[:employee],:class_timing_id => params[:class_time],:teacher_substitude_with_id => params[:assign_emp],:date => params[:date])
      if @assign_substitute.save
        employee = Employee.find_by_id(params[:assign_emp])
        batch = Batch.find(params[:batch])
        classtiming = ClassTiming.find(params[:class_time])
        @reminder = Reminder.new(:sender => @user.id,:sent_to => employee.full_name ,:body => "You have been substituted for batch -" + batch.full_name + " and classtiming - " + classtiming.start_time.strftime("%I:%M %p") +"-" + classtiming.end_time.strftime("%I:%M %p")  ,:subject => "Substitution")
        if @reminder.save
          @reminder_receive = ReminderRecipient.new(:reminder_id => @reminder.id ,:recipient => employee.user.id)
        @reminder_receive.save
        end

      else
      error = true
      end

    end
    if error == true
      respond_to do |format|
        format.json { render :json => {:valid => false}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => true}}

      end
    end

  end

  def timetable_substitution
    @teacher = []
    @emp = []
    # @emplyee_category = EmployeeCategory.find_by_name("Teaching")
    @abcent_employee = EmployeeAttendance.find(:all,:conditions => {:attendance_date => Date.today})
    # @all_employee = Employee.find_all_by_employee_category_id(@emplyee_category.id) unless @emplyee_category.nil?
    # @all_employee = Employee.all
    # unless  @all_employee.empty?
    # @all_employee.each do |all|
    # @abc = EmployeeAttendance.find_by_employee_id_and_attendance_date(all.id,Date.today)
    # if @abc.nil?
    # @emp = @emp + [*all]
    # end
    # end
    # end

    @empcount = @emp.count
    unless  @abcent_employee.empty?
      @abcent_employee.each do |ab|
      # if ab.employee.employee_category.id == @emplyee_category.id
        @teacher = @teacher + [*ab.employee] if ab.employee.is_teacher == true
      # end
      end

    end

  end

  def add_entry

    @time = TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id(params[:batch],params[:week], params[:classtime])

    @prvtime = TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id(params[:batch],params[:week1], params[:classtime1])
    unless @prvtime.nil?
      @prvtime.destroy
      @period = PeriodEntrySubjectWise.find(:all,:conditions => ["(month_date > ? AND batch_id = ? And class_timing_id = ? )",Date.today,params[:batch],params[:classtime1]] )
      unless @period.empty?
        @period.each do |pr|
          pr.destroy
        end
      end
    end
    if @time.nil?
      TimetableEntry.create(:batch_id=>params[:batch], :weekday_id => params[:week], :class_timing_id => params[:classtime], :subject_id => params[:id], :room_id => params[:room], :employee_id => params[:teacher]) \
      if TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id_and_subject_id(params[:batch],params[:week], params[:classtime],params[:id]).nil?
    else
    # @time.update_attributes(:batch_id=>params[:batch], :weekday_id => params[:week], :class_timing_id => params[:classtime], :subject_id => params[:id], :room_id => params[:room], :employee_id => params[:teacher]) \
    # if TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id_and_subject_id(params[:batch],params[:week], params[:classtime],params[:id]).nil?
      @time.update_attributes(:batch_id=>params[:batch], :weekday_id => params[:week], :class_timing_id => params[:classtime], :subject_id => params[:id], :room_id => params[:room], :employee_id => params[:teacher])
    end

    respond_to do |format|
      format.json { render :json => {}}
    end

  end

  def remove_entry

    @time = TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id(params[:batch],params[:week], params[:classtime])
    if !@time.nil?
      if @time.destroy
        @period = PeriodEntrySubjectWise.find(:all,:conditions => ["(month_date > ? AND batch_id = ? And class_timing_id = ? )",Date.today,params[:batch],params[:classtime]] )
        unless @period.empty?
          @period.each do |pr|
            pr.destroy
          end
        end
        respond_to do |format|
          format.json { render :json => {:valid => true }}
        end
      else
        respond_to do |format|
          format.json { render :json => {:valid => false }}
        end

      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false }}
      end
    end

  end

  def batch
    @course = nil
    if params[:id] == ''
      @batches = Batch.active
    else
      @course = Course.find_by_id(params[:id])
    @batches = @course.batches.active
    end

    render "_batch",:layout => false
  end

  def full_data

  end

  def timetable_setting
    @class_timing_index = []
    @rooms = Room.find(:all)
    @batch = Batch.find_by_id(params[:batch_id])
    @homeroom = Room.find_by_id(@batch.room_id)
    @rooms = @rooms - [*@homeroom]
    @rooms = [*@homeroom]+@rooms
    @class_teacher = Employee.find_by_id(@batch.class_teacher_id)
    @weekdays = Weekday.find_all_by_batch_id(params[:batch_id])
    @class_timing = ClassTiming.find_all_by_batch_id(params[:batch_id],:conditions => {:is_break => false})
    if @weekdays.empty?
      @weekdays = Weekday.default
    end
    if @class_timing.empty?
      @class_timing = ClassTiming.default
    end
    unless @class_timing.empty?
      @class_timing.each do |cl|
        @class_timing_index = @class_timing_index + [*cl.id]
      end
    end

    @class_per_week = @weekdays.count * @class_timing.count
    @class_timings = @class_timing
    render '_timetable_setting',:layout => false
  end

  def set_timetable

    @batch = Batch.find(params[:id])

    @class_timings = ClassTiming.find_all_by_batch_id(@batch.id)

    if @class_timings.empty?
      @class_timings = ClassTiming.default
    end

    @days = Weekday.find_all_by_batch_id(@batch.id)

    if @days.empty?
      @days = Weekday.default
    end

    @days.each do |d|

      @class_timings.each do |p|

        @sub = Subject.find_all_by_batch_id_and_class_timing_id(@batch.id,p.id)

        unless @sub.empty?
          @sub.each do |cls|

            unless !TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id(@batch.id, d.id, p.id).nil?
              @time_entry = TimetableEntry.find_all_by_batch_id_and_subject_id(@batch.id,cls.id)

              unless @time_entry.empty?
              @count = @time_entry.count
              else
              @count = 0
              end

              if( @count < cls.max_weekly_classes)
                @room = RoomsSubject.find_by_subject_id(cls.id)
                @emp = EmployeesSubject.find_by_subject_id(cls.id)
                TimetableEntry.create(:batch_id=>@batch.id, :weekday_id => d.id, :class_timing_id => p.id, :subject_id => cls.id, :room_id => (@room.room_id unless @room.nil?), :employee_id => (@emp.employee_id unless @emp.nil?)) \
                if TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id_and_subject_id(@batch.id, d.id, p.id,cls.id).nil?
              end
            end
          end
        end
      end
    end

    respond_to do |format|
      format.json { render :json => {:valid => true,:notice => "Timetable save" }}
    end

  end

  def emp_max_find

    str = ""
    @batch = Batch.find(params[:object_id])
    unless @batch.nil?
      # @modi =  @batch.is_timetable_created

      unless @batch.is_timetable_created == true
        unless params[:emp_arr].empty?
          index = 0
          params[:emp_arr].each do |emp|
            @empentry = TimetableEntry.find_by_employee_id_and_class_timing_id(emp,params[:slot_arr][index])
            unless @empentry.nil?
              @employee = Employee.find_by_id(emp)
              unless @employee.nil?
                if str == ""
                str = str + @employee.first_name + @employee.last_name
                else
                  str = str +","+ @employee.first_name + @employee.last_name
                end
              end
            end
            index = index + 1
          end
        end
      end
    end

    if str == ""
      respond_to do |format|
        format.json { render :json => {:valid => true}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false,:notice => str }}
      end
    end

  end

  def create

    unless params[:batch_id].nil?
      @batch = Batch.find(params[:batch_id])

      unless @batch.nil?
        @modi =  @batch.is_timetable_created
        @timetable_entry = TimetableEntry.find_by_batch_id(@batch.id)

        @err = ""
        @error = "no"
        if !params[:map].empty?
          params[:map].each do |index,val|
            @arr = val.split(',')
            @subject = Subject.find(@arr[0])
            @employee = @arr[2]

            unless @subject.nil?

              unless @subject.update_attributes(:max_weekly_classes => @arr[1],:class_timing_id => @arr[3])
                @error = "yes"
              @err = @subject.errors
              else
                @employeesubject =  EmployeesSubject.find_by_subject_id(@subject.id)
                @subject_room =  RoomsSubject.find_by_subject_id(@subject.id)
                if @subject_room.nil? && @arr[4] != 'undefined'
                  @subject_room_create =  RoomsSubject.new(:subject_id => @subject.id,:room_id => @arr[4])
                  if @subject_room_create.save
                    else
                    @error = "yes"
                  @err = @subject_room.error
                  end
                else
                  if @arr[4] != 'undefined'
                    if  !@subject_room.update_attributes(:room_id => @arr[4])
                      @error = "yes"
                    @err = @subject_room.error
                    end
                  end
                end

                if @employeesubject.nil? && @employee != 'undefined'
                  @employee_create =  EmployeesSubject.new(:subject_id => @subject.id,:employee_id => @employee)
                  if @employee_create.save

                    else
                    @error = "yes"
                  @err = @employee_create.error

                  end
                else
                  if @employee != 'undefined'
                    if  !@employeesubject.update_attributes(:employee_id => @employee)
                      @error = "yes"
                    @err = @employee_create.error
                    end
                  end
                end
              end

            end
          end

        end

        @batch.update_attributes(:is_timetable_created => true)

        if (!@batch.is_timetable_created == true) || (@timetable_entry.nil?)
          respond_to do |format|
            if @error == "yes"
              str = "error during execution"
              format.json { render :json => {:valid => false, :errors => "Error"}}
            else
              format.json { render :json => {:valid => true,:notice => "Timetable save" }}
            end

          end
        else
          respond_to do |format|
            format.json { render :json => {:already => true,:batch_id => @batch.id }}
          end

        end
      end
    end
  end

  def find_max_class
@total_assign = 0
    str = "<br/><br/>"
    @sub = Subject.find(params[:id])
    @total_assign = 0
    # @employee = Employee.find(params[:emp])
    # unless @employee.nil?
    # @employee_time_entry = TimetableEntry.where("batch_id !=#{params[:batch]}").find(:all,:conditions =>{:employee_id => @employee.id},:order => "class_timing_id asc")
    # unless @employee_time_entry.empty?
    #
    # @employee_time_entry.each do |emp|
    # @week = TimetableEntry.week(emp)
    # str = str + emp.batch.full_name + "&nbsp;&nbsp;&nbsp;&nbsp;"+  emp.class_timing.start_time.strftime("%I:%M")+"-"+emp.class_timing.end_time.strftime("%I:%M") + "&nbsp;&nbsp;&nbsp;&nbsp;"+ @week +"<br/><br/>"
    # end
    # end
    # end
    unless @sub.nil?
      @max = @sub.max_weekly_classes
      @assign = TimetableEntry.find_all_by_subject_id(params[:id])
      unless @assign.empty?
       @total_assign = @assign.count
      end
    end

    if @max <= @total_assign

      @message = "This will exceed Subject maximum classes limit"
    end
    respond_to do |format|
      if @max <= @total_assign
        format.json { render :json => {:valid => true,:notice => @message,:emp_assign => str }}
      else
        format.json { render :json => {:valid => false,:emp_assign => str}}
      end
    end
  end

  def show

    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @batch = Batch.find(params[:id])
    @timetable = TimetableEntry.find_all_by_batch_id(params[:id])
    @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :order =>'start_time ASC')
    if @class_timing.empty?
      @class_timing = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    end
    @day = Weekday.find_all_by_batch_id(@batch.id)
    if @day.empty?
      @day = Weekday.default
    end
    @subjects = Subject.find_all_by_batch_id(@batch.id)
    @map = {}
    if !@day.empty?
      @day.each do |d|
        @map[d.weekday] = d.id
      end

    end
    @arr = []
    @arr1 = []
    unless @class_timing.empty?
      ind = 0
      @count = @class_timing.count
      @div = (100/@count.to_f).to_f

      @class_timing.each do |tim|
        @arr[ind] = @div * ind
        ind = ind + 1
      end
    @arr1 = @arr.reverse

    end

  end

  def generate_subject_wise
    @batch = Batch.find params[:id]
    @start_date = @batch.start_date.to_date
    @end_date = @batch.end_date.to_date
    not_set_for_batch = Weekday.for_batch(@batch.id).empty?
    set = 0
    (@start_date..@end_date).each do |d|
      weekday = not_set_for_batch ? (Weekday.find_by_batch_id_and_weekday(nil,d.wday)) :  (Weekday.find_by_batch_id_and_weekday(@batch.id,d.wday))
      unless weekday.nil?

        unless params[:arr].nil? && params[:class_time].nil? && params[:week].nil?
          params[:week].each_with_index do |value,index|
            @week =  weekday.id
            @value = value.to_i
            if @week == @value
              @period = PeriodEntrySubjectWise.find_all_by_month_date_and_batch_id_and_subject_id_and_class_timing_id(d,@batch.id,params[:arr][index],params[:class_time][index])
              if @period.empty?
                unless Event.is_a_holiday?(d)
                  unless Event.is_a_batch_holiday?(d,@batch.id)
                    PeriodEntrySubjectWise.create(:month_date=> d, :batch_id => @batch.id,:subject_id => params[:arr][index],:class_timing_id => params[:class_time][index])
                  set = 2
                  end
                end
              # else
              # if d >= Date.today
              # entries = TimetableEntry.find_all_by_weekday_id_and_batch_id(weekday.id, @batch.id)
              # entries.each do |tte|
              # @period.each do |p|
              # if tte.class_timing_id == p.class_timing_id
              # unless tte.subject_id == p.subject_id
              # PeriodEntry.update(p.id, :month_date=> d, :batch_id => @batch.id, :subject_id => tte.subject_id, :class_timing_id =>tte.class_timing_id, :employee_id => tte.employee_id)
              # set = 1
              # end
              # end
              # end
              #
              # end
              # end
              end
            end

          end
        end
      end
    end

    respond_to do |format|

      if set == 0
        format.json { render :json => {}}
      else
        format.json { render :json => {}}
      end
    end
  end

  def generate

    @batch = Batch.find params[:id]
    @start_date = @batch.start_date.to_date
    @end_date = @batch.end_date.to_date
    not_set_for_batch = Weekday.for_batch(@batch.id).empty?
    set = 0
    (@start_date..@end_date).each do |d|
      weekday = not_set_for_batch ? (Weekday.find_by_batch_id_and_weekday(nil,d.wday)) :  (Weekday.find_by_batch_id_and_weekday(@batch.id,d.wday))
      unless weekday.nil?
        @period = PeriodEntry.find_all_by_month_date_and_batch_id(d,@batch.id)
        if @period.empty?

          unless Event.is_a_holiday?(d)

            unless Event.is_a_batch_holiday?(d,@batch.id)
              PeriodEntry.create(:month_date=> d, :batch_id => @batch.id)
            set = 2
            end

          end
        end
      end

    end
    respond_to do |format|

      if set == 0
        format.json { render :json => {:notice => 'Timetable has already been published'}}
      else
        format.json { render :json => {:notice => "Time table Published"}}
      end
    end

  end

  def extra_class
    @config = Configuration.available_modules
    unless   params[:extra_class].nil?
      @date = params[:extra_class][:date].to_date
      @batch = Batch.find(params[:extra_class][:batch_id])
      @period_entry = PeriodEntry.find_all_by_month_date_and_batch_id(@date,@batch.id)
      render (:update) do |page|
        if @period_entry.blank?
          flash[:notice] = 'No timetable entry for selected date'
          page.replace_html 'extra-class-form', :partial=>"no_period_entry"
        else
          page.replace_html 'extra-class-form', :partial => "extra_class_form"
        end
      end
    end

  end

  def extra_class_edit
    @config = Configuration.available_modules
    @period_id = params[:id]
    @period_entry = PeriodEntry.find(@period_id)
    @subjects = Subject.find_all_by_batch_id(@period_entry.batch_id,:conditions=>'is_deleted=false')
    @employee = EmployeesSubject.find_all_by_subject_id(@period_entry.subject_id)
  end

  def list_employee_by_subject
    # @period_id = params[:period_id]
    @subject = Subject.find(params[:id])
    @skill = Skill.find_by_id(@subject.skill_id)
    @employee = @skill.employees
    render "_list_employee_by_subject",:layout => false

  end

  def save_extra_class
    @period = PeriodEntry.find(params[:period_entry][:period_id])
    PeriodEntry.update(@period.id, :subject_id => params[:period_entry][:subject_id], :employee_id => params[:period_entry][:employee_id])
    @period = PeriodEntry.find(params[:period_entry][:period_id])
    render (:update) do |page|
      page.replace_html "tr-extra-class-#{@period.id}", :partial => 'extra_class_update'
    end
  end

  def timetable
    @config = Configuration.available_modules
    @batches = Batch.active
    unless params[:next].nil?
      @today = params[:next].to_date
      render (:update) do |page|
        page.replace_html "timetable", :partial => 'table'
      end
    else
      @today = Date.today
    end
  end

  def delete_subject
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @errors = {"messages" => []}
    tte = TimetableEntry.update(params[:id], :subject_id => nil)
    @timetable = TimetableEntry.find_all_by_batch_id(tte.batch_id)
    render :partial => "edit_tt_multiple", :with => @timetable
  end

  def edit
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @errors = {"messages" => []}
    @batch = Batch.find(params[:id])
    @timetable = TimetableEntry.find_all_by_batch_id(params[:id])
    @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :conditions => "is_break = false")
    if @class_timing.empty?
      @class_timing = ClassTiming.default
    end
    @day = Weekday.find_all_by_batch_id(@batch.id)
    if @day.empty?
      @day = Weekday.default
    end
    @subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>["elective_group_id IS NULL AND is_deleted = false"])
  end

  def select_class
    @batches = Batch.active
    if request.post?
      unless params[:timetable_entry][:batch_id].empty?
        @batch = Batch.find(params[:timetable_entry][:batch_id])
        @class_timings = ClassTiming.find_all_by_batch_id(@batch.id)
        if @class_timings.empty?
          @class_timings = ClassTiming.default
        end
        @days = Weekday.find_all_by_batch_id(@batch.id)
        if @days.empty?
          @days = Weekday.default
        end
        @days.each do |d|
          @class_timings.each do |p|
            TimetableEntry.create(:batch_id=>@batch.id, :weekday_id => d.id, :class_timing_id => p.id) \
            if TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id(@batch.id, d.id, p.id).nil?
          end
        end

        redirect_to :action => "edit", :id => @batch.id
      else
        flash[:notice]="Select a batch to continue"
        redirect_to :action => "select_class"
      end
    end
  end

  def weekdays
    @batches = Batch.active
  end

  def tt_entry_update
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @errors = {"messages" => []}
    subject = Subject.find(params[:sub_id])
    TimetableEntry.update(params[:tte_id], :subject_id => params[:sub_id])
    @timetable = TimetableEntry.find_all_by_batch_id(subject.batch_id)
    render :partial => "edit_tt_multiple", :with => @timetable
  end

  def tt_entry_noupdate
    render :update => "error_div_#{params[:tte_id]}", :text => "Cancelled."
  end

  def update_multiple_timetable_entries
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    subject = Subject.find(params[:subject_id])
    tte_ids = params[:tte_ids].split(",").each {|x| x.to_i}
    course = subject.batch
    @validation_problems = {}

    tte_ids.each do |tte_id|
      errors = { "info" => {"sub_id" => subject.id, "tte_id" => tte_id},
        "messages" => [] }

      # check for weekly subject limit.
      errors["messages"] << "Weekly subject limit reached." \
      if subject.max_weekly_classes <= TimetableEntry.count(:conditions => "subject_id = #{subject.id}")

      if errors["messages"].empty?
        TimetableEntry.update(tte_id, :subject_id => subject.id)
      else
      @validation_problems[tte_id] = errors
      end
    end

    @timetable = TimetableEntry.find_all_by_batch_id(course.id)
    render :partial => "edit_tt_multiple", :with => @timetable
  end

  def view
    @courses = Batch.active
  end

  def student_view

    @user = current_user
    @role = @user.role_name
    if @role == "Student"
    student = @user.student_record
    @batch = student.batch
    else
      @batch = Batch.find(params[:id])
    end

    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :order =>'start_time ASC')
    if @class_timing.empty?
      @class_timing = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    end
    @day = Weekday.find_all_by_batch_id(@batch.id)
    if @day.empty?
      @day = Weekday.default
    end
    @subjects = Subject.find_all_by_batch_id(@batch.id)
    @map = {}
    if !@day.empty?
      @day.each do |d|
        @map[d.weekday] = d.id
      end

    end
    @arr = []
    @arr1 = []
    unless @class_timing.empty?
      ind = 0
      @count = @class_timing.count
      @div = (100/@count.to_f).to_f

      @class_timing.each do |tim|
        @arr[ind] = @div * ind
        ind = ind + 1
      end
    @arr1 = @arr.reverse

    end

  end

  def admin_wise_employee_page
    # @employee_category = EmployeeCategory.find_by_name("Teaching")
    # unless @employee_category.nil?
    # @employee = Employee.find(:all,:conditions =>{:employee_category_id => @employee_category.id} )
    @employee = Employee.all
  # end
  end

  def teacher_change
    redirect_to :action => :employee_full_view
  end

  def employee_full_view

    @minutess = 0
    # @weekday = {}
    @weekday = []
    @timetable_entries = []
    @day = []
    @class_timing = []
    @subject = []
    @user = current_user
    @role = @user.role_name
    unless  params[:id].nil?
      @employee = Employee.find_by_id(params[:id])
    else
    @employee = @user.employee_record
    end

    unless  @employee.nil?

      # @timetable_entries =  TimetableEntry.find_all_by_employee_id(@employee.id,:order => "class_timing_id asc")
      # @class_timing = ClassTiming.default

      @timetable_entries = TimetableEntry.find_all_by_employee_id(@employee.id)
      @timetable_entries.sort! { |a,b| a.class_timing.start_time.to_time <=> b.class_timing.start_time.to_time  }

      @weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      @day = Weekday.default
    else
      redirect_to :back
    end

  # @arr = []
  # @arr1 = []
  # unless @class_timing.empty?
  # ind = 0
  # @count = @class_timing.count
  # @div = (100/@count.to_f).to_f
  # @class_timing.each do |tim|
  # @arr[ind] = @div * ind
  # ind = ind + 1
  # end
  # @arr1 = @arr.reverse
  # else
  # redirect_to :back
  # end

  end

  def update_timetable_view
    if params[:course_id] == ""
      render :update do |page|
        page.replace_html "timetable_view", :text => ""
      end
    return
    end
    @batch = Batch.find(params[:course_id])
    @timetable = TimetableEntry.find_all_by_batch_id(@batch.id)
    @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :conditions => "is_break = false")
    if @class_timing.empty?
      @class_timing = ClassTiming.default
    end
    @day = Weekday.find_all_by_batch_id(@batch.id)
    if @day.empty?
      @day = Weekday.default
    end

    @subjects = Subject.find_all_by_batch_id(@batch.id)
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    render :update do |page|
      page.replace_html "timetable_view", :partial => "view_timetable"
    end
  end

  #methods given below are for timetable with HR module connected

  def select_class2
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @batches = Batch.active
    if request.post?
      unless params[:timetable_entry][:batch_id].empty?
        @batch = Batch.find(params[:timetable_entry][:batch_id])
        @class_timings = ClassTiming.find_all_by_batch_id(@batch.id, :conditions => "is_break = false")
        if @class_timings.empty?
          @class_timings = ClassTiming.default
        end
        @day = Weekday.find_all_by_batch_id(@batch.id)
        if @day.empty?
          @day = Weekday.default
        end
        @day.each do |d|
          @class_timings.each do |p|
            TimetableEntry.create(:batch_id=>@batch.id, :weekday_id => d.id, :class_timing_id => p.id) \
            if TimetableEntry.find_by_batch_id_and_weekday_id_and_class_timing_id(@batch.id, d.id, p.id).nil?
          end
        end
        redirect_to :action => "edit2", :id => @batch.id
      else
        flash[:notice]="Select a batch to continue"
        redirect_to :action => "select_class2"
      end
    end
  end

  def edit2
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @errors = {"messages" => []}
    @batch = Batch.find(params[:id])
    @timetable = TimetableEntry.find_all_by_batch_id(params[:id])
    @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :conditions =>[ "is_break = false"], :order =>'start_time ASC')
    if @class_timing.empty?
      @class_timing = ClassTiming.default
    end
    @day = Weekday.find_all_by_batch_id(@batch.id)
    if @day.empty?
      @day = Weekday.default
    end
    @subjects = Subject.find_all_by_batch_id(@batch.id)
  end

  def update_employees
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    if params[:subject_id] == ""
      render :text => ""
    return
    end
    @employees_subject = EmployeesSubject.find_all_by_subject_id(params[:subject_id])
    render :partial=>"employee_list"
  end

  def update_multiple_timetable_entries2
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    employees_subject = EmployeesSubject.find(params[:emp_sub_id])
    tte_ids = params[:tte_ids].split(",").each {|x| x.to_i}
    @batch = employees_subject.subject.batch
    subject = employees_subject.subject
    employee = employees_subject.employee
    @validation_problems = {}

    tte_ids.each do |tte_id|
      tte = TimetableEntry.find(tte_id)
      errors = { "info" => {"sub_id" => employees_subject.subject_id, "emp_id"=> employees_subject.employee_id,"tte_id" => tte_id},
        "messages" => [] }

      # check for weekly subject limit.
      errors["messages"] << "Weekly subject limit reached." \
      if subject.max_weekly_classes <= TimetableEntry.count(:conditions => "subject_id = #{subject.id}") unless subject.max_weekly_classes.nil?

      #check for overlapping classes
      overlap = TimetableEntry.find(:first,
      :conditions => "weekday_id = #{tte.weekday_id} AND
                                               class_timing_id = #{tte.class_timing_id} AND
                                               employee_id = #{employee.id}")
      unless overlap.nil?
        errors["messages"] << "Class overlap occured with Batch: #{overlap.batch.full_name}."
      end

      # check for max_hour_day exceeded
      errors["messages"] << "Max hours per day exceeded." \
      if employee.max_hours_per_day <= TimetableEntry.count(:conditions => "employee_id = #{employee.id} AND weekday_id = #{tte.weekday_id}") unless employee.max_hours_per_day.nil?

      # check for max hours per week
      errors["messages"] << "Max hours per week exceeded." \
      if employee.max_hours_per_week <= TimetableEntry.count(:conditions => "employee_id = #{employee.id}") unless employee.max_hours_per_week.nil?

      if errors["messages"].empty?
        TimetableEntry.update(tte_id, :subject_id => subject.id, :employee_id=>employee.id)
      else
      @validation_problems[tte_id] = errors
      end
    end

    @timetable = TimetableEntry.find_all_by_batch_id(@batch.id)
    render :partial => "edit_tt_multiple2"
  end

  def delete_employee2
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @errors = {"messages" => []}
    tte=TimetableEntry.update(params[:id], :subject_id => nil, :employee_id => nil)
    @timetable = TimetableEntry.find_all_by_batch_id(tte.batch_id)
    render :partial => "edit_tt_multiple2", :with => @timetable
  end

  def tt_entry_update2
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @errors = {"messages" => []}
    subject = Subject.find(params[:sub_id])
    tte = TimetableEntry.find(params[:tte_id])
    overlapped_tte = TimetableEntry.find_by_weekday_id_and_class_timing_id_and_employee_id(tte.weekday_id,tte.class_timing_id,params[:emp_id])
    if overlapped_tte.nil?
      TimetableEntry.update(params[:tte_id], :subject_id => params[:sub_id], :employee_id => params[:emp_id])
    else
      TimetableEntry.update(overlapped_tte.id,:subject_id => nil, :employee_id => nil )
      TimetableEntry.update(params[:tte_id], :subject_id => params[:sub_id], :employee_id => params[:emp_id])
    end
    @timetable = TimetableEntry.find_all_by_batch_id(subject.batch_id)
    render :partial => "edit_tt_multiple2", :with => @timetable
  end

  def tt_entry_noupdate2
    render :update => "error_div_#{params[:tte_id]}", :text => "Cancelled."
  end

  #PDF Reports
  def timetable_pdf
    @batch = Batch.find(params[:course_id])
    @timetable = TimetableEntry.find_all_by_batch_id(@batch.id)
    @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :conditions => "is_break = false")
    if @class_timing.empty?
      @class_timing = ClassTiming.default
    end
    @day = Weekday.find_all_by_batch_id(@batch.id)
    if @day.empty?
      @day = Weekday.default
    end
    @subjects = Subject.find_all_by_batch_id(@batch.id)
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    render :pdf=>'timetable_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"

  #  respond_to do |format|
  #    format.pdf { render :layout => false }
  #  end
  end

  def substitution_report_center

  end

  def report_sunstitute_function(params)
    @howreport = "Absent Employees List";
    @empids = ""
    @substitute = true
    @emparr = []
    @emparrobj = []
    @absent = EmployeeAttendance.find(:all, :conditions => ["attendance_date BETWEEN '#{params[:start_date].to_date.to_s}' AND '#{params[:end_date].to_date.to_s}'"])
    unless @absent.empty?
      @absent.each do |ab|
        @emparr << ab.employee_id unless @emparr.include? ab.employee_id
      end
      unless @emparr.empty?
        @emparr.each do |emmab|
          if @empids == ""
          @empids = @empids + emmab.to_s
          else
            @empids = @empids + "," +  emmab.to_s
          end
          employee = Employee.find_by_id(emmab)
          @emparrobj << employee
        end
      end
    end
  end

  def report_function(params)
    @howreport = "List of Associated Teachers";
    @empids = ""
    @substitute = false
    @emparr = []
    @emparrobj = []
    @absent = TimetableSubstitution.find(:all, :conditions => ["date BETWEEN '#{params[:start_date].to_date.to_s}' AND '#{params[:end_date].to_date.to_s}'"])
    unless @absent.empty?
      @absent.each do |ab|
        @emparr << ab.teacher_substitude_with_id unless @emparr.include? ab.teacher_substitude_with_id
      end
      unless @emparr.empty?
        @emparr.each do |emmab|
          if @empids == ""
          @empids = @empids + emmab.to_s
          else
            @empids = @empids + "," +  emmab.to_s
          end
          employee = Employee.find_by_id(emmab)
          @emparrobj << employee
        end
      end
    end
  end

  def report_daily_sunstitute_function(params)
    @employee = Employee.find_by_id(params[:emp_id])
    @absentemployee = EmployeeAttendance.find(:all, :conditions => ["employee_id = #{params[:emp_id]} AND (attendance_date BETWEEN '#{params[:start_date].to_date.to_s}' AND '#{params[:end_date].to_date.to_s}')"])

    unless @absentemployee.empty?
      @absentemployee.each do |ab|
        substituteentry = TimetableSubstitution.find_all_by_date_and_employee_id(ab.attendance_date.to_date.to_s,params[:emp_id] )
        unless substituteentry.empty?
          substituteentry.each do |subab|
            @map << subab
          end
        end
      end
    end
    unless @map.empty?
      @map.sort! { |a,b| a.class_timing.start_time.to_time <=> b.class_timing.start_time.to_time  }
    end
  end

  def report_daily_function(params)
    @employee = Employee.find_by_id(params[:emp_id])
    substituteentry = TimetableSubstitution.find(:all, :conditions => ["teacher_substitude_with_id = #{@employee.id} AND date BETWEEN '#{params[:start_date].to_date.to_s}' AND '#{params[:end_date].to_date.to_s}'"])
    unless substituteentry.empty?
      substituteentry.each do |subab|
        @map << subab
      end
    end
    unless @map.empty?
      @map.sort! { |a,b| a.class_timing.start_time.to_time <=> b.class_timing.start_time.to_time  }
    end
  end

  def timetable_substitution_monthly_report

    if params[:howreport] == "substitute"
      report_sunstitute_function( params)
    else
      report_function(params)
    end
    render '_timetable_substitution_monthly_report',:layout => false
  end

  def timetable_substitution_daily_report
    @substitute = params[:subd];
    @map = []
    if @substitute == "true"
      report_daily_sunstitute_function(params)
    else
      report_daily_function(params)
    end
    render '_timetable_substitution_daily_report',:layout => false

  end

  def employeetimetable_pdf
    @employee  = Employee.find(params[:emp_id])

    @minutess = 0
    # @weekday = {}
    @weekday = []
    @timetable_entries = []
    @day = []
    @class_timing = []
    @subject = []

    unless  @employee.nil?

      # @timetable_entries =  TimetableEntry.find_all_by_employee_id(@employee.id,:order => "class_timing_id asc")
      # @class_timing = ClassTiming.default
      @timetable_entries = TimetableEntry.find_all_by_employee_id(@employee.id)
      @timetable_entries.sort! { |a,b| a.class_timing.start_time.to_time <=> b.class_timing.start_time.to_time  }
      @weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      @day = Weekday.default

    end
    # @batch = Batch.find(params[:batch_id])
    # @timetable = TimetableEntry.find_all_by_batch_id(@batch.id)
    # @class_timing = ClassTiming.find_all_by_batch_id(@batch.id, :conditions => "is_break = false")
    # if @class_timing.empty?
    # @class_timing = ClassTiming.default
    # end
    # @day = Weekday.find_all_by_batch_id(@batch.id)
    # if @day.empty?
    # @day = Weekday.default
    # end
    # @subjects = Subject.find_all_by_batch_id(@batch.id)
    # @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    render :pdf=>'timetable_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"

  #  respond_to do |format|
  #    format.pdf { render :layout => false }
  #  end
  end

  def monthlytimetable_pdf
    puts params
    @title = params[:title]
    @emparr = params[:emp_id]
    @emparrobj = []
    unless @emparr.nil?

      @emparr.split(',').each do |emmab|
        employee = Employee.find_by_id(emmab)
        @emparrobj << employee
      end
    end
    render :pdf=>'timetable_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end

  def dailytimetable_pdf
    @substitute = params[:subd];
    @map = []
    if @substitute == "true"
      report_daily_sunstitute_function(params)
    else
      report_daily_function(params)
    end
    render :pdf=>'timetable_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end

  def timetable_batch_selected_pdf
    @batch_array=  params[:batch_ids].split(',')
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    respond_to do |format|
      if params[:type] == "pdf"
        format.html {render :pdf=>'timetable_batch_selected_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                      :bottom => 20,
                      :left=> 30,
                      :right => 30},:disposition  => "attachment"}

      else
       format.xls
      end
    end
  end
end
