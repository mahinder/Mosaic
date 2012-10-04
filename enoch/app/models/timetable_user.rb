class TimetableUser < ActiveRecord::Base
  belongs_to  :user, :dependent=>:destroy,:autosave=>true
  validates_associated :user
  before_validation :create_user_and_validate
  def create_user_and_validate
   
    user_record = self.build_user
    user_record.first_name = self.first_name
    user_record.last_name = self.last_name
    user_record.username = "T0001"
    user_record.password = "password"#self.employee_number.to_s + "123"
    user_record.role = 'Timetable'
    user_record.email = "timetable@ezzie.in"
    check_user_errors(user_record)
   
  end
 def check_user_errors(user)
    unless user.valid?
      user.errors.each{|attr,msg| errors.add(attr.to_sym,"#{msg}")}
    end
    return false unless user.errors.blank?
    # enoch - change to return true
    return true
  end
end
