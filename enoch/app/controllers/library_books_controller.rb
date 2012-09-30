class LibraryBooksController < ApplicationController
 
 before_filter :login_required
  # GET /LibraryBooks
  # GET /LibraryBooks.json
  
  def index
    @library_books = LibraryBook.all

    respond_to do |format|
      format.html { render :layout => false }# index.html.erb
      format.json { render json: @library_books }
    end
  end

  # GET /LibraryBooks/1
  # GET /LibraryBooks/1.json
  def show
    @library_book = LibraryBook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @library_book }
    end
  end

  # GET /LibraryBooks/new
  # GET /LibraryBooks/new.json
  def new
    @library_book = LibraryBook.new
    @library_books = LibraryBook.all
    @authors = LibraryAuthor.all
    @tags = LibraryTag.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @library_book }
    end
  end

  # GET /LibraryBooks/1/edit
  def edit
    @library_book = LibraryBook.find(params[:id])
  end

  # POST /LibraryBooks
  # POST /LibraryBooks.json
  def create
    @library_book = ""
    numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/ 
    if params[:library_book][:library_tag_id] =~ numericReg_for_nomeric
      @library_book = LibraryBook.new(params[:library_book])
    else
      @library_tag = LibraryTag.create(:name => params[:library_book][:library_tag_id])
      params[:library_book][:library_tag_id] = @library_tag.id
      @library_book = LibraryBook.new(params[:library_book])
    end

    respond_to do |format|
      if @library_book.save
        format.html { redirect_to @library_book, notice: 'LibraryBook was successfully created.' }
        format.json { render :json => {:valid => true,  :notice => "book was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @library_book.errors}}
      end
    end
  end

  # PUT /LibraryBooks/1
  # PUT /LibraryBooks/1.json
  def update
    @library_book = LibraryBook.find(params[:id])
     numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/ 
    if params[:library_book][:library_tag_id] =~ numericReg_for_nomeric
      
    else
      @library_tag = LibraryTag.create(:name => params[:library_book][:library_tag_id])
      params[:library_book][:library_tag_id] = @library_tag.id
     
    end
    respond_to do |format|
      if @library_book.update_attributes(params[:library_book])
        format.html { redirect_to @library_book, notice: 'LibraryBook was successfully updated.' }
        format.json { render :json => {:valid => true, :notice => "library book was successfully updated."}}
      else
        format.html { render action: "edit" }
         format.json { render :json => {:valid => false, :errors => @library_book.errors}}
      end
    end
  end
def library_select_update
    @tags = LibraryTag.all
    render '_tag_select',:layout => false
   
  end
  
  # DELETE /LibraryBooks/1
  # DELETE /LibraryBooks/1.json
  def destroy
    @library_book = LibraryBook.find(params[:id])
    @library_book.destroy

    respond_to do |format|
      format.html { redirect_to LibraryBooks_url }
      format.json { render :json => {:valid => true,  :notice => "library book was deleted successfully!"}}
    end
  end
end
