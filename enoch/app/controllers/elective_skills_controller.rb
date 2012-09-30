class ElectiveSkillsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  # GET /elective_skills
  # GET /elective_skills.json
  def index
    puts params[:course_for]
   @course_for = params[:course_for]
   @course = Course.find_by_id(params[:course_id])
   response = {:course_for => @course_for,:course => @course}
   respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /elective_skills/1
  # GET /elective_skills/1.json
  def show
      @elective_skill = ElectiveSkill.find(params[:id])
      @course = Course.find(params[:course_id])
      response = {:course => @course,:elective => @elective_skill}
      render '/courses/_skills', :layout => false
      # respond_to do |format|
        # format.html  { render :layout => false } 
        # format.json { render :json => response }
      # end
  end

  # GET /elective_skills/new
  # GET /elective_skills/new.json
  def new
    puts params
    @elective_skill = ElectiveSkill.new
    @course_id = params[:course_id]
  # respond_to do |format|
  # format.html # new.html.erb
  # format.json { render json: @elective_skill }
  # end
  end

  # GET /elective_skills/1/edit
  def edit
    @elective_skill = ElectiveSkill.find(params[:id])
  end

  # POST /elective_skills
  # POST /elective_skills.json
  def create
    @elective_skill = ElectiveSkill.new(params[:elective_skill])
 
      respond_to do |format|
           if @elective_skill.save
                format.json { render :json => {:valid => true,:id => @elective_skill.id,:name => @elective_skill.name,:notice => 'Elective skill was successfully created.'}}
               else
                 format.html { render action: "new" }
                  #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
                 format.json { render :json => {:valid => false, :errors => @elective_skill.errors}}
           end
    end
  end
  # PUT /elective_skills/1
  # PUT /elective_skills/1.json
  def update
    @elective_skill = ElectiveSkill.find(params[:id])
    
     respond_to do |format|
      if @elective_skill.update_attributes(params[:elective_skill])
        format.json { render :json => {:valid => true ,:notice => 'Elective skill was successfully updated.'}}
        
      else
       format.json { render :json => {:valid => false , :errors => @elective_skill.errors}} 
    end
  end
    # respond_to do |format|
      # if @elective_skill.update_attributes(params[:elective_skill])
        # format.html { redirect_to :controller =>'courses',:action => 'all', notice: 'Elective skill was successfully updated.' }
        # format.json { head :ok }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @elective_skill.errors, status: :unprocessable_entity }
      # end
   
  end

  # DELETE /elective_skills/1
  # DELETE /elective_skills/1.json
  def destroy
    @elective_skill = ElectiveSkill.find(params[:id])
     if @elective_skill.skills.empty?
      @elective_skill.destroy
      respond_to do |format|
        format.html { redirect_to elctive_skill_url }
        format.json { render :json => {:valid => true,  :notice => "elective skill was deleted successfully."}}
      end
    else
      respond_to do |format|
      #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false}}
      end   end
   end
end
