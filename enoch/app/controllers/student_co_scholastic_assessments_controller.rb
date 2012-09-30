class StudentCoScholasticAssessmentsController < ApplicationController
  before_filter :login_required
  # GET /student_co_scholastic_assessments
  # GET /student_co_scholastic_assessments.json
 def index
    @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batch = employee_batches(@employee)
    @course= Course.active
    @batches =[]
    
    @student_co_scholastic_assessments = StudentCoScholasticAssessment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_assessments }
    end
  end

  # GET /student_assessments/1
  # GET /student_assessments/1.json
  def show
   @term=TermMaster.find_by_id(params[:term_id])
    @new_arr = []
    @term_id = ''
    @batch=Batch.find_by_id(params[:batch_id])
    @students=Student.find_all_by_batch_id(@batch.id)
    @students.sort! { |a,b| a.class_roll_no.to_i <=> b.class_roll_no.to_i }
    @co_scholastic_areas=@batch.course.co_scholastic_areas
    @co_scholastic_activities=@batch.course.co_scholastic_activities
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_assessment }
    end
  end

  # GET /student_assessments/new
  # GET /student_assessments/new.json
  def new
   @term=TermMaster.find_by_id(params[:assessment][:term_master_id])
    @batch=Batch.find_by_id(params[:co_scholastic_assessment][:batch_id])
    @student_co_scholastic_assessments = StudentCoScholasticAssessment.find_all_by_batch_id_and_term_master_id(@batch.id,@term.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_assessment }
    end
  end

  # GET /student_assessments/1/edit
  def edit
     @term=TermMaster.find_by_id(params[:term_id])
     @batch=Batch.find_by_id(params[:batch_id])
    @students=Student.find_all_by_batch_id(@batch.id)
    @student_co_scholastic_assessment = StudentCoScholasticAssessment.find(params[:id])
    @co_scholastic_areas=@batch.course.co_scholastic_areas
    @co_scholastic_activities=@batch.course.co_scholastic_activities
  end

  # POST /student_assessments
  # POST /student_assessments.json
  def create
    unless params[:student_assessment].nil?
        term_id = params[:term_id]
        name=params[:name]
        @student_co_scholastic_assessment = StudentCoScholasticAssessment.new
        @student_co_scholastic_assessment.school_session_id = current_session.id
        @student_co_scholastic_assessment.batch_id = params[:batch_id]
        @student_co_scholastic_assessment.term_master_id = term_id
        @student_co_scholastic_assessment.student_co_scholastic_assessment_name = name
        if @student_co_scholastic_assessment.save
            unless params[:student_assessment][:inputDataArea].nil?
              area_students = params[:student_assessment][:inputDataArea][:students]
              area_students_skills = params[:student_assessment][:inputDataArea][:sub_skill_id]
              area_indicator = params[:student_assessment][:inputDataArea][:indicator]
                unless save_student_assessment_area(@student_co_scholastic_assessment, area_students,area_students_skills,area_indicator)
                  @error = true
                end
            end
            unless params[:student_assessment][:inputDataActivity].nil?
                activity_students = params[:student_assessment][:inputDataActivity][:students]
                activity_students_skills = params[:student_assessment][:inputDataActivity][:sub_skill_id]
                activity_indicator  = params[:student_assessment][:inputDataActivity][:indicator]
                  unless save_student_assessment_activity(@student_co_scholastic_assessment, activity_students,activity_students_skills,activity_indicator)
                    @error = true
                  end
           end
        else
            @error = true
            @modal_error=@student_co_scholastic_assessment.errors
        end
    
          respond_to do |format|
            if @error.nil?
              format.html { redirect_to @student_co_scholastic_assessment, notice: 'Student assessment was successfully created.' }
               format.json { render :json => {:valid => true, :student_assessment => @student_co_scholastic_assessment, :notice => "Student assessment was successfully created."}}
            else
              format.html { render action: "new" }
              format.json { render :json => {:valid => false, :errors => @modal_error}}
            end
          end
        else
          respond_to do |format|
            str = "Sorry no Student found to create assessment"
          dependency_errors = {:dependency => [*str]}
          format.json { render :json => {:valid => false, :errors => dependency_errors}}
          end
      end
  end

  def update_student_assessment_area(student_assessment,student,sub_skill,indicator)
     status=""
     messages=""
    unless student.nil?
       student.each_with_index do |std, index|
         @student_area_assessment_detail = StudentCoScholasticAreaAssessmentDetail.new()
         student = Student.find_by_id(std)
         @student_area_assessment_detail.student_co_scholastic_assessment_id = student_assessment.id
         @student_area_assessment_detail.student_id = student.id
         @student_area_assessment_detail.co_scholastic_sub_skill_area_id = sub_skill[index]
         @student_area_assessment_detail.assessment_indicator_id = indicator[index]
        status = @student_area_assessment_detail.create_or_update_area_detail(student,sub_skill[index],student_assessment.id,indicator[index])[0]
        messages=@student_area_assessment_detail.create_or_update_area_detail(student,sub_skill[index],student_assessment.id,indicator[index])[1]
        end
        return [status,messages]
     end
     
  end
  
    def save_student_assessment_area(student_assessment,student,sub_skill,indicator)
    unless student.nil?
       student.each_with_index do |std, index|
         @student_area_assessment_detail = StudentCoScholasticAreaAssessmentDetail.new()
         student = Student.find_by_id(std)
         @student_area_assessment_detail.student_co_scholastic_assessment_id = student_assessment.id
         @student_area_assessment_detail.student_id = student.id
         @student_area_assessment_detail.co_scholastic_sub_skill_area_id = sub_skill[index]
         @student_area_assessment_detail.assessment_indicator_id = indicator[index]
         unless @student_area_assessment_detail.save
          @error =true
          @modal_error=@student_area_assessment_detail.errors
         end
       end
     end
  end
  
 def save_student_assessment_activity(student_assessment,student,sub_skill,indicator)
    unless student.nil?
       student.each_with_index do |std, index|
         student = Student.find_by_id(std)
         @student_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.new()
         @student_activity_assessment_detail.student_co_scholastic_assessment_id = student_assessment.id
         @student_activity_assessment_detail.student_id = student.id
         @student_activity_assessment_detail.co_scholastic_sub_skill_activity_id = sub_skill[index]
         @student_activity_assessment_detail.co_scholastic_activity_assessment_indicator_id = indicator[index]
         unless @student_activity_assessment_detail.save
          @error =true
           @modal_error=@student_activity_assessment_detail.errors
         end
       end
     end
  end
   def update_student_assessment_activity(student_assessment,student,sub_skill,indicator)
    status=""
     messages=""
    unless student.nil?
       student.each_with_index do |std, index|
         student = Student.find_by_id(std)
         @student_activity_assessment_detail = StudentCoScholasticActivityAssessmentDetail.new()
         @student_activity_assessment_detail.student_co_scholastic_assessment_id = student_assessment.id
         @student_activity_assessment_detail.student_id = student.id
         @student_activity_assessment_detail.co_scholastic_sub_skill_activity_id = sub_skill[index]
         @student_activity_assessment_detail.co_scholastic_activity_assessment_indicator_id = indicator[index]
        status = @student_activity_assessment_detail.create_or_update_activity_detail(student,sub_skill[index],student_assessment.id,indicator[index])[0]
        messages=@student_activity_assessment_detail.create_or_update_activity_detail(student,sub_skill[index],student_assessment.id,indicator[index])[1]
        end
        return [status,messages]
     end
  end
  
  # PUT /student_assessments/1
  # PUT /student_assessments/1.json
  def update
    
    unless params[:student_assessment].nil?
        term_id = params[:term_id]
        name=params[:name]
        @student_co_scholastic_assessment = StudentCoScholasticAssessment.find_by_id(params[:id])
        # @student_co_scholastic_assessment.school_session_id = current_session.id
        # @student_co_scholastic_assessment.batch_id = params[:batch_id]
        # @student_co_scholastic_assessment.term_master_id = term_id
        # @student_co_scholastic_assessment.student_co_scholastic_assessment_name = name
        if @student_co_scholastic_assessment.update_attributes(:student_co_scholastic_assessment_name => name)
           puts "updated"
            unless params[:student_assessment][:inputDataArea].nil?
              area_students = params[:student_assessment][:inputDataArea][:students]
              area_students_skills = params[:student_assessment][:inputDataArea][:sub_skill_id]
              area_indicator = params[:student_assessment][:inputDataArea][:indicator]
               @status=update_student_assessment_area(@student_co_scholastic_assessment, area_students,area_students_skills,area_indicator)[0]
                @modal_error=update_student_assessment_area(@student_co_scholastic_assessment, area_students,area_students_skills,area_indicator)[1]
                 
            end
            unless params[:student_assessment][:inputDataActivity].nil?
                activity_students = params[:student_assessment][:inputDataActivity][:students]
                activity_students_skills = params[:student_assessment][:inputDataActivity][:sub_skill_id]
                activity_indicator  = params[:student_assessment][:inputDataActivity][:indicator]
                @status=update_student_assessment_activity(@student_co_scholastic_assessment, activity_students,activity_students_skills,activity_indicator)[0]
                @modal_error=update_student_assessment_activity(@student_co_scholastic_assessment, activity_students,activity_students_skills,activity_indicator)[1]
           end
           
        else
         
            @status=false
            @modal_error=@student_co_scholastic_assessment.errors
        end
    
          respond_to do |format|
            if @status==true
               format.html { redirect_to @student_co_scholastic_assessment, notice: 'Student assessment was successfully created.' }
               format.json { render :json => {:valid => true, :student_assessment => @student_co_scholastic_assessment, :notice => @modal_error}}
            else
              format.html { render action: "new" }
              format.json { render :json => {:valid => false, :errors => @modal_error}}
            end
          end
        else
          respond_to do |format|
            str = "Sorry no Student found to create assessment"
          dependency_errors = {:dependency => [*str]}
          format.json { render :json => {:valid => false, :errors => dependency_errors}}
          end
      end
  end

  # DELETE /student_assessments/1
  # DELETE /student_assessments/1.json
  def destroy
    puts "i am in destro with params#{params}"
     @student_co_scholastic_assessment = StudentCoScholasticAssessment.find_by_id(params[:id])
     @batch=Batch.find_by_id(@student_co_scholastic_assessment.batch_id)
     @term=TermMaster.find_by_id(@student_co_scholastic_assessment.term_master_id)
    @student_co_scholastic_assessment.destroy
    @student_co_scholastic_assessments=StudentCoScholasticAssessment.find_all_by_batch_id_and_term_master_id(@batch.id,@term.id)
    respond_to do |format|
      format.html{ render :partial => 'new'} 
    end
  end
  def update_batch
    @batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render :partial=>'update_batch'

  end
end
