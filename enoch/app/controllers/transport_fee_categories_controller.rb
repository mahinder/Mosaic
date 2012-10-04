class TransportFeeCategoriesController < ApplicationController
  
  before_filter :login_required
  # GET /transport_fee_categories
  # GET /transport_fee_categories.json
  def index
    @transport_fee_categories = TransportFeeCategory.all

    @transport_route= TransportRoute.find(:all,:order => "name asc",:conditions=>{:status => true})
    @active_transport_fee_categories = TransportFeeCategory.find(:all,:conditions=>{:status => true})
    @inactive_transport_fee_categories = TransportFeeCategory.find(:all,:conditions=>{:status => false})
    @record_count = TransportFeeCategory.count(:all)
    
    response = { :active_transport_fee_category => @active_transport_fee_categories, :inactive_transport_fee_category => @inactive_transport_fee_categories, :record_count => @record_count}

    respond_to do |format|
      format.html {render :layout=>false}
      format.json  { render :json => response }
    end 
  end

  # GET /transport_fee_categories/1
  # GET /transport_fee_categories/1.json
  def show
    @transport_fee_category = TransportFeeCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_fee_category }
    end
  end

  # GET /transport_fee_categories/new
  # GET /transport_fee_categories/new.json
  def new
    @transport_fee_category = TransportFeeCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_fee_category }
    end
  end

  # GET /transport_fee_categories/1/edit
  def edit
    @transport_fee_category = TransportFeeCategory.find(params[:id])
  end

  # POST /transport_fee_categories
  # POST /transport_fee_categories.json
  def create
    @transport_fee_category = TransportFeeCategory.new(params[:transport_fee_category])

    respond_to do |format|
      if @transport_fee_category.save
        format.html { redirect_to @transport_fee_category, notice: 'Transport fee category was successfully created.' }
        format.json { render :json => {:valid => true, :transport_fee_category => @transport_fee_category, :notice => "Transport Fee category was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @transport_fee_category.errors}}
      end
    end
  end

  # PUT /transport_fee_categories/1
  # PUT /transport_fee_categories/1.json
  def update
    
    @transport_fee_category = TransportFeeCategory.find_by_id(params[:id])
puts "the para ms#{@transport_fee_category}"
    respond_to do |format|
      if @transport_fee_category.update_attributes(params[:transport_fee_category])
        format.html { redirect_to @transport_fee_category, notice: 'Transport fee category was successfully updated.' }
        format.json { render :json => {:valid => true, :transport_fee_category => @transport_fee_category, :notice => "Transport fee category was successfully updated."} }
      else
        format.html { render action: "edit" }
         format.json { render :json => {:valid => false, :errors => @transport_fee_category.errors}}
      end
    end
  end

  # DELETE /transport_fee_categories/1
  # DELETE /transport_fee_categories/1.json
  def destroy
    @transport_fee_category = TransportFeeCategory.find_by_id(params[:id])
    @transport_fee_category.destroy

    respond_to do |format|
      format.html { redirect_to transport_fee_categories_url }
     format.json { render :json => {:valid => true,  :notice => "Transport fee category was deleted successfully."}}
    end
  end
  
   def all_record
     @transport_fee_category = TransportFeeCategory.new
      @transport_route= TransportRoute.find(:all,:order => "name asc",:conditions=>{:status => true})
    @active_transport_fee_categories = TransportFeeCategory.find(:all,:conditions=>{:status => true})
    @inactive_transport_fee_categories = TransportFeeCategory.find(:all,:conditions=>{:status => false})
    @record_count = TransportFeeCategory.count(:all)
    
    response = { :active_transport_fee_category => @active_transport_fee_categories, :inactive_transport_fee_category => @inactive_transport_fee_categories, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
end
