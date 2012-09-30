class AssessmentIndicatorsController < ApplicationController
   before_filter :login_required
  # GET /assessment_indicators
  # GET /assessment_indicators.json
   def all_record
    @assessment_indicator = AssessmentIndicator.new
    @co_scholastic_sub_skill_area_id = params[:object_id]
    @co_scholastic_subSkill=  CoScholasticSubSkillArea.find_by_id(@co_scholastic_sub_skill_area_id)
    @co_scholastic_area = @co_scholastic_subSkill.co_scholastic_area
    @active_indicator = AssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => true ,:co_scholastic_sub_skill_area_id => @co_scholastic_sub_skill_area_id})
    @inactive_indicator = AssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => false ,:co_scholastic_sub_skill_area_id => @co_scholastic_sub_skill_area_id})
    @record_count = AssessmentIndicator.count(:all)
    
    response = { :positions => @active_master, :inactive_positions => @inactive_master, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false }
      format.json  { render :json => response }
    end
  end 
  
  
  def index
    @assessment_indicators = AssessmentIndicator.all
    @co_scholastic_sub_skill_area_id = params[:object_id]
    @co_scholastic_subSkill=  CoScholasticSubSkillArea.find_by_id(@co_scholastic_sub_skill_area_id)
    @co_scholastic_area = @co_scholastic_subSkill.co_scholastic_area
    @active_indicator = AssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => true,:co_scholastic_sub_skill_area_id => @co_scholastic_sub_skill_area_id})
    @inactive_indicator = AssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => false,:co_scholastic_sub_skill_area_id => @co_scholastic_sub_skill_area_id})
    @record_count = AssessmentIndicator.count(:all)
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @assessment_indicators }
    end
  end

  # GET /assessment_indicators/1
  # GET /assessment_indicators/1.json
  def show
    @assessment_indicator = AssessmentIndicator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assessment_indicator }
    end
  end

  # GET /assessment_indicators/new
  # GET /assessment_indicators/new.json
  def new
    @assessment_indicator = AssessmentIndicator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assessment_indicator }
    end
  end

  # GET /assessment_indicators/1/edit
  def edit
    @assessment_indicator = AssessmentIndicator.find(params[:id])
  end

  # POST /assessment_indicators
  # POST /assessment_indicators.json
  def create
    @assessment_indicator = AssessmentIndicator.new(params[:assessment_indicator])
        respond_to do |format|
          if @assessment_indicator.save
            format.html { redirect_to @assessment_indicator, notice: 'Assessment indicator was successfully created.' }
             format.json { render :json => {:valid => true, :assessment_indicator => @assessment_indicator, :sub_skill =>@assessment_indicator.co_scholastic_sub_skill_area_id, :notice => "Assessment indicator was successfully created."}}
          else
            format.html { render action: "new" }
            format.json { render :json => {:valid => false, :errors => @assessment_indicator.errors}}
          end
        end
  end

  # PUT /assessment_indicators/1
  # PUT /assessment_indicators/1.json
  def update
    @assessment_indicator = AssessmentIndicator.find(params[:id])
    respond_to do |format|
      if @assessment_indicator.update_attributes(params[:assessment_indicator])
       format.html { redirect_to @assessment_indicator, notice: 'Assessment indicator was successfully updated.' }
       format.json { render :json => {:valid => true, :assessment_indicator => @assessment_indicator,:sub_skill =>@assessment_indicator.co_scholastic_sub_skill_area_id, :notice => "Assessment indicator was successfully updated."} }
      else
        format.html { render action: "edit" }
       format.json { render :json => {:valid => false, :assessment_indicator.errors => @assessment_indicator.errors}}
      end
    end
  end

  # DELETE /assessment_indicators/1
  # DELETE /assessment_indicators/1.json
  def destroy
    @assessment_indicator = AssessmentIndicator.find(params[:id])
    @assessment_indicator.destroy
    respond_to do |format|
      format.html { redirect_to assessment_indicators_url }
      format.json { render :json => {:valid => true,:sub_skill =>"",  :notice => "Assessment indicator is deleted successfully." }}
    end
  end
end
