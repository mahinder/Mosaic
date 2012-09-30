class TermMastersController < ApplicationController
  before_filter :login_required
  # GET /term_masters
  # GET /term_masters.json
  def all_record
    @term_masters = TermMaster.new
    @active_master = TermMaster.find(:all,:order => "name asc",:conditions=>{:is_active => true})
    @inactive_master = TermMaster.find(:all,:order => "name asc",:conditions=>{:is_active => false})
    @record_count = TermMaster.count(:all)
    
    response = { :positions => @active_master, :inactive_positions => @inactive_master, :record_count => @record_count}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end
  
  def index
    @term_masters = TermMaster.all
    @active_master = TermMaster.find(:all,:order => "name asc",:conditions=>{:is_active => true})
    @inactive_master = TermMaster.find(:all,:order => "name asc",:conditions=>{:is_active => false})
    @record_count = TermMaster.count(:all)
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
      format.json { render json: @term_masters }
    end
  end

  # GET /term_masters/1
  # GET /term_masters/1.json
  def show
    @term_master = TermMaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @term_master }
    end
  end

  # GET /term_masters/new
  # GET /term_masters/new.json
  def new
    @term_master = TermMaster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @term_master }
    end
  end

  # GET /term_masters/1/edit
  def edit
    @term_master = TermMaster.find(params[:id])
  end

  # POST /term_masters
  # POST /term_masters.json
  def create
    @term_master = TermMaster.new(params[:term_master])

    respond_to do |format|
      if @term_master.save
        @record_count = TermMaster.count(:all)
        format.html { redirect_to @term_master, notice: 'Term master was successfully created.' }
        format.json { render :json => {:valid => true, :term_master => @term_master, :notice => "Term was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @term_master.errors}}
      end
    end
  end

  # PUT /term_masters/1
  # PUT /term_masters/1.json
  def update
    @term_master = TermMaster.find(params[:id])

    respond_to do |format|
      if @term_master.update_attributes(params[:term_master])
        format.html { redirect_to @term_master, notice: 'Term master was successfully updated.' }
        format.json { render :json => {:valid => true, :term_master => @term_master, :notice => "Term master was successfully updated."} }
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :term_master.errors => @term_master.errors}}
      end
    end
  end

  # DELETE /term_masters/1
  # DELETE /term_masters/1.json
  def destroy
    @term_master = TermMaster.find(params[:id])
    @term_master.destroy

    respond_to do |format|
      format.html { redirect_to term_masters_url }
      format.json { render :json => {:valid => true,  :notice => "Term is deleted successfully." }}
    end
  end
end
