class TeacherDiary < ActiveRecord::Base
  belongs_to :employee
  validates :text_date, :school_session_id ,:employee_id, :presence => true
end
