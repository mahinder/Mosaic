class SchoolConfigurationsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  FILE_EXTENSIONS = [".jpg",".jpeg",".png"]#,".gif",".png"]
  FILE_MAXIMUM_SIZE_FOR_FILE=3145728
  # def index
  # redirect_to :action => 'edit'
  # end

  # def edit
  # school = SchoolConfiguration.new
  # @school = SchoolConfiguration.get_multiple_configs_as_hash ['InstitutionName', 'InstitutionAddress', 'InstitutionPhoneNo', \
  # 'StudentAttendanceType', 'CurrencyType', 'ExamResultType', 'AdmissionNumberAutoIncrement','EmployeeNumberAutoIncrement', \
  # 'SmsEnabled','FinancialYearStartDate','FinancialYearEndDate']
  # @year = Date.today.year
  # @start_date = "01-04-"+@year.to_s
  # @end_date = "31-03-"+(@year + 1).to_s
  # end

  # def update
  #
  # unless params[:upload].nil?
  # @temp_file=params[:upload][:datafile]
  # unless FILE_EXTENSIONS.include?(File.extname(@temp_file.original_filename).downcase)
  # format.html { redirect_to action: "edit" }
  # # format.json { render :json => {:valid => false, notice: 'EmployeeGrade was successfully updated.'} }
  # end
  # if @temp_file.size > FILE_MAXIMUM_SIZE_FOR_FILE
  # format.html { redirect_to action: "edit" }
  # # format.json { render :json => {:valid => false, notice: 'File too large. File size should be less than 1 MB'} }
  # end
  # end
  # SchoolConfiguration.set_config_values(params[:schoolconfiguration])
  # SchoolConfiguration.save_institution_logo(params[:upl:class_timingoad]) unless params[:upload].nil?
  # # flash[:notice] = 'Settings has been saved'
  # # redirect_to :action => "edit"  and return
  # respond_to do |format|
  # format.html { redirect_to :action => "edit", notice: 'EmployeeGrade was successfully updated.' }
  # # format.json { render :json => {:valid => true, :notice => "Grade was updated successfully."} }
  # end
  #
  # end

  def settings
    @institute_start_time = SchoolConfiguration.find_by_config_key("ShiftStartTime").config_value;
    @institute_end_time   = SchoolConfiguration.find_by_config_key("ShiftEndTime").config_value;
    
    school = SchoolConfiguration.new
    @school = SchoolConfiguration.get_multiple_configs_as_hash ['InstitutionName', 'InstitutionAddress', 'InstitutionPhoneNo', \
      'StudentAttendanceType', 'CurrencyType', 'ExamResultType', 'AdmissionNumberAutoIncrement','EmployeeNumberAutoIncrement', \
      'SmsEnabled','FinancialYearStartDate','FinancialYearEndDate','ShiftStartTime','ShiftEndTime','OwnSiteUrl','BoardSiteUrl']
    @year = Date.today.year
    @start_date = "01-04-"+@year.to_s
    @end_date = "31-03-"+(@year + 1).to_s
    @start_time_institute = (@start_date+" "+@institute_start_time+" +0100").to_datetime
    @end_time_institute = (@start_date+" "+@institute_end_time+" +0100").to_datetime
    if request.post?
     
      @starttime = params[:class_timing]["start_time(4i)"] + ":"+ params[:class_timing]["start_time(5i)"]+":00"
      @endtime = params[:class_timing]["end_time(4i)"] + ":"+ params[:class_timing]["end_time(5i)"]+":00"
      reg_for_date = /^\d{2}\-\d{2}\-\d{4}$/
      numericReg_for_nomeric = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/
      characterReg = /^\s*[a-zA-Z,_,\-,\s]+\s*$/
      etime = Time.parse(@endtime)
      stime = Time.parse(@starttime)
      if etime <= stime
        flash[:notice_error] = 'End time should greater than start time'
        redirect_to :action => "settings"  and return
      elsif params[:schoolconfiguration][:institution_name] == ""
        flash[:notice_error] = 'Please Enter institute name'
        redirect_to :action => "settings"  and return
      elsif params[:schoolconfiguration][:institution_name] !~ characterReg
        flash[:notice_error] = 'Please Enter only characters for institute name'
        redirect_to :action => "settings"  and return
      elsif params[:schoolconfiguration][:financial_year_start_date]== "" || params[:schoolconfiguration][:financial_year_end_date] == ""
        flash[:notice_error] = 'Please Enter Academic dates'
        redirect_to :action => "settings"  and return
      else
        
        if params[:schoolconfiguration][:financial_year_start_date] =~ reg_for_date && params[:schoolconfiguration][:financial_year_end_date] =~ reg_for_date
          if params[:schoolconfiguration][:financial_year_start_date].to_date > params[:schoolconfiguration][:financial_year_end_date].to_date
            flash[:notice_error] = 'End date should be greater than start date'
            redirect_to :action => "settings"  and return
          else
           if params[:schoolconfiguration][:institution_phone_no] !~ numericReg_for_nomeric
              params[:schoolconfiguration][:institution_phone_no] = ""
           end
           
           params[:schoolconfiguration][:shift_start_time] = @starttime
            params[:schoolconfiguration][:shift_end_time] = @endtime
            unless params[:upload].nil?
              @temp_file=params[:upload][:datafile]
              unless FILE_EXTENSIONS.include?(File.extname(@temp_file.original_filename).downcase)
                flash[:notice_error] = 'Invalid Extention. Image must be .JPG'
                redirect_to :action => "settings"  and return
              end
              if @temp_file.size > FILE_MAXIMUM_SIZE_FOR_FILE
                flash[:notice_error] = 'File too large. File size should be less than 3 MB'
                redirect_to :action => "settings" and return
              end
            end
            SchoolConfiguration.set_config_values(params[:schoolconfiguration])
            SchoolConfiguration.save_institution_logo(params[:upload]) unless params[:upload].nil?

            flash[:notice] = 'Settings has been saved'
            redirect_to :action => "settings"  and return
          end
        else
          flash[:notice_error] = 'Please Enter valid dates'
          redirect_to :action => "settings"  and return
        end
      end
    end
  end

# def index
#
# end

  

end