class FinanceDonationsController < ApplicationController
  # before_filter :login_required
 # filter_access_to :all
 
  def all_record
    @finance_donation = FinanceDonation.new
    response = { :finance_donation => @finance_donation}

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end

  def create
    @finance_donation = FinanceDonation.new(params[:finance_donation])
     respond_to do |format|
      if  @finance_donation.save
        format.html { redirect_to @finance_donation, notice: 'Donation accepted.' }
        format.json { render :json => {:valid => true, :finance_donation => @finance_donationn, :notice => 'Donation accepted.'}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @finance_donation.errors}}
      end
    end
  end

def index
  
end
def donation_list
    @start_date = (params[:start_date]).to_date
    @end_date = (params[:end_date]).to_date
    @donations = FinanceDonation.donation(@start_date,@end_date)
    render '_donation_list',:layout => false
  end 
  
  # DELETE /incomes/1
  def destroy
     @donation = FinanceDonation.find(params[:id])
    @transaction = FinanceTransaction.find(@donation.transaction_id)
    if  @donation.destroy
      @transaction.destroy
        respond_to do |format|
          format.html { redirect_to incomes_url }
          format.json { render :json => {:valid => true,  :notice => "Donation was deleted successfully."}}
        end
    end
  end      

def show
    
  end
end
