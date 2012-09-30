class InstantFeeParticularsController < ApplicationController
  before_filter :login_required
  # GET /instant_fee_particulars
  # GET /instant_fee_particulars.json
  def index
    @instant_fee_particulars = InstantFeeParticular.all
    @instant_fee = InstantFee.find_by_id(params[:id])
    @fee_particulars = InstantFeeParticular.find_all_by_instant_fee_id_and_is_deleted(@instant_fee.id,false)
    if @fee_particulars.nil?
      @fee_particulars = []
    end
    response = { :instant_fee_particulars => @instant_fees_categories,:instant_fees => @instant_fees}
    respond_to do |format|
      format.html { render :layout => false}
      format.json { render :json => response}
    end
  end

  # GET /instant_fee_particulars/1
  # GET /instant_fee_particulars/1.json
  def show
    @instant_fee_particular = InstantFeeParticular.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @instant_fee_particular }
    end
  end

  # GET /instant_fee_particulars/new
  # GET /instant_fee_particulars/new.json
  def new
    @instant_fee_particular = InstantFeeParticular.new
    @instant_fee = InstantFee.find_by_id(params[:id])
    @fee_particulars = InstantFeeParticular.find_all_by_instant_fee_id_and_is_deleted(@instant_fee.id,false)
    if @fee_particulars.nil?
      @fee_particulars = []
    end
    render :partial => 'form'
  end

  # GET /instant_fee_particulars/1/edit
  def edit
    @instant_fee_particular = InstantFeeParticular.find(params[:id])
  end

  # POST /instant_fee_particulars
  # POST /instant_fee_particulars.json
  def create
    @instant_fee_particular = InstantFeeParticular.new(params[:instant_fee_particular])

    respond_to do |format|
      if @instant_fee_particular.save
         format.html { redirect_to @instant_fee_particular, notice: 'Category is successfully created.' }
         format.json { render :json => {:valid => true, :instant_fee_particular => @instant_fee_particular, :notice => "Instant Fees Particular was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @instant_fee_particular.errors}}
      end
    end
  end

  # PUT /instant_fee_particulars/1
  # PUT /instant_fee_particulars/1.json
  def update
    @instant_fee_particular = InstantFeeParticular.find(params[:id])

    respond_to do |format|
      if @instant_fee_particular.update_attributes(params[:instant_fee_particular])
        format.html { redirect_to @instant_fee_particular, notice: 'Instant Fees Particular is successfully updated.' }
        format.json { render :json => {:valid => true, :instant_fee_particular => @instant_fee_particular, :notice => "Instant Fees Particular is updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :instant_fee_particular => @instant_fee_particular, :errors => @instant_fee_particular.errors}}
      end
    end
  end

  # DELETE /instant_fee_particulars/1
  # DELETE /instant_fee_particulars/1.json
  def destroy
    @instant_fee_particular = InstantFeeParticular.find(params[:id])
      unless @instant_fee_particular.has_collected_fee(@instant_fee_particular)
        @instant_fee_particular.destroy
      else
        @error = true
      end
      respond_to do |format|
            if @error.nil?
            format.html { redirect_to @instant_fee_particular, notice: 'Instant Fees Particular is successfully deleted.' }
            format.json { render :json => {:valid => true, :instant_fee_particular => @instant_fee_particular, :notice => "Instant Fees Particular is successfully deleted."} }
            else
            str = "Instant Fee Particular can not be deleted"
            dependency_errors = {:dependency => [*str]}
            format.json { render :json => {:valid => false, :errors => dependency_errors}}
            end
      end
   end
end
