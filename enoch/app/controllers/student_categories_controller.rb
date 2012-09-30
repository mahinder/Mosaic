class StudentCategoriesController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  def all_record 
    @student_category = StudentCategory.new
    @active_student_category = StudentCategory.find(:all,:order => "name asc",:conditions=>{:is_deleted => false})
    @inactive_student_category = StudentCategory.find(:all,:order => "name asc",:conditions=>{:is_deleted => true})
    @record_count = StudentCategory.count(:all)

    response = { :active_student_category => @active_student_category, :inactive_student_category => @inactive_student_category, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  # GET /student_categories
  # GET /student_categories.json
  def index
    @student_category = StudentCategory.all
    @active_student_category = StudentCategory.find(:all,:order => "name asc",:conditions=>{:is_deleted => false})
    @inactive_student_category = StudentCategory.find(:all,:order => "name asc",:conditions=>{:is_deleted => true})
    
    response = { :active_student_category => @active_student_category, :inactive_student_category => @inactive_student_category, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /student_categories/1
  # GET /student_categories/1.json
  def show
    @student_category = StudentCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_category }
    end
  end

  # GET /student_categories/new
  # GET /student_categories/new.json
  def new
    @student_category = StudentCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_category }
    end
  end

  # GET /student_categories/1/edit
  def edit
    @student_category = StudentCategory.find(params[:id])
  end

  # POST /student_categories
  # POST /student_categories.json
  def create
   @student_category = StudentCategory.new(params[:student_category])
    
    respond_to do |format|
      if @student_category.save
         @record_count = StudentCategory.count(:all)
         format.html { redirect_to @student_category, notice: 'Student Category is successfully created.' }
         format.json { render :json => {:valid => true, :student_category => @student_category, :notice => "Student Category is successfully created."}}
      else
        @str = @student_category.errors.to_json
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @student_category.errors}}
      end
    end    
  end

  # PUT /student_categories/1
  # PUT /student_categories/1.json
  def update
    @student_category = StudentCategory.find(params[:id])
    respond_to do |format|
      if @student_category.update_attributes(params[:student_category])
        format.html { redirect_to @student_category, notice: 'Student Category is successfully updated.' }
        format.json { render :json => {:valid => true, :student_category => @student_category, :notice => "Student Category is successfully updated."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :student_category.errors => @student_category  }}      #format.json { render json: @employee_grades.errors, status: :unprocessable_entity }
      end
    end    
  end

  # DELETE /student_categories/1
  # DELETE /student_categories/1.json
  def destroy
    @student_category = StudentCategory.find(params[:id])
    @students = Student.find(:all ,:conditions=>"student_category_id = #{params[:id]}")
     if @students.empty?
      StudentCategory.update(params[:id], :is_deleted=>true)
         respond_to do |format|
             format.html { redirect_to student_categories_url }
             format.json { render :json => {:valid => true,  :notice => "Student Category is deleted successfully." }}
         end
     else
         respond_to do |format|
         format.html { redirect_to student_categories_url }
         str = "Student Category can not be deleted"
         dependency_errors = {:dependency => [*str]}
         format.json { render :json => {:valid => false, :errors => dependency_errors}}
         end
     end
  end

end