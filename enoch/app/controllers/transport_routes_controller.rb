class TransportRoutesController < ApplicationController
  
  before_filter :login_required
  
  
  # GET /transport_routes
  # GET /transport_routes.json
  def index
   @transport_route = TransportRoute.new
    @active_transport_routes = TransportRoute.find(:all,:order => "start_place asc",:conditions=>{:status => true})
    @inactive_transport_routes = TransportRoute.find(:all,:order => "start_place asc",:conditions=>{:status => false})
    @record_count = TransportRoute.count(:all)
    
    response = { :active_transport_route => @active_transport_routes, :inactive_transport_route => @inactive_transport_routes, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false }
      format.json  { render :json => response }
    end 
  end

  # GET /transport_routes/1
  # GET /transport_routes/1.json
  def show
    @transport_route = TransportRoute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_route }
    end
  end

  # GET /transport_routes/new
  # GET /transport_routes/new.json
  def new
    @transport_route = TransportRoute.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_route }
    end
  end

  # GET /transport_routes/1/edit
  def edit
    @transport_route = TransportRoute.find(params[:id])
  end

  # POST /transport_routes
  # POST /transport_routes.json
  def create
    
    @transport_route = TransportRoute.new(params[:transport_route])

    respond_to do |format|
      if @transport_route.save
         @record_count = TransportRoute.count(:all)
        format.html { redirect_to @transport_route, notice: 'Transport route was successfully created.' }
       format.json { render :json => {:valid => true, :transport_route => @transport_route, :notice => "Transport route was successfully created."}}
      else
        format.html { render action: "new" }
         format.json { render :json => {:valid => false, :errors => @transport_route.errors}}
      end
    end
  end

  # PUT /transport_routes/1
  # PUT /transport_routes/1.json
  def update
    @transport_route = TransportRoute.find(params[:id])

    respond_to do |format|
      if @transport_route.update_attributes(params[:transport_route])
        format.html { redirect_to @transport_route, notice: 'Transport route was successfully updated.' }
        format.json { render :json => {:valid => true, :transport_route => @transport_route, :notice => "Transport route was successfully updated."} }
      else
        format.html { render action: "edit" }
         format.json { render :json => {:valid => false, :transport_route.errors => @transport_route.errors}}
       end
    end
  end

  # DELETE /transport_routes/1
  # DELETE /transport_routes/1.json
  def destroy
    @transport_route = TransportRoute.find(params[:id])
    @transport_board=TransportBoard.find_all_by_transport_route_id(params[:id])
     @transport_detail=TransportDetail.find_all_by_transport_route_id(params[:id])
     respond_to do |format|
    if @transport_board.empty? && @transport_detail.empty?
    @transport_route.destroy
      format.html { redirect_to transport_routes_url }
      format.json { render :json => {:valid => true,  :notice => "Transport route was deleted successfully."}}
    else
      str = "Transport route can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors =>dependency_errors}}
    end
    end
  end
  
 def all_record
     @transport_route = TransportRoute.new
    @active_transport_routes = TransportRoute.find(:all,:order => "start_place asc",:conditions=>{:status => true})
    @inactive_transport_routes = TransportRoute.find(:all,:order => "start_place asc",:conditions=>{:status => false})
    @record_count = TransportRoute.count(:all)
    
    response = { :active_transport_route => @active_transport_routes, :inactive_transport_route => @inactive_transport_routes, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  def transport_dashboard
    
  end
end
