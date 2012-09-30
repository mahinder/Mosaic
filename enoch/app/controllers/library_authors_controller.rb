class LibraryAuthorsController < ApplicationController
  # GET /LibraryAuthors
  # GET /LibraryAuthors.json
  def index
    @library_authors = LibraryAuthor.all

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @library_authors }
    end
  end

  # GET /LibraryAuthors/1
  # GET /LibraryAuthors/1.json
  def show
    @library_author = LibraryAuthor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @library_author }
    end
  end

  # GET /LibraryAuthors/new
  # GET /LibraryAuthors/new.json
  def new
    @library_author = LibraryAuthor.new
    @library_authors = LibraryAuthor.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @library_author }
    end
  end

  # GET /LibraryAuthors/1/edit
  def edit
    @library_author = LibraryAuthor.find(params[:id])
  end

  # POST /LibraryAuthors
  # POST /LibraryAuthors.json
  def create
    @library_author = LibraryAuthor.new(params[:library_author])

    respond_to do |format|
      if @library_author.save
        format.html { redirect_to @library_author, notice: 'Author was successfully created.' }
       format.json { render :json => {:valid => true,  :notice => "Author was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @library_author.errors}}
      end
    end
  end

  # PUT /LibraryAuthors/1
  # PUT /LibraryAuthors/1.json
  def update
    @library_author = LibraryAuthor.find(params[:id])

    respond_to do |format|
      if @library_author.update_attributes(params[:library_author])
        format.html { redirect_to @library_author, notice: 'Author was successfully updated.' }
        format.json { render :json => {:valid => true, :notice => "Author was successfully updated."}}
      else
        format.html { render action: "edit" }
        format.json { render :json => {:valid => false, :errors => @library_author.errors}}
      end
    end
  end

  # DELETE /LibraryAuthors/1
  # DELETE /LibraryAuthors/1.json
  def destroy
    @library_author = LibraryAuthor.find(params[:id])
    @library_author.destroy

    respond_to do |format|
      format.html { redirect_to LibraryAuthors_url }
     format.json { render :json => {:valid => true,  :notice => "author was deleted successfully!"}}
    end
  end
end
