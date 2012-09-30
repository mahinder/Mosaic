class EmployeeDepartmentsController < ApplicationController
 before_filter :login_required
 filter_access_to :all  
  
  def all_record
    @employee_department = EmployeeDepartment.new
    @active_departments = EmployeeDepartment.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_departments = EmployeeDepartment.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = EmployeeDepartment.count(:all)
    
    response = { :departments => @active_departments, :inactive_departments => @inactive_departments, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  # GET /employee_departments
  # GET /employee_departments.json
  def index
    @employee_department = EmployeeDepartment.new
    @active_departments = EmployeeDepartment.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_departments = EmployeeDepartment.find(:all,:order => "name asc",:conditions=>{:status => false})
    
    
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @employee_departments }
      
    end
  end

  # GET /employee_departments/1
  # GET /employee_departments/1.json
  def show
    @employee_department = EmployeeDepartment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee_department }
    end
  end

  # GET /employee_departments/new
  # GET /employee_departments/new.json
  def new
    @departments = EmployeeDepartment.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_departments = EmployeeDepartment.find(:all,:order => "name asc",:conditions=>{:status => false})
    @employee_department = EmployeeDepartment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee_department }
    end
  end

  # GET /employee_departments/1/edit
  def edit
    
    @employee_department = EmployeeDepartment.find(params[:id])
  end

  # POST /employee_departments
  # POST /employee_departments.json
  def create
    
    @employee_department = EmployeeDepartment.new(params[:employee_department])
    respond_to do |format|
      if @employee_department.save
        @record_count = EmployeeDepartment.count(:all)
        format.html { redirect_to @employee_department, notice: 'Employee Department was successfully created.'}
        format.json { render :json => {:valid => true, :employee_department => @employee_department, :notice => "Employee Department was successfully created."}}
       else
         @str = @employee_department.errors.to_json
        format.html { render action: "new" }
         format.json { render :json => {:valid => false, :errors => @employee_department.errors}}
      end
    end
  end

  # PUT /employee_departments/1
  # PUT /employee_departments/1.json
  def update
     @employee_department = EmployeeDepartment.find(params[:id])
    
    respond_to do |format|
      if @employee_department.update_attributes(params[:employee_department])
        format.html { redirect_to @employee_department, notice: 'EmployeeDepartment was successfully updated.' }
        format.json { render :json => {:valid => true, :employee_department => @employee_department, :notice => "Department was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :employee_departments.errors => @employee_department.errors}}
        #format.json { render json: @employee_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_departments/1
  # DELETE /employee_departments/1.json
  def destroy
    @employee_department = EmployeeDepartment.find(params[:id])
    @employee = Employee.find(:all, :conditions => "employee_department_id = #{params[:id]}")
   if @employee.empty?
    @employee_department.destroy
    respond_to do |format|
      format.html { redirect_to employee_departments_url }
      format.json { render :json => {:valid => true,  :notice => "department was deleted successfully."}}
    end
    else
      respond_to do |format|
        format.html { redirect_to employee_departments_url }
        str = "Employee Department cannot be deleted"
        dependencyerrors = { :dependecies => [*str]}
        format.json { render :json => {:valid => false,  :errors => dependencyerrors}} 
    end
    end
  end
end
