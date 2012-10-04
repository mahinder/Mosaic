class SubSkillsController < ApplicationController
   before_filter :login_required
   filter_access_to :all
  def index
  @subskills = []
  @skill = Skill.find(params[:id])
  unless @skill.nil?
    @subskills = @skill.sub_skills
  end
  respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /sub_skills/1
  # GET /sub_skills/1.json
  def show
    @sub_skill = SubSkill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_skill }
    end
  end

  # GET /sub_skills/new
  # GET /sub_skills/new.json
  def new
    @sub_skill = SubSkill.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_skill }
    end
  end

  # GET /sub_skills/1/edit
  def edit
    @sub_skill = SubSkill.find(params[:id])
  end

  # POST /sub_skills
  # POST /sub_skills.json
  def create
    @sub_skill = SubSkill.new(params[:sub_skill])
   respond_to do |format|
      if @sub_skill.save
         skill = Skill.find(params[:sub_skill][:skill_id])
         @oldsubskill = SubSkill.find_by_name_and_skill_id(skill.name,skill.id) 
         unless @oldsubskill.nil?
           @oldsubskill.update_attributes(:is_active => false)
         end
        subject = Subject.find_by_skill_id(skill.id)
        unless subject.nil?
          Topic.create(:name => @sub_skill.name,:subject_id => subject.id,:is_active => @sub_skill.is_active)
        end 
        format.html { redirect_to @sub_skill, notice: 'Subskill was successfully created.' }
        format.json { render :json => {:valid => true, :sub_skill => @sub_skill, :notice => "Subskill was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @sub_skill.errors}}
      end
    end
  end

  # PUT /sub_skills/1
  # PUT /sub_skills/1.json
  def update
    totalsubskill = []
    @sub_skill = SubSkill.find(params[:id])

     respond_to do |format|
      if @sub_skill.update_attributes(params[:sub_skill])
            subject = Subject.find_by_skill_id(@sub_skill.skill_id)
            skill = @sub_skill.skill
           unless subject.nil?
             topic =Topic.find_by_name_and_subject_id(@sub_skill.name,subject.id)
             unless topic.nil? 
               topic.update_attributes(:name => @sub_skill.name)
              end          
           end
           
             totalsubskill = SubSkill.find(:all,:conditions => {:is_active => true,:skill_id =>skill.id })
             count = totalsubskill.count
             puts count
           if count == 0
              @oldsubskill = SubSkill.find_by_name_and_skill_id(skill.name,skill.id) 
              unless @oldsubskill.nil?
                @oldsubskill.update_attributes(:is_active => true)
              end
           else
             @oldsubskill = SubSkill.find_by_name_and_skill_id(skill.name,skill.id) 
              unless @oldsubskill.nil?
                @oldsubskill.update_attributes(:is_active => false)
              end
           end
        
        format.html { redirect_to @sub_skill, notice: 'Subskill was successfully created.' }
        format.json { render :json => {:valid => true, :sub_skill => @sub_skill, :notice => "Subskill was successfully updated."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @sub_skill.errors}}
      end
    end
  end


def subskill_find
  @subskills = []
  @subskill = SubSkill.new
  @skill = Skill.find(params[:id])
  unless @skill.nil?
    @subskills = @skill.sub_skills
  end
   render :partial=>'new'
  
end

def subject_subskill
  @topics = []
  @subject = Subject.find(params[:id])
  unless @subject.nil?
    @topics = @subject.topics
  end
   render :partial=>'subject_topic'
end




  # DELETE /sub_skills/1
  # DELETE /sub_skills/1.json
  def destroy
    @sub_skill = SubSkill.find(params[:id])
    @sub_skill.destroy

     respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { render :json => {:valid => true,  :notice => "subskill was deleted successfully!"}}
    end
  end
end
