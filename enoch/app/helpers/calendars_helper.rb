module CalendarsHelper
  class  DisplayDay
    attr_accessor :event_date,:current_date
    def initialize(  current_date ,eventDate) #sDate is of type Date
      @event_date = eventDate
      @current_date =  current_date 
    end
    
    def write_date
      @current_date.strftime('%d')
    end
  end
  
  class DisplayWeek
    attr_accessor :event_week, :week_index_in_month, :week_index_in_year
    def initialize(week_index, event_date,start_date)    

    end
  end
  
  class DisplayCalendar
    attr_accessor :display_weeks,:number_of_week_to_display
    
    def number_of_week_to_display (someDate)
      1 + someDate.end_of_month.strftime('%U').to_i - someDate.beginning_of_month.strftime('%U').to_i
     end
   end
   
   def get_event_title_to_display (event, dt, show_month )
    @a1 = []
    event.each do |current_event|
       (current_event.start_date.to_date..current_event.end_date.to_date).each do |d|   
        if d.strftime('%Y''-''%m''-''%d')== dt.to_time.strftime('%Y''-''%m''-''%d')
          @a1 << current_event
        end
    end
  
    end
      if @a1.count <= 3 
        @show=  @a1[0..@a1.count] 
        @hiddenEvent =  nil
      else
        @show =  @a1[0..2]
        @hiddenEvent =  @a1[3..@a1.count] 
      end

   end
   
end
