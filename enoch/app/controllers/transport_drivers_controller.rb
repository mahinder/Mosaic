class TransportDriversController < ApplicationController
  
  
  before_filter :login_required
  # GET /transport_drivers
  # GET /transport_drivers.json
  def index
    @transport_drivers = TransportDriver.all
    @provider=Provider.find(:all,:conditions=>{:status=>true})
    @active_transport_drivers = TransportDriver.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_transport_drivers = TransportDriver.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = TransportDriver.count(:all)
    
    response = { :active_transport_driver => @active_transport_drivers, :inactive_transport_driver => @inactive_transport_drivers, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout=>false}
      format.json  { render :json => response }
    end
  end

  # GET /transport_drivers/1
  # GET /transport_drivers/1.json
  def show
    @transport_driver = TransportDriver.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_driver }
    end
  end

  # GET /transport_drivers/new
  # GET /transport_drivers/new.json
  def new
    @transport_driver = TransportDriver.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_driver }
    end
  end

  # GET /transport_drivers/1/edit
  def edit
    @transport_driver = TransportDriver.find(params[:id])
  end

  # POST /transport_drivers
  # POST /transport_drivers.json
  def create
    @transport_driver = TransportDriver.new(params[:transport_driver])

    respond_to do |format|
      if @transport_driver.save
        format.html { redirect_to @transport_driver, notice: 'Transport driver was successfully created.' }
        format.json { render :json => {:valid => true, :transport_driver => @transport_driver, :notice => "Transport driver was successfully created."}}
      else
        format.html { render action: "new" }
       format.json { render :json => {:valid => false, :errors => @transport_driver.errors}}
      end
    end
  end

  # PUT /transport_drivers/1
  # PUT /transport_drivers/1.json
  def update
    @transport_driver = TransportDriver.find(params[:id])

    respond_to do |format|
      if @transport_driver.update_attributes(params[:transport_driver])
        format.html { redirect_to @transport_driver, notice: 'Transport driver was successfully updated.' }
       format.json { render :json => {:valid => true,:transport_driver => @transport_driver,  :notice => "Transport driver was successfully updated."}}
      else
        format.html { render action: "edit" }
       format.json { render :json => {:valid => false, :transport_driver.errors => @transport_driver.errors}}
      end
    end
  end

  # DELETE /transport_drivers/1
  # DELETE /transport_drivers/1.json
  def destroy
    @transport_driver = TransportDriver.find(params[:id])
    @transport_detail=TransportDetail.find_all_by_transport_driver_id(params[:id])
   respond_to do |format|
   if @transport_detail.empty?
    @transport_driver.destroy
      format.html { redirect_to transport_drivers_url }
      format.json { render :json => {:valid => true,  :notice => "Transport Driver was deleted successfully."}}
    else
       str = "Transport driver can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors =>dependency_errors}}
    end
    end
  end
  
  def all_record
    @transport_driver = TransportDriver.new
     @provider=Provider.find(:all,:conditions=>{:status=>true})
    @active_transport_drivers = TransportDriver.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_transport_drivers = TransportDriver.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = TransportDriver.count(:all)
    
    response = { :active_transport_driver => @active_transport_drivers, :inactive_transport_driver => @inactive_transport_drivers, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
end
