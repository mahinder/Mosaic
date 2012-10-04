class GradingLevelDetailsController < ApplicationController
  
  
  in_place_edit_for :grading_level_detail, :grading_level_detail_name
  
  # GET /grading_level_details
  # GET /grading_level_details.json
  def index
    @grading_level_details = GradingLevelDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grading_level_details }
    end
  end

  # GET /grading_level_details/1
  # GET /grading_level_details/1.json
  def show
    @grading_level_detail = GradingLevelDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grading_level_detail }
    end
  end

  # GET /grading_level_details/new
  # GET /grading_level_details/new.json
  def new
    @grading_level_detail = GradingLevelDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grading_level_detail }
    end
  end

  # GET /grading_level_details/1/edit
  def edit
    
    @grading_level_detail = GradingLevelDetail.find(params[:id])
    render :partial=>'edit_grading_level'
  end
  def edit_grading_detail
    # log.info "the params are #{params}"
  end

  # POST /grading_level_details
  # POST /grading_level_details.json
  def create
      @grading_level_detail = GradingLevelDetail.new(params[:grading_level_detail])

    respond_to do |format|
      if @grading_level_detail.save
        format.html { redirect_to @grading_level_detail, notice: 'Grading level detail was successfully created.' }
        format.json { render json: @grading_level_detail, status: :created, location: @grading_level_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @grading_level_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grading_level_details/1
  # PUT /grading_level_details/1.json
 def update
      @grading_level_detail = GradingLevelDetail.find(params[:id])

      # respond_to do |format|
      if @grading_level_detail.update_attributes(params[:grading_level_detail])
        @grading_group =   @grading_level_detail.grading_level_group
        @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)
         @html = render_to_string( :partial => 'view_grade' )
         render :json => { :valid => true, :html => @html }
      else
        @grading_group =   @grading_level_detail.grading_level_group
        @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)
        
         @html = render_to_string( :partial => 'view_grade' )
        render :json => { :valid => false, :html => @html,:errors => @grading_level_detail.errors }
      end
    # end
    end

  # DELETE /grading_level_details/1
  # DELETE /grading_level_details/1.json
  def destroy
   
    @grading_level_detail = GradingLevelDetail.find(params[:id])
    # respond_to do |format|
      if  @grading_level_detail.destroy
         @grading_group =   @grading_level_detail.grading_level_group
   @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)

      render :partial => 'view_grade'
      # else
         # response = { :status =>'created',:errors=>@grading_level_detail.errors.full_messages}
      # format.json { render :json => response }
    # end
    end
  end
  def add_grading_detail
    @grading_group = GradingLevelGroup.find params[:grading_level_group]
     @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)
    render :partial => 'add_grade'
  end
   def create_grade
     min_score=params[:grading_level][:min_score]
    @grading_level_detail = GradingLevelDetail.new(:grading_level_group_id=>params[:grading_level][:grading_level_group_id],:grading_level_detail_name=>params[:grading_level][:grading_level_detail_name],:min_score=> min_score.to_f)
        if @grading_level_detail.save
       @grading_group =   GradingLevelGroup.find params[:grading_level][:grading_level_group_id]
       @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)
        @html = render_to_string( :partial => 'view_grade' )
         render :json => { :valid => true, :html => @html }
       else
         @grading_group =   GradingLevelGroup.find params[:grading_level][:grading_level_group_id]
       @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)
       @html = render_to_string( :partial => 'view_grade' )
        render :json => { :valid => false, :html => @html,:errors => @grading_level_detail.errors }
      end
    end
def view_grading_detail
  @grading_group =   GradingLevelGroup.find params[:grading_level_group]
   @grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(@grading_group.id)
 render :partial => 'view_grade'

end
end
