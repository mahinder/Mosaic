class InstantFeeCollectionsController < ApplicationController
  before_filter :login_required
  # GET /instant_fee_collections
  # GET /instant_fee_collections.json
  def index
    @instant_fee_collections = InstantFeeCollection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @instant_fee_collections }
    end
  end

  # GET /instant_fee_collections/1
  # GET /instant_fee_collections/1.json
  def show
    @instant_fee_collection = InstantFeeCollectionDetail.find_all_by_instant_fee_collection_id(params[:collection_id])
    @name = params[:name]
    @instant_fee_collect = InstantFeeCollection.find(params[:collection_id])
    respond_to do |format|
      format.html { render :partial =>  'show' }
      format.json { render json: @instant_fee_collection }
    end
  end

  # GET /instant_fee_collections/new
  # GET /instant_fee_collections/new.json
  def new
    @instant_fee_collection = InstantFeeCollection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instant_fee_collection }
    end
  end

  # GET /instant_fee_collections/1/edit
  def edit
    @instant_fee_collection = InstantFeeCollection.find(params[:id])
  end

  # POST /instant_fee_collections
  # POST /instant_fee_collections.json
  def create
    @instant_fee_collection = InstantFeeCollection.new()
      if params[:person_type]=="Student"
          @payee = Student.find_by_id(params[:person_id])
      elsif params[:person_type]=="Employee"
          @payee = Employee.find_by_id(params[:person_id])
      end
    unless params.include?('is_custom')
    instant_fee_collection_detail1 = []
    instant_fee_collection_detail2 = []
    unless params[:checkedFee].nil?
      checked_fee = params[:checkedFee]
        checked_fee.each_with_index do |ins_fee, index|
           instant_fee_collection_detail1 << InstantFeeCollectionDetail.create(:instant_fee_particular_id => ins_fee,:particular_amount_provided => params[:checkedFeeAmount][index],:discount => params[:checkedFeeDiscount][index],:quantity=> ((params[:checkedFeeQuantity][index] unless params[:checkedFeeQuantity][index] == "") || 1))
        end
    end
    unless params[:instant_fee_collection][:particular_name].nil?
      paticular_name = params[:instant_fee_collection][:particular_name]
        paticular_name.each_with_index do |new_particular , i|
          instant_fees_particular = InstantFeeParticular.new
          instant_fees_particular.name = params[:instant_fee_collection][:particular_name][i]
          instant_fees_particular.description = params[:instant_fee_collection][:particular_name][i]
          instant_fees_particular.amount = params[:instant_fee_collection][:particular_amount][i]
          instant_fees_particular.instant_fee_id = params[:instant_fee_collection][:instant_fee_id]
          instant_fees_particular.is_deleted = false
          if instant_fees_particular.save
            instant_fee_collection_detail2 << InstantFeeCollectionDetail.create(:instant_fee_particular_id => instant_fees_particular.id,:particular_amount_provided => instant_fees_particular.amount,:discount => params[:instant_fee_collection][:particular_discount][i],:quantity=> ((params[:instant_fee_collection][:particular_quantity][i] unless  params[:instant_fee_collection][:particular_quantity][i] == "" )|| 1 ))
          end
        end
    end

    @instant_fee_collection.instant_fee_id = params[:instant_fee_collection][:instant_fee_id]
    if params[:person_type] == "Student"
      @instant_fee_collection.student_id = params[:person_id]
      @instant_fee_collection.is_guest = false
    elsif  params[:person_type] == "Employee"
      @instant_fee_collection.employee_id = params[:person_id]
      @instant_fee_collection.is_guest = false
    else
      @instant_fee_collection.is_guest = true
      @instant_fee_collection.name = params[:guest_name]
    end
    @instant_fee_collection.collection_date = Date.today
    @instant_fee_collection.amount = params[:total_amount].to_f
    respond_to do |format|
      if @instant_fee_collection.save
        instant_fee_collection_detail1.each do |ifcd1|
          ifcd1.update_attributes(:instant_fee_collection_id => @instant_fee_collection.id)
        end
        instant_fee_collection_detail2.each do |ifcd2|
          ifcd2.update_attributes(:instant_fee_collection_id => @instant_fee_collection.id)
        end
        @instant_fee_collection.update_attributes(:receipt_no => "IFC #{@instant_fee_collection.id}")
         format.html { redirect_to @instant_fee_collection, notice: 'Instant Fee Collection was successfully created.' }
         format.json { render :json => {:valid => true, :instant_fee_collection => @instant_fee_collection.id,:start_date => @instant_fee_collection.collection_date,:end_date => @instant_fee_collection.collection_date, :notice => "Instant Fee Collection was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @instant_fee_collection.errors}}
      end
    end
    else
      instant_fee_collection_detail = []
        unless params[:instant_fee_collection][:name].nil?
          @instant_fee = InstantFee.create(:name => params[:instant_fee_collection][:name],:description => params[:instant_fee_collection][:description],:school_session_id => current_session.id)
           unless params[:instant_fee_collection][:particular_name].nil?
              paticular_name = params[:instant_fee_collection][:particular_name]
              paticular_name.each_with_index do |new_particular , i|
                instant_fees_particular = InstantFeeParticular.new
                instant_fees_particular.name = params[:instant_fee_collection][:particular_name][i]
                instant_fees_particular.description = params[:instant_fee_collection][:particular_name][i]
                instant_fees_particular.amount = params[:instant_fee_collection][:particular_amount][i]
                instant_fees_particular.instant_fee_id = @instant_fee.id
                instant_fees_particular.is_deleted = false
                if instant_fees_particular.save
                  instant_fee_collection_detail << InstantFeeCollectionDetail.create(:instant_fee_particular_id => instant_fees_particular.id,:particular_amount_provided => instant_fees_particular.amount,:discount => params[:instant_fee_collection][:particular_discount][i],:quantity=> ((params[:instant_fee_collection][:particular_quantity][i] unless  params[:instant_fee_collection][:particular_quantity][i] == "" )|| 1 ))
                end
              end
           end
        end
        @instant_fee_collection.instant_fee_id = @instant_fee.id
        if params[:person_type] == "Student"
          @instant_fee_collection.student_id = params[:person_id]
          @instant_fee_collection.is_guest = false
        elsif  params[:person_type] == "Employee"
          @instant_fee_collection.employee_id = params[:person_id]
          @instant_fee_collection.is_guest = false
        else
          @instant_fee_collection.is_guest = true
          @instant_fee_collection.name = params[:guest_name]
        end
        @instant_fee_collection.collection_date = Date.today
        @instant_fee_collection.amount = params[:total_amount].to_f
    respond_to do |format|
      if @instant_fee_collection.save
        instant_fee_collection_detail.each do |ifcd|
          ifcd.update_attributes(:instant_fee_collection_id => @instant_fee_collection.id)
        end
        @instant_fee_collection.update_attributes(:receipt_no => "IFC #{@instant_fee_collection.id}")
        format.html { redirect_to @instant_fee_collection, notice: 'Instant Fee Collection was successfully created.' }
         format.json { render :json => {:valid => true, :instant_fee_collection => @instant_fee_collection.id,:start_date => @instant_fee_collection.collection_date,:end_date => @instant_fee_collection.collection_date, :notice => "Instant Fee Colection was successfully created."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @instant_fee_collection.errors}}
      end
    end 
    end
  end

  # PUT /instant_fee_collections/1
  # PUT /instant_fee_collections/1.json
  def update
    @instant_fee_collection = InstantFeeCollection.find(params[:id])

    respond_to do |format|
      if @instant_fee_collection.update_attributes(params[:instant_fee_collection])
        format.html { redirect_to @instant_fee_collection, notice: 'Instant fee Collection was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @instant_fee_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instant_fee_collections/1
  # DELETE /instant_fee_collections/1.json
  def destroy
    @instant_fee_collection = InstantFeeCollection.find(params[:id])
    @instant_fee_collection.destroy

    respond_to do |format|
      format.html { redirect_to instant_fee_collections_url }
      format.json { head :ok }
    end
  end
  
  def get_student_or_employee_data
    if params[:person_type] == "Student"
      @students = Student.find(:all,
          :conditions => "(first_name LIKE \"%#{params[:search]}%\"
                       OR middle_name LIKE \"%#{params[:search]}%\"
                       OR last_name LIKE \"%#{params[:search]}%\"
                       OR (concat(first_name, \" \", middle_name) LIKE \"#{params[:search]}%\")
                       OR (concat(first_name, \" \", last_name) LIKE \"#{params[:search]}%\")
                       OR (concat(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{params[:search]}%\")
                       OR admission_no LIKE  \"%#{params[:search]}%\")",
          :order => "batch_id asc,first_name asc") unless params[:search] == "" || params[:search].nil?
    elsif params[:person_type] == "Employee"
      @employees = Employee.find(:all,
          :conditions => "(first_name LIKE \"%#{params[:search]}%\"
                       OR middle_name LIKE \"%#{params[:search]}%\"
                       OR last_name LIKE \"%#{params[:search]}%\"
                       OR (concat(first_name, \" \", middle_name) LIKE \"#{params[:search]}%\")
                       OR (concat(first_name, \" \", last_name) LIKE \"#{params[:search]}%\")
                       OR (concat(first_name, \" \", middle_name, \" \", last_name) LIKE \"#{params[:search]}%\")
                       OR employee_number LIKE  \"%#{params[:search]}%\")",
          :order => "first_name asc") unless params[:search] == "" || params[:search].nil?
    else
      @search_data = []
    end
    render :partial => 'get_student_or_employee_data'
  end
  
  
  def get_partial_for_instant_fee_collection
      @intant_fees = InstantFee.find_all_by_school_session_id(current_session.id)
      unless params[:person_type]== "Guest"
          @person_id = params[:id]
          @unknown_person = User.find_by_id(params[:id])
          if @unknown_person.role_name == "Student"
            @person = @unknown_person.student_record unless @unknown_person.student_record.nil?
          else
            @person = @unknown_person.employee_record unless @unknown_person.employee_record.nil?
          end
      else
        
      end
    render :partial => 'get_partial_for_instant_fee_collection' 
  end
  
  def get_instant_fee_collection_table
    @instant_fees_particular = InstantFeeParticular.find_all_by_instant_fee_id(params[:id])
    @person_id = params[:person_id]
    unless @person_id=="Guest"
        @unknown_person = User.find_by_id(@person_id)
        if @unknown_person.role_name == "Student"
          @person = @unknown_person.student_record unless @unknown_person.student_record.nil?
        else
          @person = @unknown_person.employee_record unless @unknown_person.employee_record.nil?
        end
    end
    unless params[:id]== "Custom"
    render :partial => 'get_instant_fee_collection_table'
    else
    render :partial => 'custom'
    end 
  end
  
  def instant_fee_collection_receipt
    @start_date = params[:start_date]
    @end_date = params[:end_date]  
    @instant_fee_collection = InstantFeeCollectionDetail.find_all_by_instant_fee_collection_id(params[:collection_id])
    @instant_fee_collect = InstantFeeCollection.find(params[:collection_id])
    @name = @instant_fee_collect.receipt_no
    render :pdf => 'instant_fee_collection_receipt',
            :orientation => 'Landscape' ,:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30}, :status => 200,:disposition  => "attachment"
  end
end
