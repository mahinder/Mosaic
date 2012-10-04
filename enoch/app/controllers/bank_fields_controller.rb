class BankFieldsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
   def all_record
    @bank_field = BankField.new
    @active_bank_fields = BankField.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_bank_fields = BankField.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = BankField.count(:all)
    
    response = { :active_bank_fields => @active_bank_fields, :inactive_bank_fields => @inactive_bank_fields, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  # GET /bank_fields
  # GET /bank_fields.json
  def index
    @bank_fields = BankField.all
    @active_bank_fields = BankField.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_bank_fields = BankField.find(:all,:order => "name asc",:conditions=>{:status => false})
    response = { :active_bank_fields => @active_bank_fields, :inactive_bank_fields => @inactive_bank_fields, :record_count => @record_count}
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json  { render :json => response }
    end
     
  end

  # GET /bank_fields/1
  # GET /bank_fields/1.json
  def show
    @bank_field = BankField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bank_field }
    end
  end

  # GET /bank_fields/new
  # GET /bank_fields/new.json
  def new
    @bank_field = BankField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bank_field }
    end
  end

  # GET /bank_fields/1/edit
  def edit
    @bank_field = BankField.find(params[:id])
  end

  # POST /bank_fields
  # POST /bank_fields.json
  def create
    @bank_field = BankField.new(params[:bank_field])

    respond_to do |format|
      if @bank_field.save
         @record_count = BankField.count(:all)
         format.html { redirect_to @bank_field, notice: 'Bank field was successfully created.' }
        format.json { render :json => {:valid => true, :bank_field => @bank_field, :notice => "Bank field was successfully created."}}
        # format.json { render json: @bank_field, status: :created, location: @bank_field }
      else
        format.html { render action: "new" }
         format.json { render :json => {:valid => false, :errors => @bank_field.errors}}
        # format.json { render json: @bank_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bank_fields/1
  # PUT /bank_fields/1.json
  def update
    @bank_field = BankField.find(params[:id])

    respond_to do |format|
      if @bank_field.update_attributes(params[:bank_field])
        format.html { redirect_to @bank_field, notice: 'Bank field was successfully updated.' }
        # format.json { head :ok }
         format.json { render :json => {:valid => true, :bank_field => @bank_field, :notice => "Bank Field was updated successfully."} }
      else
        format.html { render action: "edit" }
        # format.json { render json: @bank_field.errors, status: :unprocessable_entity }
         format.json { render :json => {:valid => false, :bank_field.errors => @bank_field.errors}}
      end
    end
  end

  # DELETE /bank_fields/1
  # DELETE /bank_fields/1.json
  def destroy
    @bank_field = BankField.find(params[:id])
    @employee_bank_details = EmployeeBankDetail.find(:all, :conditions=>"bank_field_id = #{params[:id]}")
    if @employee_bank_details.empty?
    @bank_field.destroy
    respond_to do |format|
      format.html { redirect_to bank_fields_url }
      format.json { render :json => {:valid => true,  :notice => "Bank Field was deleted successfully."}}
    end
    else
       respond_to do |format|
         format.html { redirect_to bank_fields_url }
        str = "Bank field cannot be delete"
        dependencyerrors = { :dependecies => [*str]}
        format.json { render :json => {:valid => false,  :errors => dependencyerrors}}
    end
    end
  end
end
