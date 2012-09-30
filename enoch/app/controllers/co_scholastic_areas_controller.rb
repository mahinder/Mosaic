class CoScholasticAreasController < ApplicationController
  
 before_filter :login_required
  # GET /co_scholastic_areas
  # GET /co_scholastic_areas.json
  def index
    @co_scholastic_areas = CoScholasticArea.all
    
    @active_scholastic_areas = CoScholasticArea.find(:all,:conditions=>{:status => true})
    @inactive_scholastic_areas = CoScholasticArea.find(:all,:conditions=>{:status => false})
    @record_count = CoScholasticArea.count(:all)
    response = { :active_scholastic_areas => @active_scholastic_areas, :inactive_scholastic_areas => @inactive_scholastic_areas, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout=>false}
      format.json  { render :json => response }
    end
  end

  # GET /co_scholastic_areas/1
  # GET /co_scholastic_areas/1.json
  def show
    @co_scholastic_area = CoScholasticArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @co_scholastic_area }
    end
  end

  # GET /co_scholastic_areas/new
  # GET /co_scholastic_areas/new.json
  def new
    @co_scholastic_area = CoScholasticArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @co_scholastic_area }
    end
  end

  # GET /co_scholastic_areas/1/edit
  def edit
    @co_scholastic_area = CoScholasticArea.find(params[:id])
  end

  # POST /co_scholastic_areas
  # POST /co_scholastic_areas.json
  def create
    @co_scholastic_area = CoScholasticArea.new(params[:co_scholastic_area])
    course_list = params[:course_list]
    if @co_scholastic_area.validate_uniqueness_of_name(params)
      @errors = true
    end
    respond_to do |format|
      if @errors.nil?
          if @co_scholastic_area.save
            course_list.each do |course|
              courses = Course.find_by_id(course)
              @co_scholastic_area.courses << courses unless  @co_scholastic_area.courses.include?(courses)
            end
            format.html { redirect_to @co_scholastic_area, notice: 'Co scholastic area was successfully created.' }
            format.json { render :json => {:valid => true, :co_scholastic_area => @co_scholastic_area, :notice => "Co scholastic area was successfully created."}}
          else
            format.html { render action: "new" }
            format.json { render :json => {:valid => false, :errors => @co_scholastic_area.errors}}
          end
      else
        str = "has already been taken for the selected Course"
        dependency_errors = {:name=> [*str]}
        format.json { render :json => {:valid => false, :errors=>dependency_errors} }
      end
    end
  end

  # PUT /co_scholastic_areas/1
  # PUT /co_scholastic_areas/1.json
  def update
    @co_scholastic_area = CoScholasticArea.find(params[:id])
    course_list = params[:course_list]
    if @co_scholastic_area.validate_uniqueness_of_name(params)
      @errors = true
    end
    respond_to do |format|
      if @errors.nil?
      if @co_scholastic_area.update_attributes(params[:co_scholastic_area])
        course_list.each do |course|
          course_obj = Course.find_by_id(course)
           unless @co_scholastic_area.courses.include?(course_obj)
            @co_scholastic_area.courses << course_obj
           end
           @co_scholastic_area.courses.each do |dd|
             unless course_list.include?(dd.id.to_s)
               @co_scholastic_area.courses.delete(dd)
             end
           end
         end
        format.html { redirect_to @co_scholastic_area, notice: 'Co scholastic area was successfully updated.' }
        format.json { render :json => {:valid => true, :co_scholastic_area => @co_scholastic_area, :notice => "Co scholastic area was successfully updated"} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :errors => @co_scholastic_area.errors} }
      end
      else
        str = "has already been taken for the selected Course"
        dependency_errors = {:name=> [*str]}
        format.json { render :json => {:valid => false, :errors=>dependency_errors} }
      end
    end
  end

  # DELETE /co_scholastic_areas/1
  # DELETE /co_scholastic_areas/1.json
  def destroy
    @co_scholastic_area = CoScholasticArea.find(params[:id])
    @co_scholastic_area.destroy

    respond_to do |format|
      format.html { redirect_to co_scholastic_areas_url }
      format.json { render :json => {:valid => true,  :notice => "Co scholastic area was deleted successfully."}}
    end
  end
  
  def all_record
    @co_scholastic_area = CoScholasticArea.new
    @courses = Course.active
    @active_scholastic_areas = CoScholasticArea.find(:all,:conditions=>{:status => true})
    @inactive_scholastic_areas = CoScholasticArea.find(:all,:conditions=>{:status => false})
    @record_count = CoScholasticArea.count(:all)
    response = { :active_scholastic_areas => @active_scholastic_areas, :inactive_scholastic_areas => @inactive_scholastic_areas, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  def add_scholastic_area_subskill
    render :partial=>'add_scholastic_area_subskill'
  end
end
