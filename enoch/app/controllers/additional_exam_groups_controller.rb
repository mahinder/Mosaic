class AdditionalExamGroupsController < ApplicationController
  before_filter :login_required
  before_filter :initial_queries, :except => :get_max_min_marks
  filter_access_to :all
  in_place_edit_for :additional_exam_group, :name

  in_place_edit_for :additional_exam, :maximum_marks
  in_place_edit_for :additional_exam, :minimum_marks
  in_place_edit_for :additional_exam, :weightage
  def edit
    @additional_exam_group = AdditionalExamGroup.find params[:id]
  end

  def index
    @additional_exam_groups = @batch.additional_exam_groups
  # render :layout => false
  end

  def additional_exam_group_index
    @batch = Batch.find params[:name][:id]
    @course = @batch.course unless @batch.nil?
    @additional_exam_groups = @batch.additional_exam_groups
    render 'index'
  end

  def create_index
    @additional_exam_groups = @batch.additional_exam_groups
    render 'index'
  end

  def new
    if @batch.is_active?
    @students = @batch.students
    else
      @students =    Student.find(:all,:joins =>'INNER JOIN `batch_students` ON `students`.id = `batch_students`.student_id AND batch_students.batch_id ='+ @batch.id.to_s )
    end

  end

  def show
    @additional_exam_group = AdditionalExamGroup.find(params[:id], :include => :additional_exams)

  end

  def create

    @students=@batch.students
    @additional_exam_group = AdditionalExamGroup.new(params[:additional_exam_group])
    @additional_exam_group.batch_id = @batch.id
    subject = subject_validations()
    if subject == 'right'
     if @additional_exam_group.save
        flash[:notice] = "Additional Exam Group successfuly saved."
        redirect_to :action =>'index',:batch_id => @batch.id
      else
         @errors = @additional_exam_group.errors.full_messages
             @err_count = @additional_exam_group.errors.count
        
        render 'new'
      end
      else
        flash[:warn_notice] = 'Sorry there is no subject assigned to this batch.'
        render 'new'
      end
   
  end

  def subject_validations
    if params[:additional_exam_group]['additional_exams_attributes']
     
         return 'right'
      else
        return 'wrong'
    end
end

  def update
    @additional_exam_group = AdditionalExamGroup.find params[:id]
    if @additional_exam_group.update_attributes(params[:additional_exam_group])
      flash[:notice] = 'Updated additional exam group successfully.'
      redirect_to [@batch, @additional_exam_group]
    else
      render 'edit'
    end
  end

  def delete_additional_exam_group
    @exam_group = AdditionalExamGroup.find(params[:id], :include => :additional_exams)
    @exam_group.destroy
    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => {:valid => true} }
    end
  end

  def get_max_min_marks
    group_id = params[:exam_group_id]
    maximum_marks =[]
    minimum_marks =[]
    exam_group =  Exam.find_all_by_exam_group_id(group_id)
    exam_group.each do |m_n|
      maximum_marks << m_n.maximum_marks
      minimum_marks << m_n.minimum_marks
    end
    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => {:maximum_marks => maximum_marks,:minimum_marks =>minimum_marks} }
    end
  end

  private

  def initial_queries
    @batch = Batch.find params[:batch_id], :include => :course unless params[:batch_id].nil?
    @course = @batch.course unless @batch.nil?
  end

end
