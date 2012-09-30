# == Schema Information
#
# Table name: archived_employees
#
#  id                     :integer         not null, primary key
#  employee_category_id   :integer
#  employee_number        :string(255)
#  joining_date           :date
#  first_name             :string(255)
#  middle_name            :string(255)
#  last_name              :string(255)
#  gender                 :boolean
#  job_title              :string(255)
#  employee_position_id   :integer
#  employee_department_id :integer
#  reporting_manager_id   :integer
#  employee_grade_id      :integer
#  qualification          :string(255)
#  experience_detail      :text
#  experience_year        :integer
#  experience_month       :integer
#  status                 :boolean
#  status_description     :string(255)
#  date_of_birth          :date
#  marital_status         :string(255)
#  children_count         :integer
#  father_name            :string(255)
#  mother_name            :string(255)
#  husband_name           :string(255)
#  blood_group            :string(255)
#  nationality_id         :integer
#  home_address_line1     :string(255)
#  home_address_line2     :string(255)
#  home_city              :string(255)
#  home_state             :string(255)
#  home_country_id        :integer
#  home_pin_code          :string(255)
#  office_address_line1   :string(255)
#  office_address_line2   :string(255)
#  office_city            :string(255)
#  office_state           :string(255)
#  office_country_id      :integer
#  office_pin_code        :string(255)
#  office_phone1          :string(255)
#  office_phone2          :string(255)
#  mobile_phone           :string(255)
#  home_phone             :string(255)
#  email                  :string(255)
#  fax                    :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_data             :binary(5242880)
#  created_at             :datetime
#  updated_at             :datetime
#  photo_file_size        :integer
#  former_id              :string(255)
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

class ArchivedEmployee < ActiveRecord::Base
  belongs_to  :employee_category
  belongs_to  :employee_position
  belongs_to  :employee_grade
  belongs_to  :employee_department
  belongs_to  :nationality, :class_name => 'Country'
  has_many    :archived_employee_bank_details
  has_many    :archived_employee_additional_details
  has_many    :archived_employee_salary_structures
has_attached_file :employee_photo,:styles => {
    :small=> "50x50#",
    :large  => "500x500>"},
    :url => "/system/:class/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:id/:style/:basename.:extension"

  def image_file=(input_data)
    return if input_data.blank?
    self.employee_photo_filename     = input_data.original_filename
    self.employee_photo_content_type = input_data.content_type.chomp
    self.employee_photo_data         = input_data.read
  end


   
   def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

end
