class LiabilitiesController < ApplicationController
  before_filter :login_required
 filter_access_to :all
  
  
  def all_record
    @liability = Liability.new
    @active_liabilities = Liability.find(:all,:order => "title asc",:conditions=>{:is_deleted => false})
    @inactive_liabilities = Liability.find(:all,:order => "title asc",:conditions=>{:is_deleted => true})
    @record_count = Asset.count(:all)
    
    response = { :active_liabilities => @active_liabilities, :inactive_liabilities => @inactive_liabilities, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  # GET /liabilities
  # GET /liabilities.json
  def index
    @liabilities = Liability.all
    @active_liabilities = Liability.find(:all,:order => "title asc",:conditions=>{:is_deleted => false})
    @inactive_liabilities = Liability.find(:all,:order => "title asc",:conditions=>{:is_deleted => true})
    response = { :active_liabilities => @active_liabilities, :inactive_liabilities => @inactive_liabilities, :record_count => @record_count}

    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
  end

  # GET /liabilities/1
  # GET /liabilities/1.json
  def show
    @liability = Liability.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liability }
    end
  end

  # GET /liabilities/new
  # GET /liabilities/new.json
  def new
    @liability = Liability.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liability }
    end
  end

  # GET /liabilities/1/edit
  def edit
    @liability = Liability.find(params[:id])
  end

  # POST /liabilities
  # POST /liabilities.json
  def create
    @liability = Liability.new(params[:liability])

    respond_to do |format|
      if @liability.save
        @record_count = EmployeeGrade.count(:all)
        format.html { redirect_to @liability, notice: 'Liability was successfully created.' }
        format.json { render :json => {:valid => true, :liability => @liability, :notice => "liability was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @liability.errors}}
        # format.json { render json: @liability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liabilities/1
  # PUT /liabilities/1.json
  def update
    @liability = Liability.find(params[:id])

    respond_to do |format|
      if @liability.update_attributes(params[:liability])
        format.html { redirect_to @liability, notice: 'Liability was successfully updated.' }
        format.json { render :json => {:valid => true, :bank_field => @liability, :notice => "Liability was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :liability.errors => @liability.errors}}
      end
    end
  end

  # DELETE /liabilities/1
  # DELETE /liabilities/1.json
  def destroy
    @liability = Liability.find(params[:id])
    @liability.destroy

    respond_to do |format|
      format.html { redirect_to liabilities_url }
       format.json { render :json => {:valid => true,  :notice => "Liability was deleted successfully."}}
    end
  end
end
