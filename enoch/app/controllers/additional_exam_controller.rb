

class AdditionalExamController < ApplicationController
 before_filter :login_required
 before_filter :protect_other_student_data
 before_filter :protect_other_student_id, :only => [:generated_report]
  # filter_access_to :all
 include SmsManagerHelper 
respond_to :html, :xml, :json

  def update_exam_form
  
  @date = Time.now
    @batch = Batch.find(params[:batch])
    @name = params[:exam_option][:name]
    @type = params[:exam_option][:exam_type]

    unless @name == ''
      @additional_exam_group = AdditionalExamGroup.new
      @normal_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=> {:no_exams=> false,:elective_group_id => nil, :is_deleted => false} )
      @elective_subjects = []
      elective_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=> {:no_exams=> false,:elective_group_id => !nil, :is_deleted => false} )
      elective_subjects.each do |e|
        is_assigned = StudentsSubject.find_all_by_subject_id(e.id)
        unless is_assigned.empty?
        @elective_subjects.push e
        end
      end
      @all_subjects = @normal_subjects+@elective_subjects
      @all_subjects.each { |subject| 
        subject.topics.each do |topic| 
        @additional_exam_group.additional_exams.build(:subject_id => subject.id,:topic_id=>topic.id) 
        end
        }

 

      @students_list = ""
      for student in params[:students_list]
        @students_list += student + ","
      end unless params[:students_list].nil?
      if @type == 'Marks' 
        @exam_group_marks_type = ExamGroup.find_all_by_batch_id(@batch.id,:conditions =>{:exam_type=>'Marks'})
        render :partial=>'exam_marks_form'
     end
    if  @type == 'MarksAndGrades'
       @exam_group_mark_grades_type = ExamGroup.find_all_by_batch_id(@batch.id,:conditions =>{:exam_type=>'MarksAndGrades'})
      render :partial=>'exam_marks_form'
    end
        if @type == 'Grades' || @type == 'Custom'
       @exam_group = ExamGroup.find_all_by_batch_id(@batch.id,:conditions =>{:exam_type=>'Grades' })
        render :partial=>'exam_grade_form'
     end

    else
      render :text=>'<div class="errorExplanation"><p>Exam name can\'t be blank</p></div>'
      
    end
  end

  def publish
    @additional_exam_group = AdditionalExamGroup.find(params[:id])
    @additional_exams = @additional_exam_group.additional_exams
    @batch =  @additional_exam_group.batch
    @sms_setting_notice = ""
    @no_exam_notice = ""
    if params[:status] == "schedule"
      students = @additional_exam_group.students
      unless students.empty?
        @sent_to = ""
        students.each do |b|
          if @sent_to == ""
          @sent_to = @sent_to + b.full_name
          else
            @sent_to = @sent_to+","+ b.full_name
          end
        end
      end

      logger.info "sent to student#{ @sent_to }"

      reminder = Reminder.create(:sender=> current_user.id,:sent_to => @sent_to, :subject=>"Additional Exam Scheduled", :body=>"#{@additional_exam_group.name} has been scheduled  <br/> Please view calendar for more details")
      students.each do |s|
        student_user = s.user
        unless student_user.nil?
        ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
      end
       end

    end
    unless @additional_exams.empty?
      AdditionalExamGroup.update( @additional_exam_group.id,:is_published=>true) if params[:status] == "schedule"
      AdditionalExamGroup.update( @additional_exam_group.id,:result_published=>true) if params[:status] == "result"
      sms_setting = SmsSetting.new()
      
      if sms_setting.application_sms_active and sms_setting.exam_result_schedule_sms_active
        students = @additional_exam_group.students
        recipients = nil
        students.each do |s|
          guardian = s.immediate_contact

           if s.is_sms_enabled
            unless guardian.nil? || guardian.mobile_phone.nil?
                puts guardian.mobile_phone
                  recipients =  sms_setting.create_recipient(guardian.mobile_phone,recipients)
            else
              unless s.phone2.nil?
                recipients =  sms_setting.create_recipient(s.phone2,recipients)
              end
            end
              @message = "Dear Parent, Exam  #{@additional_exam_group.assessment_name.name unless @additional_exam_group.assessment_name.nil?} has been scheduled on #{@additional_exam_group.exam_date}. Regards MCSCHD" if params[:status] == "schedule"
              @message = "Dear Parent, Result has been published for exam #{@additional_exam_group.assessment_name.name unless @additional_exam_group.assessment_name.nil?}. Regards MCSCHD" if params[:status] == "result"
          end
        end
        response =  sms_setting.send_sms(@message,recipients)
        if response == "something went worng"
           flash[:warn_notice] = "sms can't be send due some error in sms service"
       end
      else
        # @conf = SchoolConfiguration.available_modules
        # if @conf.include?('SMS')
          @conf = SchoolConfiguration.find_by_config_key('SmsEnabled')
              if @conf.config_value == "0"
              @sms_setting_notice = "Exam schedule published, No sms was sent as Sms setting was not activated" if params[:status] == "schedule"
              @sms_setting_notice = "Exam result published, No sms was sent as Sms setting was not activated" if params[:status] == "result"
        else
              @sms_setting_notice = "Exam schedule published" if params[:status] == "schedule"
              @sms_setting_notice = "Exam result published" if params[:status] == "result"
        end
      end
      if params[:status] == "result"
        students = @additional_exam_group.students
        unless students.empty?
        @sent_to = ""
        students.each do |b|
          if @sent_to == ""
            @sent_to = @sent_to + b.full_name
          else
            @sent_to = @sent_to+","+ b.full_name
          end
        end
      end
         logger.info "sent to student#{ @sent_to }"
          reminder = Reminder.create(:sender=> current_user.id,:sent_to => @sent_to, :subject=>"Result Published", :body=>"#{@additional_exam_group.name} result has been published  <br/> Please view calendar for more details")
      students.each do |s|
        student_user = s.user
        unless student_user.nil?
        ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
      end
       end
         
      end
    else
      @no_exam_notice = "Exam scheduling not done yet."
    end
    redirect_to :controller =>'additional_exam_groups',:action =>'index',:batch_id =>@batch
  end

  def create_additional_exam
       
    @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batches = employee_batches(@employee)

    @course= Course.active
    @batch = []
  end

  def update_batch
    @batch = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false})
    render :partial=>'update_batch'
    

  end
  def show
    @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id], :include => :batch)
    @batch = @additional_exam_group.batch
    @course = @batch.course
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    additional_exam_subject = Subject.find(@additional_exam.subject_id)

    @students = @additional_exam.additional_exam_group.students
   
    unless  additional_exam_subject.elective_group_id.nil?
      assigned_students_subject = StudentsSubject.find_all_by_subject_id(additional_exam_subject.id)
      assigned_students=       assigned_students_subject .map{|s| s.student}
      assigned_students_with_exam=assigned_students&@students
      @students= assigned_students_with_exam
    end
    @config = SchoolConfiguration.get_config_value('ExamResultType') || 'Marks'
    unless @additional_exam_group.exam_group.nil?
    
 grading_level_group = @additional_exam_group.exam_group.grading_level_group
 unless grading_level_group.nil?
   grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(grading_level_group.id) 
    @grades = grading_level_details
  else
    @grades=GradingLevelDetail.find_all_by_grading_level_group_id(1)
  end
    else
    
      @grades=GradingLevelDetail.find_all_by_grading_level_group_id(1)
    end
   
  end
  
  def save_additional_scores
  
    @error= false
    @additional_exam = AdditionalExam.find(params[:id])
    @additional_exam_group = @additional_exam.additional_exam_group
    unless @additional_exam_group.exam_group.nil?
    exam_id = Exam.find_by_exam_group_id_and_subject_id(@additional_exam_group.exam_group.id,@additional_exam.subject.id)
    end
    params[:additional_exam].each_pair do |student_id, details|
      @exam_score = ExamScore.find(:first, :conditions => {:exam_id => exam_id, :student_id => student_id} )
      @additional_exam_score = AdditionalExamScore.find(:first, :conditions => {:additional_exam_id => @additional_exam.id, :student_id => student_id} )
   
      if @additional_exam_score.nil?
       
          if details[:marks].to_f <= @additional_exam.maximum_marks.to_f
                AdditionalExamScore.create do |score|
                score.additional_exam_id          = @additional_exam.id
                score.student_id       = student_id
                score.marks            = details[:marks]
                score.grading_level_detail_id = details[:grading_level_detail_id]
                score.remarks          = details[:remarks]
                score.custom          = details[:custom]
              end
                unless @exam_score.nil?
                  @exam_score.update_attributes(details)
                end
               else
                @error= true
              end
      else
       
       if details[:marks].to_f <= @additional_exam.maximum_marks.to_f
         
        @additional_exam_score.update_attributes(details)
        unless @exam_score.nil?
          @exam_score.update_attributes(details)
        end
         else
          @error= true 
   
        end
      end
    end
    flash[:warn_notice] = 'Exam score exceeds Maximum Mark.' if @error == true
    flash[:notice] = 'Exam scores updated.' if @error == false
    redirect_to :action => 'show',:additional_exam_group_id=> @additional_exam_group,:id => @additional_exam
  end
  
   def edit
    
     @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id], :include => :batch)
    @batch = @additional_exam_group.batch
    @course = @batch.course
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    @subjects = @additional_exam_group.batch.subjects
  end

 def update_additional_exam
   
     @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id], :include => :batch)
    @batch = @additional_exam_group.batch
    @course = @batch.course
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    @subjects = @additional_exam_group.batch.subjects

    if @additional_exam.update_attributes(params[:additional_exam])
      flash[:notice] = 'Updated additional exam details successfully.'
     redirect_to :controller=>'additional_exam', :action => 'show', :id => @additional_exam,:additional_exam_group_id => @additional_exam_group
    else
      @errors = @additional_exam.errors.full_messages
             @err_count = @additional_exam.errors.count
      render 'edit'
    end
  end
  
  def destroy_additional_exam
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    batch_id = @additional_exam.additional_exam_group.batch_id
    batch_event = BatchEvent.find_by_event_id_and_batch_id(@additional_exam.event_id,batch_id)
    event = Event.find(@additional_exam.event_id)
    if @additional_exam.destroy
      event.destroy
      batch_event.destroy
    end
   respond_to do |format|
      format.html # all.html.erb
      format.json  { render :json => {:valid => true} }
  end
  end
  #REPORTS
  def additional_exam_report
      @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batch = employee_batches(@employee)
    @courses = Course.active
    @batches = []
    @additional_exam_group =[]
    # @batches = Batch.active
    @subjects = []
  end
  def update_additional_exam_batch
    @batch = Batch.find_all_by_course_id(params[:batch_id], :conditions => { :is_deleted => false})
  render :layout =>false 
    end
    def get_additional_exam
    @additional_exam_groups = AdditionalExamGroup.find_all_by_batch_id(params[:batch_id])
    render :layout =>false 
    end
    def view_additional_exam_group_report
    
  @additional_exam_group = AdditionalExamGroup.find params[:additional_exam][:g_group_id]
   @student_list = @additional_exam_group.students_list.split(',')

        @batch = Batch.find params[:additional_exam_group_batch][:id]
      @subject =[]
      @additional_exam = @additional_exam_group.additional_exams
      
    @additional_exam_group.additional_exams.each do |subject|
       @subject << subject.subject.name
     end
  
    end
    def view_additional_exam_group_report_pdf
    @config = SchoolConfiguration.get_config_value('InstitutionName')
    @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group])
    @batch = Batch.find(params[:batch])
    @students = @batch.students
    render :pdf => 'generated_report_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  # respond_to do |format|
  # format.pdf { render :layout => 'application',:pdf => 'generated_report_pdf'}
  # end
  end
    def generated_report
       
       @student = Student.find(params[:student_id])
        @batch = @student.batch
      @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id])
      @subject =[]
      @additional_exam = @additional_exam_group.additional_exams
    @additional_exam_group.additional_exams.each do |subject|
       @subject << subject.subject.name
     end
  end
  def jasper_report
    @exam=AdditionalExam.find(:all)
    render :xml => {:first_name=>'Sunil',:last_name=>'Kumar',:address=>'Chandigarh'}
client = JasperServer::Client.new("http://example.com/jasperserver/services/repository",
                                  "jasperadmin", "secret!")
 request = JasperServer::Request.new("/additional_exam/jasper_report", "PDF", {'fruit' => 'apple'})    
  end
end

