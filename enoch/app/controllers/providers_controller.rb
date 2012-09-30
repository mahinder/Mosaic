class ProvidersController < ApplicationController
  
  before_filter :login_required
  # GET /providers
  # GET /providers.json
  def index
    @providers = Provider.all
    @active_providers = Provider.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_providers = Provider.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = Provider.count(:all)
    
    response = { :active_provider => @active_providers, :inactive_provider => @inactive_providers, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout=>false}
      format.json  { render :json => response }
    end 
  end

  # GET /providers/1
  # GET /providers/1.json
  def show
    @provider = Provider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @provider }
    end
  end

  # GET /providers/new
  # GET /providers/new.json
  def new
    @provider = Provider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @provider }
    end
  end

  # GET /providers/1/edit
  def edit
    @provider = Provider.find(params[:id])
  end

  # POST /providers
  # POST /providers.json
  def create
    @provider = Provider.new(params[:provider])

    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: 'Provider was successfully created.' }
         format.json { render :json => {:valid => true, :provider => @provider, :notice => "Provider was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @provider.errors}}
      end
    end
  end

  # PUT /providers/1
  # PUT /providers/1.json
  def update
    @provider = Provider.find(params[:id])

    respond_to do |format|
      if @provider.update_attributes(params[:provider])
        format.html { redirect_to @provider, notice: 'Provider was successfully updated.' }
        format.json { render :json => {:valid => true, :provider => @transport_board, :notice => "Provider was successfully updated."} }
      else
        format.html { render action: "edit" }
       format.json { render :json => {:valid => false, :provider.errors => @provider.errors}}
      end
    end
  end

  # DELETE /providers/1
  # DELETE /providers/1.json
  def destroy
    @provider = Provider.find(params[:id])
    @transport_vehicle=TransportVehicle.find_all_by_provider_id(params[:id])
    @transport_driver=TransportDriver.find_all_by_provider_id(params[:id])
     respond_to do |format|
       if @transport_vehicle.empty? && @transport_driver.empty?
       @provider.destroy
      format.html { redirect_to providers_url }
      format.json { render :json => {:valid => true,  :notice => "Provider was deleted successfully."}}
   else
     str = "Transport provider can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors =>dependency_errors}}
    end
    end
  end
  
  
  def all_record
     @provider = Provider.new
    @active_providers = Provider.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_providers = Provider.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = Provider.count(:all)
    
    response = { :active_provider => @active_providers, :inactive_provider => @inactive_providers, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
end
