# == Schema Information
#
# Table name: elective_groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  batch_id   :integer
#  is_deleted :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
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

class ElectiveGroup < ActiveRecord::Base
  belongs_to :batch
  has_many :subjects

  #validates :name,:batch_id
  #enoch - change in syntax for presence
  validates :name, :batch_id, :presence => true
  
  scope :for_batch, lambda { |b| { :conditions => { :batch_id => b, :is_deleted => false } } }

  def inactivate
    update_attribute(:is_deleted, true)
  end
end
