# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  start_date  :datetime
#  end_date    :datetime
#  is_common   :boolean         default(FALSE)
#  is_holiday  :boolean         default(FALSE)
#  is_exam     :boolean         default(FALSE)
#  is_due      :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
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

class Event < ActiveRecord::Base
  # validates :title, :description, :start_date, :end_date
  # enoch - syntax change
  validates :title, :description, :start_date, :end_date, :presence => true
  scope :holidays, :conditions => {:is_holiday => true,:is_common => true}
  scope :exams, :conditions => {:is_exam => true}
  has_many :batch_events, :dependent => :destroy
  has_many :employee_department_events, :dependent => :destroy
  has_many :user_events, :dependent => :destroy
  belongs_to :origin , :polymorphic => true
  validate  :validate

   def validate
     unless self.start_date.nil? or self.end_date.nil?
       errors.add(:end_date, "can not be before the start date") if self.end_date < self.start_date
     end
   end
   
  def is_student_event(student)
    flag = false
    base = self.origin
    unless base.blank?
      if base.respond_to?('batch_id')
        if base.batch_id == student.batch_id
          finance = base.fee_table
          if finance.present?
            flag = true if finance.map{|fee|fee.student_id}.include?(student.id)
          end
        end
      end
    end
    user_events = self.user_events
    unless user_events.nil?
      flag = true if user_events.map{|x|x.user_id }.include?(student.user.id)
    end
    return flag
  end

  def is_user_event
   flag = false
    unless self.user_events.blank?
      flag = true
    else
      flag = false
    end
    return flag
  end

  def is_employee_event(employee)
    user_events = self.user_events
     unless user_events.blank?
       user_events.each do |d|
        return true if user_events.map{|x|x.user_id }.include?(employee.user.id)
       end
     end
    return false
  end

  def is_active_event
    flag = false
    unless self.origin.nil?
      if self.origin.respond_to?('is_deleted')
        unless self.origin.is_deleted
          flag = true
        end
      else
        flag = true
      end 
    else
      flag = true
    end
    return flag
  end
  
  class << self

    def is_a_holiday?(day)
      if Event.holidays.count(:all, :conditions => ["(start_date <= ? and end_date >= ?)",day,day]) > 0
        return true
      else 
        return false
      end
    end

   def is_a_batch_holiday?(day,batch)
      
      val = 0
       event = Event.find(:all,:conditions => ["(start_date <= ? AND end_date >= ? AND is_common = false AND is_holiday = true)",day,day])
         unless event.empty?
               event.each do |evn|
                  @batch_events =  evn.batch_events
                     unless @batch_events.empty?
                           @batch_events.each do |batch_evn|
                                   if batch_evn.batch_id == batch
                                     val = 1
                                   end 
                           end
                     end
               end
         end
               if val == 1
                 return true
               else
                 return false
               end

    end
end
end  

