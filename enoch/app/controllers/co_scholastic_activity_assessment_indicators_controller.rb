class CoScholasticActivityAssessmentIndicatorsController < ApplicationController
  before_filter :login_required
  # GET /co_scholastic_activity_assessment_indicators
  # GET /co_scholastic_activity_assessment_indicators.json
  def all_record
    @assessment_indicator = CoScholasticActivityAssessmentIndicator.new
    @co_scholastic_sub_skill_activity_id = params[:object_id]
    @co_scholastic_subSkill=  CoScholasticSubSkillActivity.find_by_id(@co_scholastic_sub_skill_activity_id)
    @co_scholastic_activity = @co_scholastic_subSkill.co_scholastic_activity
    @active_indicator = CoScholasticActivityAssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => true ,:co_scholastic_sub_skill_activity_id => @co_scholastic_sub_skill_activity_id})
    @inactive_indicator = CoScholasticActivityAssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => false ,:co_scholastic_sub_skill_activity_id => @co_scholastic_sub_skill_activity_id})
    @record_count = CoScholasticActivityAssessmentIndicator.count(:all)
    
    response = { :active_indicator => @active_indicator, :inactive_indicator => @inactive_indicator, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false }
      format.json  { render :json => response }
    end
  end  
  
  def index
    @assessment_indicators = CoScholasticActivityAssessmentIndicator.all
    @co_scholastic_sub_skill_activity_id = params[:object_id]
    @co_scholastic_subSkill=  CoScholasticSubSkillActivity.find_by_id(@co_scholastic_sub_skill_activity_id)
    @co_scholastic_activity = @co_scholastic_subSkill.co_scholastic_activity
    @active_indicator = CoScholasticActivityAssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => true,:co_scholastic_sub_skill_activity_id => @co_scholastic_sub_skill_activity_id})
    @inactive_indicator = CoScholasticActivityAssessmentIndicator.find(:all,:order => "indicator_value asc",:conditions=>{:is_active => false,:co_scholastic_sub_skill_activity_id => @co_scholastic_sub_skill_activity_id})
    @record_count = CoScholasticActivityAssessmentIndicator.count(:all)
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @assessment_indicators }
    end
  end

  # GET /co_scholastic_activity_assessment_indicators/1
  # GET /co_scholastic_activity_assessment_indicators/1.json
  def show
    @co_scholastic_activity_assessment_indicator = CoScholasticActivityAssessmentIndicator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @co_scholastic_activity_assessment_indicator }
    end
  end

  # GET /co_scholastic_activity_assessment_indicators/new
  # GET /co_scholastic_activity_assessment_indicators/new.json
  def new
    @co_scholastic_activity_assessment_indicator = CoScholasticActivityAssessmentIndicator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @co_scholastic_activity_assessment_indicator }
    end
  end

  # GET /co_scholastic_activity_assessment_indicators/1/edit
  def edit
    @co_scholastic_activity_assessment_indicator = CoScholasticActivityAssessmentIndicator.find(params[:id])
  end

  # POST /co_scholastic_activity_assessment_indicators
  # POST /co_scholastic_activity_assessment_indicators.json
  def create
     @assessment_indicator = CoScholasticActivityAssessmentIndicator.new(params[:assessment_indicator])
        respond_to do |format|
          if @assessment_indicator.save
            format.html { redirect_to @assessment_indicator, notice: 'Assessment indicator was successfully created.' }
             format.json { render :json => {:valid => true, :assessment_indicator => @assessment_indicator, :sub_skill =>@assessment_indicator.co_scholastic_sub_skill_activity_id, :notice => "Assessment indicator was successfully created."}}
          else
            format.html { render action: "new" }
            format.json { render :json => {:valid => false, :errors => @assessment_indicator.errors}}
          end
        end
  end

  # PUT /co_scholastic_activity_assessment_indicators/1
  # PUT /co_scholastic_activity_assessment_indicators/1.json
  def update
    @assessment_indicator = CoScholasticActivityAssessmentIndicator.find(params[:id])
    respond_to do |format|
      if @assessment_indicator.update_attributes(params[:assessment_indicator])
       format.html { redirect_to @assessment_indicator, notice: 'Assessment indicator was successfully updated.' }
       format.json { render :json => {:valid => true, :assessment_indicator => @assessment_indicator,:sub_skill =>@assessment_indicator.co_scholastic_sub_skill_activity_id, :notice => "Assessment indicator was successfully updated."} }
      else
        format.html { render action: "edit" }
       format.json { render :json => {:valid => false, :assessment_indicator.errors => @assessment_indicator.errors}}
      end
    end
  end

  # DELETE /co_scholastic_activity_assessment_indicators/1
  # DELETE /co_scholastic_activity_assessment_indicators/1.json
  def destroy
    @assessment_indicator = CoScholasticActivityAssessmentIndicator.find(params[:id])
    @assessment_indicator.destroy
    respond_to do |format|
      format.html { redirect_to co_scholastic_activity_assessment_indicators_url }
      format.json { render :json => {:valid => true,:sub_skill =>"",  :notice => "Assessment indicator is deleted successfully." }}
    end
  end
end
