class EmployeePositionsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  
  def all_record
    @employee_position = EmployeePosition.new
    @positions = EmployeePosition.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_positions = EmployeePosition.find(:all,:order => "name asc",:conditions=>{:status => false})
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=> {:status => true})
    @record_count = EmployeePosition.count(:all)
    
    response = { :positions => @positions, :inactive_positions => @inactive_positions, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  # GET /employee_positions
  # GET /employee_positions.json
  def index
    @employee_position = EmployeePosition.all
    @positions = EmployeePosition.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_positions = EmployeePosition.find(:all,:order => "name asc",:conditions=>{:status => false})
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=> {:status => true})
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @employee_position }
    end
  end

  # GET /employee_positions/1
  # GET /employee_positions/1.json
  def show
    @employee_position = EmployeePosition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee_position }
    end
  end

  # GET /employee_positions/new
  # GET /employee_positions/new.json
  def new
    @employee_position = EmployeePosition.new
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=> {:status => true})

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee_position }
    end
  end

  # GET /employee_positions/1/edit
  def edit
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=> {:status => true})
    @employee_position = EmployeePosition.find(params[:id])
  end

  # POST /employee_positions
  # POST /employee_positions.json
  def create
    @employee_position = EmployeePosition.new(params[:employee_position])
    respond_to do |format|
      if @employee_position.save
         @record_count = EmployeePosition.count(:all)
         format.html { redirect_to @employee_position, notice: 'Position was successfully created.' }
         format.json { render :json => {:valid => true, :employee_position => @employee_position, :notice => "Employee Position was successfully created."}}
      else
        @str = @employee_position.errors.to_json
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @employee_position.errors}}
      end
    end
  end

  # PUT /employee_positions/1
  # PUT /employee_positions/1.json
  def update
    @employee_position = EmployeePosition.find(params[:id])
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=> {:status => true})
    respond_to do |format|
      if @employee_position.update_attributes(params[:employee_position])
        format.html { redirect_to @employee_position, notice: 'Employee Position was successfully updated.' }
        format.json { render :json => {:valid => true, :employee_position => @employee_position, :notice => "Employee Position was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :employee_position.errors => @employee_position.errors}}
      end
    end 
  end

  # DELETE /employee_positions/1
  # DELETE /employee_positions/1.json
  def destroy
   
    @employee_position = EmployeePosition.find(params[:id])
    @employees = Employee.find(:all ,:conditions=>"employee_position_id = #{params[:id]}")
    if @employees.empty?
      @employee_position.destroy
       respond_to do |format|
      format.html { redirect_to employee_positions_url }
      format.json { render :json => {:valid => true,  :notice => "Employee Position deleted successfully." }}
      end
    else
      respond_to do |format|
      format.html { redirect_to employee_positions_url }
      str = "Employee Position can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors => dependency_errors}}
      end
    end
  end
    
end
