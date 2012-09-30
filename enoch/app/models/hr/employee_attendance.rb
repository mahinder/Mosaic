# == Schema Information
#
# Table name: employee_attendances
#
#  id                     :integer         not null, primary key
#  attendance_date        :date
#  employee_id            :integer
#  employee_leave_type_id :integer
#  reason                 :string(255)
#  is_half_day            :boolean
#


class EmployeeAttendance < ActiveRecord::Base
  validates :employee_leave_type_id, :reason, :presence => true
  validates_uniqueness_of :employee_id, :scope=> :attendance_date
  belongs_to :employee
  belongs_to :employee_leave_type
  before_save :validate

  def validate
     if self.attendance_date.to_date < self.employee.joining_date.to_date
     errors.add(:employee_attendance,"Date marked is earlier than joining date ")
    end
  end
  
end
