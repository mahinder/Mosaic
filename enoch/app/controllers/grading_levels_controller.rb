
class GradingLevelsController < ApplicationController
  # before_filter :login_required
  # filter_access_to :all
  def index
    if params[:batch_id] == ''
      @grading_levels = GradingLevel.default
    else
      @grading_levels = GradingLevel.for_batch(params[:batch_id])
      @batch = Batch.find params[:batch_id] unless params[:batch_id] == ''
    end
    render :layout => false
  end
  def create_grading_level
    @courses = Course.find(:all)
     @grading_levels = GradingLevel.default
    @batches = []
  end
 def grade_update_batch
   @batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render :partial=>'update_grade'
end
  def new
    @grading_level = GradingLevel.new
    @batch = Batch.find params[:id] if request.xhr? and params[:id]
    respond_to do |format|
      format.js { render :action => 'new' }
    end
  end

  def create_grade
  
    @grading_level = GradingLevel.new(params[:grading_level])
    @batch = Batch.find params[:grading_level][:batch_id] unless params[:grading_level][:batch_id].empty?
     if @grading_level.save
        @grading_level.batch.nil? ?
          @grading_levels = GradingLevel.default :
          @grading_levels = GradingLevel.for_batch(@grading_level.batch_id)
        flash[:notice] = 'Grading level was successfully created.'
        
         render :partial => 'grading_levels'
     
   
  else
    render :text => 'Grading Level Name is exist'
    end 
  end

  def edit
    @grading_level = GradingLevel.find params[:id]
    @batch = @grading_level.batch
     respond_to do |format|
      format.html { }
      format.js { render :action => 'edit' }
    end
  end

  def update_grade
  
    @grading_level = GradingLevel.find params[:id]
    
      if @grading_level.update_attributes(params[:grading_level])
        @grading_level.batch.nil? ? 
          @grading_levels = GradingLevel.default :
          @grading_levels = GradingLevel.for_batch(@grading_level.batch_id)
          render :partial => 'grading_levels'
    else
   
   flash[:warn_notice]= "Name has allready been taken"
     @grading_level.batch.nil? ? 
          @grading_levels = GradingLevel.default :
          @grading_levels = GradingLevel.for_batch(@grading_level.batch_id)
   render :partial => 'grading_levels' ,:layout => false
    end
  end

  def destroy
    @grading_level = GradingLevel.find params[:id]
    @grading_level.inactivate
    @grading_level.batch.nil? ? 
          @grading_levels = GradingLevel.default :
          @grading_levels = GradingLevel.for_batch(@grading_level.batch_id)
        #flash[:notice] = 'Grading level inactive successfully.'
         render :partial => 'grading_levels'
  end

  def show
    @batch = nil
    if params[:batch_id] == ''
      @grading_levels = GradingLevel.default
    else
      @grading_levels = GradingLevel.for_batch(params[:batch_id])
      @batch = Batch.find params[:batch_id] unless params[:batch_id] == ''
    end
    respond_to do |format|
      format.js { render :action => 'show' }
    end
  end
def ajaxmodal
  
end
  
end