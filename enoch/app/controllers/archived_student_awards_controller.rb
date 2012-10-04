class ArchivedStudentAwardsController < ApplicationController
   filter_access_to :all
  # GET /archived_student_awards
  # GET /archived_student_awards.json
  def index
    @archived_student_awards = ArchivedStudentAward.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @archived_student_awards }
    end
  end

  # GET /archived_student_awards/1
  # GET /archived_student_awards/1.json
  def show
    @archived_student_award = ArchivedStudentAward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @archived_student_award }
    end
  end

  # GET /archived_student_awards/new
  # GET /archived_student_awards/new.json
  def new
    @archived_student_award = ArchivedStudentAward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @archived_student_award }
    end
  end

  # GET /archived_student_awards/1/edit
  def edit
    @archived_student_award = ArchivedStudentAward.find(params[:id])
  end

  # POST /archived_student_awards
  # POST /archived_student_awards.json
  def create
    @archived_student_award = ArchivedStudentAward.new(params[:archived_student_award])

    respond_to do |format|
      if @archived_student_award.save
        format.html { redirect_to @archived_student_award, notice: 'Archived student award was successfully created.' }
        format.json { render json: @archived_student_award, status: :created, location: @archived_student_award }
      else
        format.html { render action: "new" }
        format.json { render json: @archived_student_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /archived_student_awards/1
  # PUT /archived_student_awards/1.json
  def update
    @archived_student_award = ArchivedStudentAward.find(params[:id])

    respond_to do |format|
      if @archived_student_award.update_attributes(params[:archived_student_award])
        format.html { redirect_to @archived_student_award, notice: 'Archived student award was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @archived_student_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archived_student_awards/1
  # DELETE /archived_student_awards/1.json
  def destroy
    @archived_student_award = ArchivedStudentAward.find(params[:id])
    @archived_student_award.destroy

    respond_to do |format|
      format.html { redirect_to archived_student_awards_url }
      format.json { head :ok }
    end
  end
end
