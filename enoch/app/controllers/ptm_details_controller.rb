class PtmDetailsController < ApplicationController
  before_filter :login_required
  # GET /ptm_details
  # GET /ptm_details.json
   filter_access_to :all
  def index
    @ptm_details = PtmDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ptm_details }
    end
  end

  # GET /ptm_details/1
  # GET /ptm_details/1.json
  def show
    @ptm_detail = PtmDetail.find_all_by_ptm_master_id(params[:id])
    render :partial => 'show'
  end

  # GET /ptm_details/new
  # GET /ptm_details/new.json
  def new
    @ptm_detail = PtmDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ptm_detail }
    end
  end

  # GET /ptm_details/1/edit
  def edit
    @ptm_detail = PtmDetail.find(params[:id])
  end

  # POST /ptm_details
  # POST /ptm_details.json
  def create
    @user = current_user
    @ptm_master = PtmMaster.find(:last)
    params[:student_id].each do |st|
      @ptm_detail = PtmDetail.new(params[:ptm_detail])
      @ptm_detail.employee_id = Employee.find_by_employee_number(@user.username).id
      @ptm_detail.student_id = st
      @ptm_detail.ptm_master_id = @ptm_master.id
      @ptm_detail.save
    end
    respond_to do |format|
      if @ptm_detail.save
        format.json { render :json => {:valid => true, :notice => t(:ptm_detail_created)}}
      else
        format.json { render :json => {:valid => false, :errors => @ptm_detail.errors}}
      end
    end
  end

  # PUT /ptm_details/1
  # PUT /ptm_details/1.json
  def update
    @ptm = []
    PtmDetail.find_all_by_ptm_master_id(params[:id]).each do |fg|
      @ptm << fg.student_id.to_s
    end
    unless params[:ptm].nil?
      unless params[:ptm][:student_id].nil?
        params[:ptm][:student_id].each_with_index do |fed,i|
          @ptm_detail = PtmDetail.find_by_ptm_master_id_and_student_id(params[:id],fed)
          if @ptm.include?(fed)
            @ptm_detail.update_attribute("parent_feedback",params[:ptm][:parent_feedback][i])
          end
          @ptm_details = PtmDetail.where("student_id NOT IN (?)", params[:ptm][:student_id]).find(:all , :conditions => {:ptm_master_id => params[:id]})
          @ptm_details.each do |d|
            d.update_attribute("parent_feedback",nil)
          end
        end
      else
        @ptm_detail_parent = PtmDetail.find(:all , :conditions => {:ptm_master_id => params[:id]})
        @ptm_detail_parent.each do |d|
          d.update_attribute("parent_feedback",nil)
        end
      end
       unless  params[:ptm][:for_student_id].nil?
              params[:ptm][:for_student_id].each_with_index do |fd,j|
                @ptm_detail_note = PtmDetail.find_by_ptm_master_id_and_student_id(params[:id],fd)
                @ptm_detail_note.update_attribute("teacher_notes",params[:ptm][:teacher_notes][j])
              end
              @ptm_teacher_note = PtmDetail.where("student_id NOT IN (?)", params[:ptm][:for_student_id]).find(:all , :conditions => {:ptm_master_id => params[:id]})
              @ptm_teacher_note.each do |d|
                d.update_attribute("teacher_notes",nil)
              end
       else
              @empty_teacher_note =  PtmDetail.find_all_by_ptm_master_id(params[:id])
              @empty_teacher_note.each do |d|
                d.update_attribute("teacher_notes",nil)
              end
        end
    else
      @ptm_detail_nils = PtmDetail.find(:all , :conditions => {:ptm_master_id => params[:id]})
      @ptm_detail_nils.each do |d|
        d.update_attribute("parent_feedback",nil)
        d.update_attribute("teacher_notes",nil)
      end
    end
    respond_to do |format|
      format.json { render :json => {:valid => true, :notice => t(:feedback_submitted)}}
    end
  end

  # DELETE /ptm_details/1
  # DELETE /ptm_details/1.json
  def destroy
    @ptm_detail = PtmDetail.find(params[:id])
    @ptm_detail.destroy

    respond_to do |format|
      format.html { redirect_to ptm_details_url }
      format.json { head :ok }
    end
  end
  
  def update_parent_feedback
     @ptm_detail = PtmDetail.find(params[:id])
     respond_to do |format|
       if @ptm_detail.update_attribute("parent_feedback",params[:parent_feedback])
         format.json { render :json => {:valid => true, :notice => t(:feedback_submitted)}}
       else
         format.json { render :json => {:valid => false, :notice => t(:feedback_not_updated)}}
       end
     end
  end
end
