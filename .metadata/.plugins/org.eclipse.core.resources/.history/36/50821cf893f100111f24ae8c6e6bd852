class TeacherDiariesController < ApplicationController
  before_filter :login_required
  before_filter :protect_other_employee_data,:only => [:index,:show,:create,:view_my_diary_details]
  filter_access_to :all
  # GET /teacher_diaries
  # GET /teacher_diaries.json
  def index
    @days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"]
    @weeks = ["Ist Week" ,"2nd Week", "3rd Week" ,"4th Week","5th Week" ,"6th Week"]
    @date = Date.today.beginning_of_month
    @user = current_user
    @current_session = current_session.id
    @start_date = @date.beginning_of_month
    @end_date = @date.end_of_month
    @start_week = @start_date.strftime('%U').to_i
    @end_week =  @end_date.strftime('%U').to_i
    @techer = Employee.find_by_id(@user.employee_record.id)
    @class_timing = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    # @class_timing = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    @day = Weekday.default
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teacher_diaries }
    end
  end

  # GET /teacher_diaries/1
  # GET /teacher_diaries/1.json
  def show
    @days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"]
    @weeks = ["Ist Week" ,"2nd Week", "3rd Week" ,"4th Week","5th Week" ,"6th Week"]
    month = params[:month_id]
    current_year = Date.today.year
    @date = (current_year.to_s + "-" + month.to_s + "-" + "01").to_date
    @user = current_user
    @current_session = current_session.id
    @start_date = @date.beginning_of_month
    @end_date = @date.end_of_month
    @start_week = @start_date.strftime('%U').to_i
    @end_week =  @end_date.strftime('%U').to_i
    @techer = Employee.find_by_id(@user.employee_record.id)
     @class_timing = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    # @class_timing = ClassTiming.find(:all,:conditions => { :batch_id => nil}, :order =>'start_time ASC')
    @day = Weekday.default
    render :partial => 'show'
  end

  # GET /teacher_diaries/new
  # GET /teacher_diaries/new.json
  def new
    @employee = Employee.find(:all)
    @teacher_diary = TeacherDiary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @teacher_diary }
    end
  end

  # GET /teacher_diaries/1/edit
  def edit
    @teacher_diary = TeacherDiary.find(params[:id])
  end

  # POST /teacher_diaries
  # POST /teacher_diaries.json
  def create
    note_date = params[:teacher_diary][:date_id] unless params[:teacher_diary].nil?
    @user = current_user
    @current_session = current_session.id
    unless note_date.nil?
    note_date.each_with_index do |nd , i|
    @teacher_diary = TeacherDiary.new
    @teacher_diary.school_session_id = @current_session
    @teacher_diary.employee_id = @user.employee_record.id
    @teacher_diary.timing = "NULL"
    @teacher_diary.text_date = nd
    @teacher_diary.description = params[:teacher_diary][:description][i]
    newRecord = TeacherDiary.find_by_school_session_id_and_employee_id_and_text_date(@current_session,(@user.employee_record.id),nd)
      if newRecord.nil?
          unless @teacher_diary.save
            @error = true
          end
      else
          unless newRecord.update_attributes(:description => params[:teacher_diary][:description][i])
            @error = true
          end
      end
    end
    end
    respond_to do |format|
      if @error.nil?
        format.html { redirect_to @teacher_diary, notice: 'Teacher diary was successfully saved.' }
         format.json { render :json => {:valid => true, :teacher_diary => @teacher_diary, :notice => "Teacher diary was successfully saved."}}
      else
        format.html { render action: "new" }
        format.json { render :json => {:valid => false, :errors => @teacher_diary.errors}}
      end
    end
  end

  # PUT /teacher_diaries/1
  # PUT /teacher_diaries/1.json
  def update
    @teacher_diary = TeacherDiary.find(params[:id])

    respond_to do |format|
      if @teacher_diary.update_attributes(params[:teacher_diary])
        format.html { redirect_to @teacher_diary, notice: 'Teacher diary was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @teacher_diary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher_diaries/1
  # DELETE /teacher_diaries/1.json
  def destroy
    @teacher_diary = TeacherDiary.find(params[:id])
    @teacher_diary.destroy

    respond_to do |format|
      format.html { redirect_to teacher_diaries_url }
      format.json { head :ok }
    end
  end
  
  def view_diary
    @employee = Employee.find_by_id(params[:id])
    unless @employee.nil?
      if request.post?
        unless params[:start_date].to_date > params[:end_date].to_date 
          @diaries_detail = TeacherDiary.find_all_by_employee_id_and_school_session_id(params[:id],current_session.id, :conditions => ["date(text_date) BETWEEN ? AND ? ", "#{params[:start_date].to_date}","#{params[:end_date].to_date}"],:order => 'text_date DESC' )
        else
          @diary = TeacherDiary.new
          @error = true
          @diary.errors.add(:start_date , "can not be less than end date")
        end
        respond_to do |format|
            if @error.nil?
              format.html { redirect_to :action => 'view_diary', notice: 'Teacher diary was successfully updated.' }
              format.json  { render :json => {:html => render_to_string(:partial => 'view_diary.html.erb'), :valid => true}}
            else
              format.html { render action: "view_diary" ,notice: @diary.errors}
              format.json  { render :json => {:valid => false ,:errors => @diary.errors}}
            end
          end
      end
    else
      flash[:notice] = "Sorry, Employee record not found."
      redirect_to :controller =>'sessions', :action =>'dashboard' 
    end
  end
  
  def view_my_diary_details
    @employee = Employee.find_by_id(params[:id])
    unless @employee.nil?
      if request.post?
        unless params[:start_date].to_date > params[:end_date].to_date 
          @diaries_detail = TeacherDiary.find_all_by_employee_id(params[:id], :conditions => ["date(text_date) BETWEEN ? AND ? ", "#{params[:start_date].to_date}","#{params[:end_date].to_date}"],:order => 'text_date DESC' )
        else
          @diary = TeacherDiary.new
          @error = true
          @diary.errors.add(:start_date , "can not be less than end date")
        end
        respond_to do |format|
            if @error.nil?
              format.html { redirect_to :action => 'view_diary', notice: 'Teacher diary was successfully updated.' }
              format.json  { render :json => {:html => render_to_string(:partial => 'view_diary.html.erb'), :valid => true}}
            else
              format.html { render action: "view_diary" ,notice: @diary.errors}
              format.json  { render :json => {:valid => false ,:errors => @diary.errors}}
            end
          end
      end
    else
      flash[:notice] = "Sorry, Employee record not found."
      redirect_to :controller =>'sessions', :action =>'dashboard' 
    end

  end
  
  def view_pdf
    @employee = Employee.find_by_id(params[:id])
    @diaries_detail = TeacherDiary.find_all_by_employee_id_and_school_session_id(params[:id],current_session.id, :conditions => ["date(text_date) BETWEEN ? AND ? ", "#{params[:start_date].to_date}","#{params[:end_date].to_date}"],:order => 'text_date DESC' )
    render :pdf => 'view_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end  
end
