

class ArchivedStudentController < ApplicationController
    before_filter :login_required
    before_filter :protect_other_student_data
    filter_access_to :all
    before_filter :protect_other_student_id, :only => [:award_report]
    def profile
        @current_user = current_user
        @archived_student = ArchivedStudent.find_by_id(params[:id])
        unless @archived_student.nil?
        @parents = ArchivedGuardian.find(:all, :conditions=>"ward_id = #{@archived_student.id}")
        else
         redirect_to :controller => 'sessions', :action => 'dashboard'
          flash[:notice] = "Archived student not found" 
        end
    end

    def show
        @student = ArchivedStudent.find_by_admission_no(params[:id])
        send_data(@student.student_photo_data,
            :type => @student.student_photo_content_type,
            :filename => @student.student_photo_filename,
            :disposition => 'inline')
    end

    def guardians
        @archived_student = ArchivedStudent.find(params[:id])
        @parents = ArchivedGuardian.find(:all, :conditions=>"ward_id = #{@archived_student.id}")
    end


    def destroy
        archived_student = ArchivedStudent.find(params[:id])
        redirect_to :controller => 'sessions', :action => 'dashboard'
    end

    def reports
        @student= ArchivedStudent.find_by_id(params[:id])
        unless @student.nil?
        @batch = @student.batch
        @aexamg = AdditionalExamGroup.find_all_by_batch_id(@batch.id)
         @additional_exam = []
         unless @aexamg.empty?
          @aexamg.each do |a|
             if a.students_list.split(',').include?(@student.id.to_s)
                @additional_exam.push a
              end
          end
         end
         
        @archived_student_award = ArchivedStudentAward.find_all_by_student_id(@student.id)
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @normal_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>"no_exams = false AND elective_group_id IS NULL AND is_deleted = false")
        @student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id=>@batch.id})
        @elective_subjects = []
        @student_electives.each do |e|
            @elective_subjects.push Subject.find(e.subject_id)
        end
        @subjects = @normal_subjects+@elective_subjects
        @exam_groups = @batch.exam_groups
        @old_batches = @student.all_batches
        else
          redirect_to :controller => 'sessions', :action => 'dashboard'
          flash[:notice] = "Archived Student Not found"
        end
    end
    
    def archived_additional_exam
 
       
       @student = ArchivedStudent.find(params[:student])
        @batch = @student.batch
      @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id])
      @subject =[]
      @additional_exam = @additional_exam_group.additional_exams
    @additional_exam_group.additional_exams.each do |subject|
      
       @subject << subject.subject.name
     end
    end
    
    def archived_additional_exam_pdf
 
       
       @student = ArchivedStudent.find(params[:student])
        @batch = @student.batch
      @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id])
      @subject =[]
      @additional_exam = @additional_exam_group.additional_exams
    @additional_exam_group.additional_exams.each do |subject|
      
       @subject << subject.subject.name
     end
    end

    def consolidated_exam_report
        @exam_group = ExamGroup.find(params[:exam_group])
    end

    def consolidated_exam_report_pdf
        @exam_group = ExamGroup.find(params[:exam_group])
        respond_to do |format|
            format.pdf { render :layout => false }
        end
    end
    
    def award_report
      unless params.include?("current_student")
        @student= ArchivedStudent.find_by_id(params[:student_id])
      else
        @student= Student.find_by_id(params[:student_id])
      end
        unless @student.nil?
          unless params.include?("current_student")
            @student_award = ArchivedStudentAward.find_all_by_student_id(@student.former_id)
            @batch_array = []
            @batche_array = []
            @student_award.each do |sa|
              @batch_array << sa.batch_id
            end
            @batch_array = @batch_array.uniq
            @batch_array.each do |b|
              @batche_array << Batch.find_by_id(b)
            end
          else
            @student_award = StudentAward.find_all_by_student_id(@student.id)
            @batch_array = []
            @batche_array = []
            @student_award.each do |sa|
              @batch_array << sa.batch_id
            end
            @batch_array = @batch_array.uniq
            @batch_array.each do |b|
              @batche_array << Batch.find_by_id(b)
            end
          end
      else
        redirect_to :controller => 'sessions', :action => 'dashboard'
        flash[:notice] = "Student not found"
      end
    end

    def academic_report
        @student = ArchivedStudent.find_by_id(params[:student])
        unless @student.nil?
        @batch = Batch.find_by_id(params[:year])
            unless @batch.nil?
                @type= params[:type]
                if params[:type] == 'grouped'
                    @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
                    @exam_groups = []
                    @grouped_exams.each do |x|
                        @exam_groups.push ExamGroup.find(x.exam_group_id)
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
            else
              redirect_to :controller => 'sessions', :action => 'dashboard'
              flash[:notice] = "Archived student not found for this batch"  
            end
        else
          redirect_to :controller => 'sessions', :action => 'dashboard'
          flash[:notice] = "Archived student not found"  
        end
    end
    def grouped_academic_report
      @student = ArchivedStudent.find_by_id(params[:student])
        unless @student.nil?
        @batch = Batch.find_by_id(params[:year])
            unless @batch.nil?
                @type= params[:type]
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
            else
              redirect_to :controller => 'sessions', :action => 'dashboard'
              flash[:notice] = "Archived student not found for this batch"  
            end
        else
          redirect_to :controller => 'sessions', :action => 'dashboard'
          flash[:notice] = "Archived student not found"  
        end
      
    end

    def student_report
        @config = SchoolConfiguration.find_by_config_key('StudentAttendanceType')
        @student = ArchivedStudent.find_by_id(params[:id])
        unless @student.nil?
            @batch = Batch.find_by_id(params[:year])
            unless @batch.nil?
                  @start_date = @batch.start_date.to_date
                  if @student.created_at.to_date > @batch.end_date.to_date
                      @end_date =  @batch.end_date.to_date
                  else
                      @end_date =  @student.created_at.to_date
                  end
                  @report = PeriodEntry.find_all_by_batch_id(@batch.id,  :conditions =>{:month_date => @start_date..@end_date})
            else
              redirect_to :controller => 'sessions', :action => 'dashboard'
              flash[:notice] = "Archived student report not found for this year"  
            end
        else
          redirect_to :controller => 'sessions', :action => 'dashboard'
          flash[:notice] = "Archived student report not found"  
        end
    end


    def generated_report
        if params[:student].nil?
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
                "/archived_student/graph_for_generated_report?batch=#{@student.batch.id}&examgroup=#{@exam_group.id}&student=#{@student.id}")
        else
            @exam_group = ExamGroup.find(params[:exam_group])
            @student = ArchivedStudent.find(params[:student])
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
            @graph = open_flash_chart_object(770, 350,
                "/archived_student/graph_for_generated_report?batch=#{@student.batch.id}&examgroup=#{@exam_group.id}&student=#{@student.id}")
        end
    end

    def generated_report_pdf
        @config = SchoolConfiguration.get_config_value('InstitutionName')
        @exam_group = ExamGroup.find(params[:exam_group])
        @student = ArchivedStudent.find(params[:student])
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
        render :pdf => 'generated_report_pdf',:layout => "layouts/pdf.html.erb",:header => {:html =>{:template=> 'layouts/pdf_header.html.erb'}},:footer => {:html => { :template=> 'layouts/pdf_footer.html.erb'}},:margin => {:top=> 40,
                    :bottom => 20,
                    :left=> 30,
                    :right => 30},:disposition  => "attachment"
          
        #    respond_to do |format|
        #      format.pdf { render :layout => false }
        #    end
    end

    def generated_report3
        #student-subject-wise-report
        @student = ArchivedStudent.find_by_id(params[:student])
        unless @student.nil?
        @batch = @student.batch
        @subject = Subject.find_by_id(params[:subject])
            unless @subject.nil?
              @exam_groups = ExamGroup.find(:all,:conditions=>{:batch_id=>@batch.id})
              @graph = open_flash_chart_object(770, 350,
                  "/archived_student/graph_for_generated_report3?subject=#{@subject.id}&student=#{@student.id}")
            else
              redirect_to :controller => 'sessions', :action => 'dashboard'
              flash[:notice] = "Archived student not found with this Subject"        
            end
        else
           redirect_to :controller => 'sessions', :action => 'dashboard'
           flash[:notice] = "Archived student not found"        
        end    
    end

    def previous_years_marks_overview
        @student = ArchivedStudent.find_by_id(params[:student])
        unless @student.nil?
        @all_batches = @student.all_batches
        @graph = open_flash_chart_object(770, 350,
            "/archived_student/graph_for_previous_years_marks_overview?student=#{params[:student]}&graphtype=#{params[:graphtype]}")
        else
         redirect_to :controller => 'sessions', :action => 'dashboard'
        flash[:notice] = "Archived student not found"        
        end
    
    end


    def generated_report4
        #grouped-exam-report-for-batch
        unless params[:student].nil?
            @student = ArchivedStudent.find_by_id(params[:student])
            unless @student.nil? 
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
                general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL AND is_deleted=false")
                student_electives = StudentsSubject.find_all_by_student_id(@student.former_id,:conditions=>"batch_id = #{@student.batch.id}")
                elective_subjects = []
                student_electives.each do |elect|
                    elective_subjects.push Subject.find(elect.subject_id)
                end
                @subjects = general_subjects + elective_subjects
            else
             redirect_to :controller => 'sessions', :action => 'dashboard'
            flash[:notice] = "Archived student not found"        
            end
        end

    end
    
     def generated_report5
        #grouped-exam-report-for-batch
        unless params[:student].nil?
            @student = ArchivedStudent.find_by_id(params[:student])
            unless @student.nil? 
                @batch = @student.batch
                @type  = params[:type]
                if params[:type] == 'grouped'
                  @grouped_exams = GroupedExam.find_by_id(params[:grouped])
                     @exam_groups = []
                    
                       greid =  ConnectExam.find_all_by_grouped_exam_id(@grouped_exams.id)
          greid.each do |g|
           
            @exam_groups << ExamGroup.find(g.exam_group_id)
         
                    end
                else
                    @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
                end
                general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL AND is_deleted=false")
                student_electives = StudentsSubject.find_all_by_student_id(@student.former_id,:conditions=>"batch_id = #{@student.batch.id}")
                elective_subjects = []
                student_electives.each do |elect|
                    elective_subjects.push Subject.find(elect.subject_id)
                end
                @subjects = general_subjects + elective_subjects
            else
             redirect_to :controller => 'sessions', :action => 'dashboard'
            flash[:notice] = "Archived student not found"        
            end
        end

    end


    
    def generated_report4_pdf

        #grouped-exam-report-for-batch
        unless params[:student].nil?
            @student = ArchivedStudent.find(params[:student])
            @batch = @student.batch
            @type  = params[:type]
            if params[:type] == 'grouped'
                @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
                @exam_groups = []
                @grouped_exams.each do |x|
                    @exam_groups.push ExamGroup.find(x.exam_group_id)
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
        ##    respond_to do |format|
        ##      format.pdf { render :layout => false }
        ##    end

    end


    #GRAPHS

    def graph_for_generated_report
        student = ArchivedStudent.find(params[:student])
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
        data = []
        data2 = []

        subjects.each do |s|
            exam = Exam.find_by_exam_group_id_and_subject_id(examgroup.id,s.id)
            res = ArchivedExamScore.find_by_exam_id_and_student_id(exam, student)
            unless res.nil?
                x_labels << s.code
                data << res.marks.to_f
                data2 << exam.class_average_marks.to_f
            end
        end
        bargraph = BarFilled.new()
        bargraph.width = 1;
        bargraph.colour = '#bb0000';
        bargraph.dot_size = 5;
        bargraph.text = "Student's marks"
        bargraph.values = data

        bargraph2 = BarFilled.new
        bargraph2.width = 1;
        bargraph2.colour = '#5E4725';
        bargraph2.dot_size = 5;
        bargraph2.text = "Class average"
        bargraph2.values = data2

        x_axis = XAxis.new
        x_axis.labels = x_labels

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

        render :text => chart.render
    end

    def graph_for_generated_report3
        student = ArchivedStudent.find params[:student]
        subject = Subject.find params[:subject]
        exams = Exam.find_all_by_subject_id(subject.id, :order => 'start_time asc')

        data = []
        x_labels = []

        exams.each do |e|
            exam_result = ArchivedExamScore.find_by_exam_id_and_student_id(e, student.id)
            unless exam_result.nil?
                data << exam_result.marks
                x_labels << XAxisLabel.new(exam_result.exam.exam_group.name, '#000000', 10, 0)
            end
        end

        x_axis = XAxis.new
        x_axis.labels = x_labels

        line = BarFilled.new

        line.width = 1
        line.colour = '#5E4725'
        line.dot_size = 5
        line.values = data

        y = YAxis.new
        y.set_range(0,100,20)

        title = Title.new(subject.name)

        x_legend = XLegend.new("Examination name")
        x_legend.set_style('{font-size: 14px; color: #778877}')

        y_legend = YLegend.new("Marks")
        y_legend.set_style('{font-size: 14px; color: #770077}')

        chart = OpenFlashChart.new
        chart.set_title(title)
        chart.set_x_legend(x_legend)
        chart.set_y_legend(y_legend)
        chart.y_axis = y
        chart.x_axis = x_axis

        chart.add_element(line)

        render :text => chart.to_s
    end


    def graph_for_previous_years_marks_overview
        student = ArchivedStudent.find(params[:student])

        x_labels = []
        data = []

        student.all_batches.each do |b|
            x_labels << b.name
            exam = ArchivedExamScore.new()
            data << exam.batch_wise_aggregate(student,b)
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


end
