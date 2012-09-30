class StudentTermRemarksController < ApplicationController
  before_filter :login_required
  # GET /student_term_remarks
  # GET /student_term_remarks.json
  def index
    @student_term_remarks = StudentTermRemark.all
    @batches = []
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_term_remarks }
    end
  end

  # GET /student_term_remarks/1
  # GET /student_term_remarks/1.json
  def show
    @student_term_remark = StudentTermRemark.new
    @current_session = current_session
    @batch = Batch.find_by_id(params[:id])
    unless @batch.nil?
    @students = Student.find_all_by_batch_id(@batch.id)
    else
    @students =[]  
    end
    render :layout => false
  end

  def change_student_term_batch
   @course =Course.find_by_id(params[:id])
   unless @course.nil?
    @batches = @course.batches.active
   else
     @batches =[]
   end
   render :partial => 'student_term_batch'
  end

  # GET /student_term_remarks/new
  # GET /student_term_remarks/new.json
  def new
    @student_term_remark = StudentTermRemark.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_term_remark }
    end
  end

  # GET /student_term_remarks/1/edit
  def edit
    @student_term_remark = StudentTermRemark.find(params[:id])
  end

  # POST /student_term_remarks
  # POST /student_term_remarks.json
  def create
    unless params[:students].nil?
    params[:students].each_with_index do |student , i|
      @student_term_remark = StudentTermRemark.new(params[:student_term_remark])
      @student_term_remark.student_id = student
      @student_term_remark.remarks = params[:remarks][i]
      @student_term_remark.school_session_id = current_session.id
      @createdTermRemarks = StudentTermRemark.find_by_school_session_id_and_batch_id_and_term_master_id_and_student_id_and_remarks_type(current_session.id,  params[:student_term_remark][:batch_id], params[:student_term_remark][:term_master_id],student,params[:student_term_remark][:remarks_type])
      if @createdTermRemarks.nil?
        unless @student_term_remark.save
          @error = true
        end
      else
        @createdTermRemarks.update_attributes(:remarks => params[:remarks][i])
      end
    end
    end
     respond_to do |format|
        if @error.nil?
          format.html { redirect_to @student_term_remark, notice: 'Student term remark was successfully updated.' }
          format.json { render :json => {:valid => true, :student_term_remark => @student_term_remark, :notice => "Student term remark was successfully updated.'"}}
        else
          format.html { render action: "new" }
          format.json { render :json => {:valid => false, :errors => @student_term_remark.errors}}
        end
      end
  end

  # PUT /student_term_remarks/1
  # PUT /student_term_remarks/1.json
  def update
    @student_term_remark = StudentTermRemark.find(params[:id])

    respond_to do |format|
      if @student_term_remark.update_attributes(params[:student_term_remark])
        format.html { redirect_to @student_term_remark, notice: 'Student term remark was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_term_remark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_term_remarks/1
  # DELETE /student_term_remarks/1.json
  def destroy
    @student_term_remark = StudentTermRemark.find(params[:id])
    @student_term_remark.destroy

    respond_to do |format|
      format.html { redirect_to student_term_remarks_url }
      format.json { head :ok }
    end
  end
end
