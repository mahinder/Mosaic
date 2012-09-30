class TransportDetailsController < ApplicationController
  before_filter :login_required
  
  # GET /transport_details
  # GET /transport_details.json
  def index
    @transport_details = TransportDetail.all

  @transport_route= TransportRoute.find(:all,:order => "name asc",:conditions=>{:status => true})
      @transport_vehicle= TransportVehicle.find(:all,:order => "vehicle_type asc",:conditions=>{:status => true})
       @transport_driver= TransportDriver.find(:all,:order => "name asc",:conditions=>{:status => true})
    @active_transport_details = TransportDetail.find(:all,:conditions=>{:status => true})
    @inactive_transport_details = TransportDetail.find(:all,:conditions=>{:status => false})
    @record_count = TransportDetail.count(:all)
    
    response = { :active_transport_detail=> @active_transport_details, :inactive_transport_detail => @inactive_transport_details, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout => false} 
      format.json  { render :json => response }
    end 
  end

  # GET /transport_details/1
  # GET /transport_details/1.json
  def show
    @transport_detail = TransportDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_detail }
    end
  end

  # GET /transport_details/new
  # GET /transport_details/new.json
  def new
    @transport_detail = TransportDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_detail }
    end
  end

  # GET /transport_details/1/edit
  def edit
    @transport_detail = TransportDetail.find(params[:id])
  end

  # POST /transport_details
  # POST /transport_details.json
  def create
    @transport_detail = TransportDetail.new(params[:transport_detail])

    respond_to do |format|
      if @transport_detail.save
        format.html { redirect_to @transport_detail, notice: 'Transport detail was successfully created.' }
       format.json { render :json => {:valid => true, :transport_detail => @transport_detail, :notice => "Transport detail was successfully created."}}
      else
        format.html { render action: "new" }
      format.json { render :json => {:valid => false, :errors => @transport_detail.errors}}
      end
    end
  end

  # PUT /transport_details/1
  # PUT /transport_details/1.json
  def update
    @transport_detail = TransportDetail.find(params[:id])

    respond_to do |format|
      if @transport_detail.update_attributes(params[:transport_detail])
        format.html { redirect_to @transport_detail, notice: 'Transport detail was successfully updated.' }
        format.json { render :json => {:valid => true, :transport_detail => @transport_detail, :notice => "Transport detail was successfully updated."} }
      else
        format.html { render action: "edit" }
      format.json { render :json => {:valid => false, :transport_detail.errors => @transport_detail.errors}}
      end
    end
  end

  # DELETE /transport_details/1
  # DELETE /transport_details/1.json
  def destroy
    @transport_detail = TransportDetail.find(params[:id])
    @transport_detail.destroy

    respond_to do |format|
      format.html { redirect_to transport_details_url }
    format.json { render :json => {:valid => true,  :notice => "Transport detail was deleted successfully."}}
    end
  end
  
    def all_record
     @transport_detail = TransportDetail.new
     @transport_route= TransportRoute.find(:all,:order => "name asc",:conditions=>{:status => true})
      @transport_vehicle= TransportVehicle.find(:all,:order => "vehicle_type asc",:conditions=>{:status => true})
       @transport_driver= TransportDriver.find(:all,:order => "name asc",:conditions=>{:status => true})
    @active_transport_details = TransportDetail.find(:all,:conditions=>{:status => true})
    @inactive_transport_details = TransportDetail.find(:all,:conditions=>{:status => false})
    @record_count = TransportDetail.count(:all)
    
    response = { :active_transport_detail=> @active_transport_details, :inactive_transport_detail => @inactive_transport_details, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  
  def add_passenger
    @type=params[:type]
    @batches =[]
    @transport_detail_id=params[:transport_detail]
    render :partial => 'add_passenger'
  end
  
  def add_passenger_index
    puts "i am in add passnger inde#{params[:transport_detail]}"
    @type=params[:type]
     @batches =[]
    @transport_detail_id=params[:transport_detail]
    transport_detail=TransportDetail.find_by_id(@transport_detail_id)
    route=transport_detail.transport_route.name
    vehicle=transport_detail.transport_vehicle.vehicle_type
    @title="#{route}/#{vehicle}"
    render :partial => 'passenger'
  end
  
  def change_batch 
   logger.info "In student controller & action change_batch ,the params are #{params}" 
   unless params[:id].empty?
   @course =Course.find(params[:id]) 
   @batches = Batch.find_all_by_course_id(@course.id)
   else
      @batches =[]
     end 
   render :partial => 'batch'
  end
  
  def get_student
    @students=Student.find_all_by_batch_id(params[:batch_id],:conditions=>{:is_transport_enabled=>true})
    transport_detail=TransportDetail.find_by_id(params[:id])
    route = transport_detail.transport_route
    puts "the route id is#{route.id}"
    @boards = route.transport_boards
    render :partial=>'get_student'
  end
  
  
  def save_passanger_detail
  
    @passenger_detail=PassengerBoardTransportDetail.new
    @passenger_detail.passenger_id=params[:passanger]
    @passenger_detail.transport_board_id=params[:board]
    @passenger_detail.transport_detail_id=params[:transport_detail]
    @passenger_detail.passenger_type=params[:type]
    respond_to do |format|
   if @passenger_detail.save
   format.json { render :json => {:valid => true, :student => @passenger_detail, :notice => "passenger was successfully Saved"}}
    else
   format.json { render :json => {:valid => false, :errors => @passenger_detail.errors , :notice => "student was successfully founded."}}
    end
  end
  end
  
  def view_passanger
    @transport_detail = params[:transport_detail]
    @passengers = PassengerBoardTransportDetail.find_all_by_transport_detail_id(@transport_detail)
    transport_detail=TransportDetail.find_by_id(@transport_detail)
    route=transport_detail.transport_route.name
    vehicle=transport_detail.transport_vehicle.vehicle_type
    @title="#{route}/#{vehicle}"
  render :partial=>'view_passenger'
  end
  
  
  def delete_passenger
    
   @passenger = PassengerBoardTransportDetail.find(params[:id])
   @transport_detail = @passenger.transport_detail.id
  
   if @passenger.destroy
      @passengers =PassengerBoardTransportDetail.find_all_by_transport_detail_id(@transport_detail)
    render :partial=>'view_passenger'
   end
  end  
  def passanger_department
    @employees = Employee.find_all_by_employee_department_id(params[:department],:conditions=>{:is_transport_enabled=>true})
    transport_detail=TransportDetail.find_by_id(params[:id])
    route = transport_detail.transport_route
    @boards = TransportBoard.find_all_by_transport_route_id(route.id)
    render :partial=>'department'
  end
  
   def edit_passenger
     puts "i am in edit passenger with params#{params}"
     transport_route=TransportDetail.find_by_id(params[:transport_detail]).transport_route
     @boards = TransportBoard.find(:all,:conditions=>{:status=>true,:transport_route_id=>transport_route.id})
    @passenger = PassengerBoardTransportDetail.find(params[:id])
    render :partial=>'edit_passenger'
  end
  
  def update_passenger
    puts "the updated params are#{params}"
    @passenger = PassengerBoardTransportDetail.find(params[:id])
     transport_detail = @passenger.transport_detail
      if @passenger.update_attributes(:transport_board_id=>params[:transport_board])
        @passengers =PassengerBoardTransportDetail.find_all_by_transport_detail_id(transport_detail.id)
      else
        puts "the errors#{@passenger.errors.full_messages}"
         end
          render :partial => 'view_passenger'
  end
  
  def passengers_pdf
   
    @transport_detail = TransportDetail.find_by_id(params[:transport_detail])
    @title="#{@transport_detail.transport_route.name}/#{@transport_detail.transport_vehicle.registration_no}/#{@transport_detail.transport_driver.name} detailed report"
     @passenger = PassengerBoardTransportDetail.find_all_by_transport_detail_id(@transport_detail.id)
     render :pdf => 'passengers_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 20,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end
  
  
  def transport_report
    
  end
  def transport_report_index
    
    if params[:type]=='route'
      @routes = TransportRoute.find(:all,:conditions=>{:status=>true})
    render :partial=>'route_report'  
    else
      @boards=[]
       @routes = TransportRoute.find(:all,:conditions=>{:status=>true})
      render :partial=>'board_report'
    
  end
  end
  
  def get_transport_report
    @board=params[:board]
    @route =params[:route]
   
    unless @route.blank?
      @type="route"
      passenger_board_trans_details=[]
      transport_boards=TransportBoard.find_all_by_transport_route_id(@route,:conditions=>{:status=>true})
      transport_boards.each do |transport_board|
        passenger_board_trans_details=passenger_board_trans_details+PassengerBoardTransportDetail.find_all_by_transport_board_id(transport_board.id)
           end
      @transport_details=passenger_board_trans_details

   else
     @type="board"
       @transport_details =PassengerBoardTransportDetail.find_all_by_transport_board_id(@board)
   end
    render :partial=>'transport_report'
  end
  
   def get_transport_report_pdf
    @board=params[:board]
    @route =params[:route]
    unless @route.blank?
      @type="route"
      transport_route=TransportRoute.find_by_id(@route)
      @title="#{transport_route.name unless transport_route.nil?} wise report"
      passenger_board_trans_details=[]
      transport_boards=TransportBoard.find_all_by_transport_route_id(@route,:conditions=>{:status=>true})
      transport_boards.each do |transport_board|
        passenger_board_trans_details=passenger_board_trans_details+PassengerBoardTransportDetail.find_all_by_transport_board_id(transport_board.id)
           end
      @transport_details=passenger_board_trans_details

   else
     @type="board"
     transport_board=TransportBoard.find_by_id(@board)
     @title="#{transport_board.name unless transport_board.nil?} wise report"
       @transport_details =PassengerBoardTransportDetail.find_all_by_transport_board_id(@board)
   end
    render :pdf => 'get_transport_report_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 35,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end
  
  def transport_fee_collection
    
  end
  def collection_index
     @type=params[:type]
      @batches=[]
    render :partial=>'student' 
  end
 def collection_batch
  @course =Course.find_by_id(params[:course_id]) 
   @batches = Batch.find_all_by_course_id(@course.id)
   render :partial=>'collection_batch'
 end
 
 def get_transport_fee_collection

 if params[:type] == 'student'
   @transport_fee_categories=TransportFeeCategory.find(:all,:conditions=>{:status=>true,:passenger_type=>'Student'})
   @batch=params[:id]
 @students =Student.find_all_by_batch_id(params[:id],:conditions=>{:is_transport_enabled=>true})
 render :partial=>'get_student_transport_fee_collection'
 else
   @transport_fee_categories=TransportFeeCategory.find(:all,:conditions=>{:status=>true,:passenger_type=>'Employee'})
   @department=params[:id]
   @employees=Employee.find_all_by_employee_department_id(params[:id],:conditions=>{:is_transport_enabled=>true})
   render :partial=>'get_employee_transport_fee_collection'
 end
 end
 def create_transport_fee_collections
  
 end
 
 def get_route_board
  @boards=TransportBoard.find_all_by_transport_route_id(params[:route])
 render :partial=>'get_route_board'  
 end
 def get_fee_collection_filter
   @transport_fee_category=TransportFeeCategory.find(:all,:conditions=>{:status=>true})
   render :partial=>'fee_collection_filter'
 end
end
