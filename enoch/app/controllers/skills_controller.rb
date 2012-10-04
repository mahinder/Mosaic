class SkillsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  def index
    @skills = Skill.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @skills }
    end
  end

  # GET /skills/1
  # GET /skills/1.json
  def show
    @skill = Skill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @skill }
    end
  end

  # GET /mandatoryw
  # GET /skills/new.json
  def new
    @skill = Skill.new
    @course_id = params[:course_id]
    if !params[:elective_skill_id].nil?
      @elective_skill_id=params[:elective_skill_id]
    end
  # respond_to do |format|
  # format.html # new.html.erb
  # format.json { render json: @skill }
  # end
  end

  def remove_batch
    @skill = Skill.find(params[:id])
    unless params[:assign_values].nil? || params[:assign_values].empty?
      params[:assign_values].each do |val|
        @subject = Subject.new(:name=>@skill.name,:code=> @skill.code,:batch_id=>val,:no_exams=>@skill.no_exam,
        :max_weekly_classes=>@skill.max_weekly_classes,:is_deleted=>false,:skill_id => @skill.id,:is_common => @skill.is_common,:elective_group_id => @skill.elective_skill_id)
        @subject.save
      end
    end
    unless params[:deassign_values].nil? || params[:deassign_values].empty?
      params[:deassign_values].each do |val|
        @subject = Subject.find_by_skill_id_and_batch_id(@skill.id,val)
        @subject.destroy
      end
    end
    respond_to do |format|
      format.json { render :json => {:valid => true}}
    end
  end

  # GET /skills/1/edit
  def edit
    @skill = Skill.find(params[:id])
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.new(params[:skill])

    respond_to do |format|
      if @skill.save
        @subskill = SubSkill.new(:name=>@skill.name,:skill_id =>@skill.id )
        @subskill.save
        @course = Course.find_by_id(params[:course_id])
        @batches = @course.batches.active
        @batches.each do |batch|
          if params[:skill][:elective_skill_id] != ""
            unless params[:students_ids].nil?
              params[:students_ids].each do |ids|
                @subject = Subject.new(:name=>@skill.name,:code=> @skill.code,:batch_id=>ids,:no_exams=>@skill.no_exam,
                :max_weekly_classes=>@skill.max_weekly_classes,:is_deleted=>false,:skill_id => @skill.id,:is_common => @skill.is_common,:elective_group_id => @skill.elective_skill_id)
                @subject.save
              end
            end
          else
          # @subject = Subject.new(:name=>@skill.name,:code=> @skill.code,:batch_id=>batch.id,:no_exams=>@skill.no_exam,
          # :max_weekly_classes=>@skill.max_weekly_classes,:is_deleted=>false,:skill_id => @skill.id,:is_common => @skill.is_common,:elective_group_id => @skill.elective_skill_id)
          # @subject.save
          end

        end
        format.html { redirect_to @courses}
        #format.json { render json: @employee_grade, status: :created, location: @employee_grade }
        format.json { render :json => {:valid => true}}
      else
        format.html { render action: "new" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @skill.errors}}
      end
    end
  end

  def create_elective_skill
    @elective = ElectiveSkill.find_by_id(params[:id])
    @course = Course.find_by_id(params[:course])
    respond_to do |format|
      format.html  { render :layout => false }
      format.json { render :json => {:course => @course,:elective => @elective} }
    end
  end

  # PUT /skills/1
  # PUT /mandatoryjson
  def update

    @skill = Skill.find(params[:id])
    preskillupdate =@skill.is_active
    unless @skill.nil?
    old_name = @skill.name
    end

    if @skill.update_attributes(params[:skill])
      @subjects = Subject.find_all_by_skill_id(params[:id])
      if @skill.is_active?
          if preskillupdate == true
            @oldsubskill = SubSkill.find_by_name_and_skill_id(old_name,@skill.id)
            unless @oldsubskill.nil?
              @oldsubskill.update_attributes(:name=>@skill.name)
            end
          else
            @oldsubskill = SubSkill.find_by_name_and_skill_id(old_name,@skill.id)
            unless @oldsubskill.nil?
              @oldsubskill.update_attributes(:name=>@skill.name)
            end
            @subskill = SubSkill.find(:all,:conditions => {:is_active => false,:skill_id => @skill.id})
            unless @subskill.empty?
              @subskill.each do |skl|
                if skl.name != @skill.name
                  skl.update_attributes(:is_active => true )
                end
              end
  
            end
  
          end
       else
           @subskill = SubSkill.find(:all,:conditions => {:is_active => true,:skill_id => @skill.id})
            unless @subskill.empty?
              @subskill.each do |skl|
                skl.update_attributes(:is_active => false )
              end
            end  
          
      end
      unless @subjects.size == 0
        @subjects.each do |subject|
        # subject.update_attributes(:name=>@skill.name,:code=> @skill.code,:no_exams=>@skill.no_exam,
        # :max_weekly_classes=>@skill.max_weekly_classes,:is_common => @skill.is_common)
        # end
          if @skill.is_active?
            subject.update_attributes(:name=>@skill.name,:code=> @skill.code)
          end
        end
      end
      respond_to do |format|
        format.json { render :json => {:valid => true}}
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @skill.errors}}
      end
    end
  end

  def assigned
    @subjects = Subject.find_all_by_skill_id(params[:id],:conditions => {:is_deleted => false})

    @batchid= ''
    if @subjects.empty?
    @batchid = @batchid
    else
      @subjects.each do |sub|
        if @batchid == ''
        @batchid = @batchid + sub.batch_id.to_s
        else
          @batchid = @batchid+ ','+sub.batch_id.to_s
        end
      end
    end
    respond_to do |format|
      format.json { render :json => {:valid => true, :batchid => @batchid}}
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
    @skill = Skill.find(params[:id])
    @skill.inactivate
    # @subjects = Subject.find_all_by_skill_id(params[:id])
    # unless @subjects.empty?
      # @subjects.each do |subject|
        # subject.inactivate
      # end
    # end
    @subskill = SubSkill.find(:all,:conditions => {:is_active => true,:skill_id => @skill.id})
            unless @subskill.empty?
              @subskill.each do |skl|
                skl.update_attributes(:is_active => false )
              end
            end  
    respond_to do |format|
      format.html { redirect_to employee_grades_url }
      format.json { render :json => {:valid => true,  :notice => "skill was deleted successfully."}}
    end
  end
end
