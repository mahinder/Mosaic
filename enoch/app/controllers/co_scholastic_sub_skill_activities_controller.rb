class CoScholasticSubSkillActivitiesController < ApplicationController
  # GET /co_scholastic_sub_skill_activities
  # GET /co_scholastic_sub_skill_activities.json
  def index
    @co_scholastic_sub_skill_activities = CoScholasticSubSkillActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @co_scholastic_sub_skill_activities }
    end
  end

  # GET /co_scholastic_sub_skill_activities/1
  # GET /co_scholastic_sub_skill_activities/1.json
  def show
    @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @co_scholastic_sub_skill_activity }
    end
  end

  def add_scholastic_activity_subskill
   @scholastic_activity=params[:scholastic_activity]
   @co_scholastic_sub_skill_activities = CoScholasticSubSkillActivity.find_all_by_co_scholastic_activity_id(@scholastic_activity,:conditions=>{:is_active=>true})
   @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.new
 
    render :partial=>'add_scholastic_activity_subskill'
  end
  
  # GET /co_scholastic_sub_skill_activities/new
  # GET /co_scholastic_sub_skill_activities/new.json
  def new
    @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @co_scholastic_sub_skill_activity }
    end
  end

  # GET /co_scholastic_sub_skill_activities/1/edit
  def edit
    @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.find(params[:id])
  end

  # POST /co_scholastic_sub_skill_activities
  # POST /co_scholastic_sub_skill_activities.json
  def create
    @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.new(params[:co_scholastic_sub_skill_activity])

    respond_to do |format|
      if @co_scholastic_sub_skill_activity.save
        format.html { redirect_to @co_scholastic_sub_skill_activity, notice: 'Co scholastic sub skill activity was successfully created.' }
        format.json { render :json=>{:valid=>true,:co_scholastic_sub_skill_activity=>@co_scholastic_sub_skill_activity,:notice=>'Sub skill was successfully created.'}}
      else
        format.html { render action: "new" }
        format.json { render :json=>{:valid=>false,:errors=>@co_scholastic_sub_skill_activity.errors}}
      end
    end
  end

  # PUT /co_scholastic_sub_skill_activities/1
  # PUT /co_scholastic_sub_skill_activities/1.json
  def update
    @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.find(params[:id])
      scholastic_activity=@co_scholastic_sub_skill_activity.co_scholastic_activity
      if @co_scholastic_sub_skill_activity.update_attributes(params[:co_scholastic_sub_skill_activity])
        @co_scholastic_sub_skill_activities=CoScholasticSubSkillActivity.find_all_by_co_scholastic_activity_id(scholastic_activity.id)
        render :partial=>'view_scholastic_activity_subskill'
      end
  end

  # DELETE /co_scholastic_sub_skill_activities/1
  # DELETE /co_scholastic_sub_skill_activities/1.json
  def destroy
      @co_scholastic_sub_skill_activity = CoScholasticSubSkillActivity.find(params[:id])
      scholastic_activity=@co_scholastic_sub_skill_activity.co_scholastic_activity
      if @co_scholastic_sub_skill_activity.destroy
        @co_scholastic_sub_skill_activities=CoScholasticSubSkillActivity.find_all_by_co_scholastic_activity_id(scholastic_activity.id)
        render :partial=>'view_scholastic_activity_subskill'
      end
  end
  
 def view_scholastic_activity_subskill
   @co_scholastic_sub_skill_activities = CoScholasticSubSkillActivity.find_all_by_co_scholastic_activity_id(params[:scholastic_activity])
   render :partial=>'view_scholastic_activity_subskill'
  end
end
