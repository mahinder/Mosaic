class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :find_course, :only => [:show, :edit, :update, :destroy,:viewall]
  filter_access_to :all

  def index
   @users = []
   @course_for = params[:course_for]
   if @course_for == "montesary"
    @course_value = Course.find(:all, :conditions => { :is_deleted => false,:level => -3..5  }, :order => 'course_name asc')
    elsif @course_for == "primary"
     @course_value   = Course.find(:all, :conditions => { :is_deleted => false,:level => 6..10  }, :order => 'course_name asc')
    else 
      @course_value  = Course.find(:all, :conditions => { :is_deleted => false,:level => 11..20 }, :order => 'course_name asc')
   end
   unless @course_value.empty?
    @course_value.sort! { |a,b| a.level.to_i <=> b.level.to_i  }
   end 
   @class_timings = ClassTiming.default
   @privilege = Privilege.find_by_name("Teacher")
   unless @privilege.nil?
      @users = @privilege.users
      @teacher = []
      unless @users.empty?
          puts "Users .. #{@users}"
          @users.each do |user|
          @teacher << user.employee_record
         end
      end
   end
   respond_to do |format|
      format.html { render :layout => false } 
    end
  end

  def elective_skill
     @course_for = params[:course_for]
     @course = Course.find_by_id(params[:course_id])
     response = {:course_for => @course_for,:course => @course}
     respond_to do |format|
          format.html { render :layout => false } # index.html.erb
          format.json  { render :json => response }
        end
  end


  def all_record
    
    @teacher = []
    @users = []
    @montesary = Course.find(:all, :conditions => { :is_deleted => false,:level => -3..5  }, :order => 'course_name asc')
    @primary_courses = Course.find(:all, :conditions => { :is_deleted => false,:level => 6..10  }, :order => 'course_name asc')
    @high_school_courses  = Course.find(:all, :conditions => { :is_deleted => false,:level => 11..20 }, :order => 'course_name asc')
   unless @montesary.empty?
    @montesary.sort! { |a,b| a.level.to_i <=> b.level.to_i  }
   end 
   unless @primary_courses.empty?
    @primary_courses.sort! { |a,b| a.level.to_i <=> b.level.to_i  }
   end 
   unless @high_school_courses.empty?
    @high_school_courses.sort! { |a,b| a.level.to_i <=> b.level.to_i  }
   end 
   
    @course = Course.new
    @elective_skill = ElectiveSkill.new
    @skill = Skill.new
    @batch = Batch.new
    @class_timings = ClassTiming.default
    @privilege = Privilege.find_by_name("Teacher")
    unless @privilege.nil?
        @users = @privilege.users
        unless @users.empty?
          @users.each do |user|
          @teacher << user.employee_record
          end
        end
    end
    response = { 
    :montesary => @montesary, 
    :primary_courses => @primary_courses, 
    :high_school_courses => @high_school_courses , 
    :course => @course
    }

    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
    
  
  end

  def viewall
    @course_for = params[:course_for]
      respond_to do |format|
        format.html  { render :layout => false } 
        format.json { render :json => {:course => @course,:course_for => @course_for} }
      end
  end

  def view_skill
    @course = Course.find_by_id(params[:id])
    response = {:course => @course}
    respond_to do |format|
      format.html { render :layout => false } 
      format.json  { render :json => response }
    end
  end

  def add_course

  end

  def new
    @course_for =  params[:format]
    @course = Course.new
  end

  def manage_course
    @courses = Course.active
    @record_count = Course.active.count(:all)
    response = { :courses => @courses , :record_count => @record_count}
    respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => response }
    end
  end

  def manage_batches

  end

  def update_batch
    @batch = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })
    render(:update) do |page|
      page.replace_html 'update_batch', :partial=>'update_batch'
    end

  end
  
  def create
    @course_for = params[:course_value]
    @course = Course.new  params[:course]
    
    respond_to do |format|
      if @course.save
        format.html { redirect_to @courses, :course_value => @course_value, :course_for => @course_for}
        #format.json { render json: @employee_grade, status: :created, location: @employee_grade }
        format.json { render :json => {:valid => true,:course_for => @course_for,:course_id => @course.id }}
      else
        format.html { render action: "new" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @course.errors}}
      end
    end
  end

  def edit
  end

  def update
     respond_to do |format|
      if @course.update_attributes(params[:course])
         format.json { render :json => {:valid => true}}
      else
        format.html { render action: "edit" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @course.errors}}
     end
    end
  end

  def destroy
    if @course.batches.active.empty?
      @course.inactivate
      respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { render :json => {:valid => true,  :notice => "Course was deleted successfully!"}}
    end
    else
      respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { render :json => {:valid => false,:notice => "Course can not be deleted because of various dependencies "}}
    end
    end

  end

  def show
    puts @course
    @batches = @course.batches.active
    puts @batches
    @record_count = @batches.count(:all)
    response = {:batches => @batches , :record_count => @record_count}
    respond_to do |format|
    format.html # all.html.erb
    format.json  { render :json => response }
    end
  end

  private

  def find_course
    @course = Course.find params[:id]
   end

#  To be used once the new exam system is completed.
#
#  def email
#    @course = Course.find(params[:id])
#    if request.post?
#      recipient_list = []
#      case params['email']['recipients']
#      when 'Students'             then recipient_list << @course.student_email_list
#      when 'Guardians'            then recipient_list << @course.guardian_email_list
#      when 'Students & Guardians' then recipient_list += @course.student_email_list + @course.guardian_email_list
#      end
#
#      unless recipient_list.empty?
#        recipients = recipient_list.join(', ')
#        FedenaMailer::deliver_email(recipients, params[:email][:subject], params[:email][:message])
#        flash[:notice] = "Mail sent to #{recipients}"
#        redirect_to :controller => 'user', :action => 'dashboard'
#      end
#    end
#  end
#
#  def send_sms
#    @course = Course.find params[:id], :include => [:students]
#    if request.post?
#      sms = SmsManager.new params[:message], ['9656001824']
#      sms.send_sms
#      flash[:notice] = 'Text messages sent successfully!'
#    end
#  end

end