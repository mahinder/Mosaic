class BatchesController < ApplicationController
  before_filter :init_data,:except=>[:assign_tutor,:update_employees,:assign_employee,:remove_employee,:batch_history,:show1,:history_select_course,:batch_students_pdf]
  filter_access_to :all
  def index
    @users = []
    @teacher = []
    @course = @course
    @class_timings = ClassTiming.default
     @privilage = Privilege.find_by_name("Teacher")
      unless @privilage.nil?
        @users = @privilage.users
        unless @users.empty?
          @users.each do |user|
          @teacher << user.employee_record
        end
      end
      end
    respond_to do |format|
      format.html { render :layout => false } # index.html.erb
    end
  end

  def update_batch_subject
    @batch = Batch.find params[:id]
    render '_batch',:layout => false
  end

  def batch_history
    @batches = []
    @courses_value = Course.all

  end

  def history_select_course
    unless params[:course_id].nil?
      @course = Course.find(params[:course_id])
      if @course.nil?
        @batches = Batch.inactive
      else
      @batches = @course.batches.inactive
      end
    else
    @batches = []
    end
    render "_history_select_batch",:layout => false
  end

  def history_select_batch
    @employee = []
    @batch = Batch.find(params[:id])
    @subjects  = Subject.for_batch(params[:id])
    @students = @batch.graduated_students
    @timetable = TimetableEntry.find_all_by_batch_id(params[:id])
    unless @timetable.empty?
      @timetable.each do |time|
        unless (time.employee.nil?) || (@employee.include? time.employee)
          @employee <<  time.employee
        end
      end
    end
    render "_all_history_data",:layout => false
  end

  def find_batch_subjects

    @count = 0
    @batch_sub = []
    @sub_id = []
    @sub_name = []
    @sub_elective = []
    @course = Course.find_by_id(params[:course_id])
    @batch = Batch.find(params[:batch_id])
    @sub = Subject.for_batch(params[:batch_id])
    @class_timings = ClassTiming.default
    @weekdays = Weekday.default
    unless @class_timings.empty? || @weekdays.empty?
    @count =  @class_timings.count *  @weekdays.count
    end
    unless @sub.empty?
      @sub.each do |sb|
        @sub_id << sb.id.to_s
        @sub_name << sb.name
        if sb.elective_group.nil?
          @sub_elective << "-"
        else
        @sub_elective << sb.elective_group.name
        end
        unless sb.skill_id.nil?
        @batch_sub << sb.skill_id.to_s
        end
      end
    end
    respond_to do |format|
      format.json { render :json => {:valid => true, :subject => @batch_sub,:sub_id => @sub_id,:sub_name => @sub_name,:count => @count,:sub_elective => @sub_elective }}
    end

  end

  def assign_skill_to_batch
    @Subskills = []
    @name_sub = ""
    @name_sub_id = []
    @course = Course.find_by_id(params[:course_id])
    @batch = Batch.find(params[:batch_id])
    unless params[:skills_id].nil?
      @allready = Subject.for_batch(params[:batch_id])
      unless @allready.empty?
        @allready.each do |all|
          unless params[:skills_id].include? all.skill_id.to_s
            @exam = Exam.find_by_subject_id(all.id)
            timetable_entry = TimetableEntry.find_by_subject_id(all.id)
            if @exam.nil? || timetable_entry.nil?
              all.destroy
            else
              if @name_sub == ""
              @name_sub = @name_sub + all.name
              @name_sub_id << all.skill_id.to_s
              else
                @name_sub = @name_sub + ","+all.name
              @name_sub_id << all.skill_id.to_s
              end

            end
          end
        end
      end
      params[:skills_id].each_with_index do |skill,index|
        @skill = Skill.find(skill)
        unless @skill.nil?
          @subject_allready = Subject.find_by_batch_id_and_skill_id(@batch.id,@skill.id)
          if @subject_allready.nil?
            # @subject = Subject.new(:name=>@skill.name,:code=> @skill.code,:batch_id=>@batch.id,:no_exams=>@skill.no_exam,
            # :max_weekly_classes=>@skill.max_weekly_classes,:is_deleted=>false,:skill_id => @skill.id,:is_common => @skill.is_common,:elective_group_id => @skill.elective_skill_id)

            @subject = Subject.new(params[:full_data][index.to_s],:skill_id => @skill.id)
          @subject.save
          @Subskills = SubSkill.find_all_by_skill_id(@skill.id,:conditions => {:is_active => true})
          unless @Subskills.empty?
            @Subskills.each do |skl|
              Topic.create(:name => skl.name,:subject_id => @subject.id,:is_active => skl.is_active)
            end
          end
          else
            @subject_allready.update_attributes(params[:full_data][index.to_s])
          end
        end

      end
    end
    respond_to do |format|
      format.json { render :json => {:valid => true, :notice => "Batch subjects updated successfully",:name_sub => @name_sub,:name_sub_id => @name_sub_id}}
    end
  end

  def create_elective_group
    respond_to do |format|
      unless params[:subject_ids].nil? && params[:name].nil?
        @elective_group = ElectiveGroup.new(:name => params[:name] , :batch_id => params[:batch_id])
        if @elective_group.save
          params[:subject_ids].each do |sub|
            @subj = Subject.find(sub)

            unless @subj.nil?
              @subj.update_attributes({:elective_group_id =>  @elective_group.id})
            end

          end

          format.json { render :json => {:valid => true ,:notice => "Group created successfully" }}

        else

          format.json { render :json => {:valid => false, :errors => @elective_group.errors}}

        end
      end

      format.json { render :json => {:valid => "error" ,:notice => "Unable to save" }}
    end
  end

  def all_record

    @batch = Batch.find_by_id(params[:id])
    @courses =Course.active - [*@course]
    @courses_value = [*@course] + @courses
    @batches = @course.batches.active - [*@batch]
    @batch_value =  [*@batch] + @batches
    @course = @course
    @teacher_category = EmployeeCategory.find_by_name("Teaching")
    @class_timings = ClassTiming.for_batch(params[:id])
    if @class_timings.empty?
      @class_timings = ClassTiming.find(:all, :conditions=>["batch_id is null"])
    end
    @subjects = Subject.for_batch(@batch.id)

  end

  def select_batch
    if @course.nil?
      @batches = Batch.active
    else
    @batch_value = @course.batches.active
    end

    render "_select_batch",:layout => false
  end

  def subject_students
    @students = []
    if !params[:elective_group].nil?
      @all_students = []
      @elective =  StudentsSubject.find_all_by_subject_id(params[:subject])
      unless @elective.empty?
        @elective.each do |student|
          @all_students =  @all_students + [*Student.find_by_id(student.student_id)]
        end
      end
    else

      @batch = Batch.find(params[:batch])
      @elective = StudentsSubject.find_all_by_subject_id(params[:subject])
      if @elective.empty?
      @all_students = @batch.students
      else

        @elective.each do |student|
          @students =  @students + [*Student.find_by_id(student.student_id)]
        end
        @all_students = []
        unless @batch.students.empty?
          @batch.students.each do |bat|
            @all_students = @all_students + [*bat] unless @students.include? bat
            
          end
          @all_students =  @all_students + [*@students]
        end
      end
    end

  end

  def room
    @value = params[:value]
    @values = Room.find(:all,:conditions => "(name LIKE \"%#{@value}%\")")
    render '_search',:layout => false

  end

  def teacher
    @value = params[:value]
    # @teacher_category = EmployeeCategory.find_by_name("Teaching")
    # other_conditions = ""
    # other_conditions += " AND employee_category_id = #{@teacher_category.id}"
    # @first = Employee.find(:all,:conditions => "first_name LIKE \"%#{@value}%\" OR middle_name LIKE \"%#{@value}%\" OR last_name LIKE \"%#{@value}%\" " + other_conditions)
    @first = Employee.find(:all,:conditions => "first_name LIKE \"%#{@value}%\" OR middle_name LIKE \"%#{@value}%\" OR last_name LIKE \"%#{@value}%\" " )
    @batch = Batch.find_by_id(params[:batch_id])
    # unless @batch.employee_id.blank?
    # unless @batch.class_teacher.nil?
    # @assigned_emps = @batch.employee_id.split(',')
    # @employee = @batch.class_teacher

    # @assigned_emps.each{ |i|
    # @employee =  Employee.find_by_id(i)
    # if @first.include?(@employee)
    # @first = @first-[*@employee]
    # end
    # }
    # end

    @values = @first

    render '_employee',:layout => false

  end

  def new
    @batch = @course.batches.build
  end

  def create
    @batch = @course.batches.build(params[:batch])
    @skills = Course.new.course_skills(@course.id)

    if @batch.save

      # unless @skills.empty?
      # @skills.each do |skill|
      # @subject = Subject.new(:name=>skill.name,:code=> skill.code,:batch_id=>@batch.id,:no_exams=>skill.no_exam,
      # :max_weekly_classes=> skill.max_weekly_classes,:is_deleted=>false,:skill_id => skill.id,:is_common => skill.is_common,:elective_group_id => skill.elective_skill_id)
      # @subject.save
      # end
      #
      # end

      respond_to do |format|
        format.json { render :json => {:valid => true,:notice => "Batch created succesfully"}}
      end
    else
      respond_to do |format|
        format.json { render :json => {:valid => false, :errors => @batch.errors}}
      end
    end
  end

  def edit
  end

  def update

    respond_to do |format|
      if @batch.update_attributes(params[:batch])
        format.json { render :json => {:valid => true,:notice => "Batch updated succesfully"}}
      else
        format.html { render action: "edit" }
        #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false, :errors => @batch.errors}}
      end
    end
  end

  def assign_student_to_sub
    @batch = Batch.find_by_id(params[:id])
    render "_assign_sub_student1",:layout => false
  end

  def assign_student_to_sub1
    puts params
    all_ready_assign = StudentsSubject.find_all_by_subject_id(params[:subject_id])
    if params[:elective] == ""
      unless params[:students_ids].nil?
            params[:students_ids].each do |s|
              @student = Student.find_by_id s
              @batch = @student.batch
              @assigned = StudentsSubject.find_by_student_id_and_subject_id(s,params[:subject_id])
              StudentsSubject.create(:student_id=>s,:subject_id=>params[:subject_id],:batch_id=>@batch.id) if @assigned.nil?
            end
        unless all_ready_assign.empty?
         
          all_ready_assign.each do |inc|
            puts inc
            # @assigned = StudentsSubject.find_by_student_id_and_subject_id(inc,params[:subject_id])
              unless params[:students_ids].include? inc.student.id.to_s
              inc.destroy
              end
          end
        end

      else
        unless all_ready_assign.empty?
          
          all_ready_assign.each do |inc|
            # @assigned = StudentsSubject.find_by_student_id_and_subject_id(inc,params[:subject_id])
            inc.destroy
          end
        end

      end

    end
    # @sub_stud = StudentsSubject.new(:subject_id => params[:subject_id], :student_id => params[:students_ids])
    # params[:students_ids].each do |s|
    # @student = Student.find_by_id s
    # @batch = @student.batch
    # @assigned = StudentsSubject.find_by_student_id_and_subject_id(s,params[:subject_id])
    # StudentsSubject.create(:student_id=>s,:subject_id=>params[:subject_id],:batch_id=>@batch.id) if @assigned.nil?
    #
    # end
    render :json => { :notice => "Students Are Assigned"}
  end

  def remove_student_to_sub1
   @sub_stud = StudentsSubject.new(:subject_id => params[:subject_id], :student_id => params[:students_ids])
    params[:students_ids].each do |s|
      @assigned = StudentsSubject.find_by_id(s)
      @assigned.destroy if !@assigned.nil?
    end
    render :json => { :notice => "Students Are removed"}
  end

  def assign_home_teacher_and_room
    @batch = Batch.find_by_id(params[:batch_id])
    @batch_teacher = ""
    @batch_room = ""

    if params[:teacher].length > 0 && params[:room].length == 0
      if @batch.update_attributes(:class_teacher_id => params[:teacher])
        unless @batch.class_teacher.nil?
        @batch_teacher = @batch.class_teacher.full_name
        end
        render :json => {:valid => true,:batch_teacher => @batch_teacher}
      else
        render :json => {:valid => false, :errors => @batch.errors}
      end

    elsif params[:teacher].length  == 0 && params[:room].length > 0
      if @batch.update_attributes(:room_id => params[:room])
        unless @batch.room.nil?
        @batch_room = @batch.room.name
        end
        render :json => {:valid => true,:batch_room => @batch_room}
      else
        render :json => {:valid => false, :errors => @batch.errors}
      end

    elsif params[:teacher].length  >0 && params[:room].length > 0

      if @batch.update_attributes(:class_teacher_id => params[:teacher],:room_id => params[:room])
        unless @batch.class_teacher.nil?
        @batch_teacher = @batch.class_teacher.full_name
        end
        unless @batch.room.nil?
        @batch_room = @batch.room.name
        end
        render :json => {:valid => true,:batch_teacher =>  @batch_teacher,:batch_room => @batch_room}
      else
        render :json => {:valid => false, :errors => @batch.errors}
      end
    else
      render :json => {:valid => true, :errors => @batch.errors}
    end

  end

  def show1
    @batch_value = []
    @course = Course.find params[:course_id]
    if @course.nil?
      @batches = Batch.active
    else
    @batch_value = @course.batches.active
    end

    unless @batch_value.empty?
      @batch = @batch_value[0]
      # @teacher_category = EmployeeCategory.find_by_name("Teaching")
      @class_timings = ClassTiming.for_batch(@batch_value[0].id)
      if @class_timings.empty?
        @class_timings = ClassTiming.find(:all, :conditions=>["batch_id is null"])
      end
      @subjects = Subject.for_batch(@batch.id)
      render '_full_page',:layout => false
    else
      render "_show1",:layout => false
    end

  end

  def show
    @batch = Batch.find params[:id]
    @teacher_category = EmployeeCategory.find_by_name("Teaching")
    @class_timings = ClassTiming.for_batch(params[:id])
    if @class_timings.empty?
      @class_timings = ClassTiming.find(:all, :conditions=>["batch_id is null"])
    end
    @subjects = Subject.for_batch(@batch.id)
    render '_full_page',:layout => false
  end

  def destroy
    
    if @batch.students.empty? and @batch.subjects.empty?
      @batch.inactivate
      respond_to do |format|
        format.html { redirect_to employee_grades_url }
        format.json { render :json => {:valid => true,  :notice => "batch was deleted successfully."}}
      end
    else
      respond_to do |format|
      #format.json { render json: @employee_grades.error, status: :unprocessable_entity }
        format.json { render :json => {:valid => false}}
      end   end
  end

  def assign_tutor
    @batch = Batch.find_by_id(params[:id])
    @assigned_employee = @batch.employee_id.split(",") unless @batch.employee_id.nil?
    @departments = EmployeeDepartment.find(:all)
  end

  def update_employees
    @employees = Employee.find_all_by_employee_department_id(params[:department_id])
    @batch = Batch.find_by_id(params[:batch_id])
    render :update do |page|
      page.replace_html 'employee-list', :partial => 'employee_list'
    end
  end

  def assign_employee
    @batch = Batch.find_by_id(params[:batch_id])
    @employees = Employee.find_all_by_employee_department_id(params[:department_id])
    unless @batch.employee_id.blank?
      @assigned_emps = @batch.employee_id.split(',')
    else
    @assigned_emps = []
    end
    @assigned_emps.push(params[:id].to_s)
    @batch.update_attributes :employee_id => @assigned_emps.join(",")
    @assigned_employee = @assigned_emps.join(",")
    render :update do |page|
      page.replace_html 'employee-list', :partial => 'employee_list'
      page.replace_html 'tutor-list', :partial => 'assigned_tutor_list'
    end
  end

  def remove_employee
    @batch = Batch.find_by_id(params[:batch_id])
    @employees = Employee.find_all_by_employee_department_id(params[:department_id])
    @assigned_emps = @batch.employee_id.split(',')
    @removed_emps = @assigned_emps.delete(params[:id].to_s)
    @assigned_emps = @assigned_emps.join(",")
    @batch.update_attributes :employee_id =>@assigned_emps
    render :update do |page|
      page.replace_html 'employee-list', :partial => 'employee_list'
      page.replace_html 'tutor-list', :partial => 'assigned_tutor_list'
    end
  end

  def subject_batch_student
    @all_students = ""
    @students = ""
    if params[:elective] != ""

      @elective =  StudentsSubject.find_all_by_subject_id_and_batch_id(params[:id],params[:batch])
      unless @elective.empty?

        @elective.each do |student|
          if @all_students == ""
            @all_students =  @all_students + Student.find_by_id(student.student_id).id.to_s unless Student.find_by_id(student.student_id).nil?
          else
            @all_students =  @all_students +","+ Student.find_by_id(student.student_id).id.to_s unless Student.find_by_id(student.student_id).nil?
          end
        end
      end
    else

      @batch = Batch.find(params[:batch])

      # @elective = StudentsSubject.find_all_by_subject_id_and_batch_id(params[:id],params[:batch])
      @elective = StudentsSubject.find_all_by_subject_id(params[:id],params[:batch])
      if @elective.empty?
        students = @batch.students

        unless students.empty?
          students.each do |student|
            if @all_students == ""
            @all_students =  @all_students + student.id.to_s
            else
              @all_students =  @all_students +","+ student.id.to_s
            end
          end
        end

      else

        @elective.each do |student|
          @students =  @students +","+ Student.find_by_id(student.student_id).id.to_s unless Student.find_by_id(student.student_id).nil?
        end

        @all_students = ""
        unless @batch.students.empty?
          @batch.students.each do |bat|

            if @all_students == ""
              @all_students = @all_students + bat.id.to_s unless @students.split(',').include? bat
            @all_students =  @all_students + @students
            else

            end
            @all_students = @all_students  +","+bat.id.to_s unless @students.split(',').include? bat
            @all_students =  @all_students +@students
          end
        end
      end
    end
   
    respond_to do |format|
      format.json { render :json => {:valid => true, :all_students => @all_students}}
    end

  end

def batch_students_pdf
  @student = []
    @batch = Batch.find(params[:batch_id])
   @students = @batch.students
    @students.sort! { |a,b| a.class_roll_no.to_i <=> b.class_roll_no.to_i }
    render :pdf=>'timetable_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"

  #  respond_to do |format|
  #    format.pdf { render :layout => false }
  #  end
  end



  private

  def init_data
    @batch = Batch.find params[:id] if ['show', 'edit', 'update', 'destroy'].include? action_name
    @course = Course.find params[:course_id]
  end
end