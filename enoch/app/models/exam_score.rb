# == Schema Information
#
# Table name: exam_scores
#
#  id               :integer         not null, primary key
#  student_id       :integer
#  exam_id          :integer
#  marks            :decimal(7, 2)
#  grading_level_id :integer
#  remarks          :string(255)
#  is_failed        :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

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

class ExamScore < ActiveRecord::Base
  acts_as_audited
  belongs_to :student
  belongs_to :exam
  belongs_to :grading_level_detail

   before_save :calculate_grade

  def calculate_percentage
    percentage = self.marks.to_i * 100 / self.exam.maximum_marks
  end

  def grouped_exam_subject_total(subject,student,type,batch = "")
    if batch == ""
      batch = student.batch.id
    end
    if type == 'grouped'
      grouped_exams = GroupedExam.find_all_by_batch_id(batch)
      exam_groups = []
      grouped_exams.each do |x|
        greid =  ConnectExam.find_by_grouped_exam_id(x.id)
        # eg = ExamGroup.find(greid.exam_group_id)
        exam_groups.push ExamGroup.find(greid.exam_group_id)
      end
    else
      exam_groups = ExamGroup.find_all_by_batch_id(batch)
    end
    total_marks = 0
    exam_groups.each do |exam_group|
      unless exam_group.exam_type == 'Grades'
        exam = Exam.find_by_subject_id_and_exam_group_id(subject.id,exam_group.id)
        unless exam.nil?
          exam_score = ExamScore.find_by_student_id(student.id, :conditions=>{:exam_id=>exam.id})
          total_marks = total_marks+(exam_score.marks || 0 ) unless exam_score.nil?
        end
      end
    end
    total_marks
  end

  

  def batch_wise_aggregate(student,batch)
    check = ExamGroup.find_all_by_batch_id(batch.id)
    var = []
    check.each do |x|
      if x.exam_type == 'Grades'
        var << 1
      end
    end
    if var.empty?
      grouped_exam = GroupedExam.find_all_by_batch_id(batch.id)
       exam_groups = ExamGroup.find_all_by_batch_id(batch.id)
      exam_groups.size
      max_total = 0
      marks_total = 0
      actual_percent = 0
      normal_max = 0
      normal_max_total =0
      actual_percentage = 0
      actual_percentages = 0
      exam_groups.each do |exam_group|
                     normal_max += exam_group.total_marks(student)[1]
                     normal_max_total += exam_group.total_marks(student)[0]
               end 
               
                unless normal_max_total==0
                  aggr = normal_max_total*100/normal_max
                  end
    else
      aggr = 'nil'
    end
    
  end

  private
  def calculate_grade
  
    exam = self.exam
    exam_group = exam.exam_group
    exam_type = exam_group.exam_type
    unless exam_type == 'Grades'
      unless self.marks.nil?
        percent_score = self.marks.to_i * 100 /exam.maximum_marks
        unless exam_group.grading_level_group.nil?
        grade = GradingLevelDetail.percentage_to_grade(percent_score, exam_group.grading_level_group.id)
        else
           grade = GradingLevelDetail.percentage_to_grade(percent_score, 1)
        end
        self.grading_level_detail_id = grade.id if exam_type == 'MarksAndGrades'
      else
        self.grading_level_detail_id = nil
      end
    end
  end
  def calculate_pass
    exam = self.exam
    exam_group = exam.exam_group
    exam_type = exam_group.exam_type
    unless exam_type=='Grades' || exam_type=='Custom'
      if self.marks < exam.minimum_marks
    self.is_failed=true
  end
  end
 end
end
