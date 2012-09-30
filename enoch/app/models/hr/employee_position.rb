# == Schema Information
#
# Table name: employee_positions
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  employee_category_id :integer
#  status               :boolean
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

class EmployeePosition < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :employee_category_id, :presence => true
  validates :name, :uniqueness => {:scope=>:employee_category_id}
  scope :active, :conditions => {:status => true }

  #named_scope :active, :conditions => {:status => true }

  belongs_to :employee_category
  has_many :employee

end
