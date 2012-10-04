class TransportBoardsController < ApplicationController
  before_filter :login_required
  # GET /transport_boards
  # GET /transport_boards.json
  def index
     @transport_board = TransportBoard.new
    @active_transport_boards = TransportBoard.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_transport_boards = TransportBoard.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = TransportBoard.count(:all)
    
    response = { :active_transport_borde => @active_transport_boards, :inactive_transport_borde => @inactive_transport_boards, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout => false}
      format.json  { render :json => response }
    end 
  end

  # GET /transport_boards/1
  # GET /transport_boards/1.json
  def show
    @transport_board = TransportBoard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_board }
    end
  end

  # GET /transport_boards/new
  # GET /transport_boards/new.json
  def new
    @transport_board = TransportBoard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_board }
    end
  end

  # GET /transport_boards/1/edit
  def edit
    @transport_board = TransportBoard.find(params[:id])
  end

  # POST /transport_boards
  # POST /transport_boards.json
  def create
    @transport_board = TransportBoard.new(params[:transport_board])

    respond_to do |format|
      if @transport_board.save
         @record_count = TransportBoard.count(:all)
        format.html { redirect_to @transport_board, notice: 'Transport board was successfully created.' }
        format.json { render :json => {:valid => true, :transport_borde => @transport_board, :notice => "Transport board was successfully created."}}
      else
        format.html { render action: "new" }
         format.json { render :json => {:valid => false, :errors => @transport_board.errors}}
      end
    end
  end

  # PUT /transport_boards/1
  # PUT /transport_boards/1.json
  def update
    @transport_board = TransportBoard.find(params[:id])

    respond_to do |format|
      if @transport_board.update_attributes(params[:transport_board])
        format.html { redirect_to @transport_board, notice: 'Transport board was successfully updated.' }
       format.json { render :json => {:valid => true, :transport_board => @transport_board, :notice => "Transport board was successfully updated."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :errors => @transport_board.errors}}
      end
    end
  end

  # DELETE /transport_boards/1
  # DELETE /transport_boards/1.json
  def destroy
    @transport_board = TransportBoard.find(params[:id])
    @transport_board.destroy

    respond_to do |format|
      format.html { redirect_to transport_boards_url }
     format.json { render :json => {:valid => true,  :notice => "Transport board was deleted successfully."}}
    end
  end
  def all_record
     @transport_board = TransportBoard.new
     @transport_route= TransportRoute.find(:all,:order => "start_place asc",:conditions=>{:status => true})
    @active_transport_boards = TransportBoard.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_transport_boards = TransportBoard.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = TransportBoard.count(:all)
    
    response = { :active_transport_borde => @active_transport_boards, :inactive_transport_borde => @inactive_transport_boards, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  
end
