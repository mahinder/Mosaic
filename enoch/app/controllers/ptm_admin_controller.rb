class PtmAdminController < ApplicationController
   filter_access_to :all
   before_filter :login_required
  def index
    @batches = []
  end

  def update
   @ptm = PtmMaster.find_by_id(params[:id])
   if @ptm.is_active == true
   @ptm.update_attribute("is_active",false) 
   else
   @ptm.update_attribute("is_active",true) 
   end
  end

  def show
   @course =Course.find(params[:id])
   @batches = @course.batches.active
   render :partial => 'ptm_batch'
  end
  
  def ptm
    @ptm = PtmMaster.find_all_by_batch_id(params[:id])
    render :partial => 'ptm'
  end

  def edit
    @ptm_master = PtmMaster.find_by_id(params[:id])
    render :layout => false
  end
end
