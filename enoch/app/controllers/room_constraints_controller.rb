class RoomConstraintsController < ApplicationController
  # GET /room_constraints
  # GET /room_constraints.json
  def index
    @room_constraints = RoomConstraint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @room_constraints }
    end
  end

  # GET /room_constraints/1
  # GET /room_constraints/1.json
  def show
    @room_constraint = RoomConstraint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room_constraint }
    end
  end

  # GET /room_constraints/new
  # GET /room_constraints/new.json
  def new
    @room_constraint = RoomConstraint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room_constraint }
    end
  end

  # GET /room_constraints/1/edit
  def edit
    @room_constraint = RoomConstraint.find(params[:id])
  end

  def create
    @valid = "no"
    unless params[:full].nil?
      @room_cons = RoomConstraint.find(:all,params[:room_id])
      unless @room_cons.empty?
        @room_cons.each do |cons|
          cons.destroy
        end
      end
      params[:full].each do |con,val|
        @valid = "no"
        @room_constraint =  RoomConstraint.new(val)
        if @room_constraint.save
          @valid = "yes"
        else
        @valid =  @room_constraint.errors
        end
      end
    else
      @valid = "yes"
      @room_cons = RoomConstraint.find(:all,params[:room_id])
      unless @room_cons.empty?
        @room_cons.each do |cons|
          cons.destroy
        end
      end
    end

    respond_to do |format|
      if @valid == "yes"
        format.json { render :json => {:valid => true,:notice => "constraints was successfully created."}}
      else
        format.json { render :json => {:valid => false, :errors => @valid}}
      end
    end
  end

  # PUT /room_constraints/1
  # PUT /room_constraints/1.json
  def update
    @room_constraint = RoomConstraint.find(params[:id])

    respond_to do |format|
      if @room_constraint.update_attributes(params[:room_constraint])
        format.html { redirect_to @room_constraint, notice: 'Room constraint was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @room_constraint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_constraints/1
  # DELETE /room_constraints/1.json
  def destroy
    @room_constraint = RoomConstraint.find(params[:id])
    @room_constraint.destroy

    respond_to do |format|
      format.html { redirect_to room_constraints_url }
      format.json { head :ok }
    end
  end
end
