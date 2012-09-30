class CoScholasticSubSkillAreasController < ApplicationController
  # GET /co_scholastic_sub_skill_areas
  # GET /co_scholastic_sub_skill_areas.json
  def index
    @co_scholastic_sub_skill_areas = CoScholasticSubSkillArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @co_scholastic_sub_skill_areas }
    end
  end

  # GET /co_scholastic_sub_skill_areas/1
  # GET /co_scholastic_sub_skill_areas/1.json
  def show
    @co_scholastic_sub_skill_area = CoScholasticSubSkillArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @co_scholastic_sub_skill_area }
    end
  end

  # GET /co_scholastic_sub_skill_areas/new
  # GET /co_scholastic_sub_skill_areas/new.json
 def add_scholastic_area_subskill
   @scholastic_area=params[:scholastic_area]
   @co_scholastic_sub_skill_areas = CoScholasticSubSkillArea.find_all_by_co_scholastic_area_id(@scholastic_area)
   @co_scholastic_sub_skill_area = CoScholasticSubSkillArea.new
 
    render :partial=>'add_scholastic_area_subskill'
  end

  # GET /co_scholastic_sub_skill_areas/1/edit
  def edit
    @co_scholastic_sub_skill_area = CoScholasticSubSkillArea.find(params[:id])
    render :partial=>'edit_scholastic_sub_skill_area'
  end

  # POST /co_scholastic_sub_skill_areas
  # POST /co_scholastic_sub_skill_areas.json
  def create
    @co_scholastic_sub_skill_area = CoScholasticSubSkillArea.new(params[:co_scholastic_sub_skill_area])

    respond_to do |format|
      if @co_scholastic_sub_skill_area.save
        format.html { redirect_to @co_scholastic_sub_skill_area, notice: 'Co scholastic sub skill area was successfully created.' }
        format.json { render :json=>{:valid=>true,:co_scholastic_sub_skill_area=>@co_scholastic_sub_skill_area,:notice=>'Sub Skill was successfully created.'}}
      else
        format.html { render action: "new" }
       format.json { render :json=>{:valid=>false,:errors=>@co_scholastic_sub_skill_area.errors}}
      end
    end
  end

  # PUT /co_scholastic_sub_skill_areas/1
  # PUT /co_scholastic_sub_skill_areas/1.json
  def update
      @co_scholastic_sub_skill_area = CoScholasticSubSkillArea.find(params[:id])
      scholastic_area=@co_scholastic_sub_skill_area.co_scholastic_area
   
      if @co_scholastic_sub_skill_area.update_attributes(params[:co_scholastic_sub_skill_area])
        @co_scholastic_sub_skill_areas=CoScholasticSubSkillArea.find_all_by_co_scholastic_area_id(scholastic_area.id)
        render :partial=>'view_scholastic_area_subskill'
      end
  end

  # DELETE /co_scholastic_sub_skill_areas/1
  # DELETE /co_scholastic_sub_skill_areas/1.json
  def destroy
    @co_scholastic_sub_skill_area = CoScholasticSubSkillArea.find(params[:id])
    scholastic_area=@co_scholastic_sub_skill_area.co_scholastic_area
    if @co_scholastic_sub_skill_area.destroy
      @co_scholastic_sub_skill_areas=CoScholasticSubSkillArea.find_all_by_co_scholastic_area_id(scholastic_area.id,:conditions=>{:is_active=>true})
    render :partial=>'view_scholastic_area_subskill'
      end
  end
  def view_scholastic_area_subskill
   @co_scholastic_sub_skill_areas = CoScholasticSubSkillArea.find_all_by_co_scholastic_area_id(params[:scholastic_area])
   render :partial=>'view_scholastic_area_subskill'
  end
end
