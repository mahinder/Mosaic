

class ExamGroupsController < ApplicationController
  before_filter :login_required
  before_filter :initial_queries
  before_filter :protect_other_student_data
  before_filter :restrict_employees_from_exam
  
  in_place_edit_for :exam_group, :name
  filter_access_to :all
  in_place_edit_for :exam, :maximum_marks
  in_place_edit_for :exam, :minimum_marks
  in_place_edit_for :exam, :weightage
  
  def index
    # @batch = Batch.find(params[:batch])
    @course = @batch.course
    @exam_groups = @batch.exam_groups
    @errors = params[:errors]
    @err_count = params[:error_count]
    # if @current_user.employee?
      # @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id}
      # if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.id}.include?(1) and !@current_user.privileges.map{|p| p.id}.include?(2)
        # flash[:notice] = "Sorry, you are not allowed to access that page."
        # redirect_to :controller => 'user', :action => 'dashboard'
      # end
    # end
  end
   def exam_group_index
    @batch = Batch.find(params[:exams][:batch_id])
    @course = @batch.course
    @exam_groups = @batch.exam_groups
    render 'index'
  end

  def changeExam
    @batch = Batch.find(params[:batch])

    @course = @batch.course
    @exam_groups = @batch.exam_groups

    render :partial => 'examgroup_index'
  end

  def new
    @batch = Batch.find(params[:id])
    @course = @batch.course
    @normal_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=> {:no_exams=> false,:elective_group_id => nil, :is_deleted => false} )
      @elective_subjects = []
      elective_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=> {:no_exams=> false,:elective_group_id => !nil, :is_deleted => false} )
      elective_subjects.each do |e|
        is_assigned = StudentsSubject.find_all_by_subject_id(e.id)
        unless is_assigned.empty?
        @elective_subjects.push e
        end
      end
      @all_subjects = @normal_subjects+@elective_subjects
    
  end

  def create
   
    @exam_group = ExamGroup.new(params[:exam_group])
    @exam_group.batch_id = @batch.id
    @type = @exam_group.exam_type
    subject = subject_validations()
    if subject == 'right'
     if @exam_group.save
            flash[:notice] = 'Exam group created successfully.'
            redirect_to :action => 'index',:batch_id => @batch
          else
            @errors = @exam_group.errors.full_messages
             @err_count = @exam_group.errors.count
             redirect_to :action => 'index',:batch_id => @batch,:errors=>@errors,:error_count=>@err_count
          end
        else
       flash[:warn_notice] = 'Sorry there is no subject assigned to this batch.'
       redirect_to :action => 'index',:batch_id => @batch
        end
  end

  def subject_validations
    if params[:exam_group]['exams_attributes']
     
         return 'right'
      else
        return 'wrong'
    end
end
  def edit
    @exam_group = ExamGroup.find params[:id]
  end

  def update
    @exam_group = ExamGroup.find params[:id]
    if @exam_group.update_attributes(params[:exam_group])
      flash[:notice] = 'Updated exam group successfully.'
      redirect_to [@batch, @exam_group]
    else
      render 'edit'
    end
  end

  def delete_exam_group
    @exam_group = ExamGroup.find(params[:id], :include => :exams)
    @batch = @exam_group.batch_id

    if @current_user.employee?
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id}
      if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.id}.include?(1) and !@current_user.privileges.map{|p| p.id}.include?(2)
        flash[:notice] = "Sorry, you are not allowed to access that page."
        redirect_to :controller => 'session', :action => 'dashboard'
      end
    end
    @exam_group.destroy
    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => {:key => @batch,:valid => true} }
    end

  end

  def show
   
    @exam_group = ExamGroup.find(params[:id], :include => :exams)
    if @current_user.employee?
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id}
      if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.id}.include?(1) and !@current_user.privileges.map{|p| p.id}.include?(2)
        flash[:notice] = "Sorry, you are not allowed to access that page."
        redirect_to :controller => 'session', :action => 'dashboard'
      end
    end
  end
  

  private

  def initial_queries
    puts "i am in initial queries with params#{params[:batch_id]}"

    @batch = Batch.find params[:batch_id], :include => :course unless params[:batch_id].nil?
    @course = @batch.course unless @batch.nil?
  end

end