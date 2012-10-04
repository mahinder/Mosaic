class EmployeeGradesController < ApplicationController
  before_filter :login_required
 filter_access_to :all
  # GET /employee_grades/all
  # GET /employee_grades/all.json
  def all_record
    @employee_grade = EmployeeGrade.new
    @grades = EmployeeGrade.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_grades = EmployeeGrade.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = EmployeeGrade.count(:all)
    response = { :grades => @grades, :inactive_grades => @inactive_grades, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  # GET /employee_grades
  # GET /employee_grades.json
  def index
    @employee_grades = EmployeeGrade.all
    @grades = EmployeeGrade.find(:all,:order => "name asc",:conditions=>{:status => true})
  @inactive_grades = EmployeeGrade.find(:all,:order => "name asc",:conditions=>{:status => false})   
  response = { :grades => @grades, :inactive_grades => @inactive_grades, :record_count => @record_count}
  respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /employee_grades/1
  # GET /employee_grades/1.json
  def show
    @employee_grades = EmployeeGrade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee_grades }
    end
  end

  # GET /employee_grades/new
  # GET /employee_grades/new.json
  def new
    @employee_grade = EmployeeGrade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee_grade }
    end
  end

  # GET /employee_grades/1/edit
  def edit
    @employee_grades = EmployeeGrade.find(params[:id])
  end

  # POST /employee_grades
  # POST /employee_grades.json
  def create
    @employee_grade = EmployeeGrade.new(params[:employee_grade])
    respond_to do |format|
      if @employee_grade.save
        @record_count = EmployeeGrade.count(:all)
        format.html { redirect_to @employee_grade, notice: 'Grade was successfully created.' }
        format.json { render :json => {:valid => true, :employee_grade => @employee_grade, :notice => "Grade was successfully created."}}
      else
        @str = @employee_grade.errors.to_json
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @employee_grade.errors}}
      end
    end
  end

  # PUT /employee_grades/1
  # PUT /employee_grades/1.json
  def update
    @employee_grade = EmployeeGrade.find(params[:id])
    respond_to do |format|
      if @employee_grade.update_attributes(params[:employee_grade])
        format.html { redirect_to @employee_grade, notice: 'EmployeeGrade was successfully updated.' }
        format.json { render :json => {:valid => true, :employee_grade => @employee_grade, :notice => "Grade was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :employee_grades.errors => @employee_grades.errors}}
        #format.json { render json: @employee_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_grades/1
  # DELETE /employee_grades/1.json
  def destroy
    @employee_grade = EmployeeGrade.find(params[:id])
    @employee_with_grade = Employee.find(:all,:conditions => "employee_category_id = #{params[:id]}")
    if @employee_with_grade.empty?
      @employee_grade.destroy
      respond_to do |format|
      format.html { redirect_to employee_grades_url }
      format.json { render :json => {:valid => true,  :notice => "Grade was deleted successfully."}}
    end
    else
      respond_to do |format|
      format.html { redirect_to employee_grades_url }
      str = "Employee Grade can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors => dependency_errors}}
      end
    end
   
  end
  
end