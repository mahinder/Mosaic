#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class AdditionalExamsController < ApplicationController
  before_filter :login_required
  before_filter :protect_other_student_data
  # before_filter :query_data
  filter_access_to :all

  def show
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    additional_exam_subject = Subject.find(@additional_exam.subject_id)

    @students = @additional_exam.additional_exam_group.students
    unless  additional_exam_subject.elective_group_id.nil?
      assigned_students_subject = StudentsSubject.find_all_by_subject_id(additional_exam_subject.id)
      assigned_students=       assigned_students_subject .map{|s| s.student}
      assigned_students_with_exam=assigned_students&@students
      @students= assigned_students_with_exam
    end
    @config = Configuration.get_config_value('ExamResultType') || 'Marks'

    @grades = @batch.grading_level_list
  end

  def edit
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    @subjects = @additional_exam_group.batch.subjects
  end

  def new
    @additional_exam = AdditionalExam.new
    @subjects = @batch.subjects
  end

 
  def create
   
    @additional_exam = @additional_exam_group.additional_exams.build(params[:additional_exam])
    if @additional_exam.save
      flash[:notice] = "New exam created successfully."
      redirect_to [@batch, @additional_exam_group]
    else
      @subjects = @batch.subjects
      render 'new'
    end
  end




  def destroy
    @additional_exam = AdditionalExam.find params[:id], :include => :additional_exam_group
    batch_id = @additional_exam.additional_exam_group.batch_id
    batch_event = BatchEvent.find_by_event_id_and_batch_id(@additional_exam.event_id,batch_id)
    event = Event.find(@additional_exam.event_id)
    if @additional_exam.destroy
      event.destroy
      batch_event.destroy
    end
    redirect_to [@batch, @additional_exam_group]
  end
  def generated_report
       
       @student = Student.find(params[:student])
        @batch = @student.batch
      @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id])
      @subject =[]
      @additional_exam = @additional_exam_group.additional_exams
    @additional_exam_group.additional_exams.each do |subject|
       @subject << subject.subject.name
     end
  end


  private
  def query_data
    @additional_exam_group = AdditionalExamGroup.find(params[:additional_exam_group_id], :include => :batch)
    @batch = @additional_exam_group.batch
    @course = @batch.course
  end




end
