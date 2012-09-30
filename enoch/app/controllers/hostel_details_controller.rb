class HostelDetailsController < ApplicationController
  # GET /hostel_details
  # GET /hostel_details.json
  def index
    @new_hostel_record = HostelDeatil.new
    @hostel_details = HostelDetail.find(:all, :conditions => {:is_deleted => false})
    @inactive_hostel_details = HostelDetail.find(:all, :conditions => {:is_deleted => true})
    
    @record_count = HostelDetail.count(:all)
    
    response = { :hostel_details => @hostel_details, :inactive_hostel_details => @inactive_hostel_details, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout => false}
      format.json  { render :json => response }
    end 
  end

  # GET /hostel_details/1
  # GET /hostel_details/1.json
  def show
    @hostel_detail = HostelDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hostel_detail }
    end
  end

  # GET /hostel_details/new
  # GET /hostel_details/new.json
  def new
    @hostel_detail = HostelDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hostel_detail }
    end
  end

  # GET /hostel_details/1/edit
  def edit
    @hostel_detail = HostelDetail.find(params[:id])
  end

  # POST /hostel_details
  # POST /hostel_details.json
  def create
    @hostel_detail = HostelDetail.new(params[:hostel_detail])

    respond_to do |format|
      if @hostel_detail.save
        format.html { redirect_to @hostel_detail, notice: 'Hostel detail was successfully created.' }
        format.json { render json: @hostel_detail, status: :created, location: @hostel_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @hostel_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hostel_details/1
  # PUT /hostel_details/1.json
  def update
    @hostel_detail = HostelDetail.find(params[:id])

    respond_to do |format|
      if @hostel_detail.update_attributes(params[:hostel_detail])
        format.html { redirect_to @hostel_detail, notice: 'Hostel detail was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @hostel_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hostel_details/1
  # DELETE /hostel_details/1.json
  def destroy
    @hostel_detail = HostelDetail.find(params[:id])
    @hostel_detail.destroy

    respond_to do |format|
      format.html { redirect_to hostel_details_url }
      format.json { head :ok }
    end
  end
end
