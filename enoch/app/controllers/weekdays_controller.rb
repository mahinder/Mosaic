class WeekdaysController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  def index
    @courses = Course.active
    @batches = []
    @weekdays = Weekday.default
    @day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @days = ["0", "1", "2", "3", "4", "5", "6"]
  end

  def week
    @weekdays = []
    @batch = nil
    @days = ["0", "1", "2", "3", "4", "5", "6"]
    @day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    if params[:batch_id] == ''
      @weekdays = Weekday.default
    else
      @weekdays = Weekday.for_batch(params[:batch_id])
      @b  = Batch.find params[:batch_id]
    end

    if @weekdays.empty?
      render "_empty",:layout => false
    else
      render "_weekdays",:layout => false
    end

  end

  def weekdays_modal
    @weekdays = []
    @batch = nil
    @days = ["0", "1", "2", "3", "4", "5", "6"]
    @day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    if params[:batch_id] == ''
      @weekdays = Weekday.default
    else
      @weekdays = Weekday.for_batch(params[:batch_id])
      @b  = Batch.find params[:batch_id]
    end

  end

  def batch
    @course = nil
    if params[:id] == ''
    @batches = []
    else
      @course = Course.find_by_id(params[:id])
    @batches = @course.batches.active
    end

    render "_batch",:layout => false
  end

  def create
   
    @day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    batch = params[:weekday][:batch_id]
        if request.post?
            new_weekdays = params[:weekdays]||[]
            batch = params[:weekday][:batch_id].empty??  nil:params[:weekday][:batch_id]
            old = Weekday.find_all_by_batch_id(batch)
            old_weekdays = old.map{|w| w.weekday}
            notice  = ""
                (new_weekdays-old_weekdays).each do |new|
                  Weekday.create(:batch_id =>batch, :weekday=>new.to_s)
                end
                  (old_weekdays-new_weekdays).each do |week|
                    weekday = Weekday.find_by_weekday(week.to_s,:conditions=>{:batch_id=>batch})
                    batches = batch.nil?? (Batch.active.reject {|b| !Weekday.for_batch(b.id).empty?} ): Batch.find_all_by_id(batch)
                    
                        batches.each do |b|
                          (Date.today.to_date..b.end_date.to_date).each do |d|
                                if d.wday.to_s == weekday.weekday.to_s
                                  period =PeriodEntry.find_all_by_month_date_and_batch_id(d,b.id)
                                  period.each do |p| p.destroy  end
                                end
                            end
                        end
                    weekday.destroy
                  end
                  notice = "Weekdays modified"
                  
             
       end
         # redirect_to :action => "index"
         respond_to do |format|
            format.json  { render :json => {:valid => true,:notice => notice } }
         end
 end


end
