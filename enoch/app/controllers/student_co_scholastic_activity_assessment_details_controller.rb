class StudentCoScholasticActivityAssessmentDetailsController < ApplicationController
  # GET /student_co_scholastic_activity_assessment_details
  # GET /student_co_scholastic_activity_assessment_details.json
  def index
    @student_co_scholastic_activity_assessment_details = StudentCoScholasticActivityAssessmentDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_co_scholastic_activity_assessment_details }
    end
  end

  # GET /student_co_scholastic_activity_assessment_details/1
  # GET /student_co_scholastic_activity_assessment_details/1.json
  def show
    @student_co_scholastic_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_co_scholastic_activity_assessment_detail }
    end
  end

  # GET /student_co_scholastic_activity_assessment_details/new
  # GET /student_co_scholastic_activity_assessment_details/new.json
  def new
    @student_co_scholastic_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_co_scholastic_activity_assessment_detail }
    end
  end

  # GET /student_co_scholastic_activity_assessment_details/1/edit
  def edit
    @student_co_scholastic_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.find(params[:id])
  end

  # POST /student_co_scholastic_activity_assessment_details
  # POST /student_co_scholastic_activity_assessment_details.json
  def create
    @student_co_scholastic_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.new(params[:student_co_scholastic_activity_assessment_detail])

    respond_to do |format|
      if @student_co_scholastic_activity_assessment_detail.save
        format.html { redirect_to @student_co_scholastic_activity_assessment_detail, notice: 'Student co scholastic activity assessment detail was successfully created.' }
        format.json { render json: @student_co_scholastic_activity_assessment_detail, status: :created, location: @student_co_scholastic_activity_assessment_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @student_co_scholastic_activity_assessment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_co_scholastic_activity_assessment_details/1
  # PUT /student_co_scholastic_activity_assessment_details/1.json
  def update
    @student_co_scholastic_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.find(params[:id])

    respond_to do |format|
      if @student_co_scholastic_activity_assessment_detail.update_attributes(params[:student_co_scholastic_activity_assessment_detail])
        format.html { redirect_to @student_co_scholastic_activity_assessment_detail, notice: 'Student co scholastic activity assessment detail was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_co_scholastic_activity_assessment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_co_scholastic_activity_assessment_details/1
  # DELETE /student_co_scholastic_activity_assessment_details/1.json
  def destroy
    @student_co_scholastic_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.find(params[:id])
    @student_co_scholastic_activity_assessment_detail.destroy

    respond_to do |format|
      format.html { redirect_to student_co_scholastic_activity_assessment_details_url }
      format.json { head :ok }
    end
  end
end
