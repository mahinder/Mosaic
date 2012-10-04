class BatchTransfersController < ApplicationController
  before_filter :login_required
  filter_access_to :all
   
  def index
   @tran = params[:transfer_to]
   if params[:id]==nil   
    @batches = []
   else   
   @batch = Batch.find params[:id], :include => [:students],:order => "students.class_roll_no ASC"
   @batches = Batch.active
   response = { :batch => @batch, :batches => @batches}
    respond_to do |format|
      format.html { render :partial => 'student_table'} # index.html.erb
      format.json  { render :json => response }
    end
     # render :partial => 'student_table'
    end
  end

  def show
    @batch = Batch.find params[:id], :include => [:students],:order => "students.class_roll_no ASC"
    @batches = Batch.active - @batch.to_a
    render :partial => 'student_table'
  end

 def find_batch
     @batches = Batch.find(:all, :conditions => {:course_id => params[:q]})
     # render :partial => '/student/batch'
 end

  def transfer
    unless params[:student].nil?
      students = Student.find(params[:student])
      students.each do |s|
        s.graduated_batches << s.batch
        s.update_attribute(:batch_id, params[:to])
        s.update_attribute(:has_paid_fees,0)
      end
    end
    batch = Batch.find(params[:id])
    @stu = Student.find_all_by_batch_id(batch.id)
    if @stu.empty?
      batch.update_attribute :is_active, false
      Subject.find_all_by_batch_id(batch.id).each do |sub|
          sub.employees_subjects.each do |emp_sub|
            emp_sub.delete
          end
      end
    end
     @batch = Batch.find params[:id], :include => [:students],:order => "students.first_name ASC"
    respond_to do |format|
      format.html { render :partial => 'student_table'} # index.html.erb
      format.json  { render :json => {:batch => @batch,:notice => 'Trasferred students successfully.'} }
    end
  end

  def graduation
    @batch = Batch.find params[:id], :include => [:students]
    unless params[:ids].nil?
      @ids = params[:ids]
      @id_lists = @ids.map { |st_id| ArchivedStudent.find_by_admission_no(st_id) }
    end
      student_id_list = params[:ids]
        @student_list = student_id_list.map { |st_id| Student.find(st_id) }
        @admission_list = []
        @student_list.each do |s|
          @admission_list.push s.admission_no
        end
        @student_list.each { |s| s.archive_student(params[:status_description]) }
        @stu = Student.find_all_by_batch_id(@batch.id)
        if @stu.empty?
          @batch.update_attribute :is_active, false
        end
        @id_lists = @ids.map { |st_id| ArchivedStudent.find_by_admission_no(st_id) }
        @batch = Batch.find params[:id], :include => [:students],:order => "students.first_name ASC"
         respond_to do |format|
            format.html { render :partial => 'student_table'} # index.html.erb
            format.json  { render :json => {:batch => @batch,:notice => 'Graduated selected students successfully.'} }
          end
    end

  def subject_transfer
    @batch = Batch.find(params[:id])
    @elective_groups = @batch.elective_groups
    @normal_subjects = @batch.normal_batch_subject
    @elective_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
  end

  def get_previous_batch_subjects
    @batch = Batch.find(params[:id])
    course = @batch.course
    all_batches = course.batches
    all_batches.reject! {|b| b.is_deleted?}
    all_batches.reject! {|b| b.subjects.empty?}
    @previous_batch = all_batches[all_batches.size-2]
    @previous_batch_normal_subject = @previous_batch.normal_batch_subject
    @elective_groups = @previous_batch.elective_groups
    @previous_batch_electives = Subject.find_all_by_batch_id(@previous_batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
    render(:update) do |page|
      page.replace_html 'previous-batch-subjects', :partial=>"previous_batch_subjects"
    end
  end

  def update_batch
   logger.info "In BatchTransfer controller & action update_batch ,the params are #{params}" 
   @course =Course.find(params[:q])
   @batches = @course.batches.active
   render :partial => 'batch_transfer_batch'
  end

  def assign_previous_batch_subject
    subject = Subject.find(params[:id])
    batch = Batch.find(params[:id2])
    sub_exists = Subject.find_by_batch_id_and_name(batch.id,subject.name)
    if sub_exists.nil?
      if subject.elective_group_id == nil
        Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
          :max_weekly_classes=>subject.max_weekly_classes,:elective_group_id=>subject.elective_group_id,:is_deleted=>false)
      else
        elect_group_exists = ElectiveGroup.find_by_name_and_batch_id(ElectiveGroup.find(subject.elective_group_id).name,batch.id)
        if elect_group_exists.nil?
          elect_group = ElectiveGroup.create(:name=>ElectiveGroup.find(subject.elective_group_id).name,
            :batch_id=>batch.id,:is_deleted=>false)
          Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
            :max_weekly_classes=>subject.max_weekly_classes,:elective_group_id=>elect_group.id,:is_deleted=>false)
        else
          Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
            :max_weekly_classes=>subject.max_weekly_classes,:elective_group_id=>elect_group_exists.id,:is_deleted=>false)
        end
      end
      render(:update) do |page|
        page.replace_html "prev-subject-name-#{subject.id}", :text=>""
        page.replace_html "errors", :text=>"#{subject.name}  has been added to batch:#{batch.name}"
      end
    else
      render(:update) do |page|
        page.replace_html "prev-subject-name-#{subject.id}", :text=>""
        page.replace_html "errors", :text=>"<div class=\"errorExplanation\" ><p>#{batch.name} Already has the subject with name #{subject.name}</p></div>"
      end
    end
  end

  def assign_all_previous_batch_subjects
    msg = ""
    err = ""
    batch = Batch.find(params[:id])
    course = batch.course
    all_batches = course.batches
    @previous_batch = all_batches[all_batches.size-2]
    subjects = Subject.find_all_by_batch_id(@previous_batch.id,:conditions=>'is_deleted=false')
    subjects.each do |subject|
      sub_exists = Subject.find_by_batch_id_and_name(batch.id,subject.name)
      if sub_exists.nil?
        if subject.elective_group_id.nil?
          Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
            :max_weekly_classes=>subject.max_weekly_classes,:elective_group_id=>subject.elective_group_id,:is_deleted=>false)
        else
          elect_group_exists = ElectiveGroup.find_by_name_and_batch_id(ElectiveGroup.find(subject.elective_group_id).name,batch.id)
          if elect_group_exists.nil?
            elect_group = ElectiveGroup.create(:name=>ElectiveGroup.find(subject.elective_group_id).name,
              :batch_id=>batch.id,:is_deleted=>false)
            Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
              :max_weekly_classes=>subject.max_weekly_classes,:elective_group_id=>elect_group.id,:is_deleted=>false)
          else
            Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
              :max_weekly_classes=>subject.max_weekly_classes,:elective_group_id=>elect_group_exists.id,:is_deleted=>false)
          end
        end
        msg += "<li> The subject #{subject.name}  has been added to Batch #{batch.name}</li>"
      else
        err +=   "<li>Batch #{batch.name} already has a subject with name #{subject.name}" + "</li>"
      end
    end
    @batch = batch
    course = batch.course
    all_batches = course.batches
    @previous_batch = all_batches[all_batches.size-2]
    @previous_batch_normal_subject = @previous_batch.normal_batch_subject
    @elective_groups = @previous_batch.elective_groups
    @previous_batch_electives = Subject.find_all_by_batch_id(@previous_batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
    render(:update) do |page|
      page.replace_html 'previous-batch-subjects', :text=>"<p>Subjects have been assigned.</p> "
      unless msg.empty?
        page.replace_html "msg", :text=>"<div class=\"flash-msg\"><ul>" +msg +"</ul></p>"
      end
      unless err.empty?
        page.replace_html "errors", :text=>"<div class=\"errorExplanation\" ><p>Following errors were found :</p><ul>" +err + "</ul></div>"
      end
    end

  end



  def new_subject
    @subject = Subject.new
    @batch = Batch.find params[:id] if request.xhr? and params[:id]
    @elective_group = ElectiveGroup.find params[:id2] unless params[:id2].nil?
    respond_to do |format|
      format.js { render :action => 'new_subject' }
    end
  end

  def create_subject
    @subject = Subject.new(params[:subject])
    @batch = @subject.batch
    if @subject.save
      @subjects = @subject.batch.normal_batch_subject
      @normal_subjects = @subjects
      @elective_groups = ElectiveGroup.find_all_by_batch_id(@batch.id)
      @elective_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
    else
      @error = true
    end
  end

  def change_batch 
   logger.info "In Batch Transfer controller & action change_batch ,the params are #{params}" 
   @course =Course.find_by_id(params[:q])
   unless @course.nil?
   @batches = @course.batches.active
   else
   @batches = []
   end
   render :partial => 'batch'
  end
end