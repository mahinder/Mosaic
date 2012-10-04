class GradingLevelGroupsController < ApplicationController
  # GET /grading_level_groups
  # GET /grading_level_groups.json
  def index
    
    @grading_level_group = GradingLevelGroup.all
    @active_grading_level_groups = GradingLevelGroup.find(:all,:order => "grading_level_group_name asc",:conditions=>{:is_active => true})
    @inactive_grading_level_groups = GradingLevelGroup.find(:all,:order => "grading_level_group_name asc",:conditions=>{:is_active => false})
    @record_count = GradingLevelGroup.count(:all)
   render :partial=>'grading_level_partial'
  end

  # GET /grading_level_groups/1
  # GET /grading_level_groups/1.json
  
  def all_record
    @grading_level_group = GradingLevelGroup.new
    @active_grading_level_groups = GradingLevelGroup.find(:all,:order => "grading_level_group_name asc",:conditions=>{:is_active => true})
    @inactive_grading_level_groups = GradingLevelGroup.find(:all,:order => "grading_level_group_name asc",:conditions=>{:is_active => false})
    @record_count = GradingLevelGroup.count(:all)
    response = { :active_grading_level_groups => @active_grading_level_groups, :inactive_grading_level_groups => @inactive_grading_level_groups, :record_count => @record_count}
    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  def show
    @grading_level_group = GradingLevelGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grading_level_group }
    end
  end

  # GET /grading_level_groups/new
  # GET /grading_level_groups/new.json
  def new
    @grading_level_group = GradingLevelGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grading_level_group }
    end
  end

  # GET /grading_level_groups/1/edit
  def edit
    @grading_level_group = GradingLevelGroup.find(params[:id])
  end

  # POST /grading_level_groups
  # POST /grading_level_groups.json
  def create
    @grading_level_group = GradingLevelGroup.new(params[:grading_level_group])

    respond_to do |format|
      if @grading_level_group.save
        format.html { redirect_to @grading_level_group, notice: 'Grading level group was successfully created.' }
        response = {:status=>'created', :location=> @grading_level_group,:notice => 'Grading level group was successfully created.'}
        format.json { render :json => response }
      else
        # log.errors "the problem is#{@grading_level_group.errors.full_messages}"
        format.html { render action: "new" }
        format.json { render json: @grading_level_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grading_level_groups/1
  # PUT /grading_level_groups/1.json
  def update
    @grading_level_group = GradingLevelGroup.find(params[:id])
    respond_to do |format|
      if @grading_level_group.update_attributes(params[:grading_level_group])
        format.html { redirect_to @grading_level_group, notice: 'Grading Level Group was successfully updated.' }
        format.json { render :json => {:valid => true, :grading_level_groups => @grading_level_group, :notice => "Grading Level Group was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :grading_level_groups.errors => @grading_level_group.errors}}
        #format.json { render json: @employee_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grading_level_groups/1
  # DELETE /grading_level_groups/1.json
  def destroy
  
    @grading_level_group = GradingLevelGroup.find(params[:id])
   exam_group = ExamGroup.find_by_grading_level_group_id(@grading_level_group.id)
    respond_to do |format|
      if exam_group.nil?
    @grading_level_group.destroy
      format.html { redirect_to grading_level_groups_url }
      format.json {render :json => {:valid => true,  :notice => "Grade was deleted successfully."} }
    else
       str = "Grading Level Group can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors => dependency_errors}}
    end
    end
  end
end
