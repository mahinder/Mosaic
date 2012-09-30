class CoScholasticActivitiesController < ApplicationController
  before_filter :login_required
  # GET /co_scholastic_activities
  # GET /co_scholastic_activities.json
  def all_record
    @co_scholastic_activity = CoScholasticActivity.new
    @courses = Course.active
    @active_scholastic_activity = CoScholasticActivity.find(:all,:conditions=>{:status => true})
    @inactive_scholastic_activity = CoScholasticActivity.find(:all,:conditions=>{:status => false})
    @record_count = CoScholasticActivity.count(:all)
    response = { :active_scholastic_activity => @active_scholastic_activity, :inactive_scholastic_activity => @inactive_scholastic_activity, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  def index
    @co_scholastic_activities = CoScholasticActivity.all
    @active_scholastic_activity = CoScholasticActivity.find(:all,:conditions=>{:status => true})
    @inactive_scholastic_activity = CoScholasticActivity.find(:all,:conditions=>{:status => false})
    @record_count = CoScholasticActivity.count(:all)
    response = { :active_scholastic_activity => @active_scholastic_activity, :inactive_scholastic_activity => @inactive_scholastic_activity, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout=>false}
      format.json  { render :json => response }
    end
  end

  # GET /co_scholastic_activities/1
  # GET /co_scholastic_activities/1.json
  def show
    @co_scholastic_activity = CoScholasticActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @co_scholastic_activity }
    end
  end

  # GET /co_scholastic_activities/new
  # GET /co_scholastic_activities/new.json
  def new
    @co_scholastic_activity = CoScholasticActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @co_scholastic_activity }
    end
  end

  # GET /co_scholastic_activities/1/edit
  def edit
    @co_scholastic_activity = CoScholasticActivity.find(params[:id])
  end

  # POST /co_scholastic_activities
  # POST /co_scholastic_activities.json
  def create
    @co_scholastic_activity = CoScholasticActivity.new(params[:co_scholastic_activity])
    course_list = params[:course_list]
    if @co_scholastic_activity.validate_uniqueness_of_name(params)
      @errors = true
    end
    respond_to do |format|
      if @errors.nil?
          if @co_scholastic_activity.save
            course_list.each do |course|
              courses = Course.find_by_id(course)
              @co_scholastic_activity.courses << courses unless  @co_scholastic_activity.courses.include?(courses)
            end
            format.html { redirect_to @co_scholastic_activity, notice: 'Co scholastic activity was successfully created.' }
            format.json { render :json => {:valid => true, :co_scholastic_activity => @co_scholastic_activity, :notice => "Co scholastic activity was successfully created."}}
          else
            format.html { render action: "new" }
            format.json { render :json => {:valid => false, :errors => @co_scholastic_activity.errors}}
          end
      else
        str = "has already been taken for the selected Course"
        dependency_errors = {:name=> [*str]}
        format.json { render :json => {:valid => false, :errors=>dependency_errors} }
      end
    end
  end

  # PUT /co_scholastic_activities/1
  # PUT /co_scholastic_activities/1.json
  def update
    @co_scholastic_activity = CoScholasticActivity.find(params[:id])
    course_list = params[:course_list]
    if @co_scholastic_activity.validate_uniqueness_of_name(params)
      @errors = true
    end
    respond_to do |format|
      if @errors.nil?
          if @co_scholastic_activity.update_attributes(params[:co_scholastic_activity])
            course_list.each do |course|
              course_obj = Course.find_by_id(course)
               unless @co_scholastic_activity.courses.include?(course_obj)
                @co_scholastic_activity.courses << course_obj
               end
               @co_scholastic_activity.courses.each do |dd|
                 unless course_list.include?(dd.id.to_s)
                   @co_scholastic_activity.courses.delete(dd)
                 end
               end
             end
            format.html { redirect_to @co_scholastic_activity, notice: 'Co scholastic activity was successfully updated.' }
            format.json { render :json => {:valid => true, :co_scholastic_ctivity => @co_scholastic_activity, :notice => "Co scholastic activity was successfully updated"} }
          else
            format.html { render action: "edit" }
            format.json { render :json => {:valid => false, :errors => @co_scholastic_activity.errors} }
          end
      else
        str = "has already been taken for the selected Course"
        dependency_errors = {:name=> [*str]}
        format.json { render :json => {:valid => false, :errors=>dependency_errors} }
      end
    end
  end

  # DELETE /co_scholastic_activities/1
  # DELETE /co_scholastic_activities/1.json
  def destroy
    @co_scholastic_activity = CoScholasticActivity.find(params[:id])
    @co_scholastic_activity.destroy

    respond_to do |format|
      format.html { redirect_to co_scholastic_activities_url }
      format.json { render :json => {:valid => true,  :notice => "Co scholastic activity was deleted successfully."}}
    end
  end
  
end
