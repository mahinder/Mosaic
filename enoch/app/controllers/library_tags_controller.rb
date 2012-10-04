class LibraryTagsController < ApplicationController
 
 before_filter :login_required # GET /library_tags
  # GET /library_tags.json
  def index
    @library_tags = LibraryTag.all

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @library_tags }
    end
  end

  # GET /library_tags/1
  # GET /library_tags/1.json
  def show
    @library_tag = LibraryTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @library_tag }
    end
  end

  # GET /library_tags/new
  # GET /library_tags/new.json
  def new
    @library_tag = LibraryTag.new
    @library_tags = LibraryTag.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @library_tag }
    end
  end

  # GET /library_tags/1/edit
  def edit
    @library_tag = LibraryTag.find(params[:id])
  end

  # POST /library_tags
  # POST /library_tags.json
  def create
    @library_tag = LibraryTag.new(params[:library_tag])

    respond_to do |format|
      if @library_tag.save
        format.html { redirect_to @library_tag, notice: 'library_tag was successfully created.' }
        format.json { render :json => {:valid => true,  :notice => "library_tag was successfully created."}}
      else
        format.html { render action: "new" }
          format.json { render :json => {:valid => false, :errors => @library_tag.errors}}
      end
    end
  end

  # PUT /library_tags/1
  # PUT /library_tags/1.json
  def update
    @library_tag = LibraryTag.find(params[:id])

    respond_to do |format|
      if @library_tag.update_attributes(params[:library_tag])
        format.html { redirect_to @library_tag, notice: 'library_tag was successfully updated.' }
        format.json { render :json => {:valid => true, :notice => "library_tag was successfully updated."}}
      else
        format.html { render action: "edit" }
       format.json { render :json => {:valid => false, :errors => @library_tag.errors}}
      end
    end
  end

  # DELETE /library_tags/1
  # DELETE /library_tags/1.json
  def destroy
    @library_tag = LibraryTag.find(params[:id])
    @library_tag.destroy

    respond_to do |format|
      format.html { redirect_to library_tags_url }
      format.json { render :json => {:valid => true,  :notice => "library_tag was deleted successfully!"}}
    end
  end
end
