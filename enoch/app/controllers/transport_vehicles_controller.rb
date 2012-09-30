class TransportVehiclesController < ApplicationController
  
  before_filter :login_required
  # GET /transport_vehicles
  # GET /transport_vehicles.json
  def index
    @transport_vehicles = TransportVehicle.all
@transport_vehicle = TransportVehicle.new
     @provider=Provider.find(:all,:conditions=>{:status=>true})
    @active_transport_vehicles = TransportVehicle.find(:all,:order => "vehicle_type asc",:conditions=>{:status => true})
    @inactive_transport_vehicles = TransportVehicle.find(:all,:order => "vehicle_type asc",:conditions=>{:status => false})
    @record_count = TransportVehicle.count(:all)
    
    response = { :active_transport_vehicle => @active_transport_vehicles, :inactive_transport_vehicle => @inactive_transport_vehicles, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout=>false}
      format.json  { render :json => response }
    end 
  end

  # GET /transport_vehicles/1
  # GET /transport_vehicles/1.json
  def show
    @transport_vehicle = TransportVehicle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_vehicle }
    end
  end

  # GET /transport_vehicles/new
  # GET /transport_vehicles/new.json
  def new
    @transport_vehicle = TransportVehicle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_vehicle }
    end
  end

  # GET /transport_vehicles/1/edit
  def edit
    @transport_vehicle = TransportVehicle.find(params[:id])
  end

  # POST /transport_vehicles
  # POST /transport_vehicles.json
  def create
    @transport_vehicle = TransportVehicle.new(params[:transport_vehicle])

    respond_to do |format|
      if @transport_vehicle.save
        format.html { redirect_to @transport_vehicle, notice: 'Transport vehicle was successfully created.' }
        format.json { render :json => {:valid => true, :transport_route => @transport_vehicle, :notice => "Transport vehicle was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @transport_vehicle.errors}}
      end
    end
  end

  # PUT /transport_vehicles/1
  # PUT /transport_vehicles/1.json
  def update
    @transport_vehicle = TransportVehicle.find(params[:id])

    respond_to do |format|
      if @transport_vehicle.update_attributes(params[:transport_vehicle])
        format.html { redirect_to @transport_vehicle, notice: 'Transport vehicle was successfully updated.' }
         format.json { render :json => {:valid => true,:transport_vehicle => @transport_vehicle,  :notice => "Transport vehicle was successfully updated."}}
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :transport_vehicle.errors => @transport_vehicle.errors}}
      end
    end
  end

  # DELETE /transport_vehicles/1
  # DELETE /transport_vehicles/1.json
  def destroy
    @transport_vehicle = TransportVehicle.find(params[:id])
    @transport_detail=TransportDetail.find_all_by_transport_vehicle_id(params[:id])
   respond_to do |format|
    if @transport_detail.empty?
    @transport_vehicle.destroy
      format.html { redirect_to transport_vehicles_url }
      format.json { render :json => {:valid => true,  :notice => "Transport Vehicle was deleted successfully."}}
    else
       str = "Transport vehicle can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors =>dependency_errors}}
    end
  end
  end
   def all_record
     @transport_vehicle = TransportVehicle.new
     @provider=Provider.find(:all,:conditions=>{:status=>true})
    @active_transport_vehicles = TransportVehicle.find(:all,:order => "vehicle_type asc",:conditions=>{:status => true})
    @inactive_transport_vehicles = TransportVehicle.find(:all,:order => "vehicle_type asc",:conditions=>{:status => false})
    @record_count = TransportVehicle.count(:all)
    
    response = { :active_transport_vehicle => @active_transport_vehicles, :inactive_transport_vehicle => @inactive_transport_vehicles, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
end
