class TransportFeeCollectionsController < ApplicationController
  before_filter :login_required
  # GET /transport_fee_collections
  # GET /transport_fee_collections.json
  def index
    @transport_fee_collections = TransportFeeCollection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transport_fee_collections }
    end
  end

  # GET /transport_fee_collections/1
  # GET /transport_fee_collections/1.json
  def show
    @transport_fee_collection = TransportFeeCollection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_fee_collection }
    end
  end

  # GET /transport_fee_collections/new
  # GET /transport_fee_collections/new.json
  def new
    @transport_fee_collection = TransportFeeCollection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_fee_collection }
    end
  end

  # GET /transport_fee_collections/1/edit
  def edit
    @transport_fee_collection = TransportFeeCollection.find(params[:id])
  end

  # POST /transport_fee_collections
  # POST /transport_fee_collections.json
  def create
   passengers=params[:transport_fee_collection][:passenger_id]
   type=params[:transport_fee_collection][:passenger_type]
    amounts=params[:transport_fee_collection][:amount]
     discounts=params[:transport_fee_collection][:discount]
     transport_fee_categories=params[:transport_fee_collection][:transport_fee_category_id]
     respond_to do |format|
     passengers.each_with_index do |passenger,index|
     @transport_fee_collection_exist=TransportFeeCollection.find_by_passenger_id(passenger)
     
           if @transport_fee_collection_exist.nil?
             puts "i am in no exits#{amounts[index]}"
            @transport_fee_collection = TransportFeeCollection.new(:passenger_id=>passenger,:amount=>amounts[index],:discount=>discounts[index],:transport_fee_category_id=>transport_fee_categories[index],:passenger_type=>type)
               @transport_fee_collection.transport_fee_collection_date=Date.today
                  unless @transport_fee_collection.save
                    @error=true
                    @errors=@transport_fee_collection.errors
                  else
                    @notice="Transport Fee Collection created successfuly"
                  end
            
          else
            
                 unless @transport_fee_collection_exist.update_attributes(:passenger_id=>passenger,:amount=>amounts[index],:discount=>discounts[index],:transport_fee_category_id=>transport_fee_categories[index],:passenger_type=>type)
                  @error=true
                   @errors=@transport_fee_collection_exist.errors
                  else
                  @notice="Transport Fee Collection updated successfuly"
                 end
                   
          end
          
      end
    
   if @error.nil?
        format.json { render :json => {:valid => true,:notice =>@notice }}
    else
        format.json { render :json => {:valid => false,:errors => @errors}}       
    end
     end
end
  # PUT /transport_fee_collections/1
  # PUT /transport_fee_collections/1.json
  def update
    
    @transport_fee_collection = TransportFeeCollection.find(params[:id])

    respond_to do |format|
      if @transport_fee_collection.update_attributes(params[:transport_fee_collection])
        format.html { redirect_to @transport_fee_collection, notice: 'Transport fee collection was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @transport_fee_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transport_fee_collections/1
  # DELETE /transport_fee_collections/1.json
  def destroy
    @transport_fee_collection = TransportFeeCollection.find(params[:id])
    @transport_fee_collection.destroy

    respond_to do |format|
      format.html { redirect_to transport_fee_collections_url }
      format.json { head :ok }
    end
  end
  
  def transport_fee_collection_pdf
    @transport_fee_collections=[]
    unless params[:department].nil?
    employees=Employee.find_all_by_employee_department_id(params[:department])
    employees.each do |employee|
      transport_fee_collection=TransportFeeCollection.find_by_passenger_id(employee.id)
     @transport_fee_collections<< transport_fee_collection unless transport_fee_collection.nil?
    end
    else
      students=Student.find_all_by_batch_id(params[:batch])
    students.each do |student|
     transport_fee_collection=TransportFeeCollection.find_by_passenger_id(student.id)
     @transport_fee_collections<< transport_fee_collection unless transport_fee_collection.nil?
    end
    end
    puts "the collectio is#{@transport_fee_collections.size}"
   render :pdf => 'transport_fee_collection_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 35,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end
  def transport_fee_report
   
    passenger_type=params[:passenger_type]
    transport_fee_category=params[:fee_category]
    @start_date=params[:date].to_date
    if passenger_type=="Select" && transport_fee_category==""
      @transport_fee_collections = TransportFeeCollection.find(:all,:conditions => ["transport_fee_collection_date >= '#{@start_date}' and transport_fee_collection_date <= '#{@start_date}'"])
   else if passenger_type=="Select" && transport_fee_category !=""
         @transport_fee_collections = TransportFeeCollection.find(:all,:conditions => ["transport_fee_collection_date >= '#{@start_date}' and transport_fee_collection_date <= '#{@start_date}' and transport_fee_category_id='#{transport_fee_category}'"])
     else if transport_fee_category==""
     @transport_fee_collections = TransportFeeCollection.find(:all,:conditions => ["transport_fee_collection_date >= '#{@start_date}' and transport_fee_collection_date <= '#{@start_date}' and passenger_type='#{passenger_type}'"])
     else                                                      
     @transport_fee_collections = TransportFeeCollection.find(:all,:conditions => ["transport_fee_collection_date >= '#{@start_date}' and transport_fee_collection_date <= '#{@start_date}' and passenger_type='#{passenger_type}' and transport_fee_category_id='#{transport_fee_category}'"])
    end
    end
    end
    render :partial=>"view_transport_collection_report"
  end
  
  
  
  def monthly_transport_fee_report
     @start_date=params[:start_date]
     @end_date=params[:end_date]
     @transport_fee_collections = TransportFeeCollection.find(:all,:conditions => ["transport_fee_collection_date >= '#{@start_date}' and transport_fee_collection_date <= '#{@end_date}'"])
  end
  
end
