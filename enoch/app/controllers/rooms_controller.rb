class RoomsController < ApplicationController
 before_filter :login_required
 filter_access_to :all
  
  def all_record
    @weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @class_timings =  ClassTiming.find(:all,:conditions => {:batch_id => nil})
    @weekdays =  Weekday.find(:all,:conditions => {:batch_id => nil})
    @room = Room.new
    @rooms = Room.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_rooms = Room.find(:all,:order => "name asc",:conditions=>{:status => false})
    @employees = Employee.find(:all,:order => "first_name asc",:conditions=> {:status => true})
    # @batches = Batch.find(:all, :order => "name asc", :conditions => {:is_deleted => false})
    @batches =[]
    @record_count = Room.count(:all)
    @courses = Course.active
    response = { :rooms => @rooms, :inactive_rooms => @inactive_rooms, :record_count => @record_count}
    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end

  def change_room_batch  
   @batches = Batch.find(:all, :conditions => {:course_id => params[:q], :is_active => true})
   render :partial => 'room_batch'
  end

def find_room_skill
  @for_one = []
  @name = []
  @room = Room.find_by_id(params[:id])
    unless @room.nil?
      @room_skills = @room.skills
        unless @room_skills.empty?
          @room_skills.each do |skill|
            @for_one << skill.id
            @name << skill.full_name.to_s
          end
        end  
    end
  
  respond_to do |format|
   format.json  { render :json => {:forone => @for_one,:name => @name } }
  end
end

def room_skill_assign
  @valid = "no"
  @arr_skill = []
  @all_skills = []
  @room = Room.find_by_id(params[:room_id])
  unless @room.nil?
                 unless params[:full].nil?
                  params[:full].each do |val|
                    
                             @skill = Skill.find_by_id(val)
                             @all_skills <<  @skill
                         
                  end
                  unless @all_skills.empty?
                     @room.skills = @all_skills
                           if @room.save
                             @valid = "yes"
                           else
                             @valid = @room.errors
                             return
                           end  
                  end
              else
                @room.skills = []
                if @room.save
                   @valid = "yes"
                else
                    @valid = @room.errors
                    return
                end  
              end
   end
  
  
  
   

    respond_to do |format|
      if @valid == "yes"
        format.json { render :json => {:valid => true,:notice => "Skills was successfully Assigned."}}
      else
        format.json { render :json => {:valid => false, :errors => @valid}}
      end
    end
end



def find_room_constraints
  
  @for_one = []
  @for_one1 = []
  @room = Room.find_by_id(params[:id])
    unless @room.nil?
      @room_constraints = RoomConstraint.find_all_by_room_id(@room.id)
        unless @room_constraints.empty?
          @room_constraints.each do |room|
            @for_one << room.weekday_id
            @for_one1 << room.class_timing_id
          end
        end  
    end
  
  respond_to do |format|
  format.json  { render :json => {:forone => @for_one,:forone1 => @for_one1 } }
  end
end
  # GET /rooms
  # GET /rooms.json
  def index
    @all_rooms = Room.all
    @rooms = Room.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_rooms = Room.find(:all,:order => "name asc",:conditions=>{:status => false})
    @employees = Employee.find(:all,:order => "first_name asc",:conditions=> {:status => true})
    # @batches = Batch.find(:all, :order => "name asc", :conditions => {:is_deleted => false})
    @batches =[]
   response = { :rooms => @rooms, :inactive_rooms => @inactive_rooms, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/new
  # GET /rooms/new.json
  def new
    @room = Room.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(params[:room])
    respond_to do |format|
      if @room.save
        @record_count = Room.count(:all)
        format.html { redirect_to @room, notice: 'Resource was successfully created.' }
        format.json { render :json => {:valid => true, :room => @room, :notice => "Resource was successfully created."}}
      else
        @str = @room.errors.to_json
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @room.errors}}
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update
    @room = Room.find(params[:id])
    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to @room, notice: 'Resource was updated successfully .' }
        format.json { render :json => {:valid => true, :room => @room, :notice => "Resource was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :room.errors => @room.errors}}
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { render :json => {:valid => true,  :notice => "Resource was deleted successfully."}}
    end
  end
end
