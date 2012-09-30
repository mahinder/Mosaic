class StudentAwardsController < ApplicationController
  before_filter :login_required
   filter_access_to :all
  # GET /student_awards
  # GET /student_awards.json
  
  def index
    @user = current_user
    @awardList = StudentAward.find_all_by_student_id(params[:id])
    render :partial => '/student/student_awards_list'
  end

  # GET /student_awards/1
  # GET /student_awards/1.json
  def show
    @student_award = StudentAward.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_award }
    end
  end

  # GET /student_awards/new
  # GET /student_awards/new.json
  def new
    @student_award = StudentAward.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_award }
    end
  end

  # GET /student_awards/1/edit
  def edit
    @user = current_user
    @student_award = StudentAward.find(params[:id])
    render :partial => 'edit'
  end

  # POST /student_awards
  # POST /student_awards.json
  def create
    @user = current_user
    @student_award = StudentAward.new(params[:student_award])
    respond_to do |format|
      if @student_award.save
        format.json { render :json =>{:valid => true,:notice => t(:award_created)}}
      else
        format.json { render :json => {:valid => false,:errors => @student_award.errors }}
      end
    end
  end

  # PUT /student_awards/1
  # PUT /student_awards/1.json
  def update
    @user = current_user
    @student_award = StudentAward.find(params[:id])
    respond_to do |format|
      if @student_award.update_attributes(params[:student_award])
         format.json { render :json => {:valid => true,:notice => t(:award_updated)}}
      else
        format.html { render action: "edit" }
        format.json { render json: @student_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_awards/1
  # DELETE /student_awards/1.json
  def destroy
    @user = current_user
    @student_award = StudentAward.find(params[:id])
    @student_award.destroy
    respond_to do |format|
       format.json { render :json =>{:valid => true,:notice => t(:award_deleted)}}
    end
  end
end
