class AssessmentNamesController < ApplicationController
  before_filter :login_required
  # GET /assessment_names
  # GET /assessment_names.json
    def all_record
    @assessment_names = AssessmentName.new
    @active_assessment_names = AssessmentName.find(:all,:order => "name asc",:conditions=>{:is_active => true})
    @inactive_assessment_names = AssessmentName.find(:all,:order => "name asc",:conditions=>{:is_active => false})
    @record_count = AssessmentName.count(:all)
    
    response = { :active_assessment_names => @active_assessment_names, :inactive_assessment_names => @inactive_assessment_names, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  def index
    @assessment_names = AssessmentName.all
    @active_assessment_names = AssessmentName.find(:all,:order => "name asc",:conditions=>{:is_active => true})
    @inactive_assessment_names = AssessmentName.find(:all,:order => "name asc",:conditions=>{:is_active => false})
    @record_count = AssessmentName.count(:all)

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @assessment_names }
    end
  end

  # GET /assessment_names/1
  # GET /assessment_names/1.json
  def show
    @assessment_name = AssessmentName.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assessment_name }
    end
  end

  # GET /assessment_names/new
  # GET /assessment_names/new.json
  def new
    @assessment_name = AssessmentName.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assessment_name }
    end
  end

  # GET /assessment_names/1/edit
  def edit
    @assessment_name = AssessmentName.find(params[:id])
  end

  # POST /assessment_names
  # POST /assessment_names.json
  def create
    @assessment_name = AssessmentName.new(params[:assessment_name])

    respond_to do |format|
      if @assessment_name.save
        @record_count = AssessmentName.count(:all)
        format.html { redirect_to @assessment_name, notice: 'Assessment name was successfully created.' }
        format.json { render :json => {:valid => true, :assessment_name => @assessment_name, :notice => "Assessment name was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @assessment_name.errors}}
      end
    end
  end

  # PUT /assessment_names/1
  # PUT /assessment_names/1.json
  def update
    @assessment_name = AssessmentName.find(params[:id])

    respond_to do |format|
      if @assessment_name.update_attributes(params[:assessment_name])
        format.html { redirect_to @assessment_name, notice: 'Assessment name was successfully updated.' }
        format.json { render :json => {:valid => true, :assessment_name => @assessment_name, :notice => "Assessment name was successfully updated."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :assessment_name.errors => @assessment_name.errors}}
      end
    end
  end

  # DELETE /assessment_names/1
  # DELETE /assessment_names/1.json
  def destroy
    @assessment_name = AssessmentName.find(params[:id])
    @assessment_name.destroy

    respond_to do |format|
      format.html { redirect_to assessment_names_url }
      format.json { render :json => {:valid => true,  :notice => "Assessment name is deleted successfully." }}
    end
  end
end
