class AdditionalFieldsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
   def all_record
    @additional_field = AdditionalField.new
    @active_additional_fields = AdditionalField.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_additional_fields = AdditionalField.find(:all,:order => "name asc",:conditions=>{:status => false})
    @record_count = AdditionalField.count(:all)
    
    response = { :active_additional_fields => @active_additional_fields, :inactive_additional_fields => @inactive_additional_fields, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end 
  end
  # GET /additional_fields
  # GET /additional_fields.json
  def index
    @additional_fields = AdditionalField.all
    @active_additional_fields = AdditionalField.find(:all,:order => "name asc",:conditions=>{:status => true})
    @inactive_additional_fields = AdditionalField.find(:all,:order => "name asc",:conditions=>{:status => false})


    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @additional_fields }
    end
  end

  # GET /additional_fields/1
  # GET /additional_fields/1.json
  def show
    @additional_field = AdditionalField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @additional_field }
    end
  end

  # GET /additional_fields/new
  # GET /additional_fields/new.json
  def new
    @additional_field = AdditionalField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @additional_field }
    end
  end

  # GET /additional_fields/1/edit
  def edit
    @additional_field = AdditionalField.find(params[:id])
  end

  # POST /additional_fields
  # POST /additional_fields.json
  def create
    @additional_field = AdditionalField.new(params[:additional_field])

    respond_to do |format|
      if @additional_field.save 
         @record_count = AdditionalField.count(:all)
        format.html { redirect_to @additional_field, notice: 'Additional field was successfully created.' }
        format.json { render :json => {:valid => true, :additional_field => @additional_field, :notice => "Additional field was successfully created."} }
      else
         format.html { render action: "new" }
         format.json { render :json => {:valid => false, :errors => @additional_field.errors}}
      end
    end
  end

  # PUT /additional_fields/1
  # PUT /additional_fields/1.json
  def update
    @additional_field = AdditionalField.find(params[:id])

    respond_to do |format|
      if @additional_field.update_attributes(params[:additional_field])
        format.html { redirect_to @additional_field, notice: 'Additional field was successfully updated.' }
       format.json { render :json => {:valid => true, :additional_field => @additional_field, :notice => "Additional Field was updated successfully."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :additional_fields.errors => @additional_fields.errors}}
      end
    end
  end

  # DELETE /additional_fields/1
  # DELETE /additional_fields/1.json
  def destroy
    @additional_field = AdditionalField.find(params[:id])
    @employee_additional_details = EmployeeAdditionalDetail.find(:all, :conditions=>"additional_field_id = #{params[:id]}")
   if @employee_additional_details.empty?
    @additional_field.destroy

    respond_to do |format|
      format.html { redirect_to additional_fields_url }
       format.json { render :json => {:valid => true,  :notice => "Additional Field was deleted successfully."}}
    end
    else
      respond_to do |format|
        format.html { redirect_to additional_fields_url }
        str = "Additional field cannot be delete"
        dependencyerrors = { :dependecies => [*str]}
        format.json { render :json => {:valid => false,  :errors => dependencyerrors}}
  end
  end
end
end
