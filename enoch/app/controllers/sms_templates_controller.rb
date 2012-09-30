class SmsTemplatesController < ApplicationController
  # GET /sms_templates
  # GET /sms_templates.json
  before_filter :login_required,:sms_security
  filter_access_to :all
  def all_record
    @sms_templates = SmsTemplate.new
    @active = SmsTemplate.find(:all,:order => "template_code asc",:conditions=>{:is_inactive => false})
    @inactive = SmsTemplate.find(:all,:order => "template_code asc",:conditions=>{:is_inactive => true})
    response = { :active => @active, :inactive => @inactive}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end

  def index
    @sms_templates = SmsTemplate.new
    @active = SmsTemplate.find(:all,:order => "template_code asc",:conditions=>{:is_inactive => false})
    @inactive = SmsTemplate.find(:all,:order => "template_code asc",:conditions=>{:is_inactive => true})
    response = { :active => @active, :inactive => @inactive}

    respond_to do |format|
     format.html { render :layout => false }
      format.json  { render :json => response }
    end
  end

  # GET /sms_templates/1
  # GET /sms_templates/1.json
  def show
    @sms_template = SmsTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sms_template }
    end
  end

  # GET /sms_templates/new
  # GET /sms_templates/new.json
  def new
    @sms_template = SmsTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sms_template }
    end
  end

  # GET /sms_templates/1/edit
  def edit
    @sms_template = SmsTemplate.find(params[:id])
  end

  # POST /sms_templates
  # POST /sms_templates.json
  def create
    @sms_template = SmsTemplate.new(params[:sms_template])

    respond_to do |format|
      if @sms_template.save
        format.html { redirect_to @sms_template, notice: 'Sms template was successfully created.' }
        format.json { render :json => {:valid => true, :sms_template => @sms_template, :notice => "Template was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @sms_template.errors}}
      end
    end
  end

  # PUT /sms_templates/1
  # PUT /sms_templates/1.json
  def update
    @sms_template = SmsTemplate.find(params[:id])
  respond_to do |format|
      if @sms_template.update_attributes(params[:sms_template])
        format.html { redirect_to @sms_template, notice: 'Sms template was successfully updated.' }
        format.json { render :json => {:valid => true, :sms_template => @sms_template, :notice => "Sms template was successfully updated."} }
      else
        format.html { render action: "edit" }
         format.json { render :json => {:valid => false, :sms_template.errors => @sms_template.errors}}
      end
    end
  end

  # DELETE /sms_templates/1
  # DELETE /sms_templates/1.json
  def destroy
    @sms_template = SmsTemplate.find(params[:id])
    @sms_template.destroy

    respond_to do |format|
      format.html { redirect_to sms_templates_url }
       format.json { render :json => {:valid => true,  :notice => "Template was deleted successfully."}}
    end
  end
end
