class SchoolSessionsController < ApplicationController
    before_filter :login_required
  # GET /school_sessions
  # GET /school_sessions.json
  def all_record
    @school_sessions = SchoolSession.all
    @active_school_sessions = SchoolSession.find(:all,:order => "name asc",:conditions=>{:current_session => true})
    @inactive_school_sessions = SchoolSession.find(:all,:order => "name asc",:conditions=>{:current_session => false})
    respond_to do |format|
      format.html { render :partial => 'school_session'}
      format.json { render json: @school_sessions }
    end
  end
  
  def index
    @school_sessions = SchoolSession.new
    @active_school_sessions = SchoolSession.find(:all,:order => "name asc",:conditions=>{:current_session => true})
    @inactive_school_sessions = SchoolSession.find(:all,:order => "name asc",:conditions=>{:current_session => false})
    respond_to do |format|
      format.html 
      format.json { render json: @school_sessions }
    end
  end

  # GET /school_sessions/1
  # GET /school_sessions/1.json
  def show
    @school_session = SchoolSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school_session }
    end
  end

  # GET /school_sessions/new
  # GET /school_sessions/new.json
  def new
    @school_session = SchoolSession.new
    @active_school_sessions = SchoolSession.find(:all,:order => "name asc",:conditions=>{:current_session => true})
    @inactive_school_sessions = SchoolSession.find(:all,:order => "name asc",:conditions=>{:current_session => false})
    respond_to do |format|
      format.html
      format.json { render json: @school_session }
    end
  end

  # GET /school_sessions/1/edit
  def edit
    @school_session = SchoolSession.find(params[:id])
  end

  # POST /school_sessions
  # POST /school_sessions.json
  def create
    is_current_session = params[:school_session][:current_session]
    @school_session = SchoolSession.new(params[:school_session])
    respond_to do |format|
      if @school_session.save
        if is_current_session == "true"
        school_sessions = SchoolSession.find(:all, :conditions => ["id != ?",@school_session.id ])
         school_sessions.each do |school_session|
            school_session.update_attribute(:current_session, false) unless school_sessions.nil?
         end
        end
        format.html { redirect_to @school_session, notice: 'School session was successfully created.' }
        format.json { render :json => {:valid => true, :school_session => @school_session, :notice => "School session was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors =>@school_session.errors}}
      end
    end
  end

  # PUT /school_sessions/1
  # PUT /school_sessions/1.json
  def update
    is_current_session = params[:school_session][:current_session]
    @school_session = SchoolSession.find(params[:id])
    respond_to do |format|
      if @school_session.update_attributes(params[:school_session])
        if is_current_session == "true"
        school_sessions = SchoolSession.find(:all, :conditions => ["id != ?",@school_session.id ])
         school_sessions.each do |school_session|
            school_session.update_attribute(:current_session, false) unless school_sessions.nil?
         end
        end
        format.html { redirect_to @school_session, notice: 'School session was successfully updated.' }
        format.json { render :json => {:valid => true, :school_session => @school_session, :notice => "School session was successfully updated."}}
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :errors =>@school_session.errors}}
      end
    end
  end

  # DELETE /school_sessions/1
  # DELETE /school_sessions/1.json
  def destroy
    @school_session = SchoolSession.find(params[:id])
    @school_session.destroy

    respond_to do |format|
      format.html { redirect_to school_sessions_url }
      format.json { head :ok }
    end
  end
end
