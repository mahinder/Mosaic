class LibraryIssueBookRecordsController < ApplicationController
  # GET /issue_book_records
  # GET /issue_book_records.json
  before_filter :login_required
  def index
    @issue_book_records = LibraryIssueBookRecord.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issue_book_records }
    end
  end

  def monthly_report
    @report = params[:report]
  end

  # GET /issue_book_records/1
  # GET /issue_book_records/1.json
  def show
    @issue_book_record = LibraryIssueBookRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue_book_record }
    end
  end

  # GET /issue_book_records/new
  # GET /issue_book_records/new.json
  def new
    @issue_book_record = LibraryIssueBookRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue_book_record }
    end
  end

  def library

  end

  def fineinfo
    @Booklibrary = LibraryIssueBookRecord.find_by_id(params[:id])
    @totalfine = 0
    gap =0
    unless @Booklibrary.nil?
      user = User.find_by_id(@Booklibrary.user_id)

      unless user.nil?
        if user.employee

          setting = LibrarySetting.find_by_category("Employee")
          unless setting.nil?
          fine =  setting.fine_charged_per_day_after_due_date
          end

        else

          setting = LibrarySetting.find_by_category("Student")
          unless setting.nil?
          fine =  setting.fine_charged_per_day_after_due_date
          end
        end
      end
      if fine.nil?
      fine = 0
      end
      if @Booklibrary.due_date.to_date < Date.today
        gap = (Date.today - @Booklibrary.due_date.to_date).to_i
      end
      @totalfine = gap * fine
      if @totalfine != 0
        render '_fineinfo',:layout => false
      else
        render :text => "Fine Not Available"
      end
    else
      render :text => "Book Not Available"
    end

  end

  # GET /issue_book_records/1/edit
  def edit
    @issue_book_record = LibraryIssueBookRecord.find(params[:id])
  end

  # POST /issue_book_records
  # POST /issue_book_records.json
  def create
    @issue_book_record = LibraryIssueBookRecord.new(params[:issue_book_record])

    respond_to do |format|
      if @issue_book_record.save
        format.html { redirect_to @issue_book_record, notice: 'Issue book record was successfully created.' }
        format.json { render json: @issue_book_record, status: :created, location: @issue_book_record }
      else
        format.html { render action: "new" }
        format.json { render json: @issue_book_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issue_book_records/1
  # PUT /issue_book_records/1.json
  def update
    @issue_book_record = LibraryIssueBookRecord.find(params[:id])

    respond_to do |format|
      if @issue_book_record.update_attributes(params[:issue_book_record])
        format.html { redirect_to @issue_book_record, notice: 'Issue book record was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue_book_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_book_records/1
  # DELETE /issue_book_records/1.json
  def destroy
    @issue_book_record = LibraryIssueBookRecord.find(params[:id])
    @issue_book_record.destroy

    respond_to do |format|
      format.html { redirect_to issue_book_records_url }
      format.json { head :ok }
    end
  end

  def find_book
    @Book = LibraryBook.all

    responses = ""

    unless @Book.empty?
      @Book.each do |book|
        str = '{"key": "'+book.id.to_s+'", "value": "'+book.name+'"}'
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'

    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    puts response
    respond_to do |format|
      format.json { render :json => response}
    end
  end

  def find_student_employee

    persons = User.all

    responses = ""

    unless persons.empty?
      persons.each do |person|

        str = '{"key": "'+person.id.to_s+'", "value": "'+person.full_name+','+ person.username+'"}'
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'

    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    puts response
    respond_to do |format|
      format.json { render :json => response}
    end

  end

  def book_info
    @book = LibraryBook.find_by_id(params[:id])
    if @book.nil?
      render :text => "Book is not Available"
    else
      if @book.available_no_of_copies.to_i <= 0
        render :text => "All copies of books are issued"
      else
        render '_book_info',:layout => false
      end
    end
  end

  def person_info
    @user = User.find_by_id(params[:id])
    @Numderofbookstobeissued = 0
    @already_issue = 0
    @batch = ""
    if @user.nil?
      render :text => "Student/Employee is not Available"
    else
      @already_issue = LibraryIssueBookRecord.find(:all , :conditions => {:user_id => @user.id , :is_return => false}).count

      if @user.employee
        @type = "Employee"
        setting = LibrarySetting.find_by_category("Employee")
        unless setting.nil?
        @Numderofbookstobeissued =  setting.no_of_books_to_be_issued
        end

      else
        @type = "Student"
        setting = LibrarySetting.find_by_category("Student")
        unless setting.nil?
        @Numderofbookstobeissued =  setting.no_of_books_to_be_issued
        end
      @batch = @user.student_record.batch
      end

      @Avail = @Numderofbookstobeissued - @already_issue
      if @Avail <= 0

        render :text => "User has no book avail balance"

      else
        render '_person_info',:layout => false

      end

    end
  end

  def issue
    @Numderofdays = 0
    book = LibraryBook.find_by_id(params[:book])
    user = User.find_by_id(params[:person])
    avail = 0
    available = 0
    unless book.nil? || user.nil?
      if user.student
        setting = LibrarySetting.find_by_category("Student")
        unless setting.nil?
        @Numderofdays =  setting.default_no_of_days_for_issue
        end
        @book_issue = LibraryIssueBookRecord.new(:library_book_id => book.id,:user_id => user.id,:batch_id => user.student_record.batch_id,:is_return => false,:issue_date => Date.today ,:due_date =>Date.today+@Numderofdays.days  )
      else
        setting = LibrarySetting.find_by_category("Employee")
        unless setting.nil?
        @Numderofdays =  setting.default_no_of_days_for_issue
        end
        @book_issue = LibraryIssueBookRecord.new(:library_book_id => book.id,:user_id => user.id,:is_return => false,:issue_date => Date.today ,:due_date =>Date.today+@Numderofdays.days  )
      end
      if @book_issue.save
        available = book.available_no_of_copies.to_i
        if  available > 0
        avail =  available - 1

        end
        book.update_attributes(:available_no_of_copies => avail)
        flash[:notice] = "Book Issued Successfully"
        render :text => "Book Issue Successfuly"
      else
        error = @book_issue.error
        render :text => error
      end
    end

  end

  def return

  end

  def find_issue_book
    @Booklibrary = LibraryIssueBookRecord.find(:all , :conditions => {:is_return => false})

    responses = ""

    unless @Booklibrary.empty?
      @Booklibrary.each do |book|
        @book = LibraryBook.find_by_id(book.library_book_id)
        unless @book.nil?
          str = '{"key": "'+@book.id.to_s+'", "value": "'+@book.name+'"}'
        end
        if responses == ""
        responses = responses + str
        else
          responses = responses+","+str
        end
      end

    end
    response = '['+responses+']'

    # render :text =>  '{"key": "hello world", "value": "hello world"}'
    puts response
    respond_to do |format|
      format.json { render :json => response}
    end
  end

  def issued_book_info
    @book = LibraryBook.find_by_id(params[:id])
    render '_issued_book_info',:layout => false

  end

  def show_transaction
    start_date = params[:start_date]
    end_date = params[:end_date]
    @library_fees = LibraryIssueBookRecord.find(:all,:conditions => ["actual_return_date >= '#{start_date}' and actual_return_date <= '#{end_date}' and is_fine_paid = #{true}"])
  end

  def show_transaction_report

    @library_fees = []

    @start_date = params[:report][:start_date]
    @end_date = params[:report][:end_date]
    @library_fees = LibraryIssueBookRecord.find(:all,:conditions => ["issue_date >= '#{@start_date}' and issue_date <= '#{@end_date}'"])
  
  end

  def bookwisereport
     @library_fees = []
     @book = LibraryBook.find_by_id(params[:id])
     @library_fees = LibraryIssueBookRecord.find(:all,:conditions => {:library_book_id => params[:id]})
      puts @library_fees
      render '_bookwisereport',:layout => false
  end

  def person_issued_info
    @Booklibrary = LibraryIssueBookRecord.find(:all , :conditions => {:library_book_id => params[:id],:is_return => false})
    render '_issued_person_info',:layout => false
  end

  def book_return

    @Booklibrary = LibraryIssueBookRecord.find_by_id(params[:id])

    unless @Booklibrary.nil?
      user = User.find_by_id(@Booklibrary.user_id)
      totalfine = params[:actualamount]

      alreadyamount = params[:alreadyamount]
      if @Booklibrary.update_attributes(:is_return => true,:actual_return_date =>Date.today,:total_fine => alreadyamount,:actual_fine_paid =>totalfine ,:is_fine_paid => true)
        book = LibraryBook.find_by_id(@Booklibrary.library_book_id)

        unless book.nil?
          available = book.available_no_of_copies.to_i
          if  available > 0
          avail =  available + 1
          end
          book.update_attributes(:available_no_of_copies => avail)
        end

        render :text => "Book Return Successfuly"
      end
    else
      render :text => "Book is not available for return"
    end
  end

end
