# == Schema Information
#
# Table name: exams
#
#  id               :integer         not null, primary key
#  exam_group_id    :integer
#  subject_id       :integer
#  start_time       :datetime
#  end_time         :datetime
#  maximum_marks    :decimal(, )
#  minimum_marks    :decimal(, )
#  grading_level_id :integer
#  weightage        :integer         default(0)
#  event_id         :integer
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

class Exam < ActiveRecord::Base
  #validates :start_time
  # validates :end_time
  # enoch - syntax changes

  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :maximum_marks, :presence => true, :allow_nil=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ }
  validates :minimum_marks, :presence => true, :allow_nil=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ }
  belongs_to :exam_group
  belongs_to :topic
  belongs_to :subject, :conditions => { :is_deleted => false }
  before_destroy :removable?
  before_save :update_exam_group_date, :weight, :updateexam,:exam_group_type
  belongs_to :event
  has_many :exam_scores
  has_many :archived_exam_scores

  accepts_nested_attributes_for :exam_scores
  # enoch - for validating  validate method  
   validate :validate
  def removable?
    self.exam_scores.reject{|es| es.marks.nil? and es.grading_level_detail_id.nil?}.empty?
  end

  def validate
   
    errors.add(:Minimum_marks," can't be more than max marks.") \
    if minimum_marks and maximum_marks and minimum_marks > maximum_marks
    unless self.start_time.nil? or self.end_time.nil?
      errors.add(:end_time,"can not be before the start time")if self.end_time < self.start_time
      errors.add(:end_time,"can not be equal to the start time")if self.end_time == self.start_time
    end
    
    
 unless self.minimum_marks.nil? or self.maximum_marks.nil?
    errors.add(:Minimum_marks,"invalid marks entry")if self.minimum_marks>100
    errors.add(:Maximum_marks,"invalid marks entry")if self.maximum_marks>100
  end
     end

  # before_save
  # enoch - syntax error
  def weight
    
    self.weightage = 0 if self.weightage.nil?
  #update_exam_group_date
  end
  

  def updateexam
    update_exam_event
  end
 

  def score_for(student_id)
    exam_score = self.exam_scores.find(:first, :conditions => { :student_id => student_id })
    exam_score.nil? ? ExamScore.new : exam_score
  end

  def class_average_marks
    results = ExamScore.find_all_by_exam_id(self)
    scores = results.collect { |x| x.marks unless x.marks.nil?}
    scores.delete(nil)
    return (scores.sum / scores.size) unless scores.size == 0
    return 0
  end
  def exam_group_type

  end

  private

  def update_exam_group_date
    group = self.exam_group
    group.update_attribute(:exam_date, self.start_time.to_date) if !group.exam_date.nil? and self.start_time.to_date < group.exam_date

  end

  def update_exam_event
    if self.event.nil?
      new_event = Event.create do |e|
        e.title       = "Exam"
        e.description = "#{self.exam_group.name} for #{self.subject.batch.full_name} - #{self.subject.name}"
        e.start_date  = self.start_time
        e.end_date    = self.end_time
        e.is_exam     = true
      end
      batch_event = BatchEvent.create do |be|
        be.event_id = new_event.id
        be.batch_id = self.exam_group.batch_id
      end
      #self.event_id = new_event.id
      self.update_attributes(:event_id=>new_event.id)
    else
      self.event.update_attributes(:start_date => self.start_time, :end_date => self.end_time)
    end
  end

end
