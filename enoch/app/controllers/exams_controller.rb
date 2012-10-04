class ExamsController < ApplicationController
  before_filter :login_required
  # before_filter :query_data
  before_filter :protect_other_student_data
  # before_filter :restrict_employees_from_exam
  before_filter :protect_other_student_id, :only => [:generated_report,:generated_report3,:generated_report5,:generated_student_report4,:previous_years_marks_overviews,:previous_years_marks_overview]
  filter_access_to :all
  include SmsManagerHelper
  # GET /exams
  # GET /exams.json
  def index
    @exams = Exam.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exams }
    end
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
    @exam_group = ExamGroup.find(params[:exam_group_id], :include => :batch)
    grading_level_group = @exam_group.grading_level_group
    grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(grading_level_group.id) unless grading_level_group.nil?
    @batch = @exam_group.batch
    @employee_subjects=[]
    @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id} if @current_user.employee?
    @exam = Exam.find params[:id], :include => :exam_group
    unless @employee_subjects.include?("#{@exam.subject_id}") or @current_user.admin? or @current_user.privileges.map{|p| p.id}.include?(1) or @current_user.privileges.map{|p| p.id}.include?(2)
      flash[:notice] = 'Access Denied.'
      redirect_to :controller=>"session", :action=>"dashboard"
    end
    exam_subject = Subject.find(@exam.subject_id)
    is_elective = exam_subject.elective_group_id
    if is_elective == nil
    @students = @batch.students
    else
      assigned_students = StudentsSubject.find_all_by_subject_id(exam_subject.id)
      @students = []
      assigned_students.each do |s|
        student = Student.find_by_id(s.student_id)
        @students.push student unless student.nil?
      end
    end
    @config = SchoolConfiguration.get_config_value('ExamResultType') || 'Marks'
    grading_level_group = @exam_group.grading_level_group
    unless grading_level_group.nil?
      grading_level_details = GradingLevelDetail.find_all_by_grading_level_group_id(grading_level_group.id)

    @grades = grading_level_details
    else
      @grades=GradingLevelDetail.find_all_by_grading_level_group_id(1)
    end
  end

  # GET /exams/new
  # GET /exams/new.json
  def new
    @exam = Exam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exam }
    end
  end

  # GET /exams/1/edit
  def edit

    @exam = Exam.find params[:id],:include => :exam_group
    @exam_group = ExamGroup.find(params[:exam_group_id], :include => :batch)
    @batch = @exam_group.batch
    @course = @batch.course
    @subjects = @exam_group.batch.subjects
    if @current_user.employee?  and !@current_user.privileges.map{|m| m.id}.include?(Privilege.find_by_name('ExaminationControl'))
      @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      unless @subjects.map{|m| m.id}.include?(@exam.subject_id)
        flash[:notice] = "Sorry, you are not allowed to access that page."
        redirect_to [@batch, @exam_group]
      end
    end
  end

  # POST /exams
  # POST /exams.json
  def create

    @exam = Exam.new(params[:exams])

    respond_to do |format|
      if @exam.save
        format.html { redirect_to @exam, notice: 'Exam was successfully created.' }
        format.json { render json: @exam, status: :created, location: @exam }
      else
        format.html { render action: "new" }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exams/1
  # PUT /exams/1.json
  def update_exam

    @exam = Exam.find params[:id], :include => :exam_group
    @exam_group = ExamGroup.find(params[:exam_group_id], :include => :batch)
    @batch = @exam_group.batch
    @course = @batch.course
    if @exam.update_attributes(params[:exam])
      flash[:notice] = 'Updated exam details successfully.'
      redirect_to :controller=>'exams', :action => 'show', :id => @exam,:exam_group_id => @exam_group
    else
      @subjects = @batch.subjects
      if @current_user.employee? and  !@current_user.privileges.map{|m| m.id}.include?(Privilege.find_by_name('ExaminationControl').id)
        @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      end
      @errors = @exam.errors.full_messages
      @err_count = @exam.errors.count
      render 'edit'
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy_exam

    @exam = Exam.find params[:id], :include => :exam_group
    if @current_user.employee?  and !@current_user.privileges.map{|m| m.id}.include?(Privilege.find_by_name('ExaminationControl').id)
      @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      unless @subjects.map{|m| m.id}.include?(@exam.subject_id)
        flash[:notice] = "Sorry, you are not allowed to access that page."
        redirect_to [@batch, @exam_group] and return
      end
    end
    respond_to do |format|
      if @exam.destroy
        batch_id = @exam.exam_group.batch_id
        batch_event = BatchEvent.find_by_event_id_and_batch_id(@exam.event_id,batch_id)
        event = Event.find(@exam.event_id)
        event.destroy
        batch_event.destroy
        format.html # all.html.erb
        format.json  { render :json => {:valid => true} }
      else
        format.html # all.html.erb
        format.json  { render :json => {:valid => false,:errors =>@exam.errors.count} }
      end
    end
  end

  def create_exam

    @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batch = employee_batches(@employee)

    @course= Course.active
    @batches =[]
  end

  def update_batch
    @batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render :partial=>'update_batch'

  end

  def update_exam_form

    @batch = Batch.find(params[:batch])
    @assessment_name=params[:exam_option][:name]
    @term_id=params[:exam_option][:term_id]
    @term=TermMaster.find_by_id(@term_id).name
    @name =AssessmentName.find_by_id(@assessment_name).name
    @course = @batch.course
    @date = Time.zone.parse(Time.now.to_s).utc + 5.hour + 30.minutes
    @type = params[:exam_option][:exam_type]

    unless @name == ''
      @exam_group = ExamGroup.new
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
        logger.info "subject name#{subject.name}"
        subject.topics.each do |topic|
          @exam_group.exams.build(:subject_id => subject.id,:topic_id=>topic.id)
        end
      }
      if @type == 'Marks'
        render :partial => "exam_marks_form"
      end
      if  @type == 'MarksAndGrades'

        @grading_groups = GradingLevelGroup.find(:all,:conditions=>{:is_active=>true})
        render :partial => "exam_marks_form"
      end
      if @type == 'Grades' || @type == 'Custom'
        @grading_groups = GradingLevelGroup.find(:all,:conditions=>{:is_active=>true})
        render :partial => "exam_grade_form"
      end

    else
      render :text=>'<div class="errorExplanation"><p>Exam name can\'t be blank</p></div>'

    end
  end

  def publish

    @exam_group = ExamGroup.find(params[:id])
    @exams = @exam_group.exams
    @batch = @exam_group.batch
    @sms_setting_notice = ""
    @no_exam_notice = ""

    if params[:status] == "schedule"
      students = @batch.students
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

      reminder = Reminder.create(:sender=> current_user.id,:sent_to => @sent_to, :subject=>"#{t('exam_scheduled')}", :body=>"#{@exam_group.assessment_name.name} #{t('has_been_scheduled')}  <br/> #{t('view_calendar')}")
      students.each do |s|
        student_user = s.user
        ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
      end

    end
    unless @exams.empty?
      ExamGroup.update(@exam_group.id,:is_published=>true) if params[:status] == "schedule"
      ExamGroup.update(@exam_group.id,:result_published=>true) if params[:status] == "result"
      sms_setting = SmsSetting.new()
      if sms_setting.application_sms_active and sms_setting.exam_result_schedule_sms_active
        students = @batch.students
        unless students.empty?
           recipients = nil
          students.each do |s|
            puts s.immediate_contact
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
              @message = "Dear Parent, Exam  #{@exam_group.assessment_name.name unless @exam_group.assessment_name.nil?} has been scheduled on #{@exam_group.exam_date}. Regards MCSCHD" if params[:status] == "schedule"
              @message = "Dear Parent, Result has been published for exam #{@exam_group.assessment_name.name unless @exam_group.assessment_name.nil?}. Regards MCSCHD" if params[:status] == "result"
            end
          end
        end
        
       response =  sms_setting.send_sms(@message,recipients)
       if response == "something went worng"
           flash[:warn_notice] = "sms can't be send due some error in sms service"
       end
       
      else
      # @conf = SchoolConfiguration.available_modules

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
        @sent_to = ""
        students = @batch.students
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
        reminder = Reminder.create(:sender=> current_user.id,:sent_to => @sent_to,:subject=>"Result Scheduled", :body=>"#{@exam_group.assessment_name.name}result has been scheduled  <br/> Please view reports for your result")
        students.each do |s|
          student_user = s.user
          ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
        end
      end
    else
      @no_exam_notice = "Exam scheduling not done yet."
    end
    redirect_to :controller => 'exam_groups', :action => 'index',:batch_id => @batch.id
  end

  def save_scores
    
    @exam = Exam.find(params[:id])
    @exam_group = @exam.exam_group
     unless  !params[:exam]
           @error= false
            params[:exam].each_pair do |student_id, details|
                @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => student_id} )
                if @exam_score.nil?
                    if details[:marks].to_f <= @exam.maximum_marks.to_f
                          ExamScore.create do |score|
                            score.exam_id          = @exam.id
                            score.student_id       = student_id
                            score.marks            = details[:marks]
                            score.grading_level_detail_id = details[:grading_level_detail_id]
                            score.remarks          = details[:remarks]
                            score.custom          = details[:custom]
                          end
                    else
                         @error = true
                    end
                else
                      if details[:marks].to_f <= @exam.maximum_marks.to_f
                            Audit.as_user(@exam_score) do
                              @exam_score.audit_comment ="exam score"
                            end
                        @exam_score.update_attributes(details)
                      else
                      @error = true
                      end
                end
          end
   else
    @error="empty"
   end
    
  
   flash[:warn_notice] = 'Sorry Student Record not found.' if @error == "empty"
    flash[:warn_notice] = 'Exam score exceeds Maximum Mark.' if @error == true
    flash[:notice] = 'Exam scores updated.' if @error == false
    redirect_to :action => 'show',:exam_group_id=> @exam_group,:id => @exam
  end

  def grouping
    
    @grading_level_group=GradingLevelGroup.find(:all,:conditions=>{:is_active=>true})
    @assessment_mode=params[:assessment_mode]
    @grouped_name = GroupedExam.find_by_id(params[:grouped_exam_id])
    @batch = Batch.find(params[:id])
    @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id,:conditions=>{:exam_type =>params[:filter]})
    render :layout=>false

  end

  def new_grouping_assessment
    
    @batch = Batch.find(params[:id])
    # unless params[:exam_grouping].nil?
    name = params[:exam_grouping][:grouped_exam_name]
    gexam =  GroupedExam.find_by_batch_id_and_grouped_exam_name(@batch.id,name)
    if gexam.nil?
      unless params[:exam_grouping][:exam_group_ids].nil?
        # # GroupedExam.delete_all(:batch_id=>@batch.id)
        exam_group_ids = params[:exam_grouping][:exam_group_ids]
        name = params[:exam_grouping][:grouped_exam_name]
        grading_level_group_id=params[:exam_grouping][:grading_level_group_id]
        unless params[:exam_grouping][:weightage].nil?
          weightage = params[:exam_grouping][:weightage]
          g = 0
          weightage.delete("")
          @grid = GroupedExam.create(:batch_id=>@batch.id,:grouped_exam_name =>name,:grading_level_group_id=>grading_level_group_id)
          exam_group_ids.each_with_index do |e,i|
            weightage.each_with_index do |w,j|
              logger.info "i is #{i} and j is #{j}"
              if i==j
                g= g + w.to_f
                if g < 100 or g==100
                  logger.info "weightage for is #{ w }"
                  ConnectExam.create(:exam_group_id =>e,:grouped_exam_id => @grid.id, :weightage => w.to_f)
                  flash[:warn_notice] = nil
                  flash[:notice]="Selected exam grouped successfully created."
                else
                  flash[:notice] = nil
                  flash[:warn_notice] = "Sum of Weightage must be equal or less than 100"
                end
              end
            end
          end
        # redirect_to :controller =>'exam_groups',:action =>'index',:batch_id=>@batch.id
        else
          grading_level_group_id=params[:exam_grouping][:grading_level_group_id]
          grid = GroupedExam.create(:batch_id=>@batch.id,:grouped_exam_name =>name,:grading_level_group_id=>grading_level_group_id)
          exam_group_ids.each_with_index do |e,i|
            @connect_exam=ConnectExam.new
            @connect_exam.exam_group_id=e
            @connect_exam.grouped_exam_id=grid.id
            if @connect_exam.save
              flash[:notice]="Selected exam grouped successfully created."
            end
          end
        end
      end
    end
    redirect_to :controller =>'exam_groups',:action =>'index',:batch_id=>@batch.id
  end

  def edit_grouping

    @exam_groups=[]
    @grouped_name = GroupedExam.find_by_id(params[:grouped_exam_id])
    @batch = Batch.find_by_id(params[:id])
    ConnectExam.find_all_by_grouped_exam_id(@grouped_name.id).each do |connect_exam|
    @exam_groups << ExamGroup.find_by_id(connect_exam.exam_group_id)
    end
    if request.post?
      @grouped_exam=GroupedExam.find_by_id(params[:grouped_exam_id])
      unless params[:exam_grouping][:exam_group_ids].nil?
        exam_group_ids = params[:exam_grouping][:exam_group_ids]
        name = params[:exam_grouping][:grouped_exam_name]
        unless params[:exam_grouping][:weightage].nil?
          weightage = params[:exam_grouping][:weightage]
          g = 0
          weightage.delete("")
          exam_group_ids.each_with_index do |e,i|
            weightage.each_with_index do |w,j|
              logger.info "i is #{i} and j is #{j}"
              if i==j
                logger.info "i= #{i} and #{e} && j=  #{j} and #{w}"
                g= g + w.to_f
                logger.info "g is #{g}"
                if g < 100 or g==100
                  @grouped_exam.update_attributes(:batch_id=>@batch.id,:grouped_exam_name =>name)
                  exam_group_ids.each_with_index do |e,i|
                    weightage.each_with_index do |w,j|
                      if i==j
                        logger.info "weightage for is #{ w }"

                        connect_exam = ConnectExam.find_by_exam_group_id_and_grouped_exam_id(e,@grouped_exam.id)

                        connect_exam.update_attributes(:exam_group_id =>e,:grouped_exam_id => @grouped_exam.id, :weightage => w.to_f)
                      end
                    end
                  end
                end
              end
            end
          end
        else
          update_grouped_exam=GroupedExam.find_by_id(params[:grouped_exam_id])
           update_grouped_exam.update_attributes(:batch_id=>@batch.id,:grouped_exam_name =>name)
          exam_group_ids.each_with_index do |e,i|
            connect_exam = ConnectExam.find_by_exam_group_id_and_grouped_exam_id(e,update_grouped_exam.id)
            connect_exam.update_attributes(:exam_group_id =>e,:grouped_exam_id => update_grouped_exam.id)
            
          end
        end

      end
      if @error.nil?
        flash[:warn_notice] = nil
        flash[:notice]="exams grouped updated successfully."
        redirect_to :action=>'view_grouping',:id=>params[:id]
      else
        flash[:notice] = nil
        flash[:warn_notice] = "Sum of Weightage must be less than or equal to 100"
        redirect_to :action=>'view_grouping',:id=>params[:id]
      end
    end
  end

  def view_grouping

    @batch = Batch.find_by_id(params[:id])
    @grouped_exams= GroupedExam.find_all_by_batch_id(@batch.id)

  end

  def exam_wise_report

    @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batch = employee_batches(@employee)
    @courses = Course.active
    @batches = []
    @exam_groups = []

  end

  def exam_wise_batch_report

    course = Course.find(params[:course_id])
    @batches = Batch.find_all_by_course_id(course.id,:conditions => { :is_deleted => false, :is_active => true })
    render :partial =>'exam_wise_update_batch'
  end

  def list_exam_types

    batch = Batch.find(params[:batch_id])
    @exam_groups = ExamGroup.find_all_by_batch_id(batch.id)
    render :partial=>'exam_group_select'

  end

  def generated_report

    if params[:student_id].nil?
      if params[:exam_report].nil? or params[:exam_report][:exam_group_id].empty?
        redirect_to :action=>'exam_wise_report' and return
      end
    else
      if params[:exam_group].nil?
        redirect_to :action=>'exam_wise_report' and return
      end
    end
    if params[:student_id].nil?
      @exam_group = ExamGroup.find(params[:exam_report][:exam_group_id])
      @batch = @exam_group.batch
      @student = @batch.students.first
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @exams = []
      @subjects.each do |sub|
        exam = Exam.find_by_exam_group_id_and_subject_id(@exam_group.id,sub.id)
        @exams.push exam unless exam.nil?
      end
      @graph = open_flash_chart_object(770, 350,
                "/exams/graph_for_generated_report?batch=#{@student.batch.id}&examgroup=#{@exam_group.id}&student=#{@student.id}")
    else
      @exam_group = ExamGroup.find_by_id(params[:exam_group])
      @student = Student.find_by_id(params[:student_id])
      @batch = @student.batch
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @exams = []
      @subjects.each do |sub|
        exam = Exam.find_by_exam_group_id_and_subject_id(@exam_group.id,sub.id)
        @exams.push exam unless exam.nil?
      end
      @graph = open_flash_chart_object(600, 300,
                "/exams/graph_for_generated_report?batch=#{@student.batch.id}&examgroup=#{@exam_group.id}&student=#{@student.id}")
    end
  end

  # def previous_years_marks_overview
  # @student = Student.find(params[:student_id])
  # @all_batches = @student.all_batches
  # @graph = open_flash_chart_object(770, 350,
  # "/exams/graph_for_previous_years_marks_overview?student=#{params[:student_id]}&graphtype=#{params[:graphtype]}")
  # respond_to do |format|
  # format.pdf { render :layout => false }
  # format.html
  # end
  #
  # end

  # def graph_for_previous_years_marks_overview
  # student = Student.find(params[:student])
  #
  # x_labels = []
  # data = []
  #
  # student.all_batches.each do |b|
  # x_labels << b.name
  # exam = ExamScore.new()
  # data << exam.batch_wise_aggregate(student,b)
  # end
  #
  # if params[:graphtype] == 'Line'
  # line = Line.new
  # else
  # line = BarFilled.new
  # end
  #
  # line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data
  #
  # x_axis = XAxis.new
  # x_axis.labels = x_labels
  #
  # y_axis = YAxis.new
  # y_axis.set_range(0,100,20)
  #
  # title = Title.new(student.full_name)
  #
  # x_legend = XLegend.new("Academic year")
  # x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  # y_legend = YLegend.new("Total marks")
  # y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  # chart = OpenFlashChart.new
  # chart.set_title(title)
  # chart.y_axis = y_axis
  # chart.x_axis = x_axis
  #
  # chart.add_element(line)
  #
  # render :text => chart.to_s
  # end

  def previous_years_marks_overview_pdf
    @student = Student.find(params[:student])
    @all_batches = @student.all_batches
    render :pdf => 'previous_years_marks_overview_pdf',
              :orientation => 'Landscape',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"

  end

  def second_graph_for_generated_repport
    chart = OpenFlashChart.new
    @x_label=[]
    bar_values=[]
    bars=[]
    bar_title=[]
    student = Student.find(params[:student])
    examgroup = ExamGroup.find(params[:examgroup])
    batch = student.batch
    general_subjects = Subject.find_all_by_batch_id(batch.id, :conditions=>"elective_group_id IS NULL")
    student_electives = StudentsSubject.find_all_by_student_id(student.id,:conditions=>"batch_id = #{batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    subjects = general_subjects + elective_subjects
    subjects.each do |s|
      exams = Exam.find_all_by_exam_group_id_and_subject_id(examgroup.id,s.id)
      exams.each do |exam|
        @x_label<<s.name
        exame = Exam.find_by_topic_id(exam.topic.id,:conditions=>{:exam_group_id=>examgroup.id})
        exam_score = ExamScore.find_by_student_id(student.id,:conditions=>{:exam_id=>exame.id}) unless exame.nil?
        bar = BarFilled.new
        unless exam_score.nil?
          bar.values = [exam_score.marks.to_f]
          bar.tooltip = "#{s.name}<br>#{exam.topic.name}<br>#val#"
        end
        bars << bar

      end

    end
    t = Tooltip.new
    t.set_shadow(false)
    t.stroke = 5
    t.colour = '#6E604F'
    t.set_background_colour("#BDB396")
    t.set_title_style("{font-size: 14px; color: #CC2A43;}")
    t.set_body_style("{font-size: 10px; font-weight: bold; color: #000000;}")

    title = Title.new('Exam wise Report Graph')

    x_axis = XAxis.new
    x_axis.labels = @x_label.uniq
    y_axis = YAxis.new
    y_axis.set_range(0, 100, 10)
    chart.set_title(title)
    chart.x_axis = x_axis
    chart.y_axis = y_axis
    chart.set_tooltip(t)
    chart.set_inner_background( '#E3F0FD', '#CBD7E6', 90 );
    chart.elements = bars
    render :text => chart.to_s

  end

  def graph_for_generated_report
    student = Student.find(params[:student])
    examgroup = ExamGroup.find(params[:examgroup])
    batch = student.batch
    general_subjects = Subject.find_all_by_batch_id(batch.id, :conditions=>"elective_group_id IS NULL")
    student_electives = StudentsSubject.find_all_by_student_id(student.id,:conditions=>"batch_id = #{batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    subjects = general_subjects + elective_subjects

    x_labels = []
    student_marks = []
    data2 = []

    subjects.each do |s|
      exams = Exam.find_all_by_exam_group_id_and_subject_id(examgroup.id,s.id)
      exams.each do |exam|
        exame = Exam.find_by_topic_id(exam.topic.id,:conditions=>{:exam_group_id=>examgroup.id})
        res = ExamScore.find_by_student_id(student.id,:conditions=>{:exam_id=>exame.id}) unless exame.nil?

        unless res.nil?
          x_labels << s.code
          student_marks<< [res.marks.to_f]
          data2 << [exame.class_average_marks.to_f]
        end
      end
    end

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 5;
    bargraph.text = "Student's marks"
    bargraph.values =student_marks

    bargraph2 = BarFilled.new
    bargraph2.width = 1;
    bargraph2.colour = '#5E4725';
    bargraph2.dot_size = 5;
    bargraph2.text = "Class average"
    bargraph2.values = data2;

    x_axis = XAxis.new
    x_axis.labels = x_labels.uniq!

    y_axis = YAxis.new
    y_axis.set_range(0,100,20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("Subjects")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis
    chart.y_legend = y_legend
    chart.x_legend = x_legend

    chart.add_element(bargraph)
    chart.add_element(bargraph2)

    render :text => chart.to_s
  end

  def view
    @graph = open_flash_chart_object(500,250, 'pie_chart', true, '/')
  end

  def pie_chart
    bar = BarSketch.new(55,6,'#d070ac', '#000000')
    bar.key('2006', 10)

    10.times do |t|
      bar.data << rand(7) + 2
    end

    g = Graph.new
    g.title("Sketch Bar", '{font-size:20px; color: #ffffff; margin:10px; background-color: #d070ac; padding: 5px 15px 5px 15px;}' )
    g.set_bg_color('#fdfdfd')
    g.data_sets << bar

    g.set_x_axis_color('#e0e0e0', '#e0e0e0')
    g.set_x_tick_size(9)
    g.set_y_axis_color('#e0e0e0', '#e0e0e0')
    g.set_x_labels(%w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct))
    g.set_x_label_style(11,'#303030')
    g.set_y_label_style(11,'#303030')
    g.set_y_max(10)
    g.set_y_label_steps(5)
    render :text => g.render
  end

  def generated_report_pdf
    @config = SchoolConfiguration.get_config_value('InstitutionName')
    @exam_group = ExamGroup.find(params[:exam_group])
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

  def subject_wise_report
    @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batch = employee_batches(@employee)
    @courses = Course.find(:all,:conditions =>{:is_deleted => false})
    @batches = []
    # @batches = Batch.active
    @subjects = []
  end

  def subject_wise_batch_report
    course = Course.find(params[:course_id])
    @batches = Batch.find_all_by_course_id(course.id,:conditions => { :is_deleted => false, :is_active => true })
    render :partial =>'update_subject_wise_batch'
  end

  def list_subjects
    @subjects = Subject.find_all_by_batch_id(params[:batch_id],:conditions=>{:is_deleted => false})
    render :partial=>'subject_select'

  end

  def generated_report2
    #subject-wise-report-for-batch
    unless params[:exam_report][:subject_id] == ""
      @subject = Subject.find(params[:exam_report][:subject_id])
      @batch = @subject.batch
      @students = @batch.students
      @exam_groups = ExamGroup.find(:all,:conditions=>{:batch_id=>@batch.id})
    else
      flash[:notice] = "select a subject to continue"
      redirect_to :action=>'subject_wise_report'
    end
  end

  def generated_report2_pdf
    #subject-wise-report-for-batch
    @subject = Subject.find(params[:subject_id])
    @batch = @subject.batch
    @students = @batch.students
    @exam_groups = ExamGroup.find(:all,:conditions=>{:batch_id=>@batch.id})
    render :pdf => 'generated_report2_pdf',:page_size=> 'A4',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"

  # respond_to do |format|
  # format.pdf { render :pdf => 'generated_report_pdf',:page_size=> 'A3'}
  # end
  end

  def consolidated_exam_report
    @exam_group = ExamGroup.find(params[:exam_group])
  end

  def consolidated_exam_report_pdf
    @exam_group = ExamGroup.find(params[:exam_group])
    render :pdf => 'consolidated_exam_report_pdf', :page_size=> 'A3',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  #        respond_to do |format|
  #            format.pdf { render :layout => false }
  #        end
  end

  def grouped_exam_report
    @user = current_user
    @employee = Employee.find_by_employee_number(@user.username)
    @batch = employee_batches(@employee)
    @courses = Course.active
    @batches = []
  end

  def grouped_update_batch
    @batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })
    render :partial=>'grouped_update_batch'
  end

  def final_report_type
    batch = Batch.find(params[:batch_id])
    @grouped_exams = GroupedExam.find_all_by_batch_id(batch.id)
    render :partial=>'report_type'

  end

  def generated_report3
    #student-subject-wise-report
    @student = Student.find(params[:student_id])
    @batch = @student.batch
    @subject = Subject.find(params[:subject])
    @exam_groups = ExamGroup.find(:all,:conditions=>{:batch_id=>@batch.id})

    @graph = open_flash_chart_object(770, 350,"/exams/graph_for_generated_report3?subject=#{@subject.id}&student=#{@student.id}")

  end

  def graph_for_generated_report3

    chart = OpenFlashChart.new
    bars   = []
    @labels=[]
    @student = Student.find(params[:student])
    @batch = @student.batch
    @subject = Subject.find(params[:subject])
    @exam_groups = ExamGroup.find(:all,:conditions=>{:batch_id=>@batch.id})

    @exam_groups.each do |exam_group|
      @labels<<exam_group.assessment_name.name
      exams = Exam.find_all_by_subject_id(@subject.id,:conditions=>{:exam_group_id=>exam_group.id})
      exams.each do |exam|
        exame = Exam.find_by_topic_id(exam.topic.id,:conditions=>{:exam_group_id=>exam_group.id})
        exam_score = ExamScore.find_by_student_id(@student.id,:conditions=>{:exam_id=>exame.id}) unless exame.nil?
        bar = BarFilled.new

        unless exam_score.nil?
          bar.values = [exam_score.marks.to_f]
          bar.tooltip = "#{exam.topic.name}<br>#val#"
        end
        bars << bar
      end
    end
    t = Tooltip.new
    t.set_shadow(false)
    t.stroke = 5
    t.colour = '#6E604F'
    t.set_background_colour("#BDB396")
    t.set_title_style("{font-size: 14px; color: #CC2A43;}")
    t.set_body_style("{font-size: 10px; font-weight: bold; color: #000000;}")

    title = Title.new('Exam wise Report Graph')

    x_axis = XAxis.new
    x_axis.labels = @labels
    y_axis = YAxis.new
    y_axis.set_range(0, 100, 10)
    chart.set_title(title)
    chart.x_axis = x_axis
    chart.y_axis = y_axis
    chart.set_tooltip(t)
    chart.set_inner_background( '#E3F0FD', '#CBD7E6', 90 );
    chart.elements = bars
    render :text => chart.to_s
  end

  def generated_report4

    if params[:student_id].nil?
      if params[:batch_id].nil?
        flash[:notice] = "Select a batch to continue"
        redirect_to :action=>'grouped_exam_report' and return
      end
    else
      if params[:type].nil?
        flash[:notice] = "Invalid parameters."
        redirect_to :action=>'grouped_exam_report' and return
      end
    end
    #grouped-exam-report-for-batch
    if params[:student_id].nil?
      @type = params[:type]
      @batch = Batch.find(params[:batch_id])
      @student = @batch.students.first
      if @student.blank?
        flash[:notice] = "No Students in selected batch"
        redirect_to :action=>'grouped_exam_report' and return
      end
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)

        @exam_groups = []
        @grouped_exams.each do |x|

          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)
          greid.each do |g|

            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end

      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    else
      @student = Student.find(params[:student_id])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)

          greid.each do |g|
            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end

      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id =>@student.batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    end

  end

  def generated_student_report4

    if params[:student_id].nil?
      if params[:batch_id].nil?
        flash[:notice] = "Select a batch to continue"
        redirect_to :action=>'grouped_exam_report' and return
      end
    else
      if params[:type].nil?
        flash[:notice] = "Invalid parameters."
        redirect_to :action=>'grouped_exam_report' and return
      end
    end
    #grouped-exam-report-for-batch
    if params[:student_id].nil?
      @type = params[:type]
      @batch = Batch.find(params[:batch_id])
      @student = @batch.students.first
      if @student.blank?
        flash[:notice] = "No Students in selected batch"
        redirect_to :action=>'grouped_exam_report' and return
      end
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)

        @exam_groups = []
        @grouped_exams.each do |x|

          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)
          greid.each do |g|

            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end

      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    else
      @student = Student.find(params[:student_id])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)

          greid.each do |g|
            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end

      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id =>@student.batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    end

  end

  def generated_report4_pdf

    #grouped-exam-report-for-batch
    if params[:student].nil?
      @type = params[:type]
      @batch = Batch.find(params[:exam_report][:batch_id])
      @student = @batch.students.first
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)
          greid.each do |g|
            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end

        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    else
      @student = Student.find(params[:student])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)
          greid.each do |g|
            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end

        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    end
    render :pdf => 'generated_report_pdf',
            :orientation => 'Landscape',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  #    respond_to do |format|
  #      format.pdf { render :layout => false }
  #    end

  end

  def generated_student_report4_pdf

    #grouped-exam-report-for-batch
    if params[:student].nil?
      @type = params[:type]
      @batch = Batch.find(params[:exam_report][:batch_id])
      @student = @batch.students.first
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)
          greid.each do |g|
            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end

        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    else
      @student = Student.find(params[:student])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          greid =  ConnectExam.find_all_by_grouped_exam_id(x.id)
          greid.each do |g|
            @exam_groups.push ExamGroup.find(g.exam_group_id)
          end

        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    end
    render :pdf => 'generated_report_pdf',
            :orientation => 'Landscape',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  #    respond_to do |format|
  #      format.pdf { render :layout => false }
  #    end

  end

  def generated_report5
   
    if params[:student_id].nil?
      if params[:batch_id].empty?
        flash[:notice] = "Select a batch to continue"
        redirect_to :action=>'grouped_exam_report' and return
      end
    else
      if params[:type].nil?
        flash[:notice] = "Invalid parameters."
        redirect_to :action=>'grouped_exam_report' and return
      end
    end
    #grouped-exam-report-for-batch
    if params[:student_id].nil?
      @type = params[:type]
      @batch = Batch.find(params[:batch_id])
      @student = @batch.students.first
      if @student.blank?
        flash[:notice] = "No Students in selected batch"
        redirect_to :action=>'grouped_exam_report' and return
      end
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])

        @exam_groups = []

        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups << ExamGroup.find_by_id(g.exam_group_id)
        end

      else
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])
      end

      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false,:no_exams=>false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    else

      @student = Student.find(params[:student_id])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])
        @exam_groups = []

        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups.push ExamGroup.find(g.exam_group_id)
        end
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id =>@student.batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    end
  end
