class FinancialAssetsController < ApplicationController
  before_filter :login_required
 filter_access_to :all
  
  
  def all_record
    @financial_asset = FinancialAsset.new
    @active_financial_assets = FinancialAsset.find(:all,:order => "title asc",:conditions=>{:is_inactive => false})
    @inactive_financial_assets = FinancialAsset.find(:all,:order => "title asc",:conditions=>{:is_inactive => true})
    @record_count = FinancialAsset.count(:all)
    
    response = { :active_financial_assets => @active_financial_assets, :inactive_financial_assets => @inactive_financial_assets, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  
  
  # GET /financial_assets
  # GET /financial_assets.json
  def index
    @financial_assets = FinancialAsset.all
    @active_financial_assets = FinancialAsset.find(:all,:order => "title asc",:conditions=>{:is_inactive => false})
    @inactive_financial_assets = FinancialAsset.find(:all,:order => "title asc",:conditions=>{:is_inactive => true})
    response = { :active_financial_assets => @active_financial_assets, :inactive_financial_assets => @inactive_financial_assets, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render :json => response }
    end
  end

  # GET /financial_assets/1
  # GET /financial_assets/1.json
  def show
    @financial_asset = FinancialAsset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @financial_asset }
    end
  end

  # GET /financial_assets/new
  # GET /financial_assets/new.json
  def new
    @financial_asset = FinancialAsset.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @financial_asset }
    end
  end

  # GET /financial_assets/1/edit
  def edit
    @financial_asset = FinancialAsset.find(params[:id])
  end

  # POST /financial_assets
  # POST /financial_assets.json
  def create
    @financial_asset = FinancialAsset.new(params[:financial_asset])

    respond_to do |format|
      if @financial_asset.save
        @record_count = EmployeeGrade.count(:all)
        format.html { redirect_to @financial_asset, notice: 'Financial asset was successfully created.' }
        format.json { render :json => {:valid => true, :financial_asset => @financial_asset, :notice => "Finance asset was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @financial_asset.errors} }
      end
    end
  end

  # PUT /financial_assets/1
  # PUT /financial_assets/1.json
  def update
    @financial_asset = FinancialAsset.find(params[:id])

    respond_to do |format|
      if @financial_asset.update_attributes(params[:financial_asset])
        format.html { redirect_to @financial_asset, notice: 'Financial asset was successfully updated.' }
         format.json { render :json => {:valid => true, :financial_asset => @financial_asset, :notice => "Financial asset was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :financial_asset.errors => @financial_asset.errors}}
        # format.json { render json: @financial_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /financial_assets/1
  # DELETE /financial_assets/1.json
  def destroy
    @financial_asset = FinancialAsset.find(params[:id])
    @financial_asset.destroy

    respond_to do |format|
      format.html { redirect_to financial_assets_url }
      format.json { render :json => {:valid => true,  :notice => "financial asset was deleted successfully."}}
    end
  end
end
