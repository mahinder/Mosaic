class TimetableInterfaceController < ApplicationController
  filter_access_to :all
  def  courses
    @courses  = Course.active
    render :json => {:response => @courses}
  end

  def  skills
    @Skills  = Skill.active
    render :json => {:response => @Skills}
  end

  def  rooms
    @rooms  = Room.all
    render :json => {:response => @rooms}
  end

  def  teachers
    @teachers  = Employee.all
    @skils = {}
    @arr = []
    @skill_ids = ""
    unless @teachers.empty?
      @teachers.each do |teach|
        @skill_ids = ""
        unless teach.skills.empty?

          teach.skills.each do |ids|
            if @skill_ids == ""
            @skill_ids = @skill_ids + ids.id.to_s
            else
              @skill_ids  = @skill_ids + ","+ids.id.to_s
            end

          end
        end
        @skils[teach.id.to_s] = @skill_ids
      end
    @arr << @skils
    end
    puts @teachers.count
    render :json => {:response => @teachers,:skils => @arr }

  end

  def  batches
    @batches  = Batch.active
    render :json => {:response => @batches}
  end

  def  subjects
    @subjects  = Subject.find(:all,:conditions => {:is_deleted => false})
    puts @subjects
    render :json => {:response => @subjects}
  end

  def  weekdays
    @weekdays  = Weekday.default
    render :json => {:response => @weekdays}
  end

  def  timeslots
    @classtimming  = ClassTiming.find(:all,:conditions => {:batch_id => nil})
    render :json => {:response => @classtimming}
  end
  
  
  def  teacher_constraints
    @teacher_constraints  = EmployeeConstraint.all
    render :json => {:response => @teacher_constraints}
  end
  def  room_constraints
    @room_constraints  = RoomConstraint.all
    render :json => {:response => @room_constraints}
  end
end
