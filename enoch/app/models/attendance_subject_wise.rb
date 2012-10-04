class AttendanceSubjectWise < ActiveRecord::Base
  belongs_to :subject
  belongs_to :student
  belongs_to :batch
  belongs_to :period_entry_subject_wise, :foreign_key => :period_table_entry_subject_wise_id
  validates_uniqueness_of :student_id, :scope => [:period_table_entry_subject_wise_id]
  # validates :reason,:presence => true
  # before_save :validate
  def validate
    errors.add("Attendance before the date of admission")  if self.period_entry.month_date < self.student.admission_date
  end
end
