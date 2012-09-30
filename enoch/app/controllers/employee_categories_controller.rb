class EmployeeCategoriesController < ApplicationController
 before_filter :login_required
 filter_access_to :all
  # GET /employee_categories/all
  # GET /employee_categories/all.json 
  def all_record 
    @employee_category = EmployeeCategory.new
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = EmployeeCategory.count(:all)

    response = { :categories => @categories, :inactive_categories => @inactive_categories, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  
  # GET /employee_categories
  # GET /employee_categories.json
  def index
    @employee_category = EmployeeCategory.all
    @categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_categories = EmployeeCategory.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = EmployeeCategory.count(:all)
    response = { :categories => @categories, @inactive_categories => @inactive_categories, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end


  # GET /employee_categories/1
  # GET /employee_categories/1.json
  def show
    @employee_category = EmployeeCategory.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee_category }
   end
  end

  # GET /employee_categories/new
  # GET /employee_categories/new.json
  def new
   @employee_category = EmployeeCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee_category }
    end
  end

  # GET /employee_categories/1/edit
  def edit
    @employee_category = EmployeeCategory.find(params[:id])
  end

  # POST /employee_categories
  # POST /employee_categories.json
  def create
    @employee_category = EmployeeCategory.new(params[:employee_category])
    
    respond_to do |format|
      if @employee_category.save
         @record_count = EmployeeCategory.count(:all)
         format.html { redirect_to @employee_category, notice: 'Category is successfully created.' }
         format.json { render :json => {:valid => true, :employee_category => @employee_category, :notice => "Employee Category was successfully created."}}
      else
        @str = @employee_category.errors.to_json
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @employee_category.errors}}
      end
    end
  end

  # PUT /employee_categories/1
  # PUT /employee_categories/1.json
  def update
    @employee_category = EmployeeCategory.find(params[:id])
    respond_to do |format|
      if @employee_category.update_attributes(params[:employee_category])
        format.html { redirect_to @employee_category, notice: 'Employee Category is successfully updated.' }
        format.json { render :json => {:valid => true, :employee_category => @employee_category, :notice => "Employee Category is updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :employee_category.errors => @employee_category.errors}}
        #format.json { render json: @employee_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_categories/1
  # DELETE /employee_categories/1.json
  def destroy
    @employee_category = EmployeeCategory.find(params[:id])
    @category_position = EmployeePosition.find(:all, :conditions=>"employee_category_id = #{params[:id]}")
    @employee_with_category = Employee.find(:all,:conditions => "employee_category_id = #{params[:id]}")
    if @category_position.empty? && @employee_with_category.empty?
      @employee_category.delete
      respond_to do |format|
      format.html { redirect_to employee_categories_url }
      format.json { render :json => {:valid => true,  :notice => "Employee category deleted successfully." }}
    end
    else
      respond_to do |format|
      format.html { redirect_to employee_categories_url }
      str = "Employee Category can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors => dependency_errors}}
      end
    end
  end
  
end
