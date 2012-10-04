class ClassTimingsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  def index
    @courses = Course.active
    @class_timing = ClassTiming.new
    @batches = []
    @class_timings = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
  end

  def new
    @class_timing = ClassTiming.new
    @batch = Batch.find params[:id] if request.xhr? and params[:id]
    respond_to do |format|
      format.js { render :action => 'new' }
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

  def time
    @class_timing =ClassTiming.find_by_id(params[:class_timing_id])

    if @class_timing.batch.nil?
      @class_timings = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    else
      @class_timings = ClassTiming.for_batch(@class_timing.batch_id)
    @batch = @class_timing.batch
    end
    render '_show_batch_timing',:layout => false
  end

  def create
    @class_timing = ClassTiming.new(params[:class_timing])
    @batch = @class_timing.batch
    respond_to do |format|
      if @class_timing.save
        format.html { redirect_to @courses, :course_value => @course_value, :course_for => @course_for}
        #format.json { render json: @employee_grade, status: :created, location: @employee_grade }
        format.json { render :json => {:valid => true,:class_timing_id => @class_timing.id,  :notice => "Class Timing is Added  successfully." }}
      else
        format.html { render action: "new" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @class_timing.errors}}
      end
    end
  end

  def edit
    @class_timing = ClassTiming.find(params[:id])
    respond_to do |format|
      format.js { render :action => 'edit' }
    end
  end

  def update
    puts params[:class_timing]
    @class_timing = ClassTiming.find params[:id]
    respond_to do |format|
      if @class_timing.update_attributes(params[:class_timing])

        #     flash[:notice] = 'Class timing updated successfully.'
        format.html { redirect_to @courses, :course_value => @course_value, :course_for => @course_for}
        #format.json { render json: @employee_grade, status: :created, location: @employee_grade }
        format.json { render :json => {:valid => true,:class_timing_id => @class_timing.id,  :notice => "Class Timing is Updated  successfully." }}
      else
        format.html { render action: "new" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @class_timing.errors}}
      end
    end
  end

  def show
    @batch = nil
    if params[:batch_id] == ''
      @class_timings = ClassTiming.find(:all, :conditions=>["batch_id is null"])
    else
      @class_timings = ClassTiming.for_batch(params[:batch_id])
      @batch = Batch.find params[:batch_id] unless params[:batch_id] == ''
    end
    render "_show_batch_timing",:layout => false
  end

  def del_class_time
   
    unless params[:id]=='null'
      @batch = Batch.find params[:id]
    end
    if @batch.nil?
      @class_timings = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    else
      @class_timings = ClassTiming.find(:all,:conditions => { :batch_id => @batch.id}, :order =>'start_time ASC')
    @batch = @batch
    end
    render "_show_batch_timing",:layout => false
  end

  def destroy
    @class_timing = ClassTiming.find params[:id]
    @timetableentry = TimetableEntry.find_by_class_timing_id(@class_timing.id)
   if @timetableentry.nil?
        @class_timing.destroy
        respond_to do |format|
      format.json { render :json => {:valid => true,:batch_id => @class_timing.batch_id,  :notice => "Class Timing is Deleted  successfully." }}
    end
   else
     respond_to do |format|
      format.json { render :json => {:valid => false,:batch_id => @class_timing.batch_id,  :notice => "Unable to Delete class timing due to some timetable Dependences first delete timetable entries." }}
    end
   
   end

    

  end

def find_class_timing
   
   if params[:batch].nil?
    @start_time = ClassTiming.find(:last,:conditions => { :batch_id => nil}, :order =>'start_time ASC') 
   else
    @start_time = ClassTiming.find(:last,:conditions => { :batch_id => params[:batch]}, :order =>'start_time ASC') 
   end
  
   if @start_time.nil?
     
      @institute_start_time = SchoolConfiguration.find_by_config_key("ShiftStartTime") 
      @time_start_hour = Time.parse(@institute_start_time.config_value).strftime('%H')
      @time_start_minute = Time.parse(@institute_start_time.config_value).strftime('%M')
      @change = @time_start_hour.to_i + 1
    else
       @time_start_hour = @start_time.end_time.strftime('%H')
       @time_start_minute = @start_time.end_time.strftime('%M')
       @change = @time_start_hour.to_i + 1
        
   end
   
    respond_to do |format|
      format.json { render :json => {:valid => true,:time_start_hour => @time_start_hour,:time_start_minute => @time_start_minute,:change => @change }}
    end
   
  end

end