#   generated report 5 pdf
   def generated_report5_pdf
    
    #grouped-exam-report-for-batch
    if params[:student_id].nil?
      @type = params[:type]
      @batch = Batch.find(params[:batch_id])
      @student = @batch.students.first
        if @type == 'grouped'
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])
        @exam_groups = []
        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups << ExamGroup.find_by_id(g.exam_group_id)
        end
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
      end
      render :pdf => 'generated_report5_pdf',
            :orientation => 'Landscape',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
  end
  
  
  
#   ////
  

  def student_generated_report5
    if params[:student_id].nil?
      if params[:batch_id].empty?
        flash[:notice] = "Select a batch to continue"
        redirect_to :action=>'grouped_exam_report' and return
      end
    else
      if params[:type].nil?
        flash[:notice] = "Invalid parameters."
        redirect_to :action=>'grouped_exam_report' and return
      end
    end
    #grouped-exam-report-for-batch
    if params[:student_id].nil?
      @type = params[:type]
      @batch = Batch.find(params[:batch_id])
      @student = @batch.students.first
      if @student.blank?
        flash[:notice] = "No Students in selected batch"
        redirect_to :action=>'grouped_exam_report' and return
      end
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])

        @exam_groups = []

        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups << ExamGroup.find_by_id(g.exam_group_id)
        end

      else
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])
      end

      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    else

      @student = Student.find(params[:student_id])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_by_id(params[:grouped])
        @exam_groups = []

        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups.push ExamGroup.find(g.exam_group_id)
        end
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id =>@student.batch.id})
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
    @subjects = general_subjects + elective_subjects
    end
  end

  def index_pdf
    render :pdf => 'my_pdf',:layout => false,:template => '/exams/index_pdf',:footer => {:center =>'Center', :left => 'Left', :right => 'Right'},:disposition  => "attachment"
  end

  def connect_exam_report
    @batch = params[:batch_id]
    @batches = Batch.find(@batch)
    @grouped_exam = GroupedExam.find_all_by_batch_id(@batch)
    render :layout => false
  end

  def previous_years_marks_overview
    student_b = params[:students][:batches]
    @all_batches =[]
    student_b.each do |sb|
      batch = Batch.find_by_id(sb)
      @all_batches << batch
    end
    @student = Student.find(params[:student_id])
    logger.info "student #{@student.full_name}"

    @graph = open_flash_chart_object(770, 350,
            "/exams/graph_for_previous_years_marks_overview?student=#{params[:student_id]}&graphtype=#{params[:graphtype]}")
    respond_to do |format|
      format.pdf { render :layout => false }
      format.html
    end

  end

  def graph_for_previous_years_marks_overview

    student = Student.find(params[:student])

    x_labels = []
    data = []

    student.all_batches.each do |b|
      x_labels << b.name
      exam = ExamScore.new()
      data << exam.batch_wise_aggregate(student,b).to_f
    end

    if params[:graphtype] == 'Line'
      line = Line.new
    else
      line = BarFilled.new
    end

    line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0,100,20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("Academic year")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Total marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def previous_years_marks_overviews
    @student = Student.find(params[:student_id])
    batches = @student.all_batches
    @type = params[:type]

    @all_batches=  batches.sort! { |a,b| a.id <=> b.id }.reverse!
  end

  def academic_report

    #academic-archived-report
    @student = Student.find(params[:student_id])

    @batch = Batch.find(params[:year])
    if params[:type] == 'grouped'
      @grouped_exams = GroupedExam.find_by_id(params[:grouped])
      @exam_groups = []
      greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
      greid.each do |g|
        @exam_groups.push ExamGroup.find(g.exam_group_id)
      end
    else
      @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
    end
    general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL and is_deleted=false")
    student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    @subjects = general_subjects + elective_subjects
  end

  def normal_academic_report

    #academic-archived-report
    @student = Student.find(params[:student_id])

    @batch = Batch.find(params[:year])
    @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
    general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL and is_deleted=false")
    student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    @subjects = general_subjects + elective_subjects
  end

  def view_exam_score_updation
    @audits = ExamScore.find(:last).audits
  # @audits1=AdditionalExamScore.find_by_additional_exam_id(2).audits

  end

  def destroy_grouped_exam
    @grouped_exam = GroupedExam.find params[:id]
    respond_to do |format|
      if @grouped_exam.destroy
        format.html # show.html.erb
        format.json { render :json => {:valid => true}}
      else
        format.json { render :json => {:valid => false}}
      end
    end
  end

  def delete_view_grouping
    @batch = Batch.find(params[:id])
    @grouped_exams= GroupedExam.find_all_by_batch_id(@batch.id)
    render :partial=>'view_grouping_par'
  end

  # def co_scholastic_assessment_index
  #
  # @user = current_user
  # @employee = Employee.find_by_employee_number(@user.username)
  # @batch = employee_batches(@employee)
  #
  # @course= Course.active
  # @batches =[]
  # end
  def grouping_assessment_type

    @batch=params[:id]
  end

  def grouping_assessment_mode
    @mode=params[:assessment_mode]
    render :partial=>'assessment_mode'
  end

  def xls_demo
      @batch = Batch.find(params[:batch_id])
   
      @students = @batch.students
      @grouped_exams = GroupedExam.find_by_id(params[:grouped])
        @exam_groups = []
        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups << ExamGroup.find_by_id(g.exam_group_id)
      end
       @terms=[]
       student_co_scholastic_assessments= StudentCoScholasticAssessment.find_all_by_batch_id(@batch.id)
     unless  student_co_scholastic_assessments.empty?
         student_co_scholastic_assessments.each do |student_co_assessment|
         @terms << TermMaster.find_by_id(student_co_assessment.term_master_id)
       end
     end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false})
      # student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      # elective_subjects = []
      # student_electives.each do |elect|
        # elective_subjects.push Subject.find(elect.subject_id)
      # end
       # @subjects = general_subjects + elective_subjects
    @subjects = general_subjects 
      respond_to do |format|
      format.html
      format.rss
      format.xls {    
      send_data(render_to_xls(@students, @batch.full_name,@exam_groups,@subjects,@grouped_exams,@terms,@batch), :type=>"application/ms-excel", :filename => "#{@batch.full_name}.xls")
      }
      end
  end
  
  
  def secondry_standard_report
     @batch = Batch.find(params[:batch_id])
   
      @students = @batch.students
      @grouped_exams = GroupedExam.find_by_id(params[:grouped])
        @exam_groups = []
        greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
        greid.each do |g|
          @exam_groups << ExamGroup.find_by_id(g.exam_group_id)
      end
       @terms=[]
       student_co_scholastic_assessments= StudentCoScholasticAssessment.find_all_by_batch_id(@batch.id)
     unless  student_co_scholastic_assessments.empty?
         student_co_scholastic_assessments.each do |student_co_assessment|
         @terms << TermMaster.find_by_id(student_co_assessment.term_master_id)
       end
     end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>{:elective_group_id => nil, :is_deleted => false,:no_exams=>false})
      # student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id => @batch.id})
      # elective_subjects = []
      # student_electives.each do |elect|
        # elective_subjects.push Subject.find(elect.subject_id)
      # end
       # @subjects = general_subjects + elective_subjects
    @subjects = general_subjects 
      respond_to do |format|
      format.html
      format.rss
      format.xls {    
      send_data(render_report_card(@students, @batch.full_name,@exam_groups,@subjects,@grouped_exams,@terms,@batch), :type=>"application/ms-excel", :filename => "#{@batch.full_name}.xls")
      }
      end
  end
  
  
  def co_scholastic_area_assessment_report
    
    @student=Student.find_by_id(params[:student_id])
    @batch=Batch.find_by_id(params[:batch])
    @student_co_scholastic_assessment=StudentCoScholasticAssessment.find_by_id(params[:student_co_scholastic_assessment])
    @area_assessment_details=StudentCoScholasticAreaAssessmentDetail.find_all_by_student_co_scholastic_assessment_id_and_student_id(@student_co_scholastic_assessment.id,@student.id)
    
  end
  def co_scholastic_activity_assessment_report
    @student=Student.find_by_id(params[:student_id])
    @batch=Batch.find_by_id(params[:batch])
    @student_co_scholastic_assessment=StudentCoScholasticAssessment.find_by_id(params[:student_co_scholastic_assessment])
    @activity_assessment_details=StudentCoScholasticActivityAssessmentDetail.find_all_by_student_co_scholastic_assessment_id_and_student_id(@student_co_scholastic_assessment.id,@student.id)
    
  end
end
