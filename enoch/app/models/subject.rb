# == Schema Information
#
# Table name: subjects
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  code               :string(255)
#  batch_id           :integer
#  no_exams           :boolean         default(FALSE)
#  max_weekly_classes :integer
#  elective_group_id  :integer
#  is_deleted         :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
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

class Subject < ActiveRecord::Base

  belongs_to :batch
  belongs_to :class_timing
  has_many :topics
  # belongs_to :elective_group , :class_name => "ElectiveSkill"
  belongs_to :elective_group
  has_many :timetable_entries,:foreign_key=>'subject_id'
  has_many :employees_subjects
  has_many :employees ,:through => :employees_subjects
  has_many :rooms_subjects
  has_many :exams
  has_many :rooms ,:through => :rooms_subjects
  has_one :skill
  belongs_to :skill
  belongs_to  :class_timing
  belongs_to  :employee
  #validates :name, :max_weekly_classes, :code,:batch_id
  #enoch - Syntax change
  validates :name, :max_weekly_classes, :code, :batch_id, :presence => true
  validates_numericality_of :max_weekly_classes
  validates_uniqueness_of :code, :scope => :batch_id
  
  scope :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i, :is_deleted => false } } }
  scope :without_exams, :conditions => { :no_exams => false, :is_deleted => false }

  def inactivate
    update_attribute(:is_deleted, true)
  end

end
