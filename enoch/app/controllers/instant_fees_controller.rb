class InstantFeesController < ApplicationController
  before_filter :login_required
  def all_record 
    @instant_fees = InstantFee.new
    @instant_fees_categories = InstantFee.find(:all,:order => "name asc")
  end
  
  # GET /instant_fees
  # GET /instant_fees.json
  def index
    @instant_fees = InstantFee.all
    @instant_fees_categories = InstantFee.find(:all,:order => "name asc")
    response = { :instant_fees_categories => @instant_fees_categories,:instant_fees => @instant_fees}
    respond_to do |format|
      format.html { render :layout => false}
      format.json { render :json => response}
    end
  end

  # GET /instant_fees/1
  # GET /instant_fees/1.json
  def show
    @instant_fee = InstantFee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @instant_fee }
    end
  end

  # GET /instant_fees/new
  # GET /instant_fees/new.json
  def new
    @instant_fee = InstantFee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instant_fee }
    end
  end

  # GET /instant_fees/1/edit
  def edit
    @instant_fee = InstantFee.find(params[:id])
  end

  # POST /instant_fees
  # POST /instant_fees.json
  def create
    @instant_fee = InstantFee.new(params[:instant_fee])
    @instant_fee.school_session_id = current_session.id
    respond_to do |format|
      if @instant_fee.save
         format.html { redirect_to @instant_fee, notice: 'Instant Fees is successfully created.' }
         format.json { render :json => {:valid => true, :instant_fees => @instant_fee, :notice => "Instant Fees is successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @instant_fee.errors}}
      end
    end
  end

  # PUT /instant_fees/1
  # PUT /instant_fees/1.json
  def update
    @instant_fee = InstantFee.find(params[:id])
    @instant_fee.school_session_id = current_session.id
    respond_to do |format|
      if @instant_fee.update_attributes(params[:instant_fee])
        format.html { redirect_to @instant_fee, notice: 'Instant Fees is successfully updated.' }
        format.json { render :json => {:valid => true, :instant_fees => @instant_fee, :notice => "Instant Fees is updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :errors => @instant_fee.errors}}
      end
    end
  end

  # DELETE /instant_fees/1
  # DELETE /instant_fees/1.json
  def destroy
    @instant_fee = InstantFee.find(params[:id])
    unless @instant_fee.has_collected_fee(@instant_fee)
    @instant_fee.destroy
    else
      @error = true
    end
    respond_to do |format|
      if @error.nil?
      format.html { redirect_to instant_fees_url }
      format.json { render :json => {:valid => true,  :notice => "Instant Fees deleted successfully." }}
      else
      str = "Instant Fee can not be deleted"
      dependency_errors = {:dependency => [*str]}
      format.json { render :json => {:valid => false, :errors => dependency_errors}}
      end
    end
  end
end
