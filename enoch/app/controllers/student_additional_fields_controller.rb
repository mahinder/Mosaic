class StudentAdditionalFieldsController < ApplicationController

 before_filter :login_required
 filter_access_to :all
  def all_record 

    @student_additional_field = StudentAdditionalField.new
    @active_student_additional_field = StudentAdditionalField.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_student_additional_field = StudentAdditionalField.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = StudentAdditionalField.count(:all)

    response = { :active_student_additional_field => @active_student_additional_field, :inactive_student_additional_field => @inactive_student_additional_field, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  
  # GET /student_additional_fields
  # GET /student_additional_fields.json
  def index
    @student_additional_field = StudentAdditionalField.all
    @active_student_additional_field = StudentAdditionalField.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_student_additional_field = StudentAdditionalField.find(:all,:order => "name asc",:conditions=>{:status => false})
    
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @student_additional_field }
    end  
  end

  # GET /student_additional_fields/1
  # GET /student_additional_fields/1.json
  def show
    @student_additional_field = StudentAdditionalField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_additional_field }
    end
  end

  # GET /student_additional_fields/new
  # GET /student_additional_fields/new.json
  def new
    @student_additional_field = StudentAdditionalField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_additional_field }
    end
  end

  # GET /student_additional_fields/1/edit
  def edit
    @student_additional_field = StudentAdditionalField.find(params[:id])
  end

  # POST /student_additional_fields
  # POST /student_additional_fields.json
  def create
     @student_additional_field = StudentAdditionalField.new(params[:student_additional_field])
    
    respond_to do |format|
      if @student_additional_field.save
         @record_count = StudentAdditionalField.count(:all)
         format.html { redirect_to @student_additional_field, notice: 'Student Additional Field is successfully created.' }
         format.json { render :json => {:valid => true, :student_additional_field => @student_additional_field, :notice => "Student Additional Field was successfully created."}}
      else
        @str = @student_additional_field.errors.to_json
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @student_additional_field.errors}}
      end
    end    
  end

  # PUT /student_additional_fields/1
  # PUT /student_additional_fields/1.json
  def update
    @student_additional_field = StudentAdditionalField.find(params[:id])
    respond_to do |format|
      if @student_additional_field.update_attributes(params[:student_additional_field])
        format.html { redirect_to @student_additional_field, notice: 'Student additional field was successfully updated.' }
        format.json { render :json => {:valid => true, :student_additional_field => @student_additional_field, :notice => "Student additional field was successfully updated."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :student_additional_field.errors => @student_additional_field.errors}}
        #format.json { render json: @employee_grades.errors, status: :unprocessable_entity }
      end
    end    
  end

  # DELETE /student_additional_fields/1
  # DELETE /student_additional_fields/1.json
  def destroy
    @student_additional_field = StudentAdditionalField.find(params[:id])
    @students_additional_detail = StudentAdditionalDetails.find(:all ,:conditions=>"additional_field_id = #{params[:id]}")
     if @students_additional_detail.empty?
      @student_additional_field.destroy
      respond_to do |format|
      format.html { redirect_to student_additional_fields_url }
      format.json { render :json => {:valid => true,  :notice => "Additional Field deleted successfully." }}
       end
    else
     respond_to do |format|
      format.html { redirect_to student_additional_fields_url }
      str = "Additional Field can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors => dependency_errors}}
      end
    end
  end
  
end
