class AssignmentsController < ApplicationController
  before_filter :login_required
  # GET /assignments
  # GET /assignments.json
  filter_access_to :all
  def index
    @user = current_user
    @subject = []
    @assignments = Assignment.all
    if @user.employee == true
      @employee = @user.employee_record
      unless @employee.nil?
      @batches = employee_batches(@employee)
      else
      @batches = [] 
      end
    end
    if @user.admin?
      @batches = [] 
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @batches }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @assignment = Assignment.find_all_by_subject_id(params[:id],:conditions => ['student_id LIKE ?', "%#{@student.id}%"])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.json
  def new
    @subject = Subject.find_all_by_batch_id(params[:id])
    unless params.include?('view')
     render  :partial => 'new'
    else
     render :partial => 'view_subject' 
    end
  end

  # GET /assignments/1/edit
  def edit
    @user = current_user
    @assignment = Assignment.find(params[:id])
    render :partial => 'edit'
  end

  def show_batch
   @course =Course.find_by_id(params[:id])
       unless @course.nil?
          @batches = @course.batches.active 
       else
          @batches= []  
       end
       unless params[:viewAssignment] == "viewAssignment"
          render :partial => 'batch'
       else
          render :partial => 'admin_batch'  
       end
  end
  # POST /assignments
  # POST /assignments.json
  def create
      unless  params[:assignment][:student_id].empty?
      @student= ""
         params[:assignment][:student_id].each do |b|
           if @student == ""
             @student = @student + b
            else
              @student = @student+","+ b
            end
         end
      end  
    params[:assignment][:msg].each_with_index do |a,i|
        if(params[:assignment][:msg][i]!= "")
            @assignment = Assignment.new
            @assignment.batch_id = params[:assignment][:batch_id]
            @assignment.student_id = @student
            @assignment.subject_id = params[:assignment][:subject_id]
            @assignment.question = a
            @assignment.hint = params[:assignment][:hint_msg][i]  
            if params[:assignment][:date_msg][i] != ""
               @assignment.to_be_completed = params[:assignment][:date_msg][i]
            else
               @assignment.to_be_completed = Date.today
            end
            @assignment.save
        end
    end

    respond_to do |format|
      # if @assignment.save
       format.json { render :json => {:valid => true,:notice=> t(:assignment_created)}}
      # else
        # format.json { render :json => {:valid => false,:notice=> "Can not be created"}}
      # end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    @assignment = Assignment.find(params[:id])
    if params[:assignment].include?('student_id')
    params[:assignment][:student_id] = params[:assignment][:student_id].uniq if params[:assignment].include?('student_id')   
    unless params[:assignment][:student_id].nil?
      @student_id = ""
         params[:assignment][:student_id].each do |b|
           if @student_id == ""
             @student_id = @student_id + b
            else
              @student_id = @student_id+","+ b
            end
         end
      end  
    params[:assignment][:student_id] = @student_id
    end
    # params[:assignment][:to_be_completed] = Date.today
    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
       format.json { render :json => {:valid => true,:notice=> t(:assignment_updated)}}
      else
        format.json { render :json => {:valid => false,:errors=> t(:assignment_not_updated)}}
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment = Assignment.find(params[:id])
    FileUtils.rm_rf("#{Rails.root}/public/system/attachment/#{@assignment.id}")   
    @assignment.destroy
    respond_to do |format|
      # format.html { redirect_to assignments_url }
      format.json { render :json => {:valid => true,:notice=> t(:assignment_deleted)}}
      # format.json { head :ok }
    end
  end
  
   def student_assigned
    @student = Student.find_all_by_batch_id(params[:id])
    
    @batch = Batch.find_by_id(params[:id],:conditions => {:is_active => true})
    @subject = Subject.find_all_by_batch_id(@batch.id)
    unless params.include?('already_assigned')
    render :partial => 'form'
    else
    @assignment = Assignment.find_all_by_batch_id(@batch.id)
    render :partial => 'view_assigned_student' 
    end
  end
  
  def view
    @user = current_user
    @subject = []
    if @user.employee == true
      @employee = @user.employee_record
      @batches = employee_batches(@employee)
    end
    if @user.admin?
      @batches = []
    end
  end
  
  def view_student_assigned
    @batch = Batch.find_by_id(params[:id],:conditions => {:is_active => true})
    @assignment = Assignment.find_all_by_batch_id_and_subject_id(@batch.id,params[:subject_id])
    render :partial => 'view_assignment'
  end

    def uploadAssignment  
        return if params[:attachment].blank?
        @attachment = Assignment.new
        # @attachment.uploaded_file = params[:attachment]
        result = @attachment.uploaded_file(params)
        unless result
            flash[:notice] = t(:assignment_uploaded)
            redirect_to :action => "index"
        else
            flash[:error] = t(:assignment_not_uploaded)
            redirect_to :action => "index"
        end
    end
    
    def download_attachment
        @attachment = Assignment.find_by_id(params[:id])
        if File.exist?("#{Rails.root}/public/system/attachment/#{@attachment.id}/#{@attachment.attachment_filename}")  
          send_file  "#{Rails.root}/public/system/attachment/#{@attachment.id}/#{@attachment.attachment_filename}", :attachment_filename => @attachment.attachment_filename, :type => @attachment.attachment_content_type
        else
          flash[:notice] = t(:file_not_exist)
          redirect_to :controller => "sessions", :action => "dashboard"  
        end
    end
end
