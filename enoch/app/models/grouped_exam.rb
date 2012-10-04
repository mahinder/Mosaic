# == Schema Information
#
# Table name: grouped_exams
#
#  id            :integer         not null, primary key
#  exam_group_id :integer
#  batch_id      :integer
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

class GroupedExam < ActiveRecord::Base
  belongs_to :batch
  belongs_to :grading_level_group
  has_many :exam_groups
  has_many :connect_exams
  validates :grouped_exam_name,:presence=>true
  validates :grouped_exam_name,:uniqueness =>{:scope => [:batch_id],:case_sensitive => false }
  
  
end
