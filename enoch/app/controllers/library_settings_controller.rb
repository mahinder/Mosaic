class LibrarySettingsController < ApplicationController
  before_filter :login_required
  # GET /library_settings.json
  def index
    @library_settings = LibrarySetting.all

    respond_to do |format|
      format.html { render :layout => false }# index.html.erb
      format.json { render json: @library_settings }
    end
  end

  # GET /library_settings/1
  # GET /library_settings/1.json
  def show
    @library_setting = LibrarySetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @library_setting }
    end
  end

  # GET /library_settings/new
  # GET /library_settings/new.json
  def new
    @library_setting = LibrarySetting.new
    @library_settings = LibrarySetting.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @library_setting }
    end
  end

  # GET /library_settings/1/edit
  def edit
    @library_setting = LibrarySetting.find(params[:id])
  end

  # POST /library_settings
  # POST /library_settings.json
  def create
    @library_setting = LibrarySetting.new(params[:library_setting])

    respond_to do |format|
      if @library_setting.save
        format.html { redirect_to @library_setting, notice: 'Library setting was successfully created.' }
        format.json { render :json => {:valid => true,  :notice => "Library setting was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @library_setting.errors}}
      end
    end
  end

  # PUT /library_settings/1
  # PUT /library_settings/1.json
  def update
    @library_setting = LibrarySetting.find(params[:id])

    respond_to do |format|
      if @library_setting.update_attributes(params[:library_setting])
        format.html { redirect_to @library_setting, notice: 'Library setting was successfully updated.' }
        format.json { render :json => {:valid => true, :notice => "library setting was successfully updated."}}
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :errors => @library_setting.errors}}
      end
    end
  end

  # DELETE /library_settings/1
  # DELETE /library_settings/1.json
  def destroy
    @library_setting = LibrarySetting.find(params[:id])
    @library_setting.destroy

    respond_to do |format|
      format.html { redirect_to library_settings_url }
     format.json { render :json => {:valid => true,  :notice => "library setting was deleted successfully!"}}
    end
  end
end
