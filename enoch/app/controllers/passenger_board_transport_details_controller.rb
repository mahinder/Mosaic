class PassengerBoardTransportDetailsController < ApplicationController
  # GET /passenger_board_transport_details
  # GET /passenger_board_transport_details.json
  def index
    @passenger_board_transport_details = PassengerBoardTransportDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @passenger_board_transport_details }
    end
  end

  # GET /passenger_board_transport_details/1
  # GET /passenger_board_transport_details/1.json
  def show
    @passenger_board_transport_detail = PassengerBoardTransportDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @passenger_board_transport_detail }
    end
  end

  # GET /passenger_board_transport_details/new
  # GET /passenger_board_transport_details/new.json
  def new
    @passenger_board_transport_detail = PassengerBoardTransportDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @passenger_board_transport_detail }
    end
  end

  # GET /passenger_board_transport_details/1/edit
  def edit
    @passenger_board_transport_detail = PassengerBoardTransportDetail.find(params[:id])
  end

  # POST /passenger_board_transport_details
  # POST /passenger_board_transport_details.json
  def create
    @passenger_board_transport_detail = PassengerBoardTransportDetail.new(params[:passenger_board_transport_detail])

    respond_to do |format|
      if @passenger_board_transport_detail.save
        format.html { redirect_to @passenger_board_transport_detail, notice: 'Passenger board transport detail was successfully created.' }
        format.json { render json: @passenger_board_transport_detail, status: :created, location: @passenger_board_transport_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @passenger_board_transport_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /passenger_board_transport_details/1
  # PUT /passenger_board_transport_details/1.json
  def update
    @passenger_board_transport_detail = PassengerBoardTransportDetail.find(params[:id])

    respond_to do |format|
      if @passenger_board_transport_detail.update_attributes(params[:passenger_board_transport_detail])
        format.html { redirect_to @passenger_board_transport_detail, notice: 'Passenger board transport detail was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @passenger_board_transport_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passenger_board_transport_details/1
  # DELETE /passenger_board_transport_details/1.json
  def destroy
    @passenger_board_transport_detail = PassengerBoardTransportDetail.find(params[:id])
    @passenger_board_transport_detail.destroy

    respond_to do |format|
      format.html { redirect_to passenger_board_transport_details_url }
      format.json { head :ok }
    end
  end
end
